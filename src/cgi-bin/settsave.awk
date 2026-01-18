BEGIN {
  FS=";"
  vlc="VLC"
  rtsp="rtsp"
  split(qs, aq, "+")
  ir="irfeed_lock_state"
  fv="/mnt/mtd/nvipcstart.sh"
  fr="/mnt/mtd/mvconf/record.ini"
  cam=kt=ks=ku=nr=ns=nt=nu=nv=cp=rp=0
  fs="/mnt/sdcard/ark-add-on/opts.ini"
  ft="/mnt/mtd/mvconf/factory_const.ini"
  fu="/mnt/sdcard/ark-add-on/startup.sh"
  t2=t21=substr(aq[2],1,1)
  s1=s11=substr(aq[2],2,3)
  s2=s21=substr(aq[5],1,1)
  u4=u41=substr(aq[2],5,1)
  u5=u51=substr(aq[2],6,1)
  s3=s31=substr(aq[5],2)
  t1=t11=substr(qs,4,1)
  ssid=substr(aq[2],7)
  u3=substr(aq[4],1,1)
  port=substr(aq[4],2)
  r2=substr(aq[1],7)
  r1=substr(qs,3,1)
  r3=substr(qs,2,1)
  r4=substr(qs,1,1)
  u1=substr(qs,5,1)
  u2=substr(qs,6,1)
  uv= u4>0? 0:1
  psk=aq[3]
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
	nt++
	at[FNR] = $0
	if (cp == 1) {
		if(nf==0) {
			kt=nt
		} else {
			if (substr(af[1],1,1) == "[") {
				if(kt==0) kt=nt
				cp=2;
			} else {
				if (substr(af[1],1,4) == "rtsp") {
					if (func3(t1)) { at[FNR] = af[1] "=" t1; t1 = -1 }
					t11 = -1
				} else if (af[1] == ir) {
					if (func3(t2)) { at[FNR] = af[1] "=" t2; t2 = -1 }
					t21 = -1
				}
			}
		}
	} else if (cp == 0) {
		if (af[1] == "[CONST_PARAM]") cp=1
	}
  } else if(fl == "up.sh") {
	nu++
	au[FNR] = $0
	if(nf==0) {
		ku=nu
	} else {
		if (index(s0, "telnetd ")>0) {
			if(func1(u1)) { au[FNR] = func0(u1); u1 = -1 }
		} else if (index(s0, "ftpd ")>0) {
			if(func1(u2)) { au[FNR] = func0(u2); u2 = -1 }
		} else if (index(s0, "httpd ")>0) {
			if(func1(u3) || func2(port,4)) {
				 au[FNR] = funcR(func0(u3),port,4)
				 u3 = -1
			}
		} else if (index(s0, "/offline.sh")>0) {
			if(func1(u4)) { au[FNR] = func0(u4); u4 = -1 }
			u41 = -1
		} else if (index(s0, "/wifi.sh")>0) {
			if(func1(u5) || func2(ssid,2) || func2(psk,3)) {
				u5 = func0(u5)
				u5 = substr(u5,1,index(u5, ".sh")+2)
				psk = psk? psk " &": "&"
				ssid = ssid? " " ssid: ""
				au[FNR] = u5 ssid " " psk
				u5 = -1
			}
			u51 = -1
		}
	}
  } else if(fl == "s.ini") {
	ns++
	as[FNR] = $0
	if(nf==0) {
		ks=nt
	} else {
		if (af[1] == "cam") {
			if(nf>1) if(af[2]>0) rtsp="rtsp_enable"
		} else if (af[1] == "lang") { if(func3(s2)) { as[FNR] = af[1] "=" s2; s2 = -1 }
			s21 = -1
		} else if (af[1] == "app") { if(func3(s1)) { as[FNR] = af[1] "=" s1; s1 = "-" }
			s11 = "-"
		} else if (af[1] == "cs") { if(func3(s3)) { as[FNR] = af[1] "=" s3; s3 = -1 }
			s31 = -1
		}
	}
  } else if(fl == "d.ini") {
	nr++
	ar[FNR] = $0
	if (nf>0) {
		if (rp == 1) {
			if (substr(af[1],1,1) == "[") {
				rp=2;
			} else {
				if (af[1] == "RecordSyncAudio") {
					if(func3(r1)) { ar[FNR] = af[1] "=" r1; r1 = -1 }
				} else if (af[1] == "RecordTime") {
					if(func3(r2)) { ar[FNR] = af[1] "=" r2; r2 = -1 }
				} else if (af[1] == "enAlarmRecord") {
					if(func3(r3)) { ar[FNR] = af[1] "=" r3; r3 = -1 }
				} else if (af[1] == "enSpontaneousRecord") {
					if(func3(r4)) { ar[FNR] = af[1] "=" r4; r4 = -1 }
				}
			}
		} else if (rp == 0) {
			if (af[1] == "[RECORDPARAM]") rp=1
		}
	}
  } else if(fl =="rt.sh") {
	nv++
	av[FNR] = $0
	if (nf>0) {
		if (index(s0, "apps/log_")>0) {
			if(func1(uv)) { av[FNR] = func0(uv); uv = -1 }
		}
	}
  }
}
function funcR(t, s, j) {
	split(substr(s0,2), aw, " ")
	if (j in aw) sub("("aw[j]")", s, t)
	if (aw[j] == "&") t = t " &"
  return t
}
function func0(s) {
	if(substr(s0,1,1)=="#") {
		return s>0? substr($0,2): $0
	} else {
		return s>0? $0: "#" $0
	}
}
function func1(s) {
	i= substr(s0,1,1)=="#"? 0:1
	if(i != s) return 1
  return 0
}
function func2(s, j) {
	split(substr(s0,2), aw, " ")
	if (j in aw) if(aw[j] != s) { delete aw; return 1}
	delete aw
  return 0
}
function func3(s) {
  if (s >= 0) {
	if (nf > 1) {
		if (af[2] != s) return 1
	} else return 1
  }
  return 0
}
function print1(p, s, f) {
	if (s > 0) print p "=" s >> f
}
function print2() {
	print1(rtsp, t11, ft)
	print1(ir, t21, ft)
	t11=t21= -1
}
function print3() {
	if (s11 != "-") print "app=" s11 >> fs
	print1("lang", s21, fs)
	print1("cs", s31, fs)
	s21=s31= -1
	s11="-"
}
function print4() {
	if(u41 > 0) print " \$sd/cgi-bin/offline.sh 5 &" >> fu
	if(u51 >= 0 && ssid)
		print (u51==0? "#":"") " \$sd/cgi-bin/wifi.sh", ssid, (psk? psk " &":"&") >> fu
	u41=u51= -1
}
END {
  if(t11 > 0) t1 = -1
  if(t21 >= 0) t2 = -1
  if(t1<0 || t2<0) {
	for (i = 1; i <= nt; i++) {
		if(i==kt) print2()
		print at[i] > ft
	}
	print2()
  }
  if(r1<0 || r2<0 || r3<0 || r4<0) {
	for (i = 1; i <= nr; i++) print ar[i] > fr
  }
  if(uv<0) {
	for (i = 1; i <= nv; i++) print av[i] > fv
  }
  if(u41 > 0) u4 = -1
  if(u51 >= 0) u5 = -1
  if(u1<0 || u2<0 || u3<0 || u4<0 || u5<0) {
	for (i = 1; i <= nu; i++) {
		if(i==ku) print4()
		print au[i] > fu
	}
	print4()
  }
  if(s1 == s11 && s1 != vlc) s1 = "-"
  if(s21 > 0) s2 = -1
  if(s31 > 0) s3 = -1
  if(s1=="-" || s2<0 || s3<0) {
	for (i = 1; i <= ns; i++) {
		if(i==ks) print3()
		print as[i] > fs
	}
	print3()
  }
}
