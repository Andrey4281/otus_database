## You can find sql script for creating database in file 'script.sql'
- In this file you can also find a field description

## Local environment for running PostgreSQL and PgAmdin is in the file 'docker-compose.yaml'

## By using this studying database you can solve the next tasks:
- We can add a new product of some category and manufacturer
- Customer can find a product from catalog by category and manufacturer and get list of needed products
- Then Customer can choose needed product and check availability among different supplier (See product item table)
- Before creating order we check available balance in customer credit card and product available count for chosen supplier
- After creating order we decrease available count from product_item_table for supplier and balance on customer credit card
- Customer can find all his order for date ranges