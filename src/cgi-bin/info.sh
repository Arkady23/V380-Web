#!/bin/sh

printf "Content-Type: text/plain\r\n\r\n\tinfo"

LOCAL_TIME=$(date)
iwconfig wlan0 | awk -f /mnt/sdcard/cgi-bin/info.awk
GATEWAY=$(route -n | (read -r; read -r; read -r w1 w2 w3; printf "$w2"))
FREE_DISK=$(df -h /mnt/mtd | (read -r; read -r w1 w2 w3 w4 w5; printf "$w4"))
FREE_SD=$(df -h /mnt/sdcard | (read -r; read -r w1 w2 w3 w4 w5; printf "$w4"))
MEMORY=$(free -m | (read -r; read -r w1 w2 w3 w4 w5; printf "%sM" "$w4 / $w2"))
txt=$(ifconfig wlan0 | (read -r w1; w2=$((${#w1}-17)); printf "${w1:$w2}"; read -r w1 w2 w3 w4 w5; printf "${w2:5}=${w4:5}"))
MAC_ADDR=${txt:0:17}; txt=${txt:17}
LOCAL_IP=${txt%=*}
NETMASK=${txt#*=}

printf "\t%s" "$LOCAL_TIME" "$MEMORY" "$FREE_DISK" "$FREE_SD" "$LOCAL_IP" "$NETMASK" "$GATEWAY" "$MAC_ADDR"
