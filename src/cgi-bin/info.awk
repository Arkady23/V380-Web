BEGIN {
si=0;
FS=";"
cpu=arh=appv=appv2=hwv=hwv2=hw=vs=up=lo=""
}
{
  nf=0
  fl = substr(FILENAME,1,4); s0=$1; sub(/^[ \t]+/, "", s0); sub(/[ \t]+$/, "", s0)
  if(length(s0) >0) { if (split(s0,af,"[=:]") > 1) { nf=2; sub(/^[ \t]+/,"",af[2])
  } else { nf=1 } sub(/[ \t]+$/,"",af[1])}
  if(nf>0) {
	if(nf>1) {
		if (fl == "/mnt") {
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
		else if (fl != "/mnt") {
			if (si == 4 ) {
				split(s0, aw, " ")
				lo= sprintf("\t%s",aw[1] " " aw[2] " " aw[3])
			} else {
				si=4; split(s0, aw, " "); up= sprintf("\t%.1fh",aw[1]/3600)
			}
		}
	}
  }
}
END {
  printf "\t" hw "\t" cpu "\t" arh "\t" vs "\t" hwv "&emsp;" hwv2 "\t" appv "&emsp;" appv2 up lo
}
