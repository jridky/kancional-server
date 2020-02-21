# Kombinace číselníku a serveru

Následující složka obsahuje verzi kódu pro zařízení, které má zastávat dvojí úlohu: má být serverem i číselníkem zároveň.

Pro toto zařízení platí, že se jedná o Raspberry Pi ke kterému je pomocí HDMI kabelu připojen prakticky libovolný monitor a kterému je pevně přidělena adresa 10.0.0.1. Z důvodu bezpečnosti doporučuji, aby přiřazení této adresy bylo provedeno na straně směrovače a to na základe MAC adresy serveru.

Při výběru monitoru doporučuji dát přednost takovým, které jsou lehčí, bez velkého rámečku či příliš rušivých ovládacích tlačítek,
s možností upevnění na stěnu, poměrem stran 4:3 či 16:9, matným displejem a vyšší svítivostí.

## Potřebné balíčky

Pro chod tohoto zařízení je zapotřebí mít nainstalovaný HTTP server, webový prohlížeč Chromium a balíček nodejs. Webový prohlížeč by měl být součásti nainstalovaného systému. Webový server byl zvolen Apache 2.

Instalaci potřebných balíčků provedete příkazem:

```
sudo apt-get install apache2 nodejs
```

Po úspěšné instalaci upravte patřičné soubory pod složkou `/etc`, jako jsou uvedeny zde ve složce `etc` a povolte automatické spuštění HTTP serveru při startu systému:

```
sudo systemctl enable apache2
```

V popisu předpokládám, že při instalaci systému byl jako název pro uživatele zvolen řetězec **pi**.

## Instalace číselníku a serveru

Pro instalaci je zapotřebí nakopírovat všechny soubory ze zbývajících zde uvedených složek do adresářů na zařízení.

Nakopírovaným souborům je zapotřebí nastavit správně vlastníka i přístupová práva.

Pro soubory pod složkou `lib` by měl být vlastníkem uživatel a skupina **root**. Přístupová práva nastavte na **0644**.

Pro soubory pod složkou `usr` by měl být vlastníkem uživatel a skupina **root**. Výjimkou je soubor `startup`, který má mít ve vlastnictví uživatel a skupina **pi**. Přístupová práva nastavte všem na **0755**.

Pro soubory pod složkou `var` by měl být vlastníkem uživatel a skupina **root**. Důležité je však nastavit přístupová práva souboru `/var/www/html/state` na **0777**, pro zbývající soubory stačí práva **0644**.

Pro správné fungování serveru je zapotřebí upravit soubor `/var/www/server/server.js`, ve kterém si musíte vymyslet své unikátní varhanické heslo, které bude zapotřebí zadat do mobilní aplikace Kancionál - server, abyste byli schopni na serveru cokoli nastavovat.

V souboru `/var/www/server/server.js` nalezněte řádek `const passwd = "SET-YOUR-PASSWORD";` a nahraďte řetězec `SET-YOUR-PASSWORD` vámi zvoleným heslem.

Po nakopírování a nastavení vlastnictví a přístupových práv je zapotřebí povolit automatické spuštění nově přidaných služeb:

```
sudo systemctl enable donoff
sudo systemctl start donoff
sudo systemctl enable serverstart
sudo systemctl start serverstart
sudo systemctl enable startup
```
Po spuštění služby `startup` se spustí webový prohlížeč v režimu celé obrazovky. Pokud budete ještě potřebovat pracovat se systémem, stiskněte klávesu F11.
Spuštění služby `startup` provedete příkazem:

```
sudo systemctl start startup
```

Dále je zapotřebí upravit nastavení systému takovým způsobem, aby nedocházelo k automatickému vypínání obrazovky a přechodu do režimu spánku.

Otevřete si soubor `/etc/lightdm/lightdm.conf` jako root (pomocí sudo) a do části označené `[Seat*]` vložte následující řádek:

```
xserver-command=X -s 0 dpms
```

Jako poslední se ujistěte, že je zařízení připojené k Wi-Fi síti (není-li zařízení připojeno Ethernet kabelem) v kostele a že se k této síti dokáže po startu samo připojit.

Na závěr restartujte celé zařízení.

## Úprava zobrazení
Ve výchozím nastavení jsou čísla písní zobrazována červeně na černém pozadí. Pro čísla slok a žalmové odpovědi je použita bílá barva.

Změnu barev můžete provést úpravou kaskádových stylů v souboru `/var/www/html/index.php`.

## Řešení problémů

V případě problémů s fungováním zařízení můžete zkontrolovat stav služeb a chybový výstup serveru pomocí příkazů:

```
systemctl status startup
systemctl status serverstart
systemctl status donoff
```

V případě přetrvávajících problémů mě kontaktujte na emailu [J.Ridky@gmail.com](mailto:J:Ridky@gmail.com).