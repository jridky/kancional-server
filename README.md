# Kancionál - server

V následujícím repozitáři naleznete zdrojové kódy pro Kancionál server,
který je zapotřebí mít k dispozici v každém kostele, kde chcete mít dostupné centrální nastavování skladeb všem připojeným účastníkům bohoslužeb.

## Prerekvizity

V první řadě je zapotřebí mít v kostele vytvořenou veřejnou Wi-Fi síť, na kterou se budou moci návštěvníci se svými zařízeními připojit.
Z praktických důvodů nedoporučuji, aby daná síť měla přístup na internet.

Při vytváření Wi-Fi sítě mějte na paměti, že je jejím signálem zapotřebí pokrýt oblast celého kostela, nebo jen té části, kde se vyskytují účastníci bohoslužeb.
Druhým podstatným parametrem při vytváření Wi-Fi sítě je počet zařízení, která by se měla být schopná současně k síti připojit a komunikovat.
V tomto bodě osobně doporučuji zařízení **Ubiquiti od společnosti UniFi**, která jsou schopná pokrýt velké prostory a zároveň obsloužit 250 a více zařízení současně.

*Pro informaci: klasické Wi-Fi routery dokáží současně obsloužit pouze 8 až 16 zařízení.*


## Server
Za server je považováno zařízení Raspberry Pi, na kterém je nainstalovaný operační systém Raspbian a které je připojené k lokální síti v kostele a má **pevně přidělenou IP adresu na hodnotu 10.0.0.1.**

## Zdrojové kódy
Soubory v jednotlivých složkách korespondují s adresářovou strukturou tohoto operačního systému. Pro správnou funkci je zapotřebí mít na systému nainstalované
potřebné balíky v závislosti na verzi zařízení, které vytváříte.

V tomto repozitáři se nacházejí zdrojové kódy pro tři druhy zařízení (každý druh ve vlastní složce):
1. server
2. číselník
3. kombinace (server s číselníkem dohromady)

V každé složce naleznete pokyny specifické pro danou verzi.

Pro ovládání serveru je zapotřebí mít nainstalovanou aplikaci [Kancionál-Server](https://play.google.com/store/apps/details?id=jozkar.kancional.server), která je zdarma k dospozici pro zařízení s operačním systémem Android v obchodu Google Play.

# Copyright

Autorem zdrojového kódu i mobilní aplikace je Josef Řídký.
Zdrojový kód serveru a číselníku je dán volně k dispozici pod licencí [Creative Common 4.0 BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/)
