#!/bin/sh

lib=$(dirname "$0")
. $lib/lot.sh

get_txt(){
  if [ -n "$2" ]; then
	printf "%s" "$txt" | lot word $1 $2 =
  else
	printf "%s" "$txt" | lot word $1 =
  fi
}

printf "Content-Type: text/html\r\n\r\n"

txt=$(cat /mnt/mtd/mvconf/patchmanage.conf)
CAM=$(get_txt hwname)
CPU=$(grep -e Processor -e Hardware /proc/cpuinfo | (read -r w1 w2 w3; read -r w4 w5 w6; printf "$w3 $w6"))
ARCH=$(grep -e architecture /proc/cpuinfo | (read -r w1 w2 w3 w4; printf "$w3"))
FW_VERSION=$(get_txt version)

txt=$(cat /mnt/mtd/mvconf/version.ini)
HW_V=$(get_txt hardware_version name)
HW_V2=$(get_txt hardware_version date)
APP_V=$(get_txt app_version name)
APP_V2=$(get_txt app_version date)

LOCAL_TIME=$(date)
UPTIME=$(cat /proc/uptime | (read -r w1 w2; printf "$w1"))
LOAD_AVG=$(cat /proc/loadavg | (read -r w1 w2 w3 w4; printf "$w1 $w2 $w3"))

MEMORY=$(free -k | (read -r; read -r w1 w2 w3 w4 w5; printf "$w4 / $w2"))
FREE_DISK=$(df -k /mnt/mtd | (read -r; read -r w1 w2 w3 w4 w5; printf "$w4"))
FREE_SD=$(df -h /mnt/sdcard | (read -r; read -r w1 w2 w3 w4 w5; printf "$w4"))

txt=$(ifconfig wlan0 | (read -r w1; w2=$((${#w1}-17)); printf "${w1:$w2}"; read -r w1 w2 w3 w4 w5; printf "${w2:5}=${w4:5}"))
MAC_ADDR=${txt:0:17}
txt=${txt:17}
LOCAL_IP=${txt%=*}
NETMASK=${txt#*=}
GATEWAY=$(route -n | (read -r; read -r; read -r w1 w2 w3; printf "$w2"))
WLAN_ESSID=$(iwconfig wlan0 | (read -r w1 w2 w3 w4 w5; w1=$((${#w4}-8)); read; read; read; read; read; read w2 w3 w5; printf "${w4:7:$w1}==${w3:8}"))
WLAN_STRENGTH=${WLAN_ESSID#*==}
WLAN_ESSID=${WLAN_ESSID%==*}
let WLAN_STRENGTH=100*`printf "$WLAN_STRENGTH"`

printf "\t%s" "info" "$CAM" "$CPU" "$ARCH" "$FW_VERSION"
printf "\t%s" "${HW_V}_$HW_V2" "${APP_V}_$APP_V2" "$LOCAL_TIME" "$UPTIME" "$LOAD_AVG"
printf "\t%s" "$MEMORY" "$FREE_DISK" "$FREE_SD" "$LOCAL_IP" "$NETMASK"
printf "\t%s" "$GATEWAY" "$MAC_ADDR" "$WLAN_ESSID" "$WLAN_STRENGTH%"
