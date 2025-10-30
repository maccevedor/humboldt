#!/usr/bin/env python3
"""
Django GIS Test Script - Verify PostGIS integration
Tests spatial operations and GeometryField functionality
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

def test_django_gis():
    """Test Django GIS functionality"""
    print("🧪 Testing Django GIS Integration")
    print("=" * 50)
    
    try:
        # Test 1: Import GIS models
        print("1. Testing GIS model imports...")
        from applications.dpto.models import DptoQueries, DptoAmenazas
        from applications.mupio.models import MpioQueries, MpioAmenazas
        print("✅ GIS models imported successfully")
        
        # Test 2: Database connection
        print("\n2. Testing database connection...")
        from django.db import connection
        with connection.cursor() as cursor:
            cursor.execute("SELECT version()")
            db_version = cursor.fetchone()[0]
            print(f"✅ Database connected: {db_version}")
            
            cursor.execute("SELECT PostGIS_Version()")
            postgis_version = cursor.fetchone()[0]
            print(f"✅ PostGIS version: {postgis_version}")
        
        # Test 3: Query geometry fields
        print("\n3. Testing geometry field queries...")
        
        # Test department queries
        dpto_count = DptoQueries.objects.count()
        print(f"✅ Department queries count: {dpto_count}")
        
        if dpto_count > 0:
            # Get first department with geometry
            dpto = DptoQueries.objects.filter(geom__isnull=False).first()
            if dpto:
                print(f"✅ Found department with geometry: {dpto.nombre} (code: {dpto.codigo})")
                print(f"   Geometry type: {type(dpto.geom)}")
                
                # Test spatial operations
                from django.contrib.gis.geos import GEOSGeometry
                if hasattr(dpto.geom, 'geom_type'):
                    print(f"   Geometry type: {dpto.geom.geom_type}")
                    print(f"   Area: {dpto.geom.area:.2f}")
                    print(f"   Centroid: {dpto.geom.centroid}")
        
        # Test municipality queries
        mpio_count = MpioQueries.objects.count()
        print(f"✅ Municipality queries count: {mpio_count}")
        
        if mpio_count > 0:
            # Get first municipality with geometry
            mpio = MpioQueries.objects.filter(geom__isnull=False).first()
            if mpio:
                print(f"✅ Found municipality with geometry: {mpio.nombre} (code: {mpio.codigo})")
                if hasattr(mpio.geom, 'geom_type'):
                    print(f"   Geometry type: {mpio.geom.geom_type}")
        
        # Test 4: Spatial queries
        print("\n4. Testing spatial query operations...")
        
        # Test spatial filter
        geom_count = DptoQueries.objects.filter(geom__isnull=False).count()
        print(f"✅ Departments with geometry: {geom_count}")
        
        # Test spatial operations if we have geometry data
        if geom_count > 0:
            from django.contrib.gis.db.models import Extent
            extent = DptoQueries.objects.filter(geom__isnull=False).aggregate(extent=Extent('geom'))
            if extent['extent']:
                print(f"✅ Spatial extent: {extent['extent']}")
        
        print("\n🎉 Django GIS Integration Test PASSED!")
        print("✅ All spatial operations working correctly")
        return True
        
    except Exception as e:
        print(f"\n❌ Django GIS Test FAILED: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_raw_spatial_queries():
    """Test raw spatial SQL queries"""
    print("\n🔍 Testing Raw Spatial Queries")
    print("=" * 40)
    
    try:
        from django.db import connection
        
        with connection.cursor() as cursor:
            # Test PostGIS functions
            test_queries = [
                ("PostGIS Version", "SELECT PostGIS_Version()"),
                ("Geometry Count - Departments", "SELECT COUNT(*) FROM gbif_consultas.dpto_queries WHERE geom IS NOT NULL"),
                ("Geometry Count - Municipalities", "SELECT COUNT(*) FROM gbif_consultas.mpio_queries WHERE geom IS NOT NULL"),
                ("Geometry Type Sample", "SELECT ST_GeometryType(geom) FROM gbif_consultas.dpto_queries WHERE geom IS NOT NULL LIMIT 1"),
                ("Area Calculation", "SELECT codigo, nombre, ST_Area(geom) as area FROM gbif_consultas.dpto_queries WHERE geom IS NOT NULL LIMIT 3"),
            ]
            
            for test_name, query in test_queries:
                try:
                    cursor.execute(query)
                    result = cursor.fetchall()
                    print(f"✅ {test_name}: {result}")
                except Exception as e:
                    print(f"❌ {test_name}: {str(e)}")
        
        return True
        
    except Exception as e:
        print(f"❌ Raw spatial queries failed: {str(e)}")
        return False

if __name__ == "__main__":
    print("🚀 Starting Django GIS Verification Tests")
    print("=" * 60)
    
    # Run tests
    gis_test_passed = test_django_gis()
    raw_test_passed = test_raw_spatial_queries()
    
    print("\n" + "=" * 60)
    print("📊 TEST RESULTS SUMMARY")
    print("=" * 60)
    print(f"Django GIS Integration: {'✅ PASSED' if gis_test_passed else '❌ FAILED'}")
    print(f"Raw Spatial Queries:    {'✅ PASSED' if raw_test_passed else '❌ FAILED'}")
    
    if gis_test_passed and raw_test_passed:
        print("\n🎉 ALL TESTS PASSED - Django GIS is working correctly!")
        sys.exit(0)
    else:
        print("\n⚠️  SOME TESTS FAILED - Check configuration")
        sys.exit(1)
