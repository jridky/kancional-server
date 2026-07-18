# Kombinace číselníku a serveru -- dual-screen

Následující složka obsahuje verzi kódu pro zařízení, které má zastávat dvojí úlohu: má být serverem i číselníkem zároveň, s podporou zobrazování na dvou monitorech/televizích současně (mirroring). Jedná se o Raspberry Pi s operačním systémem Raspberry Pi OS (Bullseye, Bookworm i Trixie), ke kterému jsou pomocí HDMI kabelů připojeny dva displeje.

Oba displeje zobrazují stejný obsah. Pokud mají displeje různé rozlišení, systém automaticky detekuje rozlišení obou výstupů a přizpůsobí zobrazení.

## Instalace

Zkopírujte tuto složku na cílové Raspberry Pi a spusťte instalační skript:

```
sudo ./install.sh
```

Skript automaticky:
- nainstaluje potřebné balíčky (Apache, PHP, Node.js a další dle verze OS)
- nakopíruje a nastaví všechny potřebné soubory a služby
- nakonfiguruje službu mDNS (avahi) pro dostupnost zařízení jako `kancional.local`
- na Bookworm+ nastaví Wayland prostředí (wlopm, labwc, skrytí kurzoru)
- na starších systémech nastaví X11 prostředí

Během instalace se skript zeptá, zda bude připojeno zobrazovací zařízení typu televize nebo monitor. Při volbě televize se nainstaluje podpora pro HDMI-CEC, která umožňuje automatické zapínání a vypínání televize.

V popisu se předpokládá, že při instalaci systému byl jako název uživatele zvolen řetězec **pi**.

Po dokončení instalace je zapotřebí upravit soubor `/var/www/server/server.js`, ve kterém si musíte vymyslet své unikátní varhanické heslo. V souboru nalezněte řádek `const passwd = "SET-YOUR-PASSWORD";` a nahraďte řetězec `SET-YOUR-PASSWORD` vámi zvoleným heslem.

Na závěr restartujte zařízení.

## Dual-screen mirroring

Mirroring dvou displejů je nastaven automaticky skriptem `monitors.sh`, který se spouští při startu systému. Skript automaticky detekuje připojené HDMI výstupy a jejich rozlišení:

- **Na X11 (Bullseye)** -- používá `xrandr` s parametry `--same-as` a `--scale-from` pro mirroring s přizpůsobením rozlišení
- **Na Wayland (Bookworm+)** -- používá `wlr-randr` s pozicováním obou výstupů na `--pos 0,0` a automatickým výpočtem scale faktoru

Vypínání a zapínání displejů probíhá přes DPMS (xset dpms na X11) nebo wlopm (na Wayland), čímž je zachována konfigurace mirroringu i po delším vypnutí.

## Podporované systémy

- **Raspberry Pi OS Bullseye a starší** -- X11, xset dpms pro ovládání displeje, xrandr pro mirroring
- **Raspberry Pi OS Bookworm** -- Wayland (labwc) i X11, wlopm/xset dpms pro ovládání displeje, wlr-randr pro mirroring
- **Raspberry Pi OS Trixie** -- Wayland (labwc) i X11, wlopm/xset dpms pro ovládání displeje, wlr-randr pro mirroring

## HDMI-CEC

Pokud je k Raspberry Pi připojena televize s podporou HDMI-CEC, číselník dokáže televizi automaticky zapínat a vypínat. CEC je nutné povolit v nastavení televize (Samsung: Anynet+, LG: SimpLink, Sony: Bravia Sync, Philips: EasyLink apod.).

Při kombinaci televize a monitoru se CEC příkazy posílají na všechny připojené HDMI porty. Monitor CEC nepodporuje a příkaz tiše ignoruje, televize se vypne/zapne.

## Úprava zobrazení

Ve výchozím nastavení jsou čísla písní zobrazována bíle na černém pozadí.

Změnu barev můžete provést úpravou kaskádových stylů v souboru `/var/www/html/index.php`.

## Řešení problémů

#### Vyskakovací okno o aktualizaci Chromia
V systému Raspberry Pi OS se cca od verze 78 aplikace Chromium stává, že po určité době vyskočí menší okno s informací o aktualizaci aplikace Chromium. Jedná se o novou funkci, která dříve v Chromiu nebyla, ovšem má za následek překrytí okna číselníku touto hláškou.

Řešením je přidání souboru, který je umístěn pod složkou `/etc/chromium.d/` tohoto repozitáře do stejného místa na Raspberry Pi. Dále je potřeba přidat řádek do `/etc/crontab`, jako je uveden ve stejném souboru tohoto repozitáře.

V případě problémů s fungováním zařízení můžete zkontrolovat stav služeb:

```
systemctl status startup
systemctl status serverstart
systemctl status avahi-daemon.service
```

V případě přetrvávajících problémů mě kontaktujte na emailu [J.Ridky@gmail.com](mailto:J.Ridky@gmail.com).
