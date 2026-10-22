# 3. Yeni ana ekran

Kutunun kendi ana ekranı Google'ın standart Android TV ana ekranı (`com.google.android.tvlauncher`):
öneri satırları, sponsorlu içerik. Yerine [cleanyourtv](https://github.com/Gathin23/cleanyourtv)'nin
sade ana ekranı kuruluyor: ~430 KB, düz Java, 1 GB RAM'li cihazlar için yazılmış, ağ izni yok.

![Yeni ana ekran](../images/ana-ekran.jpg)

Bu rehber ana ekranın kodunu kopyalamıyor; doğrudan kendi reposundan derliyorsun.

## Derleme

Gerekenler: JDK 17 ve Android SDK (platform 34, build-tools 34).

```bash
# macOS
brew install openjdk@17 android-commandlinetools
sdkmanager "platforms;android-34" "build-tools;34.0.0"

git clone https://github.com/Gathin23/cleanyourtv
cd cleanyourtv/launcher
```

## Bu kutuya göre ayar

`app/src/main/res/values/config.xml` içinde şunları değiştir:

```xml
<!-- Alt satırdaki 4 uygulama, sırayla. Kurulu olmayan atlanır. -->
<string-array name="dock_apps">
    <item>org.smarttube.stable</item>
    <item>com.netflix.ninja</item>
    <item>com.android.vending</item>
    <item>com.google.android.youtube.tvmusic</item>
</string-array>

<!-- Kutuda HDMI girişi ya da anten yok -->
<string name="live_tv_package" translatable="false"></string>

<!-- Saat altında işlemci, boş RAM ve depolama satırı -->
<bool name="show_stats">true</bool>
```

TV+ kullanıyorsan `com.turkcell.ott`'u ekle; adını kısaltmak için:

```xml
<string-array name="app_labels">
    <item>com.turkcell.ott=TV+</item>
</string-array>
```

Kumanda tuşları için `app_keys` ayarı: [5. Kumanda tuşları](05-kumanda-tuslari.md).

## Kurulum

```bash
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools   # kendi SDK yolun
./gradlew assembleDebug
adb -s $TV:5555 install -r app/build/outputs/apk/debug/app-debug.apk

# Varsayılan ana ekran yap, sonra eskisini kapat
adb -s $TV:5555 shell cmd package set-home-activity com.gathin.tvhome/.MainActivity
adb -s $TV:5555 shell pm disable-user --user 0 com.google.android.tvlauncher
adb -s $TV:5555 shell input keyevent KEYCODE_HOME
```

Eski ana ekranı **yenisi Home olduktan sonra** kapat; aksi halde Home tuşuna basınca açılacak bir şey
kalmaz. Kontrol:

```bash
adb -s $TV:5555 shell dumpsys activity activities | grep mResumedActivity
# ... com.gathin.tvhome/.MainActivity
```

Bu kutuda Home'u isteyen üç uygulama var: eski ana ekran, yenisi ve `com.android.tv.settings`'in yedek
ekranı. Kurulum sihirbazı (setupwraith) burada Home'u istemiyor; dokunmana gerek yok.

## Kullanım

- **Aşağı**: diğer uygulamalar.
- **Bir uygulamada OK'a basılı tut**: taşı, değiştir, kaldır, bilgi.
- **Ayarlar** butonuna basılı tut: ana ekran ayarları (duvar kağıdı, tema, sıralama).

Yeniden başlattıktan sonra ana ekranın yerinde kaldığını kontrol et (`./scripts/status.sh`).

Sonraki adım: [4. Görüntü ayarı](04-goruntu.md)
