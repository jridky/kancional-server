# Televize
Pro zobrazení nastavených čísel a žalmových odpovědí v televizích, do kterých se přenáší obraz z kamer v hlavní lodi kostela slouží následující nastavení.

Opět platí, že pro zprovoznění je využíváno zařízení Raspberry Pi s operačním systémem Rasbpian.

Dále je zapotřebí do tohoto zařízení přivést obraz z kamery a také výsledný obraz poslat do televizních obrazovek. Možností vstupu i výstupu je vícero a nebudu je zde do detailu popisovat.
Ve většině případů však platí, že výstup z kamery je realizován pomocí HDMI a výstup z Raspberry Pi pomocí Coposite Video či HDMI výstupu. Záleží již na daných okolnostech v místě použití.

Pro získání výstupu z kamery jako vstup do Raspberry Pi se osvědčilo zařízení Video Capture Device od společnosti MyPin (k dostání např. na [Amazonu](https://www.amazon.com/MYPIN-Capture-Gamepad-Streaming-Compatible/dp/B07MZQJYYM/)). Pro zpracování takto získaného obrazu je zapotřebí USB 3 připojení, kterým v současné době disponuje pouze Raspberry Pi 4B.

## Potřebné balíčky

Pro chod televizního rozšíření je zapotřebí mít nainstalovaný HTTP server a webový prohlížeč Chromium. Webový prohlížeč by měl být součásti nainstalovaného systému. Webový server byl zvolen Apache 2.

Instalaci serveru provedete příkazem:

```
sudo apt-get install apache2
```

Po jeho nainstalování upravte patřičné soubory pod složkou `/etc`, jako jsou uvedeny zde ve složce `etc` a povolte automatické spuštění HTTP serveru při startu systému:

```
sudo systemctl enable apache2
```

V popisu předpokládám, že při instalaci systému byl jako název pro uživatele zvolen řetězec **pi**.

## Instalace televizního rozšíření

Pro instalaci je zapotřebí nakopírovat všechny soubory ze zbývajících zde uvedených složek do adresářů na zařízení.

Nakopírovaným souborům je zapotřebí nastavit správně vlastníka i přístupová práva.

Pro soubory pod složkou `lib` by měl být vlastníkem uživatel a skupina **root**. Přístupová práva nastavte na **0644**.

Pro soubory pod složkou `usr` by měl být vlastníkem uživatel a skupina **pi**. Přístupová práva nastavte na **0755**.

Pro soubory pod složkou `var` by měl být vlastníkem uživatel a skupina **root**. Přístupová práva nastavte **0644**.

Po nakopírování a nastavení vlastnictví a přístupových práv je zapotřebí povolit automatické spuštění nově přidané služby:

```
sudo systemctl enable startup
```
Po spuštění služby `startup` se spustí webový prohlížeč v režimu celé obrazovky. Při prvním spuštění je ještě zapotřebí v prohlížeči povolit čtení obrazu z kamery.
Spuštění služby `startup` provedete příkazem:

```
sudo systemctl start startup
```

Stiskněte klávesu F11 pro ukončení režimu celé obrazovky a v prohlížeči Chromium povolte přístup ke kameře pro server localhost (zvolte v nastavení možnost Povolit - nikoli Zeptat se).

Jako poslední se ujistěte, že je zařízení připojené k Wi-Fi síti (není-li zařízení připojeno Ethernet kabelem) v kostele a že se k této síti dokáže po startu samo připojit.

Na závěr restartujte celé zařízení.

## Úprava zobrazení
Ve výchozím nastavení jsou čísla písní, slok a žalmové odpovědi zobrazovány bílou barvou na černém pozadí.

Změnu barev můžete provést úpravou kaskádových stylů v souboru `/var/www/html/index.html`.

## Řešení problémů
V případě přetrvávajících problémů mě kontaktujte na emailu [J.Ridky@gmail.com](mailto:J:Ridky@gmail.com).
