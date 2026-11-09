# TV+ 4K Box Rehberi
- Root'suz, geri alınabilir ADB rehberi; her betik önce deneme modunda çalışmalı, silme veya root gerektirmemeli.
- Kullanıcı/cihaz verisi, seri numarası, IP veya kimlik bilgisi ekleme; ekran görüntülerini sentetik tut.
- Kontrol: `for s in scripts/*.sh; do bash -n "$s" || exit 1; done && bash scripts/test-safety.sh`; gerçek cihazda denenmeyen adımı doğrulanmış gösterme.
- Canlı site yok; `main` push'u yalnız GitHub deposunu günceller.
