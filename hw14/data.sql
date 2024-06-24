-- 1. Full text search.
UPDATE otus.product SET description = 'Macbook M2 Pro.MacOS is the most advanced desktop operating system in the world. And with macOS Sonoma, work and play on your Mac are even more powerful — with new ways to elevate your video presentations, boost your gaming performance, and personalize your device.Apple.laptop' WHERE name = 'Macbook M2 Pro';
UPDATE otus.product SET description = 'iPhone 15.The iPhone 15 and iPhone 15 Plus are smartphones designed, developed, and marketed by Apple Inc. They are the seventeenth and current generation of iPhones, succeeding the iPhone 14 and iPhone 14 Plus. The devices were announced on September 12, 2023, during the Apple Event at Apple Park in Cupertino, California alongside the higher-priced iPhone 15 Pro and 15 Pro Max.Apple.Cell phone' WHERE name = 'iPhone 15';
UPDATE otus.product SET description = 'Lenovo IdeaPad 1 14IGL7.The IdeaPad 1i raises the bar on every affordable laptop with a super-efficient up-to-12th Generation Intel processor in a thin and compact 17.9 mm chassis that makes multitasking a breeze while boosting energy efficiency with up-to-11 hours of battery life and rapid charge. Get more value with four-sided narrow bezels for maximum screen, Dolby Audio speakers and Flip to Start for instant bootup. Optimize your video call experience with a 1MP camera that comes with a privacy shutter to keep out prying eyes and Smart Noise Cancelling to cut out background noise.Lenovo.laptop' WHERE name = 'Lenovo IdeaPad 1 14IGL7';
UPDATE otus.product SET description = 'Samsung Galaxy A24.The Samsung Galaxy A24 is an Android-based smartphone designed, developed and marketed by Samsung Electronics as a part of its Galaxy A series. This phone was announced on April 19, 2023.Samsung.Cell phone' WHERE name = 'Samsung Galaxy A24';
--2. History index
INSERT INTO `customer_history`(history)
VALUES ('{
  "rootAction": "create",
  "customerId": 2,
  "firstName": {
    "action": "update",
    "oldValue": null,
    "value": "Andrey"
  },
  "lastName": {
    "action": "update",
    "oldValue": null,
    "value": "Semenov"
  },
  "emails": [
    {
      "action": "create",
      "value": "Andrey@mail.ru"
    },
    {
      "action": "create",
      "value": "Andrey@gmail.com"
    }
  ],
  "phones": [
    {
      "action": "create",
      "value": "89002000486"
    }
  ],
  "cards": [
    {
      "action": "create",
      "value": "XXXX XXXX XXXX XXXX"
    }
  ]
}');
INSERT INTO `customer_history`(history)
VALUES ('{
  "rootAction": "update",
  "customerId": 3,
  "cards": [
    {
      "action": "delete",
      "value": "XXXX XXXX XXXX XXXX"
    },
    {
      "action": "create",
      "value": "1111 1111 1111 1111"
    }
  ]
}');
INSERT INTO `customer_history`(history)
VALUES ('{
  "rootAction": "update",
  "customerId": 4,
  "cards": [
    {
      "action": "delete",
      "value": "XXXX XXXX XXXX XXXX"
    },
    {
      "action": "create",
      "value": "1111 1111 1111 1111"
    }
  ]
}');
INSERT INTO `customer_history`(history)
VALUES ('{
  "rootAction": "update",
  "customerId": 5,
  "cards": [
    {
      "action": "delete",
      "value": "XXXX XXXX XXXX XXXX"
    },
    {
      "action": "create",
      "value": "1111 1111 1111 1111"
    }
  ]
}');
--3. Find available product by product_id, price range and delivery date range
INSERT INTO otus.product_item (id, supplier_fk, product_fk, delivery_date, price, amount) VALUES (1, 1, 1, '2024-06-09', 100000.5000, 10.00);
INSERT INTO otus.product_item (id, supplier_fk, product_fk, delivery_date, price, amount) VALUES (2, 1, 2, '2024-06-09', 80000.0000, 100.00);
INSERT INTO otus.product_item (id, supplier_fk, product_fk, delivery_date, price, amount) VALUES (3, 1, 3, '2024-06-09', 50000.5000, 15.00);
INSERT INTO otus.product_item (id, supplier_fk, product_fk, delivery_date, price, amount) VALUES (4, 1, 4, '2024-06-09', 30000.0000, 30.00);
INSERT INTO otus.product_item (id, supplier_fk, product_fk, delivery_date, price, amount) VALUES (5, 2, 1, '2024-06-06', 120000.5000, 15.00);
--4. Find all purchase by customer:
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (1, 1, '2024-01-06');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (2, 1, '2024-01-08');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (3, 1, '2024-01-09');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (17, 2, '2024-06-09');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (4, 2, '2025-02-04');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (5, 1, '2026-03-03');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (6, 2, '2027-04-04');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (7, 1, '2028-05-09');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (8, 2, '2029-06-07');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (9, 2, '2030-06-08');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (10, 3, '2031-07-07');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (11, 3, '2032-07-09');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (12, 2, '2033-08-05');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (13, 1, '2034-09-05');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (14, 3, '2035-10-06');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (15, 2, '2035-11-11');
INSERT INTO otus.purchase (id, customer_id, delivary_date) VALUES (16, 3, '2035-12-09');

INSERT INTO otus.purchase_item (id, purchase_id, product_id, amount, total_cost, delivery_date) VALUES (1, 2, 1, 10.20, 100.5000, '2024-01-06');
INSERT INTO otus.purchase_item (id, purchase_id, product_id, amount, total_cost, delivery_date) VALUES (2, 2, 2, 1.00, 1000.0000, '2024-01-06');
INSERT INTO otus.purchase_item (id, purchase_id, product_id, amount, total_cost, delivery_date) VALUES (3, 3, 1, 5.00, 110.5000, '2024-01-08');
INSERT INTO otus.purchase_item (id, purchase_id, product_id, amount, total_cost, delivery_date) VALUES (4, 3, 2, 1.00, 1100.0000, '2024-01-08');
INSERT INTO otus.purchase_item (id, purchase_id, product_id, amount, total_cost, delivery_date) VALUES (5, 4, 1, 7.00, 150.5000, '2024-01-09');
INSERT INTO otus.purchase_item (id, purchase_id, product_id, amount, total_cost, delivery_date) VALUES (6, 4, 2, 2.00, 2100.0000, '2024-01-09');
INSERT INTO otus.purchase_item (id, purchase_id, product_id, amount, total_cost, delivery_date) VALUES (7, 17, 1, 1.00, 100000.5000, '2024-06-09');
--5. Find customer with its data
INSERT INTO otus.customer (id, first_name, last_name) VALUES (1, 'Andrey', 'Semenov');
INSERT INTO otus.customer (id, first_name, last_name) VALUES (2, 'Petr', 'Barsukov');
INSERT INTO otus.customer (id, first_name, last_name) VALUES (3, 'Ivan', 'Ivanov');
INSERT INTO otus.customer (id, first_name, last_name) VALUES (4, 'Dmitri', 'Krasnov');

INSERT INTO otus.credit_card (id, card_number, balance, customer_fk, main, active) VALUES (2, '1111 1111 1111 1111', 10.0000, 1, 1, 1);
INSERT INTO otus.credit_card (id, card_number, balance, customer_fk, main, active) VALUES (3, '2222 2222 2222 2222', 1000.2000, 2, 0, 1);
INSERT INTO otus.credit_card (id, card_number, balance, customer_fk, main, active) VALUES (4, '3333 3333 3333 3333', 1000000.5000, 2, 1, 1);

INSERT INTO otus.email (id, email_text, active, main, customer_fk) VALUES (1, 'Andrey@mail.ru', 1, 1, 1);
INSERT INTO otus.email (id, email_text, active, main, customer_fk) VALUES (2, 'Andrey@gmail.com', 1, 1, 1);
INSERT INTO otus.email (id, email_text, active, main, customer_fk) VALUES (3, 'PetrB@yandex.ru', 1, 1, 2);
INSERT INTO otus.email (id, email_text, active, main, customer_fk) VALUES (4, 'PetrB@gmail.com', 1, 0, 2);
INSERT INTO otus.email (id, email_text, active, main, customer_fk) VALUES (5, 'Ivan@yandex.ru', 0, 1, 3);
INSERT INTO otus.email (id, email_text, active, main, customer_fk) VALUES (6, 'Ivan@gmail.com', 0, 0, 3);

INSERT INTO otus.phone (id, phone_number, active, main, customer_fk) VALUES (1, '89002999488', 1, 1, 1);
INSERT INTO otus.phone (id, phone_number, active, main, customer_fk) VALUES (2, '89822999488', 1, 0, 2);