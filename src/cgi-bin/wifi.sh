#!/bin/sh

lib=$(dirname "$0")
. $lib/lot.sh

wf=/mnt/mtd/mvconf/wifi.ini
add=/mnt/sdcard/ark-add-on
fl=$add/startup.sh

txt=$(cat $fl)
V1=$(printf "%s" "$txt" | lot line 'wifi.sh ')
N1=$?

if [ $# -gt 1 ]; then

  wfi=$(cat $wf)
  old1=$(printf "%s" "$wfi" | lot word "\[STATION" stationssid =)
  N_1=$?
  old2=$(printf "%s" "$wfi" | lot word "\[STATION" stationpwd =)
  N_2=$?

  if [ -n "$old1" -a -n "$old2" ]; then

	L=""
	if [ $1 != $old1 ]; then
		sed -i "${N_1} s/\(\s*=\s*\).*$/\1$1/" $wf
		L=1
	fi
	if [ $2 != $old2 ]; then
		sed -i "${N_2} s/\(\s*=\s*\).*$/\1$2/" $wf
		L=2
	fi

	if [ -n "$L" ]; then
		if [ -n "$V1" ]; then
			if [ "${V1:0:1}" != '#' ]; then
				sed -i "${N1} s/^/\#/" $fl
			fi
		else
			printf "%s\n" "# \$sd/cgi-bin/wifi.sh $1 $2 &" >> $fl
		fi
		sync
		$lib/ip.sh 61 &
	fi
  fi
fi
