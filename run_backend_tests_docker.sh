#!/bin/bash

# Docker-based Backend Test Runner for Visor I2D Humboldt
# This script runs tests inside the Docker container

echo "==========================================="
echo "Visor I2D Humboldt - Docker Test Runner"
echo "==========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

CONTAINER_NAME="visor_i2d_backend"

# Check if container is running
check_container() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo -e "${RED}Error: Backend container '${CONTAINER_NAME}' is not running${NC}"
        echo "Please start the container with: docker-compose up -d backend"
        exit 1
    fi
}

# Function to run tests for a specific app
run_app_tests() {
    local app_name=$1
    echo -e "${YELLOW}Running tests for: $app_name${NC}"
    echo "-------------------------------------------"
    
    docker exec $CONTAINER_NAME python manage.py test applications.$app_name --verbosity=2 --failfast
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $app_name tests passed${NC}"
    else
        echo -e "${RED}✗ $app_name tests failed${NC}"
        FAILED_APPS+=("$app_name")
    fi
    echo ""
}

# Function to run all tests
run_all_tests() {
    echo -e "${YELLOW}Running all backend tests...${NC}"
    echo "==========================================="
    
    docker exec $CONTAINER_NAME python manage.py test applications --verbosity=2
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ All tests passed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Some tests failed${NC}"
        return 1
    fi
}

# Function to run tests with coverage
run_tests_with_coverage() {
    echo -e "${YELLOW}Running tests with coverage report...${NC}"
    echo "==========================================="
    
    # Install coverage if not present
    docker exec $CONTAINER_NAME pip install coverage
    
    # Run tests with coverage
    docker exec $CONTAINER_NAME coverage run --source='applications' manage.py test applications --verbosity=2
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}Generating coverage report...${NC}"
        docker exec $CONTAINER_NAME coverage report -m
        docker exec $CONTAINER_NAME coverage html
        echo -e "${GREEN}HTML coverage report generated in htmlcov/index.html${NC}"
    else
        echo -e "${RED}✗ Tests failed${NC}"
        return 1
    fi
}

# Function to setup test environment
setup_test_env() {
    echo -e "${YELLOW}Setting up test environment...${NC}"
    echo "==========================================="
    
    # Install test dependencies
    docker exec $CONTAINER_NAME pip install unidecode coverage
    
    # Run migrations for test database
    docker exec $CONTAINER_NAME python manage.py migrate --run-syncdb
    
    echo -e "${GREEN}✓ Test environment ready${NC}"
    echo ""
}

# Check container status first
check_container

# Parse command line arguments
case "$1" in
    all)
        setup_test_env
        run_all_tests
        ;;
    coverage)
        setup_test_env
        run_tests_with_coverage
        ;;
    dpto)
        setup_test_env
        run_app_tests "dpto"
        ;;
    gbif)
        setup_test_env
        run_app_tests "gbif"
        ;;
    mupio)
        setup_test_env
        run_app_tests "mupio"
        ;;
    mupiopolitico)
        setup_test_env
        run_app_tests "mupiopolitico"
        ;;
    individual)
        # Run tests for each app individually
        setup_test_env
        FAILED_APPS=()
        
        for app in dpto gbif mupio mupiopolitico; do
            run_app_tests "$app"
        done
        
        echo "==========================================="
        if [ ${#FAILED_APPS[@]} -eq 0 ]; then
            echo -e "${GREEN}✓ All individual app tests passed!${NC}"
        else
            echo -e "${RED}✗ Failed apps: ${FAILED_APPS[*]}${NC}"
            exit 1
        fi
        ;;
    setup)
        setup_test_env
        ;;
    shell)
        echo -e "${YELLOW}Opening Django shell in container...${NC}"
        docker exec -it $CONTAINER_NAME python manage.py shell
        ;;
    help|--help|-h)
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  all           - Run all tests at once"
        echo "  individual    - Run tests for each app individually"
        echo "  coverage      - Run tests with coverage report"
        echo "  dpto          - Run tests for dpto app only"
        echo "  gbif          - Run tests for gbif app only"
        echo "  mupio         - Run tests for mupio app only"
        echo "  mupiopolitico - Run tests for mupiopolitico app only"
        echo "  setup         - Setup test environment only"
        echo "  shell         - Open Django shell in container"
        echo "  help          - Show this help message"
        echo ""
        echo "Prerequisites:"
        echo "  - Docker container '$CONTAINER_NAME' must be running"
        echo "  - Start with: docker-compose up -d backend"
        echo ""
        echo "If no command is provided, all tests will be run."
        ;;
    *)
        # Default: run all tests
        setup_test_env
        run_all_tests
        ;;
esac

echo ""
echo "==========================================="
echo "Docker test run completed!"
echo "==========================================="