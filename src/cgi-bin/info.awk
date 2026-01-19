BEGIN {
si=0;
FS=";"
cpu=arh=appv=appv2=hwv=hwv2=hw=vs=up=lo=""
getline; split($0,aw,"\""); es=aw[2]; ARGC++
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
		if (ARGIND == 0) {
			if (substr(af[1],1,1) == "L") {
				i=index(af[2],"/")-1
				j=substr(af[2],i+2,index(af[2]," ")-i-2)
				i=substr(af[2],1,i)
				st = sprintf("\t%d",100*i/j)
			}
		} else if (ARGIND < 4) {
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
		else if (ARGIND > 4) {
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
  printf "\t" hw "\t" cpu "\t" arh "\t" vs "\t" hwv "&emsp;" hwv2 "\t" appv "&emsp;" appv2 up lo "\t" es st "%%"
}
