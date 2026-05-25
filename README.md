# Kancionál - server

V následujícím repozitáři naleznete zdrojové kódy pro Kancionál server,
který je zapotřebí mít k dispozici v každém kostele, kde chcete mít dostupné centrální nastavování skladeb všem připojeným účastníkům bohoslužeb nebo i jen pro ovládání číselníků.

## Prerekvizity

V první řadě je zapotřebí mít v kostele vytvořenou veřejnou Wi-Fi síť, na kterou se budou moci varhanící a případně i návštěvníci se svými zařízeními připojit.
Pokud by se mělo jednat o síť přístupnou široké veřejnosti, tak z praktických důvodů nedoporučuji, aby daná síť měla přístup na internet. Pokud by však šlo o zaheslovanou síť jen pro varhaníky, je lepší mít na ní přístup k internetu. Ne proto, že by jej aplikace vyžadovala, ale protože mají mobilní zařízení problém s připojováním k sítím, které nemají přístup na internet.

Při vytváření Wi-Fi sítě mějte na paměti, že je jejím signálem zapotřebí pokrýt oblast celého kostela, nebo jen té části, kde se vyskytují účastníci bohoslužeb.
Druhým podstatným parametrem při vytváření Wi-Fi sítě je počet zařízení, která by se měla být schopná současně k síti připojit a komunikovat.
V tomto bodě osobně doporučuji zařízení **Ubiquiti od společnosti UniFi**, která jsou schopná pokrýt velké prostory a zároveň obsloužit 250 a více zařízení současně.

*Pro informaci: klasické Wi-Fi routery dokáží současně obsloužit pouze 8 až 16 zařízení.*


## Server
Za server je považováno zařízení Raspberry Pi, na kterém je nainstalovaný operační systém Raspbian **(doporučuji Legacy Full verzi systému - Bullseye či Bookworm)** v a které je připojené k lokální síti v kostele a má **aktivní službu mDNS prostřednictvím programu avahi.**

## Zdrojové kódy
Soubory v jednotlivých složkách korespondují s adresářovou strukturou tohoto operačního systému. Pro správnou funkci je zapotřebí mít na systému nainstalované
potřebné balíky v závislosti na verzi zařízení, které vytváříte.

V tomto repozitáři se nacházejí zdrojové kódy pro tři druhy zařízení (každý druh ve vlastní složce):
1. server
2. číselník
3. kombinace (server s číselníkem dohromady)

**V každé složce naleznete pokyny specifické pro danou verzi a instalační skript. Stačí si tedy jen danou složku zkopírovat na cílové zařízení a spustit v ní příkaz `sudo ./install.sh` .**

Pro ovládání serveru je zapotřebí mít nainstalovanou aplikaci [Kancionál-Server](https://play.google.com/store/apps/details?id=jozkar.kancional.server), která je zdarma k dospozici pro zařízení s operačním systémem Android v obchodu Google Play.

# Přídání podpory pro zobrazování liturgických názvů u ordinárií

Přihlaste se na číselník pomocí ssh, otevřete si se `sudo` příkazem soubor `/var/www/html/index.php` nebo `/var/www/html/index.html` a upravte řádek, který obsahuje

```js
$("#verse .centered").html(answer.verse+". sloka");
```

za následující kód
```js
if(isFinite(answer.verse)){
   $("#verse .centered").html(answer.verse+". sloka");
} else {
   $("#verse .centered").html(answer.verse);
}
``` 

a restartujte službu nebo celé zařízení.

# Copyright

Autorem zdrojového kódu i mobilní aplikace je Josef Řídký.
Zdrojový kód serveru a číselníku je dán volně k dispozici pod licencí [Creative Common 4.0 BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/)
