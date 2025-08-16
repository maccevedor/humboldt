#!/usr/bin/env python3
"""
Django GIS Test Suite - Comprehensive testing for PostGIS integration
Tests spatial operations, GeometryField functionality, and database performance
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

def test_django_gis_configuration():
    """Test Django GIS configuration and setup"""
    print("🔧 Testing Django GIS Configuration")
    print("=" * 50)
    
    try:
        # Test 1: Django GIS imports
        print("1. Testing Django GIS imports...")
        from django.contrib.gis.db import models as gis_models
        from django.contrib.gis.geos import GEOSGeometry, Point, Polygon
        print("✅ Django GIS imports successful")
        
        # Test 2: Database backend verification
        print("\n2. Testing database backend...")
        db_engine = settings.DATABASES['default']['ENGINE']
        expected_engine = 'django.contrib.gis.db.backends.postgis'
        if db_engine == expected_engine:
            print(f"✅ PostGIS backend configured: {db_engine}")
        else:
            print(f"❌ Wrong backend: {db_engine} (expected: {expected_engine})")
            return False
        
        # Test 3: INSTALLED_APPS verification
        print("\n3. Testing INSTALLED_APPS...")
        if 'django.contrib.gis' in settings.INSTALLED_APPS:
            print("✅ django.contrib.gis in INSTALLED_APPS")
        else:
            print("❌ django.contrib.gis missing from INSTALLED_APPS")
            return False
        
        return True
        
    except Exception as e:
        print(f"❌ Configuration test failed: {str(e)}")
        return False

def test_database_connection():
    """Test database connection and PostGIS availability"""
    print("\n🔌 Testing Database Connection")
    print("=" * 40)
    
    try:
        from django.db import connection
        
        with connection.cursor() as cursor:
            # Test database connection
            cursor.execute("SELECT version()")
            db_version = cursor.fetchone()[0]
            print(f"✅ Database connected: {db_version[:50]}...")
            
            # Test PostGIS extension
            cursor.execute("SELECT name, default_version, installed_version FROM pg_available_extensions WHERE name = 'postgis'")
            postgis_info = cursor.fetchone()
            if postgis_info:
                print(f"✅ PostGIS extension: {postgis_info[0]} v{postgis_info[2]}")
            else:
                print("❌ PostGIS extension not found")
                return False
        
        return True
        
    except Exception as e:
        print(f"❌ Database connection test failed: {str(e)}")
        return False

def test_model_geometry_fields():
    """Test Django GIS model geometry fields"""
    print("\n📐 Testing Model Geometry Fields")
    print("=" * 45)
    
    try:
        from applications.dpto.models import DptoQueries, DptoAmenazas
        from applications.mupio.models import MpioQueries, MpioAmenazas
        
        # Test department models
        print("1. Testing department models...")
        dpto_count = DptoQueries.objects.count()
        dpto_amenazas_count = DptoAmenazas.objects.count()
        print(f"✅ DptoQueries records: {dpto_count}")
        print(f"✅ DptoAmenazas records: {dpto_amenazas_count}")
        
        # Test municipality models
        print("\n2. Testing municipality models...")
        mpio_count = MpioQueries.objects.count()
        mpio_amenazas_count = MpioAmenazas.objects.count()
        print(f"✅ MpioQueries records: {mpio_count}")
        print(f"✅ MpioAmenazas records: {mpio_amenazas_count}")
        
        return True
        
    except Exception as e:
        print(f"❌ Model geometry fields test failed: {str(e)}")
        return False

def test_spatial_operations():
    """Test spatial operations and geometry manipulation"""
    print("\n🌍 Testing Spatial Operations")
    print("=" * 40)
    
    try:
        from applications.dpto.models import DptoQueries
        from applications.mupio.models import MpioQueries
        
        # Test department geometry operations
        print("1. Testing department geometry operations...")
        dpto = DptoQueries.objects.filter(geom__isnull=False).first()
        if dpto and dpto.geom:
            print(f"✅ Sample department: {dpto.nombre} (code: {dpto.codigo})")
            print(f"   Geometry type: {dpto.geom.geom_type}")
            print(f"   Area: {dpto.geom.area:.4f}")
            print(f"   Centroid: {dpto.geom.centroid}")
            print(f"   Number of geometries: {dpto.geom.num_geom}")
            print(f"   SRID: {dpto.geom.srid}")
        else:
            print("❌ No department geometry found")
            return False
        
        # Test municipality geometry operations
        print("\n2. Testing municipality geometry operations...")
        mpio = MpioQueries.objects.filter(geom__isnull=False).first()
        if mpio and mpio.geom:
            print(f"✅ Sample municipality: {mpio.nombre} (code: {mpio.codigo})")
            print(f"   Geometry type: {mpio.geom.geom_type}")
            print(f"   Area: {mpio.geom.area:.6f}")
            print(f"   SRID: {mpio.geom.srid}")
        else:
            print("❌ No municipality geometry found")
            return False
        
        return True
        
    except Exception as e:
        print(f"❌ Spatial operations test failed: {str(e)}")
        return False

def test_spatial_queries():
    """Test spatial query capabilities"""
    print("\n🔍 Testing Spatial Queries")
    print("=" * 35)
    
    try:
        from applications.dpto.models import DptoQueries
        from applications.mupio.models import MpioQueries
        
        # Test geometry filtering
        print("1. Testing geometry filtering...")
        geom_dpto_count = DptoQueries.objects.filter(geom__isnull=False).count()
        total_dpto_count = DptoQueries.objects.count()
        print(f"✅ Departments with geometry: {geom_dpto_count}/{total_dpto_count}")
        
        geom_mpio_count = MpioQueries.objects.filter(geom__isnull=False).count()
        total_mpio_count = MpioQueries.objects.count()
        print(f"✅ Municipalities with geometry: {geom_mpio_count}/{total_mpio_count}")
        
        # Test spatial data completeness
        print("\n2. Testing spatial data completeness...")
        if geom_dpto_count == total_dpto_count:
            print("✅ All departments have geometry data")
        else:
            print(f"⚠️  {total_dpto_count - geom_dpto_count} departments missing geometry")
        
        if geom_mpio_count == total_mpio_count:
            print("✅ All municipalities have geometry data")
        else:
            print(f"⚠️  {total_mpio_count - geom_mpio_count} municipalities missing geometry")
        
        return True
        
    except Exception as e:
        print(f"❌ Spatial queries test failed: {str(e)}")
        return False

def test_performance_basic():
    """Test basic performance of spatial operations"""
    print("\n⚡ Testing Basic Performance")
    print("=" * 35)
    
    try:
        import time
        from applications.dpto.models import DptoQueries
        
        # Test query performance
        print("1. Testing query performance...")
        start_time = time.time()
        count = DptoQueries.objects.filter(geom__isnull=False).count()
        query_time = time.time() - start_time
        print(f"✅ Geometry count query: {count} records in {query_time:.3f}s")
        
        # Test geometry access performance
        print("\n2. Testing geometry access performance...")
        start_time = time.time()
        sample_dpto = DptoQueries.objects.filter(geom__isnull=False).first()
        if sample_dpto:
            area = sample_dpto.geom.area
            centroid = sample_dpto.geom.centroid
        access_time = time.time() - start_time
        print(f"✅ Geometry operations: completed in {access_time:.3f}s")
        
        return True
        
    except Exception as e:
        print(f"❌ Performance test failed: {str(e)}")
        return False

def run_all_tests():
    """Run all Django GIS tests"""
    print("🚀 Django GIS Comprehensive Test Suite")
    print("=" * 60)
    
    tests = [
        ("Configuration", test_django_gis_configuration),
        ("Database Connection", test_database_connection),
        ("Model Geometry Fields", test_model_geometry_fields),
        ("Spatial Operations", test_spatial_operations),
        ("Spatial Queries", test_spatial_queries),
        ("Basic Performance", test_performance_basic),
    ]
    
    results = {}
    
    for test_name, test_func in tests:
        try:
            results[test_name] = test_func()
        except Exception as e:
            print(f"\n❌ {test_name} test crashed: {str(e)}")
            results[test_name] = False
    
    # Print summary
    print("\n" + "=" * 60)
    print("📊 TEST RESULTS SUMMARY")
    print("=" * 60)
    
    passed = 0
    total = len(tests)
    
    for test_name, result in results.items():
        status = "✅ PASSED" if result else "❌ FAILED"
        print(f"{test_name:<25}: {status}")
        if result:
            passed += 1
    
    print("=" * 60)
    print(f"OVERALL RESULT: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 ALL TESTS PASSED - Django GIS is fully functional!")
        return True
    else:
        print("⚠️  SOME TESTS FAILED - Check configuration and setup")
        return False

if __name__ == "__main__":
    success = run_all_tests()
    sys.exit(0 if success else 1)
