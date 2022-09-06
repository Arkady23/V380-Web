#!/bin/sh

 if [ $# -ge 1 ]; then sleep $1; fi
 echo $(ifconfig wlan0 | (read -r w1; read -r w1 w2 w3; printf "${w2:5}")) > /mnt/sdcard/IP.txt
