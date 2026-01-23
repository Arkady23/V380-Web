#!/usr/bin/awk -f

BEGIN {
  FS=";"
  tz_offset=tz=lang=cs=pi=0
  fs="/mnt/sdcard/ark-add-on/opts.ini"
  ARGV[ARGC]="/mnt/mtd/mvconf/ntp.ini"; ARGC++
  if ((getline < fs) > 0) { ARGV[ARGC]=fs; ARGC++ }
}
{
  nf=0
  s0=$1; sub(/^[ \t]+/, "", s0); sub(/[ \t]+$/, "", s0); if(length(s0) > 0) {
  if (split(s0, af, "=") > 1) { nf=2; sub(/^[ \t]+/,"",af[2]) } else { nf=1 }
  sub(/[ \t]+$/,"",af[1]) }
  if(nf>0) {
	if (ARGIND == 1) {
		if (pi == 1) {
			if (substr(af[1],1,1) == "[" ) pi=2
			else if (nf>1) {
				if (af[1] == "tz_offset") tz_offset=af[2]
				else if (af[1] == "tz") tz=af[2]
			}
		} else if (af[1] == "[TIMEZONE]") pi=1
	} else if (ARGIND > 1) if (nf>1) {
		if (af[1] == "lang") lang=af[2]
		else if (af[1] == "cs") cs= af[2]
	}
  }
}
function print1(s) {
	if (s0 != s) {
		printf "\t" s
		s0=s
	}
}
function print2(s) {
	if (s0 != s) {
		if (substr(s,1,1) != "2") s=td
		printf "\t" s
		s0=s
	}
}
END {
  printf "Content-Type: text/plain\r\n\r\n" lang
  if (cs) {
    if (ENVIRON["HTTP_COOKIE"] == cs ) cs=FS
  } else cs=FS
  if (cs == FS) {
	s0="-"
	cmd = "/mnt/sdcard/RecFiles/recoredindex.ini"
	if ((getline < cmd) > 0) {
		td=strftime("%Y%m%d",mktime(strftime("%Y %m %d ") (strftime("%H")+tz) " " (strftime("%M")+tz_offset) " 0"))
		close(cmd)
	} else td=strftime("%Y%m%d")
	cmd="cd /mnt/sdcard/RecFiles"
	if (ENVIRON["QUERY_STRING"]) {
		printf "\tfolder\t" ENVIRON["QUERY_STRING"] "\t" tz "\t" tz_offset
		if (ENVIRON["QUERY_STRING"] == td) {
			cmd= cmd " && ls -t *.avi " td "/*/*.avi"
			while ((cmd | getline) > 0) {
				if (substr($0,1,1)=="2") t=substr($0,10)
				else {
					t=substr($0, index($0,"_")+1, 8)
					if (t == td || substr(t,1,1) != "2") t= "/" $0
					else t= ""
				}
				if (t) print1(t)
			}
		} else {
			cmd= cmd " && ls -t " ENVIRON["QUERY_STRING"] "/*/*.avi"
			while ((cmd | getline) > 0) print1(substr($0,10))
		}
	} else {
		cmd= cmd " && ls -dr *.avi [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]"
		while ((cmd | getline) > 0)
			print2(length($0)>8? substr($0,index($0,"_")+1,8): $0)
	}
  } else printf "\tpass\t" cs
}