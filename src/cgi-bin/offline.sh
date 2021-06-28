#!/bin/sh
 if [ $# == 1 ]; then
	sleep $1
 fi
 killall -9 eventhub_core
 killall -9 as9ipcwatchdog
 killall -9 as9updatednsip
 killall -9 as9nvserver
 killall -9 udp_broadcast
 killall -9 vsipbroadcast
