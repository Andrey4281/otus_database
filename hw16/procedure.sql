-- Transaction to create customer
CREATE PROCEDURE parseCustomerContactToDatabase(
    parsedContacts text,
    contactDelimiter varchar(30),
    contactInsertScriptTemplate varchar(256),
    customerId INT)
BEGIN
    DECLARE
        pointer INT UNSIGNED DEFAULT 1;
    DECLARE extractedString VARCHAR(56);
    WHILE pointer <= (LENGTH(parsedContacts) - LENGTH(REPLACE(parsedContacts, contactDelimiter, '')) + 1)
        DO
            SET extractedString =
                    SUBSTRING_INDEX(SUBSTRING_INDEX(parsedContacts, contactDelimiter, pointer), contactDelimiter, -1);
            SET @sqlScript = REPLACE(contactInsertScriptTemplate, '${extractedString}', extractedString);
            SET @sqlScript = REPLACE(@sqlScript, '${customerId}', customerId);
            SELECT @sqlScript;
            PREPARE stmp FROM @sqlScript;
            EXECUTE stmp;
            SET pointer = pointer + 1;
        END WHILE;
    SET pointer = 1;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE saveCustomer(
    firstName varchar(30),
    lastName varchar(30),
    emailArray TEXT,
    phoneArray TEXT,
    cardNumber varchar(30),
    balanceVal decimal(19, 4),
    customerHistory json,
    OUT customerId INT UNSIGNED)
BEGIN
    DECLARE
        historyId INT UNSIGNED;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;
    START TRANSACTION;
    INSERT INTO customer(first_name, last_name) VALUES (firstName, lastName);
    SELECT LAST_INSERT_ID() INTO customerId;
    CALL parseCustomerContactToDatabase(emailArray, ',',
                                        'INSERT INTO email(email_text, customer_fk) VALUES (''${extractedString}'', ${customerId})',
                                        customerId);
    CALL parseCustomerContactToDatabase(phoneArray, ',',
                                        'INSERT INTO phone(phone_number, customer_fk) VALUES (''${extractedString}'', ${customerId})',
                                        customerId);
    INSERT INTO credit_card(card_number, balance, customer_fk) VALUES (cardNumber, balanceVal, customerId);
    INSERT INTO customer_history(history) VALUES (customerHistory);
    SELECT LAST_INSERT_ID() INTO historyId;
    UPDATE customer_history SET history = JSON_SET(history, '$.customerId', customerId) WHERE id = historyId;
    COMMIT;
END //

DELIMITER;

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
        INTO
        TABLE supplier
        FIELDS TERMINATED BY ",";