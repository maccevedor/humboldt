#!/bin/bash
#
# Django GIS Test Runner Script
# Runs all Django GIS tests and generates a comprehensive report
#

echo "🚀 Django GIS Test Suite Runner"
echo "=================================="
echo "Starting comprehensive Django GIS testing..."
echo ""

# Set test directory
TEST_DIR="./tests"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORT_FILE="./tests/test_report_${TIMESTAMP}.txt"

# Function to run test and capture output
run_test() {
    local test_name="$1"
    local test_file="$2"
    local test_method="$3"
    
    echo "Running $test_name..."
    echo "========================" >> "$REPORT_FILE"
    echo "TEST: $test_name" >> "$REPORT_FILE"
    echo "FILE: $test_file" >> "$REPORT_FILE"
    echo "TIME: $(date)" >> "$REPORT_FILE"
    echo "========================" >> "$REPORT_FILE"
    
    if [ "$test_method" = "docker" ]; then
        docker exec visor_i2d_backend python "$test_file" >> "$REPORT_FILE" 2>&1
    else
        python3 "$test_file" >> "$REPORT_FILE" 2>&1
    fi
    
    local exit_code=$?
    echo "" >> "$REPORT_FILE"
    
    if [ $exit_code -eq 0 ]; then
        echo "✅ $test_name PASSED"
        echo "RESULT: PASSED" >> "$REPORT_FILE"
    else
        echo "❌ $test_name FAILED"
        echo "RESULT: FAILED (exit code: $exit_code)" >> "$REPORT_FILE"
    fi
    echo "" >> "$REPORT_FILE"
    
    return $exit_code
}

# Initialize report
echo "Django GIS Test Suite Report" > "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo "Host: $(hostname)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check if Docker containers are running
echo "🔍 Checking Docker containers..."
if ! docker ps | grep -q visor_i2d_backend; then
    echo "❌ Backend container not running. Starting containers..."
    docker-compose up -d
    sleep 10
fi

# Test results tracking
declare -a test_results
total_tests=0
passed_tests=0

# Run tests
echo ""
echo "📋 Running test suite..."

# Test 1: Django GIS Configuration and Integration
run_test "Django GIS Integration" "./tests/test_django_gis.py" "local"
test_results[0]=$?
total_tests=$((total_tests + 1))
[ ${test_results[0]} -eq 0 ] && passed_tests=$((passed_tests + 1))

# Test 2: Spatial Performance
run_test "Spatial Performance" "./tests/test_spatial_performance.py" "local"
test_results[1]=$?
total_tests=$((total_tests + 1))
[ ${test_results[1]} -eq 0 ] && passed_tests=$((passed_tests + 1))

# Test 3: PostGIS Functions
run_test "PostGIS Functions" "./tests/test_postgis_functions.py" "local"
test_results[2]=$?
total_tests=$((total_tests + 1))
[ ${test_results[2]} -eq 0 ] && passed_tests=$((passed_tests + 1))

# Generate summary
echo ""
echo "📊 TEST SUMMARY"
echo "==============="
echo "Total tests: $total_tests"
echo "Passed: $passed_tests"
echo "Failed: $((total_tests - passed_tests))"
echo "Success rate: $(( passed_tests * 100 / total_tests ))%"

# Add summary to report
echo "" >> "$REPORT_FILE"
echo "===============================================" >> "$REPORT_FILE"
echo "FINAL SUMMARY" >> "$REPORT_FILE"
echo "===============================================" >> "$REPORT_FILE"
echo "Total tests: $total_tests" >> "$REPORT_FILE"
echo "Passed: $passed_tests" >> "$REPORT_FILE"
echo "Failed: $((total_tests - passed_tests))" >> "$REPORT_FILE"
echo "Success rate: $(( passed_tests * 100 / total_tests ))%" >> "$REPORT_FILE"
echo "Report generated: $(date)" >> "$REPORT_FILE"

echo ""
echo "📄 Detailed report saved to: $REPORT_FILE"

# Return appropriate exit code
if [ $passed_tests -eq $total_tests ]; then
    echo "🎉 ALL TESTS PASSED!"
    exit 0
else
    echo "⚠️  Some tests failed. Check the report for details."
    exit 1
fi
