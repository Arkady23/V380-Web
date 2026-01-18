#!/bin/sh

printf "Content-Type: text/html\r\n\r\n"
printf "\t%s" "setts"

#read POST_DATA
#PARAMS=$(echo "$POST_DATA" | tr "&" " ")
#for S in $PARAMS ; do
#done

awk -v qs="$QUERY_STRING" -f /mnt/sdcard/cgi-bin/settsave.awk \
	/mnt/mtd/mvconf/factory_const.ini \
	/mnt/sdcard/ark-add-on/startup.sh \
	/mnt/sdcard/ark-add-on/opts.ini \
	/mnt/mtd/mvconf/record.ini \
	/mnt/mtd/nvipcstart.sh
