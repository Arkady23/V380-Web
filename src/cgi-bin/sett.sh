#!/bin/sh

printf "Content-Type: text/html\r\n\r\n"
printf "\t%s" "sett"

rec=$(cat /mnt/mtd/mvconf/record.ini)
txt=$(cat /mnt/mtd/mvconf/factory_const.ini)
sta=$(cat /mnt/sdcard/ark-add-on/startup.sh)
lib=$(dirname "$0")

. $lib/lot.sh

get_param(){
  if [ "$1" == "txt" ]; then
	if [ -n "$3" ]; then
		printf "%s" "$txt" | lot word "$2" "$3" =
	else
		printf "%s" "$txt" | lot word "$2" =
	fi
  else
	if [ -n "$3" ]; then
		printf "%s" "$rec" | lot word "$2" "$3" =
	else
		printf "%s" "$rec" | lot word "$2" =
	fi
  fi
}
get_1(){
  S=$(printf "%s" "$sta" | lot line $1)
  if [ "${S:0:1}" == '#' ]; then V=0; else V=1; fi
  printf "%s" "$V"
  if [ $1 == httpd ]; then
	V=$(printf "%s" "$S" | lot word -p)
	printf "\t%s" "$V"
  fi
}
get_1s(){
  V=0
  N_3=$(printf "%s" "$sta" | sed -n "/$1/=")
  if [ $N_3 -ge 1 ]; then
	local S=$(printf "%s" "$sta" | sed -n "${N_3} s/$1/$1/p")
	if [ "${S:0:1}" != '#' ]; then V=1; fi
  fi
  printf "%s" "$V"
}
get_opt(){
  add=/mnt/sdcard/ark-add-on
  if [ ! -f "$add/opts.ini" ]; then
	printf "%s\n" "app=MPC" > $add/opts.ini
	sync
  fi
  opt=$(cat $add/opts.ini | lot word $1 =)
  if [ -z "$opt" ]; then opt=MPC; fi
  printf "$opt"
}

printf "\t%s" "$(get_param txt '\[CONST_PARAM' rtsp)" "$(get_1s 'telnetd ')" "$(get_1s ' ftpd ')" "$(get_param rec '\[RECORDPARAM' RecordTime)" "$(get_opt app)" "$(get_1s offline.sh)" "$(get_1 httpd)"
