#!/bin/sh

lib=/mnt/sdcard/cgi-bin
. $lib/lot.sh

print1(){
	printf "\t%s" "$1"
}
print2(){
	printf "\t/%s" "$f"
}
print3(){
	if [ $L != 0 ]; then
		L=0
		if [ $f != $TD ]; then
			print1 "$TD"
		fi
	fi
	print1 "$f"
}

local cs=""
local lng="0"
add=/mnt/sdcard/ark-add-on
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
  ntp=$(cat /mnt/mtd/mvconf/ntp.ini)
  tz=$(printf "%s" "$ntp" | lot word TIMEZONE tz =)
  tz_offset=$(printf "%s" "$ntp" | lot word TIMEZONE tz_offset =)
  if test -f "recoredindex.ini"; then
	if [ $tz -lt 0 ]; then ntp="UTC+"$((-tz)); else ntp="UTC-"$tz; fi
	TD=$(TZ="$ntp" date +%Y%m%d)
  else
	TD=$(date +%Y%m%d)
  fi

  if [ -n "$QUERY_STRING" ]; then

	printf "\tfolder\t%s\t%s\t%s" "$QUERY_STRING" "$tz" "$tz_offset"

	if [ $QUERY_STRING == $TD ]; then
		L=0
		for f in `ls -t *_1970*.avi`; do
			L=1
			print2
		done
		if [ $L == 0 ]; then
			for f in `ls -t rec*.avi`; do
				print2
			done
		fi
	fi

	for f in `ls -t *_"$QUERY_STRING"*.avi`; do
		print2
	done
	cd $QUERY_STRING
	for h in `ls -r`; do
		for f in `ls -t $h/*.avi`; do
			print1 "$f"
		done
	done

  else

	L=0
	for f in `ls *_1970*.avi`; do
		L=1
	done
	if [ $L == 0 ]; then
		for f in `ls rec*.avi`; do
			L=1
		done
	fi

	for f in `ls Rec*.avi | awk -F'_' '{print substr($2,0,8)}' | sort -ru`; do
		if [[ $f != *"_1970"* ]]; then
			if ! test -d "$f"; then print3; fi
		fi
	done
	for f in `ls -dr */`; do
		if [ ${#f} == 9 ]; then
			f=${f::8}
			print3
		fi
	done
	if [ $L != 0 ]; then print1 "$TD"; fi

  fi
else
  printf "\t%s" "pass" "$cs"
fi
