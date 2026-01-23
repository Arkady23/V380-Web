#!/usr/bin/awk -f

BEGIN {
si=0;
FS=";"
cpu=arh=appv=appv2=hwv=hwv2=hw=vs=up=lo=""
ARGV[ARGC]="/mnt/mtd/mvconf/patchmanage.conf"; ARGC++
ARGV[ARGC]="/mnt/mtd/mvconf/version.ini"; ARGC++
ARGV[ARGC]="/proc/cpuinfo"; ARGC++
ARGV[ARGC]="/proc/loadavg"; ARGC++
ARGV[ARGC]="/proc/uptime"; ARGC++
}
{
  nf=0
  s0=$1; sub(/^[ \t]+/, "", s0); sub(/[ \t]+$/, "", s0); if (length(s0) >0) {
  if (split(s0,af,"[=:]") > 1) { nf=2; sub(/^[ \t]+/,"",af[2])} else { nf=1 }
  sub(/[ \t]+$/,"",af[1]) }
  if(nf>0) {
	if(nf>1) {
		if (ARGIND < 3) {
			if (si == 1) {
				if (af[1] == "hwname") hw = af[2]
				else if (af[1] == "version" ) vs = af[2]
			} else if (si == 2) {
				if (af[1] == "date") appv2 = af[2]
				else if (af[1] == "name") appv = af[2]
			} else if (si == 3) {
				if (af[1] == "date") hwv2 = af[2]
				else if (af[1] == "name") hwv = af[2]
			}
		} else if (af[1] == "Hardware") cpu = cpu "&emsp;" af[2]
		else if (af[1] == "CPU architecture") arh = af[2]
		else if (af[1] == "Processor") cpu = af[2]
	} else {
		if (af[1] == "[PATCH]") si=1
		else if (af[1] == "[app_version]") si=2
		else if (af[1] == "[hardware_version]") si=3
		else if (substr(af[1],1,1) == "[") si=0
		else if (ARGIND > 3) {
			if (si == 4 ) {
				split(s0, aw, " "); up= sprintf("\t%.1fh",aw[1]/3600)
			} else {
				split(s0, aw, " ")
				si=4; lo= sprintf("\t%s",aw[1] " " aw[2] " " aw[3])
			}
		}
	}
  }
}
END {
  printf "Content-Type: text/plain\r\n\r\n\tinfo"

  si=0
  cmd = "iwconfig wlan0 && df -h /mnt/mtd && df -h /mnt/sdcard && ifconfig wlan0 && route -n && free -m"
  while ((cmd | getline) > 0) {
	if (si == 0) {
		if (substr($0,1,1) == "w") {
			split($0, aw, "\""); si++
			printf "\t" hw "\t" strftime() "\t" cpu "\t" vs
		}
	} else if (si == 1) {
		i=index($0,"Qua")
		if (i > 0) {
			printf "\t" hwv "&emsp;" hwv2 "\t" aw[2]
			split(substr($0, i+8, 8), aw, "[/ ]"); si++
			st= sprintf("\t%d", 100*aw[1]/aw[2])
		}
	} else if (si == 2) {
		if (substr($0,1,1) == "t") {
			split($0, aw, " "); si++
			printf st "%%" "\t" aw[4]
		}
	} else if (si == 3) {
		if (substr($0,1,1) == "/") {
			split($0, aw, " "); si++
			printf "\t" aw[4]
		}
	} else if (si == 4) {
		if (substr($0,1,1) == "w") {
			split($0, aw, " "); si++
			printf lo "\t" aw[5]
		}
	} else if (si == 5) {
		split($0, aw, ":"); si++
		printf "\t" substr(aw[2], 1, index(aw[2], " ")-1) "\t" aw[4]
	} else if (si == 6) {
		if (index(substr($0,1,4), ".") > 0) {
			split($0, aw, " "); si++
			printf "\t" aw[2]
		}
	} else if (si > 6) {
		if (substr($0,1,1) == "M") {
			split($0, aw, " ")
			printf "\t" aw[4] " / " aw[2] "M" up "\t" appv "&emsp;" appv2 "\t" arh
			exit
		}
	}
  }
  close(cmd)
}