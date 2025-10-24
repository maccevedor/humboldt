#!/bin/bash

# UAT Deployment Script for Visor I2D Humboldt
# This script handles the deployment process for the UAT environment

set -e  # Exit on error

echo "=========================================="
echo "Visor I2D Humboldt - UAT Deployment"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found!${NC}"
    echo "Please copy .env.uat to .env and configure it:"
    echo "  cp .env.uat .env"
    echo "  nano .env"
    exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running!${NC}"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check required commands
if ! command_exists docker-compose && ! command_exists docker; then
    echo -e "${RED}Error: docker-compose or docker is not installed!${NC}"
    exit 1
fi

# Determine docker compose command
if command_exists docker-compose; then
    DOCKER_COMPOSE="docker-compose"
else
    DOCKER_COMPOSE="docker compose"
fi

echo -e "${YELLOW}Step 1: Stopping existing containers...${NC}"
$DOCKER_COMPOSE -f docker-compose.uat.yml down

echo -e "${YELLOW}Step 2: Pulling latest images...${NC}"
$DOCKER_COMPOSE -f docker-compose.uat.yml pull

echo -e "${YELLOW}Step 3: Building services...${NC}"
$DOCKER_COMPOSE -f docker-compose.uat.yml build --no-cache

echo -e "${YELLOW}Step 4: Starting services...${NC}"
$DOCKER_COMPOSE -f docker-compose.uat.yml up -d

echo -e "${YELLOW}Step 5: Waiting for services to be healthy...${NC}"
sleep 10

# Check service health
echo -e "${YELLOW}Checking service status...${NC}"
$DOCKER_COMPOSE -f docker-compose.uat.yml ps

# Wait for database to be ready
echo -e "${YELLOW}Waiting for database to be ready...${NC}"
timeout=60
counter=0
until $DOCKER_COMPOSE -f docker-compose.uat.yml exec -T db pg_isready -U i2d_user -d i2d_db > /dev/null 2>&1; do
    counter=$((counter + 1))
    if [ $counter -gt $timeout ]; then
        echo -e "${RED}Error: Database failed to start within $timeout seconds${NC}"
        exit 1
    fi
    echo "Waiting for database... ($counter/$timeout)"
    sleep 1
done

echo -e "${GREEN}Database is ready!${NC}"

# Run migrations
echo -e "${YELLOW}Step 6: Running database migrations...${NC}"
$DOCKER_COMPOSE -f docker-compose.uat.yml exec -T backend python manage.py migrate

# Collect static files
echo -e "${YELLOW}Step 7: Collecting static files...${NC}"
$DOCKER_COMPOSE -f docker-compose.uat.yml exec -T backend python manage.py collectstatic --noinput

# Create superuser if needed (optional)
# echo -e "${YELLOW}Step 8: Creating superuser (if needed)...${NC}"
# $DOCKER_COMPOSE -f docker-compose.uat.yml exec -T backend python manage.py createsuperuser --noinput || true

echo ""
echo -e "${GREEN}=========================================="
echo "Deployment completed successfully!"
echo "==========================================${NC}"
echo ""
echo "Services are running:"
echo "  - Frontend: http://localhost:8080"
echo "  - Backend API: http://localhost:8001"
echo "  - GeoServer: http://localhost:8081/geoserver"
echo "  - Nginx Proxy: http://localhost"
echo ""
echo "To view logs:"
echo "  $DOCKER_COMPOSE -f docker-compose.uat.yml logs -f"
echo ""
echo "To stop services:"
echo "  $DOCKER_COMPOSE -f docker-compose.uat.yml down"
echo ""
