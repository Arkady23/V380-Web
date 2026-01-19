BEGIN {
  FS=";"
  app="VLC"
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
		if (af[1] == "app") {
			app=af[2]; if (! var) exit
		} else if (af[1] == "cs") cs= af[2]
		else if (af[1] == "lang") lang=af[2]
	}
  }
}
END {
  printf app tz_offset "=" tz
  if (var) printf " " lang cs
}
