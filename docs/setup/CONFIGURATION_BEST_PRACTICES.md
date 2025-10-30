# Configuration Management Best Practices

## Executive Summary

Your project currently has **configuration sprawl** across 5+ locations. This document provides a migration path to industry-standard **12-Factor App** configuration management.

---

## Current Problems

### 1. **Multiple Configuration Sources**
- ❌ `.env` files (backend + frontend)
- ❌ `secret.json` (duplicates .env data)
- ❌ Django settings files (base.py, local.py, prod.py)
- ❌ `docker-compose.yml` (hardcoded values)
- ❌ `.env.uat` (separate UAT config)

### 2. **Issues This Causes**
- **Confusion:** Which file takes precedence?
- **Security risks:** Secrets in multiple places
- **Maintenance burden:** Update same value in 3+ places
- **Docker conflicts:** env_file vs environment variables
- **Deployment errors:** Missing variables cause runtime failures

---

## Recommended Solution: 12-Factor App

### **Configuration Hierarchy (Priority Order)**

```
1. Environment Variables (OS level)          [HIGHEST PRIORITY]
   ↓
2. Docker Compose environment section
   ↓
3. .env files (via env_file in docker-compose)
   ↓
4. Django settings defaults                   [LOWEST PRIORITY]
```

---

## Best Practice Structure

### **Directory Layout**

```
/humboldt/
├── .env.example              # Template (COMMITTED to git)
├── .env                      # Local dev (GITIGNORED)
├── .env.uat                  # UAT environment (GITIGNORED)
├── .env.production           # Production (GITIGNORED)
├── docker-compose.yml        # References .env via env_file
├── docker-compose.uat.yml    # References .env.uat
└── visor-geografico-I2D-backend/
    ├── .env.example          # Backend-specific template
    ├── .env                  # Backend local (GITIGNORED)
    └── i2dbackend/settings/
        ├── base.py           # Reads from os.environ only
        ├── local.py          # Minimal overrides
        └── prod.py           # Minimal overrides
```

---

## Migration Steps

### **Step 1: Consolidate to .env Files**

#### **Backend `.env` (Complete Example)**

```bash
# =============================================================================
# VISOR I2D BACKEND CONFIGURATION
# =============================================================================

# -----------------------------------------------------------------------------
# Django Core Settings
# -----------------------------------------------------------------------------
DEBUG=true
DJANGO_SECRET_KEY=your-secret-key-change-in-production
DJANGO_SETTINGS_MODULE=i2dbackend.settings.local
ENVIRONMENT=development

# -----------------------------------------------------------------------------
# Database Configuration (PostGIS)
# -----------------------------------------------------------------------------
DB_ENGINE=django.contrib.gis.db.backends.postgis
DB_NAME=i2d_db
DB_USER=i2d_user
DB_PASSWORD=i2d_password
DB_HOST=db
DB_PORT=5432
DB_OPTIONS=-c search_path=django,gbif_consultas,capas_base,geovisor

# -----------------------------------------------------------------------------
# Server Configuration
# -----------------------------------------------------------------------------
ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0,backend
PORT=8001

# -----------------------------------------------------------------------------
# Static & Media Files
# -----------------------------------------------------------------------------
STATIC_ROOT=/app/static
STATIC_URL=/static/
MEDIA_ROOT=/app/media
MEDIA_URL=/media/

# -----------------------------------------------------------------------------
# CORS Configuration
# -----------------------------------------------------------------------------
CORS_ALLOWED_ORIGINS=http://localhost:8080,http://localhost:1234,http://127.0.0.1:8080

# -----------------------------------------------------------------------------
# GeoServer Configuration
# -----------------------------------------------------------------------------
GEOSERVER_URL=https://geoservicios.humboldt.org.co/geoserver
GEOSERVER_ADMIN_USER=admin
GEOSERVER_ADMIN_PASSWORD=geoserver
GEOSERVER_WORKSPACE_DEFAULT=Historicos
GEOSERVER_WORKSPACE_CAPAS_BASE=Capas_Base

# -----------------------------------------------------------------------------
# Project Defaults
# -----------------------------------------------------------------------------
DEFAULT_PROJECT=general
DEFAULT_ZOOM_LEVEL=6.0
DEFAULT_CENTER_X=-8113332.0
DEFAULT_CENTER_Y=464737.0

# -----------------------------------------------------------------------------
# API Configuration
# -----------------------------------------------------------------------------
API_VERSION=v1
API_TITLE=Visor I2D API
API_DESCRIPTION=Colombian Biodiversity Data API
```

#### **Frontend `.env` (Complete Example)**

```bash
# =============================================================================
# VISOR I2D FRONTEND CONFIGURATION
# =============================================================================

# -----------------------------------------------------------------------------
# Development Server
# -----------------------------------------------------------------------------
NODE_ENV=development
PORT=1234

# -----------------------------------------------------------------------------
# Backend API
# -----------------------------------------------------------------------------
PYTHONSERVER=http://localhost:8001/api/

# -----------------------------------------------------------------------------
# GeoServer
# -----------------------------------------------------------------------------
GEOSERVER_URL=https://geoservicios.humboldt.org.co/geoserver

# -----------------------------------------------------------------------------
# External Services
# -----------------------------------------------------------------------------
GEONETWORK_URL=https://geonetwork.humboldt.org.co
DATAVERSE_URL=https://dataverse.humboldt.org.co

# -----------------------------------------------------------------------------
# Base Map Tile Servers
# -----------------------------------------------------------------------------
CARTO_LIGHT_URL=https://{a-d}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png
CARTO_DARK_URL=https://{a-d}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png
OPENTOPOMAP_URL=https://{a-c}.tile.opentopomap.org/{z}/{x}/{y}.png

# -----------------------------------------------------------------------------
# UI Links
# -----------------------------------------------------------------------------
I2D_HOME_URL=https://i2d.humboldt.org.co
CEIBA_URL=https://ceiba.humboldt.org.co

# -----------------------------------------------------------------------------
# PDF Generation
# -----------------------------------------------------------------------------
PDF_ASSET_BASE_URL=http://localhost:1234/assets
```

---

### **Step 2: Simplify Django Settings**

#### **`i2dbackend/settings/base.py`** (Environment-driven)

```python
"""
Base settings - All configuration from environment variables
"""
import os
from pathlib import Path

# Build paths
BASE_DIR = Path(__file__).resolve().parent.parent.parent

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY', 'dev-only-insecure-key')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.environ.get('DEBUG', 'false').lower() == 'true'

# Allowed hosts from environment
ALLOWED_HOSTS = os.environ.get('ALLOWED_HOSTS', 'localhost').split(',')

# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'django.contrib.gis',  # PostGIS support
    'rest_framework',
    'corsheaders',
    # Project apps
    'applications.dpto',
    'applications.mupio',
    'applications.gbif',
    'applications.projects',
]

# Database - All from environment variables
DATABASES = {
    'default': {
        'ENGINE': os.environ.get('DB_ENGINE', 'django.contrib.gis.db.backends.postgis'),
        'NAME': os.environ.get('DB_NAME', 'i2d_db'),
        'USER': os.environ.get('DB_USER', 'i2d_user'),
        'PASSWORD': os.environ.get('DB_PASSWORD', ''),
        'HOST': os.environ.get('DB_HOST', 'localhost'),
        'PORT': os.environ.get('DB_PORT', '5432'),
        'OPTIONS': {
            'options': os.environ.get('DB_OPTIONS', '')
        } if os.environ.get('DB_OPTIONS') else {}
    }
}

# Static files
STATIC_URL = os.environ.get('STATIC_URL', '/static/')
STATIC_ROOT = os.environ.get('STATIC_ROOT', BASE_DIR / 'static')
MEDIA_URL = os.environ.get('MEDIA_URL', '/media/')
MEDIA_ROOT = os.environ.get('MEDIA_ROOT', BASE_DIR / 'media')

# CORS settings
CORS_ALLOWED_ORIGINS = os.environ.get(
    'CORS_ALLOWED_ORIGINS', 
    'http://localhost:8080'
).split(',')

# ... rest of settings
```

#### **`i2dbackend/settings/local.py`** (Minimal overrides)

```python
"""
Local development settings - Minimal overrides only
"""
from .base import *

# Development-specific settings only
DEBUG = True

# Development logging
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'INFO',
    },
}
```

#### **`i2dbackend/settings/prod.py`** (Production overrides)

```python
"""
Production settings - Security-focused overrides
"""
from .base import *

# Force production settings
DEBUG = False
ALLOWED_HOSTS = os.environ.get('ALLOWED_HOSTS', '').split(',')

# Security settings
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'

# Production logging
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file': {
            'class': 'logging.FileHandler',
            'filename': '/var/log/django/visor_i2d.log',
        },
    },
    'root': {
        'handlers': ['file'],
        'level': 'WARNING',
    },
}
```

---

### **Step 3: Clean Docker Compose**

#### **`docker-compose.yml`** (Development)

```yaml
version: "3.8"

services:
  db:
    image: postgis/postgis:16-3.4-alpine
    container_name: visor_i2d_db
    env_file:
      - .env  # Database credentials from .env
    volumes:
      - postgres_data:/var/lib/postgresql/data/
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-i2d_user} -d ${DB_NAME:-i2d_db}"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    build:
      context: ./visor-geografico-I2D-backend
    container_name: visor_i2d_backend
    env_file:
      - ./visor-geografico-I2D-backend/.env  # All backend config from .env
    volumes:
      - ./visor-geografico-I2D-backend:/project
    ports:
      - "8001:8001"
    depends_on:
      db:
        condition: service_healthy
    command: >
      sh -c "python manage.py migrate &&
             python manage.py collectstatic --noinput &&
             gunicorn i2dbackend.wsgi --bind 0.0.0.0:8001"

  frontend:
    build:
      context: ./visor-geografico-I2D
    container_name: visor_i2d_frontend
    env_file:
      - ./visor-geografico-I2D/.env  # All frontend config from .env
    volumes:
      - ./visor-geografico-I2D:/home/node/app
    ports:
      - "1234:1234"
    depends_on:
      - backend

volumes:
  postgres_data:
```

#### **`docker-compose.uat.yml`** (UAT Environment)

```yaml
version: "3.8"

services:
  backend:
    env_file:
      - .env.uat  # UAT-specific configuration
    environment:
      - DJANGO_SETTINGS_MODULE=i2dbackend.settings.prod
      - ENVIRONMENT=uat

  frontend:
    env_file:
      - .env.uat
    environment:
      - NODE_ENV=production
```

---

### **Step 4: Remove `secret.json`** ❌

**Action:** Delete `secret.json` and migrate all values to `.env`

```bash
# Before (secret.json)
{
    "SECRET_KEY": "test",
    "DB_NAME": "i2d_db",
    "DB_USER": "i2d_user"
}

# After (.env)
DJANGO_SECRET_KEY=test
DB_NAME=i2d_db
DB_USER=i2d_user
```

**Update Django settings to stop reading `secret.json`:**

```python
# Remove this code from settings
import json
with open('secret.json') as f:
    secrets = json.load(f)
SECRET_KEY = secrets['SECRET_KEY']

# Replace with
SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY')
```

---

## Security Best Practices

### **1. Never Commit Secrets**

```bash
# .gitignore
.env
.env.local
.env.*.local
.env.uat
.env.production
secret.json
*.pem
*.key
```

### **2. Always Provide `.env.example`**

```bash
# .env.example (safe to commit)
DJANGO_SECRET_KEY=change-me-in-production
DB_PASSWORD=change-me
GEOSERVER_ADMIN_PASSWORD=change-me
```

### **3. Use Environment-Specific Files**

```bash
.env              # Local development (gitignored)
.env.example      # Template (committed)
.env.uat          # UAT environment (gitignored)
.env.production   # Production (gitignored, deployed separately)
```

### **4. Validate Required Variables**

```python
# i2dbackend/settings/base.py
import os

REQUIRED_ENV_VARS = [
    'DJANGO_SECRET_KEY',
    'DB_PASSWORD',
    'DB_HOST',
]

for var in REQUIRED_ENV_VARS:
    if not os.environ.get(var):
        raise ValueError(f"Missing required environment variable: {var}")
```

---

## Migration Checklist

- [ ] **Step 1:** Create comprehensive `.env.example` files
- [ ] **Step 2:** Copy `.env.example` to `.env` and fill in secrets
- [ ] **Step 3:** Update Django settings to read from `os.environ`
- [ ] **Step 4:** Remove `secret.json` and its references
- [ ] **Step 5:** Clean up `docker-compose.yml` (remove hardcoded env vars)
- [ ] **Step 6:** Update `.gitignore` to exclude all `.env` files except `.env.example`
- [ ] **Step 7:** Test locally with `docker-compose up`
- [ ] **Step 8:** Create `.env.uat` for UAT environment
- [ ] **Step 9:** Create `.env.production` for production
- [ ] **Step 10:** Document deployment process in README

---

## Benefits of This Approach

### **✅ Single Source of Truth**
- All configuration in `.env` files
- No duplication between `secret.json` and `.env`
- Clear precedence: environment variables override everything

### **✅ Environment Parity**
- Same codebase for dev/uat/prod
- Only `.env` file changes between environments
- Reduces "works on my machine" issues

### **✅ Security**
- Secrets never committed to git
- Easy to rotate credentials (just update `.env`)
- Clear separation of code and configuration

### **✅ Docker-Native**
- Docker Compose `env_file` is standard practice
- Easy to override with `docker run -e VAR=value`
- Works with Kubernetes ConfigMaps/Secrets

### **✅ Developer Experience**
- Copy `.env.example` to `.env` and start coding
- No need to understand Django settings structure
- Self-documenting via `.env.example`

---

## Tools to Help

### **1. python-decouple** (Recommended)

```bash
pip install python-decouple
```

```python
# settings/base.py
from decouple import config, Csv

SECRET_KEY = config('DJANGO_SECRET_KEY')
DEBUG = config('DEBUG', default=False, cast=bool)
ALLOWED_HOSTS = config('ALLOWED_HOSTS', cast=Csv())
DB_PASSWORD = config('DB_PASSWORD')
```

**Benefits:**
- Type casting (bool, int, float, Csv)
- Default values
- Raises clear errors for missing vars
- Reads from `.env` automatically

### **2. django-environ** (Alternative)

```bash
pip install django-environ
```

```python
import environ

env = environ.Env(
    DEBUG=(bool, False)
)
environ.Env.read_env()

SECRET_KEY = env('DJANGO_SECRET_KEY')
DEBUG = env('DEBUG')
DATABASES = {
    'default': env.db()  # Parses DATABASE_URL
}
```

### **3. direnv** (Local Development)

```bash
# Install direnv
sudo apt install direnv  # Ubuntu/Debian
brew install direnv      # macOS

# Add to ~/.bashrc or ~/.zshrc
eval "$(direnv hook bash)"

# Create .envrc in project root
echo "dotenv" > .envrc
direnv allow
```

**Benefits:**
- Auto-loads `.env` when entering directory
- Auto-unloads when leaving directory
- No need to `source .env` manually

---

## Comparison: Current vs Recommended

| Aspect | Current (❌) | Recommended (✅) |
|--------|-------------|------------------|
| **Config files** | 5+ locations | 1 per environment |
| **Secrets** | `secret.json` + `.env` | `.env` only |
| **Docker** | Hardcoded + env_file | `env_file` only |
| **Django settings** | Reads JSON + env | Reads env only |
| **Precedence** | Unclear | Clear hierarchy |
| **Security** | Secrets in multiple places | Single source |
| **Maintenance** | Update 3+ files | Update 1 file |
| **Deployment** | Complex | Simple |

---

## Example: Full Migration

### **Before (Current State)**

```yaml
# docker-compose.yml
services:
  backend:
    env_file:
      - ./visor-geografico-I2D-backend/.env
    environment:
      - DB_ENGINE=django.contrib.gis.db.backends.postgis
      - ENVIRONMENT=development
      - DEBUG=true
    volumes:
      - ./visor-geografico-I2D-backend/secret.json:/project/secret.json
```

```python
# settings/base.py
import json
with open('secret.json') as f:
    secrets = json.load(f)
SECRET_KEY = secrets['SECRET_KEY']
```

### **After (Recommended)**

```yaml
# docker-compose.yml
services:
  backend:
    env_file:
      - ./visor-geografico-I2D-backend/.env  # Single source
    # No hardcoded environment variables
```

```python
# settings/base.py
import os
SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY')
# Or with python-decouple
from decouple import config
SECRET_KEY = config('DJANGO_SECRET_KEY')
```

```bash
# .env
DJANGO_SECRET_KEY=your-secret-key
DB_ENGINE=django.contrib.gis.db.backends.postgis
ENVIRONMENT=development
DEBUG=true
```

---

## Conclusion

**Recommended approach:**
1. ✅ Use `.env` files as single source of truth
2. ✅ Remove `secret.json` completely
3. ✅ Django settings read from `os.environ` only
4. ✅ Docker Compose uses `env_file` directive
5. ✅ Commit `.env.example`, gitignore `.env`
6. ✅ Use `python-decouple` or `django-environ` for type safety

This follows **12-Factor App** methodology and is the industry standard for modern Django/Docker applications.
