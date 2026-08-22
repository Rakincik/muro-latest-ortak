#!/bin/bash
# =====================================================================
# MURO LMS — Sadece MVZ (Mevzuat Adam / uzem.mevzuatadam.com) Derleme
# =====================================================================
set -e

echo "🚀 [MVZ / Mevzuat Adam] Komple Derleme Başlatılıyor..."

echo "📥 1. Git güncelleniyor..."
git pull

echo "📦 2. Backend API & Worker derleniyor..."
docker build -t muro-api:latest -f Dockerfile.api .
docker build -t muro-worker:latest -f Dockerfile.worker .

echo "📦 3. Admin ve Öğrenci Panelleri (Tek Domain /admin) derleniyor..."
docker build -t muro-admin-mvz:latest \
  --build-arg NEXT_PUBLIC_API_URL="https://uzem.mevzuatadam.com/api/v1" \
  --build-arg NEXT_PUBLIC_BASE_PATH="/admin" \
  -f frontend/admin/Dockerfile ./frontend/admin

docker build -t muro-student-mvz:latest \
  --build-arg NEXT_PUBLIC_API_URL="https://uzem.mevzuatadam.com/api/v1" \
  -f frontend/student/Dockerfile ./frontend/student

echo "🔄 4. MVZ Konteynerları yeniden başlatılıyor..."
docker compose -f docker-compose.mvz.yml up -d --force-recreate

echo "🧹 5. Temizlik yapılıyor..."
docker image prune -f

echo "🎉 [BAŞARILI] MVZ (uzem.mevzuatadam.com) komple derlendi ve ayağa kalktı!"
