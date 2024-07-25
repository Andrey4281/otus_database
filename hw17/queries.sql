-- Let's look at a query to find stock balances for the 10 most popular products based on sales data for the period '2024-01-01' to '2024-04-01'
SELECT s.name, p.name, m.name, pc.name, pi.delivery_date, sum(pi.amount)
FROM otus.product p
         INNER JOIN (SELECT pui.product_id
                     FROM purchase_item pui
                     WHERE pui.delivery_date BETWEEN '2024-01-01' AND '2024-04-01'
                     GROUP BY product_id
                     ORDER BY sum(amount) DESC
                     LIMIT 10) as pp ON pp.product_id = p.id
         INNER JOIN otus.manufacturer m ON p.manufacturer_fk = m.id
         INNER JOIN otus.product_category_ref pcr ON pcr.product_fk = p.id
         INNER JOIN otus.product_category pc ON pc.id = pcr.product_category_fk
         INNER JOIN otus.product_item pi ON pi.product_fk = p.id
         INNER JOIN otus.supplier s ON s.id = pi.supplier_fk
WHERE pi.delivery_date > '2024-04-01'
GROUP BY s.name, p.name, m.name, pc.name, pi.delivery_date;
-- Let's look at a query plan in three formats before optimization:
-- 1)
EXPLAIN SELECT s.name, p.name, m.name, pc.name, pi.delivery_date, sum(pi.amount)
        FROM otus.product p
                 INNER JOIN (SELECT pui.product_id
                             FROM purchase_item pui
                             WHERE pui.delivery_date BETWEEN '2024-01-01' AND '2024-04-01'
                             GROUP BY product_id
                             ORDER BY sum(amount) DESC
                             LIMIT 10) as pp ON pp.product_id = p.id
                 INNER JOIN otus.manufacturer m ON p.manufacturer_fk = m.id
                 INNER JOIN otus.product_category_ref pcr ON pcr.product_fk = p.id
                 INNER JOIN otus.product_category pc ON pc.id = pcr.product_category_fk
                 INNER JOIN otus.product_item pi ON pi.product_fk = p.id
                 INNER JOIN otus.supplier s ON s.id = pi.supplier_fk
        WHERE pi.delivery_date > '2024-04-01'
        GROUP BY s.name, p.name, m.name, pc.name, pi.delivery_date;
-- 2) Json format
EXPLAIN FORMAT='json' SELECT s.name, p.name, m.name, pc.name, pi.delivery_date, sum(pi.amount)
    FROM otus.product p
    INNER JOIN (SELECT pui.product_id
    FROM purchase_item pui
    WHERE pui.delivery_date BETWEEN '2024-01-01' AND '2024-04-01'
    GROUP BY product_id
    ORDER BY sum(amount) DESC
    LIMIT 10) as pp ON pp.product_id = p.id
    INNER JOIN otus.manufacturer m ON p.manufacturer_fk = m.id
    INNER JOIN otus.product_category_ref pcr ON pcr.product_fk = p.id
    INNER JOIN otus.product_category pc ON pc.id = pcr.product_category_fk
    INNER JOIN otus.product_item pi ON pi.product_fk = p.id
    INNER JOIN otus.supplier s ON s.id = pi.supplier_fk
    WHERE pi.delivery_date > '2024-04-01'
    GROUP BY s.name, p.name, m.name, pc.name, pi.delivery_date;
-- 3)
EXPLAIN ANALYZE SELECT s.name, p.name, m.name, pc.name, pi.delivery_date, sum(pi.amount)
                FROM otus.product p
                         INNER JOIN (SELECT pui.product_id
                                     FROM purchase_item pui
                                     WHERE pui.delivery_date BETWEEN '2024-01-01' AND '2024-04-01'
                                     GROUP BY product_id
                                     ORDER BY sum(amount) DESC
                                     LIMIT 10) as pp ON pp.product_id = p.id
                         INNER JOIN otus.manufacturer m ON p.manufacturer_fk = m.id
                         INNER JOIN otus.product_category_ref pcr ON pcr.product_fk = p.id
                         INNER JOIN otus.product_category pc ON pc.id = pcr.product_category_fk
                         INNER JOIN otus.product_item pi ON pi.product_fk = p.id
                         INNER JOIN otus.supplier s ON s.id = pi.supplier_fk
                WHERE pi.delivery_date > '2024-04-01'
                GROUP BY s.name, p.name, m.name, pc.name, pi.delivery_date;