#!/bin/sh

cd /mnt/sdcard/RecFiles

FREE_SD=$(df -k /mnt/sdcard | (read -r; read -r w1 w2 w3 w4 w5; printf "$w4"))
if [ $((FREE_SD)) -le 3500000 ]; then
	d=""
	for f in `ls -dr */`; do
		if [ ${#f} == 9 ]; then d=${f::8}; fi
	done
	if [ ${#d} == 8 ]; then rm -rf "$d"; fi
fi

f=$(ls -tr Rec*.avi | head -1)
if [[ $f != *"_1970"* ]]; then
	f=${f#*"_"}
	f=${f:0:8}
	mkdir -p $f/all
	mv -f *_$f*.avi $f/all/
	rm -f /tmp/tmpindex_rec.ini rec*.ini
fi
