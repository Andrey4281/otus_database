--1) Query with inner join. Find first 20 product's name, product category's name, manufacturer's name and unit's name by product's category name and manufacturer's name
SELECT p.name, pc.name, m.name, u.name FROM otus.product p
                                                INNER JOIN otus.product_category_ref pcr ON (p.id = pcr.product_fk)
                                                INNER JOIN otus.product_category pc ON (pc.id = pcr.product_category_fk)
                                                INNER JOIN otus.manufacturer m ON m.id = p.manufacturer_fk
                                                INNER JOIN otus.unit u ON u.id = p.unit_fk
WHERE pc.name = 'laptop' and m.name = 'Apple' limit 20;
--2) Query with left join. Find customer by its id with credit cards, emails, phones
SELECT cust.first_name, cust.last_name, e.active, e.main, e.email_text,
       cc.main, cc.active, cc.card_number,
       p.active, p.main, p.phone_number
FROM otus.customer cust
         LEFT JOIN otus.credit_card cc on cust.id = cc.customer_fk
         LEFT JOIN otus.email e on cust.id = e.customer_fk
         LEFT JOIN otus.phone p on cust.id = p.customer_fk
WHERE cust.id = 2;
--3) Find product's name, product category's name, manufacturer's name and unit's name by product's category name, manufacturer's name and product's name.
-- Our customer may want to find product by its name. We also can use fulltext search in this case instead like
SELECT p.name, pc.name, m.name, u.name FROM otus.product p
INNER JOIN otus.product_category_ref pcr ON (p.id = pcr.product_fk)
                                                INNER JOIN otus.product_category pc ON (pc.id = pcr.product_category_fk)
                                                INNER JOIN otus.manufacturer m ON m.id = p.manufacturer_fk
                                                INNER JOIN otus.unit u ON u.id = p.unit_fk
WHERE pc.name = 'laptop' and m.name = 'Apple' and lower(p.name) LIKE 'macbook%';
--4) Find all customer purchase with purchase items for the last month
SELECT p.delivary_date, pi.delivery_date, pi.amount, pi.total_cost, pi.delivery_date
FROM otus.purchase p
         INNER JOIN otus.purchase_item pi ON  (p.id = pi.purchase_id AND p.delivary_date = pi.delivery_date)
         INNER JOIN otus.product p2 on pi.product_id = p2.id
WHERE customer_id = 2 AND p.delivary_date BETWEEN '2024-06-01' AND '2024-06-30';
--5) Finding the parameters of a product batch by product which amount > 0 and delivery date is less than required one
SELECT s.name, pi.amount, pi.price, pi.delivery_date FROM otus.supplier s
                                                              INNER JOIN otus.product_item pi ON (s.id = pi.supplier_fk)
                                                              INNER JOIN otus.product p ON (p.id = pi.product_fk)
WHERE pi.amount > 0 AND p.id = 1 AND delivery_date < '2024-06-10'
ORDER BY pi.price;
--6) Finding all customer who bought goods at sum greater than 90000 during 2024 year. We can give them discount in the next year on base this data
SELECT c.id, sum(pi.total_cost) FROM customer c
INNER JOIN otus.purchase p on c.id = p.customer_id
INNER JOIN otus.purchase_item pi ON p.id = pi.purchase_id
WHERE p.delivary_date >= '2024-01-01' AND p.delivary_date <= '2024-12-31'
GROUP BY c.id
HAVING sum(pi.total_cost) > 90000.0;
