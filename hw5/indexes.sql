-- We use this index for the next query:
-- SELECT c.first_name, c.last_name FROM otus.purchase_item pi
--   JOIN otus.purchase p ON  pi.purchase_fk = p.id
--   JOIN otus.customer c ON c.id = p.customer_fk
--   WHERE total_cost = 100;
CREATE INDEX purchase_item_total_cost_idx ON otus.purchase_item(total_cost);
-- We use index for full text search for the query:
-- SELECT * FROM otus.customer WHERE customer_search @@ to_tsquery('english', 'Acevedo');
UPDATE otus.customer SET customer_search = to_tsvector('english', first_name || ' ' || last_name);
CREATE INDEX customer_customer_search_gin ON otus.customer USING gin(customer_search);
-- We use this partial index for the next query:
-- SELECT c.first_name, c.last_name FROM otus.purchase_item pi
--   JOIN otus.purchase p ON  pi.purchase_fk = p.id
--   JOIN otus.customer c ON c.id = p.customer_fk
--   WHERE total_cost = 100;
CREATE INDEX purchase_item_total_cost_partial_idx ON otus.purchase_item(total_cost) WHERE total_cost < 120;
-- We use this composite index for the query:
-- SELECT c.first_name, c.last_name FROM otus.purchase_item pi
--    JOIN otus.purchase p ON  pi.purchase_fk = p.id
--    JOIN otus.customer c ON c.id = p.customer_fk
-- WHERE total_cost < 100 AND amount < 3;
CREATE INDEX purchase_item_total_cost_amount_idx ON otus.purchase_item(total_cost, amount);

