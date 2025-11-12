#!/bin/bash

# Database Performance Optimization Wrapper Script
# Visor I2D Humboldt Project

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
DB_CONTAINER="visor_i2d_db"
DB_NAME="i2d_db"
DB_USER="i2d_user"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}Database Performance Optimization${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# Check if container is running
if ! docker ps --format "{{.Names}}" | grep -q "^${DB_CONTAINER}$"; then
    echo -e "${YELLOW}Warning: Container ${DB_CONTAINER} not found${NC}"
    echo "Available containers:"
    docker ps --format "table {{.Names}}\t{{.Status}}"
    echo ""
    read -p "Enter container name: " DB_CONTAINER
fi

echo -e "${GREEN}✓${NC} Using container: ${DB_CONTAINER}"
echo ""

# Run optimization
echo "Running optimization script..."
echo ""

docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" < "$SCRIPT_DIR/optimize_database.sql"

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Optimization Complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Test query performance with your application"
echo "2. Monitor slow queries with: docker exec $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -c \"SELECT * FROM pg_stat_statements ORDER BY total_exec_time DESC LIMIT 10;\""
echo "3. Schedule weekly VACUUM ANALYZE"
echo ""
