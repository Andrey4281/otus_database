--1. Data for the first query with having
INSERT INTO customer (first_name, last_name) VALUES ('Andrey', 'Semenov');
INSERT INTO email (email_text, active, main, customer_fk)
VALUES ('Andrey@mail.ru', true, true, 1), ('Andrey@gmail.com', true, true, 1);
INSERT INTO phone(phone_number, active, main, customer_fk)
VALUES ('9002000486', true, true, 1);
INSERT INTO credit_card(card_number, balance, customer_fk, main, active)
VALUES ('XXXX XXXX XXXX XXXX', 10.0, 1, true, true);
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
INSERT INTO otus.customer(first_name, last_name) VALUES ('Ivan', 'Ivanov');
INSERT INTO otus.email(email_text, active, main, customer_fk)
VALUES ('Ivan@yandex.ru', false, true, 3),
       ('Ivan@gmail.com', false, false, 3);
INSERT INTO otus.customer(first_name, last_name) VALUES ('Dmitri', 'Krasnov');
--2. Data for the second query is the same as for the first
--3. Data for the third query
INSERT INTO otus.unit(name) VALUES ('unit');
INSERT INTO otus.manufacturer(name) VALUES ('Apple');
INSERT INTO otus.product_category(name) VALUES ('laptop');
INSERT INTO otus.product(name, manufacturer_fk, unit_fk) VALUES ('Macbook M2 Pro', 1, 1);
INSERT INTO otus.product_category_ref(product_category_fk, product_fk) VALUES (1, 1);
INSERT INTO otus.supplier(name) VALUES ('entrepreneur');
INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
VALUES (1, 1, '2024-06-09', 100000.50, 10.00);

INSERT INTO otus.product_category(name) VALUES ('Cell phone');
INSERT INTO otus.product(name, manufacturer_fk, unit_fk) VALUES ('iPhone 15', 1, 1);
INSERT INTO otus.product_category_ref(product_category_fk, product_fk) VALUES (2, 2);
INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
VALUES (1, 2, '2024-06-09', 80000.00, 100.00);

INSERT INTO otus.manufacturer(name) VALUES ('Lenovo');
INSERT INTO otus.product(name, manufacturer_fk, unit_fk) VALUES ('Lenovo IdeaPad 1 14IGL7', 2, 1);
INSERT INTO otus.product_category_ref(product_category_fk, product_fk) VALUES (1, 3);
INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
VALUES (1, 3, '2024-06-09', 50000.50, 15.00);

INSERT INTO otus.manufacturer(name) VALUES ('Samsung');
INSERT INTO otus.product(name, manufacturer_fk, unit_fk) VALUES ('Samsung Galaxy A24', 3, 1);
INSERT INTO otus.product_category_ref(product_category_fk, product_fk) VALUES (2, 4);
INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
VALUES (1, 4, '2024-06-09', 30000, 30.00);
INSERT INTO otus.supplier(name) VALUES ('fast entrepreneur');
INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
VALUES (2, 1, '2024-06-06', 120000.50, 15.00);
--4. Data for the fourth query is the same as for the third
--5. Data for the fifth query is the same as for the third

