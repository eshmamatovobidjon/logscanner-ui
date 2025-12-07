# ============================================
# LogScanner Frontend - Multi-stage Dockerfile
# ============================================

# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files first for dependency caching
COPY package.json yarn.lock* ./

# Install dependencies (regenerate lock if needed)
RUN yarn install

# Copy source and build
COPY . .
RUN yarn build

# Stage 2: Runtime with Nginx
FROM nginx:alpine

LABEL maintainer="LogScanner Team"
LABEL description="LogScanner Frontend UI"
LABEL version="1.0.0"

# Copy built assets from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD wget -qO- http://localhost:80/health || exit 1

CMD ["nginx", "-g", "daemon off;"]