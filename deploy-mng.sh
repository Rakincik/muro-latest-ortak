#!/bin/bash
# =====================================================================
# MURO LMS — MNG Tenant Deployment and Monorepo Sync Script
# =====================================================================
# Runs on: Panel Server
# Directory: /opt/mng
# Usage:
#   chmod +x deploy-mng.sh
#   ./deploy-mng.sh
# =====================================================================

set -e

echo "🚀 Starting MNG Tenant sync and build..."

# 1. Pull latest monorepo code
echo "📥 Pulling latest codebase from git..."
git pull || true

# 2. Build tenant-specific admin frontend with correct build args
# This prevents the 404 / basePath error and login loop issue!
echo "📦 Building Admin Frontend (muro-admin-mng)..."
docker build --no-cache -t muro-admin-mng:latest \
  --build-arg NEXT_PUBLIC_API_URL="https://mng-api.muro.click/api/v1" \
  --build-arg NEXT_PUBLIC_BASE_PATH="" \
  -f frontend/admin/Dockerfile ./frontend/admin

# 3. Build tenant-specific student frontend
echo "📦 Building Student Frontend (muro-student-mng)..."
docker build --no-cache -t muro-student-mng:latest \
  -f frontend/student/Dockerfile ./frontend/student

# 4. Rebuild the shared API and Worker images
echo "📦 Building API and Worker..."
docker compose -f docker-compose.mng.yml build api worker

# 5. Start all services under the MNG tenant compose file
echo "🌐 Starting all services..."
docker compose -f docker-compose.mng.yml up -d

echo "🧹 Cleaning up unused Docker resources..."
docker image prune -f

echo "🎉 MNG Tenant deployment completed successfully!"
