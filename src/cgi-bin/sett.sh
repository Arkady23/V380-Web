#!/bin/sh

printf "Content-Type: text/html\r\n\r\n"

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
  local S=$(printf "%s" "$sta" | lot line $1)
  if [ -n "$S" -a "${S:0:1}" != '#' ]; then V=1; else V=0; fi
  printf "%s" "$V"
  if [ $1 == httpd ]; then
	V=$(printf "%s" "$S" | lot word -p)
	printf "\t%s" "$V"
  elif [ $1 == wifi.sh ]; then
	V=$(printf "%s" "$S" | lot word $1)
	printf "\t%s" "$V"
	V=$(printf "%s" "$S" | lot word $V)
	printf "\t%s" "$V"
  fi
}
get_opt(){
  add=/mnt/sdcard/ark-add-on
  if [ ! -f "$add/opts.ini" ]; then
	printf "%s\n" "app=MPC" > $add/opts.ini
	sync
  fi
  opt=$(cat $add/opts.ini | lot word $1 =)
  if [ -z "$opt" -a "$1" == "app" ]; then opt=MPC; fi
  printf "$opt"
}

printf "%s\t%s" "$(get_opt lang)" "sett"
printf "\t%s" "$(get_param txt '\[CONST_PARAM' rtsp)" "$(get_1 'telnetd &')" "$(get_1 ' ftpd ')" "$(get_param rec '\[RECORDPARAM' RecordTime)" "$(get_param txt '\[CONST_PARAM' irfeed_lock_state)" "$(get_opt app)" "$(get_1 offline.sh)" "$(get_1 wifi.sh)" "$(get_1 httpd)" "$(get_opt cs)"
