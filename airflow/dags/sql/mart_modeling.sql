-- 1. 
TRUNCATE TABLE data_mart.mart_product_performance;
INSERT INTO data_mart.mart_product_performance (
        product_id,
        product_name,
        category,
        brand,
        current_price,
        total_quantity_sold,
        total_revenue,
        total_profit,
        profit_margin_pct,
        total_orders,
        avg_discount,
        dwh_updated_at
    )
SELECT p.product_id,
    p.product_name,
    p.category,
    p.brand,
    p.price,
    SUM(f.quantity),
    SUM(f.net_amount),
    SUM(f.profit_amount),
    ROUND(
        SUM(f.profit_amount) / NULLIF(SUM(f.net_amount), 0) * 100,
        2
    ),
    COUNT(DISTINCT f.order_id),
    ROUND(AVG(f.discount), 2),
    NOW()
FROM dwh.fact_sales f
    JOIN dwh.dim_product p ON p.product_key = f.product_key
WHERE f.order_status != 'cancelled'
GROUP BY p.product_id,
    p.product_name,
    p.category,
    p.brand,
    p.price;
-- 2. 
TRUNCATE TABLE data_mart.mart_daily_sales;
INSERT INTO data_mart.mart_daily_sales (
        report_date,
        store_id,
        store_name,
        city,
        total_orders,
        total_items,
        gross_revenue,
        net_revenue,
        total_discount,
        total_profit,
        avg_order_value,
        dwh_updated_at
    )
SELECT d.full_date,
    s.store_id,
    s.store_name,
    s.city,
    COUNT(DISTINCT f.order_id),
    SUM(f.quantity),
    SUM(f.gross_amount),
    SUM(f.net_amount),
    SUM(f.discount),
    SUM(f.profit_amount),
    ROUND(
        SUM(f.net_amount) / NULLIF(COUNT(DISTINCT f.order_id), 0),
        2
    ),
    NOW()
FROM dwh.fact_sales f
    JOIN dwh.dim_date d ON d.date_key = f.date_key
    JOIN dwh.dim_store s ON s.store_key = f.store_key
GROUP BY d.full_date,
    s.store_id,
    s.store_name,
    s.city;