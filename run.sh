#!/bin/bash

clear > /dev/tty1

sleep 2

clear > /dev/tty1

grep '/media/USB' /etc/mtab > /dev/null 2>&1
cavoli="$?"

	if [ $cavoli -eq "1" ]
	then
		fbi -noverbose -a -device /dev/fb0 -vt 1 /home/pi/nodevice.jpg
		exit
	fi
echo -e  "\\n\\n		MediaLooper sta caricando ...."  > /dev/tty1




	if [ -s /media/USB/medialooper/mediaconfig.txt ]

	then
		diff -q /home/pi/mediastart.txt /media/USB/medialooper/mediaconfig.txt > /dev/null
		cazzi="$?"

			if [ $cazzi -eq "0" ]
			then
				umount /dev/sda1
				clear > /dev/tty1
				echo -e "\\n\\n		Il file di configurazione non è stato modificato. \\n 		Rimuovi la pendrive, collegala al tuo pc, configura il file mediaconfig.txt.\\n 		Inserisci nuovamente la pendrive in MediaLooper e riavvia il sistema." > /dev/tty1
				exit
			else
    			cp /media/USB/medialooper/mediaconfig.txt /home/pi/
    			rm -rf /media/USB/medialooper/mediaconfig.txt
			fi
	else

		if ! [ -s /home/pi/mediaconfig.txt ]

		then
			# Inizializza la pendrive
			mkdir /media/USB/medialooper
			mkdir /media/USB/medialooper/video
			mkdir /media/USB/medialooper/musica
			mkdir /media/USB/medialooper/immagini
			cp /home/pi/mediastart.txt /media/USB/medialooper/mediaconfig.txt
			umount /dev/sda1
			clear >  /dev/tty1
			echo -e "\\n\\n		BENVENUTO A MEDIALOOPER \\n\\n 		Il pendrive è stato inizializzato: sono state create le tre cartelle contenitrici e il file di configurazione. \\n 		Rimuovi la pendrive, collegarla al pc e inserisci i giusti settaggi nel file mediaconfig.txt seguendo le indicazioni che troverai all'interno\\n 		Se devi configuarare il WiFi premi Enter e autenticati nel sistema inserendo il nome utente ''pi'' e la password ''video'' \\n 		quindi inserisci il comando ''startx''. \\n 		Sul desktop ad aiutarti troverai una guida chiamata ''Configurazione Wifi.pdf''\\n\\n 		Quando hai completato le configurazioni ricollega la chiavetta e riavvia il sistema." > /dev/tty1
			exit
		else
			if ! [ -s /media/USB/medialooper ]
			then
				# Inizializza la pendrive
				mkdir /media/USB/medialooper
				mkdir /media/USB/medialooper/video
				mkdir /media/USB/medialooper/musica
				mkdir /media/USB/medialooper/immagini
				cp /home/pi/mediaconfig.txt /media/USB/medialooper/mediaconfig.txt
				
				clear >  /dev/tty1
				echo -e "\\n\\n		Il pendrive è stato inizializzato: sono state create le tre cartelle contenitrici e il file di configurazione. \\n\\n		Se la sincronizzazione è attiva attendere 30 secondi, il sistema si aggiornerà automaticamente. \\n\\n	Altrimenti spegnere, inserire i contenuti sul pendrive e riavviare " > /dev/tty1
				sleep 30
				clear > /dev/tty1
			fi	
		fi
	fi
 


grep '/media/USB' /etc/mtab > /dev/null 2>&1
capperi="$?"

	if [ $capperi -eq "0" ]
	then
		
		source /home/pi/mediaconfig.txt
		#check if autostart is enabled
			if [ $AUTOSTART -eq 1 ]
			then

				if [ $SYNC -eq 1 ]
				then
					#Inizio while Test connessione Internet
  					echo -e "		Verifica connessione in corso....." > /dev/tty1
					x=1
					while [ $x -lt 10 ]
					do
					echo -e "		$x ° tentativo su 10" > /dev/tty1
  					wget  -q --spider --tries=10 --timeout=20 http://google.com
					cippe="$?"
						if [ $cippe -eq "0" ]
						then
     						echo -e "		Aggiornamento in corso....." > /dev/tty1
							#wget -N -P /home/pi/ --user=$USER --password=$PASS ftp://$HOST/$IND/medialooper/mediaconfig.txt > /dev/tty2
							lftp -f "
							open $HOST
							user $USER $PASS
							set ftp:ssl-allow no
							mirror  --exclude mediaconfig.txt --ignore-time --delete --verbose /$IND/medialooper/ /media/USB/
							" > /dev/tty1
							x=10
						else
							x=$(( $x + 1 ))
							sleep 6
							#clear > /dev/tty1
							if  [ $x -eq 10 ]
							then			        		
			        			echo "				Connessione non disponibile" > /dev/tty1
							sleep 5			
							fi
						fi
					done
				fi
				#start slideshow
				fbi -noverbose -a -t $TRANSIZIONE -device /dev/fb0 -vt 1 -u `find /media/USB/medialooper/immagini -iname "*.*"` & 
				#start audio-video looper
				/home/pi/startvideos.sh &
				#start system update
				/home/pi/updated.sh &  > /dev/tty2
			else
				echo -e "		Autostart disabilitato. Autenticarsi quindi digitare startx per accedere all'interfaccia grafica." > /dev/tty1
				exit
			fi
	else 
		#echo -e "ATTENZIONE!! \\n La pendrive non è presente!" > /dev/tty1
		fbi -noverbose -a -device /dev/fb0 -vt 1 /home/pi/nodevice.jpg
	fi

exit
