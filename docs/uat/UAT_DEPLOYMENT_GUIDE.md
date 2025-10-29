# UAT Deployment Guide - Visor I2D Humboldt

## Overview
This guide provides step-by-step instructions for deploying the Visor I2D application to a UAT (User Acceptance Testing) environment.

## Prerequisites

### System Requirements
- **OS**: Ubuntu 20.04+ or similar Linux distribution
- **RAM**: Minimum 8GB (16GB recommended)
- **Disk**: Minimum 50GB free space
- **Docker**: Version 20.10+
- **Docker Compose**: Version 2.0+

### Required Software
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose (if not included)
sudo apt-get update
sudo apt-get install docker-compose-plugin

# Add your user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

## Quick Start

### 1. Clone the Repository
```bash
cd /opt
git clone <your-repo-url> humboldt
cd humboldt
```

### 2. Configure Environment Variables
```bash
# Copy the UAT environment template
cp .env.uat .env

# Edit the configuration
nano .env
```

**Important**: Update these values in `.env`:
- `DB_PASSWORD`: Strong database password
- `GEOSERVER_PASSWORD`: GeoServer admin password
- `DJANGO_SECRET_KEY`: Generate with: `python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'`
- `DJANGO_ALLOWED_HOSTS`: Your UAT domain/IP

### 3. Configure Backend Environment
```bash
cd visor-geografico-I2D-backend
cp .env.example .env
nano .env
```

Update backend `.env` with:
```env
SECRET_KEY=<same-as-DJANGO_SECRET_KEY>
DEBUG=False
ALLOWED_HOSTS=your-uat-domain.com,your-server-ip
DATABASE_URL=postgis://i2d_user:your_db_password@db:5432/i2d_db
```

### 4. Configure Frontend Environment
```bash
cd ../visor-geografico-I2D
cp .env.example .env
nano .env
```

Update frontend `.env` with:
```env
NODE_ENV=production
PYTHONSERVER=http://backend:8001/api/
GEOSERVER_URL=http://geoserver:8080/geoserver
```

### 5. Deploy the Application
```bash
cd /opt/humboldt
./deploy-uat.sh
```

## Manual Deployment Steps

If you prefer manual deployment:

### 1. Stop Existing Containers
```bash
docker-compose -f docker-compose.uat.yml down
```

### 2. Build and Start Services
```bash
# Build images
docker-compose -f docker-compose.uat.yml build --no-cache

# Start services
docker-compose -f docker-compose.uat.yml up -d
```

### 3. Wait for Database
```bash
# Check database health
docker-compose -f docker-compose.uat.yml exec db pg_isready -U i2d_user -d i2d_db
```

### 4. Run Migrations
```bash
docker-compose -f docker-compose.uat.yml exec backend python manage.py migrate
```

### 5. Collect Static Files
```bash
docker-compose -f docker-compose.uat.yml exec backend python manage.py collectstatic --noinput
```

### 6. Create Superuser (First Time Only)
```bash
docker-compose -f docker-compose.uat.yml exec backend python manage.py createsuperuser
```

## Troubleshooting

### Permission Errors (EACCES)
If you see npm permission errors like in your screenshot:

**Solution 1**: The new `Dockerfile.uat` fixes this by running npm as root during build
```bash
# Rebuild the frontend
docker-compose -f docker-compose.uat.yml build --no-cache frontend
```

**Solution 2**: If still having issues, check volume permissions:
```bash
# Fix ownership of node_modules
sudo chown -R 1000:1000 visor-geografico-I2D/node_modules
```

### Database Connection Issues
```bash
# Check database logs
docker-compose -f docker-compose.uat.yml logs db

# Verify database is running
docker-compose -f docker-compose.uat.yml ps db

# Test connection
docker-compose -f docker-compose.uat.yml exec db psql -U i2d_user -d i2d_db -c "SELECT version();"
```

### Frontend Build Failures
```bash
# Check frontend logs
docker-compose -f docker-compose.uat.yml logs frontend

# Rebuild with verbose output
docker-compose -f docker-compose.uat.yml build --no-cache --progress=plain frontend
```

### GeoServer Not Starting
```bash
# Check GeoServer logs
docker-compose -f docker-compose.uat.yml logs geoserver

# Increase memory if needed (edit docker-compose.uat.yml)
INITIAL_MEMORY=4G
MAXIMUM_MEMORY=8G
```

## Service URLs

After successful deployment:

| Service | URL | Credentials |
|---------|-----|-------------|
| Frontend | http://your-server:8080 | N/A |
| Backend Admin | http://your-server:8001/admin/ | Django superuser |
| GeoServer | http://your-server:8081/geoserver | admin / (from .env) |
| Nginx Proxy | http://your-server | N/A |

## Monitoring

### View All Logs
```bash
docker-compose -f docker-compose.uat.yml logs -f
```

### View Specific Service Logs
```bash
docker-compose -f docker-compose.uat.yml logs -f frontend
docker-compose -f docker-compose.uat.yml logs -f backend
docker-compose -f docker-compose.uat.yml logs -f db
docker-compose -f docker-compose.uat.yml logs -f geoserver
```

### Check Service Status
```bash
docker-compose -f docker-compose.uat.yml ps
```

### Check Resource Usage
```bash
docker stats
```

## Backup and Restore

### Backup Database
```bash
# Create backup directory
mkdir -p backups

# Backup database
docker-compose -f docker-compose.uat.yml exec -T db pg_dump -U i2d_user -d i2d_db > backups/backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore Database
```bash
# Stop backend to prevent connections
docker-compose -f docker-compose.uat.yml stop backend

# Restore database
cat backups/backup_YYYYMMDD_HHMMSS.sql | docker-compose -f docker-compose.uat.yml exec -T db psql -U i2d_user -d i2d_db

# Start backend
docker-compose -f docker-compose.uat.yml start backend
```

## Updating the Application

### Update Code
```bash
cd /opt/humboldt

# Pull latest changes
git pull origin main

# Update submodules
git submodule update --init --recursive

# Redeploy
./deploy-uat.sh
```

### Update Specific Service
```bash
# Rebuild and restart specific service
docker-compose -f docker-compose.uat.yml up -d --build --no-deps frontend
```

## Security Considerations

1. **Change Default Passwords**: Update all passwords in `.env` file
2. **Enable HTTPS**: Configure SSL certificates in nginx configuration
3. **Firewall Rules**: Only expose necessary ports (80, 443)
4. **Regular Updates**: Keep Docker images and dependencies updated
5. **Backup Strategy**: Implement automated daily backups
6. **Access Control**: Restrict SSH and admin panel access

## Performance Tuning

### Database Optimization
Edit `docker-compose.uat.yml` database environment:
```yaml
- POSTGRES_EFFECTIVE_CACHE_SIZE=4GB  # 50% of RAM
- POSTGRES_SHARED_BUFFERS=1GB        # 25% of RAM
- POSTGRES_WORK_MEM=32MB
- POSTGRES_MAX_CONNECTIONS=200
```

### GeoServer Memory
Edit `docker-compose.uat.yml` geoserver environment:
```yaml
- INITIAL_MEMORY=4G
- MAXIMUM_MEMORY=8G
```

### Backend Workers
Edit `docker-compose.uat.yml` backend command:
```yaml
gunicorn i2dbackend.wsgi --bind 0.0.0.0:8001 --workers 8 --timeout 120
```

## Support

For issues or questions:
1. Check logs: `docker-compose -f docker-compose.uat.yml logs`
2. Review this guide's troubleshooting section
3. Contact the development team

## Maintenance Commands

```bash
# Stop all services
docker-compose -f docker-compose.uat.yml down

# Stop and remove volumes (WARNING: deletes data)
docker-compose -f docker-compose.uat.yml down -v

# Restart all services
docker-compose -f docker-compose.uat.yml restart

# Restart specific service
docker-compose -f docker-compose.uat.yml restart backend

# View container resource usage
docker stats

# Clean up unused Docker resources
docker system prune -a
```
