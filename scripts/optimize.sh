#!/usr/bin/env bash
# Hız ve gizlilik ayarları. Her ayarın eski değeri restore.sh içinde.
#
# Kullanım: TV=192.168.1.50 ./scripts/optimize.sh
#           ADBLOCK_DNS=0 ...  reklam engelleyen DNS'i atlar
#           SLEEP_MIN=60  ...  uyku süresi, dakika (varsayılan 60; fabrika değeri 180)
source "$(dirname "$0")/common.sh"
connect

# Animasyonlar yarı sürede (0 yapılırsa geçişler sertleşir).
for k in window_animation_scale transition_animation_scale animator_duration_scale; do
  sh_write settings put global "$k" 0.5
done

# Arka planda tutulan uygulama sayısı (2 GB RAM için 8 yeterli).
sh_write device_config put activity_manager max_cached_processes 8

# Not: send_action_app_error ayarını 0 yapmak kalıcı olmuyor, Play Hizmetleri birkaç saat içinde 1'e
# döndürüyor. Google'a teşhis verisi gönderimini kapatmanın kalıcı yolu menüden:
# Ayarlar > Cihaz Tercihleri > Kullanım ve Teşhis > Kapalı.

# Uyku süresi.
sh_write settings put secure sleep_timeout $(( ${SLEEP_MIN:-60} * 60000 ))

# Reklam ve izleyici engelleyen DNS (YouTube reklamlarını engellemez).
if [ "${ADBLOCK_DNS:-1}" = 1 ]; then
  sh_write settings put global private_dns_specifier dns.adguard-dns.com
  sh_write settings put global private_dns_mode hostname
fi

echo "Tamam. Durum: TV=$TV ./scripts/status.sh"
