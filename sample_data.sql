PRAGMA foreign_keys = ON;

-- 200 clientes
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 200
)
INSERT INTO customers (customer_id, customer_name, state, segment, signup_date)
SELECT
    n,
    printf('Customer %03d', n),
    CASE n % 8
        WHEN 0 THEN 'TO' WHEN 1 THEN 'SP' WHEN 2 THEN 'GO' WHEN 3 THEN 'DF'
        WHEN 4 THEN 'MG' WHEN 5 THEN 'PA' WHEN 6 THEN 'MA' ELSE 'BA'
    END,
    CASE n % 10
        WHEN 0 THEN 'Corporate'
        WHEN 1 THEN 'Small Business'
        WHEN 2 THEN 'Small Business'
        ELSE 'Consumer'
    END,
    date('2025-01-01', printf('+%d days', (n * 7) % 590))
FROM seq;

-- 40 produtos
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 40
)
INSERT INTO products (product_id, product_name, category, unit_price, unit_cost, stock_qty)
SELECT
    n,
    printf('Product %02d', n),
    CASE
        WHEN n <= 10 THEN 'Electronics'
        WHEN n <= 20 THEN 'Home'
        WHEN n <= 30 THEN 'Office'
        ELSE 'Fitness'
    END,
    ROUND(25 + ((n * 73) % 900) + (n % 5) * 0.90, 2),
    ROUND((25 + ((n * 73) % 900) + (n % 5) * 0.90) * (0.52 + (n % 4) * 0.05), 2),
    5 + ((n * 19) % 150)
FROM seq;

-- 1.200 pedidos entre janeiro e agosto de 2026
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 1200
)
INSERT INTO orders (order_id, customer_id, order_date, status, sales_channel)
SELECT
    n,
    1 + ((n * 17) % 200),
    date('2026-01-01', printf('+%d days', (n * 11) % 243)),
    CASE WHEN n % 13 = 0 THEN 'cancelled' ELSE 'completed' END,
    CASE n % 4
        WHEN 0 THEN 'Website'
        WHEN 1 THEN 'App'
        WHEN 2 THEN 'Marketplace'
        ELSE 'WhatsApp'
    END
FROM seq;

-- 1 a 3 itens por pedido, de forma determinística
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 1200
), item_no(i) AS (
    SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct)
SELECT
    s.n,
    1 + ((s.n * 7 + i * 11) % 40) AS product_id,
    1 + ((s.n + i) % 3) AS quantity,
    p.unit_price,
    CASE (s.n + i) % 10
        WHEN 0 THEN 0.20
        WHEN 1 THEN 0.15
        WHEN 2 THEN 0.10
        WHEN 3 THEN 0.05
        ELSE 0.00
    END
FROM seq s
JOIN item_no ON i <= 1 + (s.n % 3)
JOIN products p ON p.product_id = 1 + ((s.n * 7 + i * 11) % 40);

-- Pagamentos apenas para pedidos concluídos
INSERT INTO payments (order_id, payment_method, amount)
SELECT
    o.order_id,
    CASE o.order_id % 4
        WHEN 0 THEN 'PIX'
        WHEN 1 THEN 'Credit Card'
        WHEN 2 THEN 'Debit Card'
        ELSE 'Boleto'
    END,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)), 2)
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY o.order_id;
