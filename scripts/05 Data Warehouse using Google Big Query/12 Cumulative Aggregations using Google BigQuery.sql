SELECT o.order_date,
    round(sum(oi.order_item_subtotal), 2) AS revenue
FROM retail.orders AS o
    JOIN retail.order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1
ORDER BY 1;

SELECT format_date('%Y%m', current_timestamp());

WITH daily_revenue AS (
    SELECT o.order_date,
        round(sum(oi.order_item_subtotal), 2) AS revenue
    FROM retail.orders AS o
        JOIN retail.order_items AS oi
        ON o.order_id = oi.order_item_order_id
    WHERE o.order_status IN ('COMPLETE', 'CLOSED')
    GROUP BY 1
) SELECT * FROM daily_revenue ORDER BY 1;

WITH daily_revenue AS (
    SELECT o.order_date,
        round(sum(oi.order_item_subtotal), 2) AS revenue
    FROM retail.orders AS o
        JOIN retail.order_items AS oi
        ON o.order_id = oi.order_item_order_id
    WHERE o.order_status IN ('COMPLETE', 'CLOSED')
    GROUP BY 1
) SELECT format_date('%Y%m', order_date) AS order_month,
    order_date,
    revenue,
    round(sum(revenue) OVER (
        PARTITION BY format_date('%Y%m', order_date)
        ORDER BY order_date
    ), 2) AS revenue_cum
FROM daily_revenue
ORDER BY 2;