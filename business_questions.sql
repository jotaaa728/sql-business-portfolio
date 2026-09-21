-- 10 perguntas de negócio respondidas em SQL
-- Dialeto: SQLite

-- 01. Qual foi o faturamento mensal e quantos pedidos foram concluídos em cada mês?
SELECT
    strftime('%Y-%m', o.order_date) AS month,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)), 2) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY month;

-- 02. Quais são os 5 produtos com maior faturamento?
SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)), 2) AS revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC
LIMIT 5;

-- 03. Qual é o ticket médio por segmento de cliente?
WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)) AS order_total
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_id, o.customer_id
)
SELECT
    c.segment,
    COUNT(*) AS orders,
    ROUND(AVG(ot.order_total), 2) AS avg_ticket
FROM order_totals ot
JOIN customers c ON c.customer_id = ot.customer_id
GROUP BY c.segment
ORDER BY avg_ticket DESC;

-- 04. Qual é a taxa de clientes recorrentes entre os clientes que compraram?
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS completed_orders
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS customers_who_bought,
    SUM(CASE WHEN completed_orders >= 2 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        100.0 * SUM(CASE WHEN completed_orders >= 2 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS repeat_customer_rate_pct
FROM customer_orders;

-- 05. Quais estados geram mais faturamento?
SELECT
    c.state,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)), 2) AS revenue
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY c.state
ORDER BY revenue DESC;

-- 06. Qual categoria tem maior margem bruta em valor e percentual?
SELECT
    p.category,
    ROUND(SUM(
        oi.quantity * (
            oi.unit_price * (1 - oi.discount_pct) - p.unit_cost
        )
    ), 2) AS gross_margin_value,
    ROUND(
        100.0 * SUM(
            oi.quantity * (oi.unit_price * (1 - oi.discount_pct) - p.unit_cost)
        ) /
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),
        2
    ) AS gross_margin_pct
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.status = 'completed'
GROUP BY p.category
ORDER BY gross_margin_value DESC;

-- 07. Quais clientes estão inativos há mais de 90 dias considerando 01/09/2026?
WITH last_purchase AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    c.state,
    lp.last_order_date,
    CAST(julianday('2026-09-01') - julianday(lp.last_order_date) AS INTEGER) AS days_inactive
FROM last_purchase lp
JOIN customers c ON c.customer_id = lp.customer_id
WHERE julianday('2026-09-01') - julianday(lp.last_order_date) > 90
ORDER BY days_inactive DESC, c.customer_id;

-- 08. Qual a participação de cada método de pagamento no faturamento?
SELECT
    payment_method,
    COUNT(*) AS transactions,
    ROUND(SUM(amount), 2) AS revenue,
    ROUND(100.0 * SUM(amount) / SUM(SUM(amount)) OVER (), 2) AS revenue_share_pct
FROM payments
GROUP BY payment_method
ORDER BY revenue DESC;

-- 09. Qual canal de venda apresenta a maior taxa de cancelamento?
SELECT
    sales_channel,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(
        100.0 * SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS cancellation_rate_pct
FROM orders
GROUP BY sales_channel
ORDER BY cancellation_rate_pct DESC;

-- 10. Quais produtos têm risco de estoque com base no ritmo recente de vendas?
WITH sales_30d AS (
    SELECT
        oi.product_id,
        SUM(oi.quantity) AS units_sold_30d
    FROM order_items oi
    JOIN orders o ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
      AND o.order_date >= '2026-08-02'
      AND o.order_date <= '2026-08-31'
    GROUP BY oi.product_id
)
SELECT
    p.product_name,
    p.category,
    p.stock_qty,
    COALESCE(s.units_sold_30d, 0) AS units_sold_30d,
    ROUND(
        CASE
            WHEN COALESCE(s.units_sold_30d, 0) = 0 THEN NULL
            ELSE 30.0 * p.stock_qty / s.units_sold_30d
        END,
        1
    ) AS estimated_days_of_stock
FROM products p
LEFT JOIN sales_30d s ON s.product_id = p.product_id
WHERE COALESCE(s.units_sold_30d, 0) > 0
ORDER BY estimated_days_of_stock ASC
LIMIT 10;
