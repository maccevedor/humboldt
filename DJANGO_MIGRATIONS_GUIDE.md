# Django Migrations Guide - Visor I2D Backend

## Table of Contents
1. [Overview](#overview)
2. [Migration Commands](#migration-commands)
3. [Step-by-Step Execution](#step-by-step-execution)
4. [Database Schema Structure](#database-schema-structure)
5. [How Django Migrations Work](#how-django-migrations-work)
6. [Common Migration Tasks](#common-migration-tasks)
7. [Troubleshooting](#troubleshooting)

---

## Overview

Django migrations are Django's way of propagating changes you make to your models (adding a field, deleting a model, etc.) into your database schema. This guide covers the migration process for the Visor I2D backend running in Docker.

### Current Status
✅ All migrations have been successfully applied to the database.

---

## Migration Commands

### 1. Check Migration Status
Shows which migrations have been applied (`[X]`) and which are pending (`[ ]`).

```bash
docker-compose exec backend python manage.py showmigrations
```

**Output Example:**
```
projects
 [X] 0001_initial
 [X] 0002_layergroup_color
 [X] 0003_alter_defaultlayer_id_alter_layer_id_and_more
```

### 2. Create New Migrations
Detects model changes and creates migration files.

```bash
# Dry run - see what would be created without creating files
docker-compose exec backend python manage.py makemigrations --dry-run

# Actually create the migration files
docker-compose exec backend python manage.py makemigrations

# Create migrations for a specific app
docker-compose exec backend python manage.py makemigrations projects
```

### 3. Apply Migrations
Applies pending migrations to the database.

```bash
# Apply all pending migrations
docker-compose exec backend python manage.py migrate

# Apply migrations for a specific app
docker-compose exec backend python manage.py migrate projects

# Apply migrations up to a specific migration
docker-compose exec backend python manage.py migrate projects 0002
```

### 4. View Migration SQL
See the SQL that will be executed without running it.

```bash
docker-compose exec backend python manage.py sqlmigrate projects 0003
```

### 5. Rollback Migrations
Revert to a previous migration state.

```bash
# Rollback to a specific migration
docker-compose exec backend python manage.py migrate projects 0002

# Rollback all migrations for an app
docker-compose exec backend python manage.py migrate projects zero
```

---

## Step-by-Step Execution

### Initial Setup (Already Completed)

**Step 1: Check Current Status**
```bash
docker-compose exec backend python manage.py showmigrations
```

**Step 2: Detect New Changes**
```bash
docker-compose exec backend python manage.py makemigrations --dry-run
```

**Result:** Found pending migration for `projects` app to update ID fields.

**Step 3: Create Migration Files**
```bash
docker-compose exec backend python manage.py makemigrations
```

**Output:**
```
Migrations for 'projects':
  applications/projects/migrations/0003_alter_defaultlayer_id_alter_layer_id_and_more.py
    - Alter field id on defaultlayer
    - Alter field id on layer
    - Alter field id on layergroup
    - Alter field id on project
```

**Step 4: Apply Migrations**
```bash
docker-compose exec backend python manage.py migrate
```

**Output:**
```
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, mupio, mupiopolitico, projects, sessions, user
Running migrations:
  Applying projects.0003_alter_defaultlayer_id_alter_layer_id_and_more... OK
```

**Step 5: Verify Success**
```bash
docker-compose exec backend python manage.py showmigrations
```

All migrations should now show `[X]` indicating they are applied.

---

## Database Schema Structure

### PostgreSQL Schemas
The database uses multiple PostgreSQL schemas to organize tables:

```sql
-- View all schemas
docker-compose exec db psql -U i2d_user -d i2d_db -c "\dn"
```

**Schemas:**
- `django` - Django application tables (auth, sessions, migrations, etc.)
- `gbif_consultas` - GBIF biodiversity data queries
- `capas_base` - Base map layers
- `geovisor` - Geographic viewer data
- `public` - PostGIS extensions
- `tiger`, `tiger_data`, `topology` - PostGIS geocoding extensions

### Django Schema Tables

```sql
-- View tables in django schema
docker-compose exec db psql -U i2d_user -d i2d_db -c "\dt django.*"
```

**Key Tables:**
- `django_migrations` - Tracks which migrations have been applied
- `auth_user` - User authentication
- `projects` - Project configurations
- `layers` - Map layer definitions
- `layer_groups` - Layer groupings
- `default_layers` - Default layer settings

---

## How Django Migrations Work

### 1. Migration Files
Migration files are Python scripts stored in `applications/<app>/migrations/` that describe database changes.

**Example Structure:**
```python
# applications/projects/migrations/0003_alter_defaultlayer_id.py
from django.db import migrations, models

class Migration(migrations.Migration):
    dependencies = [
        ('projects', '0002_layergroup_color'),
    ]
    
    operations = [
        migrations.AlterField(
            model_name='defaultlayer',
            name='id',
            field=models.BigAutoField(primary_key=True),
        ),
    ]
```

### 2. Migration Process Flow

```
┌─────────────────┐
│  Model Changes  │  (Edit models.py)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ makemigrations  │  (Detect changes, create migration file)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Migration File │  (Python script with operations)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│     migrate     │  (Execute SQL operations)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    Database     │  (Schema updated)
└─────────────────┘
```

### 3. Migration Tracking

Django uses the `django_migrations` table to track applied migrations:

```sql
docker-compose exec db psql -U i2d_user -d i2d_db -c "SELECT * FROM django.django_migrations ORDER BY applied DESC LIMIT 5;"
```

**Columns:**
- `id` - Unique identifier
- `app` - Application name
- `name` - Migration filename
- `applied` - Timestamp when applied

### 4. Migration Dependencies

Migrations have dependencies that ensure they run in the correct order:

```python
dependencies = [
    ('projects', '0002_layergroup_color'),  # Must run after this migration
]
```

---

## Common Migration Tasks

### Creating a Superuser
After migrations are applied, create an admin user:

```bash
docker-compose exec backend python manage.py createsuperuser
```

### Loading Initial Data
Load fixture data after migrations:

```bash
docker-compose exec backend python manage.py loaddata initial_data.json
```

### Checking for Model/Migration Conflicts

```bash
docker-compose exec backend python manage.py check
```

### Squashing Migrations
Combine multiple migrations into one (for cleanup):

```bash
docker-compose exec backend python manage.py squashmigrations projects 0001 0003
```

### Creating Empty Migration
For custom SQL or data migrations:

```bash
docker-compose exec backend python manage.py makemigrations --empty projects
```

---

## Troubleshooting

### Problem: "No migrations to apply"
**Cause:** All migrations are already applied.
**Solution:** This is normal. Check `showmigrations` to verify.

### Problem: "Conflicting migrations detected"
**Cause:** Multiple migration files with the same number or conflicting dependencies.
**Solution:**
```bash
# View the conflict
docker-compose exec backend python manage.py showmigrations

# Merge migrations
docker-compose exec backend python manage.py makemigrations --merge
```

### Problem: "Table already exists"
**Cause:** Database table exists but migration wasn't recorded.
**Solution:**
```bash
# Fake the migration (mark as applied without running)
docker-compose exec backend python manage.py migrate --fake projects 0001
```

### Problem: Migration fails with SQL error
**Cause:** Database constraint violation or incompatible change.
**Solution:**
1. Check the error message for details
2. View the SQL that would be executed:
   ```bash
   docker-compose exec backend python manage.py sqlmigrate projects 0003
   ```
3. Rollback if needed:
   ```bash
   docker-compose exec backend python manage.py migrate projects 0002
   ```
4. Fix the model or create a custom migration

### Problem: Need to reset all migrations
**Cause:** Development database needs fresh start.
**Solution:**
```bash
# WARNING: This deletes all data!
docker-compose down -v
docker-compose up -d
# Migrations will run automatically on startup
```

---

## Docker-Specific Notes

### Automatic Migrations on Startup
The docker-compose configuration runs migrations automatically when the backend container starts:

```yaml
command: >
  sh -c "pip install unidecode &&
         python manage.py collectstatic --noinput &&
         python manage.py migrate &&
         gunicorn i2dbackend.wsgi --bind 0.0.0.0:8001 ..."
```

### Accessing the Django Shell
For interactive database queries:

```bash
docker-compose exec backend python manage.py shell
```

### Accessing PostgreSQL Directly

```bash
# Connect to database
docker-compose exec db psql -U i2d_user -d i2d_db

# Common psql commands:
\dn              # List schemas
\dt django.*     # List tables in django schema
\d+ django.projects  # Describe projects table
\q               # Quit
```

### Viewing Container Logs

```bash
# Backend logs (includes migration output)
docker-compose logs backend

# Follow logs in real-time
docker-compose logs -f backend
```

---

## Summary of Applied Migrations

### Applications and Migration Count

| Application    | Migrations | Status |
|---------------|-----------|--------|
| admin         | 3         | ✅ Applied |
| auth          | 12        | ✅ Applied |
| contenttypes  | 2         | ✅ Applied |
| mupio         | 4         | ✅ Applied |
| mupiopolitico | 2         | ✅ Applied |
| projects      | 3         | ✅ Applied |
| sessions      | 1         | ✅ Applied |
| user          | 1         | ✅ Applied |

**Total:** 28 migrations successfully applied

---

## Quick Reference

```bash
# Check status
docker-compose exec backend python manage.py showmigrations

# Create migrations
docker-compose exec backend python manage.py makemigrations

# Apply migrations
docker-compose exec backend python manage.py migrate

# View SQL
docker-compose exec backend python manage.py sqlmigrate <app> <migration_number>

# Rollback
docker-compose exec backend python manage.py migrate <app> <previous_migration>

# Database shell
docker-compose exec db psql -U i2d_user -d i2d_db

# Django shell
docker-compose exec backend python manage.py shell

# Create superuser
docker-compose exec backend python manage.py createsuperuser
```

---

**Last Updated:** October 13, 2025  
**Database:** PostgreSQL 16 with PostGIS 3.4  
**Django Version:** 3.1+  
**Status:** ✅ All migrations applied successfully
