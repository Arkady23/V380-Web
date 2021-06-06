#!/bin/sh

fl=/tmp/fmt.sh
sd=/mnt/sdcard
dev=/dev/mmcblk0p1

lib=$(dirname "$0")
. $lib/lot.sh

after_fmt(){
  printf "#!/bin/sh\n"
  printf "sleep 3\n"
  printf "L=0\n"
  printf "while [ \$L == 0 ]; do\n"
  printf "  sleep 2\n"
  printf "  if [ -d \"$sd/RecFiles\" ]; then\n"
  printf "	L=1\n"
  printf "  fi\n"
  printf "done\n"
  printf "sleep 2\n"
  printf "cd $sd\n"
  printf "tar -x -f /tmp/cgi.tar\n"
  printf "rm /tmp/cgi.tar\n"
  printf "mkdir ark-add-on\n"
  printf "cd ark-add-on\n"
  printf "tar -x -f /tmp/ark.tar\n"
  printf "rm /tmp/ark.tar\n"
  printf "sync\n"
  printf "$sd/ark-add-on/startup.sh &\n"
}

FREE_DISK=$(df -k /mnt/mtd | (read -r; read -r w1 w2 w3 w4 w5; printf "$w4"))
USED_SPACE=$(df -h $sd | (read -r; read -r w1 w2 w3 w4; printf "$w3"))
if [ -z $USED_SPACE ]; then
  USED_SPACE=1
elif [ $FREE_DISK -gt 600 ]; then
  > $fl
  chmod 0777 $fl
  after_fmt >> $fl
  cd $sd
  tar -c -f /tmp/cgi.tar cgi-bin/ index.html.gz
  cd ark-add-on
  tar -c -f /tmp/ark.tar  bin/ startup.sh favicon.png.gz o.js.gz s.js.gz all.css.gz o.css.gz
  cd /tmp
  killall -9 telnetd
  killall -9 httpd
  killall recorder
  umount -l $dev
  mkfs.vfat $dev
  sync
  $fl &
fi
