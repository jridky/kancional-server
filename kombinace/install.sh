#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Spusťte tento script jako root."
  exit
fi

#instalace balicku
apt-get install apache2 nodejs php -y || { echo "Systému se nepodařilo nainstalovat potřebné balíky. V instalaci číselníku nelze pokračovat. Tip: Zkontrolujte si připojení k internetu."; exit 1; }

#kopirovani nastaveni
cp ./etc/apache2/ports.conf /etc/apache2/
rm /etc/apache2/sites-available/000-default.conf
cp ./etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/
cp ./etc/avahi/services/kancional.service /etc/avahi/services/
cp ./etc/chromium.d/01-disable-update-check /etc/chromium.d/
cat ./etc/crontab >> /etc/crontab

#uprava avahi konfigurace
sed -i 's/#host-name=foo/host-name=kancional/g' /etc/avahi/avahi-daemon.conf
systemctl restart avahi-daemon.service

#instalace ciselniku a serveru

cp ./lib/systemd/system/* /lib/systemd/system/
chmod 0644 /lib/systemd/system/{serverstart,startup}.service
chown root:root /lib/systemd/system/{serverstart,startup}.service

cp ./usr/bin/* /usr/bin/
chmod 0755 /usr/bin/{donoff,startup}
chown root:root /usr/bin/donoff
chown pi:pi /usr/bin/startup

rm /var/www/html/index.html
cp ./var/www/html/* /var/www/html/
chmod 0644 /var/www/html/*
chown root:root /var/www/html/*

cp -r ./var/www/server /var/www/
chmod 0644 /var/www/server/*
chown root:root /var/www/server/*

# nastavení běhu na x11
sed /etc/lightdm/lightdm.conf -i -e "s/^#\\?user-session.*/user-session=LXDE-pi-x/"
sed /etc/lightdm/lightdm.conf -i -e "s/^#\\?autologin-session.*/autologin-session=LXDE-pi-x/"
sed /etc/lightdm/lightdm.conf -i -e "s/^#\\?greeter-session.*/greeter-session=pi-greeter/"

echo "Přepnuto na prostředí x11"

# Nastavení napájení
sed -i 's/#xserver-command=X/xserver-command=X -s 0 dpms/g' /etc/lightdm/lightdm.conf
if [ -e /boot/firmware/config.txt ] ; then
    sed -i 's/^dtoverlay/#dtoverlay/g' /boot/firmware/config.txt
else
    sed -i 's/^dtoverlay/#dtoverlay/g' /boot/config.txt
fi

sudo usermod -aG video www-data

sudo systemctl enable serverstart
sudo systemctl start serverstart
sudo systemctl enable startup

echo "Číselník nainstalován. Změňte si heslo v souboru /var/www/server/server.js a restartujte zařízení příkazem - reboot."
