#!/bin/bash
# =====================================================================
# MURO LMS — Sadece 3U (4T Akademi / 3u.muro.click) Derleme & Dağıtım
# =====================================================================
set -e

echo "🚀 [3U / 4T Akademi] Komple Derleme Başlatılıyor..."

echo "📥 1. Git güncelleniyor..."
git pull

echo "📦 2. Backend API & Worker derleniyor..."
docker build -t muro-api:latest -f Dockerfile.api .
docker build -t muro-worker:latest -f Dockerfile.worker .

echo "📦 3. Admin ve Öğrenci Panelleri derleniyor..."
docker build -t muro-admin:latest -f frontend/admin/Dockerfile ./frontend/admin
docker build -t muro-student:latest -f frontend/student/Dockerfile ./frontend/student

echo "🔄 4. 3U Konteynerları yeniden başlatılıyor..."
docker compose -f docker-compose.3u.yml up -d --force-recreate

echo "🧹 5. Temizlik yapılıyor..."
docker image prune -f

echo "🎉 [BAŞARILI] 3U (uzem.4takademi.com / 3u-ad.muro.click) komple derlendi ve ayağa kalktı!"
