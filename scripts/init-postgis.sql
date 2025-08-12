-- PostGIS initialization script for Humboldt Visor I2D
-- This script ensures PostGIS extensions are available and creates required roles

-- Create PostGIS extensions (if not already present)
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;

-- Create required database roles for backup compatibility
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'humboldt') THEN
        CREATE ROLE humboldt WITH LOGIN;
        RAISE NOTICE 'Role "humboldt" created successfully';
    ELSE
        RAISE NOTICE 'Role "humboldt" already exists';
    END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'postgres') THEN
        CREATE ROLE postgres WITH LOGIN SUPERUSER;
        RAISE NOTICE 'Role "postgres" created successfully';
    ELSE
        RAISE NOTICE 'Role "postgres" already exists';
    END IF;
END
$$;

-- Grant necessary permissions
GRANT ALL PRIVILEGES ON DATABASE i2d_db TO humboldt;
GRANT ALL PRIVILEGES ON DATABASE i2d_db TO postgres;

-- Verify PostGIS installation
SELECT PostGIS_Version() as postgis_version;

-- Log successful initialization
SELECT 'PostGIS initialization completed successfully' as status;
