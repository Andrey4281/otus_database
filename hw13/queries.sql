--1. Find all customer without emails. Query with having
SELECT cust.id
FROM otus.customer cust
         LEFT JOIN otus.email e on (cust.id = e.customer_fk AND e.active = true)
GROUP BY cust.id
HAVING count(e.customer_fk) = 0;
--2. Print all customer with property has email. Query with case
SELECT cust.id,
       CASE
           WHEN (count(e.customer_fk) > 0)
               THEN 'yes'
           ELSE 'no'
           END as has_email
FROM otus.customer cust
         LEFT JOIN otus.email e on (cust.id = e.customer_fk)
WHERE e.active = true
GROUP BY cust.id;
--3. The most expensive and the least expensive product in each category:
SELECT pc.name, min(pi.price), max(pi.price)
FROM otus.product_item pi
         INNER JOIN otus.product_category_ref pcr ON pcr.product_fk = pi.product_fk
         INNER JOIN otus.product_category pc ON pc.id = pcr.product_category_fk
GROUP BY pc.name;
-- 4. Count of products by category with rollup
SELECT IF(GROUPING(pc.name), 'Total count', pc.name) AS category,
       count(pcr.product_fk)
FROM otus.product_category_ref pcr
         INNER JOIN otus.product_category pc ON pc.id = pcr.product_category_fk
GROUP BY pc.name WITH ROLLUP;
--5. Min price, max price for each product and offer count
SELECT p.name, min(pi.price), max(pi.price), sum(pi.amount)
FROM otus.product_item pi
         INNER JOIN otus.product p ON p.id = pi.product_fk
GROUP BY p.name;