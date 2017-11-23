Monitor - CPU Miner Multi-Threaded
==============

Monitor é um minerador de Criptomoedas para CPUs (Processadores).

Desenvolvido na linguagem de programação C, este minerador implementa recursos multi-threaded  e é compatível com o modelo JSON-RPC 2.0.

*Méritos para [LucasJones](//github.com/lucasjones/cpuminer-multi) que é o autor do projeto original,  méritos a todos os outros desenvolvedores da comunidade.*

*Veja __AUTHORS__ para obter a lista de contribuicões.*


#### Tabela de conteúdo

* [Algoritmo](#algoritmo)
* [Dependências](#dependências)
* [Download](#download)
* [Compilar](#compilar)
* [Arquitetura](#arquitetura)
* [Instruções de uso](#Instruções-de-uso)
* [Sistema operacional](#Sistema-operacional)
* [Doações](#doações)
* [Créditos](#créditos)
* [Licença](#licença)


Algoritmo
==========

Este minerador trabalha com moedas do tipo __cryptonight__, como:

* BCN – Bytecoin			https://bytecoin.org/
* XMR – Monero			http://getmonero.org/
* QCN -  QuazarCoin			http://www.quazarcoin.org/
* XDN – DigitalNote			http://digitalnote.org/
* FCN – FantomCoin			https://github.com/xdn-project/fantomcoin/releases
* MCN - MonetaVerde			https://bitcointalk.org/index.php?topic=653141.0
* DSH – Dashcoin			http://dashcoin.info/
* INF8 - Infinium-8			https://bitcointalk.org/index.php?topic=698727.0


Dependências
============

* libcurl			http://curl.haxx.se/libcurl/
* jansson			http://www.digip.org/jansson/ (jansson is included in-tree)


Download
========

* Veja a arvore de desenvolvimento:   https://github.com/thiagorpc/monitor.git
* Faça um clone do projeto através do comando `git clone https://github.com/thiagorpc/cpu_miner.git`


Compilar
=====

#### Execute os comandos a seguir em sequência:

git clone https://github.com/thiagorpc/monitor.git monitor

chmod +x autogen.sh

./autogen.sh					

* Utilize o parâmetro __march=native__ para compilar este projeto em um servidor com suporte a __AES-NI__
CFLAGS="*-march=native*" ./configure

* Utilize o parâmetro __disable-aes-ni__ quando precisar indicar que o processador não suporta __AES-NI__
CFLAGS="*-march=native*" ./configure --disable-aes-ni
 
make

make install

*Execute o comando estando logado com o ROOT ou eleve a permissão para o ROOT via comando SUDO.*


Arquitetura
==================

* O protocolo __CryptoNight__ funciona apenas em __x86__ e __x86-64__.
* Se você não tiver um processador com suporte a __AES-NI__, infelizmente a sua mineração será muito lenta, praticamente 1/3 do normal.


Instruções de uso
==================

Execute o comando "minerd --help" para ver as opções disponíveis.


Exemplos de linha de comando
==================

./minerd -a cryptonight -o stratum+tcp://mine.moneropool.com:3333 -p x -u 46yMYuV6DCc9nMSUXuFY1E6r5JcJu87Vz74mXXAxXN8XAP5X98X2u9DJTJ1h21PDGLeQxRLAB2buSWQz8NPeLTKH5v3bgmg -t 3

### Conectando através de um proxy

Utilize a opção --proxy.

Para utilizar proxys do tipo SOCKS, adicione o parâmetro socks4:// ou socks5:// antes do host.
  
Protocolos socks4a e socks5h, permitem resolução de nomes remotas e estão disponíveis desde a __libcurl 7.18.0__.

Se você não especificar um protocolo do tipo __SOCKS__, a aplicação irá assumir que você deseja utilizar um proxy do tipo __HTTP__.

Quanto o parâmetro __--proxy__ não é utilizado, o programa deixa em branco as variáveis __http_proxy__ e tenta alcançar a Internet através da rede local.


Sistema operacional
=========

### Ubuntu Server 16.04.3 LTS
[Ubuntu Server 16.04.3 LTS release notes](//wiki.ubuntu.com/XenialXerus/ReleaseNotes?_ga=2.208342994.1365505851.1511400309-1147109503.1509147611)

[Link para download](//www.ubuntu.com/download/alternative-downloads)

### Ubuntu Server 17.10
[Ubuntu Server 17.10 release notes](//wiki.ubuntu.com/ArtfulAardvark/ReleaseNotes?_ga=2.249769926.1365505851.1511400309-1147109503.15091476110)

[Link para download](//www.ubuntu.com/download/alternative-downloads)


Doações
=========

Sintam-se a vontade para fazerem suas doações com o objetivo de suportar futuras manutenções deste desenvolvimento.

* XMR: ` 46yMYuV6DCc9nMSUXuFY1E6r5JcJu87Vz74mXXAxXN8XAP5X98X2u9DJTJ1h21PDGLeQxRLAB2buSWQz8NPeLTKH5v3bgmg`


Créditos
=======

*Méritos para [LucasJones](//github.com/lucasjones/cpuminer-multi) que é o autor do projeto original,  méritos a todos os outros desenvolvedores da comunidade.*

*Veja __AUTHORS__ para obter a lista de contribuicões.*


Licença
=======

GPLv3.  Veja o arquivo LICENSE para maiores detalhes.
