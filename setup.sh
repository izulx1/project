#!/bin/bash
# // COLOR VARIATION
p="\e[1;97m"
g="\033[1;92m"
y='\033[1;93m'
z="\033[96m"
j="\033[93m"
w="\033[1;92m"
r="\033[1;31m"
a=" ${z}ACCOUNT" 
q="\e[1;92;41m"
b="\033[0;34m"
NC='\033[0m'

rm -f ${0}

purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

cd
if [ "${EUID}" -ne 0 ]; then
echo "You need to run this script as root"
exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
echo "OpenVZ is not supported"
exit 1
fi

secs_to_human() {
echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

cat> /root/.profile << END
if [ "$BASH" ]; then
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
fi
mesg n || true
clear
neofetch
END
chmod 644 /root/.profile

apt install git curl -y >/dev/null 2>&1
apt install python -y >/dev/null 2>&1
apt install neofetch -y

mkdir -p /var/lib/xdxl >/dev/null 2>&1
echo "IP=" >> /var/lib/xdxl/ipvps.conf
echo ""
wget -q https://raw.githubusercontent.com/izulx1/project/master/tools.sh;chmod +x tools.sh;./tools.sh
rm tools.sh

mkdir -p /etc/xray
touch /etc/xray/domain

clear
neofetch
echo -e "$BBlue                 SETUP DOMAIN VPS     $NC"
echo -e "$BYellow----------------------------------------------------------$NC"
echo -e "$BGreen 1. Choose Your Own Domain / Gunakan Domain Sendiri $NC"
echo -e "$BGreen 2. Use Domain Random / Gunakan Domain Random $NC"
echo -e "$BYellow----------------------------------------------------------$NC"
read -rp " input 1 or 2 / pilih 1 atau 2 : " dns
if test $dns -eq 1; then
read -rp " Enter Your Domain / masukan domain : " dom
read -rp " Input ur ns-domain : " -e nsdomen
echo "IP=$dom" > /var/lib/xdxl/ipvps.conf
echo "$dom" > /etc/xray/domain
elif test $dns -eq 2; then
clear
apt install jq curl -y
wget -q -O /root/cf "https://raw.githubusercontent.com/izulx1/project/master/ssh/cf.sh" >/dev/null 2>&1
chmod +x /root/cf
bash /root/cf
print_success " Domain Random Done"
fi

clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green      Install SSH / WS               $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
clear
wget https://raw.githubusercontent.com/izulx1/project/master/ssh/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green      Install BACKUP               $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
clear
wget https://raw.githubusercontent.com/izulx1/project/master/backup/set-br.sh &&  chmod +x set-br.sh && ./set-br.sh
clear
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green          Install XRAY              $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
clear
wget https://raw.githubusercontent.com/izulx1/project/master/xray/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh

history -c
curl -sS ifconfig.me > /root/.myip
clear
echo " Installation DoNe"
rm /root/*.sh >/dev/null 2>&1
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
read -n 1 -s -r -p "Press any key to menu"
menu
