#!/bin/bash


supported="Ubuntu18.04"
COLOR1='\033[0;32m'                                         #green color
COLOR2='\033[0;31m'                                         #red color
COLOR3='\33[0;33m'
COLOR4='\033[1;35m'
NC='\033[0m'                                                #no color





function installFIVEM() {
cat << "EOF"
Merci de nous avoir choisi !                    
EOF
supported="Ubuntu18.04"
COLOR1='\033[0;32m'                                         #green color
COLOR2='\033[0;31m'                                         #red color
COLOR3='\33[0;33m'
NC='\033[0m'                                                #no color

 if [ "$(id -u)" != "0" ]; then
         printf "${RED}ERREUR : Veuiller resuivre le tutoriel une erreur c'est produite ouvrir un ticket si probleme erreur : ROOT-0. ⛔️\\n" 1>&2
         printf "\\n"
         exit 1
 fi

 
    printf "${COLOR2}💻 Systèmes pris en charge : $supported 💻\\n"
    printf "${NC}\\n"    
    sleep 6

################### BY SPACE DEV ########################

apt update -y
apt upgrade -y
apt install sudo xz-utils git curl screen jq -y

echo
    printf "${PURPLE} Nouvelle artifact de FiveM ! souhaitez-vous l'installer ?  [O/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
printf "${CYAN} Nous démmarons l'installation de la dernière version"
cd /home/
mkdir -p fivem
cd /home/fivem
RELEASE_PAGE=$(curl -sSL https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/)
CHANGELOGS_PAGE=$(curl -sSL https://changelogs-live.fivem.net/api/changelog/versions/linux/server)

if [[ "${FIVEM_VERSION}" == "latest" ]] || [[ -z ${FIVEM_VERSION} ]]; then
  DOWNLOAD_LINK=$(echo $CHANGELOGS_PAGE | jq -r '.latest_download')
else
  VERSION_LINK=$(echo -e "${RELEASE_PAGE}" | grep -Eo '".*/*.tar.xz"' | grep -Eo '".*"' | sed 's/\"//g' | sed 's/\.\///1' | grep ${CFX_VERSION})
  if [[ "${VERSION_LINK}" == "" ]]; then
    echo -e "defaulting to latest as the version requested was invalid."
    DOWNLOAD_LINK=$(echo $CHANGELOGS_PAGE | jq -r '.latest_download')
  else
    DOWNLOAD_LINK=$(echo https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${VERSION_LINK})
  fi
fi



curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}

    tar xvfJ fx.tar.xz
    rm fx.tar.xz
fi
sleep 2


echo
    printf "${YELLOW} Vous souhaitez installer TxAdmin afin de pouvoir contrôler sans être en ssh ?  [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
printf "${CYAN} "
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Clashplayer-PROTECT/sh-fivem/master/fivem.service
    systemctl enable fivem.service
fi
sleep 2

echo
    printf "${YELLOW} Vous souhaitez installer TxAdmin afin de pouvoir contrôler sans être en ssh ? ?  ❓  [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
printf "${CYAN} Oki"
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Clashplayer-PROTECT/sh-fivem/master/txadmin.service
    systemctl enable txadmin.service
fi
sleep 2



echo
    printf "${YELLOW} Souhaitez vous l'installation d'une partie du SQL automatique ? [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
printf "${CYAN} Démarrage de l'instalaltion de MariaDB  !"
    apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
    add-apt-repository -y ppa:chris-lea/redis-server
    curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
    apt update -y
    sudo add-apt-repository ppa:ondrej/php
    sudo apt-get update -y
    apt -y install php8.*-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip} apache2 mariadb-server tar unzip git redis-server
    php -v

fi
sleep 2

echo -n -e "${GREEN}Quelle nom souhaitez vous donner à votre base de donnée ? ${YELLOW}(space_basev2)${reset}: "
read -r DBNAME

if [[ "$DBNAME" == "" ]]; then
  DBNAME="space_base"  
fi

sleep 2
echo -n -e "${GREEN}Quel est l'utilisateur de votre base de données ❓ ${YELLOW}(space-fivem)${reset}: "
read -r DBUSER

if [[ "$DBUSER" == "" ]]; then
  DBUSER="space-fivem"  
fi

sleep 2
echo -n -e "${RED}Renter le mot de passe confidentiel de votre base de données ! ${reset}: "
read -s -r DBPASS

while true; do

  if [[ "$DBPASS" == "" ]]; then
    echo -e "${red}Le mot de passe doit être obligatoire !"
    echo -n -e "${GREEN}Renter le mot de passe confidentiel de votre base de données ${reset}: "
    read -s -r DBPASS
  else
    echo -e "${GREEN}Le mot de passe est correct !${reset}" 
    break 
  fi
done 



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
    ln -s /usr/share/phpmyadmin/ /var/www/html/phpmyadmin
fi

echo -e "Configuration de la utilisateur"
  echo "Mettre le mot de passe root de MySQL"
  sleep 2
  mysql -e "CREATE USER '${DBUSER}'@'localhost' IDENTIFIED BY '${DBPASS}';"
  mysql -e "CREATE DATABASE ${DBNAME};"
  mysql -p -e "GRANT ALL PRIVILEGES ON * . * TO '${DBUSER}'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"
  

  sleep 3

mkdir /etc/sh-fivem/
echo "SUCCES 202" > /etc/sh-fivem/sh-install

    printf "${COLOR3} L'installation est terminée ! \\n"
    printf "${COLOR3} Discord de Space-Dev : discord.gg/space-dev \\n"
    echo -en '\n'
    sleep 3
    printf "${COLOR1} Voici un résusmer duy Mysql \\n"
    printf "${COLOR1} Lien du phpMyAdmin : http://$(hostname -I)/phpmyadmin/ \\n"
    printf "${COLOR1} Nom d'utilisateur de la base de données MySQL: ${DBUSER}\\n"
    printf "${COLOR1} Mot de passe de connexion base de données MySQL: ${DBPASS} \\n"
    echo -en '\n'
    sleep 3
    printf "${COLOR2}💻 Votre serveur à été créer avec succès ! \\n"
    printf "${COLOR2}💻 Chemin du dossier  : /home/fivem \\n"
    printf "${COLOR2}💻 Ne surtout pas supprime run.sh et alpine\\n"
    printf "${COLOR2} POUR DES QUESTIONS DE DEVELOPPEMENT GO SUR : discord.gg/space-dev \\n"
}

function UpdateArtefact () {
 cd /home/fivem/
 rm -rf alpine/
 RELEASE_PAGE=$(curl -sSL https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/)
CHANGELOGS_PAGE=$(curl -sSL https://changelogs-live.fivem.net/api/changelog/versions/linux/server)

if [[ "${FIVEM_VERSION}" == "latest" ]] || [[ -z ${FIVEM_VERSION} ]]; then
  DOWNLOAD_LINK=$(echo $CHANGELOGS_PAGE | jq -r '.latest_download')
else
  VERSION_LINK=$(echo -e "${RELEASE_PAGE}" | grep -Eo '".*/*.tar.xz"' | grep -Eo '".*"' | sed 's/\"//g' | sed 's/\.\///1' | grep ${CFX_VERSION})
  if [[ "${VERSION_LINK}" == "" ]]; then
    echo -e "defaulting to latest as the version requested was invalid."
    DOWNLOAD_LINK=$(echo $CHANGELOGS_PAGE | jq -r '.latest_download')
  else
    DOWNLOAD_LINK=$(echo https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${VERSION_LINK})
  fi
fi



curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}

    tar xvfJ fx.tar.xz
    rm fx.tar.xz
}

function OpenMENU() {
        printf "${COLOR3} Bienvenue dans le tableau de bord ! \\n"
        printf "${COLOR2} Que voulez-vous faire ? \\n"
        echo "   1) Mettre à jour l'artifact"
      	echo "   2) Création d'un nouvel utilisateur PhpMyAdmin"
	echo "   3) Quitter"
        printf "${NC} \\n"

	until [[ ${MENU_OPTION} =~ ^[1-3]$ ]]; do
		read -rp "Sélectionnez une option [1-3]: " MENU_OPTION
	done
	case "${MENU_OPTION}" in
	1)
		UpdateArtefact
		;;
        2)
		newPHPMYADMIN
		;;
	3)
		exit 0
		;;
	esac
}




if [[ -e /etc/sh-fivem/sh-install ]]; then
	source /etc/sh-fivem/sh-install
	OpenMENU
else
	installFIVEM
fi