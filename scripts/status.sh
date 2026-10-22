#!/usr/bin/env bash
# Kutunun şu anki durumunu özetler. Hiçbir şeyi değiştirmez.
# Güncellemeden sonra çalıştır: firmware kapatılan paketleri geri açabilir.
#
# Kullanım: TV=192.168.1.50 ./scripts/status.sh
source "$(dirname "$0")/common.sh"
connect

echo "== Kutu"
echo "Model:      $(sh_read getprop ro.product.model) ($(sh_read getprop ro.product.device))"
echo "Android:    $(sh_read getprop ro.build.version.release), yazılım $(sh_read getprop ro.build.display.id)"
echo "Açık kalma: $(sh_read cat /proc/uptime | awk '{printf "%d dk", $1/60}')"

echo
echo "== Liste"
disabled="$(sh_read pm list packages -d)"
enabled="$(sh_read pm list packages -e)"
for p in $(packages); do
  if   grep -qx "package:$p" <<<"$disabled"; then s="kapalı"
  elif grep -qx "package:$p" <<<"$enabled";  then s="AÇIK (yeniden kapatmak için debloat.sh)"
  else s="kutuda yok"; fi
  printf '  %-42s %s\n' "$p" "$s"
done

echo
echo "== Ana ekran ve tuşlar"
echo "Ana ekran:   $(sh_read cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME | tail -1)"
svc="$(sh_read settings get secure enabled_accessibility_services)"
echo "Tuş servisi: $([ "${svc}" != null ] && echo "$svc" || echo "kapalı")"

echo
echo "== Görüntü"
sh_read cat /sys/class/amhdmitx/amhdmitx0/config 2>/dev/null | grep -E "^(cur_VIC|colordepth|colorspace)" | sed 's/^/  /'
echo "  (cur_VIC 16 = 1080p60, 353 = 2160p60 YCbCr 4:2:0)"

echo
echo "== Ayarlar"
echo "  Animasyon:   $(sh_read settings get global window_animation_scale)"
echo "  DNS:         $(sh_read settings get global private_dns_mode) $(sh_read settings get global private_dns_specifier)"
echo "  Uyku:        $(( $(sh_read settings get secure sleep_timeout) / 60000 )) dk"

echo
echo "== Bellek"
sh_read dumpsys meminfo | grep -E "Free RAM|Used RAM" | sed 's/^ */  /'
