#!/usr/bin/env python3
"""
PostGIS Functions Test Suite
Tests PostGIS spatial functions and database capabilities
"""

import os
import sys
import django
from django.conf import settings

# Add the project directory to Python path
sys.path.append('./visor-geografico-I2D-backend')

# Configure Django settings
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'i2dbackend.settings.local')
django.setup()

def test_postgis_functions():
    """Test PostGIS functions availability"""
    print("🗄️  PostGIS Functions Test")
    print("=" * 35)
    
    from django.db import connection
    
    # PostGIS function tests
    tests = [
        ("PostGIS Version", "SELECT PostGIS_Version()"),
        ("GEOS Version", "SELECT PostGIS_GEOS_Version()"),
        ("PROJ Version", "SELECT PostGIS_Proj_Version()"),
        ("GDAL Version", "SELECT PostGIS_GDAL_Version()"),
        ("Spatial Reference Systems", "SELECT COUNT(*) FROM spatial_ref_sys"),
        ("Available Extensions", "SELECT name FROM pg_available_extensions WHERE name LIKE '%postgis%'"),
    ]
    
    with connection.cursor() as cursor:
        for test_name, query in tests:
            try:
                cursor.execute(query)
                result = cursor.fetchall()
                print(f"✅ {test_name:<25}: {result}")
            except Exception as e:
                print(f"❌ {test_name:<25}: {str(e)[:50]}...")

def test_spatial_functions_on_data():
    """Test spatial functions on actual data"""
    print("\n📐 Spatial Functions on Data Test")
    print("=" * 45)
    
    from django.db import connection
    
    # Spatial function tests on real data
    tests = [
        ("Geometry count - Departments", 
         "SELECT COUNT(*) FROM gbif_consultas.dpto_queries WHERE geom IS NOT NULL"),
        ("Geometry count - Municipalities", 
         "SELECT COUNT(*) FROM gbif_consultas.mpio_queries WHERE geom IS NOT NULL"),
        ("Geometry types - Departments", 
         "SELECT DISTINCT ST_GeometryType(geom) FROM gbif_consultas.dpto_queries WHERE geom IS NOT NULL LIMIT 5"),
        ("Sample area calculation", 
         "SELECT codigo, nombre, ST_Area(geom) as area FROM gbif_consultas.dpto_queries WHERE geom IS NOT NULL LIMIT 3"),
        ("Sample centroid calculation", 
         "SELECT codigo, ST_X(ST_Centroid(geom)) as lon, ST_Y(ST_Centroid(geom)) as lat FROM gbif_consultas.dpto_queries WHERE geom IS NOT NULL LIMIT 3"),
        ("SRID information", 
         "SELECT DISTINCT ST_SRID(geom) FROM gbif_consultas.dpto_queries WHERE geom IS NOT NULL"),
    ]
    
    with connection.cursor() as cursor:
        for test_name, query in tests:
            try:
                cursor.execute(query)
                result = cursor.fetchall()
                print(f"✅ {test_name}")
                for row in result[:3]:  # Limit output
                    print(f"   {row}")
            except Exception as e:
                print(f"❌ {test_name}: {str(e)[:50]}...")

if __name__ == "__main__":
    test_postgis_functions()
    test_spatial_functions_on_data()
    print("\n🎯 PostGIS functions tests completed!")
