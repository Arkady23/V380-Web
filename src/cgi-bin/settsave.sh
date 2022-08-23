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
rc=/mnt/mtd/mvconf/record.ini
add=/mnt/sdcard/ark-add-on

rec=$(cat $rc)
txt=$(cat $fl)
N_1=$(printf "%s" "$txt" | sed -n "/\[CONST_PARAM\]/=")
N_3=$(($N_1+1))
N_3=$(printf "%s" "$txt" | sed -n "$N_3,\$p" | sed -n "/\[/=" | head -n 1)
N_2=$(($N_1+$N_3))
lin=""

get_param(){
  printf "%s" "$txt" | sed -n "${N_1},${N_2} s/$1/$1/p" | lot word =
}
SAVE_01(){
  if [ $2 == 1 ]; then V=1; else V=0; fi
  par=$(get_param $1)
  if [ "$par" != "$V" ]; then
	if [ -z "$par" ]; then
		sed -i "${N_2} s/\[/$1=$V\n&/" $fl
	else
		opts=$(printf "%s" "$txt" | sed -n ${N_1},${N_2}p)
		N_3=$(printf "%s" "$opts" | sed -n "/$1/=")
		sed -i "${N_3} s/\(\s*=\s*\).*$/\1$V/" $fl
	fi
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
			"offline.sh")	printf "%s\n" " \$sd/cgi-bin/$1 5 &" >> $fl ;;
			*) ;;
		esac
	fi
  fi
}
SAVE_TIME(){
  old=$(printf "%s" "$rec" | lot word "\[RECORDPARAM" RecordTime =)
  N_3=$?
  if [ $N_3 -gt 1 ]; then
	if [ $1 != $old ]; then
		sed -i "${N_3} s/$old/\1$1/" $rc
	fi
  fi
}
SAVE_opt(){
  fo=$add/opts.ini
  opts=$(cat $fo)
  N_3=$(printf "%s" "$opts" | sed -n "/$1/=")
  if [ $N_3 -ge 1 ]; then
	local old=$(printf "%s" "$opts" | sed -n "${N_3} s/$1/$1/p")
	old=$(printf "${old#*=}" | (read -r w1 w2; printf "$w1"))
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
 SAVE_1 "telnetd " ${QUERY_STRING:1:1}

 SAVE_1 " ftpd " ${QUERY_STRING:2:1}

 Q=${QUERY_STRING%+*}
 SAVE_TIME ${Q:3}
 Q=${QUERY_STRING#*+}

 SAVE_opt app ${Q:0:3}

 SAVE_1 offline.sh ${Q:3:1}

 SAVE_1 httpd ${Q:4:1}
 port=$(printf "%s" "$lin" | lot word -p)
 if [ $N_3 -gt 1 ]; then
	V=${Q:5}
	if [ $V -lt 1 ]; then
		V=80
	elif [ $V -gt 65535 ]; then
		V=80
	fi
	if [ $V != $port ]; then
		sed -i "${N_3} s/$port/$V/" $fl
	fi
 fi
