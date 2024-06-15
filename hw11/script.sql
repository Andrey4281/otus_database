--1) Let's reacreate table otus.purchase. Now, it shouldn't has any foreign key, as partitioned table.
CREATE TABLE otus.purchase (
    `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `customer_id` integer UNSIGNED NOT NULL,
    `delivary_date` date NOT NULL COMMENT 'Date of delivering the whole order',otus
    PRIMARY KEY (id, delivary_date)
);
--2) Let's create partitions by range. We will have partition for each month for each year.
ALTER TABLE otus.purchase PARTITION BY RANGE COLUMNS (delivary_date) (
    PARTITION p2024 VALUES LESS THAN ('2025-01-01'),
    PARTITION p2025 VALUES LESS THAN ('2026-01-01'),
    PARTITION p2026 VALUES LESS THAN ('2027-01-01'),
    PARTITION p2027 VALUES LESS THAN ('2028-01-01'),
    PARTITION p2028 VALUES LESS THAN ('2029-01-01'),
    PARTITION p2029 VALUES LESS THAN ('2030-01-01'),
    PARTITION p2030 VALUES LESS THAN ('2031-01-01'),
    PARTITION p2031 VALUES LESS THAN ('2032-01-01'),
    PARTITION p2032 VALUES LESS THAN ('2033-01-01'),
    PARTITION p2033 VALUES LESS THAN ('2034-01-01'),
    PARTITION p2034 VALUES LESS THAN ('2035-01-01'),
    PARTITION p2035 VALUES LESS THAN ('2036-01-01')
    );
--3) Let's insert data to partitioned table.
INSERT INTO otus.purchase(customer_id, delivary_date) VALUES
                                                          (1, '2024-01-06'),
                                                          (1, '2024-01-08'),
                                                          (1, '2024-01-09'),
                                                          (2, '2025-02-04'),
                                                          (1, '2026-03-03'),
                                                          (2, '2027-04-04'),
                                                          (1, '2028-05-09'),
                                                          (2, '2029-06-07'),
                                                          (2, '2030-06-08'),
                                                          (3, '2031-07-07'),
                                                          (3, '2032-07-09'),
                                                          (2, '2033-08-05'),
                                                          (1, '2034-09-05'),
                                                          (3, '2035-10-06'),
                                                          (2, '2035-11-11'),
                                                          (3, '2035-12-09');
--4) Let's check partitioning
--4.1) Let's get data from 2024 partition
SELECT * FROM otus.purchase PARTITION (p2024);
--4.2) Let's see the distribution of data by partition
SELECT PARTITION_NAME, TABLE_ROWS FROM information_schema.PARTITIONS WHERE TABLE_NAME = 'purchase';
--4.3) Let's get all purchases for customerId = 1 during 2024 year. You can see from query plan we use only 2024 partition for search.
EXPLAIN SELECT * FROM otus.purchase WHERE customer_id = 1 AND delivary_date >= '2024-01-01' AND delivary_date <= '2024-12-31';
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
    PARTITION pi2024 VALUES LESS THAN ('2025-01-01'),
    PARTITION pi2025 VALUES LESS THAN ('2026-01-01'),
    PARTITION pi2026 VALUES LESS THAN ('2027-01-01'),
    PARTITION pi2027 VALUES LESS THAN ('2028-01-01'),
    PARTITION pi2028 VALUES LESS THAN ('2029-01-01'),
    PARTITION pi2029 VALUES LESS THAN ('2030-01-01'),
    PARTITION pi2030 VALUES LESS THAN ('2031-01-01'),
    PARTITION pi2031 VALUES LESS THAN ('2032-01-01'),
    PARTITION pi2032 VALUES LESS THAN ('2033-01-01'),
    PARTITION pi2033 VALUES LESS THAN ('2034-01-01'),
    PARTITION pi2034 VALUES LESS THAN ('2035-01-01'),
    PARTITION pi2035 VALUES LESS THAN ('2036-01-01')
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
--8.1) Let's get data from 2024 partition
SELECT * FROM otus.purchase_item PARTITION (pi2024);
--8.2) Let's see the distribution of data by partition
SELECT PARTITION_NAME, TABLE_ROWS FROM information_schema.PARTITIONS WHERE TABLE_NAME = 'purchase_item';
--8.3) Let's get all purchases with purchase items for customerId = 1 during 2024. You can see from query plan we use only 2024 partition for search in tables "purchase" and "purchase_item".
EXPLAIN SELECT * FROM otus.purchase p INNER JOIN otus.purchase_item pi ON  (p.id = pi.purchase_id AND p.delivary_date = pi.delivery_date)
        WHERE customer_id = 1 AND p.delivary_date >= '2024-01-01' AND p.delivary_date <= '2024-12-31';