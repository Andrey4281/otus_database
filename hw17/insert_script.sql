-- 1. Insert unit, manufacturer and product_category:
INSERT INTO otus.unit(name) VALUES ('unit');
INSERT INTO otus.manufacturer(name) VALUES ('Samsung');
INSERT INTO otus.product_category(name) VALUES ('appliances');

-- 2. Insert products:
SELECT id
FROM manufacturer
WHERE name = 'Samsung'
INTO @manufacturer_id;
SELECT id FROM unit
WHERE name = 'unit' INTO @unit_id;

INSERT INTO otus.product(name, manufacturer_fk, unit_fk)
VALUES ('Refrigerator', @manufacturer_id, @unit_id),
       ('Washing machine', @manufacturer_id, @unit_id),
       ('Dishwasher', @manufacturer_id, @unit_id),
       ('Oven', @manufacturer_id, @unit_id),
       ('Microwave', @manufacturer_id, @unit_id),
       ('Food processor', @manufacturer_id, @unit_id),
       ('Electric griddle', @manufacturer_id, @unit_id),
       ('Vacuum cleaner', @manufacturer_id, @unit_id),
       ('Steam mop', @manufacturer_id, @unit_id),
       ('Robot vacuum', @manufacturer_id, @unit_id),
       ('Carpet cleaner', @manufacturer_id, @unit_id),
       ('Air purifier', @manufacturer_id, @unit_id),
       ('Humidifier', @manufacturer_id, @unit_id),
       ('Dehumidifier', @manufacturer_id, @unit_id),
       ('Space heater', @manufacturer_id, @unit_id),
       ('Fan', @manufacturer_id, @unit_id),
       ('Air conditioner', @manufacturer_id, @unit_id),
       ('Portable air conditioner', @manufacturer_id, @unit_id),
       ('Tower fan', @manufacturer_id, @unit_id),
       ('Ceiling fan', @manufacturer_id, @unit_id),
       ('Dehydrator', @manufacturer_id, @unit_id),
       ('Water filter', @manufacturer_id, @unit_id),
       ('Water dispenser', @manufacturer_id, @unit_id),
       ('Water purifier', @manufacturer_id, @unit_id),
       ('Garbage disposal', @manufacturer_id, @unit_id),
       ('Trash compactor', @manufacturer_id, @unit_id),
       ('Range hood', @manufacturer_id, @unit_id),
       ('Electric grill', @manufacturer_id, @unit_id),
       ('Electric can opener', @manufacturer_id, @unit_id),
       ('Espresso machine', @manufacturer_id, @unit_id),
       ('Tea kettle', @manufacturer_id, @unit_id),
       ('Wine cooler', @manufacturer_id, @unit_id),
       ('Blender', @manufacturer_id, @unit_id),
       ('Rice cooker', @manufacturer_id, @unit_id),
       ('Stand mixer', @manufacturer_id, @unit_id),
       ('Hand mixer', @manufacturer_id, @unit_id),
       ('Mixer', @manufacturer_id, @unit_id),
       ('Toaster', @manufacturer_id, @unit_id),
       ('Toaster oven', @manufacturer_id, @unit_id),
       ('Coffee maker', @manufacturer_id, @unit_id),
       ('Espresso maker', @manufacturer_id, @unit_id),
       ('Electric kettle', @manufacturer_id, @unit_id),
       ('Juicer', @manufacturer_id, @unit_id),
       ('Waffle maker', @manufacturer_id, @unit_id),
       ('Crepe maker', @manufacturer_id, @unit_id),
       ('Pancake maker', @manufacturer_id, @unit_id),
       ('Hot plate', @manufacturer_id, @unit_id),
       ('Deep fryer', @manufacturer_id, @unit_id),
       ('Air fryer', @manufacturer_id, @unit_id),
       ('Quesadilla maker', @manufacturer_id, @unit_id),
       ('Ice maker', @manufacturer_id, @unit_id),
       ('Water cooler', @manufacturer_id, @unit_id),
       ('Crockpot', @manufacturer_id, @unit_id),
       ('Bread maker', @manufacturer_id, @unit_id),
       ('Popcorn maker', @manufacturer_id, @unit_id),
       ('Nutribullet', @manufacturer_id, @unit_id),
       ('Food steamer', @manufacturer_id, @unit_id),
       ('Food saver', @manufacturer_id, @unit_id),
       ('Vacuum sealer', @manufacturer_id, @unit_id),
       ('Food dehydrator', @manufacturer_id, @unit_id),
       ('Yogurt maker', @manufacturer_id, @unit_id),
       ('Sous vide machine', @manufacturer_id, @unit_id),
       ('Electric skillet', @manufacturer_id, @unit_id),
       ('Fondue pot', @manufacturer_id, @unit_id),
       ('Rice maker', @manufacturer_id, @unit_id),
       ('Pressure cooker', @manufacturer_id, @unit_id),
       ('Slow cooker', @manufacturer_id, @unit_id),
       ('Indoor grill', @manufacturer_id, @unit_id),
       ('Panini press', @manufacturer_id, @unit_id),
       ('Food chopper', @manufacturer_id, @unit_id),
       ('Food slicer', @manufacturer_id, @unit_id),
       ('Mandoline', @manufacturer_id, @unit_id),
       ('Food scale', @manufacturer_id, @unit_id),
       ('Meat thermometer', @manufacturer_id, @unit_id),
       ('Bread machine', @manufacturer_id, @unit_id),
       ('Ice cream maker', @manufacturer_id, @unit_id),
       ('Frozen yogurt maker', @manufacturer_id, @unit_id),
       ('Popcorn machine', @manufacturer_id, @unit_id),
       ('Cotton candy machine', @manufacturer_id, @unit_id),
       ('Slushie machine', @manufacturer_id, @unit_id);

-- 3. Insert product category ref:
SELECT id FROM otus.product_category WHERE name = 'appliances' INTO @product_category_id;
SELECT @product_category_id;
INSERT INTO otus.product_category_ref(product_category_fk, product_fk)
SELECT @product_category_id, product.id FROM otus.product;

-- 4. Insert product item data:
INSERT INTO otus.supplier(name) VALUES ('main entrepreneur');
SELECT id FROM otus.supplier WHERE name = 'main entrepreneur' INTO @supplier_id;
INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
SELECT @supplier_id, product.id, '2024-04-14', rand() * 10000, rand() * 1000 FROM otus.product;

INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
SELECT @supplier_id, product.id, '2024-04-13', rand() * 10000, rand() * 1000 FROM otus.product;

INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
SELECT @supplier_id, product.id, '2024-04-12', rand() * 10000, rand() * 1000 FROM otus.product;

INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
SELECT @supplier_id, product.id, '2024-04-11', rand() * 10000, rand() * 1000 FROM otus.product;

INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
SELECT @supplier_id, product.id, '2024-04-10', rand() * 10000, rand() * 1000 FROM otus.product;

INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
SELECT @supplier_id, product.id, '2024-04-09', rand() * 10000, rand() * 1000 FROM otus.product;

INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
SELECT @supplier_id, product.id, '2024-04-08', rand() * 10000, rand() * 1000 FROM otus.product;

INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
SELECT @supplier_id, product.id, '2024-04-07', rand() * 10000, rand() * 1000 FROM otus.product;

INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
SELECT @supplier_id, product.id, '2024-04-07', rand() * 10000, rand() * 1000 FROM otus.product;

INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
SELECT @supplier_id, product.id, '2024-04-06', rand() * 10000, rand() * 1000 FROM otus.product;

INSERT INTO otus.product_item(supplier_fk, product_fk, delivery_date, price, amount)
SELECT @supplier_id, product.id, '2024-04-05', rand() * 10000, rand() * 1000 FROM otus.product;

-- 5. Insert customer data: (large file with 100000 records), see file customer.sql

-- 6. Insert customer purchase:
INSERT INTO otus.purchase(customer_id, delivary_date)
SELECT id, '2024-04-14' FROM otus.customer;

INSERT INTO otus.purchase_item(purchase_id, product_id, amount, total_cost, delivery_date)
SELECT id,  (SELECT id
             FROM product
             ORDER BY RAND()
             LIMIT 1), rand() * 1000, rand() * 10000, '2024-04-13'  FROM otus.purchase;