#!/bin/sh

lot(){
  local N=0
  local L=0
  local L1=0
  local L2=0
  local L3=0
  local EF=0
  local REPL
  local lin
  line=""; befor=""; after=""; word=""
  while [ $L == 0 ]; do
      if ! read -r; then
		EF=1
	fi
	N=$(($N+1))
	lin="$REPLY"
	if [ $L1 == 0 ]; then
		REPL="${REPLY#*$2}"
		if [ "$REPLY" != "$REPL" ]; then
			befor="$2"
			L1=1; REPLY="$REPL"
			if [ $# == 2 ]; then
				L=1; L2=1; L3=1
			fi
		fi
	fi
	if [ $L1 != 0 -a $L2 == 0 ]; then
		REPL="${REPLY#*$3}"
		if [ "$REPLY" != "$REPL" ]; then
			befor="$3"
			L2=1; REPLY="$REPL"
			if [ $# == 3 ]; then
				L=1; L3=1
			fi
		fi
	fi
	if [ $L1 != 0 -a $L2 != 0 -a $L3 == 0 ]; then
		REPL="${REPLY#*$4}"
		if [ "$REPLY" != "$REPL" ]; then
			befor="$4"
			L3=1; REPLY="$REPL"
			L=1
		fi
	fi
	if [ $L != 0 ]; then
		L3=$((${#lin}-${#REPLY}-${#befor}))
		befor="${lin:0:$L3}"
		line="$lin"
		after="$REPLY"
		word=$(printf $REPLY)
	fi
	if [ $EF != 0 ]; then
		if [ $L == 0 ]; then
			L=1
			N=0
		fi
	fi
  done

  case $1 in
	"word")  printf "%s" "$word" ;;
	"after") printf "%s" "$after" ;;
	"befor") printf "%s" "$befor" ;;
	*) printf "%s" "$line" ;;
  esac
exit $N
}
