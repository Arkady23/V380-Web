#!/bin/sh

lib=$(dirname "$0")
. $lib/lot.sh

TD=$(date +%Y%m%d)
add=/mnt/sdcard/ark-add-on

local cs=""
local lng="0"
if [ -f "$add/opts.ini" ]; then
  cs=$(cat $add/opts.ini | lot word cs =)
  lng=$(cat $add/opts.ini | lot word lang =)
fi
if [ -z "$cs" -o "$cs" == "0" ]; then
  cs="ark"
else
  if [ "$HTTP_COOKIE" == "$cs" ]; then cs="ark"; fi
fi

printf "Content-Type: text/html\r\n\r\n"
printf "$lng"

if [ "$cs" == "ark" ]; then

  cd /mnt/sdcard/RecFiles

  if [ -n "$QUERY_STRING" ]; then

	ntp=$(cat /mnt/mtd/mvconf/ntp.ini)
	tz=$(printf "%s" "$ntp" | lot word TIMEZONE tz =)
	tz_offset=$(printf "%s" "$ntp" | lot word TIMEZONE tz_offset =)

	printf "\tfolder\t%s\t%s\t%s" "$QUERY_STRING" "$tz" "$tz_offset"

	if [ $QUERY_STRING == $TD ]; then
		for f in `ls -r *.avi`; do
			printf "\t/%s" "$f"
		done
	  fi
	cd $QUERY_STRING
	for h in `ls -r`; do
		for f in `ls -r $h/*.avi`; do
			printf "\t%s" "${f:4}"
		done
	done

  else

	L=0
	for f in `ls -r *.avi`; do
		L=1
	done
	for f in `ls -r`; do
		if [ ${#f} == 8 ]; then
			if [ $L != 0 ]; then
				L=0
				if [ $f != $TD ]; then
					printf "\t%s" "$TD"
				fi
			fi
			printf "\t%s" "$f"
		fi
	done
	if [ $L != 0 ]; then
		L=0
		printf "\t%s" "$TD"
	fi

  fi
else
  printf "\t%s" "pass" "$cs"
fi
