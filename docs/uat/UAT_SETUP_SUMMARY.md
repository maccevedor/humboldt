# UAT Setup Summary - Fixing npm Permission Errors

## Problem Identified

The error you encountered:
```
npm ERR! Error: EACCES: permission denied, mkdir '/home/node/app/node_modules'
```

This occurs because:
1. The `DockerfileDev` switches to the `node` user before copying files
2. The volume mount `./visor-geografico-I2D:/home/node/app` creates permission conflicts
3. The `node` user doesn't have write permissions to create `node_modules`

## Solution Implemented

### 1. Created UAT-Specific Docker Compose
**File**: `docker-compose.uat.yml`

Key improvements:
- Uses production-ready Dockerfile (`Dockerfile.uat`)
- Removes development volume mounts that cause permission issues
- Optimized for UAT environment with proper resource limits
- All services have `restart: unless-stopped` for reliability

### 2. Created Production Frontend Dockerfile
**File**: `visor-geografico-I2D/Dockerfile.uat`

This uses a **multi-stage build**:
- **Stage 1 (Builder)**: Runs as root, installs dependencies, builds the app
- **Stage 2 (Production)**: Uses Nginx to serve static files
- No permission issues because npm runs as root during build
- Final image is lightweight (Nginx Alpine)

### 3. Environment Configuration
**File**: `.env.uat`

Template for UAT environment variables:
- Database passwords
- GeoServer credentials
- Django secret key
- Email configuration

### 4. Automated Deployment Script
**File**: `deploy-uat.sh`

One-command deployment:
```bash
./deploy-uat.sh
```

Handles:
- Service shutdown
- Image building
- Service startup
- Health checks
- Database migrations
- Static file collection

## Quick Start for UAT Server

### Step 1: Configure Environment
```bash
cd /opt/humboldt

# Copy and edit environment file
cp .env.uat .env
nano .env

# Update these values:
# - DB_PASSWORD
# - GEOSERVER_PASSWORD
# - DJANGO_SECRET_KEY
# - DJANGO_ALLOWED_HOSTS
```

### Step 2: Configure Backend
```bash
cd visor-geografico-I2D-backend
cp .env.example .env
nano .env

# Update with your UAT settings
```

### Step 3: Configure Frontend
```bash
cd ../visor-geografico-I2D
cp .env.example .env
nano .env

# Set NODE_ENV=production
# Set PYTHONSERVER=http://backend:8001/api/
```

### Step 4: Deploy
```bash
cd /opt/humboldt
./deploy-uat.sh
```

## Differences Between Development and UAT

| Aspect | Development (docker-compose.yml) | UAT (docker-compose.uat.yml) |
|--------|----------------------------------|------------------------------|
| Frontend Build | Hot reload with volume mounts | Multi-stage build, static files |
| User Permissions | node user (causes issues) | Root during build, nginx for serving |
| node_modules | Created in mounted volume | Built inside container |
| Restart Policy | None | unless-stopped |
| Resource Limits | None | Optimized for production |
| Environment | NODE_ENV=development | NODE_ENV=production |
| Nginx | Separate service | Built into frontend container |

## Why This Fixes Your Error

### Old Approach (Development)
```dockerfile
FROM node:18.3.0 AS dev
USER node                          # ❌ Switch to node user
WORKDIR /home/node/app
COPY package.json /home/node/app   # ❌ Copy as node user
RUN npm install                    # ❌ Install as node user
```

With volume mount: `./visor-geografico-I2D:/home/node/app`
- Host files owned by your user (UID 1000)
- Container tries to create node_modules as node user (UID 1000)
- Permission conflict = EACCES error

### New Approach (UAT)
```dockerfile
FROM node:18.3.0 AS builder
WORKDIR /app                       # ✅ No user switch (runs as root)
COPY package*.json ./              # ✅ Copy as root
RUN npm ci --only=production       # ✅ Install as root
COPY . .                           # ✅ Copy all files
RUN npm run build                  # ✅ Build as root

FROM nginx:alpine AS production
COPY --from=builder /app/dist /usr/share/nginx/html  # ✅ Copy built files
```

No volume mounts = No permission conflicts!

## Verification Steps

After deployment, verify:

### 1. Check All Services Running
```bash
docker-compose -f docker-compose.uat.yml ps
```

Expected output: All services "Up" and "healthy"

### 2. Check Frontend
```bash
curl http://localhost:8080
```

Should return HTML content

### 3. Check Backend API
```bash
curl http://localhost:8001/admin/
```

Should return Django admin login page

### 4. Check GeoServer
```bash
curl http://localhost:8081/geoserver/web/
```

Should return GeoServer web interface

### 5. View Logs
```bash
# All services
docker-compose -f docker-compose.uat.yml logs -f

# Specific service
docker-compose -f docker-compose.uat.yml logs -f frontend
```

## Troubleshooting

### If Frontend Still Fails to Build

1. **Clear Docker cache**:
```bash
docker-compose -f docker-compose.uat.yml down
docker system prune -a
docker-compose -f docker-compose.uat.yml build --no-cache
```

2. **Check build logs**:
```bash
docker-compose -f docker-compose.uat.yml build --progress=plain frontend
```

3. **Verify package.json exists**:
```bash
ls -la visor-geografico-I2D/package.json
```

### If Database Connection Fails

1. **Check database is running**:
```bash
docker-compose -f docker-compose.uat.yml ps db
```

2. **Test connection**:
```bash
docker-compose -f docker-compose.uat.yml exec db psql -U i2d_user -d i2d_db -c "SELECT 1;"
```

3. **Check backend can connect**:
```bash
docker-compose -f docker-compose.uat.yml logs backend | grep -i database
```

## Next Steps

1. ✅ Configure `.env` file with your UAT credentials
2. ✅ Run `./deploy-uat.sh`
3. ✅ Verify all services are running
4. ✅ Access frontend at http://your-server:8080
5. ✅ Create Django superuser if needed
6. ✅ Configure GeoServer layers
7. ✅ Run tests to verify functionality

## Additional Resources

- **Full Deployment Guide**: See `UAT_DEPLOYMENT_GUIDE.md`
- **Docker Compose Reference**: `docker-compose.uat.yml`
- **Frontend Dockerfile**: `visor-geografico-I2D/Dockerfile.uat`
- **Backend Dockerfile**: `visor-geografico-I2D-backend/Dockerfile.prod`

## Support

If you encounter any issues:
1. Check the logs: `docker-compose -f docker-compose.uat.yml logs -f`
2. Review the troubleshooting section in `UAT_DEPLOYMENT_GUIDE.md`
3. Verify all environment variables are correctly set
4. Ensure Docker has sufficient resources (RAM, disk space)
