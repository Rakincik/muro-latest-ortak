#!/bin/bash
# =====================================================================
# MURO LMS — Migrates existing uploaded materials out of Guid.Empty dir
# =====================================================================
# Runs on: CyberPanel / VPS Server
# Usage:
#   chmod +x fix_existing_materials.sh
#   ./fix_existing_materials.sh
# =====================================================================

set -e

echo "🔍 Scanning running MURO API containers to fix PDF/material directories..."

# Get all running docker container names that match 'muro_*_api'
CONTAINERS=$(docker ps --format "{{.Names}}" | grep -E '^muro_.*_api$' || true)

if [ -z "$CONTAINERS" ]; then
    echo "⚠️  No running 'muro_*_api' containers found!"
    exit 0
fi

for container in $CONTAINERS; do
    echo "--------------------------------------------------"
    echo "📦 Checking container: $container"
    
    # Check if materials/Guid.Empty folder exists inside the container's wwwroot
    if docker exec "$container" [ -d /app/wwwroot/uploads/materials/00000000-0000-0000-0000-000000000000 ]; then
        echo "📂 Found Guid.Empty folder. Moving files to parent directory..."
        
        # Move all files (if any exist) to /app/wwwroot/uploads/materials
        docker exec "$container" sh -c '
            if [ "$(ls -A /app/wwwroot/uploads/materials/00000000-0000-0000-0000-000000000000 2>/dev/null)" ]; then
                mv /app/wwwroot/uploads/materials/00000000-0000-0000-0000-000000000000/* /app/wwwroot/uploads/materials/
                echo "✅ Successfully moved files."
            else
                echo "ℹ️  Guid.Empty directory was empty."
            fi
        '
        
        # Remove the now empty Guid.Empty directory
        docker exec "$container" rm -rf /app/wwwroot/uploads/materials/00000000-0000-0000-0000-000000000000
        echo "🗑️  Removed Guid.Empty directory."
    else
        echo "✨ No Guid.Empty folder folder found for $container (or already migrated)."
    fi
done

echo "--------------------------------------------------"
echo "🎉 Migration check completed!"
