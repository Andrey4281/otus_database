--1) Let's reacreate table otus.purchase. Now, it shouldn't has any foreign key, as partitioned table.
CREATE TABLE otus.purchase (
    `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `customer_id` integer UNSIGNED NOT NULL,
    `delivary_date` date NOT NULL COMMENT 'Date of delivering the whole order',
    PRIMARY KEY (id, delivary_date)
);
--2) Let's create partitions by range. We will have partition for each month for each year.
ALTER TABLE otus.purchase PARTITION BY RANGE COLUMNS (delivary_date) (
    PARTITION p202401 VALUES LESS THAN ('2024-02-01'),
    PARTITION p202402 VALUES LESS THAN ('2024-03-01'),
    PARTITION p202403 VALUES LESS THAN ('2024-04-01'),
    PARTITION p202404 VALUES LESS THAN ('2024-05-01'),
    PARTITION p202405 VALUES LESS THAN ('2024-06-01'),
    PARTITION p202406 VALUES LESS THAN ('2024-07-01'),
    PARTITION p202407 VALUES LESS THAN ('2024-08-01'),
    PARTITION p202408 VALUES LESS THAN ('2024-09-01'),
    PARTITION p202409 VALUES LESS THAN ('2024-10-01'),
    PARTITION p202410 VALUES LESS THAN ('2024-11-01'),
    PARTITION p202411 VALUES LESS THAN ('2024-12-01'),
    PARTITION p202412 VALUES LESS THAN ('2025-01-01')
    );
--3) Let's insert data to partitioned table.
INSERT INTO otus.purchase(customer_id, delivary_date) VALUES
                                                          (1, '2024-01-06'),
                                                          (1, '2024-01-08'),
                                                          (1, '2024-01-09'),
                                                          (2, '2024-02-04'),
                                                          (1, '2024-03-03'),
                                                          (2, '2024-04-04'),
                                                          (1, '2024-05-09'),
                                                          (2, '2024-06-07'),
                                                          (2, '2024-06-08'),
                                                          (3, '2024-07-07'),
                                                          (3, '2024-07-09'),
                                                          (2, '2024-08-05'),
                                                          (1, '2024-09-05'),
                                                          (3, '2024-10-06'),
                                                          (2, '2024-11-11'),
                                                          (3, '2024-12-09');
--4) Let's check partitioning
--4.1) Let's get data from January partition
SELECT * FROM otus.purchase PARTITION (p202401);
--4.2) Let's see the distribution of data by partition
SELECT PARTITION_NAME, TABLE_ROWS FROM information_schema.PARTITIONS WHERE TABLE_NAME = 'purchase';
--4.3) Let's get all purchases for customerId = 1 during January. You can see from query plan we use only January partition for search.
EXPLAIN SELECT * FROM otus.purchase WHERE customer_id = 1 AND delivary_date >= '2024-01-01' AND delivary_date < '2024-02-01';
--5) Let's reacreate table otus.purchase_item. Now, it shouldn't has any foreign key, as partitioned table.\
CREATE TABLE otus.purchase_item (
    `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `purchase_id` bigint UNSIGNED NOT NULL,
    `product_id` bigint UNSIGNED NOT NULL,
    `amount` decimal(10,2) NOT NULL COMMENT 'Count of bought product',
    `total_cost` decimal(19,4) NOT NULL COMMENT 'Total cost for current price and count',
    `delivery_date` date NOT NULL COMMENT 'Date of delivering the purchase',
    PRIMARY KEY (id, delivery_date)
);
--6) Let's create partitions by range. We will have partition for each month for each year.
ALTER TABLE otus.purchase_item PARTITION BY RANGE COLUMNS (delivery_date) (
    PARTITION pi202401 VALUES LESS THAN ('2024-02-01'),
    PARTITION pi202402 VALUES LESS THAN ('2024-03-01'),
    PARTITION pi202403 VALUES LESS THAN ('2024-04-01'),
    PARTITION pi202404 VALUES LESS THAN ('2024-05-01'),
    PARTITION pi202405 VALUES LESS THAN ('2024-06-01'),
    PARTITION pi202406 VALUES LESS THAN ('2024-07-01'),
    PARTITION pi202407 VALUES LESS THAN ('2024-08-01'),
    PARTITION pi202408 VALUES LESS THAN ('2024-09-01'),
    PARTITION pi202409 VALUES LESS THAN ('2024-10-01'),
    PARTITION pi202410 VALUES LESS THAN ('2024-11-01'),
    PARTITION pi202411 VALUES LESS THAN ('2024-12-01'),
    PARTITION pi202412 VALUES LESS THAN ('2025-01-01')
    );
--7) Let's insert data to partitioned table.
INSERT INTO otus.purchase_item(purchase_id, product_id, amount, total_cost, delivery_date) VALUES
                                                                                               (2, 1, 10.2, 100.5, '2024-01-06'),
                                                                                               (2, 2, 1, 1000.0, '2024-01-06'),
                                                                                               (3, 1, 5.0, 110.5, '2024-01-08'),
                                                                                               (3, 2, 1, 1100.0, '2024-01-08'),
                                                                                               (4, 1, 7.0, 150.5, '2024-01-09'),
                                                                                               (4, 2, 2, 2100.0, '2024-01-09');
;
--8) Let's check partitioning
--8.1) Let's get data from January partition
SELECT * FROM otus.purchase_item PARTITION (pi202401);
--8.2) Let's see the distribution of data by partition
SELECT PARTITION_NAME, TABLE_ROWS FROM information_schema.PARTITIONS WHERE TABLE_NAME = 'purchase_item';
--8.3) Let's get all purchases with purchase items for customerId = 1 during January. You can see from query plan we use only January partition for search in tables "purchase" and "purchase_item".
EXPLAIN SELECT * FROM otus.purchase p INNER JOIN otus.purchase_item pi ON  (p.id = pi.purchase_id AND p.delivary_date = pi.delivery_date)
        WHERE customer_id = 1 AND p.delivary_date >= '2024-01-01' AND p.delivary_date < '2024-02-01';