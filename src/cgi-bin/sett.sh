#!/bin/sh

printf "Content-Type: text/html\r\n\r\n"
awk -f	/mnt/sdcard/cgi-bin/sett.awk \
	/mnt/mtd/mvconf/factory_const.ini \
	/mnt/sdcard/ark-add-on/startup.sh \
	/mnt/sdcard/ark-add-on/opts.ini \
	/mnt/mtd/mvconf/record.ini
