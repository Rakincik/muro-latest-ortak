#!/bin/bash
# =============================================================
# BBB 2.7 → 3.0 Kayıt Playback Fix
# Sorun: tldraw.json ve external_videos.json 404 veriyor
# Çözüm: Eksik dosyaları oluştur + izinleri düzelt
# =============================================================

PRES_DIR="/var/bigbluebutton/published/presentation"

echo "======================================"
echo "BBB Kayıt Playback Fix Başlıyor..."
echo "======================================"

# Önce kaç kayıtta tldraw.json eksik ona bakalım
TOTAL=$(find "$PRES_DIR" -maxdepth 1 -mindepth 1 -type d | wc -l)
MISSING=$(find "$PRES_DIR" -maxdepth 1 -mindepth 1 -type d -exec sh -c '[ ! -f "$1/tldraw.json" ]' _ {} \; -print | wc -l)
echo "Toplam kayıt: $TOTAL"
echo "tldraw.json eksik olan: $MISSING"
echo ""

# Her published kayıt klasörüne gir
FIXED=0
for dir in "$PRES_DIR"/*/; do
    [ -d "$dir" ] || continue
    
    rec_id=$(basename "$dir")
    
    # 1) tldraw.json yoksa oluştur (boş ama geçerli JSON)
    if [ ! -f "$dir/tldraw.json" ]; then
        echo '[]' > "$dir/tldraw.json"
        chown bigbluebutton:bigbluebutton "$dir/tldraw.json"
        FIXED=$((FIXED + 1))
    fi
    
    # 2) external_videos.json yoksa oluştur
    if [ ! -f "$dir/external_videos.json" ]; then
        echo '[]' > "$dir/external_videos.json"
        chown bigbluebutton:bigbluebutton "$dir/external_videos.json"
    fi
    
    # Her 500 kayıtta ilerleme göster
    if [ $((FIXED % 500)) -eq 0 ] && [ $FIXED -gt 0 ]; then
        echo "  İlerleme: $FIXED / $MISSING düzeltildi..."
    fi
done

echo ""
echo "======================================"
echo "TAMAMLANDI! $FIXED kayıtta tldraw.json oluşturuldu."
echo "======================================"
echo ""
echo "Şimdi tüm klasörlerin izinlerini düzeltelim..."
chown -R bigbluebutton:bigbluebutton "$PRES_DIR"
echo "İzinler düzeltildi!"
echo ""
echo ">>> Şimdi tarayıcıdan bir kaydı aç ve presentation'ın gelip gelmediğini kontrol et."
