SHOW databases;

USE retail_bronze_db;

SHOW tables;

!gsutil ls gs://airetail/retail_bronze.db/orders;
!gsutil ls gs://airetail/retail_bronze.db/order_items;

SELECT 'Displaying count for orders';
SELECT count(*) FROM orders;

SELECT 'Displaying count for order_items';
SELECT count(*) FROM order_items;

USE retail_gold_db;

SHOW tables;

!gsutil ls gs://airetail/retail_gold.db/daily_product_revenue;

SELECT 'Displaying count for daily_product_revenue';
SELECT count(*) FROM daily_product_revenue;

SELECT * FROM daily_product_revenue LIMIT 20;