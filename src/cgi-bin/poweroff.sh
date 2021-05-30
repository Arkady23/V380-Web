#!/bin/sh

killall httpd
killall recorder
sync
umount /dev/mmcblk0p1
killall5

if [ "$QUERY_STRING" ]; then
  reboot
else
  halt
fi
