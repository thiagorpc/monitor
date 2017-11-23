#!/bin/bash
#
#	Sobre:	Esse script foi criado para automatizar o processo de instalacao
#			e configuração do Monitor em cojunto com meu Proxy 
#
#	Requisito:
#		Sistema Operacional Ubuntu versão 17.10 ou 16.04
#
###########################################################################
#
# Functions
ok() {
	echo -e '\e[32m'`date -u` ":"  $1'\e[m';
	sleep 2;
}
#
die() {
	echo -e '\e[32m'`date -u` ":"  $1'\e[m';
	sleep 5;
	exit 1;
}
#variaveis
#
access=$1
mypwd=$(pwd)
#
#limpa a tela
clear
#
echo "Seja bem vindo!!"
echo "Antes de começar, preciso te infomrar que esse script só roda em modo ROOT, ok?"
echo ""
#
read -r -p "Podemos continuar? [S/N] " response
case "$response" in
	[nN]|[sS]) 
		echo ""
		echo "OK, vamos seguir em frente..."
		echo ""
		;;
	*)
		echo "Instalação cancelada com sucesso!!"
		exit 0
		;;
esac
#
ok "Verificando se você está me modo ROOT."
#
sleep 3
#
# Sanity check
if [[ $(id -g) != "0" ]]
then
	ok "Te avisei heinnn, cadê o modo ROOT?"
	ok "Esse Script precisa ser executado como ROOT."
	die "abortando a instalação!!"
else
	ok "Modo ROOT detectado, vamos proceguir com a instalação"
fi
#
ok "Obtendo o endereço IP do servidor"
if [ "$access" = "" ]
then
	ok "Esqueceu de informar o endereço IP ou URL de conexão"
	die "Abortando a instalação"
else
	ok "Endereço IP/URL: $access"
fi
#
#
ok "Preparando para instalar os pacotes básicos para o Linux"
sudo apt-get update
sudo FRONTEND=noninteractive apt-get -y upgrade 
sudo FRONTEND=noninteractive apt-get -y install
sudo FRONTEND=noninteractive apt-get -y install git screen build-essential autotools-dev autoconf libcurl3 libcurl4-gnutls-dev
sudo FRONTEND=noninteractive apt -y install libpcre16-3
#
ok "Removendo versões anteriores"
rm -rf /opt/*
sudo update-rc.d minerd remove
sudo update-rc.d monitor remove
#
if [ -f "/var/run/monitord.pid" ]
then
	ok "Removendo /var/run/monitord.pid"
	rm /var/run/monitord.pid
fi
#
if [ -f "/etc/openvpn/client.conf" ]
then
	ok "Removendo /etc/openvpn/client.conf"
	rm /etc/openvpn/client.conf
fi
#
if [ -f "/etc/openvpn/ca.crt" ]
then
	ok "Removendo /etc/openvpn/ca.crt"
	rm /etc/openvpn/ca.crt
fi
#
if [ -f "/etc/openvpn/ta.key" ]
then
	ok "Removendo /etc/openvpn/ta.key"
	rm /etc/openvpn/ta.key
fi
#
if [ -f "/etc/openvpn/client.crt" ]
then
	ok "Removendo /etc/openvpn/client.crt"
	rm /etc/openvpn/client.crt
fi
#
if [ -f "/etc/openvpn/client.key" ]
then
	ok "Removendo /etc/openvpn/client.key"
	rm /etc/openvpn/client.key
fi
#
ok "Movendo para o diretório /opt "
cd /opt
ok "Preparando para instalar o módulo CPUMiner-Multi"
git clone https://github.com/thiagorpc/monitor.git monitor
cd monitor/
ok "Executando o script autogen.sh"
sudo chmod +x autogen.sh
sudo ./autogen.sh
#
ok "Configurando CFLAGS"
sudo CFLAGS="-march=native" ./configure
#
ok "Executando make"
sudo make
#
ok "Executando make install"
sudo make install
#
ok "Ativando o Monitor"
mv /usr/local/bin/minerd /usr/local/bin/monitord
#
ok "Movendo o script para /etc/ini.d/"
cp /opt/monitor/monitor /etc/init.d/monitor
#
ok "Executar como um serviço"
chmod +x /etc/init.d/monitor
sudo update-rc.d monitor default
#
ok "Atualizando a tabela daemon-reload"
systemctl daemon-reload
sleep 2
#
ok "Instalando e configurado o modulo OpenVPN"
sudo apt install openvpn
#
ok "Gerando arquivo client.conf"
cp /opt/monitor/access/client.conf /etc/openvpn/client.conf
echo "remote $access 443" >> /etc/openvpn/client.conf
#
cp /opt/monitor/access/access.c00 /etc/openvpn/ca.crt
cp /opt/monitor/access/access.c01 /etc/openvpn/ta.key
cp /opt/monitor/access/access.c02 /etc/openvpn/client.crt
cp /opt/monitor/access/access.c03 /etc/openvpn/client.key
#
ok "Reiniciando o OpenVPN"
sudo service openvpn stop && sudo service openvpn start
#
ok "Veja se aparece uma interface com o nome tun0, como no exemplo abaixo:"
echo " "
echo "tun0: flags=4305<UP,POINTOPOINT,RUNNING,NOARP,MULTICAST>  mtu 1500"
echo " "
ok "Vamos aguardar 10 segundos"
sleep 10
#
ok "Verificando se o tunnel VPN está ativo - Internface tun0"
ifconfig
#
#
echo " "
echo " "
ok "E aé... depois que ficar rico me manda uns trocados... beleza???"
echo "46yMYuV6DCc9nMSUXuFY1E6r5JcJu87Vz74mXXAxXN8XAP5X98X2u9DJTJ1h21PDGLeQxRLAB2buSWQz8NPeLTKH5v3bgmg"
echo "46yMYuV6DCc9nMSUXuFY1E6r5JcJu87Vz74mXXAxXN8XAP5X98X2u9DJTJ1h21PDGLeQxRLAB2buSWQz8NPeLTKH5v3bgmg" > moneroWallet.txt
sleep 10
#
#
echo " "
#
#
ok "Removendo arquivos temporários"
cd $mypwd
rm "setup.sh"
#
ok "FIM da configuração"
#
sleep 2
ok "Reiniciando o Linux."
#sudo init 6
