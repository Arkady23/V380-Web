#!/bin/sh

printf "Content-Type: text/html\r\n\r\n"

sd=/mnt/sdcard
cd $sd

get_ip(){
  local ip=$HTTP_X_FORWARDED_FOR
  if [ -z "$ip" ]; then
	ip=$HTTP_CLIENT_IP
	if [ -z "$ip" ]; then
		ip=$REMOTE_ADDR
	fi
  fi
  echo "$ip"
}
updir(){
  i=1
  ls -l $sd/$1 | while read f ; do
	if [ $i == 1 ]; then
		i=2
	else
		if [ ${f:0:1} != d ]; then
			tftp -l $1/${f:57}.u -r $1/${f:57} -g $ip
			if [ -f "$1/${f:57}.u" ]; then
				printf "<br> %s" "$1/${f:57}"
				c=$(cmp $1/${f:57}.u $1/${f:57})
				if [ -n "$c" ]; then
					printf " *"
					mv -f $1/${f:57}.u $1/${f:57}
				else
					rm -f $1/${f:57}.u
				fi
			else
				printf "<br> %s" "$1/${f:57} could not load"
			fi
		fi
	fi
  done
}
put_avi(){
  for h in `ls -r $1 | grep avi`; do
	printf "<br> %s" "$1/$h"
	tftp -l $1/$h -r RecFiles/$h -p $ip
	printf " *"
  done
}

ip=$(get_ip)
ip1=$(route -n | awk 'NR==3{print $2}')

if [ ${ip:0:8} != ${ip1:0:8} ]; then
  ip=""
else
  tftp -l ark-add-on/test -r cgi-bin/test.sh -g $ip
  if [ -f "ark-add-on/test" ]; then
	rm -f ark-add-on/test
  else
	ip=""
  fi
fi

if [ -n "$ip" ]; then
  printf "Viewing files:"
  if [ -n "$QUERY_STRING" ]; then
	if [ ${QUERY_STRING:0:1} == / ]; then
		printf "<br> %s" "Error into QUERY_STRING"
	elif [ ${QUERY_STRING:0:1} == - ]; then
		if [ -f "${QUERY_STRING:1}" ]; then
			rm -f ${QUERY_STRING:1}
			printf "<br> %s" "File ${QUERY_STRING:1} removed"
			rmdir `dirname ${QUERY_STRING:1}`
		elif [ -d "${QUERY_STRING:1}" ]; then
			rm -fr ${QUERY_STRING:1}
			printf "<br> %s" "Folder ${QUERY_STRING:1} removed"
		fi
	elif [ ${QUERY_STRING:0:8} == RecFiles ]; then
		cd RecFiles
		if [ ${#QUERY_STRING} -gt 9 ]; then
			f=${QUERY_STRING:9}
		else
			set -- `ls -r`
			f=$1
		fi
		if [ ${#f} -gt 9 ]; then
			put_avi $f
		else
			for g in `ls -r $f`; do
				put_avi ${f:0:8}/$g
			done
		fi
	else
		if [ -d "$QUERY_STRING" ]; then
			updir $QUERY_STRING
		else
			tftp -l tmp.u -r $QUERY_STRING -g $ip
			mkdir -p `dirname $QUERY_STRING`
			printf "<br> %s" "$QUERY_STRING"
			mv tmp.u $QUERY_STRING
			printf " *"
		fi
	fi
  else
	updir ark-add-on
	updir cgi-bin
	updir .
  fi
  printf "<br> ="
else
  printf "The tftp server is not running"
fi
