#!/bin/sh

killall -9 httpd
/mnt/mtd/stopallapp.sh
sync
umount /dev/mmcblk0p1
killall5

if [ "$QUERY_STRING" ]; then
  reboot
else
  halt
fi
