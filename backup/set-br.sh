#!/bin/bash

# Ambil tanggal dari server Google
serverDate=$(curl -sI --insecure https://google.com | grep -i ^Date: | sed 's/Date: //')
formattedDate=$(date -d "$serverDate" +"%Y-%m-%d")

# Export Banner Status Information
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
NC='\e[0m'

export EROR="[${RED} EROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"

clear
sleep 1
echo -e "[ ${GREEN}INFO${NC} ] Checking..."
sleep 2

# Install rclone
echo -e "[ ${GREEN}INFO${NC} ] Download & Install rclone..."
curl -fsSL https://rclone.org/install.sh | bash > /dev/null 2>&1

# Setup rclone config
printf "q\n" | rclone config > /dev/null 2>&1

# Buat direktori konfigurasi jika belum ada
mkdir -p /root/.config/rclone

echo -e "[ ${GREEN}INFO${NC} ] Downloading rclone config..."
wget -q -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/Panwas89/asu/main/backup/rclone.conf"

# Install wondershaper
echo -e "[ ${GREEN}INFO${NC} ] Cloning wondershaper..."
git clone https://github.com/magnific0/wondershaper.git &> /dev/null
cd wondershaper || exit 1
echo -e "[ ${GREEN}INFO${NC} ] Installing wondershaper..."
make install > /dev/null 2>&1
cd ..
rm -rf wondershaper

# Buat file kosong
: > /home/limit

# Install dependensi
pkgs='msmtp-mta ca-certificates bsd-mailx'
if ! dpkg -s $pkgs > /dev/null 2>&1; then
    echo -e "[ ${GREEN}INFO${NC} ] Installing dependencies..."
    apt install -y $pkgs > /dev/null 2>&1
else
    echo -e "[ ${GREEN}INFO${NC} ] Dependencies already installed..."
fi

# Download skrip tambahan
echo -e "[ ${GREEN}INFO${NC} ] Downloading scripts..."
wget -q -O /usr/bin/backup "https://raw.githubusercontent.com/Panwas89/asu/main/backup/backup.sh" && chmod +x /usr/bin/backup
wget -q -O /usr/bin/restore "https://raw.githubusercontent.com/Panwas89/asu/main/backup/restore.sh" && chmod +x /usr/bin/restore
wget -q -O /usr/bin/menu-bckp "https://raw.githubusercontent.com/Panwas89/asu/main/menu/menu-bckp.sh" && chmod +x /usr/bin/menu-bckp

# Restart cron service
service cron restart > /dev/null 2>&1

# Hapus skrip ini setelah selesai
rm -f /root/set-br.sh
