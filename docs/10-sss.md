# 10. Sık sorulanlar

**TV+ kutusuna dışarıdan APK kurulur mu?**
Evet, ADB ile (`adb install`); test kutusunda sorunsuz çalıştı. Bu kutu Google lisanslı bir Android
TV; kullanıcı kısıtlaması ve cihaz yöneticisi yok. Forumlarda kutunun içinden kurulumda engel
çıktığı yazıyor, bu rehber o yolu denemedi. 64-bit'e özel uygulamalar kurulmaz (kutu 32-bit).

**TV+ uygulaması silinir mi?**
Kullanıcı için kaldırılabilir (`pm uninstall --user 0 com.turkcell.ott`) ya da kapatılabilir.
Fabrika kopyası sistemde kalır, sıfırlamada geri gelir. Geri getirmek için:
`cmd package install-existing com.turkcell.ott`.

**Netflix HD kalır mı?**
Evet. Bu rehberdeki hiçbir şey DRM'e dokunmuyor. Bootloader açılsaydı düşerdi.

**Kutu bozulur mu?**
Hiçbir şey silinmiyor, sistem bölümüne yazılmıyor. "Dokunma" listesindeki paketler korunuyor.
En kötü durumda `restore.sh` ya da fabrika ayarlarına sıfırlama.

**Kumandanın Google Play tuşu çalışmıyor.**
Büyük ihtimalle resmi YouTube kapalı ve YouTube tuşuna basıldı:
[5. Kumanda tuşları](05-kumanda-tuslari.md).

**Monitörde yazılar bulanık.**
Kutu 4K 4:2:0 gönderiyor olabilir: [4. Görüntü](04-goruntu.md).

**Ses gelmiyor.**
HDMI medya sesi 0 olabilir; kumandayla aç. Monitörde hoparlör yoksa ses gelmez.

**Telefondan kumanda servisini kapatamıyorum.**
Firmware her açılışta geri getiriyor. ~14 MB, zararsız.

**Root yapılır mı?**
Hayır: [8. Root ve bootloader](08-root-ve-bootloader.md).

**Güncelleme gelince ne olur?**
Bazı paketler geri açılabilir: `./scripts/status.sh`, sonra `./scripts/debloat.sh`.

**Başka bir operatör kutusunda çalışır mı?**
Betikler model kontrolü yapıyor. Benzer Amlogic kutularda yaklaşım aynı ama paket listesi farklı;
[cleanyourtv/examples](https://github.com/Gathin23/cleanyourtv/tree/main/examples)'da 190'dan fazla
model var.
