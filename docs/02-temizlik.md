# 2. Yedek ve temizlik

## Önce yedek

```bash
./scripts/backup.sh
```

`backup/<tarih-saat>/` altına paket listelerini, tüm `settings` değerlerini, `getprop` çıktısını ve
varsayılan ana ekranı kaydeder. Bu klasörde cihazına özel bilgiler var; **GitHub'a yükleme**
(`.gitignore` zaten dışarıda bırakıyor).

## Temizlik nasıl çalışıyor

```bash
DRY_RUN=1 ./scripts/debloat.sh   # önce ne yapacağını gör
./scripts/debloat.sh
```

Her paket `pm disable-user --user 0` ile **devre dışı** bırakılır. Uygulama kutuda kalır, sadece
çalışmaz ve görünmez. **Ayarlar → Uygulamalar → Sistem uygulamaları** altından ya da
`adb shell pm enable <paket>` ile tek tek, `./scripts/restore.sh` ile toptan geri açılır.

Kullandığın bir şey varsa `scripts/debloat.txt` içinde o satırın başına `#` koy.

## Kapatılanlar ve nedenleri

Paketlerin ne yaptığı, onları **başlatmadan** `dumpsys package <paket>` ile incelendi: hangi
olaylara tepki veriyor, hangi izinleri var. Fabrika/test uygulamaları özellikle hiç açılmadı; bazı
Amlogic/CVTE kutularında fabrika menüsünü açmak kalıcı ayar değişikliklerine yol açabiliyor.

| Paket | Ne yapıyor | Neden kapatıldı |
|---|---|---|
| `com.google.android.feedback` | Google geri bildirim | Veri toplama |
| `com.google.android.tv.bugreportsender` | Hata raporu gönderici | Veri toplama |
| `com.droidlogic.readlog` | USB bellek takılınca sistem loglarını ona kopyalar | Gereksiz, log izni geniş |
| `com.sdmc.facTest` | Fabrika test uygulaması, açılışta çalışır | Son kullanıcıya gereksiz |
| `com.google.android.tvrecommendations` | Eski ana ekrandaki öneri satırları | Ana ekran değişince işe yaramıyor |
| `com.sdmc.leakbackcustomer` | Operatörün eski ana ekrana eklediği satırlar ve widget'lar | Aynı |
| `android.autoinstalls.config.sdmc` | Play üzerinden ortak uygulamaları otomatik kurma | İstenmeyen kurulum |
| `com.sdmc.autorunapp` | Açılışta operatör uygulamasını başlatır | Açılışta istediğin ekran gelsin |
| `com.google.android.katniss` | Google Asistan, sesli arama | Tercih: mikrofon tuşu çalışmaz olur |
| `com.google.android.apps.mediashell` | Chromecast alıcısı | Tercih: telefondan yansıtma gider |
| `com.google.android.videos` | Play Filmler | Kullanılmıyor |
| `com.google.android.play.games` | Play Oyunlar | Kullanılmıyor |
| `com.google.android.marvin.talkback` | Ekran okuyucu | Kapalıydı, kullanılmıyor |
| `com.android.printspooler` | Yazdırma | TV'de gereksiz |
| `com.android.camera2`, `com.android.gallery3d` | Kamera, galeri | Kutuda kamera yok |

Resmi YouTube (`com.google.android.youtube.tv`) listede **yorum satırında**. Kapatmadan önce
[5. Kumanda tuşları](05-kumanda-tuslari.md)'nı oku.

## Asla dokunma

| Paket | Neden |
|---|---|
| `com.sdmc.GlobalKey` | Kumandanın YouTube / Google Play / TV+ tuşlarını işliyor |
| `com.sdmc.standbyserver` | Bekleme modu |
| `com.sdmc.bluetoothconnect` | Kumanda eşleştirme |
| `com.sdmc.disablecec` | HDMI-CEC'i sadece ilk açılışta kapatıyor; zararsız |
| `com.sdmc.factorymonitor` | Paket kaldırmayı izliyor, tam ne yaptığı belli değil |
| `com.droidlogic`, `com.droidlogic.*` | Amlogic sistem, görüntü, Bluetooth ayarları |
| `com.droidlogic.otaupgrade` | Yazılım güncellemeleri |
| `com.google.android.tungsten.setupwraith` | Kurulum sihirbazı ve kumanda eşleştirme |
| `com.android.vending`, `com.google.android.gms` | Play Store, Play Hizmetleri |
| `com.google.android.inputmethod.latin` | Ekran klavyesi |

## Kapatılamayan

`com.google.android.tv.remote.service` (telefondan kumanda, ~14 MB) hem `disable-user` hem
`pm uninstall --user 0` sonrası **her açılışta geri geliyor**. Listede yok. Bir faydası da var:
kumandayı bulamazsan telefondaki Google TV uygulamasıyla kutuyu yönetebilirsin.

## TV+ uygulaması

TV+ (`com.turkcell.ott`) listede yok, çünkü çoğu kişi kullanıyor. Kullanmıyorsan:

```bash
adb shell pm disable-user --user 0 com.turkcell.ott    # ya da
adb shell pm uninstall --user 0 com.turkcell.ott       # kullanıcı için kaldır
```

İkisi de geri alınır (`pm enable` / `cmd package install-existing com.turkcell.ott`). Kaldırınca
kumandanın TV+ tuşu Play Store'daki TV+ sayfasını açar; başka bir uygulamaya atamak için
[5. Kumanda tuşları](05-kumanda-tuslari.md).

## Hız ayarları

```bash
./scripts/optimize.sh
```

| Ayar | Değer | Fabrika |
|---|---|---|
| Animasyonlar (`*_animation_scale`) | 0.5 | 1.0 |
| Arka planda tutulan uygulama (`max_cached_processes`) | 8 | sistem varsayılanı |
| Uyku süresi | 60 dk (`SLEEP_MIN=`) | 180 dk |
| Özel DNS | `dns.adguard-dns.com` (`ADBLOCK_DNS=0` ile atla) | otomatik |

AdGuard DNS reklam ve izleyici alan adlarını sistem genelinde engeller; YouTube reklamlarını
engellemez (onu SmartTube yapar). Bir uygulama bozulursa kapat:
`adb shell settings put global private_dns_mode opportunistic`.

Google'a teşhis verisi gönderimini kapatmak için ADB ayarı kalıcı değil (`send_action_app_error`
Play Hizmetleri tarafından birkaç saatte geri açılıyor). Menüden kapat:
**Ayarlar → Cihaz Tercihleri → Kullanım ve Teşhis → Kapalı**.

## Kontrol

```bash
./scripts/status.sh
```

Sonraki adım: [3. Yeni ana ekran](03-ana-ekran.md)
