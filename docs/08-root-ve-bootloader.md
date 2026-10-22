# 8. Root ve bootloader

Kısa cevap: **bu kutuda root için hazır bir yol yok ve gerekmiyor.**

## Kutunun durumu

```bash
adb shell getprop | grep -E "verifiedbootstate|vbmeta.device_state|veritymode|oem_unlock"
```

| Özellik | Değer | Anlamı |
|---|---|---|
| `ro.boot.vbmeta.device_state` | `locked` | Bootloader kilitli |
| `ro.boot.verifiedbootstate` | `green` | Doğrulamalı açılış etkin, sistem değiştirilmemiş |
| `ro.boot.veritymode` | `enforcing` | Sistem bölümü değişirse kutu açılmaz |
| `ro.oem_unlock_supported` | (boş) | Standart kilit açma desteği yok |
| `oem_lock` servisi | yok | Geliştirici seçeneklerinde "OEM kilidini aç" çıkmaz |
| SELinux | `Enforcing` | ADB'den yetki yükseltilemez |
| Güvenlik yaması | 2023-02-05 | Bilinen, hazır bir root açığı yok |

Geriye kalan yollar (değiştirilmiş yazılımı Amlogic USB Burning Tool ile yüklemek, açılış
zincirinde açık aramak) bu kutu için hazır değil ve kutuyu **açılmaz hale getirme** riski yüksek.
Fabrika yazılımı kamuya açık olmadığı için geri dönüş de yok.

## Açılabilseydi ne olurdu

Kazanılacaklar:

- Sistem uygulamalarını tamamen silmek, ev ağının tamamı için Pi-hole/AdGuard Home (port 53),
  menüde olmayan görüntü modları, uygulamaları verisiyle yedekleme.
- CoreELEC (sadece Kodi, Amlogic için) ya da Armbian (Linux: Docker, Jellyfin, Home Assistant).

Kaybedilecekler:

- **DRM seviyesi düşer**: Netflix ve diğer ücretli servisler HD'den 480p'ye iner ya da açılmaz.
- Google cihaz doğrulaması başarısız olur, bazı uygulamalar Play Store'da görünmez, güncelleme gelmez.
- Operatöre ait bir kutuyu bozmanın bedeli.

Bu kazanımların çoğu ayrı bir Raspberry Pi ya da mini PC ile risksiz yapılabilir.

## ADB ile yapılabilenler (root'suz)

Bu rehberdeki her şey: uygulama kapatma/kaldırma (kullanıcı için), APK kurma, ana ekran
değiştirme, ayarlar, erişilebilirlik servisi ile tuş atama, ekran görüntüsü, log okuma.
