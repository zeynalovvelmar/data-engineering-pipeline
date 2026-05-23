-- SCD1
-- customers
INSERT INTO staging.stg_customers (
        customer_id,
        first_name,
        last_name,
        email,
        phone,
        city,
        country,
        birth_date,
        gender,
        created_at,
        updated_at,
        etl_load_date,
        etl_batch_id
    )
SELECT s.customer_id,
    s.first_name,
    s.last_name,
    s.email,
    s.phone,
    s.city,
    s.country,
    s.birth_date,
    s.gender,
    s.created_at,
    s.updated_at,
    NOW(),
    '{{ run_id }}'
FROM ext_source.customers s ON CONFLICT (customer_id) DO
UPDATE
SET first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    email = EXCLUDED.email,
    phone = EXCLUDED.phone,
    city = EXCLUDED.city,
    country = EXCLUDED.country,
    birth_date = EXCLUDED.birth_date,
    gender = EXCLUDED.gender,
    updated_at = EXCLUDED.updated_at,
    etl_load_date = EXCLUDED.etl_load_date,
    etl_batch_id = EXCLUDED.etl_batch_id;
-- products
INSERT INTO staging.stg_products (
        product_id,
        product_name,
        category,
        brand,
        price,
        cost,
        stock_quantity,
        is_active,
        created_at,
        updated_at,
        etl_load_date,
        etl_batch_id
    )
SELECT s.product_id,
    s.product_name,
    s.category,
    s.brand,
    s.price,
    s.cost,
    s.stock_quantity,
    s.is_active,
    s.created_at,
    s.updated_at,
    NOW(),
    '{{ run_id }}'
FROM ext_source.products s ON CONFLICT (product_id) DO
UPDATE
SET product_name = EXCLUDED.product_name,
    category = EXCLUDED.category,
    brand = EXCLUDED.brand,
    price = EXCLUDED.price,
    cost = EXCLUDED.cost,
    stock_quantity = EXCLUDED.stock_quantity,
    is_active = EXCLUDED.is_active,
    updated_at = EXCLUDED.updated_at,
    etl_load_date = EXCLUDED.etl_load_date,
    etl_batch_id = EXCLUDED.etl_batch_id;
-- ORDERS
-- ORDERS Incremental Load (updated_at silinib)
INSERT INTO staging.stg_orders (
        order_id,
        customer_id,
        store_id,
        employee_id,
        order_date,
        status,
        total_amount,
        created_at,
        etl_load_date,
        etl_batch_id
    )
SELECT s.order_id,
    s.customer_id,
    s.store_id,
    s.employee_id,
    s.order_date,
    s.status,
    s.total_amount,
    s.created_at,
    NOW(),
    '{{ run_id }}'
FROM ext_source.orders s ON CONFLICT (order_id) DO
UPDATE
SET customer_id = EXCLUDED.customer_id,
    store_id = EXCLUDED.store_id,
    employee_id = EXCLUDED.employee_id,
    order_date = EXCLUDED.order_date,
    status = EXCLUDED.status,
    total_amount = EXCLUDED.total_amount,
    etl_load_date = EXCLUDED.etl_load_date,
    etl_batch_id = EXCLUDED.etl_batch_id;
-- ORDER_ITEMS
INSERT INTO staging.stg_order_items (
        item_id,
        order_id,
        product_id,
        quantity,
        unit_price,
        discount,
        total_price,
        created_at,
        etl_load_date,
        etl_batch_id
    )
SELECT s.item_id,
    s.order_id,
    s.product_id,
    s.quantity,
    s.unit_price,
    s.discount,
    s.total_price,
    s.created_at,
    NOW(),
    '{{ run_id }}'
FROM ext_source.order_items s ON CONFLICT (item_id) DO
UPDATE
SET order_id = EXCLUDED.order_id,
    product_id = EXCLUDED.product_id,
    quantity = EXCLUDED.quantity,
    unit_price = EXCLUDED.unit_price,
    discount = EXCLUDED.discount,
    total_price = EXCLUDED.total_price,
    etl_load_date = EXCLUDED.etl_load_date,
    etl_batch_id = EXCLUDED.etl_batch_id;