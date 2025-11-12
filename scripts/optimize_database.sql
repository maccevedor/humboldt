-- ============================================================================
-- Database Performance Optimization Script
-- Visor I2D Humboldt Project
-- PostgreSQL 16 + PostGIS 3.4
-- Based on: visor-geografico-I2D-backend/docs/database.md
-- ============================================================================

-- Run with: docker exec -i visor_i2d_db psql -U i2d_user -d i2d_db < optimize_database.sql

\echo '========================================='
\echo 'Database Performance Optimization Script'
\echo 'Based on documented optimizations'
\echo '========================================='
\echo ''

-- ============================================================================
-- PHASE 1: CRITICAL DATABASE OPTIMIZATIONS
-- ============================================================================

-- ============================================================================
-- 1. ANALYZE TABLES - Update statistics for query planner
-- ============================================================================
\echo '1. Analyzing all tables (updating statistics)...'

ANALYZE capas_base.mpio_politico;
ANALYZE capas_base.dpto_politico;
ANALYZE capas_base.cars;
ANALYZE gbif_consultas.mpio_queries;
ANALYZE gbif_consultas.dpto_queries;
ANALYZE gbif_consultas.mpio_amenazas;
ANALYZE gbif_consultas.dpto_amenazas;
ANALYZE gbif_consultas.gbif_info;
ANALYZE django.layers;
ANALYZE django.layer_groups;
ANALYZE django.projects;

\echo '✓ Table statistics updated'
\echo ''

-- ============================================================================
-- 2. COMPOSITE INDEXES - For frequent queries (DOCUMENTED)
-- ============================================================================
\echo '2. Creating composite indexes for frequent queries...'

-- Composite indexes with WHERE clause for NULL filtering
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_dpto_queries_codigo_tipo 
  ON gbif_consultas.dpto_queries (codigo, tipo) WHERE tipo IS NOT NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_mpio_queries_codigo_tipo 
  ON gbif_consultas.mpio_queries (codigo, tipo) WHERE tipo IS NOT NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_dpto_amenazas_codigo 
  ON gbif_consultas.dpto_amenazas (codigo) WHERE tipo IS NOT NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_mpio_amenazas_codigo 
  ON gbif_consultas.mpio_amenazas (codigo) WHERE tipo IS NOT NULL;

\echo '✓ Composite indexes created'
\echo ''

-- ============================================================================
-- 3. STATISTICS OPTIMIZATION INDEXES (DOCUMENTED)
-- ============================================================================
\echo '3. Creating statistics optimization indexes...'

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_dpto_species_stats 
  ON gbif_consultas.dpto_queries (species, endemicas, exoticas);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_mpio_species_stats 
  ON gbif_consultas.mpio_queries (species, endemicas, exoticas);

\echo '✓ Statistics indexes created'
\echo ''

-- ============================================================================
-- 4. TEXT SEARCH INDEXES - GIN indexes for municipality search (DOCUMENTED)
-- ============================================================================
\echo '4. Creating GIN text search indexes...'

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_mupio_politico_nombre_gin 
  ON capas_base.mpio_politico USING gin(to_tsvector('spanish', nombre));

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_mupio_politico_dpto_gin 
  ON capas_base.mpio_politico USING gin(to_tsvector('spanish', dpto_nombre));

\echo '✓ Text search indexes created'
\echo ''

-- ============================================================================
-- 5. DJANGO APPLICATION INDEXES (DOCUMENTED)
-- ============================================================================
\echo '5. Creating Django application indexes...'

CREATE INDEX IF NOT EXISTS idx_layers_project_id ON django.layers(project_id);
CREATE INDEX IF NOT EXISTS idx_layers_layer_group_id ON django.layers(layer_group_id);
CREATE INDEX IF NOT EXISTS idx_layer_groups_project_id ON django.layer_groups(project_id);

\echo '✓ Django indexes created'
\echo ''

-- ============================================================================
-- PHASE 2: POSTGIS SPATIAL OPTIMIZATIONS (DOCUMENTED - HIGH IMPACT)
-- Expected: 31.5-46.6% improvement for spatial queries
-- ============================================================================

-- ============================================================================
-- 6. SPATIAL GIST INDEXES - Critical for PostGIS performance (DOCUMENTED)
-- ============================================================================
\echo '6. Creating PostGIS spatial GIST indexes...'
\echo '   Expected improvement: 31.5-46.6% for spatial queries'

-- Spatial indexes for GBIF queries (PRIMARY OPTIMIZATION)
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_dpto_queries_geom 
  ON gbif_consultas.dpto_queries USING GIST (geom);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_mpio_queries_geom 
  ON gbif_consultas.mpio_queries USING GIST (geom);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_dpto_amenazas_geom 
  ON gbif_consultas.dpto_amenazas USING GIST (geom);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_mpio_amenazas_geom 
  ON gbif_consultas.mpio_amenazas USING GIST (geom);

-- Spatial indexes for base layers
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_mpio_politico_geom 
  ON capas_base.mpio_politico USING GIST(geom);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_dpto_politico_geom 
  ON capas_base.dpto_politico USING GIST(geom);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_cars_geom 
  ON capas_base.cars USING GIST(geom);

\echo '✓ Spatial GIST indexes created'
\echo ''

-- ============================================================================
-- 4. VACUUM ANALYZE - Reclaim space and update statistics
-- ============================================================================
\echo '4. Running VACUUM ANALYZE (this may take a few minutes)...'

VACUUM ANALYZE capas_base.mpio_politico;
VACUUM ANALYZE capas_base.dpto_politico;
VACUUM ANALYZE capas_base.cars;
VACUUM ANALYZE gbif_consultas.mpio_queries;
VACUUM ANALYZE gbif_consultas.dpto_queries;
VACUUM ANALYZE gbif_consultas.mpio_amenazas;
VACUUM ANALYZE gbif_consultas.dpto_amenazas;
VACUUM ANALYZE django.layers;
VACUUM ANALYZE django.layer_groups;
VACUUM ANALYZE django.projects;

\echo '✓ VACUUM ANALYZE completed'
\echo ''

-- ============================================================================
-- 5. UPDATE POSTGRESQL CONFIGURATION (Session level)
-- ============================================================================
\echo '5. Optimizing PostgreSQL configuration...'

-- Increase work memory for complex queries
SET work_mem = '256MB';

-- Increase maintenance work memory for index creation
SET maintenance_work_mem = '512MB';

-- Enable parallel query execution
SET max_parallel_workers_per_gather = 4;

-- Optimize random page cost for SSD
SET random_page_cost = 1.1;

-- Increase effective cache size
SET effective_cache_size = '2GB';

\echo '✓ Configuration optimized (session level)'
\echo ''

-- ============================================================================
-- 6. REINDEX - Rebuild indexes for optimal performance
-- ============================================================================
\echo '6. Reindexing critical tables...'

REINDEX TABLE capas_base.mpio_politico;
REINDEX TABLE capas_base.dpto_politico;
REINDEX TABLE gbif_consultas.mpio_queries;
REINDEX TABLE gbif_consultas.dpto_queries;

\echo '✓ Reindexing completed'
\echo ''

-- ============================================================================
-- 7. PERFORMANCE VERIFICATION QUERIES
-- ============================================================================
\echo '7. Verifying performance improvements...'
\echo ''

\echo 'Created indexes:'
SELECT 
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname IN ('gbif_consultas', 'capas_base', 'django')
  AND indexname LIKE 'idx_%'
ORDER BY schemaname, tablename, indexname;

\echo ''
\echo 'Index usage statistics:'
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as index_scans,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched
FROM pg_stat_user_indexes
WHERE schemaname IN ('capas_base', 'gbif_consultas', 'django')
ORDER BY idx_scan DESC
LIMIT 20;

\echo ''
\echo 'Table sizes after optimization:'
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS total_size,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) AS table_size,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename) - pg_relation_size(schemaname||'.'||tablename)) AS indexes_size
FROM pg_tables
WHERE schemaname IN ('capas_base', 'gbif_consultas', 'django')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
LIMIT 15;

\echo ''
\echo '========================================='
\echo 'Optimization Complete!'
\echo '========================================='
\echo ''
\echo 'Expected Performance Improvements (from database.md):'
\echo '  - Department queries: 31.5-44.4% faster'
\echo '  - Municipality queries: 12.4-23.6% faster'
\echo '  - Export operations: 21.4-46.6% faster'
\echo '  - Average improvement: 21.5% across all queries'
\echo ''
\echo 'Next Steps:'
\echo '1. Test query performance with EXPLAIN ANALYZE'
\echo '2. Run VACUUM ANALYZE weekly'
\echo '3. Monitor index usage statistics'
\echo '4. Review database.md for additional optimizations'
\echo ''
