#!/bin/sh

printf "Content-Type: text/html\r\n\r\n"

TD=$(date +%Y%m%d)

if [ -n "$QUERY_STRING" ]; then

  printf "\tfolder\t%s" "$QUERY_STRING"

  cd /mnt/sdcard/RecFiles
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
  cd /mnt/sdcard/RecFiles
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
