# 9. Cihaz bilgileri

Test edilen kutudan ADB ile okunan bilgiler.

## Kimlik

| | |
|---|---|
| `ro.product.model` | `TV PLUS 4K BOX` |
| `ro.product.device` | `DV6069Y_TVPLUS` |
| `ro.product.name` | `TVPLUS_OTT` |
| Üretici | SDMC |
| `ro.build.fingerprint` | `TVPLUS/TVPLUS_OTT/DV6069Y_TVPLUS:10/QT/20230328:user/release-keys` |
| `ro.build.display.id` | `QT.20230328 release-keys` |
| Android / SDK | 10 / 29 |
| Güvenlik yaması | 2023-02-05 |
| Çekirdek | Linux 4.9.180 |

## Donanım

| | |
|---|---|
| İşlemci | Amlogic, kart `faraday`, 4 × ARMv8 (`ARMv8 Processor rev 4`) |
| Kullanıcı alanı | **32-bit** (`ro.product.cpu.abi = armeabi-v7a`) |
| RAM | 2 GB (Android'in gördüğü 1,94 GB; ~730 MB video için ayrılmış CMA) |
| ZRAM | 384 MB |
| Depolama | 4,1 GB kullanıcı alanı |
| Wi-Fi | 2,4 / 5 GHz |
| Bluetooth | Realtek |
| HDMI | 2.0, HDCP 2.2, en fazla 2160p60 |

## Video ve ses çözücüler

`/vendor/etc/media_codecs*.xml`'den:

| Biçim | Donanım |
|---|---|
| H.264 (AVC) | Var (`OMX.amlogic.avc.decoder.awesome2`, güvenli sürümü de) |
| HEVC (H.265) | Var |
| VP9 | Var |
| Dolby Vision | Var (çözücü listede) |
| MPEG-2, MPEG-4, VC-1, AVS, AVS2 | Var |
| **AV1** | **Yok** |
| DTS-HD | Var |

## Ön yüklü uygulamalar (seçmeler)

| Paket | Ne |
|---|---|
| `com.turkcell.ott` | TV+ (sistem uygulaması, Play'den güncelleniyor) |
| `com.netflix.ninja` | Netflix |
| `com.google.android.youtube.tv`, `.youtube.tvmusic` | YouTube, YouTube Music |
| `com.google.android.tvlauncher` | Ana ekran |
| `com.sdmc.*` | Üretici servisleri (tuşlar, bekleme, kumanda eşleştirme, fabrika testi...) |
| `com.droidlogic.*` | Amlogic sistem ve ayarlar |

Toplam 91 paket. Kullanıcı kısıtlaması yok, cihaz yöneticisi yok, `install_non_market_apps=1`:
ADB ile APK kurulumu serbest.

## Ağda

Kutu kendini `_googlecast._tcp` (Chromecast) olarak duyuruyor; açık portlar:

| Port | Servis |
|---|---|
| 5555 | ADB (sadece hata ayıklama açıkken) |
| 6466, 6467 | Android TV Remote (telefon uygulaması) |
| 8008, 8009, 8443 | Chromecast |
| 9000 | Belirsiz |
