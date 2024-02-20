#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Spusťte tento script jako root."
  exit
fi

#instalace balicku
apt-get install nodejs -y || { echo "Systému se nepodařilo nainstalovat potřebné balíky. V instalaci číselníku nelze pokračovat. Tip: Zkontrolujte si připojení k internetu."; exit 1; }

#kopirovani nastaveni
cp ./etc/avahi/services/kancional.service /etc/avahi/services/

#uprava avahi konfigurace
sed -i 's/#host-name=foo/host-name=kancional/g' /etc/avahi/avahi-daemon.conf
systemctl restart avahi-daemon.service

#instalace serveru

cp ./lib/systemd/system/* /lib/systemd/system/
chmod 0644 /lib/systemd/system/startup.service
chown root:root /lib/systemd/system/startup.service

cp ./usr/bin/* /usr/bin/
chmod 0755 /usr/bin/startup

rm /var/www/html/index.html
cp -r ./var/www/html /var/www/html/
chmod 0644 /var/www/html/*
chown root:root /var/www/html/*

sudo systemctl enable startup
sudo systemctl start startup

echo "Číselník nainstalován. Změňte si heslo v souboru /var/www/html/server.js a restartujte zařízení příkazem - reboot."
