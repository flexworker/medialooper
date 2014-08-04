	source /home/pi/mediaconfig.txt
		if ! [ -s /home/pi/update/update.tar.gz ]
			then 
			echo "file iniziale" > /home/pi/update/update.tar.gz
			x=0
		else
			x=0
		fi
			if [ $SYNC -eq 1 ]
				then
				while [ $x -ne 1 ]
					do
					sleep 10	
					wget  --spider -N -P /home/pi/update/ --user=$USER --password=$PASS ftp://$HOST/$IND/medialooper/update/update.tar.gz > /dev/tty2
					aggiornamento="$?"
						if [ $aggiornamento -eq "0" ]
							then
     							wget -N -P /tmp --user=$USER --password=$PASS ftp://$HOST/$IND/medialooper/update/update.tar.gz > /dev/tty2
								diff -q /tmp/update.tar.gz /home/pi/update/update.tar.gz > /dev/tty1
								cambio="$?"
								if [ $cambio -eq "1" ]
									then
									service medialooper stop > /dev/tty2
									clear >  /dev/tty1
									echo "Aggiornamento sistema in corso NON SPEGNERE! Il sistema si riavvierà a lavoro ultimato." > /dev/tty1
									cp /tmp/update.tar.gz /home/pi/update/update.tar.gz > /dev/tty1
									rm /tmp/update.tar.gz > /dev/tty1
									tar -zxvf /home/pi/update/update.tar.gz -C /home/pi/update/ > /dev/tty1
									chmod +x /home/pi/update/update.sh > /dev/tty1
									
									/home/pi/update/update.sh & > /dev/tty1
									x=1
								else
									x=0
								fi
						fi
				done
			else
				if [ -s /media/USB/medialooper/update/update.tar.gz ]
					then
					diff -q /media/USB/medialooper/update/update.tar.gz /home/pi/update/update.tar.gz > /dev/tty2
					cambiousb="$?"
					if [ $cambiousb -eq "1" ]
						then
						service medialooper stop > /dev/tty1
						clear  > /dev/tty1
						echo "Aggiornamento sistema in corso NON SPEGNERE! Il sistema si riavvierà a lavoro ultimato." > /dev/tty1

						cp /media/USB/medialooper/update/update.tar.gz /home/pi/update/update.tar.gz > /dev/tty1
						rm /media/USB/medialooper/update/update.tar.gz > /dev/tty1
						tar -zxvf /home/pi/update/update.tar.gz -C /home/pi/update/ > /dev/tty1
						chmod +x /home/pi/update/update.sh  > /dev/tty1
						/home/pi/update/update.sh & > /dev/tty1
					else
						exit
						
					fi
				fi	
			fi			
exit	

