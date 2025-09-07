--
-- PostgreSQL database dump
--

\restrict yXGXIUGOU3nmwFVe3ttdvCUngTOryHepiZPgQ4KPeYVdickLQfeLpb5QkYSjw4l

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-1.pgdg25.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: layers; Type: TABLE; Schema: django; Owner: i2d_user
--

CREATE TABLE django.layers (
    id integer NOT NULL,
    nombre_geoserver character varying(200) NOT NULL,
    nombre_display character varying(200) NOT NULL,
    store_geoserver character varying(200) NOT NULL,
    estado_inicial boolean NOT NULL,
    metadata_id character varying(500),
    orden integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    grupo_id integer NOT NULL
);


ALTER TABLE django.layers OWNER TO i2d_user;

--
-- Name: layers_id_seq; Type: SEQUENCE; Schema: django; Owner: i2d_user
--

CREATE SEQUENCE django.layers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE django.layers_id_seq OWNER TO i2d_user;

--
-- Name: layers_id_seq; Type: SEQUENCE OWNED BY; Schema: django; Owner: i2d_user
--

ALTER SEQUENCE django.layers_id_seq OWNED BY django.layers.id;


--
-- Name: layers id; Type: DEFAULT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.layers ALTER COLUMN id SET DEFAULT nextval('django.layers_id_seq'::regclass);


--
-- Data for Name: layers; Type: TABLE DATA; Schema: django; Owner: i2d_user
--

INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (2, 'bosque_seco_tropical', 'Bosque Seco Tropical 2014', 'Historicos', false, 'eca845f9-dea1-4e86-b562-27338b79ef29', 1, '2025-08-28 09:56:44.738558+00', '2025-08-28 09:56:44.738571+00', 1);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (3, 'BST2018', 'Bosque Seco Tropical 2018', 'Historicos', false, '6ccd867c-5114-489f-9266-3e5cf657a375', 2, '2025-08-28 09:56:44.74141+00', '2025-08-28 09:56:44.741431+00', 1);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (4, 'complejos_paramos_escala100k', 'Complejos Páramos Escala 100k', 'Historicos', false, 'c9a5d546-33b5-41d6-a60e-57cfae1cff82', 3, '2025-08-28 09:56:44.744051+00', '2025-08-28 09:56:44.744064+00', 1);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (5, 'ecosistemas_cuenca_rio_orinoco', 'Ecosistemas Cuenca Río Orinoco', 'Historicos', false, '05281f18-d63e-469d-a2df-5796e8fd1769', 4, '2025-08-28 09:56:44.745715+00', '2025-08-28 09:56:44.745727+00', 1);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (6, 'ecosistemas_generales_etter', 'Ecosistemas Generales Etter', 'Historicos', false, '52be9cc9-a139-4568-8781-bbbda5590eab', 5, '2025-08-28 09:56:44.747327+00', '2025-08-28 09:56:44.747338+00', 1);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (7, 'grado_transformacion_humedales_m10k', 'Grado Transformación Humedales', 'Historicos', false, '532e5414-8906-47ee-a298-a97735fc6cdd', 6, '2025-08-28 09:56:44.749133+00', '2025-08-28 09:56:44.749143+00', 1);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (8, 'Humedales', 'Clasificación de humedales 2015', 'Proyecto_fondo_adaptacion', false, '7ff0663a-129c-43e9-a024-7718dbe59d60', 0, '2025-08-28 09:56:44.751573+00', '2025-08-28 09:56:44.75158+00', 2);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (9, 'Humedales_Continentales_Insulares_2015_Vector', 'Humedales Continentales Insulares', 'Proyecto_fondo_adaptacion', false, 'd68f4329-0385-47a2-8319-8b56c772b4c0', 1, '2025-08-28 09:56:44.752618+00', '2025-08-28 09:56:44.752626+00', 2);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (10, 'Limites21Paramos_25K_2015', 'Límite 21 Complejos Páramo 2015', 'Proyecto_fondo_adaptacion', false, '5dbddd78-3e51-45e6-b754-ab4c8f74f1b5', 2, '2025-08-28 09:56:44.753662+00', '2025-08-28 09:56:44.75367+00', 2);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (11, 'Limites24Paramos_25K_2016', 'Límite 24 Complejos Páramo 2016', 'Proyecto_fondo_adaptacion', false, '36139b13-b15e-445e-b44d-dd7a5dbe8185', 3, '2025-08-28 09:56:44.754863+00', '2025-08-28 09:56:44.754871+00', 2);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (12, 'biomas', 'Biomas', 'Proyecto_PACBAO_Ecopetrol', false, '4ea0ecd2-678d-423b-a940-ee2667d6d4a2', 0, '2025-08-28 09:56:44.75864+00', '2025-08-28 09:56:44.758651+00', 3);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (13, 'colapso_acuatico', 'Colapso Acuático', 'Proyecto_PACBAO_Ecopetrol', false, '11d7eb22-f60e-446f-b953-cb88817a4ca5', 1, '2025-08-28 09:56:44.759961+00', '2025-08-28 09:56:44.75997+00', 3);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (14, 'colapso_terrestre', 'Colapso Terrestre', 'Proyecto_PACBAO_Ecopetrol', false, '11d7eb22-f60e-446f-b953-cb88817a4ca5', 2, '2025-08-28 09:56:44.761092+00', '2025-08-28 09:56:44.7611+00', 3);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (15, 'colapso_total', 'Colapso Total', 'Proyecto_PACBAO_Ecopetrol', false, '11d7eb22-f60e-446f-b953-cb88817a4ca5', 3, '2025-08-28 09:56:44.762306+00', '2025-08-28 09:56:44.762315+00', 3);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (16, 'distritos_biogeograficos', 'Distritos Biogeográficos', 'Proyecto_PACBAO_Ecopetrol', false, '2dec7ad8-6677-4ee2-912c-bd39af420952', 4, '2025-08-28 09:56:44.764639+00', '2025-08-28 09:56:44.76466+00', 3);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (17, 'hidrobiologia', 'Hidrobiología', 'Proyecto_PACBAO_Ecopetrol', false, 'ca8b1ba9-3dea-4791-bf01-48df68d0fd41', 5, '2025-08-28 09:56:44.767561+00', '2025-08-28 09:56:44.767578+00', 3);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (18, 'lineamientos', 'Lineamientos', 'Proyecto_PACBAO_Ecopetrol', false, '7963d97d-ba67-4c09-8f28-2807f43f9419', 6, '2025-08-28 09:56:44.770768+00', '2025-08-28 09:56:44.770787+00', 3);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (19, 'meta_conservacion', 'Meta Conservación', 'Proyecto_PACBAO_Ecopetrol', false, '4cd64685-b856-42b7-a6ce-c4446abb36d3', 7, '2025-08-28 09:56:44.773703+00', '2025-08-28 09:56:44.773724+00', 3);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (20, 'unicidad', 'Unicidad', 'Proyecto_PACBAO_Ecopetrol', false, '9c0dc2c7-6919-400d-998e-265624c7e781', 8, '2025-08-28 09:56:44.776054+00', '2025-08-28 09:56:44.776071+00', 3);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (21, 'unidades_analisis', 'Unidades de Análisis', 'Proyecto_PACBAO_Ecopetrol', false, 'f6f304bd-a5f0-450c-a836-d30b12acbaff', 9, '2025-08-28 09:56:44.778159+00', '2025-08-28 09:56:44.778173+00', 3);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (29, 'Uso_Sostenible_priorizando_Costos_de_Oportunidad_Compensación', 'Costos de oportunidad-Inversión en compensación', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 1, '2025-08-28 09:56:44.81079+00', '2025-08-28 09:56:44.810806+00', 6);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (30, 'Uso_Sostenible_priorizando_Costos_Abióticos_Compensación', 'Costos ecológicos-Inversión en compensación', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 2, '2025-08-28 09:56:44.812702+00', '2025-08-28 09:56:44.812715+00', 6);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (34, 'Restauración_priorizando_todos_los_enfoques_Compensación', 'Todos los enfoques de costos-Inversión en compensación', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 0, '2025-08-29 10:38:38.773699+00', '2025-08-29 10:38:38.773715+00', 8);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (35, 'Restauración_priorizando_Costos_de_Oportunidad_Compensación', 'Costos de oportunidad-Inversión en compensación', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 1, '2025-08-29 10:38:38.775366+00', '2025-08-29 10:38:38.775374+00', 8);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (36, 'Restauración_priorizando_Costos_Abióticos_Compensación', 'Costos ecológicos-Inversión en compensación', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 2, '2025-08-29 10:38:38.7766+00', '2025-08-29 10:38:38.776608+00', 8);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (37, 'Uso_Sostenible_priorizando_todos_los_enfoques_Compensación', 'Todos los enfoques de costos-Inversión en compensación', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 0, '2025-08-29 10:38:38.778874+00', '2025-08-29 10:38:38.778882+00', 9);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (38, 'Uso_Sostenible_priorizando_Costos_de_Oportunidad_Compensación', 'Costos de oportunidad-Inversión en compensación', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 1, '2025-08-29 10:38:38.779899+00', '2025-08-29 10:38:38.779906+00', 9);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (39, 'Uso_Sostenible_priorizando_Costos_Abióticos_Compensación', 'Costos ecológicos-Inversión en compensación', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 2, '2025-08-29 10:38:38.780942+00', '2025-08-29 10:38:38.780948+00', 9);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (40, 'Preservación_priorizando_todos_los_enfoques_Inversión_Voluntaria', 'Todos los enfoques de costos-Inversiones voluntarias', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 0, '2025-08-29 10:38:38.782897+00', '2025-08-29 10:38:38.782903+00', 10);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (41, 'Preservación_riorizando_Costos_de_Oportunidad_Inversión_Voluntaria', 'Costos de oportunidad-Inversiones voluntarias', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 1, '2025-08-29 10:38:38.783828+00', '2025-08-29 10:38:38.783834+00', 10);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (1, 'aicas', 'AICAS', 'Historicos', false, '09ee583d-d397-4eb8-99df-92bb6f0d0c4c', 1, '2025-08-28 09:56:44.735126+00', '2025-08-30 12:29:15.846382+00', 1);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (22, 'Preservación_priorizando_todos_los_enfoques_Inversión_no_menos_1_', 'Todos los enfoques de costos-Inversión en compensación', 'ecoreservas', true, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 0, '2025-08-28 09:56:44.784294+00', '2025-08-28 09:56:44.784312+00', 4);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (23, 'Preservación_priorizando_Costos_de_Oportunidad_Inversión_no_menos_1_', 'Costos de oportunidad-Inversión en compensación', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 1, '2025-08-28 09:56:44.788028+00', '2025-08-28 09:56:44.788049+00', 4);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (32, 'Preservación_priorizando_Costos_de_Oportunidad_Inversión_no_menos_1_', 'Costos de oportunidad-Inversión en compensación', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 1, '2025-08-29 10:38:38.767952+00', '2025-08-29 10:38:38.767959+00', 7);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (24, 'Preservación_priorizando_Costos_Abióticos_Inversión_no_menos_1_', 'Costos ecológicos-Inversión en compensación', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 2, '2025-08-28 09:56:44.791435+00', '2025-08-28 09:56:44.791462+00', 4);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (33, 'Preservación_priorizando_Costos_Abióticos_Inversión_no_menos_1_', 'Costos ecológicos-Inversión en compensación', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 2, '2025-08-29 10:38:38.769823+00', '2025-08-29 10:38:38.769835+00', 7);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (42, 'Preservación_priorizando_Costos_Abióticos_Inversión_Voluntaria', 'Costos ecológicos-Inversiones voluntarias', 'ecoreservas', false, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 2, '2025-08-29 10:38:38.784725+00', '2025-08-29 10:38:38.784731+00', 10);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (28, 'Uso_Sostenible_priorizando_todos_los_enfoques_Compensación', 'Todos los enfoques de costos-Inversión en compensación', 'ecoreservas', true, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 0, '2025-08-28 09:56:44.80881+00', '2025-08-30 12:21:19.913912+00', 6);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (31, 'Preservación_priorizando_todos_los_enfoques_Inversión_no_menos_1_', 'Todos los enfoques de costos-Inversión en compensación', 'ecoreservas', true, '4eca511b-d4db-49bc-8efa-a1f20e7c45ac', 0, '2025-08-29 10:38:38.766469+00', '2025-08-29 10:38:38.766479+00', 7);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (44, 'dpto_politico', 'Departamentos', 'Capas_Base', false, NULL, 1, '2025-09-01 12:36:04.048751+00', '2025-09-01 12:36:04.04876+00', 13);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (45, 'mpio_politico', 'Municipios', 'Capas_Base', false, NULL, 2, '2025-09-01 12:36:04.050626+00', '2025-09-01 12:36:04.050635+00', 13);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (54, 'paramo', 'Paramos', 'gefparamos', false, NULL, 1, '2025-09-01 12:36:04.059958+00', '2025-09-01 12:44:23.845853+00', 17);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (55, 'municipio', 'Municipios', 'gefparamos', false, NULL, 2, '2025-09-01 12:36:04.060893+00', '2025-09-01 12:44:23.84885+00', 17);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (56, 'procesos_gobernanza', 'Posibles procesos de gobernanza', 'Gobernanza', false, 'a6fcfe1b-11e8-4383-a38e-a7f0035dece5', 1, '2025-09-03 10:35:08.476303+00', '2025-09-03 10:35:08.476303+00', 18);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (57, 'coberturas_bo_2009_2010', 'Cobertura Bo', 'Proyecto_oleoducto_bicentenario', false, '008150a7-4ee9-488a-9ac0-354d678b4b8e', 1, '2025-09-03 10:35:46.655564+00', '2025-09-03 10:44:25.657441+00', 19);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (58, 'scen_mincost_target3', 'Escenario mínimo costo target 3', 'weplan', false, '1d6b06b6-8a57-4c87-97ef-e156cb40dc46', 5, '2025-09-06 11:44:26.86259+00', '2025-09-07 12:50:14.408629+00', 5);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (60, 'scen_mincost_target4', 'Escenario mínimo costo target 4', 'weplan', false, '1d6b06b6-8a57-4c87-97ef-e156cb40dc46', 6, '2025-09-06 11:44:26.86259+00', '2025-09-07 12:50:14.408629+00', 5);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (61, 'scen_mincost_target1', 'Escenario mínimo costo target 1', 'weplan', false, '1d6b06b6-8a57-4c87-97ef-e156cb40dc46', 3, '2025-09-06 11:44:26.86259+00', '2025-09-07 12:50:14.408629+00', 5);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (63, 'scen_mincost_target2', 'Escenario mínimo costo target 2', 'weplan', false, '1d6b06b6-8a57-4c87-97ef-e156cb40dc46', 4, '2025-09-06 11:44:26.86259+00', '2025-09-07 12:50:14.408629+00', 5);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (59, 'integr_total4326', 'Integridad', 'restauracion', false, '55d29ef5-e419-489f-a450-3299e4bcc4d4', 1, '2025-09-06 11:44:26.86259+00', '2025-09-07 12:58:46.149877+00', 5);
INSERT INTO django.layers (id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, metadata_id, orden, created_at, updated_at, grupo_id) VALUES (62, 'red_viveros', 'Red Viveros', 'visor', false, NULL, 2, '2025-09-06 11:44:26.86259+00', '2025-09-07 12:58:46.149877+00', 5);


--
-- Name: layers_id_seq; Type: SEQUENCE SET; Schema: django; Owner: i2d_user
--

SELECT pg_catalog.setval('django.layers_id_seq', 63, true);


--
-- Name: layers layers_pkey; Type: CONSTRAINT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.layers
    ADD CONSTRAINT layers_pkey PRIMARY KEY (id);


--
-- Name: layers_grupo_id_2a2fbe40; Type: INDEX; Schema: django; Owner: i2d_user
--

CREATE INDEX layers_grupo_id_2a2fbe40 ON django.layers USING btree (grupo_id);


--
-- Name: layers layers_grupo_id_2a2fbe40_fk_layer_groups_id; Type: FK CONSTRAINT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.layers
    ADD CONSTRAINT layers_grupo_id_2a2fbe40_fk_layer_groups_id FOREIGN KEY (grupo_id) REFERENCES django.layer_groups(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

\unrestrict yXGXIUGOU3nmwFVe3ttdvCUngTOryHepiZPgQ4KPeYVdickLQfeLpb5QkYSjw4l

