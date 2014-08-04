#!/bin/bash

declare -A video
declare -A audio
#Make a newline a delimiter instead of a space
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

source /home/pi/mediaconfig.txt
 #if [[ $numerotracce -eq 1 ]]; then
  #  FILES=/media/USB/musicaevideo/
 #fi

selettore=0

#echo $numerotracce

#inizio parte video

FILESv=/media/USB/medialooper/video/
cntvideo=0
for f in `ls "--sort=none" $FILESv | grep ".mp4$\|.avi$\|.mkv$\|.mov$\|.flv$\|.m4v$"`
do
        video[$cntvideo]="$f"
        let cntvideo+=1

done
maxvideo=$cntvideo
cntvideo=0

#fine parte video



#inizio parte audio

FILESa=/media/USB/medialooper/musica/
cntaudio=0
for f in `ls  $FILESa | grep ".mp3$" | shuf `
do
        audio[$cntaudio]="$f"
        let cntaudio+=1

done
maxaudio=$cntaudio
cntaudio=0

#fine parte audio

#Reset the IFS
IFS=$SAVEIFS


while true; do

if [ $selettore -gt $NUMEROTRACCE ]
  then selettore=0
fi

if pgrep omxplayer > /dev/null
then
echo "running"
else



 	if [ $selettore -eq "0" ]
		then
			if [ $cntvideo -ge $maxvideo ]
			then
			cntvideo=0
			fi

		/usr/bin/omxplayer -z -o hdmi "$FILESv${video[$cntvideo]}"

		let cntvideo+=1
		selettore=`expr $selettore + 1`
		#echo $selettore

	else
		if [ $cntaudio -ge $maxaudio ]
		then
		cntaudio=0
		fi

	#	/usr/bin/omxplayer -r  -o hdmi "$FILESa${audio[$cntaudio]}"
		/usr/bin/mpg321 "$FILESa${audio[$cntaudio]}"
		let cntaudio+=1
		selettore=`expr $selettore + 1`
	#echo $selettore
	fi

sleep 2
fi
done
