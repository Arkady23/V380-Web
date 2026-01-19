BEGIN {
FS=";"
ssid=pwd=""
li=lu=ni=nu=si=0
wf="/mnt/mtd/mvconf/wifi.ini"
sf="/mnt/sdcard/ark-add-on/startup.sh"
ARGV[ARGC]=sf; ARGC++
ARGV[ARGC]=wf; ARGC++
}
{
  nf=0
  s0=$1; sub(/^[ \t]+/, "", s0); sub(/[ \t]+$/, "", s0); if(length(s0) > 0) {
  if (split(s0, af, "=") > 1) { nf=2; sub(/^[ \t]+/,"",af[2]) } else { nf=1 }
  sub(/[ \t]+$/,"",af[1]) }
  if (ARGIND > 1) {
	ni++
	ai[FNR] = $0
	if (si == 1) {
		if(nf>0) {
			if (substr(af[1],1,1) == "[") {
				si=2
			} else {
				if (af[1] == "stationssid") func2(ssid)
				else if (af[1] == "stationpwd") func2(pwd)
			}
		}
	} else if (si == 0) {
		if (af[1] == "[STATION]") si=1
	}
  } else if (ARGIND == 1) {
	if(nf>0) {
		i = index($0,"/wifi.sh")
		if (i>0) {
			if (substr(s0,1,1) != "#") {
				s0 = substr($0, i+9); sub(/^[ \t]+/, "", s0)
				split(s0, aw, " "); ssid = aw[1]; pwd = aw[2]
				lu = 1
			}
		}
	}
  }
}
function func2 (z) {
  if (lu && af[2] != z) {
	li=1; ai[FNR] = af[1] "=" z
  }
}
END {
  if (li) {
	for (i = 1; i <= ni; i++) print ai[i] > wf
	printf 1
  }
}
