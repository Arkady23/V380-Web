#!/bin/sh

fl=/tmp/fmt.sh
sd=/mnt/sdcard
dev=/dev/mmcblk0p1

lib=$(dirname "$0")
. $lib/lot.sh

USED_SPACE=$(df -h $sd | (read -r; read -r w1 w2 w3 w4; printf "$w3"))
if [ -z $USED_SPACE ]; then
  USED_SPACE=1
else
  killall -9 telnetd
  killall -9 tcpsvd
  killall -9 httpd
  cd $sd
  cgi-bin/offline.sh
  mv -f bin /tmp
  mv -f cgi-bin /tmp
  mv -f ark-add-on /tmp
  mv -f index.html.gz /tmp
  cd /tmp
  killall -2 recorder
  umount -l $dev
  mkfs.vfat $dev
  sync
  killall -9 recorder
  mount $dev $sd &
  sleep 5
  cp -r bin $sd
  cp -r cgi-bin $sd
  cp -r ark-add-on $sd
  cp index.html.gz $sd
  sync
  umount -l $dev
  killall5
  reboot
fi
