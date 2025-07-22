-- PostgreSQL initialization script for I2D backend
-- Creates the required schemas for Django application

-- Create schemas
CREATE SCHEMA IF NOT EXISTS django;
CREATE SCHEMA IF NOT EXISTS gbif_consultas;
CREATE SCHEMA IF NOT EXISTS capas_base;
CREATE SCHEMA IF NOT EXISTS geovisor;

-- Grant permissions to the application user
GRANT ALL PRIVILEGES ON SCHEMA django TO i2d_user;
GRANT ALL PRIVILEGES ON SCHEMA gbif_consultas TO i2d_user;
GRANT ALL PRIVILEGES ON SCHEMA capas_base TO i2d_user;
GRANT ALL PRIVILEGES ON SCHEMA geovisor TO i2d_user;

-- Set default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA django GRANT ALL ON TABLES TO i2d_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA gbif_consultas GRANT ALL ON TABLES TO i2d_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA capas_base GRANT ALL ON TABLES TO i2d_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA geovisor GRANT ALL ON TABLES TO i2d_user;

-- Set default privileges for sequences
ALTER DEFAULT PRIVILEGES IN SCHEMA django GRANT ALL ON SEQUENCES TO i2d_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA gbif_consultas GRANT ALL ON SEQUENCES TO i2d_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA capas_base GRANT ALL ON SEQUENCES TO i2d_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA geovisor GRANT ALL ON SEQUENCES TO i2d_user;

-- Set search path for the user
ALTER USER i2d_user SET search_path = django,gbif_consultas,capas_base,geovisor,public;
