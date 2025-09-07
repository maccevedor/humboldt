--
-- PostgreSQL database dump
--

\restrict ichQ2SDYGl81LnczVH85WBQpCSaIe3dnw9judKUafiyKL8X5CYHBDfmU9gotg0w

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
-- Name: default_layers; Type: TABLE; Schema: django; Owner: i2d_user
--

CREATE TABLE django.default_layers (
    id integer NOT NULL,
    visible_inicial boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    layer_id integer NOT NULL,
    proyecto_id integer NOT NULL
);


ALTER TABLE django.default_layers OWNER TO i2d_user;

--
-- Name: default_layers_id_seq; Type: SEQUENCE; Schema: django; Owner: i2d_user
--

CREATE SEQUENCE django.default_layers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE django.default_layers_id_seq OWNER TO i2d_user;

--
-- Name: default_layers_id_seq; Type: SEQUENCE OWNED BY; Schema: django; Owner: i2d_user
--

ALTER SEQUENCE django.default_layers_id_seq OWNED BY django.default_layers.id;


--
-- Name: default_layers id; Type: DEFAULT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.default_layers ALTER COLUMN id SET DEFAULT nextval('django.default_layers_id_seq'::regclass);


--
-- Data for Name: default_layers; Type: TABLE DATA; Schema: django; Owner: i2d_user
--

INSERT INTO django.default_layers (id, visible_inicial, created_at, layer_id, proyecto_id) VALUES (1, true, '2025-08-30 12:28:01.43029+00', 1, 1);


--
-- Name: default_layers_id_seq; Type: SEQUENCE SET; Schema: django; Owner: i2d_user
--

SELECT pg_catalog.setval('django.default_layers_id_seq', 1, true);


--
-- Name: default_layers default_layers_pkey; Type: CONSTRAINT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.default_layers
    ADD CONSTRAINT default_layers_pkey PRIMARY KEY (id);


--
-- Name: default_layers default_layers_proyecto_id_layer_id_c7e1f97d_uniq; Type: CONSTRAINT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.default_layers
    ADD CONSTRAINT default_layers_proyecto_id_layer_id_c7e1f97d_uniq UNIQUE (proyecto_id, layer_id);


--
-- Name: default_layers_layer_id_a8542097; Type: INDEX; Schema: django; Owner: i2d_user
--

CREATE INDEX default_layers_layer_id_a8542097 ON django.default_layers USING btree (layer_id);


--
-- Name: default_layers_proyecto_id_208af11b; Type: INDEX; Schema: django; Owner: i2d_user
--

CREATE INDEX default_layers_proyecto_id_208af11b ON django.default_layers USING btree (proyecto_id);


--
-- Name: default_layers default_layers_layer_id_a8542097_fk_layers_id; Type: FK CONSTRAINT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.default_layers
    ADD CONSTRAINT default_layers_layer_id_a8542097_fk_layers_id FOREIGN KEY (layer_id) REFERENCES django.layers(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: default_layers default_layers_proyecto_id_208af11b_fk_projects_id; Type: FK CONSTRAINT; Schema: django; Owner: i2d_user
--

ALTER TABLE ONLY django.default_layers
    ADD CONSTRAINT default_layers_proyecto_id_208af11b_fk_projects_id FOREIGN KEY (proyecto_id) REFERENCES django.projects(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

\unrestrict ichQ2SDYGl81LnczVH85WBQpCSaIe3dnw9judKUafiyKL8X5CYHBDfmU9gotg0w

