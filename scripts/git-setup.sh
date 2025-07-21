#!/bin/bash

# Visor-I2D Git Repository Setup Script
# This script helps set up the unified repository with proper Git submodules

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if we're in a Git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a Git repository. Please run 'git init' first."
        exit 1
    fi
    log_success "Git repository detected"
}

# Remove existing submodule directories if they exist
cleanup_existing_dirs() {
    log_info "Cleaning up existing project directories..."

    if [ -d "visor-geografico-I2D" ]; then
        log_warning "Removing existing visor-geografico-I2D directory"
        rm -rf visor-geografico-I2D
    fi

    if [ -d "visor-geografico-I2D-backend" ]; then
        log_warning "Removing existing visor-geografico-I2D-backend directory"
        rm -rf visor-geografico-I2D-backend
    fi

    log_success "Cleanup completed"
}

# Add Git submodules
add_submodules() {
    log_info "Adding Git submodules..."

    # Add frontend submodule
    log_info "Adding frontend submodule..."
    if git submodule add https://github.com/PEM-Humboldt/visor-geografico-I2D.git visor-geografico-I2D; then
        log_success "Frontend submodule added"
    else
        log_warning "Frontend submodule might already exist"
    fi

    # Add backend submodule
    log_info "Adding backend submodule..."
    if git submodule add https://github.com/PEM-Humboldt/visor-geografico-I2D-backend.git visor-geografico-I2D-backend; then
        log_success "Backend submodule added"
    else
        log_warning "Backend submodule might already exist"
    fi

    # Initialize and update submodules
    log_info "Initializing and updating submodules..."
    git submodule init
    git submodule update --recursive --remote

    log_success "Submodules setup completed"
}

# Create necessary directories
create_directories() {
    log_info "Creating necessary directories..."

    mkdir -p backups
    mkdir -p logs
    mkdir -p nginx/ssl

    log_success "Directories created"
}

# Set up initial Git configuration
setup_git_config() {
    log_info "Setting up Git configuration..."

    # Add .gitignore if it doesn't exist
    if [ ! -f ".gitignore" ]; then
        log_warning ".gitignore not found. Please create it first."
    else
        log_success ".gitignore found"
    fi

    # Configure submodule update strategy
    git config submodule.recurse true
    git config diff.submodule log
    git config status.submodulesummary 1

    log_success "Git configuration completed"
}

# Fix file permissions
fix_permissions() {
    log_info "Setting correct file permissions..."

    # Make scripts executable
    chmod +x scripts/*.sh

    # Set proper permissions for directories
    chmod 755 nginx/
    chmod 755 scripts/
    chmod 755 backups/
    chmod 755 logs/

    log_success "Permissions set correctly"
}

# Verify setup
verify_setup() {
    log_info "Verifying setup..."

    # Check submodules
    if [ -d "visor-geografico-I2D/.git" ] || [ -f "visor-geografico-I2D/.git" ]; then
        log_success "Frontend submodule: OK"
    else
        log_error "Frontend submodule: FAILED"
        return 1
    fi

    if [ -d "visor-geografico-I2D-backend/.git" ] || [ -f "visor-geografico-I2D-backend/.git" ]; then
        log_success "Backend submodule: OK"
    else
        log_error "Backend submodule: FAILED"
        return 1
    fi

    # Check required files
    local required_files=(
        "docker-compose.yml"
        ".gitmodules"
        ".gitignore"
        "scripts/db-setup.sh"
        "nginx/nginx.conf"
        "nginx/default.conf"
    )

    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            log_success "Required file: $file - OK"
        else
            log_error "Required file: $file - MISSING"
            return 1
        fi
    done

    log_success "Setup verification completed successfully!"
}

# Show status
show_status() {
    log_info "Repository Status:"
    echo "==================="

    # Git status
    echo -e "${BLUE}Git Status:${NC}"
    git status --short
    echo

    # Submodules status
    echo -e "${BLUE}Submodules Status:${NC}"
    git submodule status
    echo

    # Directory structure
    echo -e "${BLUE}Directory Structure:${NC}"
    tree -L 2 -a || ls -la
}

# Update submodules
update_submodules() {
    log_info "Updating submodules to latest versions..."

    git submodule update --remote --merge

    log_success "Submodules updated"
}

# Main script logic
main() {
    case "$1" in
        "init")
            log_info "Initializing Visor-I2D unified repository..."
            check_git_repo
            cleanup_existing_dirs
            add_submodules
            create_directories
            setup_git_config
            fix_permissions
            verify_setup
            log_success "Repository initialization completed!"
            echo
            log_info "Next steps:"
            echo "1. Review and commit the changes: git add . && git commit -m 'Initial unified repository setup'"
            echo "2. Start the development environment: docker-compose up -d"
            echo "3. Setup the database: ./scripts/db-setup.sh setup"
            ;;
        "update")
            log_info "Updating submodules..."
            check_git_repo
            update_submodules
            ;;
        "status")
            show_status
            ;;
        "verify")
            verify_setup
            ;;
        "permissions")
            fix_permissions
            ;;
        "clean")
            log_warning "This will remove submodule directories and reset them!"
            read -p "Are you sure you want to continue? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                cleanup_existing_dirs
                log_info "Run '$0 init' to reinitialize submodules"
            else
                log_info "Clean operation cancelled"
            fi
            ;;
        *)
            echo "Visor-I2D Git Repository Setup Script"
            echo "Usage: $0 {init|update|status|verify|permissions|clean}"
            echo ""
            echo "Commands:"
            echo "  init        - Initialize repository with submodules and directory structure"
            echo "  update      - Update submodules to latest versions"
            echo "  status      - Show repository and submodules status"
            echo "  verify      - Verify that setup is correct"
            echo "  permissions - Fix file and directory permissions"
            echo "  clean       - Remove submodule directories (WARNING: destructive)"
            echo ""
            echo "Examples:"
            echo "  $0 init     # First time setup"
            echo "  $0 update   # Update submodules"
            echo "  $0 status   # Check current status"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
