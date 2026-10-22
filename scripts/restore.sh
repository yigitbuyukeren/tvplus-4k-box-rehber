#!/usr/bin/env bash
# Her şeyi geri alır: listedeki paketleri açar, fabrika ana ekranını geri getirir, ayarları fabrika
# değerlerine döndürür, kullanıcı için kaldırılan TV+'ı geri kurar.
#
# Kullanım: TV=192.168.1.50 ./scripts/restore.sh
source "$(dirname "$0")/common.sh"
connect

# Listedeki paketler, "# paket" diye yorum satırına alınmış olanlar da (önceden kapatılmış olabilirler).
known="$(sh_read pm list packages -u)"
for p in $(grep -oE '^(# )?[a-z][a-z0-9_]*(\.[a-zA-Z0-9_]+)+' "$SCRIPTS_DIR/debloat.txt" | sed 's/^# //' | sort -u) \
         com.google.android.tvlauncher; do
  grep -qx "package:$p" <<<"$known" || continue
  printf '%-42s ' "$p"
  sh_write pm enable "$p"
done

# Kullanıcı için kaldırılmış olabilecek fabrika uygulamaları.
installed="$(sh_read pm list packages)"
for p in com.turkcell.ott com.google.android.youtube.tv; do
  if ! grep -qx "package:$p" <<<"$installed"; then
    printf '%-42s ' "$p"
    sh_write cmd package install-existing "$p"
  fi
done

# Fabrika ana ekranı.
sh_write cmd package set-home-activity com.google.android.tvlauncher/.MainActivity

# Fabrika ayarları.
for k in window_animation_scale transition_animation_scale animator_duration_scale; do
  sh_write settings put global "$k" 1.0
done
sh_write device_config delete activity_manager max_cached_processes
sh_write settings put secure sleep_timeout 10800000
sh_write settings put global private_dns_mode opportunistic
sh_write settings delete global private_dns_specifier
sh_write settings delete secure enabled_accessibility_services

echo
echo "Geri alındı. Sonra yeniden başlat: adb -s $TV reboot"
echo "Yeni ana ekranı silmek için: adb -s $TV uninstall com.gathin.tvhome"
echo "Ekran çözünürlüğü ADB ile geri alınamaz: Ayarlar > TV settings > Display > Screen resolution."
