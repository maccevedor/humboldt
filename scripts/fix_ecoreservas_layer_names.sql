-- Fix Ecoreservas Layer Names to Match GeoServer
-- This SQL script fixes the layer name mismatch between database and GeoServer
-- Issue: Database had incorrect layer names that don't exist in GeoServer
-- Solution: Update database layer names to match actual GeoServer layer names

-- Update Preservación group layers
UPDATE applications_projects_layer 
SET nombre_geoserver = 'Preservación_priorizando_todos_los_enfoques_Inversión_no_menos_1_' 
WHERE nombre_geoserver = 'Preservación_priorizando_todos_los_enfoques_Compensación';

UPDATE applications_projects_layer 
SET nombre_geoserver = 'Preservación_priorizando_Costos_de_Oportunidad_Inversión_no_menos_1_' 
WHERE nombre_geoserver = 'Preservación_priorizando_Costos_de_Oportunidad_Compensación';

UPDATE applications_projects_layer 
SET nombre_geoserver = 'Preservación_priorizando_Costos_Abióticos_Inversión_no_menos_1_' 
WHERE nombre_geoserver = 'Preservación_priorizando_Costos_Abióticos_Compensación';

-- Update Restauración group layers (if they exist with similar pattern)
UPDATE applications_projects_layer 
SET nombre_geoserver = 'Restauración_priorizando_todos_los_enfoques_Inversión_no_menos_1_' 
WHERE nombre_geoserver = 'Restauración_priorizando_todos_los_enfoques_Compensación';

UPDATE applications_projects_layer 
SET nombre_geoserver = 'Restauración_priorizando_Costos_de_Oportunidad_Inversión_no_menos_1_' 
WHERE nombre_geoserver = 'Restauración_priorizando_Costos_de_Oportunidad_Compensación';

UPDATE applications_projects_layer 
SET nombre_geoserver = 'Restauración_priorizando_Costos_Abióticos_Inversión_no_menos_1_' 
WHERE nombre_geoserver = 'Restauración_priorizando_Costos_Abióticos_Compensación';

-- Update Uso Sostenible group layers (if they exist with similar pattern)
UPDATE applications_projects_layer 
SET nombre_geoserver = 'Uso_Sostenible_priorizando_todos_los_enfoques_Inversión_no_menos_1_' 
WHERE nombre_geoserver = 'Uso_Sostenible_priorizando_todos_los_enfoques_Compensación';

UPDATE applications_projects_layer 
SET nombre_geoserver = 'Uso_Sostenible_priorizando_Costos_de_Oportunidad_Inversión_no_menos_1_' 
WHERE nombre_geoserver = 'Uso_Sostenible_priorizando_Costos_de_Oportunidad_Compensación';

UPDATE applications_projects_layer 
SET nombre_geoserver = 'Uso_Sostenible_priorizando_Costos_Abióticos_Inversión_no_menos_1_' 
WHERE nombre_geoserver = 'Uso_Sostenible_priorizando_Costos_Abióticos_Compensación';

-- Verify the changes
SELECT nombre_display, nombre_geoserver, store_geoserver 
FROM applications_projects_layer 
WHERE store_geoserver = 'ecoreservas' 
ORDER BY nombre_display;

-- Expected layer names in GeoServer (for reference):
-- Preservación_priorizando_todos_los_enfoques_Inversión_no_menos_1_
-- Preservación_priorizando_Costos_de_Oportunidad_Inversión_no_menos_1_
-- Preservación_priorizando_Costos_Abióticos_Inversión_no_menos_1_
-- Preservación_priorizando_todos_los_enfoques_Compensación
-- Preservación_priorizando_Costos_de_Oportunidad_Compensación
-- Preservación_priorizando_Costos_Abióticos_Compensación
-- Preservación_priorizando_todos_los_enfoques_Inversión_Voluntaria
-- Preservación_priorizando_Costos_Abióticos_Inversión_Voluntaria
-- Preservación_riorizando_Costos_de_Oportunidad_Inversión_Voluntaria
