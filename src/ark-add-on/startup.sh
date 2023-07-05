#!/bin/sh
 sd=/mnt/sdcard
 killall -9 telnetd
 telnetd &
 $sd/bin/busybox tcpsvd -vE 0.0.0.0 21 ftpd -w &
 $sd/bin/busybox httpd -p 80 -h $sd &
