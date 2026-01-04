#!/bin/sh

fl=/tmp/fmt.sh
sd=/mnt/sdcard
dev=/dev/mmcblk0p1

next(){
	echo "#!/bin/sh"
	echo "killall -2 recorder"
	echo "sync"
	echo "umount -l $dev"
	echo "mkfs.vfat $dev"
	echo "mount $dev $sd"
	echo "cd $sd"
	echo "cp -r /tmp/bin ."
	echo "cp -r /tmp/cgi-bin ."
	echo "cp -r /tmp/ark-add-on ."
	echo "cp /tmp/index.html.gz ."
	echo "rm -f /mnt/mtd/reset.sh"
	echo "sync"
	echo "umount -l $dev"
	echo "killall5"
	echo "reboot"
}

USED_SPACE=$(df -k $sd | (read -r; read -r w1 w2 w3 w4; printf "$w3"))
if [ -z $USED_SPACE ]; then
	USED_SPACE=1
else
	cd $sd
	pkill -f watch
	pkill -f httpd
	pkill -f tcpsvd
	cp -f /etc/bak/reset/reset.sh /mnt/mtd
	cp -f index.html.gz /tmp
	cp -r ark-add-on /tmp
	cp -r cgi-bin /tmp
	cp -r bin /tmp
	cd /tmp/bin
	if [[ -f busybox && -f lib && -f libc.so.0 && -f libm.so.0 ]]; then
		next > /mnt/mtd/reset.sh
		sync
		/mnt/mtd/reset.sh &
	else
		rm -rf &sd/RecFiles
		sync
		umount -l $dev
		killall5
		reboot
	fi
fi
