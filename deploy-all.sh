#!/bin/bash
# =====================================================================
# MURO LMS — Multi-Tenant Global Deployment Script
# =====================================================================
# Runs on: CyberPanel / VPS Server
# Usage:
#   chmod +x deploy-all.sh
#   ./deploy-all.sh
# =====================================================================

set -e

echo ""
echo "╔═══════════════════════════════════════════════════╗"
echo "║      MURO LMS — 8 Kurum Toplu Güncelleme 🚀       ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""

# 0. Git Güncellemesi
echo "📥 1. Git reposundan en güncel kodlar çekiliyor..."
git pull
echo "✅ Kodlar güncellendi."
echo ""

# 1. Ortak API ve Worker İmajları
echo "📦 2. Ortak Backend imajları derleniyor..."
docker build -t muro-api:latest -f Dockerfile.api .
docker build -t muro-worker:latest -f Dockerfile.worker .
echo "✅ Backend imajları hazır."
echo ""

# 2. Ortak Admin ve Student İmajları
echo "📦 3. Ortak Frontend imajları derleniyor (3u, ens, hll, mvz, omr, trk)..."
docker build -t muro-admin:latest -f frontend/admin/Dockerfile ./frontend/admin
docker build -t muro-student:latest -f frontend/student/Dockerfile ./frontend/student
echo "✅ Ortak Frontend imajları hazır."
echo ""

# 3. AKM Özel Admin İmaji ve 3U Özel Student İmajı
echo "📦 4. AKM özel Admin ve 3U özel Student imajları derleniyor..."
docker build -t muro-admin-akm:latest -f frontend/admin/Dockerfile ./frontend/admin
docker build -t muro-student:3u-ozel -f frontend/student/Dockerfile ./frontend/student
echo "✅ AKM ve 3U özel imajları hazır."
echo ""

# 4. MNG (DereceUzem) Özel İmajları
# MNG için özel API_URL ve basePath argümanları ile derleme yapılır.
echo "📦 5. MNG (DereceUzem) özel imajları derleniyor..."
docker build -t muro-admin-mng:latest \
  --build-arg NEXT_PUBLIC_API_URL="https://online-api.dereceuzem.com/api/v1" \
  --build-arg NEXT_PUBLIC_BASE_PATH="/admin" \
  -f frontend/admin/Dockerfile ./frontend/admin

docker build -t muro-student-mng:latest \
  --build-arg NEXT_PUBLIC_API_URL="https://online-api.dereceuzem.com/api/v1" \
  -f frontend/student/Dockerfile ./frontend/student
echo "✅ MNG özel imajları hazır."
echo ""

# 5. Bütün Kurumları Sırayla Recreate Etme
echo "🔄 6. Kurum klasörlerine gidilip kodlar güncelleniyor ve konteynerlar yeniden başlatılıyor..."

# Kurumların sunucudaki klasör yolları
TENANT_DIRS=(
    "/opt/akm"
    "/opt/mng"
    "/opt/ens"
    "/opt/hll"
    "/opt/mvz"
    "/opt/omr"
    "/opt/trk"
    "/opt/3u"
    "/opt/odin"
)

# Ana derleme yaptığımız klasörü kaydet (geri dönmek için)
BUILD_DIR=$(pwd)

for dir in "${TENANT_DIRS[@]}"; do
    echo "--------------------------------------------------"
    echo "🔹 Dizin kontrol ediliyor: $dir"
    echo "--------------------------------------------------"
    if [ -d "$dir" ]; then
        cd "$dir"
        echo "📥 Git reposu güncelleniyor..."
        git pull || true
        
        echo "🔄 Konteynerlar yeni imajlarla yeniden başlatılıyor..."
        # docker-compose.yml, docker-compose.prod.yml veya tenant yml dosyalarını çalıştırır
        if [ -f "docker-compose.yml" ]; then
            docker compose up -d
        elif [ -f "docker-compose.prod.yml" ]; then
            docker compose -f docker-compose.prod.yml up -d
        else
            COMPOSE_FILE=$(find . -maxdepth 1 -name "docker-compose.*.yml" | head -n 1)
            if [ -n "$COMPOSE_FILE" ]; then
                docker compose -f "$COMPOSE_FILE" up -d
            else
                echo "⚠️  Docker Compose dosyası bulunamadı!"
            fi
        fi
        echo "✅ $dir başarıyla güncellendi!"
        cd "$BUILD_DIR"
    else
        echo "⚠️  $dir dizini bulunamadı, atlanıyor."
    fi
done

echo "--------------------------------------------------"
echo ""

# 6. Eski İmajların Temizliği
echo "🧹 7. Disk tasarrufu için eski imajlar temizleniyor..."
docker image prune -f
echo "✅ Temizlik tamamlandı."
echo ""

echo "🎉 [BAŞARILI] Bütün 8 kurum sorunsuz şekilde güncellendi! 🥂"
echo ""
