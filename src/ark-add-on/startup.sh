#!/bin/sh
 sd=/mnt/sdcard
 killall -9 telnetd
# telnetd &
# $sd/bin/tcpsvd -vE 0.0.0.0 21 ftpd -w &
 $sd/bin/httpd -p 80 -h $sd &
