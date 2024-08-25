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
