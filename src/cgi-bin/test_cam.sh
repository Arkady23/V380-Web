#!/bin/sh

add=/mnt/sdcard/ark-add-on
fo=$add/opts.ini

  if [ -z "$(awk 'sub(/=/," "){if($1=="cam" && NF>1){printf 1;exit}}' $fo)" ]
  then
	if [ -n "$(grep -m 1 rtsp_enable /mvs/apps/recorder)" ]
	then p=1; else p=0; fi
	if [ -f "$fo" ]; then
		printf "%s\n" "cam=$p" >> $fo
	else
		printf "%s\n" "cam=$p" > $fo
	fi
  fi
