#!/bin/sh

cgi=/mnt/sdcard/cgi-bin

if [ $# -ge 1 ]; then
  if [ -n "$(awk -f $cgi/wifi.awk)" ]; then
	$cgi/poweroff.sh 61 &
  else
	$cgi/ip.sh 61 &
  fi
fi
