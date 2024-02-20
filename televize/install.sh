#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Spusťte tento script jako root."
  exit
fi

#instalace balicku
apt-get install apache2 -y || { echo "Systému se nepodařilo nainstalovat potřebné balíky. V instalaci číselníku nelze pokračovat. Tip: Zkontrolujte si připojení k internetu."; exit 1; }

#kopirovani nastaveni
cp ./etc/apache2/ports.conf /etc/apache2/
rm /etc/apache2/sites-available/000-default.conf
cp ./etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/
cp ./etc/chromium.d/01-disable-update-check /etc/chromium.d/
cat ./etc/crontab >> /etc/crontab

#instalace ciselniku

cp ./lib/systemd/system/* /lib/systemd/system/
chmod 0644 /lib/systemd/system/startup.service
chown root:root /lib/systemd/system/startup.service

cp ./usr/bin/* /usr/bin/
chmod 0755 /usr/bin/startup
chown pi:pi /usr/bin/startup

rm /var/www/html/index.html
cp ./var/www/html/* /var/www/html/
chmod 0644 /var/www/html/*
chmod 0777 /var/www/html/state
chown root:root /var/www/html/*

sudo systemctl enable startup

echo "Číselník nainstalován. Restartujte zařízení příkazem - reboot."
