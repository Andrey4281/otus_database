CREATE TABLE "product" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "name" varchar(256) NOT NULL,
  "product_category_id" id NOT NULL,
  "manufacturer_id" integer NOT NULL
);

CREATE TABLE "product_category" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "name" varchar(256) NOT NULL
);

CREATE TABLE "manufacturer" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "name" varchar(256) NOT NULL
);

CREATE TABLE "supplier" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "name" varchar(256) NOT NULL
);

CREATE TABLE "purchase" (
  "id" BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "customer_id" bigint NOT NULL,
  "purchase_delivary_date" date NOT NULL
);

CREATE TABLE "purchase_item" (
  "id" BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "id_purchase" bigint NOT NULL,
  "id_product" bigint NOT NULL,
  "id_supplier" integer NOT NULL,
  "product_count" bigint NOT NULL,
  "sum" bigint NOT NULL,
  "purchase_item_delivery_date" date NOT NULL
);

CREATE TABLE "customer" (
  "id" BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "email" varchar(256) NOT NULL,
  "phone" varchar(256) NOT NULL
);

CREATE TABLE "product_item" (
  "id" BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "supplier_id" integer NOT NULL,
  "product_id" integer NOT NULL,
  "delivery_date" date NOT NULL,
  "price" bigint NOT NULL,
  "count" integer NOT NULL
);

CREATE TABLE "credit_card" (
  "id" BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "card_number" varchar(20) NOT NULL,
  "balance" bigint NOT NULL,
  "customer_id" bigint NOT NULL
);

COMMENT ON COLUMN "product"."name" IS 'Product name';

COMMENT ON COLUMN "product_category"."name" IS 'Product category name';

COMMENT ON COLUMN "manufacturer"."name" IS 'Manufacturer name';

COMMENT ON COLUMN "purchase"."purchase_delivary_date" IS 'Date of delivering the whole order';

COMMENT ON COLUMN "purchase_item"."product_count" IS 'Count of bought product';

COMMENT ON COLUMN "purchase_item"."sum" IS 'Total cost for current price and count';

COMMENT ON COLUMN "purchase_item"."purchase_item_delivery_date" IS 'Date of delivering the purchase';

COMMENT ON COLUMN "product_item"."delivery_date" IS 'Date when product can be delivered';

COMMENT ON COLUMN "product_item"."price" IS 'Price in minor unit';

COMMENT ON COLUMN "product_item"."count" IS 'Available count in warehousefor supplier';

COMMENT ON COLUMN "credit_card"."card_number" IS 'Credit card number';

COMMENT ON COLUMN "credit_card"."balance" IS 'Balance in minor unit';

ALTER TABLE "product" ADD FOREIGN KEY ("product_category_id") REFERENCES "product_category" ("id");

ALTER TABLE "product" ADD FOREIGN KEY ("manufacturer_id") REFERENCES "manufacturer" ("id");

ALTER TABLE "purchase_item" ADD FOREIGN KEY ("id_purchase") REFERENCES "purchase" ("id");

ALTER TABLE "purchase_item" ADD FOREIGN KEY ("id_supplier") REFERENCES "supplier" ("id");

ALTER TABLE "purchase_item" ADD FOREIGN KEY ("id_product") REFERENCES "product" ("id");

ALTER TABLE "purchase" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("id");

ALTER TABLE "credit_card" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("id");

ALTER TABLE "product_item" ADD FOREIGN KEY ("supplier_id") REFERENCES "supplier" ("id");

ALTER TABLE "product_item" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id");
