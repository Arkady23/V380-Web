#!/bin/sh

add=/mnt/sdcard/ark-add-on
lib=$(dirname "$0")
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
  if [ $app == VLC ]; then
	printf "<?xml version='1.0' encoding='UTF-8'?>\r\n"
	printf "<playlist xmlns='http://xspf.org/ns/0/' xmlns:vlc='http://www.videolan.org/vlc/playlist/ns/0/' version='1'>\r\n"
	printf "\t<trackList>\r\n"
  else
	printf "MPCPLAYLIST\r\n"
  fi
  N=0
  cd /mnt/sdcard/RecFiles
  if [ $(date +%Y%m%d) == $QUERY_STRING ]; then
	for f in `ls -r *.avi`; do
		t="${QUERY_STRING:6:2}-${QUERY_STRING:4:2}-${QUERY_STRING:0:4} Video recording is open"
		c_playr "$t" "$f"
	done
  fi
  cd $QUERY_STRING
  for h in `ls -r`; do
	for f in `ls -r $h/*.avi`; do
		t="${QUERY_STRING:6:2}-${QUERY_STRING:4:2}-${QUERY_STRING:0:4} ${h:1:2}:${f:21:2}"
		c_playr "$t" "$QUERY_STRING/$f"
	done
  done
  if [ $app == VLC ]; then
	printf "\t</trackList>\r\n"
	printf "\t<extension application='http://www.videolan.org/vlc/playlist/0'>\r\n"
	i=0
	while [ $i -le $N ]; do
		printf "\t\t<vlc:item tid='$i'/>\r\n"
		i=$(($i+1))
	done
	printf "\t</extension>\r\n"
	printf "</playlist>\r\n"
  fi
}

if [ -f "$add/opts.ini" ]; then
  app=$(cat $add/opts.ini | lot word app =)
else
  app=MPC
fi
if [ $app == VLC ]; then
  f="xspf"
else
  f="mpcpl"
fi

ip=$(ifconfig wlan0 | lot word "inet addr:")
fn=${QUERY_STRING}_${ip}.$f
fl=/tmp/$fn
> $fl
c_plist >> $fl

printf "Content-Type: text/plain\r\n"
printf "Content-Disposition: attachment; filename=\"${fn}\"\r\n"
printf "Content-Length: `wc -c < $fl`\r\n\r\n"
cat $fl
rm $fl
