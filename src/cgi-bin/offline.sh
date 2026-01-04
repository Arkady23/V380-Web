#!/bin/sh
 if [ $# -ge 1 ]; then
	sleep $1
 fi
 pkill -f eventhub_core
 pkill -f as9ipcwatchdog
 pkill -f as9updatednsip
 pkill -f as9nvserver
 pkill -f udp_broadcast
 pkill -f vsipbroadcast
