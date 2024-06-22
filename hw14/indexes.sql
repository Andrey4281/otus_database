-- 1. Full text search:
ALTER TABLE otus.product ADD COLUMN description text;
ALTER TABLE otus.product ADD COLUMN full_text_search text;
CREATE FULLTEXT INDEX product_full_text_search_idx ON otus.product (full_text_search);
-- Examples of select
--1.a. By manufacturer
SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('IdeaPad');
SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('Apple');
SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('Lenovo');
EXPLAIN SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('IdeaPad');
EXPLAIN SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('Apple');
EXPLAIN SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('Lenovo');
--2.b By product name
SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('Macbook');
SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('iPhone');
SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('IdeaPad');
EXPLAIN SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('Macbook');
EXPLAIN SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('iPhone');
EXPLAIN SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('IdeaPad');
--3.c By description's words
SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('MacOS');
SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('smartphone');
EXPLAIN SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('MacOS');
EXPLAIN SELECT id, name FROM otus.product WHERE MATCH(full_text_search) AGAINST ('smartphone');
--3.d By product category
SELECT * FROM otus.product WHERE MATCH(full_text_search) AGAINST ('laptop');
SELECT * FROM otus.product WHERE MATCH(full_text_search) AGAINST ('Cell phone');
EXPLAIN SELECT * FROM otus.product WHERE MATCH(full_text_search) AGAINST ('laptop');
EXPLAIN SELECT * FROM otus.product WHERE MATCH(full_text_search) AGAINST ('Cell phone');

--2. Json index:
CREATE INDEX customer_history_customerId_idx ON otus.customer_history ((CAST(history ->>'$.customerId' AS char(32)) COLLATE utf8mb4_bin));
EXPLAIN SELECT id, history FROM customer_history ch
        WHERE history ->>'$.customerId' = '5'
        order by id;
SELECT id, history FROM customer_history ch
        WHERE history ->>'$.customerId' = '5'
        order by id;

--3. Find available product by product_id, price range and delivery date range:
CREATE INDEX product_item_product_fk_price_idx ON otus.product_item (product_fk, price);
SELECT * FROM otus.product_item pi
                          INNER JOIN otus.product p ON (pi.product_fk = p.id)
        WHERE pi.product_fk = 4
          AND pi.amount > 0
          AND pi.price < 31000
          AND delivery_date < '2024-09-10';
EXPLAIN SELECT * FROM otus.product_item pi
                          INNER JOIN otus.product p ON (pi.product_fk = p.id)
        WHERE pi.product_fk = 4
          AND pi.amount > 0
          AND pi.price < 31000
          AND delivery_date < '2024-09-10';
--4. Find all purchase by customer:
CREATE INDEX purchase_customer_id_idx ON otus.purchase (customer_id);
CREATE INDEX purchase_item_purchase_id_idx ON otus.purchase_item (purchase_id);
CREATE INDEX product_item_product_fk_price_idx ON otus.product_item (product_fk, price);
SELECT * FROM otus.purchase p
                          INNER JOIN otus.purchase_item pi ON (p.id = pi.purchase_id)
        WHERE customer_id = 1
          AND p.delivary_date between '2024-01-01' AND '2024-08-01'
          AND pi.delivery_date between '2024-01-01' AND '2024-08-01';
EXPLAIN SELECT * FROM otus.purchase p
                          INNER JOIN otus.purchase_item pi ON (p.id = pi.purchase_id)
        WHERE customer_id = 1
          AND p.delivary_date between '2024-01-01' AND '2024-08-01'
          AND pi.delivery_date between '2024-01-01' AND '2024-08-01';
--5. Find customer with its data
CREATE INDEX phone_customer_fk_idx ON otus.phone (customer_fk);
EXPLAIN SELECT * FROM otus.customer c
                          LEFT JOIN otus.email e ON (c.id = e.customer_fk)
                          LEFT JOIN otus.phone p ON (c.id = p.customer_fk)
                          LEFT JOIN otus.credit_card cc ON (c.id = cc.customer_fk)
        WHERE c.id = 2;
SELECT * FROM otus.customer c
                          LEFT JOIN otus.email e ON (c.id = e.customer_fk)
                          LEFT JOIN otus.phone p ON (c.id = p.customer_fk)
                          LEFT JOIN otus.credit_card cc ON (c.id = cc.customer_fk)
        WHERE c.id = 2;
