#!/bin/sh

lib=$(dirname "$0")
. $lib/lot.sh

fl=/tmp/fmt.sh
sd=/mnt/sdcard
dev=/dev/mmcblk0p1

FREE_DISK=$(df -k /mnt/mtd | (read -r; read -r w1 w2 w3 w4 w5; printf "$w4"))
USED_SPACE=$(df -h $sd | (read -r; read -r w1 w2 w3 w4; printf "$w3"))
if [ -z $USED_SPACE ]; then
  USED_SPACE=1
elif [ $FREE_DISK -gt 600 ]; then
  echo '#!/bin/sh' > $fl
  chmod 0777 $fl
  echo "sleep 3" >> $fl
  echo "killall recorder" >> $fl
  echo "umount -l $sd" >> $fl
  echo "sync" >> $fl
  echo "L=0" >> $fl
  echo "while [ \$L == 0 ]; do" >> $fl
  echo "  sleep 2" >> $fl
  echo "  if [ -d \"$sd/RecFiles\" ]; then" >> $fl
  echo "	L=1" >> $fl
  echo "  fi" >> $fl
  echo "done" >> $fl
  echo "sleep 2" >> $fl
  echo "cd $sd" >> $fl
  echo 'tar -x -f /tmp/cgi.tar' >> $fl
  echo 'rm /tmp/cgi.tar' >> $fl
  echo 'mkdir ark-add-on' >> $fl
  echo 'cd ark-add-on' >> $fl
  echo 'tar -x -f /tmp/ark.tar' >> $fl
  echo 'rm /tmp/ark.tar' >> $fl
  echo 'sync' >> $fl
  echo "$sd/ark-add-on/startup.sh &" >> $fl
  cd $sd
  tar -c -f /tmp/cgi.tar cgi-bin/ index.html.gz
  cd ark-add-on
  tar -c -f /tmp/ark.tar  bin/ startup.sh favicon.png.gz o.js.gz s.js.gz all.css.gz o.css.gz
  cd /tmp
  killall telnetd
  killall httpd
  killall recorder
  umount -l $dev
  mkfs.vfat $dev
  sync
  $fl &
fi
