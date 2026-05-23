-- 1. DIM_STORE
INSERT INTO dwh.dim_store (
        store_id,
        store_name,
        city,
        country,
        address,
        phone,
        email,
        opened_date,
        is_active,
        is_current,
        dwh_created_at,
        dwh_updated_at
    )
SELECT store_id,
    store_name,
    city,
    country,
    address,
    phone,
    email,
    opened_date,
    is_active,
    TRUE,
    NOW(),
    NOW()
FROM staging.stg_stores ON CONFLICT (store_id) DO
UPDATE
SET store_name = EXCLUDED.store_name,
    city = EXCLUDED.city,
    is_active = EXCLUDED.is_active,
    dwh_updated_at = NOW();
-- 2. DIM_PRODUCT 
INSERT INTO dwh.dim_product (
        product_id,
        product_name,
        category,
        brand,
        price,
        cost,
        stock_quantity,
        is_active,
        is_current,
        effective_from,
        effective_to,
        dwh_created_at
    )
SELECT product_id,
    product_name,
    category,
    brand,
    price,
    cost,
    stock_quantity,
    is_active,
    TRUE,
    CURRENT_DATE,
    '9999-12-31',
    NOW()
FROM staging.stg_products ON CONFLICT (product_id) DO
UPDATE
SET price = EXCLUDED.price,
    cost = EXCLUDED.cost,
    is_active = EXCLUDED.is_active;
-- 3. DIM_CUSTOMER
INSERT INTO dwh.dim_customer (
        customer_id,
        first_name,
        last_name,
        email,
        phone,
        city,
        country,
        birth_date,
        age_group,
        gender,
        is_current,
        effective_from,
        effective_to,
        dwh_created_at
    )
SELECT customer_id,
    first_name,
    last_name,
    email,
    phone,
    city,
    country,
    birth_date,
    CASE
        WHEN birth_date > CURRENT_DATE - INTERVAL '25 years' THEN '18-25'
        WHEN birth_date > CURRENT_DATE - INTERVAL '35 years' THEN '26-35'
        ELSE '36+'
    END,
    gender,
    TRUE,
    CURRENT_DATE,
    '9999-12-31',
    NOW()
FROM staging.stg_customers ON CONFLICT (customer_id) DO
UPDATE
SET email = EXCLUDED.email,
    age_group = EXCLUDED.age_group;
-- 4. DIM_EMPLOYEE
INSERT INTO dwh.dim_employee (
        employee_id,
        first_name,
        last_name,
        email,
        phone,
        job_title,
        salary,
        is_active,
        is_current,
        dwh_created_at,
        dwh_updated_at
    )
SELECT employee_id,
    first_name,
    last_name,
    email,
    phone,
    job_title,
    salary,
    is_active,
    TRUE,
    NOW(),
    NOW()
FROM staging.stg_employees ON CONFLICT (employee_id) DO
UPDATE
SET salary = EXCLUDED.salary,
    job_title = EXCLUDED.job_title,
    dwh_updated_at = NOW();
-- 5. FACT_SALES
INSERT INTO dwh.fact_sales (
        date_key,
        customer_key,
        product_key,
        store_key,
        employee_key,
        order_id,
        item_id,
        quantity,
        unit_price,
        discount,
        gross_amount,
        net_amount,
        profit_amount,
        order_status,
        dwh_created_at
    )
SELECT TO_CHAR(o.order_date, 'YYYYMMDD')::INT,
    dc.customer_key,
    dp.product_key,
    ds.store_key,
    de.employee_key,
    o.order_id,
    oi.item_id,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    (oi.quantity * oi.unit_price),
    (oi.quantity * oi.unit_price) - oi.discount,
    ((oi.quantity * oi.unit_price) - oi.discount) - (oi.quantity * dp.cost),
    o.status,
    NOW()
FROM staging.stg_orders o
    JOIN staging.stg_order_items oi ON o.order_id = oi.order_id
    JOIN dwh.dim_customer dc ON o.customer_id = dc.customer_id
    JOIN dwh.dim_product dp ON oi.product_id = dp.product_id
    JOIN dwh.dim_store ds ON o.store_id = ds.store_id
    JOIN dwh.dim_employee de ON o.employee_id = de.employee_id
WHERE NOT EXISTS (
        SELECT 1
        FROM dwh.fact_sales fs
        WHERE fs.item_id = oi.item_id
    );