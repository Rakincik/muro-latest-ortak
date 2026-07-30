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
echo "🔄 6. Kurum konteynerları yeni imajlarla güncelleniyor..."

TENANTS=("akm" "mng" "ens" "hll" "mvz" "omr" "trk" "3u")

for tenant in "${TENANTS[@]}"; do
    echo "--------------------------------------------------"
    echo "🔹 Kurum güncelleniyor: $tenant"
    echo "--------------------------------------------------"
    if [ -f "docker-compose.${tenant}.yml" ]; then
        # docker compose up -d komutu yeni derlenen imajları algılar ve 
        # veritabanına zarar vermeden sadece ilgili konteynerları yeniden oluşturur (recreate).
        docker compose -f docker-compose.${tenant}.yml up -d
        echo "✅ $tenant başarıyla güncellendi ve başlatıldı!"
    else
        echo "⚠️  docker-compose.${tenant}.yml bulunamadı, atlanıyor."
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
