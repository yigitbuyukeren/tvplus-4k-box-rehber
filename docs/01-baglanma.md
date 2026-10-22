# 1. Bağlanma

## Gerekenler

- Kutuyla **aynı ağa** bağlı bir bilgisayar (macOS, Linux ya da Windows).
- `adb` (Android Platform Tools):
  - macOS: `brew install android-platform-tools`
  - Linux: dağıtımının paketi (`android-tools-adb` / `android-tools`)
  - Windows: [Platform Tools](https://developer.android.com/tools/releases/platform-tools) zip'i
- Kumanda.

## Kutuda geliştirici seçeneklerini açma

1. **Ayarlar → Cihaz Tercihleri → Hakkında**
2. **Yapı** satırına 7 kez bas. "Artık bir geliştiricisiniz" mesajı çıkar.
3. Geri dön: **Cihaz Tercihleri → Geliştirici seçenekleri → USB hata ayıklama: Açık**

Bu kutuda USB hata ayıklamayı açmak, ağ üzerinden ADB'yi de (port **5555**) açıyor; ayrıca
"kablosuz hata ayıklama" adımı yok. Bu kutu Android 10, eşleştirme kodu Android 11+ özelliği.

> Amlogic kutularında hata ayıklama açıkken USB portu "cihaz" moduna geçebiliyor ve oraya takılı
> USB bellek ya da hoparlör çalışmayabiliyor. İş bitince kapat.

## Kutunun IP adresini bulma

En kolayı: **Ayarlar → Ağ ve İnternet →** bağlı ağın adı → IP adresi.

Bilgisayardan bulmak istersen kutu kendini ağda Chromecast olarak duyuruyor:

```bash
# macOS
dns-sd -B _googlecast._tcp local.          # "TV-PLUS-4K-BOX-..." görünür, Ctrl+C
dns-sd -L "TV-PLUS-4K-BOX-<id>" _googlecast._tcp local.
dns-sd -G v4 <yukarıda çıkan>.local         # IP adresi
```

Chromecast'i kapattıysan bu yöntem çalışmaz; router'ın bağlı cihazlar listesine bak.

## İlk bağlantı

```bash
adb connect 192.168.1.50:5555
adb devices -l
```

İlk seferde durum `unauthorized` görünür ve TV'de **"USB hata ayıklamaya izin verilsin mi?"**
sorusu çıkar. **"Bu bilgisayardan her zaman izin ver"** kutusunu işaretleyip onayla. Sonra:

```
192.168.1.50:5555   device product:TVPLUS_OTT model:TV_PLUS_4K_BOX device:DV6069Y_TVPLUS
```

Bu kutuda `ro.adb.secure=1`: her yeni bilgisayar TV ekranında ayrıca onaylanmak zorunda. Yani ağdaki
biri sen onaylamadan bağlanamaz; yine de iş bitince hata ayıklamayı kapatmak en temizi.

## Sorun çıkarsa

| Belirti | Sebep / çözüm |
|---|---|
| `failed to connect ... No route to host`, ama port açık | macOS'ta Terminal'in "Yerel Ağ" izni yok: **Sistem Ayarları → Gizlilik ve Güvenlik → Yerel Ağ**. Ya da `adb kill-server` sonra tekrar dene. |
| `Connection refused` | Hata ayıklama kapalı ya da kutu yeniden başlarken. |
| `unauthorized` kalıyor | TV'deki soruyu kaçırdın: `adb disconnect`, tekrar `adb connect`, soru yeniden çıkar. |
| `offline` | Kutu uykuda; kumandayla uyandır. |

Sonraki adım: [2. Yedek ve temizlik](02-temizlik.md)
