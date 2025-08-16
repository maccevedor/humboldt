# Django GIS Setup and Verification Guide

## Overview
This guide provides complete instructions for setting up, verifying, and troubleshooting Django GIS integration in the Visor I2D Humboldt project.

## Quick Setup Commands

### 1. Initial Setup
```bash
# Navigate to project directory
cd /home/mrueda/WWW/humboldt

# Stop containers
docker-compose down

# Rebuild backend with GIS dependencies
docker-compose build --no-cache backend

# Start all services
docker-compose up -d

# Wait for services to start
sleep 30
```

### 2. Verify Configuration
```bash
# Check PostGIS backend is configured
docker exec visor_i2d_backend env | grep DB_ENGINE
# Expected: DB_ENGINE=django.contrib.gis.db.backends.postgis

# Verify PostGIS extension
docker exec visor_i2d_db psql -U i2d_user -d i2d_db -c "SELECT PostGIS_Version();"

# Test Django GIS integration
docker exec visor_i2d_backend python /project/manage.py shell -c "
from django.conf import settings
from applications.dpto.models import DptoQueries
print('✅ DB Engine:', settings.DATABASES['default']['ENGINE'])
sample = DptoQueries.objects.first()
print('✅ Geometry type:', type(sample.geom))
print('✅ Sample area:', sample.geom.area if sample.geom else 'No geometry')
"
```

### 3. Run Test Suite
```bash
# Run complete test suite
./tests/run_all_tests.sh

# Or run individual tests
python3 ./tests/test_django_gis.py
python3 ./tests/test_spatial_performance.py
python3 ./tests/test_postgis_functions.py

# Or run from Docker container
docker exec visor_i2d_backend python /project/verify_django_gis.py
docker exec visor_i2d_backend python /project/quick_test.py
```

## Detailed Implementation

### Files Modified

#### Django Models
- **File**: `applications/dpto/models.py`
- **File**: `applications/mupio/models.py`
- **Change**: Updated imports and geometry field definitions

```python
# Before
from django.db import models
geom = models.TextField(blank=True, null=True)

# After
from django.contrib.gis.db import models
geom = models.GeometryField(blank=True, null=True)
```

#### Django Settings
- **Files**: `i2dbackend/settings/base.py`, `local.py`, `prod.py`
- **Changes**: Added GIS app and PostGIS backend

```python
INSTALLED_APPS = [
    # ... existing apps
    'django.contrib.gis',  # Added
]

DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',  # Changed
        # ... other settings
    }
}
```

#### Docker Configuration
- **File**: `dockerfile`
- **Change**: Added GIS system dependencies

```dockerfile
RUN apt-get update && apt-get install -y \
    gdal-bin \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    && rm -rf /var/lib/apt/lists/*
```

- **File**: `docker-compose.yml`
- **Change**: Added PostGIS environment variable

```yaml
backend:
  # ... existing config
  environment:
    - DB_ENGINE=django.contrib.gis.db.backends.postgis
```

## Verification Commands

### Check System Status
```bash
# Verify containers are running
docker ps | grep visor_i2d

# Check backend logs
docker-compose logs backend

# Check database connection
docker exec visor_i2d_db pg_isready -U i2d_user -d i2d_db
```

### Test Spatial Data
```bash
# Count records with geometry
docker exec visor_i2d_backend python /project/manage.py shell -c "
from applications.dpto.models import DptoQueries
from applications.mupio.models import MpioQueries
print('Departments with geometry:', DptoQueries.objects.filter(geom__isnull=False).count())
print('Total departments:', DptoQueries.objects.count())
print('Municipalities with geometry:', MpioQueries.objects.filter(geom__isnull=False).count())
print('Total municipalities:', MpioQueries.objects.count())
"

# Test spatial operations
docker exec visor_i2d_backend python /project/manage.py shell -c "
from applications.dpto.models import DptoQueries
dept = DptoQueries.objects.filter(geom__isnull=False).first()
if dept and dept.geom:
    print(f'Department: {dept.nombre}')
    print(f'Geometry type: {dept.geom.geom_type}')
    print(f'Area: {dept.geom.area:.4f}')
    print(f'Centroid: {dept.geom.centroid}')
    print(f'SRID: {dept.geom.srid}')
else:
    print('No geometry data found')
"
```

### Performance Testing
```bash
# Quick performance test
docker exec visor_i2d_backend python /project/manage.py shell -c "
import time
from applications.dpto.models import DptoQueries

# Test query performance
start = time.time()
count = DptoQueries.objects.filter(geom__isnull=False).count()
duration = time.time() - start
print(f'Query performance: {count} records in {duration:.3f}s')

# Test geometry operations
start = time.time()
dept = DptoQueries.objects.first()
if dept and dept.geom:
    area = dept.geom.area
    centroid = dept.geom.centroid
duration = time.time() - start
print(f'Geometry operations: {duration:.4f}s')
"
```

## Troubleshooting

### Common Issues

#### Issue 1: PostGIS Backend Not Configured
**Symptoms**: `AttributeError: 'DatabaseOperations' object has no attribute 'select'`

**Solution**:
```bash
# Check current backend
docker exec visor_i2d_backend env | grep DB_ENGINE

# If not showing PostGIS backend, restart containers
docker-compose down
docker-compose up -d

# Verify again
docker exec visor_i2d_backend env | grep DB_ENGINE
# Should show: DB_ENGINE=django.contrib.gis.db.backends.postgis
```

#### Issue 2: PostGIS Extension Missing
**Symptoms**: `function postgis_version() does not exist`

**Solution**:
```bash
# Enable PostGIS extension
docker exec visor_i2d_db psql -U i2d_user -d i2d_db -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# Verify extension
docker exec visor_i2d_db psql -U i2d_user -d i2d_db -c "SELECT PostGIS_Version();"
```

#### Issue 3: Django Module Not Found
**Symptoms**: `ModuleNotFoundError: No module named 'django'`

**Solution**: Always run Django commands from within the container:
```bash
# Wrong
python3 /home/mrueda/WWW/humboldt/tests/test_django_gis.py

# Correct
docker exec visor_i2d_backend python /project/../tests/test_django_gis.py
```

#### Issue 4: Container Not Running
**Symptoms**: `Error response from daemon: Container not running`

**Solution**:
```bash
# Check container status
docker ps -a | grep visor_i2d

# Start containers if stopped
docker-compose up -d

# Check logs for errors
docker-compose logs backend
```

### Health Check Commands
```bash
# Complete health check
echo "=== Docker Containers ==="
docker ps | grep visor_i2d

echo "=== Database Connection ==="
docker exec visor_i2d_db pg_isready -U i2d_user -d i2d_db

echo "=== PostGIS Extension ==="
docker exec visor_i2d_db psql -U i2d_user -d i2d_db -c "SELECT name, installed_version FROM pg_available_extensions WHERE name = 'postgis';"

echo "=== Django GIS Backend ==="
docker exec visor_i2d_backend env | grep DB_ENGINE

echo "=== Spatial Data Count ==="
docker exec visor_i2d_backend python /project/manage.py shell -c "
from applications.dpto.models import DptoQueries
print('Departments with geometry:', DptoQueries.objects.filter(geom__isnull=False).count())
"
```

## Expected Results

### Successful Setup
- ✅ All containers running
- ✅ PostGIS backend configured: `django.contrib.gis.db.backends.postgis`
- ✅ PostGIS extension installed and functional
- ✅ 297 departments with geometry data
- ✅ 8,702 municipalities with geometry data
- ✅ Spatial operations working (area, centroid, geometry types)

### Test Suite Results
When running `/home/mrueda/WWW/humboldt/tests/run_all_tests.sh`, expect:
- ✅ Django GIS Integration: PASSED
- ✅ Spatial Performance: PASSED
- ✅ PostGIS Functions: PASSED
- ✅ Overall success rate: 100%

## Advanced Usage

### Spatial Query Examples
```python
from applications.dpto.models import DptoQueries
from django.contrib.gis.geos import Point

# Basic spatial operations
dept = DptoQueries.objects.first()
area = dept.geom.area
centroid = dept.geom.centroid
geom_type = dept.geom.geom_type

# Spatial filtering (when advanced spatial functions are available)
# large_depts = DptoQueries.objects.filter(geom__area__gt=1.0)
# point = Point(-74.0, 4.0)  # Bogotá coordinates
# nearby = DptoQueries.objects.filter(geom__distance_lte=(point, 0.5))
```

### Performance Monitoring
```bash
# Monitor query performance
python3 ./tests/test_spatial_performance.py

# Check database performance
docker exec visor_i2d_db psql -U i2d_user -d i2d_db -c "
SELECT schemaname, tablename, attname, n_distinct, correlation 
FROM pg_stats 
WHERE tablename IN ('dpto_queries', 'mpio_queries') 
AND attname = 'geom';
"
```

## Maintenance

### Regular Checks
```bash
# Weekly health check
/home/mrueda/WWW/humboldt/tests/run_all_tests.sh

# Monitor spatial index usage
docker exec visor_i2d_db psql -U i2d_user -d i2d_db -c "
SELECT schemaname, tablename, indexname, idx_tup_read, idx_tup_fetch 
FROM pg_stat_user_indexes 
WHERE indexname LIKE '%geom%';
"
```

### Updates and Migrations
```bash
# After model changes, create migrations
docker exec visor_i2d_backend python /project/manage.py makemigrations

# Apply migrations
docker exec visor_i2d_backend python /project/manage.py migrate

# Test after changes
docker exec visor_i2d_backend python /project/../tests/test_django_gis.py
```

---

**Last Updated**: 16 August 2025  
**Django GIS Version**: Integrated with Django 3.1.7  
**PostGIS Version**: 3.4.3  
**Status**: Production Ready
