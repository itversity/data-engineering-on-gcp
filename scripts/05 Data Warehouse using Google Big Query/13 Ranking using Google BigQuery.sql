SELECT o.order_date,
    oi.order_item_product_id,
    round(sum(oi.order_item_subtotal), 2) AS revenue
FROM retail.orders AS o
    JOIN retail.order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

CREATE OR REPLACE VIEW retail.daily_product_revenue_v
AS
SELECT o.order_date,
    oi.order_item_product_id,
    round(sum(oi.order_item_subtotal), 2) AS revenue
FROM retail.orders AS o
    JOIN retail.order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1, 2;
    
SELECT * FROM retail.daily_product_revenue_v
ORDER BY 1, 3 DESC;

SELECT order_date,
    order_item_product_id,
    revenue,
    dense_rank() OVER (
        PARTITION BY order_date
        ORDER BY revenue DESC
    ) AS drank
FROM retail.daily_product_revenue_v
ORDER BY 1, 3 DESC;

SELECT * FROM (
    SELECT order_date,
        order_item_product_id,
        revenue,
        dense_rank() OVER (
            PARTITION BY order_date
            ORDER BY revenue DESC
        ) AS drank
    FROM retail.daily_product_revenue_v
) WHERE drank <= 3  
ORDER BY 1, 3 DESC;