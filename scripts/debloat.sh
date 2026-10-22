#!/usr/bin/env bash
# scripts/debloat.txt içindeki paketleri devre dışı bırakır. Silmez; restore.sh hepsini geri açar.
#
# Kullanım: TV=192.168.1.50 ./scripts/debloat.sh
#           DRY_RUN=1 TV=192.168.1.50 ./scripts/debloat.sh   (sadece ne yapacağını gösterir)
source "$(dirname "$0")/common.sh"
connect

if [ "${DRY_RUN:-0}" != 1 ] && [ ! -d "$REPO_DIR/backup" ]; then
  echo "Önce yedek al: TV=$TV ./scripts/backup.sh" >&2
  exit 1
fi

# Resmi YouTube listede açıksa ve tuşlar yeniden atanmamışsa uyar (docs/05-kumanda-tuslari.md).
if grep -qx com.google.android.youtube.tv <<<"$(packages)"; then
  case "$(sh_read settings get secure enabled_accessibility_services)" in
    *InputKeyService*) ;;
    *)
    echo "UYARI: YouTube kapatılıyor ama kumanda tuşları yeniden atanmamış." >&2
    echo "YouTube tuşu com.sdmc.GlobalKey'i çökertir, Play tuşu da çalışmaz olur." >&2
    echo "Önce docs/05-kumanda-tuslari.md'yi uygula ya da debloat.txt'de YouTube satırını kapat." >&2
    [ -n "${FORCE:-}" ] || exit 1 ;;
  esac
fi

# Paketleri tek tek kapat: zincirlenmiş pm komutları bazı yazılımlarda ilk hatada sessizce durur.
installed="$(sh_read pm list packages)"
for p in $(packages); do
  if ! grep -qx "package:$p" <<<"$installed"; then
    printf '%-42s %s\n' "$p" "kutuda yok, atlandı"
    continue
  fi
  printf '%-42s ' "$p"
  sh_write pm disable-user --user 0 "$p"
done

echo
echo "Devre dışı paket sayısı: $(sh_read pm list packages -d | grep -c .)"
echo "Sorun çıkarsa: TV=$TV ./scripts/restore.sh"
