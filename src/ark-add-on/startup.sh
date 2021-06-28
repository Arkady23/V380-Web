#!/bin/sh
 sd=/mnt/sdcard
 killall -9 telnetd
 telnetd -l /bin/sh &
 $sd/bin/httpd -p 80 -h $sd &
