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
                productName varchar,
                productDescription  text,
                manufacturerName  varchar,
                productCategoryName varchar,
                productItemPrice numeric(19, 4),
                deliveryCost numeric(19, 4),
                deliveryDuration interval
            )
AS
$$
DECLARE baseQuery varchar(4024) = 'SELECT p.name AS productName,
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
DECLARE filters varchar(4024) = '';
DECLARE sort varchar(1024) = '';
DECLARE limitValue varchar(1024) = '';
DECLARE offsetValue varchar(1024) = '';
DECLARE orderDirection varchar(10) = '';
BEGIN
    IF (search IS NOT NULL) THEN
        filters = CONCAT(filters, REPLACE(' AND p.product_search @@ to_tsquery(''english'', ''${value}'')', '${value}', search));
END IF;
IF (categoryId IS NOT NULL) THEN
        filters = CONCAT(filters, REPLACE(' AND pc.id = ${value}', '${value}', categoryId::varchar));
END IF;
IF (manufacturerId IS NOT NULL) THEN
        filters = CONCAT(filters, REPLACE(' AND m.id = ${value}', '${value}', manufacturerId::varchar));
END IF;
IF (lowerBorderPrice IS NOT NULL) THEN
        filters = CONCAT(filters, REPLACE(' AND pi.price > ${value}', '${value}', lowerBorderPrice));
END IF;
IF (rightBorderPrice IS NOT NULL) THEN
        filters = CONCAT(filters, REPLACE(' AND pi.price < ${value}', '${value}', rightBorderPrice));
END IF;
IF (isDeliveryInTheSameCountry = true OR isDeliveryInTheSameCity = true) THEN
        filters = REPLACE(filters, '${warehouseJoin}', ' INNER JOIN otus.warehouse w ON (w.supplier_fk = s.id)');
filters = REPLACE(filters, '${warehouseContactDataJoin}', ' INNER JOIN otus.warehouse_contact_data wcd ON (wcd.warehouse_fk = w.id)');
IF (isDeliveryInTheSameCountry = true) THEN
            filters = CONCAT(filters, REPLACE(' AND wcd.country_fk IN (SELECT ccd.country_fk FROM otus.customer_contact_data ccd WHERE ccd.customer_fk = ${value})', '${value}', customerId::varchar));
END IF;
IF (isDeliveryInTheSameCity = true) THEN
            filters = CONCAT(filters, REPLACE(' AND wcd.street_fk IN (SELECT ccd.street_fk FROM otus.customer_contact_data ccd WHERE ccd.customer_fk = ${value})', '${value}', customerId::varchar));
END IF;
ELSE
        filters = REPLACE(filters, '${warehouseJoin}', '');
filters = REPLACE(filters, '${warehouseContactDataJoin}', '');
END IF;
IF (sortColumn IS NOT NULL) THEN
        orderDirection = CASE WHEN (sortDirectionIsAsc = true) THEN 'ASC' ELSE 'DESC' END;
sort = CONCAT(' ORDER BY ', sortColumn, ' ', orderDirection);
END IF;
IF (limitValue IS NOT NULL) THEN
        limitValue = CONCAT(limitValue, REPLACE(' LIMIT ${value}', '${value}', lim));
END IF;
IF (limitValue IS NOT NULL AND offsetValue IS NOT NULL) THEN
        offsetValue = CONCAT(offsetValue, REPLACE(' OFFSET ${value}', '${value}', offs));
END IF;
baseQuery = CONCAT(baseQuery, filters, sort, limitValue, offsetValue);
RETURN QUERY EXECUTE baseQuery;
END;
$$ LANGUAGE plpgsql;