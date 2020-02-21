# Server
Následující složka obsahuje zdrojový kód pro zprovoznění samostatného serveru na jednom zařízení Raspberry Pi s operačním systémem Rasbpian.

Server je tvořen zařízením Raspberry Pi, kterému je pevně přidělena adresa 10.0.0.1. Z důvodu bezpečnosti doporučuji, aby přiřazení této adresy bylo provedeno na straně směrovače a to na základe MAC adresy serveru.

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

Pro správné fungování celého serveru je zapotřebí upravit soubor `/var/www/html/server.js`, ve kterém si musíte vymyslet své unikátní varhanické heslo, které bude zapotřebí zadat do mobilní aplikace Kancionál - server, abyste byli schopni na serveru cokoli nastavovat.

V souboru `/var/www/html/server.js` nalezněte řádek `const passwd = "SET-YOUR-PASSWORD";` a nahraďte řetězec `SET-YOUR-PASSWORD` vámi zvoleným heslem.

Po nakopírování, nastavení vlastnictví, přístupových práv a hesla je zapotřebí povolit automatické spuštění nově přidané služby:

```
sudo systemctl enable startup
sudo systemctl start startup
```

Jako poslední se ujistěte, že je zařízení připojené k Wi-Fi síti (není-li zařízení připojeno Ethernet kabelem) v kostele a že se k této síti dokáže po startu samo připojit.

Na závěr restartujte celé zařízení.

## Řešení problémů

V případě problémů s fungováním serveru můžete zkontrolovat stav služby a chybový výstup serveru pomocí příkazu:

```
systemctl status startup
```

V případě přetrvávajících problémů mě kontaktujte na emailu [J.Ridky@gmail.com](mailto:J:Ridky@gmail.com).
