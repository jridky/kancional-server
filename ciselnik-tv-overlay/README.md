# Číselník -- TV overlay

Slouží pro zobrazení čísel písní a žalmových odpovědí jako překryv (overlay) přes živý obraz z kamery v hlavní lodi kostela. Výsledný obraz se přenáší do televizních obrazovek.

Pro zprovoznění je využíváno zařízení Raspberry Pi s operačním systémem Raspberry Pi OS (Bullseye, Bookworm i Trixie). Číselník vyžaduje v síti běžící server, ke kterému se připojuje přes WebSocket.

Do zařízení je zapotřebí přivést obraz z kamery a výsledný obraz poslat do televizních obrazovek. Ve většině případů platí, že vstup z kamery je realizován pomocí HDMI a výstup z Raspberry Pi pomocí Composite Video či HDMI výstupu.

Pro získání výstupu z kamery jako vstup do Raspberry Pi se osvědčilo zařízení Video Capture Device od společnosti MyPin (k dostání např. na [Amazonu](https://www.amazon.com/MYPIN-Capture-Gamepad-Streaming-Compatible/dp/B07MZQJYYM/)). Pro zpracování takto získaného obrazu je zapotřebí USB 3 připojení, kterým disponuje Raspberry Pi 4B a novější.

## Instalace

Zkopírujte tuto složku na cílové Raspberry Pi a spusťte instalační skript:

```
sudo ./install.sh
```

Skript automaticky nainstaluje potřebné balíčky (Apache) a nakopíruje všechny soubory.

V popisu se předpokládá, že při instalaci systému byl jako název uživatele zvolen řetězec **pi**.

Po dokončení instalace restartujte zařízení. Při prvním spuštění je zapotřebí v prohlížeči povolit čtení obrazu z kamery — stiskněte klávesu F11 pro ukončení režimu celé obrazovky a v Chromiu povolte přístup ke kameře pro server localhost (zvolte možnost Povolit, nikoli Zeptat se).

## Úprava zobrazení

Ve výchozím nastavení jsou čísla písní, slok a žalmové odpovědi zobrazovány bílou barvou na černém pozadí.

Změnu barev můžete provést úpravou kaskádových stylů v souboru `/var/www/html/index.html`.

## Řešení problémů

V případě problémů s fungováním můžete zkontrolovat stav služby:

```
systemctl status startup
```

V případě přetrvávajících problémů mě kontaktujte na emailu [J.Ridky@gmail.com](mailto:J.Ridky@gmail.com).
