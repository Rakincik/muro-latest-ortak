#!/bin/bash
# =====================================================================
# MURO LMS — Sadece TRK (uzem.ataniyorumhocam.com) Derleme & Dağıtım
# =====================================================================
set -e

echo "🚀 [TRK] Komple Derleme Başlatılıyor..."

echo "📥 1. Git güncelleniyor..."
git pull

echo "📦 2. Backend API & Worker derleniyor..."
docker build -t muro-api:latest -f Dockerfile.api .
docker build -t muro-worker:latest -f Dockerfile.worker .

echo "📦 3. TRK Admin Paneli derleniyor..."
docker build -t muro-admin-trk:latest \
  --build-arg NEXT_PUBLIC_API_URL="https://uzem.ataniyorumhocam.com/api/v1" \
  --build-arg NEXT_PUBLIC_BASE_PATH="/admin" \
  -f frontend/admin/Dockerfile ./frontend/admin

echo "📦 4. TRK Öğrenci Paneli derleniyor..."
docker build -t muro-student-trk:latest \
  --build-arg NEXT_PUBLIC_API_URL="https://uzem.ataniyorumhocam.com/api/v1" \
  -f frontend/student/Dockerfile ./frontend/student

echo "🔄 5. TRK Konteynerları yeniden başlatılıyor..."
docker compose -f docker-compose.trk.yml up -d --force-recreate

echo "🧹 6. Temizlik yapılıyor..."
docker image prune -f

echo "🎉 [BAŞARILI] TRK (uzem.ataniyorumhocam.com) komple derlendi ve ayağa kalktı!"
