# Django GIS Commands Reference

## Quick Verification Commands

### 1. Check Django GIS Status
```bash
# Verify PostGIS backend is configured
docker exec visor_i2d_backend env | grep DB_ENGINE
# Expected: DB_ENGINE=django.contrib.gis.db.backends.postgis

# Or run from Docker container
docker exec visor_i2d_backend python /project/tests/verify_django_gis.py
docker exec visor_i2d_backend python /project/tests/quick_test.py
```

### 2. Test Spatial Operations
```bash
# Test basic spatial operations
docker exec visor_i2d_backend python /project/manage.py shell -c "
from applications.dpto.models import DptoQueries
dept = DptoQueries.objects.first()
print(f'Department: {dept.nombre}')
print(f'Geometry type: {dept.geom.geom_type}')
print(f'Area: {dept.geom.area:.4f}')
print(f'Centroid: {dept.geom.centroid}')
"
```

### 3. Verify Data Completeness
```bash
# Check geometry data completeness
docker exec visor_i2d_backend python /project/manage.py shell -c "
from applications.dpto.models import DptoQueries
from applications.mupio.models import MpioQueries
print('Departments with geometry:', DptoQueries.objects.filter(geom__isnull=False).count(), '/ 297')
print('Municipalities with geometry:', MpioQueries.objects.filter(geom__isnull=False).count(), '/ 8702')
"
```

### 4. Performance Test
```bash
# Quick performance test
docker exec visor_i2d_backend python /project/manage.py shell -c "
import time
from applications.dpto.models import DptoQueries

start = time.time()
count = DptoQueries.objects.filter(geom__isnull=False).count()
duration = time.time() - start
print(f'Query performance: {count} records in {duration:.3f}s')

start = time.time()
dept = DptoQueries.objects.first()
if dept.geom:
    area = dept.geom.area
    centroid = dept.geom.centroid
duration = time.time() - start
print(f'Geometry operations: {duration:.4f}s')
"
```

## Setup Commands (If Needed)

### Initial Setup
```bash
# Run from project root directory
docker-compose down
docker-compose build --no-cache backend
docker-compose up -d
```

### Enable PostGIS Extension
```bash
docker exec visor_i2d_db psql -U i2d_user -d i2d_db -c "CREATE EXTENSION IF NOT EXISTS postgis;"
```

## Troubleshooting Commands

### Check Container Status
```bash
docker ps | grep visor_i2d
docker-compose logs backend
```

### Database Health Check
```bash
docker exec visor_i2d_db pg_isready -U i2d_user -d i2d_db
docker exec visor_i2d_db psql -U i2d_user -d i2d_db -c "SELECT PostGIS_Version();"
```

### Reset if Needed
```bash
docker-compose down
docker-compose up -d
sleep 30
docker exec visor_i2d_backend python /project/verify_django_gis.py
```

## Expected Results

### Successful Verification Output
```
🔧 Django GIS Verification
==============================
1. Environment check...
   DB_ENGINE: django.contrib.gis.db.backends.postgis

2. Django import test...
   Configured engine: django.contrib.gis.db.backends.postgis
   ✅ PostGIS backend configured

3. Model import test...
   ✅ GIS models imported successfully
   ✅ Departments: 297
   ✅ Municipalities: 8702

4. Geometry field test...
   ✅ Sample department: ANTIOQUIA
   ✅ Geometry type: <class 'django.contrib.gis.geos.collections.MultiPolygon'>
   ✅ Has geometry data: Yes
   ✅ Geometry class: MultiPolygon
   ✅ Area: 5.1349

🎯 Verification completed!
```

## Files Created/Modified

### Test Files
- `./tests/test_django_gis.py` - Comprehensive test suite
- `./tests/test_spatial_performance.py` - Performance tests
- `./tests/test_postgis_functions.py` - PostGIS function tests
- `./tests/README.md` - Test documentation
- `./verify_django_gis.py` - Quick verification script

### Documentation
- `./DJANGO_GIS_SETUP.md` - Complete setup guide
- `./visor-geografico-I2D-backend/docs/database.md` - Updated with GIS section

### Modified Files
- `applications/dpto/models.py` - GeometryField integration
- `applications/mupio/models.py` - GeometryField integration
- `i2dbackend/settings/base.py` - Added django.contrib.gis
- `i2dbackend/settings/local.py` - PostGIS backend
- `i2dbackend/settings/prod.py` - PostGIS backend
- `dockerfile` - Added GIS dependencies
- `docker-compose.yml` - PostGIS environment variable
