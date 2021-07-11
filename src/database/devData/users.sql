--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

-- Started on 2021-07-11 23:04:24 IST

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
-- TOC entry 201 (class 1259 OID 16815)
-- Name: users; Type: TABLE; Schema: public; Owner: battlefield
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    first_name character varying(64) NOT NULL,
    last_name character varying(64),
    email character varying(100) NOT NULL,
    password character varying NOT NULL,
    date_of_birth timestamp with time zone,
    role public.users_role_enum DEFAULT 'customer'::public.users_role_enum NOT NULL,
    address character varying(255),
    avatar character varying(512),
    password_reset_token character varying,
    password_reset_request_at timestamp without time zone,
    password_reset_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    current_hashed_refresh_token character varying
);


ALTER TABLE public.users OWNER TO battlefield;

--
-- TOC entry 3299 (class 0 OID 16815)
-- Dependencies: 201
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: battlefield
--

INSERT INTO public.users (id, first_name, last_name, email, password, date_of_birth, role, address, avatar, password_reset_token, password_reset_request_at, password_reset_at, created_at, updated_at, current_hashed_refresh_token) VALUES ('0cec9878-d83e-4b89-8b0f-614231c7c88c', 'Margot', 'Leuschke', 'cashier@cafe.com', '$2b$10$ISe1bpdHo0DzweW6hMo43OwOh72I4h8vj2XANV3oDVClS9m.LF0PG', '1959-11-03 05:06:43.355+05:30', 'cashier', 'Abagail Via,Apt. 658,Hiramfurt,96863', 'https://cdn.fakercloud.com/avatars/victorstuber_128.jpg', NULL, NULL, NULL, '2021-07-11 13:11:27.164373', '2021-07-11 13:11:27.164373', NULL);
INSERT INTO public.users (id, first_name, last_name, email, password, date_of_birth, role, address, avatar, password_reset_token, password_reset_request_at, password_reset_at, created_at, updated_at, current_hashed_refresh_token) VALUES ('1ad5685f-f13d-4d08-a09e-abeacb62c317', 'Kaci', 'Ledner', 'chef@cafe.com', '$2b$10$0clzMVDpn5N9iJS/rFjzI.BQcTMferpJT5ZlIpyWmKCInQhiX9teG', '1950-03-12 04:58:09.435+05:30', 'chef', 'Barton Glen,Apt. 187,Schoenshire,55202-5982', 'https://cdn.fakercloud.com/avatars/daniloc_128.jpg', NULL, NULL, NULL, '2021-07-11 13:11:27.165109', '2021-07-11 13:11:27.165109', NULL);
INSERT INTO public.users (id, first_name, last_name, email, password, date_of_birth, role, address, avatar, password_reset_token, password_reset_request_at, password_reset_at, created_at, updated_at, current_hashed_refresh_token) VALUES ('ae6d9802-eb0b-4e41-99c4-f64811674f53', 'Peggie', 'Mayert', 'manager@cafe.com', '$2b$10$sGUaBgN/qF0Yuk3/9VrL4OHaTfkMBWPN7NMhHy2zeCJ.JtqqEFUcO', '1975-07-28 14:07:18.967+05:30', 'manager', 'Beahan Row,Apt. 426,Waukegan,33900-3107', 'https://cdn.fakercloud.com/avatars/manekenthe_128.jpg', NULL, NULL, NULL, '2021-07-11 13:11:27.164021', '2021-07-11 13:11:27.164021', NULL);
INSERT INTO public.users (id, first_name, last_name, email, password, date_of_birth, role, address, avatar, password_reset_token, password_reset_request_at, password_reset_at, created_at, updated_at, current_hashed_refresh_token) VALUES ('ba299f83-ce53-4173-b0ec-d7274a0df1fd', 'Edison', 'McLaughlin', 'waiter@cafe.com', '$2b$10$RldrSKNlGt13Knsn8nm3xOOyw0va80NAVuinhuURC78NTHOGm5Qiq', '1980-10-25 00:10:01.187+05:30', 'waiter', 'Milford Cove,Suite 167,Hodkiewiczburgh,33847', 'https://cdn.fakercloud.com/avatars/curiousonaut_128.jpg', NULL, NULL, NULL, '2021-07-11 13:11:27.216591', '2021-07-11 13:11:27.216591', NULL);
INSERT INTO public.users (id, first_name, last_name, email, password, date_of_birth, role, address, avatar, password_reset_token, password_reset_request_at, password_reset_at, created_at, updated_at, current_hashed_refresh_token) VALUES ('baa0ea26-689c-41e3-b156-686124bc555a', 'Thea', 'MacGyver', 'admin@cafe.com', '$2b$10$iCamTRDjYNaA6QnRBE6uBebe53onjBSDAoVtlMpYcV.947YT2WTre', '1975-05-26 01:38:02.187+05:30', 'admin', 'Conroy Port,Apt. 274,West Wilma,06107', 'https://cdn.fakercloud.com/avatars/badlittleduck_128.jpg', NULL, NULL, NULL, '2021-07-11 13:11:27.164783', '2021-07-11 13:11:27.164783', NULL);
INSERT INTO public.users (id, first_name, last_name, email, password, date_of_birth, role, address, avatar, password_reset_token, password_reset_request_at, password_reset_at, created_at, updated_at, current_hashed_refresh_token) VALUES ('46b695be-07fe-4ad5-8139-510516d4395d', 'Alaina', 'Bernhard', 'customer@cafe.com', '$2b$10$9AEdet3HyXN6gmKl52QeBOVsCx2pwGzO8dhBY/we9PfQDy/q.1fcC', '1989-11-17 01:21:56.543+05:30', 'customer', 'Clark Fort,Suite 717,Cruickshankborough,41332', 'https://cdn.fakercloud.com/avatars/ah_lice_128.jpg', NULL, NULL, NULL, '2021-07-11 13:11:27.216937', '2021-07-11 13:11:27.216937', NULL);
INSERT INTO public.users (id, first_name, last_name, email, password, date_of_birth, role, address, avatar, password_reset_token, password_reset_request_at, password_reset_at, created_at, updated_at, current_hashed_refresh_token) VALUES ('47752669-d9b2-4e21-b2e0-e49c0befbbb2', 'Admin', NULL, 'admin@admin.com', '$2b$10$gInqu7iFNSKpaKCBc4D1iuwZZNt7I7JnxeYHU2Sz.b3eZtNyp6NNa', NULL, 'admin', NULL, 'https://uifaces.co/our-content/donated/gPZwCbdS.jpg', NULL, NULL, '2021-07-08 23:03:37.347', '2021-06-17 15:01:14.104922', '2021-07-11 22:57:31.477682', '$2b$10$9agZQU0CIILT5Z2BS3QJr.i/VuXZiywrhm6jK09hdgwKbcMaGHGQS');


--
-- TOC entry 3166 (class 2606 OID 16826)
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- TOC entry 3168 (class 2606 OID 16828)
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


-- Completed on 2021-07-11 23:04:24 IST

--
-- PostgreSQL database dump complete
--

