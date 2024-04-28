-- I want to find customer whose first name begins with 'Al' and last begin with 'Tr' or 'Tu':
SELECT * FROM otus.customer WHERE first_name ~ 'Al' and last_name ~ 'T[ru]';
-- Queries with INNER JOIN:
SELECT * FROM otus.customer c
INNER JOIN otus.email e ON e.customer_fk = c.id
WHERE c.first_name ~ 'Al' and c.last_name ~ 'T[ru]';
-- Changing join order in from expression doesn't change query result because inner join is commutative operation:
SELECT * FROM otus.email e
INNER JOIN otus.customer c ON e.customer_fk = c.id
WHERE c.first_name ~ 'Al' and c.last_name ~ 'T[ru]';
-- Query with LEFT JOIN
SELECT * FROM otus.customer c
LEFT JOIN otus.email e ON e.customer_fk = c.id
WHERE c.first_name ~ 'Al' and c.last_name ~ 'T[ru]';
-- Changing join order in from expression change query result
SELECT * FROM otus.email e
LEFT JOIN otus.customer c ON e.customer_fk = c.id
WHERE c.first_name ~ 'Al' and c.last_name ~ 'T[ru]';
-- Insert with returning information about inserted records:
INSERT INTO otus.email(email_text, active, main, customer_fk) VALUES ('AliceTran@mail.ru', true, true, 1988),
                                                                     ('AliceTran@yandex.ru', true, false, 1988),
                                                                     ('AliceTran@gmail.ru', false, false, 1988),
                                                                     ('AliceTucker@proton.com', true, true, 1992),
                                                                     ('AliceTrevino@yandex.ru', true, true, 1990) RETURNING *;
-- Update query with from clause. Let's deactivate emails whose first name begins with 'Al' and last begin with 'Tr' or 'Tu':
UPDATE otus.email SET active = false FROM
    (SELECT c.first_name, c.last_name, c.id FROM otus.customer c) as cust
WHERE cust.id = customer_fk
  AND cust.first_name ~ 'Al'
  AND cust.last_name ~ 'T[ru]'
returning *;
-- Delete query with using. Let's delete emails whose first name begins with 'Al' and last begin with 'Tr' or 'Tu':
DELETE FROM otus.email e
    USING otus.customer c
WHERE c.id = e.customer_fk
  AND c.first_name ~ 'Al'
  AND c.last_name ~ 'T[ru]' RETURNING e.*;