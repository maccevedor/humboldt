# Django GIS Test Suite

This directory contains comprehensive tests for Django GIS integration in the Visor I2D Humboldt project.

## Test Files

### `test_django_gis.py`
Comprehensive Django GIS integration test suite covering:
- Django GIS configuration verification
- Database connection and PostGIS availability
- Model geometry fields testing
- Spatial operations testing
- Spatial queries testing
- Basic performance testing

### `test_spatial_performance.py`
Performance-focused tests for spatial operations:
- Spatial query performance benchmarking
- Geometry operations performance testing
- Database response time measurements

### `test_postgis_functions.py`
PostGIS-specific function tests:
- PostGIS version and extension verification
- Spatial functions availability testing
- Real data spatial operations testing

## Running Tests

### Prerequisites
Ensure Docker containers are running:
```bash
cd /home/mrueda/WWW/humboldt
docker-compose up -d
```

### Run Individual Tests

#### Complete Django GIS Test Suite
```bash
python3 ./tests/test_django_gis.py
```

#### Performance Tests
```bash
python3 ./tests/test_spatial_performance.py
```

#### PostGIS Functions Tests
```bash
python3 ./tests/test_postgis_functions.py
```

### Run Tests from Docker Container
```bash
# Complete test suite
docker exec visor_i2d_backend python /project/tests/quick_test.py

# Verification script
docker exec visor_i2d_backend python /project/tests/verify_django_gis.py
```

### Run All Tests (Batch)
```bash
cd ./tests
for test in test_*.py; do
    echo "Running $test..."
    python3 "$test"
    echo "---"
done
```

## Expected Results

### Successful Test Output
- ✅ All configuration tests should pass
- ✅ Database connection should be established
- ✅ All 297 departments should have geometry data
- ✅ All 8,702 municipalities should have geometry data
- ✅ Spatial operations should work correctly
- ✅ PostGIS functions should be available

### Common Issues and Solutions

#### Issue: `ModuleNotFoundError: No module named 'django'`
**Solution**: Run tests from Docker container:
```bash
docker exec visor_i2d_backend python /project/../tests/test_django_gis.py
```

#### Issue: `function postgis_version() does not exist`
**Solution**: Enable PostGIS extension:
```bash
docker exec visor_i2d_db psql -U i2d_user -d i2d_db -c "CREATE EXTENSION IF NOT EXISTS postgis;"
```

#### Issue: `AttributeError: 'DatabaseOperations' object has no attribute 'select'`
**Solution**: Verify PostGIS backend is configured:
```bash
docker exec visor_i2d_backend env | grep DB_ENGINE
# Should show: DB_ENGINE=django.contrib.gis.db.backends.postgis
```

## Test Results Interpretation

### Configuration Tests
- Verifies Django GIS is properly installed and configured
- Checks database backend is set to PostGIS
- Confirms django.contrib.gis is in INSTALLED_APPS

### Database Tests
- Tests PostgreSQL connection
- Verifies PostGIS extension is installed and available
- Checks spatial reference systems

### Model Tests
- Validates GeometryField integration
- Tests model queries and data access
- Verifies spatial data completeness

### Performance Tests
- Measures query response times
- Tests geometry operation performance
- Provides benchmarks for optimization

## Troubleshooting

### Check Django GIS Configuration
```bash
docker exec visor_i2d_backend python /project/manage.py shell -c "
from django.conf import settings
print('DB Engine:', settings.DATABASES['default']['ENGINE'])
print('GIS in INSTALLED_APPS:', 'django.contrib.gis' in settings.INSTALLED_APPS)
"
```

### Verify PostGIS Extension
```bash
docker exec visor_i2d_db psql -U i2d_user -d i2d_db -c "
SELECT name, default_version, installed_version 
FROM pg_available_extensions 
WHERE name LIKE '%postgis%';
"
```

### Check Geometry Data
```bash
docker exec visor_i2d_backend python /project/manage.py shell -c "
from applications.dpto.models import DptoQueries
print('Departments with geometry:', DptoQueries.objects.filter(geom__isnull=False).count())
print('Total departments:', DptoQueries.objects.count())
"
```
