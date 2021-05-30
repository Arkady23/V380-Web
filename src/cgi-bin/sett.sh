#!/bin/sh

printf "Content-Type: text/html\r\n\r\n"
printf "\t%s" "sett"

txt=$(cat /mnt/mtd/mvconf/factory_const.ini)
sta=$(cat /mnt/sdcard/ark-add-on/startup.sh)
lib=$(dirname "$0")

. $lib/lot.sh

get_param(){
  if [ -n "$2" ]; then
	printf "%s" "$txt" | lot word $1 $2 =
  else
	printf "%s" "$txt" | lot word $1 =
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
get_app(){
  add=/mnt/sdcard/ark-add-on
  if [ -f "$add/opts.ini" ]; then
	app=$(cat $add/opts.ini | lot word app =)
  else
	printf "%s\n" "app=MPC" > $add/opts.ini
	app=MPC
  fi
  printf "$app"
}

printf "\t%s\t%s\t%s\t%s" "$(get_param CONST_PARAM rtsp)" "$(get_1 telnetd)" "$(get_app)" "$(get_1 httpd)"
