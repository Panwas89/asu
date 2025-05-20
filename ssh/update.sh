#!/bin/bash
CYAN='\e[0;36m'
GREEN='\e[0;32m'
NC='\e[0;37m'
clear
echo -e "${GREEN}"
echo -e " [INFO] Downloading Update File "
sleep 2
cd /usr/bin
rm -rf menu
rm -rf menu-ssh
rm -rf menu-vmess
rm -rf menu-vless
rm -rf menu-trojan
rm -rf menu-trial
clear
echo -e " [INFO]AMBIL FILE DULU SAYANK..."
sleep 2
wget -q -O /usr/bin/menu "https://raw.githubusercontent.com/Panwas89/asu/main/menu/menu.sh" && chmod +x /usr/bin/menu
wget -q -O /usr/bin/menu-trial "https://raw.githubusercontent.com/Panwas89/asu/main/menu/menu-trial.sh" && chmod +x /usr/bin/menu-trial
wget -q -O /usr/bin/menu-vmess "https://raw.githubusercontent.com/Panwas89/asu/main/menu/menu-vmess.sh" && chmod +x /usr/bin/menu-vmess
wget -q -O /usr/bin/menu-vless "https://raw.githubusercontent.com/Panwas89/asu/main/menu/menu-vless.sh" && chmod +x /usr/bin/menu-vless
wget -q -O /usr/bin/menu-trojan "https://raw.githubusercontent.com/Panwas89/asu/main/menu/menu-trojan.sh" && chmod +x /usr/bin/menu-trojan
wget -q -O /usr/bin/menu-ssh "https://raw.githubusercontent.com/Panwas89/asu/main/menu/menu-ssh.sh" && chmod +x /usr/bin/menu-ssh
wget -q -O /usr/bin/menu-set "https://raw.githubusercontent.com/Panwas89/asu/main/menu/menu-set.sh" && chmod +x /usr/bin/menu-set


chmod +x menu
chmod +x menu-ssh
chmod +x menu-vmess
chmod +x menu-vless
chmod +x menu-trojan
chmod +x menu-set
chmod +x menu-trial

echo -e "${NC}"
echo -e "${GREEN} [INFO] ${NC}Update Sukses Sayank..!!"
sleep 2
menu
