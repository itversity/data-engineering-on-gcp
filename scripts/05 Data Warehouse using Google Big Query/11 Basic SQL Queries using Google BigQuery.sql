SELECT * FROM retail.orders LIMIT 10;

SELECT * FROM retail.order_items LIMIT 10;

SELECT *
FROM retail.orders
WHERE order_status IN ('COMPLETE', 'CLOSED');

SELECT *
FROM retail.orders AS o
  JOIN retail.order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE order_status IN ('COMPLETE', 'CLOSED');

SELECT o.order_date,
    oi.order_item_product_id,
    round(sum(oi.order_item_subtotal), 2) AS revenue
FROM retail.orders AS o
    JOIN retail.order_items AS oi
      ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1, 2
ORDER BY 1, 3 DESC;