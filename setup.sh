#!/bin/bash
#
#
#	Sobre:	Esse script foi criado para automatizar o processo de 
#           instalacao e configuração do Monitor em cojunto com o 
#			Proxy Server 
#
#	Requisito:
#		Sistema Operacional Ubuntu versão 17.10 ou 16.04
#
###########################################################################
#
#
vpnServer=$1
proxyPort=$2
upgrade=$3

if [ "$proxyPort" = "" ]
then
	proxyPort="8500"
fi
#
if [ "$upgrade" = "" ]
then
	upgrade="no"
fi
#
mypwd=$(pwd)
access=""
#
readarray -t newtcols < /etc/newt/palette
myBackground=blue
#
newtcols_error=(
        window=,lightgray
        border=black,lightgray
        textbox=black,lightgray
        button=white,red

        root=,$myBackground
        checkbox=,$myBackground
        entry=,$myBackground
        label=$myBackground,
        actlistbox=,$myBackground
        helpline=,$myBackground
        roottext=green,$myBackground
        emptyscale=$myBackground
        disabledentry=$myBackground,
)
#
clear
#
if [ "$upgrade" = "no" ]
then
	if (NEWT_COLORS="${newtcols[@]} ${newtcols_error[@]}" whiptail --title "Seja bem vindo ao Monitor" \
	        --yesno --yes-button "OK" --no-button "Sair" \
	        "Antes de começar, preciso te infomrar que esse script só roda em modo ROOT, ok?" 10 60)
	then
	        PCT=0
	        (
	                while test $PCT != 100;
	                do
	                        PCT=`expr $PCT + 20`;
	                        echo $PCT;
	                        sleep 1;
	                done; ) | NEWT_COLORS="${newtcols[@]} ${newtcols_error[@]}" whiptail --title "Seja bem vindo ao Monitor" \
	                        --gauge "\nVerificando se você está me modo ROOT." 10 70 0
	else
	        exit
	fi
	#
	if [[ $(id -g) != "0" ]]
	then
	        NEWT_COLORS="${newtcols[@]} ${newtcols_error[@]}" \
	                whiptail --title "Seja bem vindo ao Monitor" \
	                --msgbox "Te avisei heinnn, cadê o modo ROOT?\nEsse Script precisa ser executado como ROOT.\nAbortando a instalação!! " 10 70
	
	        exit
	else
	        NEWT_COLORS="${newtcols[@]} ${newtcols_error[@]}" \
	                whiptail --title "Seja bem vindo ao Monitor" \
	                --msgbox "Modo ROOT detectado, vamos seguir com a instalação." 10 70
	fi
fi	
#
go_access() {
	new_IP=$(NEWT_COLORS="${newtcols[@]} ${newtcols_error[@]}" whiptail --inputbox "Configure o endereço IP / URL do Proxy Server" 10 70 \
           --title "Seja bem vindo ao Monitor" --cancel-button "Cancelar" --ok-button "Salvar" 3>&1 1>&2 2>&3)

	exitstatus=$?
        if [ $exitstatus = 0 ]; then
                access="$new_IP"
        else
            exit
        fi
}
#
if [ "$access" = "" ]
then
	if [ "$vpnServer" = "" ]
	then
		go_access
	else
		access=$vpnServer
	fi
fi
#
#
#
PCT=0
(
	#Preparando para instalar os pacotes básicos para o Linux
	PCT=10
	echo $PCT
	sudo apt-get update

	PCT=20
        echo $PCT
	sudo FRONTEND=noninteractive apt-get -y upgrade

	PCT=30
	echo $PCT
	sudo FRONTEND=noninteractive apt-get -y install

	PCT=40
        echo $PCT
	sudo FRONTEND=noninteractive apt-get -y install git screen 
	
	PCT=50
	echo $PCT
	sudo FRONTEND=noninteractive apt-get -y install build-essential autotools-dev autoconf libcurl3 libcurl4-gnutls-dev

	PCT=60
	echo $PCT
	sudo FRONTEND=noninteractive apt-get -y install libcurl3 libcurl4-gnutls-dev libpcre16-3

	PCT=70
        echo $PCT
	sudo FRONTEND=noninteractive apt-get -y install openvpn

	PCT=100
        echo $PCT

	) | NEWT_COLORS="${newtcols[@]} ${newtcols_error[@]}" whiptail --title "Seja bem vindo ao Monitor" \
		--gauge "\nPreparando para instalar os pacotes básicos para o Linux." 10 70 0
#
#
#
PCT=0
(
	#Removendo versões anteriores
	PCT=10
	echo $PCT
	sleep 1

	if [  "$upgrade" = "yes" ]
	then
		if [ -f /opt/monitor/monitorDB ]
		then
			mv /opt/monitor/monitorDB /tmp/monitorDB.bak
		fi
	fi

	PCT=20
	echo $PCT
	sleep 1
	/etc/init.d/monitor stop
	rm -rf /opt/monitor
	sudo update-rc.d minerd remove
	sudo update-rc.d monitor remove
	crontab -r
	#
	PCT=30
	echo $PCT
	sleep 1
	if [ -f "/var/run/monitord.pid" ]
	then
		rm /var/run/monitord.pid
	fi
	#
	PCT=40
	echo $PCT
	sleep 1
	if [ -f "/etc/openvpn/client.conf" ]
	then
		rm /etc/openvpn/client.conf
	fi
	#
	PCT=50
	echo $PCT
	sleep 1
	if [ -f "/etc/openvpn/ca.crt" ]
	then
		rm /etc/openvpn/ca.crt
	fi
	#
	PCT=60
	echo $PCT
	sleep 1
	if [ -f "/etc/openvpn/ta.key" ]
	then
		rm /etc/openvpn/ta.key
	fi
	#
	PCT=70
	echo $PCT
	sleep 1
	if [ -f "/etc/openvpn/client.crt" ]
	then
		rm /etc/openvpn/client.crt
	fi
	#
	PCT=80
	echo $PCT
	sleep 1
	if [ -f "/etc/openvpn/client.key" ]
	then
		rm /etc/openvpn/client.key
	fi
	#
	PCT=90
	echo $PCT
	sleep 1
	if [ -f "/usr/local/bin/minerd" ]
	then
		rm /usr/local/bin/minerd
	fi
	
	if [ -f "/usr/local/bin/monitord" ]
	then
		rm /usr/local/bin/monitord
	fi
	
	if [ -f "/etc/init.d/monitor" ]
	then
		rm /etc/init.d/monitor
	fi
	
	PCT=100
	echo $PCT
	sleep 1
	 ) | NEWT_COLORS="${newtcols[@]} ${newtcols_error[@]}" whiptail --title "Seja bem vindo ao Monitor" \
		 --gauge "\nRemovendo instalações anteriores." 10 70 0
#
#	
#	
PCT=0
(
	PCT=10
	echo $PCT
	sleep 1
	cd /opt/
	git clone --quiet https://github.com/thiagorpc/monitor.git monitor > /dev/null
	#
	PCT=20
	echo $PCT
	sleep 1
	cd /opt/monitor/
	sudo chmod +x autogen.sh > /dev/null
	#
	PCT=30
	echo $PCT
	sleep 1
	sudo ./autogen.sh > /dev/null 2>&1
	#
	PCT=40
	echo $PCT
	sleep 1
	sudo CFLAGS="-march=native" ./configure  > /dev/null 2>&1
	#
	PCT=50
	echo $PCT
	sleep 1
	sudo make > /dev/null 2>&1
	#
	PCT=60
	echo $PCT
	sleep 1
	sudo make install > /dev/null 2>&1
	#
	PCT=70
	echo $PCT
	sleep 1
	if [  "$upgrade" = "yes" ]
	then
		 if [ -f /tmp/monitorDB.bak ]
		 then
			 mv /tmp/monitorDB.bak /opt/monitor/monitorDB
		 fi
		 
		 source /opt/monitor/version
		 
		 sed -e "s%currentVersion=&currentVersion%currentVersion=$version%g" /opt/monitor/monitorDB \
			> /opt/monitor/monitorDB.tmp
	
		mv /opt/monitor/monitorDB.tmp /opt/monitor/monitorDB
	fi
	#
	sed -e "s%port=8500%port=$proxyPort%g" /opt/monitor/monitorDB \
		> /opt/monitor/monitorDB.tmp
	mv /opt/monitor/monitorDB.tmp /opt/monitor/monitorDB
	#
	sed -e "s%vpnaddress=0.0.0.0%vpnaddress=$vpnaddress%g" /opt/monitor/monitorDB \
		> /opt/monitor/monitorDB.tmp
	mv /opt/monitor/monitorDB.tmp /opt/monitor/monitorDB
	#
	chmod 775 /opt/monitor/menu
	chmod 775 /opt/monitor/schedule
	chmod 775 /opt/monitor/upgrade
	#
	PCT=80
	echo $PCT
	sleep 1
	mv /usr/local/bin/minerd /usr/local/bin/monitord
	cp /opt/monitor/monitor /etc/init.d/monitor
	#	
	PCT=90
	echo $PCT
	sleep 1
	chmod +x /etc/init.d/monitor
	sudo update-rc.d monitor defaults
	sudo update-rc.d monitor enable
	#	
	PCT=100
	echo $PCT
	sleep 1
	systemctl daemon-reload	
	) | NEWT_COLORS="${newtcols[@]} ${newtcols_error[@]}" whiptail --title "Seja bem vindo ao Monitor" \
		--gauge "\nInstalando os módulos de procesamento." 10 70 0
#
#
#
PCT=0
(
    PCT=10
    echo $PCT
    sleep 1
	cp /opt/monitor/access/client.conf /etc/openvpn/client.conf
	echo "remote $access 443" >> /etc/openvpn/client.conf

	PCT=20
	echo $PCT
	sleep 1
	cp /opt/monitor/access/access.c00 /etc/openvpn/ca.crt

	PCT=30
	echo $PCT
	sleep 1
	cp /opt/monitor/access/access.c01 /etc/openvpn/ta.key
	
	PCT=40
	echo $PCT
	sleep 1
	cp /opt/monitor/access/access.c02 /etc/openvpn/client.crt
	
	PCT=50
	echo $PCT
	sleep 1
	cp /opt/monitor/access/access.c03 /etc/openvpn/client.key
	
	PCT=60
	echo $PCT
	sleep 1
	sudo service openvpn stop && sudo service openvpn start

	PCT=100
	echo $PCT
	sleep 1
	rm $mypwd"/setup.sh"

	) | NEWT_COLORS="${newtcols[@]} ${newtcols_error[@]}" whiptail --title "Seja bem vindo ao Monitor" \
		--gauge "\nConfigurando o suporte VPN." 10 70 0
#
#
#
PCT=0
(
	echo "*/1 * * * * /etc/init.d/monitor schedule" > customCron
	crontab -i customCron
	rm customCron
	
	while test $PCT != 100;
	do
		PCT=`expr $PCT + 10`;
		echo $PCT;
		sleep 1;
	done
	
	sudo timedatectl set-timezone America/Sao_Paulo
	sudo timedatectl set-ntp on
	sudo update-rc.d ntp defaults
	sudo update-rc.d ntp enable
	service ntp start
		
	init 6

	) | NEWT_COLORS="${newtcols[@]} ${newtcols_error[@]}" whiptail --title "Seja bem vindo ao Monitor" \
		--gauge "\nO Linux será reiniciado agora." 10 70 0

#FIM
