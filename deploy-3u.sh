#!/bin/bash
# =====================================================================
# MURO LMS — 3U (3U Akademi) Özel Canlıya Alma Betiği
# =====================================================================
# Usage:
#   chmod +x deploy-3u.sh
#   ./deploy-3u.sh
# =====================================================================

set -e

echo ""
echo "╔═══════════════════════════════════════════════════╗"
echo "║      MURO LMS — Sadece 3U Güncelleme 🚀           ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""

# 1. Git Reposunu Güncelle
echo "📥 1. Git reposundan en güncel kodlar çekiliyor..."
git pull
echo "✅ Kodlar güncellendi."
echo ""

# 2. Ortak backend imajlarını oluştur
echo "📦 2. Ortak Backend imajları derleniyor..."
docker build -t muro-api:latest -f Dockerfile.api .
docker build -t muro-worker:latest -f Dockerfile.worker .
echo "✅ Backend imajları hazır."
echo ""

# 3. Ortak frontend imajlarını oluştur
echo "📦 3. Ortak Frontend imajları derleniyor..."
docker build -t muro-admin:latest -f frontend/admin/Dockerfile ./frontend/admin
docker build -t muro-student:latest -f frontend/student/Dockerfile ./frontend/student
echo "✅ Frontend imajları hazır."
echo ""

# 4. Sadece 3u'yu Güncelle
echo "🔄 4. 3U dizinine gidilip konteynerlar yeniden başlatılıyor..."
BUILD_DIR=$(pwd)

if [ -d "/opt/3u" ]; then
    cd "/opt/3u"
    echo "📥 3U dizini Git reposu güncelleniyor..."
    git pull || true
    
    echo "🔄 Konteynerlar yeni imajlarla yeniden başlatılıyor..."
    docker compose -f docker-compose.3u.yml up -d
    echo "✅ 3U Akademi başarıyla güncellendi!"
    cd "$BUILD_DIR"
else
    echo "⚠️  /opt/3u dizini bulunamadı! Atlanıyor."
fi
echo ""

# 5. Eski İmajları Temizle
echo "🧹 5. Disk tasarrufu için eski imajlar temizleniyor..."
docker image prune -f
echo "✅ Temizlik tamamlandı."
echo ""

echo "🎉 [BAŞARILI] Sadece 3U Akademi sorunsuz şekilde güncellendi! 🥂"
echo ""
