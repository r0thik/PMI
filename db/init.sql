

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    balance numeric(12,2) DEFAULT 0.00 NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE users_id_seq OWNED BY users.id;

CREATE TABLE products (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    image character varying(255),
    stock integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    genre text
);

CREATE SEQUENCE products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE products_id_seq OWNED BY products.id;

CREATE TABLE news (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    summary text,
    date date
);

CREATE SEQUENCE news_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE news_id_seq OWNED BY news.id;

CREATE TABLE partners (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);

CREATE SEQUENCE partners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE partners_id_seq OWNED BY partners.id;

CREATE TABLE holidays (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    date date,
    note text
);

CREATE SEQUENCE holidays_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE holidays_id_seq OWNED BY holidays.id;

CREATE TABLE price_updates (
    id integer NOT NULL,
    date date,
    text text
);

CREATE SEQUENCE price_updates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE price_updates_id_seq OWNED BY price_updates.id;

CREATE TABLE orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    total numeric(12,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;

CREATE TABLE order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    quantity integer DEFAULT 1 NOT NULL
);

CREATE SEQUENCE order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE order_items_id_seq OWNED BY order_items.id;

CREATE TABLE license_keys (
    id integer NOT NULL,
    order_id integer,
    user_id integer,
    product_id integer,
    key_value character varying(40) NOT NULL,
    issued_at timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE license_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE license_keys_id_seq OWNED BY license_keys.id;

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);
ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);
ALTER TABLE ONLY news ALTER COLUMN id SET DEFAULT nextval('news_id_seq'::regclass);
ALTER TABLE ONLY partners ALTER COLUMN id SET DEFAULT nextval('partners_id_seq'::regclass);
ALTER TABLE ONLY holidays ALTER COLUMN id SET DEFAULT nextval('holidays_id_seq'::regclass);
ALTER TABLE ONLY price_updates ALTER COLUMN id SET DEFAULT nextval('price_updates_id_seq'::regclass);
ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);
ALTER TABLE ONLY order_items ALTER COLUMN id SET DEFAULT nextval('order_items_id_seq'::regclass);
ALTER TABLE ONLY license_keys ALTER COLUMN id SET DEFAULT nextval('license_keys_id_seq'::regclass);

ALTER TABLE ONLY users ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY products ADD CONSTRAINT products_pkey PRIMARY KEY (id);
ALTER TABLE ONLY news ADD CONSTRAINT news_pkey PRIMARY KEY (id);
ALTER TABLE ONLY partners ADD CONSTRAINT partners_pkey PRIMARY KEY (id);
ALTER TABLE ONLY holidays ADD CONSTRAINT holidays_pkey PRIMARY KEY (id);
ALTER TABLE ONLY price_updates ADD CONSTRAINT price_updates_pkey PRIMARY KEY (id);
ALTER TABLE ONLY orders ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
ALTER TABLE ONLY order_items ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);
ALTER TABLE ONLY license_keys ADD CONSTRAINT license_keys_pkey PRIMARY KEY (id);

ALTER TABLE ONLY users ADD CONSTRAINT users_email_key UNIQUE (email);
ALTER TABLE ONLY users ADD CONSTRAINT users_username_key UNIQUE (username);
ALTER TABLE ONLY license_keys ADD CONSTRAINT license_keys_key_value_key UNIQUE (key_value);

ALTER TABLE ONLY orders ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE ONLY order_items ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;
ALTER TABLE ONLY order_items ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE ONLY license_keys ADD CONSTRAINT license_keys_order_id_fkey FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL;
ALTER TABLE ONLY license_keys ADD CONSTRAINT license_keys_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL;
ALTER TABLE ONLY license_keys ADD CONSTRAINT license_keys_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;

CREATE INDEX idx_license_keys_key ON license_keys USING btree (key_value);