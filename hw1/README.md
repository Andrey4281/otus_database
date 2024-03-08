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