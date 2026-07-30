#!/bin/bash
# ==============================================================================
# MURO LMS — Çoklu Kurum Otomatik Veritabanı Yedekleme Scripti
# ==============================================================================
# Bu script her gece 00.00'da çalıştırılmak üzere tasarlanmıştır.
# Her kurum için son 2 günün yedeğini (Bugün ve Dün) saklar, eski yedekleri siler.
# ==============================================================================

# Yedeklerin saklanacağı ana dizin
BACKUP_DIR="/var/backups/muro"
mkdir -p "$BACKUP_DIR"

# 8 Kurumun PostgreSQL Konteyner İsimleri
CONTAINERS=(
    "muro_akm_postgres"
    "muro_mng_postgres"
    "muro_ens_postgres"
    "muro_hll_postgres"
    "muro_mvz_postgres"
    "muro_omr_postgres"
    "muro_trk_postgres"
    "muro_3u_postgres"
)

echo "📆 Yedekleme İşlemi Başladı: $(date)"
echo "--------------------------------------------------"

for container in "${CONTAINERS[@]}"; do
    # Kurum adını konteyner isminden çıkar (Örn: muro_akm_postgres -> akm)
    tenant=$(echo "$container" | cut -d'_' -f2)

    echo "🔹 Kurum yedekleniyor: $tenant ($container)"

    # Konteynerın çalışıp çalışmadığını kontrol et
    if [ "$(docker ps -q -f name=^/${container}$)" ]; then
        # 1. Konteyner içindeki çevre değişkenlerinden DB bilgilerini oku
        DB_USER=$(docker exec "$container" printenv POSTGRES_USER)
        DB_PASS=$(docker exec "$container" printenv POSTGRES_PASSWORD)
        DB_NAME=$(docker exec "$container" printenv POSTGRES_DB)

        # Bilgiler okunamadıysa varsayılan değerleri kullan
        DB_USER=${DB_USER:-muro_user}
        DB_PASS=${DB_PASS:-muro_redis_2024}
        DB_NAME=${DB_NAME:-muro_prod}

        # Dosya yolları
        YESTERDAY_FILE="${BACKUP_DIR}/${tenant}_backup_dun.sql"
        TODAY_FILE="${BACKUP_DIR}/${tenant}_backup_bugun.sql"

        # 2. Döngüsel Silme/Kaydırma: Dünün yedeğini sil, bugünün yedeğini düne aktar
        if [ -f "$TODAY_FILE" ]; then
            mv -f "$TODAY_FILE" "$YESTERDAY_FILE"
            echo "   ↳ Eski yedek düne aktarıldı: ${tenant}_backup_dun.sql"
        fi

        # 3. Yeni yedek al (Konteyner içinde pg_dump çalıştırıp hosta yazar)
        if docker exec -e PGPASSWORD="$DB_PASS" "$container" pg_dump -U "$DB_USER" -d "$DB_NAME" > "$TODAY_FILE"; then
            echo "   ✅ Yedekleme başarılı: ${tenant}_backup_bugun.sql"
            chmod 600 "$TODAY_FILE" # Güvenlik için sadece root okuyabilsin
        else
            echo "   ❌ HATA: pg_dump başarısız oldu!"
        fi
    else
        echo "   ⚠️  UYARI: $container konteyneri aktif değil! Yedek alınamadı."
    fi
    echo "--------------------------------------------------"
done

# Eski yedeklerin temizlenmesi (Güvence olarak 3 günden eski kalan herhangi bir sql dosyası varsa siler)
find "$BACKUP_DIR" -name "*.sql" -mtime +2 -delete 2>/dev/null || true

echo "🎉 Bütün yedekleme ve döngüsel temizlik tamamlandı! $(date)"
echo ""
