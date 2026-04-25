-- models.sql

-- users
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(64) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  balance NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  is_admin BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- products
CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  price NUMERIC(10,2) NOT NULL,
  image VARCHAR(255),
  stock INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- news
CREATE TABLE IF NOT EXISTS news (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  summary TEXT,
  date DATE
);

-- partners
CREATE TABLE IF NOT EXISTS partners (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

-- holidays
CREATE TABLE IF NOT EXISTS holidays (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  date DATE,
  note TEXT
);

-- price_updates
CREATE TABLE IF NOT EXISTS price_updates (
  id SERIAL PRIMARY KEY,
  date DATE,
  text TEXT
);

-- orders
CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  total NUMERIC(12,2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- order_items
CREATE TABLE IF NOT EXISTS order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id INTEGER NOT NULL REFERENCES products(id),
  unit_price NUMERIC(10,2) NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1
);

-- license_keys
CREATE TABLE IF NOT EXISTS license_keys (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id) ON DELETE SET NULL,
  user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
  product_id INTEGER REFERENCES products(id) ON DELETE SET NULL,
  key_value VARCHAR(40) NOT NULL UNIQUE,
  issued_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_license_keys_key ON license_keys(key_value);
