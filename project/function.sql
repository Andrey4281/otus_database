CREATE OR REPLACE FUNCTION getOrdersReport(leftBorderDeliveryDate date,
                                           rightBorderDeliveryDate date,
                                           supplierId int,
                                           groupingClause otus.reportGroupingClause DEFAULT 'product')
    RETURNS TABLE
            (
                group_column varchar,
                totalCost    decimal(19, 4),
                totalAmount  decimal(10, 2)
            )
AS
$$
DECLARE baseQuery varchar(2024) = 'SELECT
    ${group.column} as group_column,
    sum(oi.total_cost) as totalCost,
    sum(oi.amount) as totalAmount
FROM otus.order_item oi
         INNER JOIN otus.product_item pi on oi.product_item_id = pi.id
         INNER JOIN otus.product p ON (pi.product_fk = p.id)
         INNER JOIN otus.manufacturer m ON p.manufacturer_fk = m.id
         INNER JOIN otus.product_category_ref pcr ON pcr.product_fk = p.id
         INNER JOIN otus.product_category pc ON pc.id = pcr.product_category_fk
WHERE oi.delivery_date BETWEEN  ''${leftBorderDeliveryDate}'' AND ''${rightBorderDeliveryDate}'' AND pi.supplier_fk = ${supplierId}
GROUP BY ${group.column}';
BEGIN
    IF (leftBorderDeliveryDate IS NULL) THEN
        RAISE EXCEPTION 'NULL is not allowed for leftBorderDeliveryDate.';
END IF;
IF (rightBorderDeliveryDate IS NULL) THEN
        RAISE EXCEPTION 'NULL is not allowed for rightBorderDeliveryDate.';
END IF;
IF (supplierId IS NULL) THEN
        RAISE EXCEPTION 'NULL is not allowed for supplierId.';
end if;
baseQuery = replace(baseQuery, '${leftBorderDeliveryDate}', leftBorderDeliveryDate::varchar);
baseQuery = replace(baseQuery, '${rightBorderDeliveryDate}', rightBorderDeliveryDate::varchar);
baseQuery = replace(baseQuery, '${supplierId}', supplierId::varchar);
IF (groupingClause = 'product') THEN
        baseQuery = replace(baseQuery, '${group.column}', 'p.name');
ELSEIF (groupingClause = 'manufacturer') THEN
        baseQuery = replace(baseQuery, '${group.column}', 'm.name');
ELSEIF (groupingClause = 'category') THEN
        baseQuery = replace(baseQuery, '${group.column}', 'pc.name');
END IF;
RETURN QUERY EXECUTE baseQuery;
END;
$$ LANGUAGE plpgsql;

SELECT group_column, totalCost, totalAmount FROM getOrdersReport('2024-01-01', '2028-01-01', 1, 'product');

CREATE OR REPLACE FUNCTION getGoods(search varchar(256),
                                    categoryId int,
                                    manufacturerId int,
                                    lowerBorderPrice decimal(19, 4),
                                    rightBorderPrice decimal(19, 4),
                                    customerId int,
                                    sortColumn varchar(50),
                                    lim int,
                                    offs int,
                                    isDeliveryInTheSameCountry boolean default false,
                                    isDeliveryInTheSameCity boolean default false,
                                    sortDirectionIsAsc boolean default true)
    RETURNS TABLE
            (
                productName         varchar,
                productDescription  text,
                manufacturerName    varchar,
                productCategoryName varchar,
                productItemPrice    numeric(19, 4),
                deliveryCost        numeric(19, 4),
                deliveryDuration    interval
            )
AS
$$
DECLARE
    baseQuery      varchar(4024) = 'SELECT p.name AS productName,
       p.description AS productDescription,
       m.name AS manufacturerName,
       pc.name AS productCategoryName,
       pi.price AS productItemPrice,
       dk.cost AS deliveryCost,
       dk.duration AS deliveryDuration
FROM otus.product_item pi
INNER JOIN otus.supplier s ON (s.id = pi.supplier_fk)
INNER JOIN otus.delivery_kind dk ON s.id = dk.supplier_fk
INNER JOIN otus.product p ON (pi.product_fk = p.id)
INNER JOIN otus.manufacturer m ON (m.id = p.manufacturer_fk)
INNER JOIN otus.product_category_ref pcr ON (pcr.product_fk = p.id)
INNER JOIN otus.product_category pc ON (pc.id = pcr.product_category_fk)
${warehouseJoin}
${warehouseContactDataJoin}
WHERE 1=1';
filters        varchar(4024) = '';
sort           varchar(1024) = '';
limitValue     varchar(1024) = '';
offsetValue    varchar(1024) = '';
orderDirection varchar(10)   = '';
BEGIN
    IF (search IS NOT NULL) THEN
        filters = CONCAT(filters,
                         REPLACE(' AND p.product_search @@ to_tsquery(''english'', ''${value}'')', '${value}', search));
END IF;
IF (categoryId IS NOT NULL) THEN
        filters = CONCAT(filters, REPLACE(' AND pc.id = ${value}', '${value}', categoryId::varchar));
END IF;
IF (manufacturerId IS NOT NULL) THEN
        filters = CONCAT(filters, REPLACE(' AND m.id = ${value}', '${value}', manufacturerId::varchar));
END IF;
IF (lowerBorderPrice IS NOT NULL) THEN
        filters = CONCAT(filters, REPLACE(' AND pi.price > ${value}', '${value}', lowerBorderPrice::varchar));
END IF;
IF (rightBorderPrice IS NOT NULL) THEN
        filters = CONCAT(filters, REPLACE(' AND pi.price < ${value}', '${value}', rightBorderPrice::varchar));
END IF;
IF (isDeliveryInTheSameCountry = true OR isDeliveryInTheSameCity = true) THEN
        baseQuery = REPLACE(baseQuery, '${warehouseJoin}', ' INNER JOIN otus.warehouse w ON (w.supplier_fk = s.id)');
baseQuery = REPLACE(baseQuery, '${warehouseContactDataJoin}',
    ' INNER JOIN otus.warehouse_contact_data wcd ON (wcd.warehouse_fk = w.id)');
IF (isDeliveryInTheSameCountry = true) THEN
            filters = CONCAT(filters, REPLACE(
                    ' AND wcd.country_fk IN (SELECT ccd.country_fk FROM otus.customer_contact_data ccd WHERE ccd.customer_fk = ${value})',
                    '${value}', customerId::varchar));
END IF;
IF (isDeliveryInTheSameCity = true) THEN
            filters = CONCAT(filters, REPLACE(
                    ' AND wcd.street_fk IN (SELECT ccd.street_fk FROM otus.customer_contact_data ccd WHERE ccd.customer_fk = ${value})',
                    '${value}', customerId::varchar));
END IF;
ELSE
        baseQuery = REPLACE(baseQuery, '${warehouseJoin}', '');
baseQuery = REPLACE(baseQuery, '${warehouseContactDataJoin}', '');
END IF;
IF (sortColumn IS NOT NULL) THEN
        orderDirection = CASE WHEN (sortDirectionIsAsc = true) THEN 'ASC' ELSE 'DESC' END;
sort = CONCAT(' ORDER BY ', sortColumn, ' ', orderDirection);
END IF;
IF (limitValue IS NOT NULL) THEN
        limitValue = CONCAT(limitValue, REPLACE(' LIMIT ${value}', '${value}', lim::varchar));
END IF;
IF (limitValue IS NOT NULL AND offsetValue IS NOT NULL) THEN
        offsetValue = CONCAT(offsetValue, REPLACE(' OFFSET ${value}', '${value}', offs::varchar));
END IF;
baseQuery = CONCAT(baseQuery, filters, sort, limitValue, offsetValue);
RAISE NOTICE 'Query executed: %', baseQuery;
RETURN QUERY EXECUTE baseQuery;
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM getGoods('Refrigerator', null, null, null, null, null, null, null, null);

SELECT *
FROM getGoods('Refrigerator', 1, null, null, null, null, null, null, null);

SELECT *
FROM getGoods('Refrigerator', 1, 2, 50000, 90000, null, null, null, null);

SELECT *
FROM getGoods('Refrigerator', 1, 2, 50000, 90000, 1, 'productItemPrice', 100, 100, true);


CREATE OR REPLACE FUNCTION saveOrder(customerId bigint, order_items json)
    RETURNS void
AS
$$
DECLARE
    json_array_length int;
product_item_id_val bigint;
delivery_kind_id_val int;
supplier_pick_up_point_id_val int;
amount_val numeric(10, 2);
total_cost_val numeric(19, 4);
delivery_date_val date;
order_id_val bigint;
v_rec record;
counter int;
min_order_item_date date;
BEGIN
SELECT json_array_length(order_items) INTO json_array_length;
RAISE NOTICE 'array length: %', json_array_length;
FOR counter IN 0..json_array_length - 1 LOOP
        FOR v_rec IN (SELECT * FROM json_each_text(json_array_element(order_items, counter))
                      WHERE key = 'delivery_date') LOOP
            IF (min_order_item_date IS NULL) THEN
                min_order_item_date := to_date(v_rec.value, 'YYYY-MM-DD');
ELSEIF (min_order_item_date > to_date(v_rec.value, 'YYYY-MM-DD')) THEN
                min_order_item_date := to_date(v_rec.value, 'YYYY-MM-DD');
END IF;
END LOOP;
END LOOP;
RAISE NOTICE 'Min date: %', min_order_item_date;
INSERT INTO otus."order"(customer_id, delivary_date) VALUES (customerId, min_order_item_date) RETURNING id INTO order_id_val;
RAISE NOTICE 'OrderId: %', order_id_val;
FOR counter IN 0..json_array_length - 1 LOOP
            FOR v_rec IN (SELECT * FROM json_each_text(json_array_element(order_items, counter))) LOOP
                CASE
                    WHEN v_rec.key = 'product_item_id' THEN
                    product_item_id_val := v_rec.value;
WHEN v_rec.key = 'delivery_kind_id' THEN
                    delivery_kind_id_val := v_rec.value;
WHEN v_rec.key = 'supplier_pick_up_point_id' THEN
                    supplier_pick_up_point_id_val := v_rec.value;
WHEN v_rec.key = 'amount' THEN
                    amount_val := v_rec.value;
WHEN v_rec.key = 'total_cost' THEN
                    total_cost_val := v_rec.value;
WHEN v_rec.key = 'delivery_date' THEN
                    delivery_date_val := to_date(v_rec.value, 'YYYY-MM-DD');
END CASE;
END LOOP;
INSERT INTO otus.order_item(order_id, product_item_id, delivery_kind_id, supplier_pick_up_point_id, amount, total_cost, delivery_date, status)
VALUES (order_id_val, product_item_id_val, delivery_kind_id_val, supplier_pick_up_point_id_val, amount_val, total_cost_val, delivery_date_val, 'NEW');
END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT saveOrder(1, '[{"product_item_id": 1, "delivery_kind_id": 1, "supplier_pick_up_point_id": 1, "amount": 2.0, "total_cost": 1000.000, "delivery_date": "2024-08-27"},
  {"product_item_id": 3, "delivery_kind_id": 2, "supplier_pick_up_point_id": 1, "amount": 5.0, "total_cost": 5000.000, "delivery_date": "2024-08-29"}]');

SELECT * FROM otus."order" o
                  INNER JOIN otus.order_item oi on o.id = oi.order_id
WHERE o.id = 1123241 AND o.delivary_date BETWEEN '2024-08-01' AND '2024-08-31'
  AND oi.delivery_date BETWEEN '2024-08-01' AND '2024-08-31' AND customer_id = 1;