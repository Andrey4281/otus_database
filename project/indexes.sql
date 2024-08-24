-- полнотекстовый, обычные на запросы, покрывающий, частичный, функциональный
CREATE INDEX product_product_search_gin ON otus.product USING gin(product_search);