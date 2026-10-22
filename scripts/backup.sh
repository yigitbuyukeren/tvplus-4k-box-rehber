#!/usr/bin/env bash
# Değişiklik yapmadan önce kutunun durumunu kaydeder: paket listeleri, tüm ayarlar, sistem özellikleri,
# varsayılan ana ekran. Hiçbir şeyi değiştirmez.
#
# Kullanım: TV=192.168.1.50 ./scripts/backup.sh
# Çıktı:    backup/<tarih-saat>/  (bu klasörü GitHub'a yükleme, cihazına özel bilgiler içerir)
source "$(dirname "$0")/common.sh"
connect

OUT="$REPO_DIR/backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUT"

sh_read pm list packages -f   > "$OUT/packages-all.txt"
sh_read pm list packages -d   > "$OUT/packages-disabled.txt"
sh_read pm list packages -u   > "$OUT/packages-with-uninstalled.txt"
for ns in global secure system; do
  sh_read settings list "$ns" > "$OUT/settings-$ns.txt"
done
sh_read getprop               > "$OUT/getprop.txt"
sh_read cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME > "$OUT/home.txt"

echo "Yedek: $OUT"
wc -l "$OUT"/* | tail -1
