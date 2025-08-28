#!/bin/bash

# Test script for Dynamic Project Management System
# Tests both backend API and frontend functionality

echo "🧪 Testing Dynamic Project Management System"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    
    echo -n "Testing: $test_name... "
    
    result=$(eval "$test_command" 2>/dev/null)
    
    if [[ -n "$expected_pattern" && "$result" =~ $expected_pattern ]] || [[ -z "$expected_pattern" && $? -eq 0 ]]; then
        echo -e "${GREEN}✅ PASSED${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAILED${NC}"
        echo "   Expected pattern: $expected_pattern"
        echo "   Got: $result"
        ((TESTS_FAILED++))
    fi
}

echo -e "\n${YELLOW}1. Backend API Tests${NC}"
echo "-------------------"

# Test 1: Check if backend is running
run_test "Backend Health Check" \
    "curl -s -o /dev/null -w '%{http_code}' http://localhost:8001/health/" \
    "200"

# Test 2: Test projects API endpoint
run_test "Projects API Endpoint" \
    "curl -s http://localhost:8001/api/projects/ | head -1" \
    "^\["

# Test 3: Test project by name endpoint
run_test "Project by Name API" \
    "curl -s http://localhost:8001/api/projects/by-name/general/ | grep -o '\"nombre_corto\":\"general\"'" \
    "\"nombre_corto\":\"general\""

# Test 4: Test ecoreservas project
run_test "Ecoreservas Project API" \
    "curl -s http://localhost:8001/api/projects/by-name/ecoreservas/ | grep -o '\"nombre_corto\":\"ecoreservas\"'" \
    "\"nombre_corto\":\"ecoreservas\""

echo -e "\n${YELLOW}2. Database Tests${NC}"
echo "----------------"

# Test 5: Check if projects table exists and has data
run_test "Projects Table Data" \
    "docker-compose exec -T backend python manage.py shell -c \"from applications.projects.models import Project; print(Project.objects.count())\"" \
    "[0-9]+"

# Test 6: Check layer groups
run_test "Layer Groups Data" \
    "docker-compose exec -T backend python manage.py shell -c \"from applications.projects.models import LayerGroup; print(LayerGroup.objects.count())\"" \
    "[0-9]+"

# Test 7: Check layers
run_test "Layers Data" \
    "docker-compose exec -T backend python manage.py shell -c \"from applications.projects.models import Layer; print(Layer.objects.count())\"" \
    "[0-9]+"

echo -e "\n${YELLOW}3. Frontend Tests${NC}"
echo "----------------"

# Test 8: Check if frontend is running
run_test "Frontend Health Check" \
    "curl -s -o /dev/null -w '%{http_code}' http://localhost:1234/" \
    "200"

# Test 9: Check if project service file exists
run_test "Project Service File" \
    "test -f /home/mrueda/WWW/humboldt/visor-geografico-I2D/src/components/services/projectService.js && echo 'exists'" \
    "exists"

# Test 10: Check if dynamic layers file exists
run_test "Dynamic Layers File" \
    "test -f /home/mrueda/WWW/humboldt/visor-geografico-I2D/src/components/mapComponent/dynamicLayers.js && echo 'exists'" \
    "exists"

# Test 11: Check if unit tests exist
run_test "Unit Tests Files" \
    "test -f /home/mrueda/WWW/humboldt/visor-geografico-I2D/tests/projectService.test.js && echo 'exists'" \
    "exists"

echo -e "\n${YELLOW}4. Integration Tests${NC}"
echo "-------------------"

# Test 12: Test project URL parameter handling
run_test "General Project URL" \
    "curl -s 'http://localhost:1234/?proyecto=general' | grep -o 'Visor.*I2D' | head -1" \
    "Visor.*I2D"

# Test 13: Test ecoreservas project URL
run_test "Ecoreservas Project URL" \
    "curl -s 'http://localhost:1234/?proyecto=ecoreservas' | grep -o 'Visor.*I2D' | head -1" \
    "Visor.*I2D"

echo -e "\n${YELLOW}5. Configuration Tests${NC}"
echo "---------------------"

# Test 14: Check Django settings
run_test "Django Projects App" \
    "docker-compose exec -T backend python manage.py shell -c \"from django.conf import settings; print('applications.projects' in settings.INSTALLED_APPS)\"" \
    "True"

# Test 15: Check migrations
run_test "Database Migrations" \
    "docker-compose exec -T backend python manage.py showmigrations projects | grep -c '\[X\]'" \
    "[1-9]"

echo -e "\n${YELLOW}📊 Test Results${NC}"
echo "==============="
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"
echo -e "Total Tests: $((TESTS_PASSED + TESTS_FAILED))"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All tests passed! Dynamic Project Management System is working correctly.${NC}"
    exit 0
else
    echo -e "\n${RED}⚠️  Some tests failed. Please check the implementation.${NC}"
    exit 1
fi
