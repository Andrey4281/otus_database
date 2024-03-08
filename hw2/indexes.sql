CREATE UNIQUE INDEX product_category_ref_product_id_product_category_id_idx ON otus.product_category_ref USING btree(product_id, product_category_id);
ALTER TABLE otus.product ADD column product_search_name tsvector;
UPDATE otus.product SET product_search_name = to_tsvector('english', otus.product.name);
CREATE INDEX product_product_search_name_gin ON otus.product USING gin(product_search_name);
CREATE INDEX product_item_product_id_supplier_id_idx ON otus.product_item USING btree(product_id, supplier_id);
CREATE INDEX credit_card_customer_id_idx ON otus.credit_card USING btree(customer_id);
CREATE INDEX purchase_customer_id_idx ON otus.purchase USING btree(customer_id);
CREATE INDEX purchase_item_id_purchase_idx ON otus.purchase_item USING btree(id_purchase);
CREATE INDEX purchase_item_id_product_idx ON otus.purchase_item USING btree(id_product);
CREATE INDEX purchase_item_id_supplier_idx ON otus.purchase_item USING btree(id_supplier);


