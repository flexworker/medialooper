#!/bin/bash

declare -A video
declare -A audio
#Make a newline a delimiter instead of a space
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
#source /home/pi/mediaconfig.txt
source /home/flex/Scrivania/udate6agosto/test/mediaconfig.txt
selettore=0

#inizio parte video

#FILESv=/media/USB/medialooper/video/
FILESv=/home/flex/Video/
cntvideo=0
for f in `ls "--sort=none" $FILESv | grep ".mp4$\|.avi$\|.mkv$\|.mov$\|.flv$\|.m4v$"`
do
        video[$cntvideo]="$f"
        let cntvideo+=1

done
maxvideo=$cntvideo
cntvideo=0

#fine parte video
while true
   do	
   ora=`date +%k%M`
   if [ $SECONDA -le $ora ] && [ $TERZA -gt $ora ]
#seconda playlist
	then	
#inizio parte audio
		FILESa=/media/USB/medialooper/musica/seconda/
		SAVEIFS=$IFS
		IFS=$(echo -en "\n\b")
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
		z=0
	while [ $z -ne 1 ]; do
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
			else
				if [ $cntaudio -ge $maxaudio ]
					then
					cntaudio=0
				fi
				/usr/bin/mpg321 "$FILESa${audio[$cntaudio]}"
				let cntaudio+=1
				selettore=`expr $selettore + 1`
			fi
				ora=`date +%k%M`
			if [ $SECONDA -le $ora ] && [ $TERZA -gt $ora ]
				then
				z=0
				else
				z=1
			fi	
			sleep 2
		fi
	done
	else
#terza playlist	
       if [ $TERZA -le $ora ]
    	then
			SAVEIFS=$IFS
			IFS=$(echo -en "\n\b")
       		FILESa=/media/USB/medialooper/musica/terza/
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
			m=0
		while [ $m -ne 1 ]; do
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
				else
					if [ $cntaudio -ge $maxaudio ]
						then
						cntaudio=0
					fi
					/usr/bin/mpg321 "$FILESa${audio[$cntaudio]}"
					let cntaudio+=1
					selettore=`expr $selettore + 1`
				fi
				ora=`date +%k%M`
				if ! [ $TERZA -le $ora ]
					then
					p=1
				fi	
			sleep 2
			fi
		done
		else
#prima playlist		
			FILESa=/media/USB/medialooper/musica/prima/
			SAVEIFS=$IFS
			IFS=$(echo -en "\n\b")
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
			m=0
		while [ $m -ne 1 ]; do
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
				else
					if [ $cntaudio -ge $maxaudio ]
						then
						cntaudio=0
					fi
					/usr/bin/mpg321 "$FILESa${audio[$cntaudio]}"
					let cntaudio+=1
					selettore=`expr $selettore + 1`
				fi
				ora=`date +%k%M`
				if [ $SECONDA -le $ora ] 
					then
					m=1
				fi	
			sleep 2
			fi
		done
		fi
	fi		
done
exit
