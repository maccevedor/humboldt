#!/bin/bash

# Visor-I2D Database Setup and Migration Script
# This script handles database initialization and Django migrations

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DB_CONTAINER="visor_i2d_db"
BACKEND_CONTAINER="visor_i2d_backend"
DB_NAME="i2d_db"
DB_USER="i2d_user"
DB_PASSWORD="i2d_password"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
check_docker() {
    log_info "Checking Docker status..."
    if ! docker info > /dev/null 2>&1; then
        log_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    log_success "Docker is running"
}

# Wait for database to be ready
wait_for_db() {
    log_info "Waiting for PostgreSQL database to be ready..."
    local max_attempts=30
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if docker exec $DB_CONTAINER pg_isready -U $DB_USER -d $DB_NAME > /dev/null 2>&1; then
            log_success "Database is ready!"
            return 0
        fi

        log_info "Attempt $attempt/$max_attempts: Database not ready yet, waiting..."
        sleep 2
        ((attempt++))
    done

    log_error "Database failed to become ready after $max_attempts attempts"
    return 1
}

# Create Django superuser
create_superuser() {
    log_info "Creating Django superuser..."

    # Check if superuser already exists
    if docker exec $BACKEND_CONTAINER python manage.py shell -c "
from django.contrib.auth import get_user_model;
User = get_user_model();
print('exists' if User.objects.filter(username='admin').exists() else 'not_exists')
" | grep -q "exists"; then
        log_warning "Superuser 'admin' already exists"
        return 0
    fi

    # Create superuser
    docker exec $BACKEND_CONTAINER python manage.py shell -c "
from django.contrib.auth import get_user_model;
User = get_user_model();
User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
"
    log_success "Superuser 'admin' created with password 'admin123'"
}

# Load sample data (if exists)
load_sample_data() {
    log_info "Loading sample data..."

    # Check if fixtures directory exists
    if [ -d "./visor-geografico-I2D-backend/fixtures" ]; then
        for fixture in ./visor-geografico-I2D-backend/fixtures/*.json; do
            if [ -f "$fixture" ]; then
                log_info "Loading fixture: $(basename $fixture)"
                docker exec $BACKEND_CONTAINER python manage.py loaddata "fixtures/$(basename $fixture)"
            fi
        done
        log_success "Sample data loaded"
    else
        log_warning "No fixtures directory found, skipping sample data"
    fi
}

# Run Django migrations
run_migrations() {
    log_info "Running Django migrations..."

    # Make migrations
    log_info "Creating new migrations..."
    docker exec $BACKEND_CONTAINER python manage.py makemigrations

    # Apply migrations
    log_info "Applying migrations..."
    docker exec $BACKEND_CONTAINER python manage.py migrate

    log_success "Migrations completed"
}

# Collect static files
collect_static() {
    log_info "Collecting static files..."
    docker exec $BACKEND_CONTAINER python manage.py collectstatic --noinput
    log_success "Static files collected"
}

# Database backup
backup_database() {
    log_info "Creating database backup..."
    local backup_file="backup_$(date +%Y%m%d_%H%M%S).sql"

    docker exec $DB_CONTAINER pg_dump -U $DB_USER $DB_NAME > "./backups/$backup_file"
    log_success "Database backup created: ./backups/$backup_file"
}

# Database restore
restore_database() {
    local backup_file=$1

    if [ -z "$backup_file" ]; then
        log_error "Please provide backup file path"
        exit 1
    fi

    if [ ! -f "$backup_file" ]; then
        log_error "Backup file not found: $backup_file"
        exit 1
    fi

    log_info "Restoring database from: $backup_file"
    log_warning "This will overwrite the current database!"

    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Database restore cancelled"
        exit 0
    fi

    # Drop and recreate database
    docker exec $DB_CONTAINER psql -U $DB_USER -c "DROP DATABASE IF EXISTS $DB_NAME;"
    docker exec $DB_CONTAINER psql -U $DB_USER -c "CREATE DATABASE $DB_NAME;"

    # Restore from backup
    docker exec -i $DB_CONTAINER psql -U $DB_USER $DB_NAME < "$backup_file"
    log_success "Database restored successfully"
}

# Show database status
show_status() {
    log_info "Database Status:"
    echo "=================="

    # Database connection
    if docker exec $DB_CONTAINER pg_isready -U $DB_USER -d $DB_NAME > /dev/null 2>&1; then
        log_success "Database: Connected"
    else
        log_error "Database: Not connected"
    fi

    # Tables count
    local table_count=$(docker exec $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | tr -d ' ')
    echo -e "${BLUE}Tables:${NC} $table_count"

    # Database size
    local db_size=$(docker exec $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -t -c "SELECT pg_size_pretty(pg_database_size('$DB_NAME'));" | tr -d ' ')
    echo -e "${BLUE}Size:${NC} $db_size"

    # Last migration
    if docker exec $BACKEND_CONTAINER python manage.py showmigrations --plan | tail -1 > /dev/null 2>&1; then
        local last_migration=$(docker exec $BACKEND_CONTAINER python manage.py showmigrations --plan | tail -1)
        echo -e "${BLUE}Last Migration:${NC} $last_migration"
    fi
}

# Main script logic
main() {
    case "$1" in
        "setup")
            log_info "Starting complete database setup..."
            check_docker
            wait_for_db
            run_migrations
            collect_static
            create_superuser
            load_sample_data
            log_success "Database setup completed!"
            ;;
        "migrate")
            log_info "Running migrations only..."
            check_docker
            wait_for_db
            run_migrations
            ;;
        "superuser")
            log_info "Creating superuser..."
            check_docker
            create_superuser
            ;;
        "backup")
            mkdir -p ./backups
            backup_database
            ;;
        "restore")
            restore_database "$2"
            ;;
        "status")
            show_status
            ;;
        "reset")
            log_warning "This will completely reset the database!"
            read -p "Are you sure you want to continue? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                log_info "Resetting database..."
                docker-compose down -v
                docker-compose up -d db
                wait_for_db
                run_migrations
                create_superuser
                log_success "Database reset completed!"
            else
                log_info "Database reset cancelled"
            fi
            ;;
        *)
            echo "Visor-I2D Database Management Script"
            echo "Usage: $0 {setup|migrate|superuser|backup|restore|status|reset}"
            echo ""
            echo "Commands:"
            echo "  setup     - Complete database setup (migrations, superuser, sample data)"
            echo "  migrate   - Run Django migrations only"
            echo "  superuser - Create Django superuser"
            echo "  backup    - Create database backup"
            echo "  restore   - Restore database from backup file"
            echo "  status    - Show database status"
            echo "  reset     - Reset database completely (WARNING: destructive)"
            echo ""
            echo "Examples:"
            echo "  $0 setup"
            echo "  $0 migrate"
            echo "  $0 backup"
            echo "  $0 restore ./backups/backup_20240120_143022.sql"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
