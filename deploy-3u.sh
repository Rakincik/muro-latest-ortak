#!/bin/bash
# =====================================================================
# MURO LMS — Sadece 3U (4T Akademi / 3u.muro.click) Derleme & Dağıtım
# =====================================================================
set -e

echo "🚀 [3U / 4T Akademi] Güncelleme Başlatılıyor..."

echo "📥 1. Git güncelleniyor..."
git pull

echo "📦 2. Ortak Backend API ve Öğrenci Paneli derleniyor..."
docker build -t muro-api:latest -f Dockerfile.api .
docker build -t muro-student:latest -f frontend/student/Dockerfile ./frontend/student

echo "🔄 3. 3U Konteynerları yeniden başlatılıyor..."
docker compose -f docker-compose.3u.yml up -d

echo "🧹 4. Temizlik yapılıyor..."
docker image prune -f

echo "🎉 [BAŞARILI] 3U (uzem.4takademi.com / 3u.muro.click) güncellendi!"
