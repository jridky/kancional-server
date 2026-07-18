#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Spusťte tento script jako root."
  exit
fi

# Detekce verze OS
. /etc/os-release
IS_BOOKWORM_PLUS=false
case "$VERSION_CODENAME" in
    jessie|stretch|buster|bullseye)
        IS_BOOKWORM_PLUS=false
        ;;
    *)
        IS_BOOKWORM_PLUS=true
        ;;
esac

# Dotaz na typ zobrazovacího zařízení
USE_CEC=false
read -p "Jaké zobrazovací zařízení bude připojeno - televize nebo monitor? (t/m): " CEC_ANSWER
if [ "$CEC_ANSWER" = "t" ] ; then
    USE_CEC=true
fi

#instalace balicku
PACKAGES="apache2 php"
if [ "$USE_CEC" = true ] ; then
    PACKAGES="$PACKAGES v4l-utils"
fi
if [ "$IS_BOOKWORM_PLUS" = true ] ; then
    PACKAGES="$PACKAGES wlopm wtype x11-xserver-utils"
elif [ "$USE_CEC" = true ] ; then
    PACKAGES="$PACKAGES x11-xserver-utils"
fi
apt-get install $PACKAGES -y || { echo "Systému se nepodařilo nainstalovat potřebné balíky. V instalaci číselníku nelze pokračovat. Tip: Zkontrolujte si připojení k internetu."; exit 1; }

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
chmod 0755 /usr/bin/{donoff,startup}
chown root:root /usr/bin/donoff
chown pi:pi /usr/bin/startup

rm /var/www/html/index.html
cp ./var/www/html/* /var/www/html/
chmod 0644 /var/www/html/*
chown root:root /var/www/html/*

if [ "$IS_BOOKWORM_PLUS" = false ] ; then
    # nastavení běhu na x11
    sed /etc/lightdm/lightdm.conf -i -e "s/^#\\?user-session.*/user-session=LXDE-pi-x/"
    sed /etc/lightdm/lightdm.conf -i -e "s/^#\\?autologin-session.*/autologin-session=LXDE-pi-x/"
    sed /etc/lightdm/lightdm.conf -i -e "s/^#\\?greeter-session.*/greeter-session=pi-greeter/"
    echo "Přepnuto na prostředí x11"
fi

# Nastavení napájení
sed -i 's/#xserver-command=X/xserver-command=X -s 0 dpms/g' /etc/lightdm/lightdm.conf
if [ "$IS_BOOKWORM_PLUS" = false ] && [ "$USE_CEC" = false ] ; then
    if [ -e /boot/firmware/config.txt ] ; then
        sed -i 's/^dtoverlay/#dtoverlay/g' /boot/firmware/config.txt
    else
        sed -i 's/^dtoverlay/#dtoverlay/g' /boot/config.txt
    fi
fi

# Prevence hotplug waggle na Bookworm+
if [ "$IS_BOOKWORM_PLUS" = true ] ; then
    if [ -e /boot/firmware/cmdline.txt ] ; then
        CMDLINE_FILE="/boot/firmware/cmdline.txt"
    else
        CMDLINE_FILE="/boot/cmdline.txt"
    fi
    if ! grep -q 'vc4.force_hotplug' "$CMDLINE_FILE" ; then
        sed -i 's/$/ vc4.force_hotplug=3/' "$CMDLINE_FILE"
    fi
fi

sudo usermod -aG video www-data

# Na Bookworm+ povolit www-data spouštět wlopm jako pi (pro ovládání displeje z PHP)
if [ "$IS_BOOKWORM_PLUS" = true ] ; then
    echo "www-data ALL=(pi) NOPASSWD: /usr/bin/wlopm, /usr/bin/env" > /etc/sudoers.d/donoff
    chmod 0440 /etc/sudoers.d/donoff
fi

# Na Bookworm+ nastavit skrytí kurzoru přes labwc
if [ "$IS_BOOKWORM_PLUS" = true ] ; then
    LABWC_DIR="/home/pi/.config/labwc"
    mkdir -p "$LABWC_DIR"

    # Zkopírovat systémový rc.xml pokud lokální neexistuje
    if [ ! -e "$LABWC_DIR/rc.xml" ] ; then
        cp /etc/xdg/labwc/rc.xml "$LABWC_DIR/rc.xml"
    fi

    # Přidat keybind pro HideCursor pokud ještě není
    if ! grep -q 'HideCursor' "$LABWC_DIR/rc.xml" ; then
        sed -i '/<\/keyboard>/i\    <keybind key="A-W-h">\n      <action name="HideCursor" \/>\n    <\/keybind>' "$LABWC_DIR/rc.xml"
    fi

    chown -R pi:pi "$LABWC_DIR"
fi

sudo systemctl enable startup

echo "Číselník nainstalován. Restartujte zařízení příkazem - reboot."
