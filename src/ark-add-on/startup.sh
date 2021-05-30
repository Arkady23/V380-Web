#!/bin/sh
 sd=/mnt/sdcard
 telnetd -l /bin/sh &
 $sd/ark-add-on/bin/httpd -p 80 -h $sd &
