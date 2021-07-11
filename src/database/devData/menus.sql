--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

-- Started on 2021-07-11 23:11:38 IST

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
-- TOC entry 202 (class 1259 OID 16829)
-- Name: menus; Type: TABLE; Schema: public; Owner: battlefield
--

CREATE TABLE public.menus (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    image character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.menus OWNER TO battlefield;

--
-- TOC entry 3299 (class 0 OID 16829)
-- Dependencies: 202
-- Data for Name: menus; Type: TABLE DATA; Schema: public; Owner: battlefield
--

INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('ba89d5e2-8204-4426-a8da-3ab53f1b63f6', 'Spicy', false, NULL, '2021-06-17 19:00:35.433413', '2021-06-17 19:00:35.433413');
INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('81302a13-9b4f-4eef-93e4-16798bb1580f', 'CONTINENTAL', true, 'https://images.unsplash.com/photo-1535567465397-7523840f2ae9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1014&q=80', '2021-07-11 20:12:28.559943', '2021-07-11 20:12:28.559943');
INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('532975e4-a104-422c-afdd-4cffe4c62d78', 'INDIAN / THALIS', true, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80', '2021-07-11 20:12:28.577461', '2021-07-11 20:12:28.577461');
INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('be0a9f7b-da91-4728-aac7-e3ae4b95f213', 'SANDWICHES & MORE', true, 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1053&q=80', '2021-07-11 20:12:28.510024', '2021-07-11 20:12:28.510024');
INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('593750cf-33a4-437a-ac70-0d498a3acac8', 'WOK-STATION', true, 'https://images.unsplash.com/photo-1593181520415-5d48196b5ecb?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80', '2021-07-11 20:12:28.552733', '2021-07-11 20:12:28.552733');
INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('3fb8ba79-82b1-49df-9f86-8308601b4f48', 'FRESH BEVERAGES', true, 'https://images.unsplash.com/photo-1560508180-03f285f67ded?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80', '2021-07-11 20:12:28.550379', '2021-07-11 20:12:28.550379');
INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef', 'FRESH DESSERTS', true, 'https://images.unsplash.com/photo-1582716401301-b2407dc7563d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1054&q=80', '2021-07-11 20:12:28.521728', '2021-07-11 20:12:28.521728');
INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('65a11383-1fb6-4cc1-ad57-ce6fbf813c7e', 'BURGERS & WRAPS', true, 'https://images.unsplash.com/photo-1586816001966-79b736744398?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80', '2021-07-11 20:12:28.611257', '2021-07-11 20:12:28.611257');
INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('b81fede0-bc1a-4009-a258-212b957dbdaf', 'FIT N FAB', true, 'https://images.unsplash.com/photo-1577594990850-e843a8e91512?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80', '2021-07-11 20:12:28.612036', '2021-07-11 20:12:28.612036');
INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('fd261909-81e3-4c93-9f65-e4c3922e6b6a', 'LARGE PLATES', true, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1224&q=80', '2021-07-11 20:12:28.618727', '2021-07-11 20:12:28.618727');
INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('3dcc81e4-a728-4a9a-b4e9-4d400fd24344', 'APPETIZERS', true, 'https://images.unsplash.com/photo-1607098665874-fd193397547b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80', '2021-07-11 20:12:28.634821', '2021-07-11 20:12:28.634821');
INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('4df08324-7d8a-4567-843d-adf9b9a443a8', 'FAMILY COMBOS', true, 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=676&q=80', '2021-07-11 20:12:28.662235', '2021-07-11 20:12:28.662235');
INSERT INTO public.menus (id, name, is_active, image, created_at, updated_at) VALUES ('cdbf15d4-c061-4eee-8a8a-4a237f3265d0', 'BIG BIRIYANI CO.', true, 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80', '2021-07-11 20:12:28.663208', '2021-07-11 20:12:28.663208');


--
-- TOC entry 3166 (class 2606 OID 16840)
-- Name: menus PK_3fec3d93327f4538e0cbd4349c4; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT "PK_3fec3d93327f4538e0cbd4349c4" PRIMARY KEY (id);


--
-- TOC entry 3168 (class 2606 OID 16842)
-- Name: menus UQ_a8bb3519a45e021a147bc87e49a; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT "UQ_a8bb3519a45e021a147bc87e49a" UNIQUE (name);


-- Completed on 2021-07-11 23:11:38 IST

--
-- PostgreSQL database dump complete
--

