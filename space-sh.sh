#!/bin/bash
# Script Auto Install Five M
#=====================================================================================
# Author:   Clashplayer#3630 
#=====================================================================================
#=====================================================================================
# Root Force
# By Clashplayer#8772

cat << "EOF"
Bienvenue sur l'installateur FiveM automatique !                            
EOF
#Supported systems:
supported="Ubuntu"
COLOR1='\033[0;32m'                                         #green color
COLOR2='\033[0;31m'                                         #red color
COLOR3='\33[0;33m'
NC='\033[0m'                                                #no color

 if [ "$(id -u)" != "0" ]; then
         printf "${RED}CODE ERREUR: ROOT-FALSE. ⛔️\\n" 1>&2
         printf "\\n"
         exit 1
 fi
    printf "${COLOR1}©️  Copyright Tous droits réservés.©️ \\n"
    printf "${COLOR2}💻 Systèmes pris en charge : $supported 💻\\n"
    printf "${NC}\\n"    
    sleep 6
#############################################################################

# Prérequis installation Five M
apt update -y
apt upgrade -y
apt install sudo xz-utils git curl screen -y

#Installation de 5104
echo
    printf "${YELLOW} Dernière artifact trouver 5204 souhaitez-vous le prendre?  [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
printf "${CYAN} Démarrage de l'instalaltion de version de 5104 pour serveur Five M !"
    cd /home/
    mkdir -p fivem
    cd /home/fivem
    wget  https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/5402-810a639673d8da03fe4b1dc2b922c9c0265a542e/fx.tar.xz
    tar xvfJ fx.tar.xz
    # Suppression du cache automatique
    # sed -i '1irm -r cache' run.sh
    rm fx.tar.xz
fi
sleep 2

sleep 2

#Installation de SYSTEMCTL | TXADMIN
echo
    printf "${YELLOW} Vous souhaitez disposer d'une nouvelle technologie pour démarrer votre serveur TXADMIN ?  ❓  [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
printf "${CYAN} Démarrage technologie pour démarrer votre serveur TXADMIN !"
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Clashplayer-PROTECT/sh-fivem/master/txadmin.service
    systemctl enable txadmin.service
fi
sleep 2

# Installation mysql-server
echo
    printf "${YELLOW} Souhaitez-vous créer une installation automatique de Mysql Server ? [O/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
printf "${CYAN} Démarrage de l'instalaltion de MariaDB pour serveur FiveM !"
    apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
    add-apt-repository -y ppa:chris-lea/redis-server
    curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
    apt update -y
    sudo add-apt-repository ppa:ondrej/php
    sudo apt-get update -y
    sudo apt-get install php-mbstring php-gettext
    sudo apt install php7.4 -y
    apt install -y php7.4-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip} mariadb-client mariadb-server apache2 tar unzip git 
    php -v

fi
sleep 2

echo -n -e "${GREEN}Quel est le nom de votre base de données  ${YELLOW}(space_base)${reset}: "
read -r DBNAME

if [[ "$DBNAME" == "" ]]; then
  DBNAME="sh_base"  
fi

sleep 2
echo -n -e "${GREEN}Quelle nom d'utilisateur souhaitez-vous ? ${YELLOW}(space-fivem)${reset}: "
read -r DBUSER

if [[ "$DBUSER" == "" ]]; then
  DBUSER="sh-fivem"  
fi

sleep 2
echo -n -e "${GREEN}Quel est le mot de passe de votre base de données ❓ ${reset}: "
read -s -r DBPASS

while true; do

  if [[ "$DBPASS" == "" ]]; then
    echo -e "${red}MDP OBLIGATOIRE"
    echo -n -e "${GREEN}Quel mdp souhaitez vous ? ${reset}: "
    read -s -r DBPASS
  else
    echo -e "${GREEN}Le mdp est niquel !${reset}" 
    break 
  fi
done 


#Installation PMA
echo
    printf "${YELLOW} Souhaitez-vous crée une installation automatique de PHPMYADMIN   ❓ [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
printf "${CYAN} Démarrage de l'instalaltion de phpMyAdmin pour serveur Five M !"
mkdir /var/www/phpmyadmin && cd /var/www/phpmyadmin
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.gz
tar xvzf phpMyAdmin-latest-english.tar.gz
mv /var/www/phpmyadmin/phpMyAdmin-latest-english/* /var/www/phpmyadmin
fi

echo -e "Configuration de la utilisateur"
  echo "Mettre le mot de passe root de MySQL"
  sleep 2
  mysql -e "CREATE USER '${DBUSER}'@'localhost' IDENTIFIED BY '${DBPASS}';"
  mysql -e "CREATE DATABASE ${DBNAME};"
  mysql -p -e "GRANT ALL PRIVILEGES ON * . * TO '${DBUSER}'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"
  

  sleep 3
    printf "${COLOR3} L'installation est terminée ! \\n"
    printf "${COLOR3} Discord de SH-FIVEM : https://discord.gg/Bx5UUV54mu \\n"
    printf "${COLOR3} Github de Clahsplayer sur SH-FIVEM: https://github.com/Clashplayer-PROTECT/sh-fivem \\n"
    echo -en '\n'
    sleep 3
    printf "${COLOR1} TOPO du MySQL \\n"
    printf "${COLOR1} Lien du phpMyAdmin : http://$(hostname -I)/phpmyadmin/ \\n"
    printf "${COLOR1} Nom d'utilisateur de la base de données MySQL: ${DBUSER}\\n"
    printf "${COLOR1} Mot de passe de connexion base de données MySQL: ${DBPASS} \\n"
    echo -en '\n'
    sleep 3
    printf "${COLOR2}💻 TOPO sur créaction de votre seveur ! \\n"
    printf "${COLOR2}💻 Chemin du dossier  : /home/fivem \\n"
    printf "${COLOR2}💻 Ne surtout pas supprime run.sh et alpine\\n"
    printf "${NC}\\n"    


cat << "EOF"
Aurevoir. :) 
EOF
