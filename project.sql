-- MySQL dump 10.13  Distrib 8.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: otus
-- ------------------------------------------------------
-- Server version	8.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `credit_card`
--

DROP TABLE IF EXISTS `credit_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credit_card` (
                               `id` int unsigned NOT NULL AUTO_INCREMENT,
                               `card_number` varchar(20) NOT NULL COMMENT 'Credit card number',
                               `balance` decimal(19,4) NOT NULL COMMENT 'Balance',
                               `customer_fk` int unsigned NOT NULL,
                               `main` tinyint(1) NOT NULL DEFAULT '0',
                               `active` tinyint(1) NOT NULL DEFAULT '1',
                               PRIMARY KEY (`id`),
                               KEY `customer_fk` (`customer_fk`),
                               CONSTRAINT `credit_card_ibfk_1` FOREIGN KEY (`customer_fk`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
                            `id` int unsigned NOT NULL AUTO_INCREMENT,
                            `first_name` varchar(30) NOT NULL,
                            `last_name` varchar(30) NOT NULL,
                            PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101777 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customer_history`
--

DROP TABLE IF EXISTS `customer_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_history` (
                                    `id` bigint unsigned NOT NULL AUTO_INCREMENT,
                                    `history` json NOT NULL,
                                    PRIMARY KEY (`id`),
                                    KEY `customer_history_customerId_idx` (((cast(json_unquote(json_extract(`history`,_utf8mb4'$.customerId')) as char(32) charset utf8mb4) collate utf8mb4_bin)))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email`
--

DROP TABLE IF EXISTS `email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email` (
                         `id` int unsigned NOT NULL AUTO_INCREMENT,
                         `email_text` varchar(30) NOT NULL,
                         `active` tinyint(1) NOT NULL DEFAULT '1',
                         `main` tinyint(1) NOT NULL DEFAULT '0',
                         `customer_fk` int unsigned NOT NULL,
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `email_text` (`email_text`),
                         KEY `customer_fk` (`customer_fk`),
                         CONSTRAINT `email_ibfk_1` FOREIGN KEY (`customer_fk`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `manufacturer`
--

DROP TABLE IF EXISTS `manufacturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manufacturer` (
                                `id` int unsigned NOT NULL AUTO_INCREMENT,
                                `name` varchar(40) NOT NULL COMMENT 'Manufacturer name',
                                PRIMARY KEY (`id`),
                                UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `phone`
--

DROP TABLE IF EXISTS `phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone` (
                         `id` int unsigned NOT NULL AUTO_INCREMENT,
                         `phone_number` varchar(20) NOT NULL,
                         `active` tinyint(1) NOT NULL DEFAULT '1',
                         `main` tinyint(1) NOT NULL DEFAULT '0',
                         `customer_fk` int NOT NULL,
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `phone_number` (`phone_number`),
                         KEY `phone_customer_fk_idx` (`customer_fk`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
                           `id` int unsigned NOT NULL AUTO_INCREMENT,
                           `name` varchar(50) NOT NULL COMMENT 'Product name',
                           `manufacturer_fk` int unsigned NOT NULL,
                           `unit_fk` int unsigned NOT NULL COMMENT 'Product unit',
                           `description` text,
                           PRIMARY KEY (`id`),
                           UNIQUE KEY `name` (`name`),
                           FULLTEXT KEY `product_description_idx` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=1993 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category`
--

DROP TABLE IF EXISTS `product_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category` (
                                    `id` int unsigned NOT NULL AUTO_INCREMENT,
                                    `name` varchar(60) NOT NULL COMMENT 'Product category name',
                                    PRIMARY KEY (`id`),
                                    UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_ref`
--

DROP TABLE IF EXISTS `product_category_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_ref` (
                                        `id` int unsigned NOT NULL AUTO_INCREMENT,
                                        `product_category_fk` int unsigned NOT NULL,
                                        `product_fk` int unsigned NOT NULL,
                                        PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_item`
--

DROP TABLE IF EXISTS `product_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_item` (
                                `id` bigint unsigned NOT NULL AUTO_INCREMENT,
                                `supplier_fk` int unsigned NOT NULL,
                                `product_fk` int unsigned NOT NULL,
                                `delivery_date` date NOT NULL COMMENT 'Date when product can be delivered',
                                `price` decimal(19,4) NOT NULL COMMENT 'Price',
                                `amount` decimal(10,2) NOT NULL COMMENT 'Available count in warehousefor supplier',
                                PRIMARY KEY (`id`),
                                KEY `product_item_product_fk_idx` (`product_fk`)
) ENGINE=InnoDB AUTO_INCREMENT=198337 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `purchase`
--

DROP TABLE IF EXISTS `purchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase` (
                            `id` bigint unsigned NOT NULL AUTO_INCREMENT,
                            `customer_id` int unsigned NOT NULL,
                            `delivary_date` date NOT NULL COMMENT 'Date of delivering the whole order',
                            PRIMARY KEY (`id`,`delivary_date`)
) ENGINE=InnoDB AUTO_INCREMENT=101782 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
    /*!50500 PARTITION BY RANGE  COLUMNS(delivary_date)
    (PARTITION p2024 VALUES LESS THAN ('2025-01-01') ENGINE = InnoDB,
    PARTITION p2025 VALUES LESS THAN ('2026-01-01') ENGINE = InnoDB,
    PARTITION p2026 VALUES LESS THAN ('2027-01-01') ENGINE = InnoDB,
    PARTITION p2027 VALUES LESS THAN ('2028-01-01') ENGINE = InnoDB,
    PARTITION p2028 VALUES LESS THAN ('2029-01-01') ENGINE = InnoDB,
    PARTITION p2029 VALUES LESS THAN ('2030-01-01') ENGINE = InnoDB,
    PARTITION p2030 VALUES LESS THAN ('2031-01-01') ENGINE = InnoDB,
    PARTITION p2031 VALUES LESS THAN ('2032-01-01') ENGINE = InnoDB,
    PARTITION p2032 VALUES LESS THAN ('2033-01-01') ENGINE = InnoDB,
    PARTITION p2033 VALUES LESS THAN ('2034-01-01') ENGINE = InnoDB,
    PARTITION p2034 VALUES LESS THAN ('2035-01-01') ENGINE = InnoDB,
    PARTITION p2035 VALUES LESS THAN ('2036-01-01') ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `purchase_item`
--

DROP TABLE IF EXISTS `purchase_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_item` (
                                 `id` bigint unsigned NOT NULL AUTO_INCREMENT,
                                 `purchase_id` bigint unsigned NOT NULL,
                                 `product_id` bigint unsigned NOT NULL,
                                 `amount` decimal(10,2) NOT NULL COMMENT 'Count of bought product',
                                 `total_cost` decimal(19,4) NOT NULL COMMENT 'Total cost for current price and count',
                                 `delivery_date` date NOT NULL COMMENT 'Date of delivering the purchase',
                                 PRIMARY KEY (`id`,`delivery_date`),
                                 KEY `pi_purchase_id_idx` (`purchase_id`),
                                 KEY `purchase_item_delivery_date_idx` (`delivery_date`)
) ENGINE=InnoDB AUTO_INCREMENT=101789 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
    /*!50500 PARTITION BY RANGE  COLUMNS(delivery_date)
    (PARTITION pi2024 VALUES LESS THAN ('2025-01-01') ENGINE = InnoDB,
    PARTITION pi2025 VALUES LESS THAN ('2026-01-01') ENGINE = InnoDB,
    PARTITION pi2026 VALUES LESS THAN ('2027-01-01') ENGINE = InnoDB,
    PARTITION pi2027 VALUES LESS THAN ('2028-01-01') ENGINE = InnoDB,
    PARTITION pi2028 VALUES LESS THAN ('2029-01-01') ENGINE = InnoDB,
    PARTITION pi2029 VALUES LESS THAN ('2030-01-01') ENGINE = InnoDB,
    PARTITION pi2030 VALUES LESS THAN ('2031-01-01') ENGINE = InnoDB,
    PARTITION pi2031 VALUES LESS THAN ('2032-01-01') ENGINE = InnoDB,
    PARTITION pi2032 VALUES LESS THAN ('2033-01-01') ENGINE = InnoDB,
    PARTITION pi2033 VALUES LESS THAN ('2034-01-01') ENGINE = InnoDB,
    PARTITION pi2034 VALUES LESS THAN ('2035-01-01') ENGINE = InnoDB,
    PARTITION pi2035 VALUES LESS THAN ('2036-01-01') ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
                            `id` int unsigned NOT NULL AUTO_INCREMENT,
                            `name` varchar(40) NOT NULL,
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unit`
--

DROP TABLE IF EXISTS `unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unit` (
                        `id` int unsigned NOT NULL AUTO_INCREMENT,
                        `name` varchar(30) NOT NULL COMMENT 'Product unit',
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-08-04  5:04:46