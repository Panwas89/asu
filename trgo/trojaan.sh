#!/bin/bash

MYIP=$(curl -sS ipv4.icanhazip.com)

clear
clear
x="ok"
cekray=`cat /root/log-install.txt | grep -ow "XRAYS" | sort | uniq`
if [ "$cekray" = "XRAYS" ]; then
kjj='xray'
else
kjj='v2ray'
fi
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
chck_pid(){
	PID=`ps -ef |grep -v grep | grep $kjj |awk '{print $2}'`
	if [[ ! -z "${PID}" ]]; then
			echo -e "\033[0;33mStatus: ${Green_font_prefix} Installed${Font_color_suffix} & ${Green_font_prefix}Jalan${Font_color_suffix}"
		else
			echo -e "\033[0;33mStatus: ${Green_font_prefix} Installed${Font_color_suffix} but ${Red_font_prefix}Busuk${Font_color_suffix}"
		fi
}

chgck_pid(){
	PID=`ps -ef |grep -v grep | grep trojan-go |awk '{print $2}'`
	if [[ ! -z "${PID}" ]]; then
			echo -e "\033[0;33mStatus: ${Green_font_prefix} Installed${Font_color_suffix} & ${Green_font_prefix}Jalan${Font_color_suffix}"
		else
			echo -e "\033[0;33mStatus: ${Green_font_prefix} Installed${Font_color_suffix} but ${Red_font_prefix}Busuk${Font_color_suffix}"
		fi
}

while true $x != "ok"
do

echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[0;36m                MENU TROJAN-GO                    \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
#chck_pid
echo -e " "
echo -e "01. Create Trojan-GO Account "
echo -e "02. Deleting Trojan-GO Account "
echo -e "03. Extending Trojan-GO Account Active Life "
echo -e "04. Check User Login Trojan-GO  "
#echo -e " \033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " "
echo -e "\033[0;35m[00] • Back to Main Menu "
#echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -ne "Select menu : "; read x

case "$x" in 
   1 | 01)
   clear
   addtrgo
   break
   ;;
   2 | 02)
   clear
   deltrgo
   break
   ;;
   3 | 03)
   clear
   renewtrgo
   break
   ;;
   4 | 04)
   clear
   cektrgo
   break
   ;;
   0 | 00)
   clear
   menu
   break
   ;;
   *)
   clear
esac
done