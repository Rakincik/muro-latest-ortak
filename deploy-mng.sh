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

# =====================================================================
# Configuration (Adjust domains/paths here if needed)
# =====================================================================
NEXT_PUBLIC_API_URL="https://online-api.dereceuzem.com/api/v1"
NEXT_PUBLIC_BASE_PATH="/admin"

# 2. Build tenant-specific admin frontend with correct build args
# This prevents the 404 / basePath error and login loop issue!
echo "📦 Building Admin Frontend (muro-admin-mng)..."
docker build --no-cache -t muro-admin-mng:latest \
  --build-arg NEXT_PUBLIC_API_URL="$NEXT_PUBLIC_API_URL" \
  --build-arg NEXT_PUBLIC_BASE_PATH="$NEXT_PUBLIC_BASE_PATH" \
  -f frontend/admin/Dockerfile ./frontend/admin

# 3. Build tenant-specific student frontend
echo "📦 Building Student Frontend (muro-student-mng)..."
docker build --no-cache -t muro-student-mng:latest \
  --build-arg NEXT_PUBLIC_API_URL="$NEXT_PUBLIC_API_URL" \
  -f frontend/student/Dockerfile ./frontend/student

# 4. Rebuild the shared API and Worker images
echo "📦 Building API and Worker..."
docker build -t muro-api:latest -f Dockerfile.api .
docker build -t muro-worker:latest -f Dockerfile.worker .

# 5. Start all services under the MNG tenant compose file
echo "🌐 Starting all services..."
docker compose -f docker-compose.mng.yml up -d

echo "🧹 Cleaning up unused Docker resources..."
docker image prune -f

echo "🎉 MNG Tenant deployment completed successfully!"
