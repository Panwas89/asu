#!/bin/bash
# =========================================

clear
clear
vlx=$(grep -c -E "^#& " "/etc/xray/config.json")
let vla=$vlx/2
vmc=$(grep -c -E "^### " "/etc/xray/config.json")
let vma=$vmc/2
ssh1="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"

trx=$(grep -c -E "^#! " "/etc/xray/config.json")
let tra=$trx/2
ssx=$(grep -c -E "^## " "/etc/xray/config.json")
let ssa=$ssx/2
#UDPX="https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1S3IE25v_fyUfCLslnujFBSBMNunDHDk2' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1S3IE25v_fyUfCLslnujFBSBMNunDHDk2"
BIYellow='\033[0;33m'
NC='\033[0;37m'
BICyan='\033[0;34m'
WT='\033[0;37m'
GREEN='\033[0;32m'
PURPLE='\033[0;33m'
RED='\033[0;31m'
green='\033[0;32m'
red='\033[0;31m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
ORANGE='\033[0;33m'
#Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"
clear

# // Exporting Language to UTF-8

export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'


# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export EROR="[${RED} EROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"

# // Clear
clear
clear && clear && clear
clear;clear;clear
cek=$(service ssh status | grep active | cut -d ' ' -f5)
if [ "$cek" = "active" ]; then
stat=-f5
else
stat=-f7
fi
ssh=$(service ssh status | grep active | cut -d ' ' $stat)
if [ "$ssh" = "active" ]; then
ressh="${green}ON${NC}"
else
ressh="${red}OFF${NC}"
fi
sshstunel=$(service stunnel4 status | grep active | cut -d ' ' $stat)
if [ "$sshstunel" = "active" ]; then
resst="${green}ON${NC}"
else
resst="${red}OFF${NC}"
fi
sshws=$(service ws-stunnel status | grep active | cut -d ' ' $stat)
if [ "$sshws" = "active" ]; then
ressshws="${green}ON${NC}"
else
ressshws="${red}OFF${NC}"
fi
ngx=$(service nginx status | grep active | cut -d ' ' $stat)
if [ "$ngx" = "active" ]; then
resngx="${green}ON${NC}"
else
resngx="${red}OFF${NC}"
fi
dbr=$(service dropbear status | grep active | cut -d ' ' $stat)
if [ "$dbr" = "active" ]; then
resdbr="${green}ON${NC}"
else
resdbr="${red}OFF${NC}"
fi
v2r=$(service xray status | grep active | cut -d ' ' $stat)
if [ "$v2r" = "active" ]; then
resv2r="${green}ON${NC}"
else
resv2r="${red}OFF${NC}"
fi
function addhost(){
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -rp "Domain/Host: " -e host
echo ""
if [ -z $host ]; then
echo "????"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
setting-menu
else
echo "IP=$host" > /var/lib/SIJA/ipvps.conf
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo "Dont forget to renew cert"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
fi
}
function genssl(){
clear
systemctl stop nginx
domain=$(cat /var/lib/SIJA/ipvps.conf | cut -d'=' -f2)
Cek=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
if [[ ! -z "$Cek" ]]; then
sleep 1
echo -e "[ ${red}WARNING${NC} ] Detected port 80 used by $Cek " 
systemctl stop $Cek
sleep 2
echo -e "[ ${green}INFO${NC} ] Processing to stop $Cek " 
sleep 1
fi
echo -e "[ ${green}INFO${NC} ] Starting renew cert... " 
sleep 2
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
echo -e "[ ${green}INFO${NC} ] Renew cert done... " 
sleep 2
echo -e "[ ${green}INFO${NC} ] Starting service $Cek " 
sleep 2
echo $domain > /etc/xray/domain
systemctl restart xray
systemctl restart nginx
echo -e "[ ${green}INFO${NC} ] All finished... " 
sleep 0.5
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
# TOTAL RAM
total_ram=` grep "MemTotal: " /proc/meminfo | awk '{ print $2}'`
totalram=$(($total_ram/1024))
# GETTING DOMAIN NAME
Domen="$(cat /etc/xray/domain)"
#Slow="$(cat /root/nsdomain)"
uphours=`uptime -p | awk '{print $2,$3}' | cut -d , -f1`
upminutes=`uptime -p | awk '{print $4,$5}' | cut -d , -f1`
uptimecek=`uptime -p | awk '{print $6,$7}' | cut -d , -f1`
cekup=`uptime -p | grep -ow "day"`
IPVPS=$(curl -s ipinfo.io/ip )
ISPVPS=$( curl -s ipinfo.io/org )
RAM=$(free -m | awk 'NR==2 {print $2}')
#USAGERAM=$(free -m | awk 'NR==2 {print $3}')
MEMOFREE=$(printf '%-1s' "$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')")
LOADCPU=$(printf '%-0.00001s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")
MODEL=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')
CORE=$(printf '%-1s' "$(grep -c cpu[0-9] /proc/stat)")
DATEVPS=$(date +'%d/%m/%Y')
TIMEZONE=$(printf '%(%H:%M:%S)T')
#SERONLINE=$(uptime -p | cut -d " " -f 2-10000)
clear
echo -e ""
echo -e ""
echo -e ""
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "${BICyan} │                  ${BIPurple}${NC}INFO SERVER VPS${NC}"     
echo -e "${BICyan} │"
echo -e " ${BICyan}│  ${WT} Hostname     :${BIYellow} $HOSTNAME"
echo -e " ${BICyan}│  ${WT} Public IP    :${BIYellow} $IPVPS"
echo -e " ${BICyan}│  ${WT} Domain       : ${BIYellow}$Domen"
echo -e " ${BICyan}│  ${WT} ISP          : ${BIYellow}$ISPVPS"
echo -e " ${BICyan}│  ${WT} Total RAM    : ${BIYellow}${totalram}MB"
echo -e " ${BICyan}│  ${WT} Usage Memory : ${BIYellow}$MEMOFREE${NC}"
echo -e " ${BICyan}│  ${WT} LoadCPU      : ${BIYellow}$LOADCPU%${NC}"
echo -e " ${BICyan}│  ${WT} Core System  : ${BIYellow}$CORE${NC}"
echo -e " ${BICyan}│  ${WT} Waktu Aktif  : ${BIYellow}$uphours $upminutes $uptimecek"
echo -e " ${BICyan}│  ${WT} System OS    : ${BIYellow}$MODEL${NC}"
echo -e " ${BICyan}│  ${WT} Date         :${BIYellow} $DATEVPS${NC}"
echo -e " ${BICyan}│  ${WT} Time         : ${BIYellow}$TIMEZONE${NC}"
echo -e " ${BICyan}└─────────────────────────────────────────────────────┘${NC}"
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "     ${BICyan}[${GREEN}01${BICyan}] ${WT}SSHWS    ${BICyan}[${BIYellow}Menu${BICyan}]${NC}"    "     ${BICyan}[${GREEN}07${BICyan}] ${WT}BACKUP  ${NC} "
echo -e "     ${BICyan}[${GREEN}02${BICyan}] ${WT}VMESS    ${BICyan}[${BIYellow}Menu${BICyan}]${NC}" "     ${BICyan}[${GREEN}08${BICyan}] ${WT}ADD-HOST  ${NC}"
echo -e "     ${BICyan}[${GREEN}03${BICyan}] ${WT}VLESS    ${BICyan}[${BIYellow}Menu${BICyan}]${NC}"  "     ${BICyan}[${GREEN}09${BICyan}] ${WT}CERT SSL     ${NC}"
echo -e "     ${BICyan}[${GREEN}04${BICyan}] ${WT}TROJANWS ${BICyan}[${BIYellow}Menu${BICyan}]${NC}" "     ${BICyan}[${GREEN}10${BICyan}]${WT} INSTAL UDP         "
echo -e "     ${BICyan}[${GREEN}05${BICyan}] ${WT}TROJANGO ${BICyan}[${BIYellow}Menu${BICyan}]${NC}"  "     ${BICyan}[${GREEN}11${BICyan}] ${WT}UPDATE MENU ${NC}"
echo -e "     ${BICyan}[${GREEN}06${BICyan}] ${WT}SETING   ${BICyan}[${BIYellow}Menu${BICyan}]${NC}"  "     ${BICyan}[${GREEN}12${BICyan}] ${WT}INFO VPS ${NC}"

echo -e " ${BICyan}└─────────────────────────────────────────────────────┘${NC}"
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "${BICyan} │  \033[0m ${BOLD}${GREEN}   ${WT} SSH${GREEN}       ${WT}VMESS  ${GREEN}     ${WT}VLESS  ${GREEN}     ${WT}TROJAN${GREEN}     $NC "
echo -e "${BICyan} │  \033[0m ${Blue}     $ssh1          $vma           $vla           $tra              $NC"
echo -e "${BICyan} └─────────────────────────────────────────────────────┘${NC}"
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "    ${WT} SSH ${RED}: $ressh"" ${WT} NGINX ${RED}: $resngx"" ${WT}  XRAY ${RED}: $resv2r"" ${WT} TROJAN ${RED}: $resv2r"
echo -e "  ${WT}     STUNNEL ${RED}: $resst" "${WT} DROPBEAR ${RED}: $resdbr" "${WT} SSH-WS ${RED}: $ressshws"
echo -e " ${BICyan}└─────────────────────────────────────────────────────┘${NC}"
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "${BICyan} │$NC ${WT}HARI INI${NC}: ${ORANGE}$ttoday$NC ${WT}KEMARIN${NC}: ${ORANGE}$tyest$NC ${WT}BULAN${NC}: ${ORANGE}$tmon$NC $NC"
echo -e "${BICyan} └─────────────────────────────────────────────────────┘${NC}"
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "${GREEN}  ${RED}▁ ${CYAN}▂ ${GREEN}▄ ${ORANGE}▅${PINK} ▆${GREEN} ▇ ${RED}█${BLUE}𒆜${CYAN} ༻${NC}  SCRIPT ARYA BLITAR ${BLUE}༺ ${RED}𒆜${GREEN}█ ${ORANGE}▇ ${CYAN}▆ ${RED}▅ ${GREEN}▄ ${ORANGE}▂ ${PINK}▁\E[0m"
echo -e "${BICyan} └─────────────────────────────────────────────────────┘${NC}"
DATE=$(date +'%d %B %Y')
datediff() {
d1=$(date -d "$1" +%s)
d2=$(date -d "$2" +%s)
echo -e " ${BICyan}│${ICyan}  Expiry In     : ${NC}$(( (d1 - d2) / 86400 )) ${ORANGE}Days $NC"
}
mai="datediff "$Exp" "$DATE""
echo -e " ${BICyan}┌─────────────────────────────────────────────────────┐${NC}"
echo -e " ${BICyan}│ ${ICyan} Version       : ${NC} GRATIS 2024 ${NC}"
echo -e " ${BICyan}└─────────────────────────────────────────────────────┘${NC}"
echo
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; menu-ssh ;;
2) clear ; menu-vmess ;;
3) clear ; menu-vless ;;
4) clear ; menu-trojan ;;
5) clear ; trojaan ;;
6) clear ; menu-set ;;
7) clear ; menu-backup ;;
8) clear ; add-host ;;
9) clear ; certv2ray ;;
10) clear ; clear ; wget https://raw.githubusercontent.com/Jatimpark/udp/main/custom.sh && chmod +x custom.sh && ./custom.sh && reboot ;;
11) clear ; update ;;
12) clear ; gotop ;;
#14) clear ; menu-quota ;;
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back exit" ; sleep 1 ; exit ;;
esac
