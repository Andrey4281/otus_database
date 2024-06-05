CREATE TABLE `product` (
                           `id` integer UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                           `name` varchar(50) UNIQUE NOT NULL COMMENT 'Product name',
    `manufacturer_fk` integer UNSIGNED NOT NULL,
    `unit_fk` integer UNSIGNED UNIQUE NOT NULL COMMENT 'Product unit'
    );

CREATE TABLE `unit` (
                        `id` integer UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                        `name` varchar(30) NOT NULL COMMENT 'Product unit'
    );

CREATE TABLE `product_category` (
                                    `id` integer UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                                    `name` varchar(60) UNIQUE NOT NULL COMMENT 'Product category name'
    );

CREATE TABLE `manufacturer` (
                                `id` integer UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                                `name` varchar(40) UNIQUE NOT NULL COMMENT 'Manufacturer name'
    );

CREATE TABLE `supplier` (
                            `id` integer UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                            `name` varchar(40) UNIQUE NOT NULL
    );

CREATE TABLE `purchase` (
                            `id` bigint UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                            `customer_fk` integer UNSIGNED NOT NULL,
                            `delivary_date` date NOT NULL COMMENT 'Date of delivering the whole order'
);

CREATE TABLE `purchase_item` (
                                 `id` bigint UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                                 `purchase_fk` bigint UNSIGNED NOT NULL,
                                 `product_item_fk` bigint UNSIGNED NOT NULL,
                                 `amount` decimal(10,2) NOT NULL COMMENT 'Count of bought product',
    `total_cost` decimal(19,4) NOT NULL COMMENT 'Total cost for current price and count',
    `delivery_date` date NOT NULL COMMENT 'Date of delivering the purchase'
    );

CREATE TABLE `customer` (
                            `id` integer UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                            `first_name` varchar(30) NOT NULL,
    `last_name` varchar(30) NOT NULL
    );

CREATE TABLE `email` (
                         `id` integer UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                         `email_text` varchar(30) UNIQUE NOT NULL,
    `active` boolean NOT NULL DEFAULT true,
    `main` boolean NOT NULL DEFAULT false,
    `customer_fk` integer UNSIGNED NOT NULL
    );

CREATE TABLE `phone` (
                         `id` integer UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                         `phone_number` varchar(10) UNIQUE NOT NULL,
    `active` boolean NOT NULL DEFAULT true,
    `main` boolean NOT NULL DEFAULT false,
    `customer_fk` integer UNSIGNED NOT NULL
    );

CREATE TABLE `product_item` (
                                `id` bigint UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                                `supplier_fk` integer UNSIGNED NOT NULL,
                                `product_fk` integer UNSIGNED NOT NULL,
                                `delivery_date` date NOT NULL COMMENT 'Date when product can be delivered',
                                `price` decimal(19,4) NOT NULL COMMENT 'Price',
    `amount` decimal(10,2) NOT NULL COMMENT 'Available count in warehousefor supplier'
    );

CREATE TABLE `credit_card` (
                               `id` integer UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                               `card_number` varchar(20) NOT NULL COMMENT 'Credit card number',
    `balance` decimal(19,4) NOT NULL COMMENT 'Balance',
    `customer_fk` integer UNSIGNED NOT NULL,
    `main` boolean NOT NULL DEFAULT false,
    `active` boolean NOT NULL DEFAULT true
    );

CREATE TABLE `product_category_ref` (
                                        `id` integer UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
                                        `product_category_fk` integer UNSIGNED NOT NULL,
                                        `product_fk` integer UNSIGNED NOT NULL
);

CREATE TABLE `customer_history`
(
    `id`      bigint UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `history` json                        NOT NULL
);

ALTER TABLE `product` ADD FOREIGN KEY (`unit_fk`) REFERENCES `unit` (`id`);

ALTER TABLE `product` ADD FOREIGN KEY (`manufacturer_fk`) REFERENCES `manufacturer` (`id`);

ALTER TABLE `purchase_item` ADD FOREIGN KEY (`purchase_fk`) REFERENCES `purchase` (`id`);

ALTER TABLE `purchase_item` ADD FOREIGN KEY (`product_item_fk`) REFERENCES `product_item` (`id`);

ALTER TABLE `purchase` ADD FOREIGN KEY (`customer_fk`) REFERENCES `customer` (`id`);

ALTER TABLE `credit_card` ADD FOREIGN KEY (`customer_fk`) REFERENCES `customer` (`id`);

ALTER TABLE `product_item` ADD FOREIGN KEY (`supplier_fk`) REFERENCES `supplier` (`id`);

ALTER TABLE `product_item` ADD FOREIGN KEY (`product_fk`) REFERENCES `product` (`id`);

ALTER TABLE `product_category_ref` ADD FOREIGN KEY (`product_fk`) REFERENCES `product` (`id`);

ALTER TABLE `product_category_ref` ADD FOREIGN KEY (`product_category_fk`) REFERENCES `product_category` (`id`);

ALTER TABLE `email` ADD FOREIGN KEY (`customer_fk`) REFERENCES `customer` (`id`);

ALTER TABLE `phone` ADD FOREIGN KEY (`customer_fk`) REFERENCES `customer` (`id`);