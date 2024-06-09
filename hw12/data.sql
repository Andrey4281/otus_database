--1) Data for the inner join query
INSERT INTO otus.unit(name) VALUES ('unit');
INSERT INTO otus.manufacturer(name) VALUES ('Apple');
INSERT INTO otus.product_category(name) VALUES ('laptop');
INSERT INTO otus.product(name, manufacturer_fk, unit_fk) VALUES ('Macbook M2 Pro', 1, 1);
INSERT INTO otus.product_category_ref(product_category_fk, product_fk) VALUES (1, 1);
--2) Data for the left join query
INSERT INTO otus.customer(first_name, last_name) VALUES ('Petr', 'Barsukov');
INSERT INTO otus.email(email_text, active, main, customer_fk)
VALUES ('PetrB@yandex.ru', true, true, 2),
       ('PetrB@gmail.com', true, false, 2);
INSERT INTO otus.phone(phone_number, active, main, customer_fk)
VALUES ('89002999488', true, true, 2),
       ('89822999488', true, false, 2);
INSERT INTO otus.credit_card(card_number, balance, customer_fk, main, active)
VALUES ('2222 2222 2222 2222', 1000.20, 2, false, true),
       ('3333 3333 3333 3333', 1000000.50, 2, true, true);
--3) Data for the third query as the same as for the first query
--4) Data for fourth query
INSERT INTO otus.purchase(customer_id, delivary_date) VALUES (2, '2024-06-09');
INSERT INTO otus.purchase_item(purchase_id, product_id, amount, total_cost, delivery_date)
VALUES (17, 1, 1, 100000.50, '2024-06-09');
--5) Data for the fifth query:
INSERT INTO otus.supplier(name) VALUES ('entrepreneur');
INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
VALUES (1, 1, '2024-06-09', 100000.50, 10.00);
--6) Data for sixth query have been already filled by the previous statements