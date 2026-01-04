#!/bin/sh

add=/mnt/sdcard/ark-add-on
lib=/mnt/sdcard/cgi-bin
. $lib/lot.sh

c_playr(){
  if [ $app == VLC ]; then
	printf "\t\t<track>\r\n"
	printf "\t\t\t<location>http://$ip/RecFiles/$2</location>\r\n"
	printf "\t\t\t<title>$1</title>\r\n"
	printf "\t\t\t<extension application='http://www.videolan.org/vlc/playlist/0'>\r\n"
	printf "\t\t\t\t<vlc:id>$N</vlc:id>\r\n"
	if [ $N == 0 ]; then
		printf "\t\t\t\t<vlc:option>network-caching=1000</vlc:option>\r\n"
	fi
	printf "\t\t\t</extension>\r\n"
	printf "\t\t</track>\r\n"
	N=$(($N+1))
  else
	N=$(($N+1))
	printf "$N,type,0\r\n"
	printf "$N,label,$1\r\n"
	printf "$N,filename,http://$ip/RecFiles/$2\r\n"
  fi
}
c_plist(){
  ntp=$(cat /mnt/mtd/mvconf/ntp.ini)
  tz=$(printf "%s" "$ntp" | lot word TIMEZONE tz =)
  tz_offset=$(printf "%s" "$ntp" | lot word TIMEZONE tz_offset =)

  if [ $app == VLC ]; then
	printf "<?xml version='1.0' encoding='UTF-8'?>\r\n"
	printf "<playlist xmlns='http://xspf.org/ns/0/' xmlns:vlc='http://www.videolan.org/vlc/playlist/ns/0/' version='1'>\r\n"
	printf "\t<trackList>\r\n"
  else
	printf "MPCPLAYLIST\r\n"
  fi
  N=0
  cd /mnt/sdcard/RecFiles
  if test -f "recoredindex.ini"; then
	if [ $tz -lt 0 ]; then ntp="UTC+"$((-tz)); else ntp="UTC-"$tz; fi
	TD=$(TZ="$ntp" date +%Y%m%d)
	V2=0
  else
	TD=$(date +%Y%m%d)
	V2=2
  fi
  if [ $TD == $QUERY_STRING ]; then
	L=0
	for f in `ls -t *_1970*.avi`; do
		L=1
		print2
	done
	if [ $L == 0 ]; then
		for f in `ls -t rec*.avi`; do
			print2
		done
	fi
  fi
  for f in `ls -t *_"$QUERY_STRING"*.avi`; do
	titl2
	c_playr "$t" "$f"
  done
  cd $QUERY_STRING
  for h in `ls -r`; do
	for f in `ls -t $h/*.avi`; do
		if [ $V2 == 0 ]; then
			titl2
		else
			titl1
			ss=$(date -d "$t" +"%s")
			ss=$(($tz*3600+$tz_offset*60+$ss))
			t=$(date -d "@$ss" +"%d-%m-%Y %H:%M")
		fi
		c_playr "$t" "$QUERY_STRING/$f"
	done
  done
  if [ $app == VLC ]; then
	printf "\t</trackList>\r\n"
	printf "\t<extension application='http://www.videolan.org/vlc/playlist/0'>\r\n"
	i=0
	while [ $i -lt $N ]; do
		printf "\t\t<vlc:item tid='$i'/>\r\n"
		i=$(($i+1))
	done
	printf "\t</extension>\r\n"
	printf "</playlist>\r\n"
  fi
}
titl1(){
	t=${f#*"_"}
	t="${t:0:4}-${t:4:2}-${t:6:2} ${t:8:2}:${t:10:2}:${t:12:2}"
}
titl2(){
	titl1
	t=$(date -d "$t" +"%d-%m-%Y %H:%M")
}
print2(){
	t="${QUERY_STRING:6:2}-${QUERY_STRING:4:2}-${QUERY_STRING:0:4} Video recording is open"
	c_playr "$t" "$f"
}

if [ -f "$add/opts.ini" ]; then
  app=$(cat $add/opts.ini | lot word app =)
else
  app=VLC
fi
if [ $app == VLC ]; then
  f="xspf"
else
  f="mpcpl"
fi

ip=$(ifconfig wlan0 | lot word "inet addr:")
fn=${QUERY_STRING}_${ip}.$f
fl=/tmp/$fn
c_plist > $fl

printf "Content-Type: text/plain\r\n"
printf "Content-Disposition: attachment; filename=\"${fn}\"\r\n"
printf "Content-Length: `wc -c < $fl`\r\n\r\n"
cat $fl
rm $fl
