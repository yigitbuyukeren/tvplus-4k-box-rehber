# 5. Kumanda tuşları

## Tuşlar nasıl çalışıyor

Kumandanın tuş tablosu: `/vendor/usr/keylayout/Vendor_7545_Product_0171.kl`

| Tuş | Linux kodu | Android kodu |
|---|---|---|
| YouTube | 59 (`KEY_F1`) | `KEYCODE_BUTTON_4` |
| Google Play | 61 (`KEY_F3`) | `KEYCODE_BUTTON_5` |
| TV+ | 185 | `KEYCODE_BUTTON_10` (üretici adı: `SDMCEXTEND2`) |

Tuş tablosunda bir de Prime Video tuşu tanımlı (63, `KEYCODE_BUTTON_8`), ama bu kutunun
kumandasında öyle bir tuş yok; aynı yazılım başka kumandalarla da kullanılıyor olabilir.

Bu üç tuş "global tuş": hangi uygulamada olursan ol, Android bunları üreticinin servisi
**`com.sdmc.GlobalKey`**'e gönderiyor. Servis tuşa bağlı uygulamayı açıyor. Uygulama **kurulu
değilse** Play Store'daki sayfasını açıyor.

Kendin görmek için, tuşa basarken:

```bash
adb -s $TV:5555 shell getevent -lt          # ham tuş kodları
adb -s $TV:5555 logcat -s GlobalKey         # servisin ne yaptığı
```

## Sorun: YouTube'u kapatınca Google Play tuşu ölüyor

GlobalKey sadece uygulamanın **kurulu** olup olmadığına bakıyor, **devre dışı** olup olmadığına
bakmıyor. Resmi YouTube'u kapattıktan sonra YouTube tuşuna basınca:

```
java.lang.RuntimeException: Unable to start receiver com.sdmc.GlobalKey.GlobalKeyReceiver:
android.content.ActivityNotFoundException: No Activity found to handle Intent
{ flg=0x10000000 pkg=com.google.android.youtube.tv (has extras) }
```

Servis çöküyor. Art arda çökünce Android onu "bozuk süreç" olarak işaretliyor:

```
Unable to launch app com.sdmc.GlobalKey/1000 for broadcast Intent
{ act=android.intent.action.GLOBAL_BUTTON ... }: process is bad
```

Bundan sonra **üç tuşun hepsi** yeniden başlatana kadar çalışmıyor. Google Play tuşu "bozuldu"
gibi görünüyor ama asıl sebep YouTube tuşu.

## Çözüm: tuşları GlobalKey'den önce yakalamak

cleanyourtv ana ekranının bir erişilebilirlik servisi var (`InputKeyService`). Erişilebilirlik
servisleri tuşları, Android onları GlobalKey'e göndermeden önce görüyor; servis tuşu kendisi
işleyip yutuyor. Böylece GlobalKey hiç devreye girmiyor.

1. Ana ekranın `config.xml` dosyasında ([3. Yeni ana ekran](03-ana-ekran.md)):

   ```xml
   <string-array name="app_keys" translatable="false">
       <item>KEYCODE_BUTTON_4:org.smarttube.stable</item>   <!-- YouTube tuşu → SmartTube -->
       <item>KEYCODE_BUTTON_5:com.android.vending</item>    <!-- Google Play tuşu → Play Store -->
       <item>KEYCODE_BUTTON_10:com.netflix.ninja</item>     <!-- TV+ tuşu → Netflix -->
   </string-array>
   ```

   Paket adını istediğin uygulamayla değiştir. Paket adlarını görmek için:
   `adb shell pm list packages`.

2. Derle, kur, sonra servisi aç:

   ```bash
   adb -s $TV:5555 shell settings put secure enabled_accessibility_services com.gathin.tvhome/.InputKeyService
   adb -s $TV:5555 shell settings put secure accessibility_enabled 1
   ```

3. Yeniden başlat (GlobalKey'in "bozuk" işareti de böylece temizlenir) ve kontrol et:

   ```bash
   adb -s $TV:5555 shell dumpsys accessibility | grep "Bound services"
   # Bound services:{Service[label=Ana Ekran, ...]}
   ```

4. **Gerçek kumandayla dene.** ADB ile gönderilen tuşlar (`input keyevent`) erişilebilirlik
   servisine uğramıyor; test için işe yaramaz.

> Ana ekranı her yeniden kurduğunda (`adb install -r`) Android bu servisi kapatır. 2. adımdaki
> komutu tekrar çalıştır.

## Tuşlar için öneriler

| Tuş | Öneri |
|---|---|
| YouTube | SmartTube (`org.smarttube.stable`) |
| Google Play | Play Store (`com.android.vending`), GlobalKey'den kurtarmak için |
| TV+ | TV+ kullanmıyorsan: Netflix, YouTube Music (`com.google.android.youtube.tvmusic`) ya da Kodi |

Kutuyu uyutmak ya da son uygulamaya dönmek gibi sistem işlevleri `app_keys` ile atanamıyor; sadece
uygulama açılabiliyor.

Sonraki adım: [6. SmartTube](06-smarttube.md)
