CREATE SCHEMA landing;

CREATE TYPE category AS ENUM (
  'Apparel',
  'Footwear',
  'Sportswear',
  'Traditional',
  'Formal Wear',
  'Accessories',
  'Watches & Jewelry',
  'Luggage',
  'Cosmetics'
);

COMMENT ON TYPE category IS 'Category of clothing';

CREATE TYPE gender AS ENUM (
  'male',
  'female',
  'unisex'
);

COMMENT ON TYPE gender IS 'Gender of customer or clothes';

CREATE TABLE landing.colors (
  id   SERIAL PRIMARY KEY,
  name TEXT,
  rgb  TEXT
);

COMMENT ON TABLE landing.colors IS 'Colors with name and rgb value';

CREATE TABLE landing.sizes (
  id       SERIAL PRIMARY KEY,
  gender   gender,
  category category,
  size     TEXT,
  size_US  int4range,
  size_UK  int4range,
  size_EU  int4range
);

COMMENT ON TABLE landing.sizes IS 'Sizes for US, UK and EU';

CREATE TABLE landing.labels (
  id       SERIAL PRIMARY KEY,
  name     TEXT,
  slugName TEXT,
  icon     bytea
);

COMMENT ON TABLE landing.labels IS 'Brands / labels';

CREATE TABLE landing.products
(
  id              SERIAL PRIMARY KEY,
  name            TEXT,
  labelId         INTEGER REFERENCES landing.labels (id),
  category        category,
  gender          gender,
  currentlyActive BOOLEAN,
  created         TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated         TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE landing.products IS 'Groups articles (differing in sizes/color)';

CREATE TABLE landing.articles
(
  id                SERIAL PRIMARY KEY,
  productId         INTEGER REFERENCES landing.products (id),
  ean               TEXT,
  colorId           INTEGER REFERENCES landing.colors (id),
  sizeId            INTEGER REFERENCES landing.sizes (id),
  description       TEXT,
  originalPrice     money,
  reducedPrice      money,
  taxRate           DECIMAL,
  discountInPercent INTEGER,
  currentlyActive   BOOLEAN,
  created           TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated           TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE landing.articles IS 'Instance of a product with a size, color and price';

CREATE TABLE landing.stock (
  id        SERIAL PRIMARY KEY,
  articleId INTEGER REFERENCES landing.articles (id),
  count     INTEGER,
  created   TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated   TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE landing.stock IS 'Amount of articles on stock';

CREATE TABLE landing.customer (
  id               SERIAL PRIMARY KEY,
  firstName        TEXT,
  lastName         TEXT,
  gender           gender,
  email            TEXT,
  dateOfBirth      DATE,
  currentAddressId INTEGER,
  created          TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated          TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE landing.customer IS 'Basic customer data';

CREATE TABLE landing.address (
  id         SERIAL PRIMARY KEY,
  customerId INTEGER,
  firstName  TEXT,
  lastName   TEXT,
  address1   TEXT,
  address2   TEXT,
  city       TEXT,
  zip        TEXT,
  created    TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated    TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE landing.address IS 'Addresses for receipts and shipping';

ALTER TABLE landing.customer
  ADD CONSTRAINT fk_customer_to_current_address FOREIGN KEY
  (currentAddressId) REFERENCES landing.address (id);

CREATE TABLE landing.order (
  id                SERIAL PRIMARY KEY,
  customerId        INTEGER REFERENCES landing.customer (id),
  orderTimestamp    TIMESTAMP WITH TIME ZONE DEFAULT now(),
  shippingAddressId INTEGER REFERENCES landing.address (id),
  total             money,
  shippingCost      money,
  created           TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated           TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE landing.order IS 'Metadata for an order, see order_positions as well';

CREATE TABLE landing.order_positions (
  id        SERIAL PRIMARY KEY,
  orderId   INTEGER REFERENCES landing.order (id),
  articleId INTEGER REFERENCES landing.articles (id),
  amount    SMALLINT,
  price     money,
  created   TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated   TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE landing.order_positions IS 'Articles that are contained in an order';
