--
-- PostgreSQL database dump
--

\restrict 4IZAJdLwBdho2J3g2HDm7s9VZihT1OppOVe7K2mDdzAIGRFe3izfr9JzNnG6m38

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
-- Name: projects; Type: TABLE; Schema: django; Owner: i2d_user
--

CREATE TABLE django.projects (
    id integer NOT NULL,
    nombre_corto character varying(50) NOT NULL,
    nombre character varying(200) NOT NULL,
    logo_pequeno_url character varying(200),
    logo_completo_url character varying(200),
    nivel_zoom double precision NOT NULL,
    coordenada_central_x double precision NOT NULL,
    coordenada_central_y double precision NOT NULL,
    panel_visible boolean NOT NULL,
    base_map_visible character varying(50) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE django.projects OWNER TO i2d_user;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: django; Owner: i2d_user
--

CREATE SEQUENCE django.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE django.projects_id_seq OWNER TO i2d_user;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: django; Owner: i2d_user
--

ALTER SEQUENCE django.projects_id_seq OWNED BY django.projects.id;


--
-- Name: projects id; Type: DEFAULT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.projects ALTER COLUMN id SET DEFAULT nextval('django.projects_id_seq'::regclass);


--
-- Data for Name: projects; Type: TABLE DATA; Schema: django; Owner: i2d_user
--

INSERT INTO django.projects (id, nombre_corto, nombre, logo_pequeno_url, logo_completo_url, nivel_zoom, coordenada_central_x, coordenada_central_y, panel_visible, base_map_visible, created_at, updated_at) VALUES (1, 'general', 'Visor General I2D', NULL, NULL, 6, -8113332, 464737, true, 'streetmap', '2025-08-28 09:56:44.724483+00', '2025-08-28 09:56:44.724501+00');
INSERT INTO django.projects (id, nombre_corto, nombre, logo_pequeno_url, logo_completo_url, nivel_zoom, coordenada_central_x, coordenada_central_y, panel_visible, base_map_visible, created_at, updated_at) VALUES (2, 'ecoreservas', 'Ecoreservas', NULL, NULL, 9.2, -8249332, 544737, true, 'cartodb_positron', '2025-08-28 09:56:44.727968+00', '2025-08-28 09:56:44.727982+00');
INSERT INTO django.projects (id, nombre_corto, nombre, logo_pequeno_url, logo_completo_url, nivel_zoom, coordenada_central_x, coordenada_central_y, panel_visible, base_map_visible, created_at, updated_at) VALUES (3, 'ecopetrol', 'Ecopetrol', 'https://www.w3schools.com/images/w3schools_green.jpg', 'https://www.w3schools.com/images/w3schools_green.jpg', 1, -8249332, 544737, true, 'terrain', '2025-08-30 12:38:12.330991+00', '2025-08-30 12:41:44.676604+00');


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: django; Owner: i2d_user
--

SELECT pg_catalog.setval('django.projects_id_seq', 3, true);


--
-- Name: projects projects_nombre_corto_key; Type: CONSTRAINT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.projects
    ADD CONSTRAINT projects_nombre_corto_key UNIQUE (nombre_corto);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects_nombre_corto_bc2a7840_like; Type: INDEX; Schema: django; Owner: i2d_user
--

CREATE INDEX projects_nombre_corto_bc2a7840_like ON django.projects USING btree (nombre_corto varchar_pattern_ops);


--
-- PostgreSQL database dump complete
--

\unrestrict 4IZAJdLwBdho2J3g2HDm7s9VZihT1OppOVe7K2mDdzAIGRFe3izfr9JzNnG6m38

