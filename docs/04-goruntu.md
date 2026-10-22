# 4. Görüntü ayarı

## Sorun: 4K + YCbCr 4:2:0

Kutu, bağlı ekranın 4K kabul ettiğini görünce **2160p 59.94 Hz, YCbCr 4:2:0** gönderebiliyor. Bu
rehberin test edildiği kutu 1080p bir bilgisayar monitörüne (Acer KG242Y P) bağlıydı ve tam olarak
bunu yapıyordu:

- Monitör 4K görüntüyü alıp kendi 1080p paneline **küçültüyor**: yazılar ve kenarlar bulanık.
- **4:2:0** renk bilgisinin bir kısmını atıyor: ince renkli yazılarda renk taşması, soluk renkler.
- Küçültme işlemi küçük bir gecikme ekliyor.

Arayüz zaten 1920×1080 çiziliyor; 4K çıkış sadece videoda fark eder, o da ekran gerçekten 4K ise.

## Kontrol et

```bash
adb -s $TV:5555 shell cat /sys/class/amhdmitx/amhdmitx0/config | head -4
```

| `cur_VIC` | Anlamı |
|---|---|
| `16` | 1080p 60 Hz |
| `31` | 1080p 50 Hz |
| `97` | 2160p 60 Hz (4:4:4 / 4:2:2) |
| `353` | 2160p 60 Hz **YCbCr 4:2:0** (Amlogic `256 + 97`) |

`colorspace: 420` görüyorsan ve ekranın 4K değilse düzelt.

Ekranın ne olduğunu kutunun gördüğü EDID'den de okuyabilirsin:

```bash
adb -s $TV:5555 shell cat /sys/class/amhdmitx/amhdmitx0/rawedid
adb -s $TV:5555 shell cat /sys/class/amhdmitx/amhdmitx0/disp_cap
```

`rawedid`'in içinde ekranın modeli (`fc 00` bloğu) ve kendi çözünürlüğü (ilk zamanlama bloğu) yazar.

## Düzelt

ADB'nin (shell kullanıcısı) çözünürlüğü doğrudan değiştirme yetkisi yok
(`/sys/class/display/mode` yazılamıyor). Menüden:

**Ayarlar → TV settings → Display → Screen resolution**

![Çözünürlük menüsü](../images/cozunurluk-menusu.jpg)

1. **Display Mode → 1080p-59.94hz** (ekranın 4K değilse). Kutu "8 saniye içinde onaylamazsan
   eski ayara dönerim" diye sorar; görüntü geldiyse **OK**.
2. **Color Space Settings → YCbCr444** (1080p'ye geçince genelde kendisi seçiyor).
3. **Color Depth Settings**: otomatik bırak.
4. **Auto switch to best resolution**: kapalı kalsın; açarsan tekrar 4K'ya dönebilir.

Ekran kararırsa hiçbir şeye basma: 8 saniye sonra eski ayara döner.

Sonuç (test kutusu): `cur_VIC: 16`, `colorspace: 444`, yeniden başlatmadan sonra da kalıcı.

## Ekranın gerçekten 4K TV ise

- **Display Mode → 2160p-59.94hz** kalsın.
- **Color Space**: TV destekliyorsa 4:4:4 ya da 4:2:2; 4:2:0 4K60'ta HDMI 2.0 bant genişliği için
  normal, görüntü farkı TV'de az.
- HDR kutuda **SDR** görünüyorsa ve TV'n HDR destekliyorsa HDR'ı otomatik bırak.

## Diğer ses/görüntü notları

- **HDMI-CEC**: kutu ilk açılışta CEC'i kapatıyor (`com.sdmc.disablecec`). TV kullanıyorsan Ayarlar'daki HDMI CEC
  seçeneğinden aç (menü yolu yazılım sürümüne göre değişebilir). Kutuyu açınca TV de açılır. Bilgisayar monitörleri CEC
  desteklemez, monitörde kapalı kalsın.
- **Surround ses**: ses sistemi/soundbar bağlıysa dijital ses çıkışını **Otomatik** yap. Monitör ya da
  sadece TV hoparlörüyse PCM 2 kanal (fabrika ayarı) doğru.
- **Kare hızı**: kutu film kare hızlarına göre çıkışı zaten ayarlıyor (`frac_rate_policy=1`).

Sonraki adım: [5. Kumanda tuşları](05-kumanda-tuslari.md)
