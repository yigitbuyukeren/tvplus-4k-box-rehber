# 6. SmartTube

[SmartTube](https://github.com/yuliskov/SmartTube) Android TV için açık kaynaklı bir YouTube
istemcisi: reklam yok, SponsorBlock var, ayrıntılı kalite ayarları var. Play Store'da yok.

## İndirme

**Sadece resmi GitHub sürümlerinden indir.** Proje sahibi APK sitelerindeki kopyalara karşı uyarıyor.

Bu kutu **32-bit**, `armeabi-v7a` sürümünü al:

```bash
gh release download -R yuliskov/SmartTube -p 'SmartTube_stable_*_armeabi-v7a.apk'
```

ya da [Releases](https://github.com/yuliskov/SmartTube/releases) sayfasından
`SmartTube_stable_<sürüm>_armeabi-v7a.apk`.

İmzayı kontrol etmek istersen (Android SDK build-tools ile):

```bash
apksigner verify --print-certs SmartTube_stable_*_armeabi-v7a.apk
# Signer #1 certificate DN: CN=Yurii L, OU=Android Development, O=SmartTube, C=US
```

## Kurulum

```bash
adb -s $TV:5555 install -r SmartTube_stable_*_armeabi-v7a.apk
```

Paket adı: `org.smarttube.stable`. Sonraki güncellemeleri uygulama kendisi yapıyor.

## Bu kutu için önemli ayarlar

Kutunun video çözücüleri: **H.264, HEVC ve VP9 donanımla**; **AV1 donanım çözücüsü yok**.
YouTube bazı videoları AV1 gönderiyor; bu kutuda yazılımla çözülür, takılır.

| Ayar | Değer | Neden |
|---|---|---|
| Oynatıcı → Video formatı | **VP9** (AV1 kapalı) | Donanım çözücü; sorun olursa AVC |
| Oynatıcı → Kalite | En fazla **1080p 60** | Ekran 4K değilse fazlası RAM ve bant israfı |
| SponsorBlock | Açık: Sponsor, Kendi reklamı, Abone ol hatırlatması | Videolardaki reklam kısımlarını atlar |
| Hesaplar | Google hesabıyla giriş (telefonda kod girerek) | Abonelikler ve geçmiş |
| Arayüz → Ana sayfa bölümleri | Kullanmadıklarını kapat (Shorts, Oyun, Haber) | Daha hafif menü |
| Otomatik kare hızı | Kapalı | Kutu zaten doğru hızda; açılınca ekran bir an kararabilir |

Kumandanın YouTube tuşunun SmartTube'u açması için: [5. Kumanda tuşları](05-kumanda-tuslari.md).

Sonraki adım: [7. Geri alma ve güncellemeler](07-geri-alma.md)
