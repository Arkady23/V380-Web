#!/bin/sh
 sd=/mnt/sdcard
 killall -9 telnetd
 telnetd &
 watch -n 50000 $sd/cgi-bin/everyday.sh &
 $sd/bin/busybox tcpsvd -vE 0.0.0.0 21 ftpd -w &
 $sd/bin/busybox httpd -p 80 -h $sd &
