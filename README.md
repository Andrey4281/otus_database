## You can find sql script for creating database in file 'script.sql'
- In this file you can also find a field description

## Local environment for running PostgreSQL and PgAmdin is in the file 'docker-compose.yaml'

## HW1

## By using this studying database you can solve the next tasks:
- We can add a new product of some category and manufacturer
- Customer can find a product from catalog by category and manufacturer and get list of needed products
- Then Customer can choose needed product and check availability among different supplier (See product item table)
- Before creating order we check available balance in customer credit card and product available count for chosen supplier
- After creating order we decrease available count from product_item_table for supplier and balance on customer credit card
- Customer can find all his order for date ranges

# HW2

## Example of queries and indexes
- Find product name with product category and manufacturer name by product category (We can get large list of product):
  
  SELECT p.name, pc.name, m.name FROM otus.product p
  INNER JOIN otus.product_category_ref pcr ON (p.id = pcr.product_id)
  INNER JOIN otus.product_category pc ON (pc.id = pcr.product_category_id)
  INNER JOIN otus.manufacturer m on m.id = p.manufacturer_id
  WHERE pc.id = :category;
  
  For this request we create index "product_category_ref_product_id_product_category_id_idx" see (indexes.sql)

- Find product name with product category and manufacturer name by product's name (We use fulltext search):

  SELECT p.name, pc.name, m.name FROM otus.product p
  INNER JOIN otus.product_category_ref pcr ON (p.id = pcr.product_id)
  INNER JOIN otus.product_category pc ON (pc.id = pcr.product_category_id)
  INNER JOIN otus.manufacturer m on m.id = p.manufacturer_id
  WHERE product_search_name @@ to_tsquery('english', 'computer');

  For this request we create index product_product_search_name_gin see (indexes.sql)

- Find available product_item from different supplier by product:

  SELECT p.name, s.name, pi.price, pi.count FROM otus.product p
  INNER JOIN otus.product_item pi ON (p.id = pi.product_id)
  INNER JOIN otus.supplier s ON (pi.supplier_id = s.id)
  WHERE p.id = 1 AND count > 0;

  For this request we create product_item_product_id_supplier_id_idx see (indexes.sql)

- Find all credit card for customer:

  SELECT * FROM otus.customer c
  INNER JOIN otus.credit_card cc on c.id = cc.customer_id WHERE c.id = 1

  For this request we create credit_card_customer_id_idx see (indexes.sql)

- Find all customers's purchases:

  SELECT c.email,
  p.purchase_delivary_date,
  pi.product_count,
  pi.purchase_item_delivery_date,
  pi.sum,
  s.name,
  p2.name
  FROM otus.customer c
  INNER JOIN otus.purchase p on c.id = p.customer_id
  INNER JOIN otus.purchase_item pi on p.id = pi.id_purchase
  INNER JOIN otus.product p2 on p2.id = pi.id_product
  INNER JOIN otus.supplier s on s.id = pi.id_supplier
  WHERE c.id = 1;

  For this request we create purchase_customer_id_idx, purchase_item_id_purchase_idx, purchase_item_id_product_idx, purchase_item_id_supplier_idx see (indexes.sql)

## Constraints
unique: product.name, product_category.name, manufacturer.name, supplier.name, customer.email, customer.phone
greater then or equals zero: credit_card.balance, product_item.count
greater then zero: product_item.price, purchase_item.product_count, purchase_item.sum
See file hw2/script.sql

# HW3
- By using docker-compose.yaml file you can install postgresql server and pqAdmin in the same network (execute command in the folder hw3 - 'docker-compose up -d')
- By using command 'sudo apt-get install postgresql-client' you can install psql on your Ubuntu host or virtual machine
- By using psql or pqAdmin you can connect to you databases
![img.png](img.png)
![img_1.png](img_1.png)

# HW4
- You can find simple example of working with DDL operation in file hw4/script.sql
- Current database schema in file hw4/schema_hw4.png

# HW5
- You can find current database schema in file hw5/script.sql
- You can find initial data in file hw5/insert_script.sql
- Let's consider a query to find first name and last name of customers, who bought a good which price is equal 100
- SELECT c.first_name, c.last_name FROM otus.purchase_item pi
  JOIN otus.purchase p ON  pi.purchase_fk = p.id
  JOIN otus.customer c ON c.id = p.customer_fk
  WHERE total_cost = 100;
- We have the next query plan:
  Gather  (cost=1000.72..57720.30 rows=15 width=14) (actual time=1.501..249.019 rows=86 loops=1)
  "  Output: c.first_name, c.last_name"
  Workers Planned: 2
  Workers Launched: 2
  ->  Nested Loop  (cost=0.71..56718.80 rows=6 width=14) (actual time=1.259..245.555 rows=29 loops=3)
  "        Output: c.first_name, c.last_name"
  Inner Unique: true
  Worker 0:  actual time=1.944..244.566 rows=27 loops=1
  Worker 1:  actual time=0.796..244.825 rows=27 loops=1
  ->  Nested Loop  (cost=0.42..56716.89 rows=6 width=4) (actual time=1.077..241.864 rows=29 loops=3)
  Output: p.customer_fk
  Inner Unique: true
  Worker 0:  actual time=1.737..240.801 rows=27 loops=1
  Worker 1:  actual time=0.612..241.664 rows=27 loops=1
  ->  Parallel Seq Scan on otus.purchase_item pi  (cost=0.00..56666.25 rows=6 width=8) (actual time=0.856..238.120 rows=29 loops=3)
  "                    Output: pi.id, pi.purchase_fk, pi.product_item_fk, pi.amount, pi.total_cost, pi.delivery_date"
  Filter: (pi.total_cost = '100'::numeric)
  Rows Removed by Filter: 1322279
  Worker 0:  actual time=1.562..237.209 rows=27 loops=1
  Worker 1:  actual time=0.404..238.527 rows=27 loops=1
  ->  Index Scan using purchase_pkey on otus.purchase p  (cost=0.42..8.44 rows=1 width=12) (actual time=0.128..0.128 rows=1 loops=86)
  "                    Output: p.id, p.customer_fk, p.delivary_date"
  Index Cond: (p.id = pi.purchase_fk)
  Worker 0:  actual time=0.130..0.130 rows=1 loops=27
  Worker 1:  actual time=0.114..0.114 rows=1 loops=27
  ->  Index Scan using customer_pkey on otus.customer c  (cost=0.29..0.32 rows=1 width=18) (actual time=0.127..0.127 rows=1 loops=86)
  "              Output: c.id, c.first_name, c.last_name"
  Index Cond: (c.id = p.customer_fk)
  Worker 0:  actual time=0.138..0.138 rows=1 loops=27
  Worker 1:  actual time=0.115..0.115 rows=1 loops=27
  Planning Time: 4.380 ms
  Execution Time: 249.112 ms
- Let's add the index on "total_cost" field:
  CREATE INDEX purchase_item_total_cost_idx ON otus.purchase_item(total_cost);
- Now we have the next plan for the previous query:
  Nested Loop  (cost=1.15..156.68 rows=15 width=14) (actual time=0.060..1.065 rows=86 loops=1)
  "  Output: c.first_name, c.last_name"
  Inner Unique: true
  ->  Nested Loop  (cost=0.85..151.89 rows=15 width=4) (actual time=0.056..0.828 rows=86 loops=1)
  Output: p.customer_fk
  Inner Unique: true
  ->  Index Scan using purchase_item_total_cost_idx on otus.purchase_item pi  (cost=0.43..25.29 rows=15 width=8) (actual time=0.045..0.543 rows=86 loops=1)
  "              Output: pi.id, pi.purchase_fk, pi.product_item_fk, pi.amount, pi.total_cost, pi.delivery_date"
  Index Cond: (pi.total_cost = '100'::numeric)
  ->  Index Scan using purchase_pkey on otus.purchase p  (cost=0.42..8.44 rows=1 width=12) (actual time=0.003..0.003 rows=1 loops=86)
  "              Output: p.id, p.customer_fk, p.delivary_date"
  Index Cond: (p.id = pi.purchase_fk)
  ->  Index Scan using customer_pkey on otus.customer c  (cost=0.29..0.32 rows=1 width=18) (actual time=0.002..0.002 rows=1 loops=86)
  "        Output: c.id, c.first_name, c.last_name"
  Index Cond: (c.id = p.customer_fk)
  Planning Time: 0.369 ms
  Execution Time: 1.089 ms
- We can see execution time is equals 1.089 ms. It's faster then query execution without index more than 228 times
- Let's consider a query to find customer by first name or last name by using full text search in postgresql.
  ALTER table otus.customer ADD column customer_search tsvector;
  UPDATE otus.customer SET customer_search = to_tsvector('english', first_name || ' ' || last_name);
  SELECT * FROM otus.customer WHERE customer_search @@ to_tsquery('english', 'Acevedo');
- We have the next query plan for select:
  Seq Scan on otus.customer  (cost=0.00..2945.45 rows=122 width=51) (actual time=0.338..18.855 rows=102 loops=1)
  "  Output: id, first_name, last_name, customer_search"
  Filter: (customer.customer_search @@ '''acevedo'''::tsquery)
  Rows Removed by Filter: 101614
  Planning Time: 3.249 ms
  Execution Time: 18.888 ms
- Let's add index for full text search:
  CREATE INDEX customer_customer_search_gin ON otus.customer USING gin(customer_search);
- Now we have the next query plan for the previous query:
  Bitmap Heap Scan on otus.customer  (cost=13.45..392.99 rows=122 width=51) (actual time=0.027..0.098 rows=102 loops=1)
  "  Output: id, first_name, last_name, customer_search"
  Recheck Cond: (customer.customer_search @@ '''acevedo'''::tsquery)
  Heap Blocks: exact=102
  ->  Bitmap Index Scan on customer_customer_search_gin  (cost=0.00..13.42 rows=122 width=0) (actual time=0.017..0.017 rows=102 loops=1)
  Index Cond: (customer.customer_search @@ '''acevedo'''::tsquery)
  Planning Time: 0.230 ms
  Execution Time: 0.113 ms
- We can see execution time is equals 0.113 ms. It's faster then query execution without index more than 167 times
- Let's consider a query to find first name and last name of customers, who bought a good which price is equal 100
- SELECT c.first_name, c.last_name FROM otus.purchase_item pi
  JOIN otus.purchase p ON  pi.purchase_fk = p.id
  JOIN otus.customer c ON c.id = p.customer_fk
  WHERE total_cost = 100;
- We have the next query plan:
  Gather  (cost=1000.72..57720.30 rows=15 width=14) (actual time=1.501..249.019 rows=86 loops=1)
  "  Output: c.first_name, c.last_name"
  Workers Planned: 2
  Workers Launched: 2
  ->  Nested Loop  (cost=0.71..56718.80 rows=6 width=14) (actual time=1.259..245.555 rows=29 loops=3)
  "        Output: c.first_name, c.last_name"
  Inner Unique: true
  Worker 0:  actual time=1.944..244.566 rows=27 loops=1
  Worker 1:  actual time=0.796..244.825 rows=27 loops=1
  ->  Nested Loop  (cost=0.42..56716.89 rows=6 width=4) (actual time=1.077..241.864 rows=29 loops=3)
  Output: p.customer_fk
  Inner Unique: true
  Worker 0:  actual time=1.737..240.801 rows=27 loops=1
  Worker 1:  actual time=0.612..241.664 rows=27 loops=1
  ->  Parallel Seq Scan on otus.purchase_item pi  (cost=0.00..56666.25 rows=6 width=8) (actual time=0.856..238.120 rows=29 loops=3)
  "                    Output: pi.id, pi.purchase_fk, pi.product_item_fk, pi.amount, pi.total_cost, pi.delivery_date"
  Filter: (pi.total_cost = '100'::numeric)
  Rows Removed by Filter: 1322279
  Worker 0:  actual time=1.562..237.209 rows=27 loops=1
  Worker 1:  actual time=0.404..238.527 rows=27 loops=1
  ->  Index Scan using purchase_pkey on otus.purchase p  (cost=0.42..8.44 rows=1 width=12) (actual time=0.128..0.128 rows=1 loops=86)
  "                    Output: p.id, p.customer_fk, p.delivary_date"
  Index Cond: (p.id = pi.purchase_fk)
  Worker 0:  actual time=0.130..0.130 rows=1 loops=27
  Worker 1:  actual time=0.114..0.114 rows=1 loops=27
  ->  Index Scan using customer_pkey on otus.customer c  (cost=0.29..0.32 rows=1 width=18) (actual time=0.127..0.127 rows=1 loops=86)
  "              Output: c.id, c.first_name, c.last_name"
  Index Cond: (c.id = p.customer_fk)
  Worker 0:  actual time=0.138..0.138 rows=1 loops=27
  Worker 1:  actual time=0.115..0.115 rows=1 loops=27
  Planning Time: 4.380 ms
  Execution Time: 249.112 ms
- Let's add the partial index on "total_cost" field:
  CREATE INDEX purchase_item_total_cost_partial_idx ON otus.purchase_item(total_cost) WHERE total_cost < 120;
- Now we have the next plan for the previous query:
  Nested Loop  (cost=1.12..158.60 rows=15 width=14) (actual time=0.045..1.011 rows=86 loops=1)
  "  Output: c.first_name, c.last_name"
  Inner Unique: true
  ->  Nested Loop  (cost=0.71..151.75 rows=15 width=4) (actual time=0.037..0.790 rows=86 loops=1)
  Output: p.customer_fk
  Inner Unique: true
  ->  Index Scan using purchase_item_total_cost_partial_idx on otus.purchase_item pi  (cost=0.29..25.15 rows=15 width=8) (actual time=0.030..0.520 rows=86 loops=1)
  "              Output: pi.id, pi.purchase_fk, pi.product_item_fk, pi.amount, pi.total_cost, pi.delivery_date"
  Index Cond: (pi.total_cost = '100'::numeric)
  ->  Index Scan using purchase_pkey on otus.purchase p  (cost=0.42..8.44 rows=1 width=12) (actual time=0.003..0.003 rows=1 loops=86)
  "              Output: p.id, p.customer_fk, p.delivary_date"
  Index Cond: (p.id = pi.purchase_fk)
  ->  Index Scan using customer_pkey on otus.customer c  (cost=0.42..0.46 rows=1 width=18) (actual time=0.002..0.002 rows=1 loops=86)
  "        Output: c.id, c.first_name, c.last_name, c.customer_search"
  Index Cond: (c.id = p.customer_fk)
  Planning Time: 0.373 ms
  Execution Time: 1.033 ms
- We can see execution time is equals 1.033 ms. It's faster then query execution without index more than 241 times
- Let's consider a query to find first name and last name of customers, who bought a good which price is less than 100 and amount is less than 3:
  EXPLAIN (COSTS, VERBOSE, format text, analyze ) SELECT c.first_name, c.last_name FROM otus.purchase_item pi
  JOIN otus.purchase p ON  pi.purchase_fk = p.id
  JOIN otus.customer c ON c.id = p.customer_fk
  WHERE total_cost < 100 AND amount < 3;
- We have the next query plan:
  Gather  (cost=1000.84..61824.67 rows=7 width=14) (actual time=0.894..115.669 rows=19 loops=1)
  "  Output: c.first_name, c.last_name"
  Workers Planned: 2
  Workers Launched: 2
  ->  Nested Loop  (cost=0.84..60823.97 rows=3 width=14) (actual time=4.497..111.495 rows=6 loops=3)
  "        Output: c.first_name, c.last_name"
  Inner Unique: true
  Worker 0:  actual time=10.923..109.513 rows=4 loops=1
  Worker 1:  actual time=1.868..110.993 rows=9 loops=1
  ->  Nested Loop  (cost=0.42..60822.60 rows=3 width=4) (actual time=4.484..111.447 rows=6 loops=3)
  Output: p.customer_fk
  Inner Unique: true
  Worker 0:  actual time=10.905..109.465 rows=4 loops=1
  Worker 1:  actual time=1.852..110.924 rows=9 loops=1
  ->  Parallel Seq Scan on otus.purchase_item pi  (cost=0.00..60797.28 rows=3 width=8) (actual time=4.460..111.387 rows=6 loops=3)
  "                    Output: pi.id, pi.purchase_fk, pi.product_item_fk, pi.amount, pi.total_cost, pi.delivery_date"
  Filter: ((pi.total_cost < '100'::numeric) AND (pi.amount < '3'::numeric))
  Rows Removed by Filter: 1322302
  Worker 0:  actual time=10.866..109.401 rows=4 loops=1
  Worker 1:  actual time=1.832..110.846 rows=9 loops=1
  ->  Index Scan using purchase_pkey on otus.purchase p  (cost=0.42..8.44 rows=1 width=12) (actual time=0.008..0.008 rows=1 loops=19)
  "                    Output: p.id, p.customer_fk, p.delivary_date"
  Index Cond: (p.id = pi.purchase_fk)
  Worker 0:  actual time=0.014..0.014 rows=1 loops=4
  Worker 1:  actual time=0.007..0.008 rows=1 loops=9
  ->  Index Scan using customer_pkey on otus.customer c  (cost=0.42..0.46 rows=1 width=18) (actual time=0.007..0.007 rows=1 loops=19)
  "              Output: c.id, c.first_name, c.last_name, c.customer_search"
  Index Cond: (c.id = p.customer_fk)
  Worker 0:  actual time=0.010..0.010 rows=1 loops=4
  Worker 1:  actual time=0.007..0.007 rows=1 loops=9
  Planning Time: 0.207 ms
  Execution Time: 115.696 ms
- Let's add the composite index on "total_cost" and "amount" fields:
  CREATE INDEX purchase_item_total_cost_amount_idx ON otus.purchase_item(total_cost, amount);
- Now we have the next plan for the previous query:
  Nested Loop  (cost=1.27..290.37 rows=7 width=14) (actual time=0.071..0.885 rows=19 loops=1)
  "  Output: c.first_name, c.last_name"
  Inner Unique: true
  ->  Nested Loop  (cost=0.85..287.17 rows=7 width=4) (actual time=0.066..0.826 rows=19 loops=1)
  Output: p.customer_fk
  Inner Unique: true
  ->  Index Scan using purchase_item_total_cost_amount_idx on otus.purchase_item pi  (cost=0.43..228.09 rows=7 width=8) (actual time=0.058..0.757 rows=19 loops=1)
  "              Output: pi.id, pi.purchase_fk, pi.product_item_fk, pi.amount, pi.total_cost, pi.delivery_date"
  Index Cond: ((pi.total_cost < '100'::numeric) AND (pi.amount < '3'::numeric))
  ->  Index Scan using purchase_pkey on otus.purchase p  (cost=0.42..8.44 rows=1 width=12) (actual time=0.003..0.003 rows=1 loops=19)
  "              Output: p.id, p.customer_fk, p.delivary_date"
  Index Cond: (p.id = pi.purchase_fk)
  ->  Index Scan using customer_pkey on otus.customer c  (cost=0.42..0.46 rows=1 width=18) (actual time=0.003..0.003 rows=1 loops=19)
  "        Output: c.id, c.first_name, c.last_name, c.customer_search"
  Index Cond: (c.id = p.customer_fk)
  Planning Time: 0.407 ms
  Execution Time: 0.904 ms
- We can see execution time is equals 0.904 ms. It's faster then query execution without index more than 127 times

# HW7
- Query with regular expression. I want to find customer whose first name begins with 'Al' and last begin with 'Tr' or 'Tu'
  SELECT * FROM otus.customer WHERE first_name ~ 'Al' and last_name ~ 'T[ru]';
- Query with INNER JOIN. I want to find customers and their emails whose first name begins with 'Al' and last begin with 'Tr' or 'Tu':
  SELECT * FROM otus.customer c
  INNER JOIN otus.email e ON e.customer_fk = c.id
  WHERE c.first_name ~ 'Al' and c.last_name ~ 'T[ru]';
  Changing join order in from expression doesn't change query result because inner join is commutative operation:
  SELECT * FROM otus.email e
  INNER JOIN otus.customer c ON e.customer_fk = c.id
  WHERE c.first_name ~ 'Al' and c.last_name ~ 'T[ru]';
- Query with LEFT JOIN. I want to find customers and their emails or without them whose first name begins with 'Al' and last begin with 'Tr' or 'Tu':
  SELECT * FROM otus.customer c
  LEFT JOIN otus.email e ON e.customer_fk = c.id
  WHERE c.first_name ~ 'Al' and c.last_name ~ 'T[ru]';
  Query result size is equal record count in first table (otus.customer) which meet the conditions in where clause:
  Changing join order will change result of query because we will get all email with customers or without it.
  Query result size is equal record count in first table (otus.email)
  SELECT * FROM otus.email e
  LEFT JOIN otus.customer c ON e.customer_fk = c.id
  WHERE c.first_name ~ 'Al' and c.last_name ~ 'T[ru]';
- Insert with returning information about inserted records:
  INSERT INTO otus.email(email_text, active, main, customer_fk) VALUES ('AliceTran@mail.ru', true, true, 1988),
  ('AliceTran@yandex.ru', true, false, 1988),
  ('AliceTran@gmail.ru', false, false, 1988),
  ('AliceTucker@proton.com', true, true, 1992),
  ('AliceTrevino@yandex.ru', true, true, 1990) RETURNING *;
- Update query with from clause. Let's deactivate emails whose first name begins with 'Al' and last begin with 'Tr' or 'Tu'
  UPDATE otus.email SET active = false FROM
  (SELECT c.first_name, c.last_name, c.id FROM otus.customer c) as cust
  WHERE cust.id = customer_fk
  AND cust.first_name ~ 'Al'
  AND cust.last_name ~ 'T[ru]'
  returning *;
- Delete query with using. Let's delete emails whose first name begins with 'Al' and last begin with 'Tr' or 'Tu'
  DELETE FROM otus.email e
  USING otus.customer c
  WHERE c.id = e.customer_fk
  AND c.first_name ~ 'Al'
  AND c.last_name ~ 'T[ru]' RETURNING e.*;
  
