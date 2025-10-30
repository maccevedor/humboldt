# Visor-I2D: Unified Docker Setup
## Complete Development Environment with Frontend, Backend, and Database

This repository provides a unified Docker Compose setup for the complete Visor-I2D geographic information system, including both frontend and backend components with PostgreSQL database.

---

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Nginx Proxy   │    │    Frontend     │    │    Backend      │
│   (Port 80)     │◄──►│   (Node.js)     │◄──►│   (Django)      │
│                 │    │   (Port 8080)   │    │   (Port 8001)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                                              │
         │              ┌─────────────────┐             │
         └─────────────►│   PostgreSQL    │◄────────────┘
                        │   (Port 5432)   │
                        └─────────────────┘
                                 │
                        ┌─────────────────┐
                        │     Redis       │
                        │   (Port 6379)   │
                        └─────────────────┘
```

## 📋 Prerequisites

### Required Software
- **Docker** (version 20.0+)
- **Docker Compose** (version 2.0+)
- **Git** (version 2.20+)
- **Bash** (for setup scripts)

### System Requirements
- **RAM**: Minimum 4GB, Recommended 8GB
- **Storage**: Minimum 10GB free space
- **OS**: Linux, macOS, or Windows with WSL2

### Verify Prerequisites
```bash
# Check Docker
docker --version
docker-compose --version

# Check Git
git --version

# Check available memory
free -h  # Linux
# or
system_profiler SPHardwareDataType | grep Memory  # macOS
```

---

## 🚀 Quick Start

### 1. Clone the Repository with Submodules
```bash
# Clone the main repository
git clone https://github.com/PEM-Humboldt/visor-geografico-I2D-unified.git
cd visor-geografico-I2D-unified

# Initialize and update submodules
git submodule init
git submodule update --recursive --remote

# Or clone with submodules in one command
git clone --recurse-submodules https://github.com/PEM-Humboldt/visor-geografico-I2D-unified.git
```

### 2. Environment Setup
```bash
# Make scripts executable
chmod +x scripts/db-setup.sh
chmod +x scripts/start.sh
chmod +x scripts/stop.sh

# Create necessary directories
mkdir -p backups
mkdir -p logs
```

### 3. Start the Complete Stack
```bash
# Start all services
docker-compose up -d

# Wait for services to be ready (this may take a few minutes)
docker-compose logs -f

# Setup database and run migrations
./scripts/db-setup.sh setup
```

### 4. Verify Installation
```bash
# Check service status
docker-compose ps

# Check application health
curl http://localhost/health
curl http://localhost:8001/admin/
curl http://localhost:8080/
```

---

## 📁 Project Structure

```
visor-geografico-I2D-unified/
├── docker-compose.yml              # Main orchestration file
├── .gitmodules                     # Git submodules configuration
├── README.md                       # This file
├── LEARNING_PLAN.md               # Technology learning guide
├── UPGRADE_STRATEGY.md            # Modernization planning
├──
├── scripts/                       # Setup and management scripts
│   ├── db-setup.sh               # Database management script
│   ├── init-db.sql               # Database initialization
│   ├── start.sh                  # Start services script
│   └── stop.sh                   # Stop services script
├──
├── nginx/                        # Nginx configuration
│   ├── nginx.conf               # Main Nginx config
│   └── default.conf             # Server configuration
├──
├── backups/                      # Database backups
├── logs/                         # Application logs
├──
├── visor-geografico-I2D/         # Frontend submodule
│   ├── src/                     # Frontend source code
│   ├── package.json             # Node.js dependencies
│   ├── Dockerfile               # Frontend container config
│   └── ...
└──
└── visor-geografico-I2D-backend/ # Backend submodule
    ├── applications/            # Django applications
    ├── i2dbackend/             # Django project settings
    ├── requirements.txt        # Python dependencies
    ├── Dockerfile              # Backend container config
    └── ...
```

---

## 🛠️ Detailed Setup Instructions

### Step 1: Initial Setup

#### 1.1 Clone with Submodules
```bash
# Method 1: Clone then initialize submodules
git clone https://github.com/PEM-Humboldt/visor-geografico-I2D-unified.git
cd visor-geografico-I2D-unified
git submodule init
git submodule update --recursive

# Method 2: Clone with submodules (recommended)
git clone --recurse-submodules https://github.com/PEM-Humboldt/visor-geografico-I2D-unified.git
cd visor-geografico-I2D-unified
```

#### 1.2 Environment Configuration
```bash
# Copy environment template (if exists)
cp .env.example .env

# Edit environment variables
nano .env  # or your preferred editor
```

### Step 2: Docker Services

#### 2.1 Build and Start Services
```bash
# Build all images
docker-compose build

# Start services in detached mode
docker-compose up -d

# View logs
docker-compose logs -f
```

#### 2.2 Service Health Checks
```bash
# Check all services status
docker-compose ps

# Check individual service logs
docker-compose logs db
docker-compose logs backend
docker-compose logs frontend
docker-compose logs nginx
```

### Step 3: Database Setup

#### 3.1 Automatic Setup (Recommended)
```bash
# Complete database setup
./scripts/db-setup.sh setup
```

#### 3.2 Manual Setup
```bash
# Wait for database to be ready
./scripts/db-setup.sh status

# Run migrations
./scripts/db-setup.sh migrate

# Create superuser
./scripts/db-setup.sh superuser

# Load sample data (if available)
./scripts/db-setup.sh load-data
```

### Step 4: Verification

#### 4.1 Service Endpoints
- **Frontend**: http://localhost (port 80)
- **Backend API**: http://localhost:8001
- **Django Admin**: http://localhost/admin/
- **Database**: localhost:5432
- **Redis**: localhost:6379

#### 4.2 Health Checks
```bash
# Nginx health check
curl http://localhost/health

# Backend health check
curl http://localhost:8001/admin/

# Frontend check
curl http://localhost:8080/

# Database check
docker exec visor_i2d_db pg_isready -U i2d_user -d i2d_db
```

---

## 🔧 Management Scripts

### Database Management Script
```bash
# Complete setup
./scripts/db-setup.sh setup

# Run migrations only
./scripts/db-setup.sh migrate

# Create superuser
./scripts/db-setup.sh superuser

# Create backup
./scripts/db-setup.sh backup

# Restore from backup
./scripts/db-setup.sh restore ./backups/backup_20240121_143022.sql

# Show database status
./scripts/db-setup.sh status

# Reset database (WARNING: destructive)
./scripts/db-setup.sh reset
```

### Service Management
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# Restart specific service
docker-compose restart backend

# View logs
docker-compose logs -f backend

# Scale services (if needed)
docker-compose up -d --scale backend=2
```

---

## 🌐 Access Points

### Web Interfaces
- **Main Application**: http://localhost
- **Django Admin**: http://localhost/admin/
  - Username: `admin`
  - Password: `admin123`
- **Frontend Direct**: http://localhost:8080
- **Backend Direct**: http://localhost:8001

### API Endpoints
- **API Base**: http://localhost/api/
- **Health Check**: http://localhost/health
- **Static Files**: http://localhost/static/
- **Media Files**: http://localhost/media/

### Database Access
```bash
# Connect to PostgreSQL
docker exec -it visor_i2d_db psql -U i2d_user -d i2d_db

# Or using external client
psql -h localhost -p 5432 -U i2d_user -d i2d_db
```

---

## 🔍 Development Workflow

### Frontend Development
```bash
# Enter frontend container
docker exec -it visor_i2d_frontend bash

# Install new dependencies
docker exec -it visor_i2d_frontend npm install package-name

# Run development server
docker exec -it visor_i2d_frontend npm start

# Build for production
docker exec -it visor_i2d_frontend npm run build
```

### Backend Development
```bash
# Enter backend container
docker exec -it visor_i2d_backend bash

# Install new Python packages
docker exec -it visor_i2d_backend pip install package-name

# Run Django commands
docker exec -it visor_i2d_backend python manage.py shell
docker exec -it visor_i2d_backend python manage.py createsuperuser
docker exec -it visor_i2d_backend python manage.py collectstatic
```

### Code Changes
```bash
# Update submodules to latest
git submodule update --remote --merge

# Rebuild after code changes
docker-compose build backend
docker-compose up -d backend

# Or rebuild all
docker-compose build
docker-compose up -d
```

---

## 🐛 Troubleshooting

### Common Issues

#### 1. Services Won't Start
```bash
# Check Docker daemon
sudo systemctl status docker

# Check ports availability
netstat -tlnp | grep :80
netstat -tlnp | grep :5432

# Check logs
docker-compose logs
```

#### 2. Database Connection Issues
```bash
# Check database status
./scripts/db-setup.sh status

# Restart database
docker-compose restart db

# Check database logs
docker-compose logs db
```

#### 3. Permission Issues
```bash
# Fix script permissions
chmod +x scripts/*.sh

# Fix volume permissions
sudo chown -R $USER:$USER ./backups
sudo chown -R $USER:$USER ./logs
```

#### 4. Port Conflicts
```bash
# Check what's using ports
sudo lsof -i :80
sudo lsof -i :5432

# Stop conflicting services
sudo systemctl stop apache2  # if Apache is running
sudo systemctl stop postgresql  # if local PostgreSQL is running
```

### Service-Specific Issues

#### Frontend Issues
```bash
# Rebuild frontend
docker-compose build frontend
docker-compose up -d frontend

# Check frontend logs
docker-compose logs frontend

# Access frontend container
docker exec -it visor_i2d_frontend bash
```

#### Backend Issues
```bash
# Check Django settings
docker exec -it visor_i2d_backend python manage.py check

# Run migrations
./scripts/db-setup.sh migrate

# Check backend logs
docker-compose logs backend
```

#### Database Issues
```bash
# Reset database
./scripts/db-setup.sh reset

# Check PostgreSQL logs
docker-compose logs db

# Manual database access
docker exec -it visor_i2d_db psql -U i2d_user -d i2d_db
```

---

## 📊 Monitoring and Logs

### Log Locations
```bash
# Docker Compose logs
docker-compose logs

# Individual service logs
docker-compose logs backend
docker-compose logs frontend
docker-compose logs db
docker-compose logs nginx

# Follow logs in real-time
docker-compose logs -f --tail=100
```

### Performance Monitoring
```bash
# Check resource usage
docker stats

# Check disk usage
docker system df

# Clean up unused resources
docker system prune
```

---

## 🔒 Security Considerations

### Production Deployment
1. **Change default passwords**
2. **Use environment variables for secrets**
3. **Enable HTTPS with SSL certificates**
4. **Configure firewall rules**
5. **Regular security updates**

### Environment Variables
```bash
# Create .env file with:
SECRET_KEY=your-very-secure-secret-key
DB_PASSWORD=your-secure-database-password
ALLOWED_HOSTS=your-domain.com,localhost
DEBUG=False
```

---

## 🚀 Production Deployment

### Preparation
```bash
# Set production environment
export DJANGO_ENV=production

# Update environment variables
nano .env

# Build production images
docker-compose -f docker-compose.prod.yml build
```

### SSL/HTTPS Setup
```bash
# Add SSL certificates to nginx/ssl/
# Update nginx configuration for HTTPS
# Restart nginx service
docker-compose restart nginx
```

---

## 📚 Additional Resources

### Documentation
- [Django Documentation](https://docs.djangoproject.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Nginx Documentation](https://nginx.org/en/docs/)

### Learning Resources
- See `LEARNING_PLAN.md` for comprehensive technology learning guide
- See `UPGRADE_STRATEGY.md` for modernization planning

### Support
- GitHub Issues: [Project Issues](https://github.com/PEM-Humboldt/visor-geografico-I2D/issues)
- Instituto Humboldt: [Contact Information](http://www.humboldt.org.co)

---

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Clone with submodules
3. Create feature branch
4. Make changes
5. Test thoroughly
6. Submit pull request

### Code Standards
- Follow PEP 8 for Python code
- Use ESLint for JavaScript code
- Write comprehensive tests
- Update documentation

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

---

## 👥 Authors and Contributors

* **Julián David Torres Caicedo** - *Frontend Development* - [juliant8805](https://github.com/juliant8805)
* **Liceth Barandica Diaz** - *Frontend Development* - [licethbarandicadiaz](https://github.com/licethbarandicadiaz)
* **Daniel López** - *DevOps and Deployment* - [danflop](https://github.com/danflop)

**Ingeniería de Datos y Desarrollo**
**Programa de Evaluación y Monitoreo de la Biodiversidad**
**Instituto Alexander von Humboldt Colombia**

---

## 🆘 Quick Help

### Emergency Commands
```bash
# Stop everything
docker-compose down

# Nuclear option - remove everything
docker-compose down -v --remove-orphans
docker system prune -a

# Start fresh
git submodule update --init --recursive
docker-compose up -d
./scripts/db-setup.sh setup
```

### Status Check
```bash
# Quick health check
curl http://localhost/health && echo "✅ Nginx OK"
curl http://localhost:8001/admin/ && echo "✅ Backend OK"
curl http://localhost:8080/ && echo "✅ Frontend OK"
./scripts/db-setup.sh status
```

---

**¡Happy coding! 🌱**
