#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################



clear
source /var/lib/SIJA/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
tls="$(cat ~/log-install.txt | grep -w "Vless TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vless None TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
echo -e "\033[0;34m☉——————————————————————————☉\033[0m"
echo -e "\E[44;1;39m      Add Xray/Vless Account      \E[0m"
echo -e "\033[0;34m☉——————————————————————————☉\033[0m"

		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
		echo -e "\033[0;34m☉——————————————————————————☉\033[0m"
		echo -e "\E[44;1;39m      Add Xray/Vless Account      \E[0m"
		echo -e "\033[0;34m☉——————————————————————————☉\033[0m"
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
			read -n 1 -s -r -p "PRESS [ ENTER ] KELUAR MENU"
			v2ray-menu
		fi
	done

uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
read -p "Limit (GB) : " quota
read -p "Max Login : " iplimit
#QUOTA
if [[ $quota -gt 0 ]]; then
echo -e "$[$quota * 1024 * 1024 * 1024]" > /etc/cobek/limit/vmess/quota/$user
else
echo > /dev/null
fi
#IPLIMIT
if [[ $iplimit -gt 0 ]]; then
echo -e "$iplimit" > /etc/cobek/limit/vmess/ip/$user
else
echo > /dev/null
fi
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vless$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=/vless&security=tls&encryption=none&type=ws#${user}"
vlesslink2="vless://${uuid}@${domain}:$none?path=/vless&encryption=none&type=ws#${user}"
vlesslink3="vless://${uuid}@${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com#${user}"
systemctl restart xray
clear
echo -e "\033[0;34m☉——————————————————————————☉\033[0m" | tee -a /etc/log-create-user.log
echo -e "\E[44;1;39m Xray/Vless Account  \E[0m" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m☉——————————————————————————☉\033[0m" | tee -a /etc/log-create-user.log
echo -e "Remarks        : ${user}" | tee -a /etc/log-create-user.log
echo -e "Domain         : ${domain}" | tee -a /etc/log-create-user.log
echo -e "port TLS       : $tls" | tee -a /etc/log-create-user.log
echo -e "port none TLS  : $none" | tee -a /etc/log-create-user.log
echo -e "id             : ${uuid}" | tee -a /etc/log-create-user.log
echo -e "Encryption     : none" | tee -a /etc/log-create-user.log
echo -e "Network        : ws" | tee -a /etc/log-create-user.log
echo -e "Path           : /vless" | tee -a /etc/log-create-user.log
echo -e "Path           : vless-grpc" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m☉——————————————————————————☉\033[0m" | tee -a /etc/log-create-user.log
echo -e "Link TLS       : ${vlesslink1}" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m☉——————————————————————————☉\033[0m" | tee -a /etc/log-create-user.log
echo -e "Link none TLS  : ${vlesslink2}" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m☉——————————————————————————☉\033[0m" | tee -a /etc/log-create-user.log
echo -e "Link GRPC      : ${vlesslink3}" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m☉——————————————————————————☉\033[0m" | tee -a /etc/log-create-user.log
echo -e "Expired On     : $exp" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m☉——————————————————————————☉\033[0m" | tee -a /etc/log-create-user.log
echo "" | tee -a /etc/log-create-user.log
read -n 1 -s -r -p "PRESS [ ENTER ] KELUAR MENU"

menu
