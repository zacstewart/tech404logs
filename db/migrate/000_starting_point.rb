# Prior to this migration, databases were created and auto-upgraded by
# datamapper
STARTING_POINT = <<-SQL
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.4

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
-- Name: tech404_index_channels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tech404_index_channels (
    id character varying(50) NOT NULL,
    name character varying(50),
    creator_id character varying(50),
    member boolean
);


--
-- Name: tech404_index_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tech404_index_messages (
    id integer NOT NULL,
    channel_id character varying(50),
    user_id character varying(50),
    text text,
    "timestamp" timestamp without time zone
);


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

ALTER SEQUENCE public.tech404_index_messages_id_seq OWNED BY public.tech404_index_messages.id;


--
-- Name: tech404_index_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tech404_index_users (
    id character varying(50) NOT NULL,
    name character varying(50),
    real_name character varying(50),
    image character varying(255)
);


--
-- Name: tech404_index_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tech404_index_messages ALTER COLUMN id SET DEFAULT nextval('public.tech404_index_messages_id_seq'::regclass);


--
-- Name: tech404_index_channels tech404_index_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tech404_index_channels
    ADD CONSTRAINT tech404_index_channels_pkey PRIMARY KEY (id);


--
-- Name: tech404_index_messages tech404_index_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tech404_index_messages
    ADD CONSTRAINT tech404_index_messages_pkey PRIMARY KEY (id);


--
-- Name: tech404_index_users tech404_index_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tech404_index_users
    ADD CONSTRAINT tech404_index_users_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

SQL

migration 0, :starting_point do
  up do
    execute STARTING_POINT
  end

  down do
    drop_table :tech404logs_channels
    drop table :tech404logs_messages
    drop_table :tech404logs_users
  end
end
