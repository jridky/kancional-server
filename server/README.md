# Server
Následující složka obsahuje zdrojový kód pro zprovoznění samostatného serveru na jednom zařízení Raspberry Pi s operačním systémem Rasbpian.

Server je tvořen zařízením Raspberry Pi.

## Potřebné balíčky

Pro chod serveru je zapotřebí mít nainstalovaný balíček nodejs.

Instalaci provedete příkazem:

```
sudo apt-get install nodejs
```

V popisu předpokládám, že při instalaci systému byl jako název pro uživatele zvolen řetězec **pi**.

## Instalace číselníku

Pro instalaci je zapotřebí nakopírovat všechny soubory ze zde uvedených složek do adresářů na zařízení.

Nakopírovaným souborům je zapotřebí nastavit správně vlastníka i přístupová práva.

Pro soubor pod složkou `lib` by měl být vlastníkem uživatel a skupina **root**. Přístupová práva nastavte na **0644**.

Pro soubory pod složkou `var` by měl být vlastníkem uživatel a skupina **root**. Souborům postačí práva **0644**, složkám **0755**.

Pro soubory pod složkou `etc` by měl být vlastníkem uživatel a skupina **root**. Souborům postačí práva **0644**, složkám **0755**.

Pro správné fungování celého serveru je zapotřebí upravit soubor `/var/www/html/server.js`, ve kterém si musíte vymyslet své unikátní varhanické heslo, které bude zapotřebí zadat do mobilní aplikace Kancionál - server, abyste byli schopni na serveru cokoli nastavovat.

V souboru `/var/www/html/server.js` nalezněte řádek `const passwd = "SET-YOUR-PASSWORD";` a nahraďte řetězec `SET-YOUR-PASSWORD` vámi zvoleným heslem.

Po nakopírování, nastavení vlastnictví, přístupových práv a hesla je zapotřebí povolit automatické spuštění nově přidané služby:

```
sudo systemctl enable startup
sudo systemctl start startup
```

Dále je zapotřebí nastavit službu mDNS, kterou zajišťuje služba `avahi`. Tato služba by již měla být na vašem Raspberry Pi automaticky nainstalovaná, povolená a spuštěná. Toto můžete ověřit příkazem:

```
systemctl status avahi-daemon.service
```
kde byste měli vidět danou službu povolenou (enabled) a spuštěnou (running).

První část nastavení této služby jste provedli nakopírováním souborů do složky `etc`.
Pro druhou část je zapotřebí upravit soubor `/etc/avahi/avahi-daemon.conf`.

V tomto souboru upravte jediný řádek:
```
#host-name=foo
```
opravte na 
```
host-name=kancional
```

Jako poslední se ujistěte, že je zařízení připojené k Wi-Fi síti (není-li zařízení připojeno Ethernet kabelem) v kostele a že se k této síti dokáže po startu samo připojit.

Na závěr restartujte celé zařízení.

## Řešení problémů

V případě problémů s fungováním serveru můžete zkontrolovat stav služby a chybový výstup serveru pomocí příkazu:

```
systemctl status startup
systemctl status avahi-daemon.service
```

V případě přetrvávajících problémů mě kontaktujte na emailu [J.Ridky@gmail.com](mailto:J:Ridky@gmail.com).
