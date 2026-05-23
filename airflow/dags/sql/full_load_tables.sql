-- stores full load
TRUNCATE TABLE staging.stg_stores;
INSERT INTO staging.stg_stores (
        store_id,
        store_name,
        city,
        country,
        address,
        phone,
        email,
        opened_date,
        is_active,
        etl_load_date,
        etl_batch_id
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
    NOW(),
    '{{ run_id }}' -- unikal batch id
FROM ext_source.stores;
-- employees full load
TRUNCATE TABLE staging.stg_employees;
INSERT INTO staging.stg_employees (
        employee_id,
        store_id,
        first_name,
        last_name,
        email,
        phone,
        hire_date,
        job_title,
        salary,
        is_active,
        etl_load_date,
        etl_batch_id
    )
SELECT employee_id,
    store_id,
    first_name,
    last_name,
    email,
    phone,
    hire_date,
    job_title,
    salary,
    is_active,
    NOW(),
    '{{ run_id }}'
FROM ext_source.employees;
-- CUSTOMERS full load
TRUNCATE TABLE staging.stg_customers;
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
SELECT customer_id,
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
    NOW(),
    '{{ run_id }}'
FROM ext_source.customers;
-- PRODUCTS full load
TRUNCATE TABLE staging.stg_products;
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
SELECT product_id,
    product_name,
    category,
    brand,
    price,
    cost,
    stock_quantity,
    is_active,
    created_at,
    updated_at,
    NOW(),
    '{{ run_id }}'
FROM ext_source.products;
-- ORDERS full load
TRUNCATE TABLE staging.stg_orders;
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
SELECT order_id,
    customer_id,
    store_id,
    employee_id,
    order_date,
    status,
    total_amount,
    created_at,
    NOW(),
    '{{ run_id }}'
FROM ext_source.orders;
-- ORDER_ITEMS full load
TRUNCATE TABLE staging.stg_order_items;
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
SELECT item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount,
    total_price,
    created_at,
    NOW(),
    '{{ run_id }}'
FROM ext_source.order_items;