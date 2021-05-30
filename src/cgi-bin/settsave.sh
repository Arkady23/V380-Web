#!/bin/sh

lib=$(dirname "$0")
. $lib/lot.sh

printf "Content-Type: text/html\r\n\r\n"
printf "\t%s" "settsave"

#read POST_DATA
#PARAMS=$(echo "$POST_DATA" | tr "&" " ")
#for S in $PARAMS ; do
#done

fl=/mnt/mtd/mvconf/factory_const.ini
add=/mnt/sdcard/ark-add-on
txt=$(cat $fl)
N_1=$(printf "%s" "$txt" | sed -n "/\[CONST_PARAM\]/=")
N_3=$(($N_1+1))
N_3=$(printf "%s" "$txt" | sed -n "$N_3,\$p" | sed -n "/\[/=" | head -n 1)
N_2=$(($N_1+$N_3))
lin=""

get_param(){
  printf "%s" "$txt" | sed -n "${N_1},${N_2} s/$1/$1/p" | cut -d "=" -f2
}
SAVE_01(){
  if [ $2 == 1 ]; then V=1; else V=0; fi
  if [ $(get_param rtsp) != "$V" ] ; then
	sed -i "${N_1},${N_2} s/^\($1\s*=\s*\).*$/\1$V/" $fl
  fi
}
SAVE_1(){
  N_3=$(printf "%s" "$txt" | sed -n "/$1/=")
  lin=$(printf "%s" "$txt" | sed -n "${N_3}p")
  if [ "${lin:0:1}" == '#' ]; then V=0; else V=1; fi
  if [ $2 != $V ]; then
	if [ $2 == 1 ]; then
		sed -i "${N_3} s/^.//" $fl
	else
		sed -i "${N_3} s/^/\#/" $fl
	fi
  fi
}


 SAVE_01 rtsp ${QUERY_STRING:0:1}

 fl=$add/startup.sh
 txt=$(cat $fl)

 SAVE_1 telnetd ${QUERY_STRING:1:1}

 fo=$add/opts.ini
 port=$(cat $fo | lot word app =)
 N_3=$?
 if [ ${QUERY_STRING:2:3} != $port ]; then
	sed -i "${N_3} s/^\(app\s*=\s*\).*$/\1${QUERY_STRING:2:3}/" $fo
 fi

 SAVE_1 httpd ${QUERY_STRING:5:1}
 port=$(printf "%s" "$lin" | lot word -p)
 V=${QUERY_STRING:6}
 if [ $V -lt 1 ]; then
	V=80
 elif [ $V -gt 65535 ]; then
	V=80
 fi
 if [ $V != $port ]; then
	sed -i "${N_3} s/$port/${QUERY_STRING:3}/" $fl
 fi
