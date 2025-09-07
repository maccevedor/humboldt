--
-- PostgreSQL database dump
--

\restrict q1UZjwwgUQYV8daH7KK4I2zofg1dU3Ih3rrhJZd9cuNkjlJ9Th5pcWzVO42MtoG

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
-- Name: layer_groups; Type: TABLE; Schema: django; Owner: i2d_user
--

CREATE TABLE django.layer_groups (
    id integer NOT NULL,
    nombre character varying(200) NOT NULL,
    orden integer NOT NULL,
    fold_state character varying(10) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    parent_group_id integer,
    proyecto_id integer NOT NULL
);


ALTER TABLE django.layer_groups OWNER TO i2d_user;

--
-- Name: layer_groups_id_seq; Type: SEQUENCE; Schema: django; Owner: i2d_user
--

CREATE SEQUENCE django.layer_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE django.layer_groups_id_seq OWNER TO i2d_user;

--
-- Name: layer_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: django; Owner: i2d_user
--

ALTER SEQUENCE django.layer_groups_id_seq OWNED BY django.layer_groups.id;


--
-- Name: layer_groups id; Type: DEFAULT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.layer_groups ALTER COLUMN id SET DEFAULT nextval('django.layer_groups_id_seq'::regclass);


--
-- Data for Name: layer_groups; Type: TABLE DATA; Schema: django; Owner: i2d_user
--

INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (1, 'Historicos', 1, 'close', '2025-08-28 09:56:44.731155+00', '2025-08-28 09:56:44.731169+00', NULL, 1);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (2, 'Fondo de adaptación', 2, 'close', '2025-08-28 09:56:44.750456+00', '2025-08-28 09:56:44.750465+00', NULL, 1);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (3, 'Conservación de la Biodiversidad', 3, 'close', '2025-08-28 09:56:44.756558+00', '2025-08-28 09:56:44.756579+00', NULL, 1);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (4, 'Preservación', 1, 'close', '2025-08-28 09:56:44.780646+00', '2025-08-28 09:56:44.780674+00', NULL, 2);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (6, 'Uso Sostenible', 3, 'close', '2025-08-28 09:56:44.807058+00', '2025-08-28 09:56:44.807071+00', NULL, 2);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (7, 'Preservación - Compensación', 1, 'close', '2025-08-29 10:38:38.764438+00', '2025-08-29 10:38:38.76445+00', NULL, 2);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (8, 'Restauración - Compensación', 2, 'close', '2025-08-29 10:38:38.771773+00', '2025-08-29 10:38:38.771786+00', NULL, 2);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (9, 'Uso Sostenible - Compensación', 3, 'close', '2025-08-29 10:38:38.777714+00', '2025-08-29 10:38:38.777721+00', NULL, 2);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (10, 'Preservación - Inversión Voluntaria', 4, 'close', '2025-08-29 10:38:38.781907+00', '2025-08-29 10:38:38.781913+00', NULL, 2);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (11, 'TestIcas', 0, 'close', '2025-08-30 12:30:41.708913+00', '2025-08-30 12:30:41.708931+00', 1, 1);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (13, 'División político-administrativa', 1, 'close', '2025-09-01 12:36:04.042266+00', '2025-09-01 12:36:04.042279+00', NULL, 1);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (17, 'GEF Páramos', 8, 'close', '2025-09-01 12:36:04.04685+00', '2025-09-01 12:36:04.046857+00', NULL, 1);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (18, 'Gobernanza', 4, 'close', '2025-09-03 10:35:08.476303+00', '2025-09-03 10:35:08.476303+00', NULL, 1);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (19, 'Proyecto Oleoducto Bicentenario', 5, 'close', '2025-09-03 10:35:08.476303+00', '2025-09-03 10:35:08.476303+00', NULL, 1);
INSERT INTO django.layer_groups (id, nombre, orden, fold_state, created_at, updated_at, parent_group_id, proyecto_id) VALUES (5, 'Restauración', 2, 'close', '2025-08-28 09:56:44.794647+00', '2025-09-04 10:59:17.891988+00', NULL, 1);


--
-- Name: layer_groups_id_seq; Type: SEQUENCE SET; Schema: django; Owner: i2d_user
--

SELECT pg_catalog.setval('django.layer_groups_id_seq', 19, true);


--
-- Name: layer_groups layer_groups_pkey; Type: CONSTRAINT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.layer_groups
    ADD CONSTRAINT layer_groups_pkey PRIMARY KEY (id);


--
-- Name: layer_groups_parent_group_id_8c583396; Type: INDEX; Schema: django; Owner: i2d_user
--

CREATE INDEX layer_groups_parent_group_id_8c583396 ON django.layer_groups USING btree (parent_group_id);


--
-- Name: layer_groups_proyecto_id_e91c04e9; Type: INDEX; Schema: django; Owner: i2d_user
--

CREATE INDEX layer_groups_proyecto_id_e91c04e9 ON django.layer_groups USING btree (proyecto_id);


--
-- Name: layer_groups layer_groups_parent_group_id_8c583396_fk_layer_groups_id; Type: FK CONSTRAINT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.layer_groups
    ADD CONSTRAINT layer_groups_parent_group_id_8c583396_fk_layer_groups_id FOREIGN KEY (parent_group_id) REFERENCES django.layer_groups(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: layer_groups layer_groups_proyecto_id_e91c04e9_fk_projects_id; Type: FK CONSTRAINT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.layer_groups
    ADD CONSTRAINT layer_groups_proyecto_id_e91c04e9_fk_projects_id FOREIGN KEY (proyecto_id) REFERENCES django.projects(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

\unrestrict q1UZjwwgUQYV8daH7KK4I2zofg1dU3Ih3rrhJZd9cuNkjlJ9Th5pcWzVO42MtoG

