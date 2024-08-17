-- найти товары в своем городе(стране) по полнотекстовому поиску, производителю, категории

-- в своем городе
SELECT p.name, m.name, pc.name, pi.amount, pi.price
FROM otus.customer cu
         INNER JOIN otus.customer_contact_data ccd ON cu.id = ccd.customer_fk
         INNER JOIN otus.warehouse_contact_data wcd ON ccd.city_fk = wcd.city_fk
         INNER JOIN otus.warehouse w ON (w.id = wcd.warehouse_fk)
         INNER JOIN otus.product_item pi ON wcd.warehouse_fk = pi.warehouse_fk
         INNER JOIN otus.product p ON p.id = pi.product_fk
         INNER JOIN otus.manufacturer m ON (m.id = p.manufacturer_fk)
         INNER JOIN otus.unit u ON (u.id = p.unit_fk)
         INNER JOIN otus.product_category_ref pcr ON (pcr.product_fk = p.id)
         INNER JOIN otus.product_category pc ON (pc.id = pcr.product_category_fk);

-- в своей стране
SELECT p.name, m.name, pc.name, pi.amount, pi.price
FROM otus.customer cu
         INNER JOIN otus.customer_contact_data ccd ON cu.id = ccd.customer_fk
         INNER JOIN otus.warehouse_contact_data wcd ON ccd.country_fk = wcd.country_fk
         INNER JOIN otus.warehouse w ON (w.id = wcd.warehouse_fk)
         INNER JOIN otus.product_item pi ON wcd.warehouse_fk = pi.warehouse_fk
         INNER JOIN otus.product p ON p.id = pi.product_fk
         INNER JOIN otus.manufacturer m ON (m.id = p.manufacturer_fk)
         INNER JOIN otus.unit u ON (u.id = p.unit_fk)
         INNER JOIN otus.product_category_ref pcr ON (pcr.product_fk = p.id)
         INNER JOIN otus.product_category pc ON (pc.id = pcr.product_category_fk);