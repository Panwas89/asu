#!/bin/bash
# Cleaned & Improved SSH-VPN Installer Script
# Author: RosiVPN (modified)
# ===============================================

set -euo pipefail

# Configuration
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip)
NET=$(ip -o -4 route show to default | awk '{print $5}')
source /etc/os-release
ver=$VERSION_ID

# Company Details
country=ID
state=Indonesia
locality=Indonesia
organization=aryavpn
organizationalunit=aryavpn
commonname=aryavpn
email=setyaaries9@gmail.com

# Setup rc.local
cat > /etc/systemd/system/rc-local.service <<-EOF
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/rc.local <<-EOF
#!/bin/sh -e
# rc.local
exit 0
EOF

chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local.service

# Disable IPv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
grep -q 'disable_ipv6' /etc/rc.local || echo 'echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' >> /etc/rc.local

# System update
apt update -y && apt upgrade -y && apt dist-upgrade -y
apt-get remove --purge -y ufw firewalld exim4

# Install essentials
apt install -y jq shc wget curl figlet ruby screen net-tools iptables-persistent fail2ban
gem install lolcat
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# Configure SSH ports
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
for port in 22 200 500 51443 58080 40000; do
  grep -q "Port $port" /etc/ssh/sshd_config || echo "Port $port" >> /etc/ssh/sshd_config
done

# Restart SSH
systemctl restart ssh

# Install Dropbear
apt install -y dropbear
sed -i 's/NO_START=1/NO_START=0/' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/' /etc/default/dropbear
echo 'DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110 -p 69"' >> /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
systemctl restart dropbear

# Install Nginx
apt install -y nginx
rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/Panwas89/asu/main/ssh/nginx.conf"
mkdir -p /home/vps/public_html
systemctl restart nginx

# Install BadVPN
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/Panwas89/asu/main/ssh/newudpgw"
chmod +x /usr/bin/badvpn-udpgw
for port in {7100..7900..100}; do
  echo "screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:$port --max-clients 500" >> /etc/rc.local
  screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:$port --max-clients 500
done

# Install and configure Stunnel
apt install -y stunnel4
cat > /etc/stunnel/stunnel.conf <<-EOF
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
[ssh]
accept = 445
connect = 127.0.0.1:22
[dropbear]
accept = 777
connect = 127.0.0.1:109
[openvpn]
accept = 442
connect = 127.0.0.1:1194
EOF

openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem > /etc/stunnel/stunnel.pem
sed -i 's/ENABLED=0/ENABLED=1/' /etc/default/stunnel4
systemctl restart stunnel4
rm -f key.pem cert.pem

# Block torrent traffic
TORRENT_STRINGS=("get_peers" "announce_peer" "find_node" "BitTorrent" "BitTorrent protocol" "peer_id=" ".torrent" "announce.php?passkey=" "torrent" "announce" "info_hash")
for string in "${TORRENT_STRINGS[@]}"; do
  iptables -A FORWARD -m string --algo bm --string "$string" -j DROP
done
iptables-save > /etc/iptables.up.rules
iptables-restore < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# Install DDoS Deflate
if [ ! -d /usr/local/ddos ]; then
  mkdir /usr/local/ddos
  wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
  chmod 0755 /usr/local/ddos/ddos.sh
  ln -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
  /usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
fi

# Setup cron jobs
cat > /etc/cron.d/re_otm <<-EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 2 * * * root /sbin/reboot
EOF

cat > /etc/cron.d/xp_otm <<-EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 0 * * * root /usr/bin/xp
EOF

echo 7 > /home/re_otm
systemctl restart cron

# Cleanup
apt autoclean -y
apt autoremove -y

# Set permissions
chown -R www-data:www-data /home/vps/public_html

# Restart all services
for svc in nginx openvpn ssh dropbear fail2ban stunnel4 vnstat squid; do
  systemctl restart "$svc" || true
done

# Finalize
history -c
echo "unset HISTFILE" >> /etc/profile
clear
echo "Installation Complete."
