#!/usr/bin/env bash
# ADB'yi taklit ederek cihaz bağlantısı kurmadan güvenlik kapılarını sınar.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cat > "$tmp/adb" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$ADB_TEST_LOG"
case "$*" in
  *get-state) echo device ;;
  *getprop\ ro.product.device) echo "${ADB_TEST_MODEL:-DV6069Y_TVPLUS}" ;;
  *settings\ get\ secure\ enabled_accessibility_services) echo InputKeyService ;;
  *pm\ list\ packages*) echo package:com.google.android.youtube.tv ;;
esac
EOF
chmod +x "$tmp/adb"
export PATH="$tmp:$PATH" ADB_TEST_LOG="$tmp/adb.log" TV=192.0.2.1

# Model yanlışsa ayar veya paket işlemi başlamamalı.
if ADB_TEST_MODEL=unexpected DRY_RUN=1 bash "$root/scripts/optimize.sh" >"$tmp/out" 2>&1; then
  echo 'Yanlış model reddedilmedi.' >&2; exit 1
fi
grep -q 'DV6069Y_TVPLUS değil' "$tmp/out"
! grep -Eq 'shell (settings put|device_config|pm disable-user)' "$ADB_TEST_LOG"

# Kuru çalıştırmada yazma komutları gösterilir ama adb'ye gönderilmez.
: > "$ADB_TEST_LOG"
DRY_RUN=1 bash "$root/scripts/optimize.sh" > "$tmp/out"
grep -q '\[dry-run\] adb shell settings put' "$tmp/out"
! grep -Eq 'shell (settings put|device_config)' "$ADB_TEST_LOG"

echo 'Model ve kuru çalıştırma güvenlik kontrolleri geçti.'
