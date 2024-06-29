-- Procedure for selecting products using various filters:
DELIMITER $$
USE otus $$
CREATE PROCEDURE getGoods(search varchar(256),
                          categoryId int unsigned,
                          manufacturerId int unsigned,
                          lowerBorderPrice decimal(19, 4),
                          rightBorderPrice decimal(19, 4),
                          leftBorderDeliveryDate date,
                          rightBorderDeliveryDate date,
                          sortColumn varchar(50),
                          sortDirectionIsAsc boolean,
                          limitValue int unsigned,
                          offsetValue int unsigned)
BEGIN
    SET @baseQuery = 'SELECT p.name, m.name, pc.name, pi.amount, pi.price, pi.delivery_date
FROM otus.product p
         INNER JOIN otus.manufacturer m ON p.manufacturer_fk = m.id
         INNER JOIN otus.product_category_ref pcr ON pcr.product_fk = p.id
         INNER JOIN otus.product_category pc ON pc.id = pcr.product_category_fk
         INNER JOIN otus.product_item pi ON pi.product_fk = p.id';
    SET @filters = '';
    IF (search IS NOT NULL
        OR categoryId IS NOT NULL
        OR manufacturerId IS NOT NULL
        OR lowerBorderPrice IS NOT NULL
        OR rightBorderPrice IS NOT NULL
        OR leftBorderDeliveryDate IS NOT NULL
        OR rightBorderDeliveryDate IS NOT NULL) THEN
        SET @filters = CONCAT(@filters, ' WHERE ');
        SET @hasOtherFilter = false;
        IF (search IS NOT NULL) THEN
            SET @hasOtherFilter = true;
            SET @filters = CONCAT(@filters, REPLACE('MATCH(description) AGAINST (''$value'')', '$value', search));
        END IF;
        IF (categoryId IS NOT NULL) THEN
            IF (@hasOtherFilter = true) THEN
                SET @filters = CONCAT(@filters, ' AND ');
            END IF;
            SET @filters = CONCAT(@filters, REPLACE(' pc.id = $value', '$value', categoryId));
            SET @hasOtherFilter = true;
        END IF;
        IF (manufacturerId IS NOT NULL) THEN
            IF (@hasOtherFilter = true) THEN
                SET @filters = CONCAT(@filters, ' AND ');
            END IF;
            SET @filters = CONCAT(@filters, REPLACE(' m.id = $value', '$value', manufacturerId));
            SET @hasOtherFilter = true;
        END IF;
        IF (lowerBorderPrice IS NOT NULL) THEN
            IF (@hasOtherFilter = true) THEN
                SET @filters = CONCAT(@filters, ' AND ');
            END IF;
            SET @filters = CONCAT(@filters, REPLACE(' pi.price > $value', '$value', lowerBorderPrice));
            SET @hasOtherFilter = true;
        END IF;
        IF (rightBorderPrice IS NOT NULL) THEN
            IF (@hasOtherFilter = true) THEN
                SET @filters = CONCAT(@filters, ' AND ');
            END IF;
            SET @filters = CONCAT(@filters, REPLACE(' pi.price < $value', '$value', rightBorderPrice));
            SET @hasOtherFilter = true;
        END IF;
        IF (leftBorderDeliveryDate IS NOT NULL) THEN
            IF (@hasOtherFilter = true) THEN
                SET @filters = CONCAT(@filters, ' AND ');
            END IF;
            SET @filters = CONCAT(@filters, REPLACE(' pi.delivery_date >= ''$value''', '$value', leftBorderDeliveryDate));
            SET @hasOtherFilter = true;
        END IF;
        IF (rightBorderDeliveryDate IS NOT NULL) THEN
            IF (@hasOtherFilter = true) THEN
                SET @filters = CONCAT(@filters, ' AND ');
            END IF;
            SET @filters = CONCAT(@filters, REPLACE(' pi.delivery_date <= ''$value''', '$value', rightBorderDeliveryDate));
        END IF;
    END IF;
    SET @sort = '';
    IF (sortColumn IS NOT NULL) THEN
        SET @orderDirection = IF(sortDirectionIsAsc IS NOT NULL AND sortDirectionIsAsc = true, 'ASC', 'DESC');
        SET @sort = CONCAT(' ORDER BY ', sortColumn, ' ', @orderDirection);
    END IF;
    SET @limit = '';
    IF (limitValue IS NOT NULL) THEN
        SET @limit = CONCAT(@limit, REPLACE(' LIMIT $value', '$value', limitValue));
    END IF;
    SET @offset = '';
    IF (limitValue IS NOT NULL AND offsetValue IS NOT NULL) THEN
        SET @offset = CONCAT(@offset, REPLACE(' OFFSET $value', '$value', offsetValue));
    END IF;
    SET @baseQuery = CONCAT(@baseQuery, @filters, @sort, @limit, @offset);
    PREPARE stmp FROM @baseQuery;
    EXECUTE stmp;
END $$

DELIMITER ;

CREATE USER 'client'@'localhost' IDENTIFIED BY 'client';
GRANT EXECUTE ON PROCEDURE otus.getGoods TO 'client'@'localhost';

-- Sales report for a certain period with different levels of grouping (by product, by category, by manufacturer):
DELIMITER $$
USE otus $$
CREATE PROCEDURE getOrdersReport(leftBorderDeliveryDate date,
                                 rightBorderDeliveryDate date,
                                 groupingClause ENUM ('product', 'manufacturer', 'category'))
BEGIN
    SET @baseQuery = 'SELECT ${group.column}, sum(pi.total_cost) as totalCost, sum(pi.amount) as totalAmount FROM purchase p
                                                                                        INNER JOIN otus.purchase_item pi on p.id = pi.purchase_id
                                                                                        INNER JOIN otus.product pro on pi.product_id = pro.id
                                                                                        INNER JOIN otus.manufacturer m ON pro.manufacturer_fk = m.id
                                                                                        INNER JOIN otus.product_category_ref pcr ON pcr.product_fk = p.id
                                                                                        INNER JOIN otus.product_category pc ON pc.id = pcr.product_category_fk
WHERE pi.delivery_date BETWEEN  ''${leftBorderDeliveryDate}'' AND ''${rightBorderDeliveryDate}''
GROUP BY ${group.column}';
    IF (leftBorderDeliveryDate IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NULL is not allowed for leftBorderDeliveryDate.';
    END IF;
    IF (rightBorderDeliveryDate IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NULL is not allowed for rightBorderDeliveryDate.';
    END IF;
    IF (groupingClause IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NULL is not allowed for groupingClause.';
    END IF;
    SET @baseQuery = replace(@baseQuery, '${leftBorderDeliveryDate}', leftBorderDeliveryDate);
    SET @baseQuery = replace(@baseQuery, '${rightBorderDeliveryDate}', rightBorderDeliveryDate);
    IF (groupingClause = 'product') THEN
        SET @baseQuery = replace(@baseQuery, '${group.column}', 'pro.name');
    ELSEIF (groupingClause = 'manufacturer') THEN
        SET @baseQuery = replace(@baseQuery, '${group.column}', 'm.name');
    ELSEIF (groupingClause = 'category') THEN
        SET @baseQuery = replace(@baseQuery, '${group.column}', 'pc.name');
    END IF;
    PREPARE stmp FROM @baseQuery;
    EXECUTE stmp;
END $$

DELIMITER ;

CREATE USER 'manager'@'localhost' IDENTIFIED BY 'manager';
GRANT EXECUTE ON PROCEDURE otus.getOrdersReport TO 'manager'@'localhost';