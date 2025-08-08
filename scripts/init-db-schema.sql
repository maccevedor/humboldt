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


-- Connect to your PostgreSQL database and run this SQL
-- This creates the gbif_info table in the gbif_consultas schema

CREATE TABLE IF NOT EXISTS gbif_consultas.gbif_info (
    id SERIAL PRIMARY KEY,
    download_date DATE NOT NULL,
    doi TEXT
);


CREATE TABLE dpto_amenazas (
                               id serial PRIMARY KEY,
                               codigo varchar(5),
                               tipo varchar(1),
                               amenazadas bigint,
                               geom text,
                               nombre varchar(254)
);

CREATE TABLE dpto_queries (
                              id serial PRIMARY KEY,
                              codigo varchar(5),
                              tipo text,
                              registers bigint,
                              species bigint,
                              exoticas bigint,
                              endemicas bigint,
                              geom text,
                              nombre varchar(254)
);

CREATE TABLE mpio_amenazas (
                               id serial PRIMARY KEY,
                               codigo varchar(5),
                               tipo varchar(1),
                               amenazadas bigint,
                               geom text,
                               nombre varchar(254)
);


CREATE TABLE mpio_queries (
                              id serial PRIMARY KEY,
                              codigo varchar(5),
                              tipo text,
                              registers bigint,
                              species bigint,
                              exoticas bigint,
                              endemicas bigint,
                              geom text,
                              nombre varchar(254)
);


CREATE TABLE mpio_politico (
    gid SERIAL PRIMARY KEY,
    dpto_ccdgo VARCHAR(2),
    mpio_ccdgo VARCHAR(3),
    mpio_cnmbr VARCHAR(60),
    mpio_crslc VARCHAR(60),
    mpio_narea NUMERIC(20, 10),
    mpio_ccnct VARCHAR(5),
    mpio_nano BIGINT,
    dpto_cnmbr VARCHAR(250),
    shape_area NUMERIC(20, 10),
    shape_len NUMERIC(20, 10),
    orig_fid BIGINT,
    geom TEXT,
    -- If you want to add the fields from the simplified model:
    codigo VARCHAR(5),
    dpto_nombre VARCHAR(254),
    nombre VARCHAR(254),
    area_ha NUMERIC(20, 10),
    coord_central TEXT
);


ALTER TABLE mpio_politico
    ADD COLUMN nombre_unaccented VARCHAR(255);



ALTER TABLE mpio_politico
    ADD COLUMN dpto_nombre_unaccented VARCHAR(255);
