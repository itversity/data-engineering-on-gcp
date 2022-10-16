SELECT * 
FROM EXTERNAL_QUERY(
  "tidy-fort-361710.us.retailpgexternal",
  "SELECT * FROM information_schema.tables WHERE table_schema = 'public'"
);

SELECT * 
FROM EXTERNAL_QUERY(
  "tidy-fort-361710.us.retailpgexternal",
  "SELECT order_date, count(*) AS order_count FROM orders GROUP BY 1 ORDER BY 2 DESC"
);

SELECT *
FROM EXTERNAL_QUERY(
  "tidy-fort-361710.us.retailpgexternal",
  "SELECT * FROM products"  
) AS p;

SELECT o.order_date,
  oi.order_item_product_id,
  p.product_name,
  round(sum(oi.order_item_subtotal)) AS revenue
FROM EXTERNAL_QUERY(
  "tidy-fort-361710.us.retailpgexternal",
  "SELECT * FROM products"  
) AS p 
  JOIN retail.order_items AS oi
    ON p.product_id = oi.order_item_product_id
  JOIN retail.orders AS o
    ON oi.order_item_order_id = o.order_id
GROUP BY 1, 2, 3
ORDER BY 1, 4 DESC;