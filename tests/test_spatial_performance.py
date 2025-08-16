#!/usr/bin/env python3
"""
Spatial Performance Test Suite
Tests performance of spatial operations and database queries
"""

import os
import sys
import time
import django
from django.conf import settings

# Add the project directory to Python path
sys.path.append('./visor-geografico-I2D-backend')

# Configure Django settings
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'i2dbackend.settings.local')
django.setup()

def test_spatial_query_performance():
    """Test performance of spatial queries"""
    print("⚡ Spatial Query Performance Test")
    print("=" * 45)
    
    from applications.dpto.models import DptoQueries
    from applications.mupio.models import MpioQueries
    
    tests = [
        ("Department count", lambda: DptoQueries.objects.count()),
        ("Department with geometry", lambda: DptoQueries.objects.filter(geom__isnull=False).count()),
        ("Municipality count", lambda: MpioQueries.objects.count()),
        ("Municipality with geometry", lambda: MpioQueries.objects.filter(geom__isnull=False).count()),
        ("First department geometry", lambda: DptoQueries.objects.first().geom.area if DptoQueries.objects.first().geom else 0),
        ("First municipality geometry", lambda: MpioQueries.objects.first().geom.area if MpioQueries.objects.first().geom else 0),
    ]
    
    for test_name, test_func in tests:
        start_time = time.time()
        try:
            result = test_func()
            duration = time.time() - start_time
            print(f"✅ {test_name:<30}: {duration:.3f}s (result: {result})")
        except Exception as e:
            duration = time.time() - start_time
            print(f"❌ {test_name:<30}: {duration:.3f}s (error: {str(e)[:50]})")

def test_geometry_operations_performance():
    """Test performance of geometry operations"""
    print("\n🌍 Geometry Operations Performance Test")
    print("=" * 50)
    
    from applications.dpto.models import DptoQueries
    
    # Get sample department
    sample_dept = DptoQueries.objects.filter(geom__isnull=False).first()
    if not sample_dept or not sample_dept.geom:
        print("❌ No sample department with geometry found")
        return
    
    print(f"Testing with: {sample_dept.nombre}")
    
    operations = [
        ("Area calculation", lambda: sample_dept.geom.area),
        ("Centroid calculation", lambda: sample_dept.geom.centroid),
        ("Geometry type", lambda: sample_dept.geom.geom_type),
        ("Number of geometries", lambda: sample_dept.geom.num_geom),
        ("SRID", lambda: sample_dept.geom.srid),
        ("WKT (first 100 chars)", lambda: str(sample_dept.geom)[:100]),
    ]
    
    for op_name, op_func in operations:
        start_time = time.time()
        try:
            result = op_func()
            duration = time.time() - start_time
            print(f"✅ {op_name:<25}: {duration:.4f}s")
        except Exception as e:
            duration = time.time() - start_time
            print(f"❌ {op_name:<25}: {duration:.4f}s (error: {str(e)[:30]})")

if __name__ == "__main__":
    test_spatial_query_performance()
    test_geometry_operations_performance()
    print("\n🎯 Performance tests completed!")
