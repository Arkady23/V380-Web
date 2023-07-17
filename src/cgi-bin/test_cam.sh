#!/bin/sh

lib=/mnt/sdcard/cgi-bin
. $lib/lot.sh

add=/mnt/sdcard/ark-add-on
fo=$add/opts.ini
ops=$(cat $fo)

  lin=$(printf "%s" "$ops" | lot word cam =)
  if [ -z "$lin" ]; then
	if [ $(grep -m 1 rtsp_enable /mvs/apps/recorder) ]; then
		p=1
	 else
		p=0
	fi
	printf "%s\n" "cam=$p" >> $fo
  fi
