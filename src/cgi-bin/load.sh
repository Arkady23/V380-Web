#!/bin/sh

cat > /mnt/sdcard/ark-add-on/update
printf "Content-Type: text/html\r\n\r\n"
printf "\t%s\t" "load"

cd /mnt/sdcard/ark-add-on
if [ -f "update" ]; then
  tar -x -f update update.sh
  sync
  if [ -f "update.sh" ]; then
	/mnt/sdcard/ark-add-on/update.sh update
  fi
fi
