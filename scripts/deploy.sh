#!/bin/bash

# Production deployment script for Visor I2D
# Usage: ./deploy.sh [environment] [version]

set -e

# Configuration
ENVIRONMENT=${1:-production}
VERSION=${2:-latest}
PROJECT_NAME="visor-i2d"
BACKUP_DIR="/backups"
LOG_FILE="/var/log/deploy.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a $LOG_FILE
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}" | tee -a $LOG_FILE
    exit 1
}

warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}" | tee -a $LOG_FILE
}

# Pre-deployment checks
pre_deployment_checks() {
    log "Running pre-deployment checks..."
    
    # Check if Docker is running
    if ! docker info > /dev/null 2>&1; then
        error "Docker is not running"
    fi
    
    # Check if docker-compose is available
    if ! command -v docker-compose &> /dev/null; then
        error "docker-compose is not installed"
    fi
    
    # Check disk space
    AVAILABLE_SPACE=$(df / | awk 'NR==2 {print $4}')
    if [ $AVAILABLE_SPACE -lt 1048576 ]; then  # Less than 1GB
        error "Insufficient disk space (less than 1GB available)"
    fi
    
    # Check if required files exist
    if [ ! -f "docker-compose.yml" ]; then
        error "docker-compose.yml not found"
    fi
    
    if [ ! -f "visor-geografico-I2D-backend/.env" ]; then
        error "Backend .env file not found"
    fi
    
    log "Pre-deployment checks passed"
}

# Create backup
create_backup() {
    log "Creating backup..."
    
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_NAME="${PROJECT_NAME}_backup_${TIMESTAMP}"
    
    # Create backup directory
    mkdir -p $BACKUP_DIR
    
    # Backup database
    log "Backing up database..."
    docker-compose exec -T db pg_dump -U i2d_user i2d_db > "$BACKUP_DIR/${BACKUP_NAME}_db.sql"
    
    # Backup volumes
    log "Backing up volumes..."
    docker run --rm -v $(pwd):/backup -v visor_postgres_data_restore:/data alpine tar czf /backup/$BACKUP_DIR/${BACKUP_NAME}_volumes.tar.gz -C /data .
    
    # Backup configuration
    log "Backing up configuration..."
    tar czf "$BACKUP_DIR/${BACKUP_NAME}_config.tar.gz" \
        docker-compose.yml \
        visor-geografico-I2D-backend/.env \
        visor-geografico-I2D-backend/secret.json \
        nginx/
    
    log "Backup created: $BACKUP_NAME"
    echo $BACKUP_NAME > /tmp/last_backup_name
}

# Health check function
health_check() {
    local service=$1
    local url=$2
    local max_attempts=30
    local attempt=1
    
    log "Checking health of $service..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f -s $url > /dev/null; then
            log "$service is healthy"
            return 0
        fi
        
        log "Attempt $attempt/$max_attempts: $service not ready yet..."
        sleep 10
        attempt=$((attempt + 1))
    done
    
    error "$service failed health check after $max_attempts attempts"
}

# Deploy services
deploy_services() {
    log "Deploying services..."
    
    # Pull latest images
    log "Pulling latest images..."
    docker-compose pull
    
    # Build custom images
    log "Building custom images..."
    docker-compose build --no-cache
    
    # Start services with zero-downtime deployment
    log "Starting services..."
    
    # Start database first
    docker-compose up -d db redis
    sleep 30
    
    # Wait for database to be ready
    health_check "Database" "http://localhost:5432"
    
    # Start backend
    docker-compose up -d backend
    sleep 30
    
    # Wait for backend to be ready
    health_check "Backend" "http://localhost:8001/health/simple/"
    
    # Start frontend and other services
    docker-compose up -d frontend nginx geoserver
    
    # Final health checks
    health_check "Frontend" "http://localhost:8080"
    health_check "Nginx" "http://localhost:80/health"
    health_check "GeoServer" "http://localhost:8081"
    
    log "All services deployed successfully"
}

# Run database migrations
run_migrations() {
    log "Running database migrations..."
    docker-compose exec backend python manage.py migrate --noinput
    log "Migrations completed"
}

# Update static files
update_static_files() {
    log "Updating static files..."
    docker-compose exec backend python manage.py collectstatic --noinput
    log "Static files updated"
}

# Post-deployment verification
post_deployment_verification() {
    log "Running post-deployment verification..."
    
    # Test API endpoints
    log "Testing API endpoints..."
    
    endpoints=(
        "http://localhost:8001/health/"
        "http://localhost:8001/api/docs/"
        "http://localhost:8001/dpto/"
        "http://localhost:8001/mpio/"
    )
    
    for endpoint in "${endpoints[@]}"; do
        if curl -f -s "$endpoint" > /dev/null; then
            log "✓ $endpoint is accessible"
        else
            warning "✗ $endpoint is not accessible"
        fi
    done
    
    # Check container status
    log "Checking container status..."
    docker-compose ps
    
    # Check logs for errors
    log "Checking for errors in logs..."
    if docker-compose logs --tail=50 backend | grep -i error; then
        warning "Errors found in backend logs"
    fi
    
    log "Post-deployment verification completed"
}

# Cleanup old images and containers
cleanup() {
    log "Cleaning up old images and containers..."
    
    # Remove unused images
    docker image prune -f
    
    # Remove unused containers
    docker container prune -f
    
    # Remove unused volumes (be careful with this)
    # docker volume prune -f
    
    log "Cleanup completed"
}

# Rollback function
rollback() {
    log "Rolling back deployment..."
    
    if [ -f "/tmp/last_backup_name" ]; then
        BACKUP_NAME=$(cat /tmp/last_backup_name)
        log "Rolling back to backup: $BACKUP_NAME"
        
        # Stop services
        docker-compose down
        
        # Restore database
        if [ -f "$BACKUP_DIR/${BACKUP_NAME}_db.sql" ]; then
            log "Restoring database..."
            docker-compose up -d db
            sleep 30
            docker-compose exec -T db psql -U i2d_user -d i2d_db < "$BACKUP_DIR/${BACKUP_NAME}_db.sql"
        fi
        
        # Restore configuration
        if [ -f "$BACKUP_DIR/${BACKUP_NAME}_config.tar.gz" ]; then
            log "Restoring configuration..."
            tar xzf "$BACKUP_DIR/${BACKUP_NAME}_config.tar.gz"
        fi
        
        # Restart services
        docker-compose up -d
        
        log "Rollback completed"
    else
        error "No backup found for rollback"
    fi
}

# Main deployment function
main() {
    log "Starting deployment for environment: $ENVIRONMENT, version: $VERSION"
    
    case "$1" in
        "rollback")
            rollback
            ;;
        *)
            pre_deployment_checks
            create_backup
            deploy_services
            run_migrations
            update_static_files
            post_deployment_verification
            cleanup
            log "Deployment completed successfully!"
            ;;
    esac
}

# Handle script arguments
if [ "$1" = "rollback" ]; then
    main rollback
else
    main $ENVIRONMENT $VERSION
fi
