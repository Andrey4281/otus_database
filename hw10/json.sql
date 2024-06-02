-- We want to store history changes of customers

-- 1. Let's add a new customer:
INSERT INTO customer (first_name, last_name) VALUES ('Andrey', 'Semenov');
INSERT INTO email (email_text, active, main, customer_fk)
VALUES ('Andrey@mail.ru', true, true, 1), ('Andrey@gmail.com', true, true, 1);
INSERT INTO phone(phone_number, active, main, customer_fk)
VALUES ('9002000486', true, true, 1);
INSERT INTO credit_card(card_number, balance, customer_fk, main, active)
VALUES ('XXXX XXXX XXXX XXXX', 10.0, 1, true, true);
-- 2. In result we have the next customer's history object:
INSERT INTO `customer_history`(history)
VALUES ('{
  "rootAction": "create",
  "customerId": 1,
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
-- 3. Let's update the customer by adding a new credit card and delete the old card:
DELETE FROM credit_card WHERE card_number = 'XXXX XXXX XXXX XXXX';
INSERT INTO credit_card(card_number, balance, customer_fk, main, active)
VALUES ('1111 1111 1111 1111', 10.0, 1, true, true);
--4. We have the next history object:
INSERT INTO `customer_history`(history)
VALUES ('{
  "rootAction": "update",
  "customerId": 1,
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
--5. Now we can get all history objects for the customer and draw in your UI by using history json field:
SELECT id, history FROM customer_history ch
WHERE history ->>'$.customerId' = 1
order by id;