#!/bin/sh
 sd=/mnt/sdcard
 killall -9 telnetd
# telnetd &
 tcpsvd -vE 0.0.0.0 21 ftpd -w &
 $sd/bin/httpd -p 80 -h $sd &
 $sd/cgi-bin/offline.sh 5 &
