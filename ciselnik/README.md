# Číselník

Následující složka obsahuje zdrojový kód pro zprovoznění samostatného číselníku na jednom zařízení Raspberry Pi s operačním systémem Raspberry Pi OS (Bullseye, Bookworm i Trixie).

Číselník je tvořen zařízením Raspberry Pi, ke kterému je pomocí HDMI kabelu připojen monitor nebo televize. Číselník vyžaduje v síti běžící server (ze složky `server` nebo `kombinace`), ke kterému se připojuje přes WebSocket.

Při výběru monitoru doporučuji dát přednost takovým, které jsou lehčí, bez velkého rámečku či příliš rušivých ovládacích tlačítek, s možností upevnění na stěnu, poměrem stran 4:3 či 16:9, matným displejem a vyšší svítivostí.

## Instalace

Zkopírujte tuto složku na cílové Raspberry Pi a spusťte instalační skript:

```
sudo ./install.sh
```

Skript automaticky:
- nainstaluje potřebné balíčky (Apache, PHP a další dle verze OS)
- nakopíruje a nastaví všechny potřebné soubory a služby
- na Bookworm+ nastaví Wayland prostředí (wlopm, labwc, skrytí kurzoru)
- na starších systémech nastaví X11 prostředí

Během instalace se skript zeptá, zda bude připojeno zobrazovací zařízení typu televize nebo monitor. Při volbě televize se nainstaluje podpora pro HDMI-CEC, která umožňuje automatické zapínání a vypínání televize.

V popisu se předpokládá, že při instalaci systému byl jako název uživatele zvolen řetězec **pi**.

Po dokončení instalace restartujte zařízení.

## Podporované systémy

- **Raspberry Pi OS Bullseye a starší** -- X11, vcgencmd/xset dpms pro ovládání displeje
- **Raspberry Pi OS Bookworm** -- Wayland (labwc) i X11, wlopm/xset dpms pro ovládání displeje
- **Raspberry Pi OS Trixie** -- Wayland (labwc) i X11, wlopm/xset dpms pro ovládání displeje

## HDMI-CEC

Pokud je k Raspberry Pi připojena televize s podporou HDMI-CEC, číselník dokáže televizi automaticky zapínat a vypínat. CEC je nutné povolit v nastavení televize (Samsung: Anynet+, LG: SimpLink, Sony: Bravia Sync, Philips: EasyLink apod.).

## Úprava zobrazení

Ve výchozím nastavení jsou čísla písní zobrazována bíle na černém pozadí.

Změnu barev můžete provést úpravou kaskádových stylů v souboru `/var/www/html/index.php`.

## Řešení problémů

#### Vyskakovací okno o aktualizaci Chromia
V systému Raspberry Pi OS se cca od verze 78 aplikace Chromium stává, že po určité době vyskočí menší okno s informací o aktualizaci aplikace Chromium. Jedná se o novou funkci, která dříve v Chromiu nebyla, ovšem má za následek překrytí okna číselníku touto hláškou.

Řešením je přidání souboru, který je umístěn pod složkou `/etc/chromium.d/` tohoto repozitáře do stejného místa na Raspberry Pi. Dále je potřeba přidat řádek do `/etc/crontab`, jako je uveden ve stejném souboru tohoto repozitáře.

V případě problémů s fungováním číselníku můžete zkontrolovat stav služby:

```
systemctl status startup
```

V případě přetrvávajících problémů mě kontaktujte na emailu [J.Ridky@gmail.com](mailto:J.Ridky@gmail.com).
