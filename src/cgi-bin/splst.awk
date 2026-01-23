#!/usr/bin/awk -f

BEGIN {
  FS=";"
  app="VLC"
  tz_offset=tz=lang=cs=pi=dl=0
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
		if (af[1] == "app") { app=af[2]; exit }
	}
  }
}
function titl(f) {
	t=substr(f,index(f,"_")+1)
	if (v1) s= substr(t,9,2) " " substr(t,11,2)
	else s= (substr(t,9,2)+tz) " " (substr(t,11,2)+tz_offset)
	return strftime("%d-%m-%Y %H:%M", mktime(substr(t,1,4) " " substr(t,5,2) " "substr(t,7,2) " " s " 0"))
}
function print1(s) {
	dl+=length(s)+1
	printf s "\n" > fl
}
function print2(f){
	print3(substr(td,7,2) "-" substr(td,5,2) "-" substr(td,1,4) " Video recording is open",f)
}
function print3(t,f) {
  if (substr(f,1,1) != "/") f= "/" ENVIRON["QUERY_STRING"] "/" f
  if (app == "VLC") {
	print1("\t\t<track>")
	print1("\t\t\t<location>http://" ip "/RecFiles" f "</location>")
	print1("\t\t\t<title>" t "</title>")
	print1("\t\t\t<extension application='http://www.videolan.org/vlc/playlist/0'>")
	print1("\t\t\t\t<vlc:id>" N "</vlc:id>")
	if (! N) print1("\t\t\t\t<vlc:option>network-caching=1000</vlc:option>")
	print1("\t\t\t</extension>")
	print1("\t\t</track>")
	N++
  } else {
	N++
	print1(N ",type,0")
	print1(N ",label," t)
	print1(N ",filename,http://" ip "/RecFiles" f)
  }
}
function print4(f){
	if (! N) if (substr(f,1,1) == "/") if (substr(t,1,1) != "2") {
		print2(f)
		return
	}
	print3(titl(f),f)
}
END {
  N=ip=v1=0
  cmd = "/mnt/sdcard/RecFiles/recoredindex.ini"
  if ((getline < cmd) > 0) {
	td=strftime("%Y%m%d",mktime(strftime("%Y %m %d ") (strftime("%H")+tz) " " (strftime("%M")+tz_offset) " 0"))
	close(cmd)
	v1=1
  } else td=strftime("%Y%m%d")
  if (ENVIRON["QUERY_STRING"] == td)
	cmd="cd /mnt/sdcard/RecFiles && ifconfig wlan0 && ls -r *.avi " td "/*/*.avi"
  else
	cmd="cd /mnt/sdcard/RecFiles && ifconfig wlan0 && ls -r " ENVIRON["QUERY_STRING"] "/*/*.avi"
  while ((cmd | getline) > 0)
	if (substr($0,1,1) == " ") {
		if (! ip) {
			split(substr($0,index($0,":")+1), aw, " ")
			ip= aw[1]
			fn= ENVIRON["QUERY_STRING"] "_" ip "." (app == "VLC"? "xspf":"mpcpl")
			fl= "/tmp/" fn
			if (app == "VLC") {
				print1("<?xml version='1.0' encoding='UTF-8'?>")
				print1("<playlist xmlns='http://xspf.org/ns/0/' xmlns:vlc='http://www.videolan.org/vlc/playlist/ns/0/' version='1'>")
				print1("\t<trackList>")
			} else print1("MPCPLAYLIST")
		}
	} else if (ip && length($0)>1) {
		if (ENVIRON["QUERY_STRING"] == td) {
			if (substr($0,1,1)=="2") f=substr($0,10)
			else {
				t=substr($0, index($0,"_")+1, 8)
				if (t == td || substr(t,1,1) != "2") f= "/" $0
				else f= ""
			}
			if (f) print4(f)
		} else print4(substr($0,10))
	}
  if (app == "VLC") {
	print1("\t</trackList>")
	print1("\t<extension application='http://www.videolan.org/vlc/playlist/0'>")
	for (i=0; i < N; i++) print1("\t\t<vlc:item tid='" i "'/>")
	print1("\t</extension>")
	print1("</playlist>")
  }
  printf "Content-Type: text/plain\r\n"
  printf "Content-Disposition: attachment; filename=\"" fn "\"\r\n"
  printf "Content-Length: " dl "\r\n\r\n"
  cmd= "cat " fl " && rm " fl
  while ((cmd | getline) > 0) print
}