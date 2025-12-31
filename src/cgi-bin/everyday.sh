#!/bin/sh
cd /mnt/sdcard/RecFiles
FREE_SD=$(df -k /mnt/sdcard | (read -r; read -r w1 w2 w3 w4 w5; printf "$w4"))
if [ $((FREE_SD)) -le 3500000 ]; then
	d = ""
	for f in `ls -r`; do
		if [ ${#f} == 8 ]; then d="$f"; fi
	done
	if [ ${#d} == 8 ]; then rm -rf "$d"; fi
fi
