#!/bin/sh

printf "Content-Type: text/plain\r\n\r\n"
printf "\tinfo"

awk -f /mnt/sdcard/cgi-bin/info.awk /mnt/mtd/mvconf/patchmanage.conf \
	/mnt/mtd/mvconf/version.ini /proc/cpuinfo /proc/uptime /proc/loadavg

LOCAL_TIME=$(date)
MEMORY=$(free -m | (read -r; read -r w1 w2 w3 w4 w5; printf "%sM" "$w4 / $w2"))
FREE_DISK=$(df -h /mnt/mtd | (read -r; read -r w1 w2 w3 w4 w5; printf "$w4"))
FREE_SD=$(df -h /mnt/sdcard | (read -r; read -r w1 w2 w3 w4 w5; printf "$w4"))

txt=$(ifconfig wlan0 | (read -r w1; w2=$((${#w1}-17)); printf "${w1:$w2}"; read -r w1 w2 w3 w4 w5; printf "${w2:5}=${w4:5}"))
MAC_ADDR=${txt:0:17}
txt=${txt:17}
LOCAL_IP=${txt%=*}
NETMASK=${txt#*=}
GATEWAY=$(route -n | (read -r; read -r; read -r w1 w2 w3; printf "$w2"))
WLAN_ESSID=$(iwconfig wlan0 | (read -r w1 w2 w3 w4 w5; w1=$((${#w4}-8)); read -r; read -r; read -r; read -r; read -r; read -r w2 w3 w5; printf "${w4:7:$w1}==${w3:8}"))
WLAN_STRENGTH=${WLAN_ESSID#*==}
WLAN_ESSID=${WLAN_ESSID%==*}
let WLAN_STRENGTH=100*`printf "$WLAN_STRENGTH"`

printf "\t%s" "$LOCAL_TIME" "$MEMORY" "$FREE_DISK" "$FREE_SD" "$LOCAL_IP" "$NETMASK"
printf "\t%s" "$GATEWAY" "$MAC_ADDR" "$WLAN_ESSID" "$WLAN_STRENGTH%"
