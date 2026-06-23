# ============================================
# MURO Admin Frontend — Production Dockerfile
# Two-stage: build → runner
# ============================================

# --- Stage 1: Build ---
FROM node:20-alpine AS builder
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

# === DIAGNOSTIC: Show what npm actually installed ===
RUN echo "=== NEXT VERSION ===" && npx next --version || echo "NEXT NOT FOUND"
RUN echo "=== BIN CONTENTS ===" && ls node_modules/.bin/ | head -30 || echo "NO BIN DIR"
RUN echo "=== NEXT IN NODE_MODULES ===" && ls node_modules/next/package.json || echo "NEXT PACKAGE NOT FOUND"
# === END DIAGNOSTIC ===

COPY . .

# Build-time environment variables
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}

RUN npx next build

# --- Stage 2: Runner ---
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3001

# Create non-root user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

# Copy standalone output
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

USER nextjs

EXPOSE 3001

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD wget -q --spider http://localhost:3001 || exit 1

CMD ["node", "server.js"]
