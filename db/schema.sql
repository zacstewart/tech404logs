--
-- PostgreSQL database dump
--

-- Dumped from database version 13.6
-- Dumped by pg_dump version 13.6

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
-- Name: channels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.channels (
    id character varying(50) NOT NULL,
    name character varying(50),
    creator_id character varying(50),
    member boolean
);


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    channel_id character varying(50),
    user_id character varying(50),
    text text,
    "timestamp" timestamp without time zone
);


--
-- Name: migration_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migration_info (
    migration_name character varying(255)
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id character varying(50) NOT NULL,
    name character varying(50),
    real_name character varying(50),
    image character varying(255),
    opted_out boolean DEFAULT false NOT NULL
);


--
-- Name: searchable_messages; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.searchable_messages AS
 SELECT messages.id,
    messages.channel_id,
    messages.user_id,
    messages.text,
    messages."timestamp",
    channels.name AS channel_name,
    users.image AS user_image,
    users.real_name AS user_real_name,
    users.name AS user_name,
    to_tsvector(((((((messages.text || ' '::text) || (channels.name)::text) || ' '::text) || (users.real_name)::text) || ' '::text) || (users.name)::text)) AS tsv
   FROM ((public.messages
     JOIN public.users ON (((messages.user_id)::text = (users.id)::text)))
     JOIN public.channels ON (((messages.channel_id)::text = (channels.id)::text)))
  WITH NO DATA;


--
-- Name: tech404_index_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tech404_index_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tech404_index_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tech404_index_messages_id_seq OWNED BY public.messages.id;


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.tech404_index_messages_id_seq'::regclass);


--
-- Name: migration_info migration_info_migration_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migration_info
    ADD CONSTRAINT migration_info_migration_name_key UNIQUE (migration_name);


--
-- Name: channels tech404_index_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT tech404_index_channels_pkey PRIMARY KEY (id);


--
-- Name: messages tech404_index_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT tech404_index_messages_pkey PRIMARY KEY (id);


--
-- Name: users tech404_index_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT tech404_index_users_pkey PRIMARY KEY (id);


--
-- Name: messages_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX messages_channel_id ON public.messages USING btree (channel_id);


--
-- Name: searchable_messages_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX searchable_messages_tsv ON public.searchable_messages USING gin (tsv);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.6
-- Dumped by pg_dump version 13.6

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

--
-- Data for Name: migration_info; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.migration_info (migration_name) FROM stdin;
starting_point
rename_channels_table
rename_messages_table
rename_users_table
add_index_to_messages
add_fulltext_index_to_messages
add_opted_out_to_users
\.


--
-- PostgreSQL database dump complete
--

