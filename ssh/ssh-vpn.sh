#!/bin/bash
# Updated and secured version of ssh-vpn.sh for Ubuntu 22.04
# By: ChatGPT with user request

set -e

export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip)
NET=$(ip -o -4 route show to default | awk '{print $5}')

# Set time zone
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Update & Install Essentials
apt update -y && apt upgrade -y
apt install -y wget curl jq screen figlet lolcat stunnel4 fail2ban netfilter-persistent iptables-persistent nginx dropbear

# Set SSH Configuration
sed -i 's/^#Port 22/Port 22\nPort 2222/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^AcceptEnv/#AcceptEnv/' /etc/ssh/sshd_config

echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
wget -q -O /etc/issue.net "https://raw.githubusercontent.com/Panwas89/asu/main/ssh/issue.net" || echo "Welcome to Secure Server" > /etc/issue.net
chmod +x /etc/issue.net

systemctl restart ssh

# Configure Dropbear
sed -i 's/NO_START=1/NO_START=0/' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells

echo 'DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110 -p 69"' >> /etc/default/dropbear
systemctl enable dropbear
systemctl restart dropbear

# Configure Stunnel
cat > /etc/stunnel/stunnel.conf <<EOF
cert = /etc/stunnel/stunnel.pem
client = no

[ssh]
accept = 443
connect = 127.0.0.1:22
EOF

openssl req -new -x509 -days 1095 -nodes -out /etc/stunnel/stunnel.pem -keyout /etc/stunnel/stunnel.pem \
-subj "/C=ID/ST=Indonesia/L=Indonesia/O=aryavpn/OU=aryavpn/CN=aryavpn/emailAddress=setyaaries9@gmail.com"

sed -i 's/ENABLED=0/ENABLED=1/' /etc/default/stunnel4
systemctl enable stunnel4
systemctl restart stunnel4

# BadVPN via systemd
cat > /etc/systemd/system/badvpn.service <<EOF
[Unit]
Description=BadVPN UDPGW Service
After=network.target

[Service]
ExecStart=/usr/bin/badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
Restart=always

[Install]
WantedBy=multi-user.target
EOF

chmod +x /usr/bin/badvpn-udpgw
systemctl daemon-reexec
systemctl enable badvpn
systemctl start badvpn

# Disable IPv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf

# Block Torrent
iptables -A FORWARD -m string --string "BitTorrent" --algo bm -j DROP
iptables-save > /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# Configure Fail2Ban
systemctl enable fail2ban
systemctl restart fail2ban

# Setup Cron Job for Reboot & User Expiration (Optional)
echo "0 2 * * * root /sbin/reboot" > /etc/cron.d/re_otm
echo "0 0 * * * root /usr/bin/xp" > /etc/cron.d/xp_otm

# Restart Services
systemctl restart ssh dropbear stunnel4 nginx fail2ban

# Cleanup
apt autoclean -y

clear
echo "====================================="
echo "  SSH & VPN Server Setup Complete  "
echo "     IP: $MYIP on Ubuntu 22.04       "
echo "====================================="
