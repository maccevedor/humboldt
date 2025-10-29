# Quick Start - UAT Deployment

## 🚀 One-Command Deployment

```bash
cd /opt/humboldt
cp .env.uat .env
nano .env  # Update passwords and settings
./deploy-uat.sh
```

## 📋 Pre-Deployment Checklist

- [ ] Docker and Docker Compose installed
- [ ] `.env` file configured with secure passwords
- [ ] Backend `.env` file configured
- [ ] Frontend `.env` file configured
- [ ] Sufficient disk space (50GB+)
- [ ] Sufficient RAM (8GB+)

## 🔧 Essential Commands

### Deploy/Update
```bash
./deploy-uat.sh
```

### View Logs
```bash
docker-compose -f docker-compose.uat.yml logs -f
```

### Restart Services
```bash
docker-compose -f docker-compose.uat.yml restart
```

### Stop Services
```bash
docker-compose -f docker-compose.uat.yml down
```

### Check Status
```bash
docker-compose -f docker-compose.uat.yml ps
```

## 🌐 Service URLs

| Service | URL | Default Credentials |
|---------|-----|---------------------|
| Frontend | http://localhost:8080 | N/A |
| Backend Admin | http://localhost:8001/admin/ | Create superuser |
| GeoServer | http://localhost:8081/geoserver | admin / (from .env) |
| Nginx | http://localhost | N/A |

## 🔐 Create Django Superuser

```bash
docker-compose -f docker-compose.uat.yml exec backend python manage.py createsuperuser
```

## 💾 Backup Database

```bash
mkdir -p backups
docker-compose -f docker-compose.uat.yml exec -T db pg_dump -U i2d_user -d i2d_db > backups/backup_$(date +%Y%m%d_%H%M%S).sql
```

## 🔄 Update Application

```bash
git pull origin main
git submodule update --init --recursive
./deploy-uat.sh
```

## 🐛 Quick Troubleshooting

### Frontend not loading?
```bash
docker-compose -f docker-compose.uat.yml logs frontend
docker-compose -f docker-compose.uat.yml restart frontend
```

### Backend errors?
```bash
docker-compose -f docker-compose.uat.yml logs backend
docker-compose -f docker-compose.uat.yml exec backend python manage.py check
```

### Database issues?
```bash
docker-compose -f docker-compose.uat.yml logs db
docker-compose -f docker-compose.uat.yml exec db pg_isready -U i2d_user -d i2d_db
```

### Permission errors?
```bash
# The new Dockerfile.uat fixes this!
docker-compose -f docker-compose.uat.yml build --no-cache frontend
docker-compose -f docker-compose.uat.yml up -d frontend
```

## 📚 Full Documentation

- **Complete Guide**: `UAT_DEPLOYMENT_GUIDE.md`
- **Setup Summary**: `UAT_SETUP_SUMMARY.md`
- **Docker Compose**: `docker-compose.uat.yml`

## ⚠️ Important Notes

1. **Always backup** before updates
2. **Use strong passwords** in `.env`
3. **Monitor logs** after deployment
4. **Test thoroughly** before going live
5. **Keep Docker updated**

## 🆘 Emergency Commands

### Complete Reset (⚠️ Deletes all data!)
```bash
docker-compose -f docker-compose.uat.yml down -v
docker system prune -a
./deploy-uat.sh
```

### Restore from Backup
```bash
docker-compose -f docker-compose.uat.yml stop backend
cat backups/backup_YYYYMMDD_HHMMSS.sql | docker-compose -f docker-compose.uat.yml exec -T db psql -U i2d_user -d i2d_db
docker-compose -f docker-compose.uat.yml start backend
```

## ✅ Health Check

```bash
# All services should show "healthy"
docker-compose -f docker-compose.uat.yml ps

# Test endpoints
curl http://localhost:8080
curl http://localhost:8001/admin/
curl http://localhost:8081/geoserver/web/
```

---

**Need help?** Check the full documentation or contact the development team.
