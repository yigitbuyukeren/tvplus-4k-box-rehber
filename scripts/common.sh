# Ortak yardımcılar. Diğer betikler bunu `source` ile yükler, tek başına çalıştırılmaz.
#
# Kutunun adresi TV ortam değişkeninden okunur:  TV=192.168.1.50 ./scripts/status.sh
# Port yazılmazsa 5555 eklenir. DRY_RUN=1 ile kutuya hiçbir şey yazılmaz, sadece komutlar yazdırılır.

set -euo pipefail

if [ -z "${TV:-}" ]; then
  echo "TV değişkeni boş. Örnek: TV=192.168.1.50 $0" >&2
  exit 1
fi
case "$TV" in *:*) ;; *) TV="$TV:5555" ;; esac

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPTS_DIR")"

command -v adb >/dev/null || { echo "adb bulunamadı. macOS: brew install android-platform-tools" >&2; exit 1; }

# Kutudan okur (her zaman çalışır, DRY_RUN'da da).
sh_read() { adb -s "$TV" shell "$@" </dev/null | tr -d '\r'; }

# Kutuya yazar (DRY_RUN=1 iken sadece yazdırır).
sh_write() {
  if [ "${DRY_RUN:-0}" = 1 ]; then
    echo "[dry-run] adb shell $*"
  else
    adb -s "$TV" shell "$@" </dev/null | tr -d '\r'
  fi
}

connect() {
  adb connect "$TV" >/dev/null 2>&1 || true
  local state
  state="$(adb -s "$TV" get-state 2>/dev/null || true)"
  if [ "$state" != device ]; then
    echo "Kutuya bağlanılamadı ($TV, durum: ${state:-yok})." >&2
    echo "Geliştirici seçeneklerinde USB/ağ hata ayıklamasının açık olduğundan ve TV'deki" >&2
    echo "\"USB hata ayıklamaya izin verilsin mi?\" sorusunu onayladığından emin ol." >&2
    exit 1
  fi
  local model
  model="$(sh_read getprop ro.product.device)"
  if [ "$model" != DV6069Y_TVPLUS ] && [ -z "${FORCE:-}" ]; then
    echo "Bu kutu DV6069Y_TVPLUS değil ($model). Liste bu modele göre hazırlandı." >&2
    echo "Yine de devam etmek için FORCE=1 ekle." >&2
    exit 1
  fi
}

# debloat.txt'deki paket adları (yorumlar ve boş satırlar atlanır).
packages() {
  grep -vE '^\s*(#|$)' "$SCRIPTS_DIR/debloat.txt" | awk '{print $1}'
}
