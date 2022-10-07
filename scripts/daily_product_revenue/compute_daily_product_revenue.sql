CREATE DATABASE IF NOT EXISTS retail_gold_db
LOCATION '${bucket_name}/retail_gold.db';

USE retail_gold_db;

CREATE TABLE IF NOT EXISTS daily_product_revenue (
    order_date STRING,
    order_item_product_id INT,
    order_status STRING,
    product_quantity INT,
    product_revenue FLOAT
) USING PARQUET;

INSERT INTO daily_product_revenue
SELECT order_date,
    order_item_product_id,
    order_status,
    sum(order_item_quantity) AS product_quantity,
    round(sum(order_item_subtotal), 2) AS product_revenue
FROM retail_bronze_db.orders JOIN retail_bronze_db.order_items
    ON order_id = order_item_order_id
GROUP BY
    order_date,
    order_item_product_id,
    order_status;