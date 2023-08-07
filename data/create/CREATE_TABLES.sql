CREATE SCHEMA raw;

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

CREATE TABLE raw.application__colors (
  id   SERIAL PRIMARY KEY,
  name TEXT,
  rgb  TEXT
);

COMMENT ON TABLE raw.application__colors IS 'Colors with name and rgb value';

CREATE TABLE raw.application__sizes (
  id       SERIAL PRIMARY KEY,
  gender   gender,
  category category,
  size     TEXT,
  size_US  int4range,
  size_UK  int4range,
  size_EU  int4range
);

COMMENT ON TABLE raw.application__sizes IS 'Sizes for US, UK and EU';

CREATE TABLE raw.application__labels (
  id       SERIAL PRIMARY KEY,
  name     TEXT,
  slugName TEXT,
  icon     bytea
);

COMMENT ON TABLE raw.application__labels IS 'Brands / labels';

CREATE TABLE raw.application__products
(
  id              SERIAL PRIMARY KEY,
  name            TEXT,
  labelId         INTEGER REFERENCES raw.application__labels (id),
  category        category,
  gender          gender,
  currentlyActive BOOLEAN,
  created         TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated         TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE raw.application__products IS 'Groups articles (differing in sizes/color)';

CREATE TABLE raw.application__articles
(
  id                SERIAL PRIMARY KEY,
  productId         INTEGER REFERENCES raw.application__products (id),
  ean               TEXT,
  colorId           INTEGER REFERENCES raw.application__colors (id),
  sizeId            INTEGER REFERENCES raw.application__sizes (id),
  description       TEXT,
  originalPrice     money,
  reducedPrice      money,
  taxRate           DECIMAL,
  discountInPercent INTEGER,
  currentlyActive   BOOLEAN,
  created           TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated           TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE raw.application__articles IS 'Instance of a product with a size, color and price';

CREATE TABLE raw.application__stock (
  id        SERIAL PRIMARY KEY,
  articleId INTEGER REFERENCES raw.application__articles (id),
  count     INTEGER,
  created   TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated   TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE raw.application__stock IS 'Amount of articles on stock';

CREATE TABLE raw.application__customer (
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

COMMENT ON TABLE raw.application__customer IS 'Basic customer data';

CREATE TABLE raw.application__address (
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

COMMENT ON TABLE raw.application__address IS 'Addresses for receipts and shipping';

ALTER TABLE raw.application__customer
  ADD CONSTRAINT fk_customer_to_current_address FOREIGN KEY
  (currentAddressId) REFERENCES raw.application__address (id);

CREATE TABLE raw.application__order (
  id                SERIAL PRIMARY KEY,
  customerId        INTEGER REFERENCES raw.application__customer (id),
  orderTimestamp    TIMESTAMP WITH TIME ZONE DEFAULT now(),
  shippingAddressId INTEGER REFERENCES raw.application__address (id),
  total             money,
  shippingCost      money,
  created           TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated           TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE raw.application__order IS 'Metadata for an order, see order_positions as well';

CREATE TABLE raw.application__order_positions (
  id        SERIAL PRIMARY KEY,
  orderId   INTEGER REFERENCES raw.application__order (id),
  articleId INTEGER REFERENCES raw.application__articles (id),
  amount    SMALLINT,
  price     money,
  created   TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated   TIMESTAMP WITH TIME ZONE
);

COMMENT ON TABLE raw.application__order_positions IS 'Articles that are contained in an order';
