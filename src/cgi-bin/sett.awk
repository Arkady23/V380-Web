BEGIN {
  FS=";"
  port=80
  app="VLC"
  ir="irfeed_lock_state"
  fr="/mnt/mtd/mvconf/record.ini"
  fs="/mnt/sdcard/ark-add-on/opts.ini"
  ft="/mnt/mtd/mvconf/factory_const.ini"
  fu="/mnt/sdcard/ark-add-on/startup.sh"
  rtsp=tel=ftp=http=cp=rp=r1=r2=r3=r4=0
  off=ssid=psk=lang=cs=""
  wifi="\t\t"
}
{
  nf=0
  fl = substr(FILENAME, length(FILENAME)-4)
  s0=$1; sub(/^[ \t]+/, "", s0); sub(/[ \t]+$/, "", s0)
  if (length(s0) > 0) {
	if (split(s0, af, "=") > 1) {
		nf=2; sub(/^[ \t]+/, "", af[2])
	} else { nf=1 }
	sub(/[ \t]+$/, "", af[1])
  }
  if (fl == "t.ini") {
	if (cp == 1) {
		if (substr(af[1],1,1) == "[") {
			cp=2; nextfile
		} else {
			if (substr(af[1],1,4) == "rtsp") rtsp = af[2]
			else if (af[1] == ir) ir = af[2]
		}
	} else if (cp == 0) {
		if (af[1] == "[CONST_PARAM]") cp=1
	}
  } else if(fl == "up.sh") {
	if (index(s0, "telnetd ")>0) tel = func1()
	else if (index(s0, "ftpd ")>0) ftp = func1()
	else if (index(s0, "/offline.sh")>0) off = func1()
	else if (index(s0, "httpd ")>0) http = func1() "\t" func2(port,4)
	else if (index(s0, "/wifi.sh")>0) wifi = func1() "\t" func2(ssid,2) "\t" func2(psk,3)
  } else if(fl == "s.ini") {
	if (af[1] == "lang") lang = af[2]
	else if (af[1] == "cs") cs = af[2]
	else if (af[1] == "app") app = af[2]
  } else if(fl == "d.ini") {
	if (rp == 1) {
		if (substr(af[1],1,1) == "[") {
				rp=2; nextfile
		} else {
			if (af[1] == "RecordSyncAudio") r1 = af[2]
			else if (af[1] == "RecordTime") r2 = af[2]
			else if (af[1] == "enAlarmRecord") r3 = af[2]
			else if (af[1] == "enSpontaneousRecord") r4 = af[2]
		}
	} else if (rp == 0) {
		if (af[1] == "[RECORDPARAM]") rp=1
	}
  }
}
function func1() {
  return substr(s0,1,1)=="#"? 0:1
}
function func2(s, j) {
	split(substr(s0,2), aw, " ")
	if(j in aw) if(aw[j] != "&") s=aw[j]
	delete aw
  return s
}
END {
  printf lang "\tsett\t" r4 "\t" r3 "\t" r1 "\t" rtsp "\t" tel "\t" ftp "\t" r2 "\t" ir "\t" app "\t" off "\t" wifi "\t" http "\t" cs
}