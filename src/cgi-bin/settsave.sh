#!/bin/sh

lib=$(dirname "$0")
. $lib/lot.sh

printf "Content-Type: text/html\r\n\r\n"
printf "\t%s" "setts"

#read POST_DATA
#PARAMS=$(echo "$POST_DATA" | tr "&" " ")
#for S in $PARAMS ; do
#done

fc=/mnt/mtd/mvconf/factory_const.ini
rc=/mnt/mtd/mvconf/record.ini
add=/mnt/sdcard/ark-add-on
fl=$add/startup.sh
fo=$add/opts.ini

rec=$(cat $rc)
fac=$(cat $fc)
txt=$(cat $fl)
ops=$(cat $fo)

N_1=$(printf "%s" "$fac" | sed -n "/\[CONST_PARAM\]/=")
N_3=$(($N_1+1))
N_3=$(printf "%s" "$fac" | sed -n "$N_3,\$p" | sed -n "/\[/=" | head -n 1)
N_2=$(($N_1+$N_3))
N_3=$(($N_2-1))

lin=$(printf "%s" "$fac" | sed -n "${N_3}p")
if [ -z "$lin" ]; then
  N_2=$N_3
  N_3=$(($N_2-1))
  lin=$(printf "%s" "$fac" | sed -n "${N_3}p")
  if [ -z "$lin" ]; then
	N_2=$N_3
  fi
fi

SAVE_01(){
  par=$(printf "%s" "$fac" | sed -n "${N_1},${N_2} s/$1/$1/p" | lot word =)
  if [ -z "$par" ]; then
	V="0"
  else
	V="$par"
  fi
  if [ "$V" != "$2" ]; then
	if [ -z "$par" ]; then
		sed -i "${N_2}i $1=$2" $fc
		N_2=$(($N_2+1))
	else
		opts=$(printf "%s" "$fac" | sed -n ${N_1},${N_2}p)
		N_3=$(printf "%s" "$opts" | sed -n "/$1/=")
		sed -i "${N_3} s/\(\s*=\s*\).*$/\1$2/" $fc
	fi
  fi
}
SAVE_1(){
  lin=$(printf "%s" "$txt" | lot line "$1")
  N_3=$?
  if [ -n "$lin" ]; then
	if [ "$1" == "wifi.sh" ]; then
		if [ $2 == 0 ]; then V='#'; else V=''; fi
		if [ "${lin:0:1}" != "$V" -o "$(printf "%s" "$lin" | lot after "$1")" != " $3 $4 &" ]; then
			sed -i "${N_3} s/.*/$V \$sd\/cgi-bin\/$1 $3 $4 \&/" $fl
		fi
	else
		if [ "${lin:0:1}" != "#" ]; then V=1; else V=0; fi
		if [ $2 != $V ]; then
			if [ $2 == 1 ]; then
				sed -i "${N_3} s/^.//" $fl
			else
				sed -i "${N_3} s/^/\#/" $fl
			fi
		fi
	fi
  else
	if [ "$2" == "1" -o -n "$3" -o -n "$4" ]; then
		if [ "$1" == "offline.sh" ]; then
			printf "%s\n" " \$sd/cgi-bin/$1 5 &" >> $fl
		elif [ "$1" == "wifi.sh" ]; then
			printf "%s\n" "# \$sd/cgi-bin/$1 $3 $4 &" >> $fl
		fi
	fi
  fi
}
SAVE_TIME(){
  lin=$(printf "%s" "$rec" | lot word "\[RECORDPARAM" RecordTime =)
  N_3=$?
  if [ -n "$lin" ]; then
	if [ "$1" != "$lin" ]; then
		sed -i "${N_3} s/$lin/\1$1/" $rc
	fi
  fi
}
SAVE_opt(){
  lin=$(printf "%s" "$ops" | lot word $1 =)
  N_3=$?
  if [ -n "$lin" ]; then
	lin=$(printf "${lin#*=}" | (read -r w1 w2; printf "$w1"))
	if [ "$2" != "$lin" ]; then
		sed -i "${N_3} s/^\($1\s*=\s*\).*$/\1$2/" $fo
	fi
  else
	printf "%s\n" "$1=$2" >> $fo
  fi
}


 SAVE_01 rtsp ${QUERY_STRING:0:1}

 SAVE_1 "telnetd " ${QUERY_STRING:1:1}

 SAVE_1 " ftpd " ${QUERY_STRING:2:1}

 Q=${QUERY_STRING%%+*}
 SAVE_TIME ${Q:3}
 Q=${QUERY_STRING#*+}

 SAVE_01 irfeed_lock_state ${Q:0:1}

 SAVE_opt app ${Q:1:3}

 SAVE_1 offline.sh ${Q:4:1}

 p1=${Q:5:1}
 Q=${Q:6}
 p2=${Q%%+*}
 Q=${Q#*+}
 SAVE_1 wifi.sh $p1 $p2 ${Q%%+*}
 Q=${Q#*+}

 SAVE_1 httpd ${Q:0:1}
 p1=$(printf "%s" "$lin" | lot word -p)
 V=${Q%%+*}
 Q=${Q#*+}

 if [ $N_3 -gt 1 ]; then
	V=${V:1}
	if [ $V -lt 1 ]; then
		V=80
	elif [ $V -gt 65535 ]; then
		V=80
	fi
	if [ $V != $p1 ]; then
		sed -i "${N_3} s/$p1/$V/" $fl
	fi
 fi

 SAVE_opt lang "${Q:0:1}"
 if [ "${Q:1}" != "1" ]; then
	SAVE_opt cs "${Q:1}"
 fi
