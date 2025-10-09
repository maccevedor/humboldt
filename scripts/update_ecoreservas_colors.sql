-- SQL script to update layer group colors for ecoreservas project
-- Based on Bootstrap color scheme matching the production site
-- Date: 2025-10-09

-- Color reference:
-- #17a2b8 = Bootstrap info (cyan/teal) - Main ecoregion headers
-- #28a745 = Bootstrap success (green) - Investment type subgroups
-- #ffc107 = Bootstrap warning (yellow/orange) - San Antero ecoregion header

-- ============================================================================
-- Ecoregión Mancilla y Tocancipá (Main header - Level 1)
-- ============================================================================
UPDATE django.layer_groups 
SET color = '#17a2b8' 
WHERE id = 23 
  AND nombre = 'Ecoregión relacionada a las Ecoreservas Mancilla y Tocancipá'
  AND proyecto_id = (SELECT id FROM django.projects WHERE nombre_corto = 'ecoreservas');

-- Compensación subgroup (already correct green #28a745)
-- No update needed for id = 24

-- Inversión 1% subgroup (Level 2)
UPDATE django.layer_groups 
SET color = '#28a745' 
WHERE id = 40 
  AND nombre = 'Inversión 1%' 
  AND parent_group_id = 23
  AND proyecto_id = (SELECT id FROM django.projects WHERE nombre_corto = 'ecoreservas');

-- Inversión Voluntaria subgroup (Level 2)
UPDATE django.layer_groups 
SET color = '#28a745' 
WHERE id = 44 
  AND nombre = 'Inversión Voluntaria' 
  AND parent_group_id = 23
  AND proyecto_id = (SELECT id FROM django.projects WHERE nombre_corto = 'ecoreservas');

-- ============================================================================
-- Ecoregión San Antero (Main header - Level 1)
-- ============================================================================
UPDATE django.layer_groups 
SET color = '#ffc107' 
WHERE id = 32 
  AND nombre = 'Ecoregión relacionada a la Ecoreserva San Antero'
  AND proyecto_id = (SELECT id FROM django.projects WHERE nombre_corto = 'ecoreservas');

-- Inversión 1% subgroup for San Antero (Level 2)
UPDATE django.layer_groups 
SET color = '#28a745' 
WHERE id = 33 
  AND nombre = 'Inversión 1%' 
  AND parent_group_id = 32
  AND proyecto_id = (SELECT id FROM django.projects WHERE nombre_corto = 'ecoreservas');

-- Inversión Voluntaria subgroup for San Antero (Level 2)
UPDATE django.layer_groups 
SET color = '#28a745' 
WHERE id = 36 
  AND nombre = 'Inversión Voluntaria' 
  AND parent_group_id = 32
  AND proyecto_id = (SELECT id FROM django.projects WHERE nombre_corto = 'ecoreservas');

-- ============================================================================
-- Verification query
-- ============================================================================
SELECT 
    lg.id,
    lg.nombre,
    lg.color,
    lg.parent_group_id,
    CASE 
        WHEN lg.parent_group_id IS NULL THEN 'Level 1 (Main)'
        WHEN EXISTS (SELECT 1 FROM django.layer_groups WHERE parent_group_id = lg.id) THEN 'Level 2 (Subgroup)'
        ELSE 'Level 3 (Action)'
    END as level,
    p.nombre_corto
FROM django.layer_groups lg
JOIN django.projects p ON lg.proyecto_id = p.id
WHERE p.nombre_corto = 'ecoreservas'
ORDER BY lg.orden, lg.id;
