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
  if [ $N_3 -gt 1 ]; then
	lin=$(printf "%s" "$txt" | sed -n "${N_3}p")
	if [ "${lin:0:1}" == '#' ]; then V=0; else V=1; fi
	if [ $2 != $V ]; then
		if [ $2 == 1 ]; then
			sed -i "${N_3} s/^.//" $fl
		else
			sed -i "${N_3} s/^/\#/" $fl
		fi
	fi
  else
	if [ "$2" == "1" ]; then
		case $1 in
			"offline.sh")	printf "%s\n" " \$sd/cgi-bin/$1 &" >> $fl ;;
			*) ;;
		esac
	fi
  fi
}
SAVE_opt(){
  N_3=$(printf "%s" "$opts" | sed -n "/$1/=")
  if [ $N_3 -ge 1 ]; then
	local old=$(printf "%s" "$opts" | sed -n "${N_3} s/$1/$1/p")
	old=$(printf "${old#*=}" | read -r w1 w2; printf "$w1")
	if [ $2 != $old ]; then
		sed -i "${N_3} s/^\($1\s*=\s*\).*$/\1$2/" $fo
	fi
  else
	printf "%s\n" "$1=$2" >> $fo
  fi
}


 SAVE_01 rtsp ${QUERY_STRING:0:1}

 fl=$add/startup.sh
 txt=$(cat $fl)
 SAVE_1 telnetd ${QUERY_STRING:1:1}

 fo=$add/opts.ini
 opts=$(cat $fo)
 SAVE_opt app ${QUERY_STRING:2:3}

 SAVE_1 offline.sh ${QUERY_STRING:5:1}

 SAVE_1 httpd ${QUERY_STRING:6:1}
 port=$(printf "%s" "$lin" | lot word -p)
 N_3=$?
 if [ $N_3 -gt 1 ]; then
	V=${QUERY_STRING:7}
	if [ $V -lt 1 ]; then
		V=80
	elif [ $V -gt 65535 ]; then
		V=80
	fi
	if [ $V != $port ]; then
		sed -i "${N_3} s/$port/${QUERY_STRING:3}/" $fl
	fi
 fi
