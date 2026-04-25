--
-- PostgreSQL database cluster dump
--

-- Started on 2025-12-09 13:36:19

\restrict hw03087DlGPonAbxi7N9XjjUMtnx4GREAdnRexFLfABdlqKsuGDml0RyWxNBKGa

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--








\unrestrict hw03087DlGPonAbxi7N9XjjUMtnx4GREAdnRexFLfABdlqKsuGDml0RyWxNBKGa

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict L24QQp2E4r7KxqlIdmqFaDMwkA1VJsTA0CnjasrdLWSZdjPBlkWtC4Ke5JPRT2X

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-12-09 13:36:19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2025-12-09 13:36:19

--
-- PostgreSQL database dump complete
--

\unrestrict L24QQp2E4r7KxqlIdmqFaDMwkA1VJsTA0CnjasrdLWSZdjPBlkWtC4Ke5JPRT2X

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict BOPehjwkiBROazBrIKHW0MrGyJ67hkVlbeYfjOI9STyBBqpZZDUkz73A8Ea5YRN

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-12-09 13:36:19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- TOC entry 228 (class 1259 OID 16446)
-- Name: holidays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.holidays (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    date date,
    note text
);


ALTER TABLE public.holidays OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16445)
-- Name: holidays_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.holidays_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.holidays_id_seq OWNER TO postgres;

--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 227
-- Name: holidays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.holidays_id_seq OWNED BY public.holidays.id;


--
-- TOC entry 236 (class 1259 OID 16506)
-- Name: license_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.license_keys (
    id integer NOT NULL,
    order_id integer,
    user_id integer,
    product_id integer,
    key_value character varying(40) NOT NULL,
    issued_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.license_keys OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16505)
-- Name: license_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.license_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.license_keys_id_seq OWNER TO postgres;

--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 235
-- Name: license_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.license_keys_id_seq OWNED BY public.license_keys.id;


--
-- TOC entry 224 (class 1259 OID 16426)
-- Name: news; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.news (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    summary text,
    date date
);


ALTER TABLE public.news OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16425)
-- Name: news_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.news_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.news_id_seq OWNER TO postgres;

--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 223
-- Name: news_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.news_id_seq OWNED BY public.news.id;


--
-- TOC entry 234 (class 1259 OID 16483)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    quantity integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16482)
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO postgres;

--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 233
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- TOC entry 232 (class 1259 OID 16467)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    total numeric(12,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16466)
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO postgres;

--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 231
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- TOC entry 226 (class 1259 OID 16437)
-- Name: partners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.partners (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.partners OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16436)
-- Name: partners_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.partners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.partners_id_seq OWNER TO postgres;

--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 225
-- Name: partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.partners_id_seq OWNED BY public.partners.id;


--
-- TOC entry 230 (class 1259 OID 16457)
-- Name: price_updates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_updates (
    id integer NOT NULL,
    date date,
    text text
);


ALTER TABLE public.price_updates OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16456)
-- Name: price_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.price_updates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.price_updates_id_seq OWNER TO postgres;

--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 229
-- Name: price_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_updates_id_seq OWNED BY public.price_updates.id;


--
-- TOC entry 222 (class 1259 OID 16411)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    image character varying(255),
    stock integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    genre text
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16410)
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO postgres;

--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 221
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- TOC entry 220 (class 1259 OID 16389)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    balance numeric(12,2) DEFAULT 0.00 NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16388)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4858 (class 2604 OID 16449)
-- Name: holidays id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.holidays ALTER COLUMN id SET DEFAULT nextval('public.holidays_id_seq'::regclass);


--
-- TOC entry 4864 (class 2604 OID 16509)
-- Name: license_keys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.license_keys ALTER COLUMN id SET DEFAULT nextval('public.license_keys_id_seq'::regclass);


--
-- TOC entry 4856 (class 2604 OID 16429)
-- Name: news id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.news ALTER COLUMN id SET DEFAULT nextval('public.news_id_seq'::regclass);


--
-- TOC entry 4862 (class 2604 OID 16486)
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- TOC entry 4860 (class 2604 OID 16470)
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- TOC entry 4857 (class 2604 OID 16440)
-- Name: partners id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.partners ALTER COLUMN id SET DEFAULT nextval('public.partners_id_seq'::regclass);


--
-- TOC entry 4859 (class 2604 OID 16460)
-- Name: price_updates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_updates ALTER COLUMN id SET DEFAULT nextval('public.price_updates_id_seq'::regclass);


--
-- TOC entry 4853 (class 2604 OID 16414)
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- TOC entry 4849 (class 2604 OID 16392)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5053 (class 0 OID 16446)
-- Dependencies: 228
-- Data for Name: holidays; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.holidays (id, name, date, note) FROM stdin;
1	День разработчика	2025-09-13	Спецподборка инди-игр
\.


--
-- TOC entry 5061 (class 0 OID 16506)
-- Dependencies: 236
-- Data for Name: license_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.license_keys (id, order_id, user_id, product_id, key_value, issued_at) FROM stdin;
1	1	1	1	THCSU-XUM2V-9PDU0-EYMVZ-QIG3U	2025-12-06 19:33:59.516548+03
2	2	2	1	20N0S-311U0-VUOXP-C4AIC-IKHZU	2025-12-06 20:50:06.55008+03
3	3	1	4	ESQRU-SVKHR-IX2LV-QYHO8-B4PRL	2025-12-08 19:40:59.135505+03
\.


--
-- TOC entry 5049 (class 0 OID 16426)
-- Dependencies: 224
-- Data for Name: news; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.news (id, title, summary, date) FROM stdin;
1	RV There Yet? анонсирован	Кооперативная аркада добавлена в каталог.	2025-10-01
2	Добавлена новая игра: PEAK	Кооперативная игра про выживание и восхождение	2025-12-07
\.


--
-- TOC entry 5059 (class 0 OID 16483)
-- Dependencies: 234
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, product_id, unit_price, quantity) FROM stdin;
1	1	1	299.00	1
2	2	1	292.00	1
3	3	4	200.00	1
\.


--
-- TOC entry 5057 (class 0 OID 16467)
-- Dependencies: 232
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, user_id, total, created_at) FROM stdin;
1	1	299.00	2025-12-06 19:33:59.516548+03
2	2	292.00	2025-12-06 20:50:06.55008+03
3	1	200.00	2025-12-08 19:40:59.135505+03
\.


--
-- TOC entry 5051 (class 0 OID 16437)
-- Dependencies: 226
-- Data for Name: partners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.partners (id, name) FROM stdin;
1	Партнёр 1
2	Партнёр 2
\.


--
-- TOC entry 5055 (class 0 OID 16457)
-- Dependencies: 230
-- Data for Name: price_updates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_updates (id, date, text) FROM stdin;
2	2025-12-07	Изменена цена игры 'PEAK': была 399.00 ₽, стала 299.00 ₽
3	2025-12-08	Изменена цена игры 'CS2': была 999.00 ₽, стала 888.00 ₽
\.


--
-- TOC entry 5047 (class 0 OID 16411)
-- Dependencies: 222
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, title, description, price, image, stock, created_at, genre) FROM stdin;
5	ARC Raiders	хз	3000.00	img/arcraiders.jpg	5	2025-12-06 20:30:05.236883+03	\N
1	RV There Yet?	Кооперативная аркада про путешествие на автодоме.	292.00	img/rv-there-yet.jpg	9	2025-12-06 19:06:14.067603+03	\N
6	Rematch	футбольчек рака мака фо	1399.00	img/rematch.jpg	23	2025-12-06 20:30:43.753678+03	Спорт
8	Dead by Daylight	беги от маньякича	599.00	img/dbd.jpg	52	2025-12-07 16:10:55.333036+03	horror
9	PEAK	Кооперативная игра про выживание и восхождение	299.00	img/peak.jpg	15	2025-12-07 16:17:15.356174+03	Кооператив
4	Minecraft	песочница	200.00	img/minecraft.jpg	14	2025-12-06 20:28:34.864069+03	\N
3	CS2	Шутер	888.00	img/cs2.jpg	10	2025-12-06 20:23:21.002814+03	\N
\.


--
-- TOC entry 5045 (class 0 OID 16389)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password_hash, balance, is_admin, created_at) FROM stdin;
2	gosha	gosha@mail.ru	scrypt:32768:8:1$wKLKKkepv50a9Xht$5c773385287a93259b8ae8cc565eb3fb1c6d23cf9af940f52a65a98f37db0b5b382976141c7c5da9bfe2e261e7d5c868b8def58c7404b5a4ba0cb0a0c0ef2c04	9708.00	t	2025-12-06 20:05:16.066213+03
1	egor	popkaegora@mail.ru	scrypt:32768:8:1$vqdmsUA1Ivndn0Tc$a5fb825f0fa9f928df73146f220206d7f413b04a9cb5f5dbb07dd2122669aedad16d4d97139ac7b5d4c803b26624bddf50bb8a87d1643a4f74f1bfa6045db682	501.00	f	2025-12-06 19:13:45.473651+03
\.


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 227
-- Name: holidays_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.holidays_id_seq', 1, true);


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 235
-- Name: license_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.license_keys_id_seq', 3, true);


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 223
-- Name: news_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.news_id_seq', 2, true);


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 233
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_id_seq', 3, true);


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 231
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 3, true);


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 225
-- Name: partners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.partners_id_seq', 3, true);


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 229
-- Name: price_updates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.price_updates_id_seq', 3, true);


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 221
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 9, true);


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- TOC entry 4879 (class 2606 OID 16455)
-- Name: holidays holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.holidays
    ADD CONSTRAINT holidays_pkey PRIMARY KEY (id);


--
-- TOC entry 4888 (class 2606 OID 16516)
-- Name: license_keys license_keys_key_value_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.license_keys
    ADD CONSTRAINT license_keys_key_value_key UNIQUE (key_value);


--
-- TOC entry 4890 (class 2606 OID 16514)
-- Name: license_keys license_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.license_keys
    ADD CONSTRAINT license_keys_pkey PRIMARY KEY (id);


--
-- TOC entry 4875 (class 2606 OID 16435)
-- Name: news news_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.news
    ADD CONSTRAINT news_pkey PRIMARY KEY (id);


--
-- TOC entry 4885 (class 2606 OID 16494)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4883 (class 2606 OID 16476)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 4877 (class 2606 OID 16444)
-- Name: partners partners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.partners
    ADD CONSTRAINT partners_pkey PRIMARY KEY (id);


--
-- TOC entry 4881 (class 2606 OID 16465)
-- Name: price_updates price_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_updates
    ADD CONSTRAINT price_updates_pkey PRIMARY KEY (id);


--
-- TOC entry 4873 (class 2606 OID 16424)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 4867 (class 2606 OID 16409)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4869 (class 2606 OID 16405)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4871 (class 2606 OID 16407)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4886 (class 1259 OID 16532)
-- Name: idx_license_keys_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_license_keys_key ON public.license_keys USING btree (key_value);


--
-- TOC entry 4894 (class 2606 OID 16517)
-- Name: license_keys license_keys_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.license_keys
    ADD CONSTRAINT license_keys_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE SET NULL;


--
-- TOC entry 4895 (class 2606 OID 16527)
-- Name: license_keys license_keys_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.license_keys
    ADD CONSTRAINT license_keys_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- TOC entry 4896 (class 2606 OID 16522)
-- Name: license_keys license_keys_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.license_keys
    ADD CONSTRAINT license_keys_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 4892 (class 2606 OID 16495)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- TOC entry 4893 (class 2606 OID 16500)
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 4891 (class 2606 OID 16477)
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2025-12-09 13:36:19

--
-- PostgreSQL database dump complete
--

\unrestrict BOPehjwkiBROazBrIKHW0MrGyJ67hkVlbeYfjOI9STyBBqpZZDUkz73A8Ea5YRN

-- Completed on 2025-12-09 13:36:19

--
-- PostgreSQL database cluster dump complete
--

