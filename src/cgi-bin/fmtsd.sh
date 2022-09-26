#!/bin/sh

fl=/tmp/fmt.sh
sd=/mnt/sdcard
dev=/dev/mmcblk0p1

lib=$(dirname "$0")
. $lib/lot.sh

after_fmt(){
  printf "#!/bin/sh\n"
  printf "killall -9 recorder\n"
  printf "mount $dev $sd &\n"
  printf "sleep 5\n"
  printf "cd $sd\n"
  printf "tar -x -f /tmp/bin1.tar\n"
  printf "tar -x -f /tmp/bin2.tar\n"
  printf "tar -x -f /tmp/cgi.tar\n"
  printf "mkdir ark-add-on\n"
  printf "mkdir RecFiles\n"
  printf "cd ark-add-on\n"
  printf "tar -x -f /tmp/ark.tar\n"
  printf "sync\n"
  printf "umount -l $dev\n"
  printf "killall5\n"
  printf "reboot\n"
}

USED_SPACE=$(df -h $sd | (read -r; read -r w1 w2 w3 w4; printf "$w3"))
if [ -z $USED_SPACE ]; then
  USED_SPACE=1
else
  cd $sd
  tar -c -f /tmp/bin1.tar bin/tcpsvd
  tar -c -f /tmp/bin2.tar bin/httpd
  tar -c -f /tmp/cgi.tar cgi-bin/ bin/libc.so.0 bin/lib bin/libm.so.0 index.html.gz
  cd ark-add-on
  tar -c -f /tmp/ark.tar startup.sh favicon.png.gz o.js.gz s.js.gz all.css.gz o.css.gz
  cd /tmp
  if [ -f "bin1.tar" -a -f "bin2.tar" -a -f "cgi.tar" -a -f "ark.tar" ]; then
	> $fl
	chmod 0777 $fl
	after_fmt >> $fl
	$sd/cgi-bin/offline.sh
	killall -9 telnetd
	killall -9 httpd
	killall -2 recorder
	umount -l $dev
	mkfs.vfat $dev
	sync
	$fl &
  fi
fi
