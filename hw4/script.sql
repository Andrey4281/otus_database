CREATE DATABASE otus;

CREATE TABLESPACE ssd1 LOCATION '/ssd1';
CREATE TABLESPACE ssd2 LOCATION '/ssd2';

CREATE SCHEMA IF NOT EXISTS otus;

CREATE TABLE IF NOT EXISTS otus.product (
                           "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                           "name" varchar(50) UNIQUE NOT NULL,
                           "manufacturer_fk" integer NOT NULL,
                           "unit_fk" integer UNIQUE NOT NULL
) TABLESPACE ssd1;

CREATE TABLE IF NOT EXISTS otus.unit (
                        "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                        "name" varchar(30) NOT NULL
) TABLESPACE ssd1;

CREATE TABLE IF NOT EXISTS otus.product_category (
                                    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                                    "name" varchar(60) UNIQUE NOT NULL
) TABLESPACE ssd1;

CREATE TABLE IF NOT EXISTS otus.manufacturer (
                                "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                                "name" varchar(40) UNIQUE NOT NULL
) TABLESPACE ssd1;

CREATE TABLE IF NOT EXISTS otus.product_category_ref (
                                        "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                                        "product_category_fk" integer NOT NULL,
                                        "product_fk" integer NOT NULL
) TABLESPACE ssd1;

CREATE TABLE IF NOT EXISTS otus.supplier (
                            "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                            "name" varchar(40) UNIQUE NOT NULL
) TABLESPACE ssd2;

CREATE TABLE IF NOT EXISTS otus.product_item (
                                "id" BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                                "supplier_fk" integer NOT NULL,
                                "product_fk" integer NOT NULL,
                                "delivery_date" date NOT NULL,
                                "price" decimal(10,2) NOT NULL,
                                "amount" decimal(10,2) NOT NULL
) TABLESPACE ssd2;

CREATE TABLE IF NOT EXISTS otus.purchase_item (
                                 "id" BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                                 "purchase_fk" bigint NOT NULL,
                                 "product_item_fk" bigint NOT NULL,
                                 "amount" decimal(10,2) NOT NULL,
                                 "total_cost" decimal(10,2) NOT NULL,
                                 "delivery_date" date NOT NULL
) TABLESPACE ssd2;

CREATE TABLE IF NOT EXISTS otus.purchase (
                            "id" BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                            "customer_fk" integer NOT NULL,
                            "delivary_date" date NOT NULL
) TABLESPACE ssd2;

CREATE TABLE IF NOT EXISTS otus.credit_card (
                               "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                               "card_number" varchar(20) NOT NULL,
                               "balance" decimal(10,2) NOT NULL,
                               "customer_fk" integer NOT NULL,
                               "main" boolean NOT NULL DEFAULT false,
                               "active" boolean NOT NULL DEFAULT true
) TABLESPACE ssd2;

CREATE TABLE IF NOT EXISTS otus.customer (
                            "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                            "first_name" varchar(30) NOT NULL,
                            "last_name" varchar(30) NOT NULL
) TABLESPACE ssd2;

CREATE TABLE IF NOT EXISTS otus.phone (
                         "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                         "phone_number" varchar(10) UNIQUE NOT NULL,
                         "active" boolean NOT NULL DEFAULT true,
                         "main" boolean NOT NULL DEFAULT false,
                         "customer_fk" integer NOT NULL
) TABLESPACE ssd2;

CREATE TABLE IF NOT EXISTS otus.email (
                         "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
                         "email_text" varchar(30) UNIQUE NOT NULL,
                         "active" boolean NOT NULL DEFAULT true,
                         "main" boolean NOT NULL DEFAULT false,
                         "customer_fk" integer NOT NULL
) TABLESPACE ssd2;

CREATE ROLE supplier_user;
GRANT INSERT, UPDATE, SELECT ON otus.supplier, otus.product_item TO supplier_user;
GRANT SELECT ON otus.product, otus.unit, otus.product_category, otus.product_category_ref, otus.manufacturer TO supplier_user;
CREATE USER simple_supplier PASSWORD '123';
GRANT supplier_user TO simple_supplier;
GRANT usage ON schema otus TO supplier_user;

CREATE ROLE customer_user;
GRANT INSERT, SELECT ON otus.purchase_item, otus.purchase TO customer_user;
GRANT INSERT, UPDATE, SELECT ON otus.customer, otus.phone, otus.email, otus.credit_card TO customer_user;
GRANT SELECT ON otus.product, otus.unit, otus.product_category, otus.product_category_ref, otus.manufacturer TO customer_user;
GRANT UPDATE, SELECT ON otus.product_item TO customer_user;
CREATE USER simple_customer PASSWORD '123';
GRANT customer_user TO simple_customer;
GRANT usage ON schema otus TO customer_user;



