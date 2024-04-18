# Číselník
Následující složka obsahuje zdrojový kód pro zprovoznění samostatného číselníku na jednom zařízení Raspberry Pi s operačním systémem Rasbpian.

Číselník je tvořen zařízením Raspberry Pi, ke kterému je pomocí HDMI kabelu připojen prakticky libovolný monitor.

Při výběru monitoru doporučuji dát přednost takovým, které jsou lehčí, bez velkého rámečku či příliš rušivých ovládacích tlačítek,
s možností upevnění na stěnu, poměrem stran 4:3 či 16:9, matným displejem a vyšší svítivostí.

## Potřebné balíčky

Pro chod číselníku je zapotřebí mít nainstalovaný HTTP server, PHP a webový prohlížeč Chromium. Webový prohlížeč by měl být součásti nainstalovaného systému. Webový server byl zvolen Apache 2.

Instalaci serveru provedete příkazem:

```
sudo apt-get install apache2 php
```

Po jeho nainstalování upravte patřičné soubory pod složkou `/etc`, jako jsou uvedeny zde ve složce `etc` a povolte automatické spuštění HTTP serveru při startu systému:

```
sudo systemctl enable apache2
```

V popisu předpokládám, že při instalaci systému byl jako název pro uživatele zvolen řetězec **pi**.

## Instalace číselníku

Pro instalaci je zapotřebí nakopírovat všechny soubory ze zbývajících zde uvedených složek do adresářů na zařízení.

Nakopírovaným souborům je zapotřebí nastavit správně vlastníka i přístupová práva.

Pro soubory pod složkou `lib` by měl být vlastníkem uživatel a skupina **root**. Přístupová práva nastavte na **0644**.

Pro soubory pod složkou `usr` by měl být vlastníkem uživatel a skupina **root**. Výjimkou je soubor `startup`, který má mít ve vlastnictví uživatel a skupina **pi**. Přístupová práva nastavte všem na **0755**.

Pro soubory pod složkou `var` by měl být vlastníkem uživatel a skupina **root**. Pro soubory stačí práva **0644**.

V terminálu spusťte následující příkaz pro zařazení uživatele do potřebné skupiny:
```
sudo usermod -aG video www-data
```

Po nakopírování a nastavení vlastnictví a přístupových práv a skupin je zapotřebí povolit automatické spuštění nově přidaných služeb:

```
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

#### Vyskakovací okno o aktualizaci Chromia
V systému Rasbpian se cca od verze 78 aplikace Chromium stává, že po určité době vyskočí menší okno s informací o aktualizaci aplikace Chromium. Jedná se o novou funkci, která dříve v Chromiu nebyla, ovšem má za následek překrytí okna číselníku touto hláškou.

Řešením je přidání souboru, který je umístěn pod složkou `/etc/chromium.d/` tohoto repozitáře do stejného místa na Raspberry Pi. Dále je potřeba přidat řádek do `/etc/crontab`, jako je uveden ve stejném souboru tohoto repozitáře.

V případě problémů s fungováním číselníku můžete zkontrolovat stav služeb a chybový výstup zařízení pomocí příkazů:

```
systemctl status startup
```

V případě přetrvávajících problémů mě kontaktujte na emailu [J.Ridky@gmail.com](mailto:J:Ridky@gmail.com).
