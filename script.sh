#!/usr/bin/env bash
clear

rm -rf data
rm -rf Vagrantfile
vagrant init
echo "Nom du dossier sync"
read dirSync
mkdir $dirSync
sed -i "s/..\/data/.\/$dirSync/" 'Vagrantfile'
sed -i 's/vagrant_data/var\/www\/html/' 'Vagrantfile'

echo "Quelle Machine veux-tu monter?"
echo "1. Linux"
echo "2. Windows"
echo "3. MacOS"
read lie
sed -i -e 's/base/ubuntu\/xenial64/' 'Vagrantfile'
echo "Quelle adresse IP"
read ip
sed -i s/192.168.33.10/$ip/ 'Vagrantfile'
sed -i '35 s/#//; 46 s/#//; 66 s/#//' 'Vagrantfile'


echo "#!/usr/bin/env bash
sudo apt-get update" > $dirSync/install-update.sh

echo "Le Vagrantfile est bien configuré, passons à la VM"
sleep 1
echo "Est-ce que tu veux installer apache2?"
echo "1. Oui"
echo "2. Non"
read apache
if [ $apache == 1 ]
then
  echo "sudo apt install -y apache2" >> $dirSync/install-update.sh
  echo "sudo service apache2 restart" >> $dirSync/install-update.sh
  echo -e "\e[32mParfait! Apache sera bien installé"
fi
sleep 1

echo -e "\e[97mEst-ce que tu veux installer php7.0?"
echo "1. Oui"
echo "2. Non"
read php
if [ $php == 1 ]
then
  echo "sudo apt install -y php7.0" >> $dirSync/install-update.sh
  echo -e "\e[32mParfait! Php7.0 sera bien installé"
fi
sleep 1

echo -e "\e[97mEst-ce que tu veux installer libapache2-mod-php7.0?"
echo "1. Oui"
echo "2. Non"
read libapache
if [ $libapache == 1 ]
then
  echo "sudo apt install libapache2-mod-php7.0" >> $dirSync/install-update.sh
  echo "sudo service apache2 restart" >> $dirSync/install-update.sh
  echo -e "\e[32mParfait! libapache2-mod-php7.0 sera bien installé"
fi
sleep 1

echo -e "\e[97mEst-ce que tu veux installer une licorne à moteur toute mignonne?"
echo "1. Oui"
echo "2. Non"
read unicorn
if [ $unicorn == 1 ]
then
  echo -e "\e[96mMouahahah! Ca existe pas les licornes à moteur!"
else
  echo -e "\e[96mTu fais bien, c'est beaucoup trop d'entretien..."
fi
sleep 1


sed -i "s/inline:\ <<-SHELL/path: \"$dirSync\/install-update.sh\"/" 'Vagrantfile'


vagrant up
vagrant ssh
