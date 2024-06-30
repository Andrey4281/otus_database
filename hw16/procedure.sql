-- Transaction to create customer
DELIMITER //

CREATE PROCEDURE saveCustomer(
    firstName varchar(30),
    lastName varchar(30),
    emailArray TEXT,
    phoneArray TEXT,
    cardNumber varchar(20),
    balanceVal decimal(19, 4),
    customerHistory json,
    OUT customerId INT UNSIGNED)
BEGIN
    DECLARE pointer INT UNSIGNED DEFAULT 1;
        DECLARE extractedString VARCHAR(56);
        DECLARE historyId INT UNSIGNED;
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
    INSERT INTO customer(first_name, last_name) VALUES (firstName, lastName);
    SELECT LAST_INSERT_ID() INTO customerId;
    WHILE pointer <= (LENGTH(emailArray) - LENGTH(REPLACE(emailArray, ',', '')) + 1)
    DO
    SET extractedString = SUBSTRING_INDEX(SUBSTRING_INDEX(emailArray, ',', pointer), ',', -1);
    INSERT INTO email(email_text, customer_fk) VALUES (extractedString, customerId);
    SET pointer = pointer + 1;
END WHILE;
SET pointer = 1;
WHILE pointer <= (LENGTH(phoneArray) - LENGTH(REPLACE(phoneArray, ',', '')) + 1)
DO
SET extractedString = SUBSTRING_INDEX(SUBSTRING_INDEX(phoneArray, ',', pointer), ',', -1);
INSERT INTO phone(phone_number, customer_fk) VALUES (extractedString, customerId);
SET pointer = pointer + 1;
END WHILE;
INSERT INTO credit_card(card_number, balance, customer_fk) VALUES (cardNumber, balanceVal, customerId);
INSERT INTO customer_history(history) VALUES (customerHistory);
SELECT LAST_INSERT_ID() INTO historyId;
UPDATE customer_history SET history = JSON_SET(history, '$.customerId', customerId) WHERE id = historyId;
COMMIT;
END //

DELIMITER ;

CALL saveCustomer(
        'Vlad',
        'Petrov',
        'Vlad2@mail.ru,Vlad2@gmail.com',
        '890020001986,8984671985',
        '4444 4444 4444 4444',
        1000000.00,
        '{
          "rootAction": "create",
          "firstName": {
            "action": "update",
            "oldValue": null,
            "value": "Vlad"
          },
          "lastName": {
            "action": "update",
            "oldValue": null,
            "value": "Petrov"
          },
          "emails": [
            {
              "action": "create",
              "value": "Vlad1@mail.ru"
            },
            {
              "action": "create",
              "value": "Vlad2@gmail.com"
            }
          ],
          "phones": [
            {
              "action": "create",
              "value": "890020001987"
            },
            {
              "action": "create",
              "value": "8984671982"
            }
          ],
          "cards": [
            {
              "action": "create",
              "value": "4444 4444 4444 4443"
            }
          ]
        }', @customerId
    );

-- Import data
LOAD DATA
    INFILE '/var/lib/mysql-files/manufactorer.csv'
        INTO TABLE supplier
        FIELDS TERMINATED BY ",";