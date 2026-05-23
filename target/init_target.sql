CREATE SCHEMA IF NOT EXISTS staging;
--
CREATE SCHEMA IF NOT EXISTS dwh;
--
CREATE SCHEMA IF NOT EXISTS data_mart;
-----

select * from staging.stg_stores
select * from staging.stg_employees

CREATE TABLE IF NOT EXISTS staging.stg_stores (
    store_id     INT           NOT NULL,
    store_name   VARCHAR(100),
    city         VARCHAR(50),
    country      VARCHAR(50),
    address      VARCHAR(200),
    phone        VARCHAR(20),
    email        VARCHAR(100),
    opened_date  DATE,
    is_active    BOOLEAN,
    etl_load_date   TIMESTAMP  NOT NULL DEFAULT NOW(),
    etl_batch_id    VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS staging.stg_employees (
    employee_id  INT           NOT NULL,
    store_id     INT,
    first_name   VARCHAR(50),
    last_name    VARCHAR(50),
    email        VARCHAR(100),
    phone        VARCHAR(20),
    hire_date    DATE,
    job_title    VARCHAR(50),
    salary       NUMERIC(10,2),
    is_active    BOOLEAN,
    etl_load_date   TIMESTAMP  NOT NULL DEFAULT NOW(),
    etl_batch_id    VARCHAR(50)
);


--select * from staging.stg_customers
CREATE TABLE IF NOT EXISTS staging.stg_customers (
    customer_id  INT           NOT NULL,
    first_name   VARCHAR(50),
    last_name    VARCHAR(50),
    email        VARCHAR(100),
    phone        VARCHAR(20),
    city         VARCHAR(50),
    country      VARCHAR(50),
    birth_date   DATE,
    gender       CHAR(1),
    created_at   TIMESTAMP,
    updated_at   TIMESTAMP,
    etl_load_date   TIMESTAMP  NOT NULL DEFAULT NOW(),
    etl_batch_id    VARCHAR(50)
);



CREATE TABLE IF NOT EXISTS staging.stg_products (
    product_id      INT           NOT NULL,
    product_name    VARCHAR(150),
    category        VARCHAR(50),
    brand           VARCHAR(50),
    price           NUMERIC(10,2),
    cost            NUMERIC(10,2),
    stock_quantity  INT,
    is_active       BOOLEAN,
    created_at      TIMESTAMP,
    updated_at      TIMESTAMP,
    etl_load_date   TIMESTAMP  NOT NULL DEFAULT NOW(),
    etl_batch_id    VARCHAR(50)
);



CREATE TABLE IF NOT EXISTS staging.stg_orders (
    order_id      INT           NOT NULL,
    customer_id   INT,
    store_id      INT,
    employee_id   INT,
    order_date    DATE,
    status        VARCHAR(20),
    total_amount  NUMERIC(12,2),
    created_at    TIMESTAMP,
    etl_load_date   TIMESTAMP  NOT NULL DEFAULT NOW(),
    etl_batch_id    VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS staging.stg_order_items (
    item_id      INT           NOT NULL,
    order_id     INT,
    product_id   INT,
    quantity     INT,
    unit_price   NUMERIC(10,2),
    discount     NUMERIC(5,2),
    total_price  NUMERIC(12,2),
    created_at   TIMESTAMP,
    etl_load_date   TIMESTAMP  NOT NULL DEFAULT NOW(),
    etl_batch_id    VARCHAR(50)
);

--select * from staging.stg_payments

CREATE TABLE IF NOT EXISTS staging.stg_payments (
    payment_id      INT           NOT NULL,
    order_id        INT,
    payment_method  VARCHAR(20),
    amount          NUMERIC(12,2),
    payment_date    TIMESTAMP,
    status          VARCHAR(20),
    transaction_ref VARCHAR(50),
    etl_load_date   TIMESTAMP  NOT NULL DEFAULT NOW(),
    etl_batch_id    VARCHAR(50)
);



---------------------dwh---------------

CREATE TABLE IF NOT EXISTS dwh.dim_date (
    date_key        INT           PRIMARY KEY,   
    full_date       DATE          NOT NULL UNIQUE,
    day_of_week     SMALLINT      NOT NULL,       
    day_name        VARCHAR(10)   NOT NULL,      
    day_of_month    SMALLINT      NOT NULL,
    day_of_year     SMALLINT      NOT NULL,
    week_of_year    SMALLINT      NOT NULL,
    month_num       SMALLINT      NOT NULL,
    month_name      VARCHAR(10)   NOT NULL,
    quarter         SMALLINT      NOT NULL,       
    year            SMALLINT      NOT NULL,
    is_weekend      BOOLEAN       NOT NULL,
    is_holiday      BOOLEAN       NOT NULL DEFAULT FALSE
);
 

CREATE TABLE IF NOT EXISTS dwh.dim_store (
    store_key    SERIAL        PRIMARY KEY,       
    store_id     INT           NOT NULL UNIQUE,   
    store_name   VARCHAR(100),
    city         VARCHAR(50),
    country      VARCHAR(50),
    address      VARCHAR(200),
    phone        VARCHAR(20),
    email        VARCHAR(100),
    opened_date  DATE,
    is_active    BOOLEAN,
    dwh_created_at  TIMESTAMP  NOT NULL DEFAULT NOW(),
    dwh_updated_at  TIMESTAMP  NOT NULL DEFAULT NOW()
);
 --select * from dwh.dim_store

CREATE TABLE IF NOT EXISTS dwh.dim_employee (
    employee_key  SERIAL        PRIMARY KEY,      
    employee_id   INT           NOT NULL UNIQUE,  
    store_id      INT,                            
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    full_name     VARCHAR(101),                  
    email         VARCHAR(100),
    phone         VARCHAR(20),
    hire_date     DATE,
    job_title     VARCHAR(50),
    salary        NUMERIC(10,2),
    is_active     BOOLEAN,
    dwh_created_at  TIMESTAMP  NOT NULL DEFAULT NOW(),
    dwh_updated_at  TIMESTAMP  NOT NULL DEFAULT NOW()
);
 

--select * from dwh.dim_customer
CREATE TABLE IF NOT EXISTS dwh.dim_customer (
    customer_key    SERIAL        PRIMARY KEY,    
    customer_id     INT           NOT NULL,      
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    full_name       VARCHAR(101),                
    email           VARCHAR(100),
    phone           VARCHAR(20),
    city            VARCHAR(50),
    country         VARCHAR(50),
    birth_date      DATE,
    gender          CHAR(1),
    age_group       VARCHAR(20),                 
    effective_from  DATE          NOT NULL,
    effective_to    DATE          NOT NULL DEFAULT '9999-12-31',
    is_current      BOOLEAN       NOT NULL DEFAULT TRUE,
    dwh_created_at  TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dwh.dim_product (
    product_key     SERIAL        PRIMARY KEY,    
    product_id      INT           NOT NULL,       
    product_name    VARCHAR(150),
    category        VARCHAR(50),
    brand           VARCHAR(50),
    price           NUMERIC(10,2),
    cost            NUMERIC(10,2),
    margin          NUMERIC(10,2),               
    margin_pct      NUMERIC(5,2),                 
    stock_quantity  INT,
    is_active       BOOLEAN,
    effective_from  DATE          NOT NULL,
    effective_to    DATE          NOT NULL DEFAULT '9999-12-31',
    is_current      BOOLEAN       NOT NULL DEFAULT TRUE,
    dwh_created_at  TIMESTAMP     NOT NULL DEFAULT NOW()
);
 

CREATE TABLE IF NOT EXISTS dwh.fact_sales (
    sales_key       BIGSERIAL     PRIMARY KEY,
    date_key        INT           NOT NULL REFERENCES dwh.dim_date(date_key),
    customer_key    INT           NOT NULL REFERENCES dwh.dim_customer(customer_key),
    product_key     INT           NOT NULL REFERENCES dwh.dim_product(product_key),
    store_key       INT           NOT NULL REFERENCES dwh.dim_store(store_key),
    employee_key    INT           NOT NULL REFERENCES dwh.dim_employee(employee_key),
    order_id        INT           NOT NULL,
    item_id         INT           NOT NULL,
    payment_id      INT,
    quantity        INT           NOT NULL,
    unit_price      NUMERIC(10,2) NOT NULL,
    discount        NUMERIC(5,2)  NOT NULL DEFAULT 0,
    gross_amount    NUMERIC(12,2) NOT NULL,       
    net_amount      NUMERIC(12,2) NOT NULL,      
    cost_amount     NUMERIC(12,2),                
    profit_amount   NUMERIC(12,2),                
    payment_method  VARCHAR(20),
    order_status    VARCHAR(20),
    dwh_created_at  TIMESTAMP     NOT NULL DEFAULT NOW()
);
 
---datamart
CREATE TABLE IF NOT EXISTS data_mart.mart_daily_sales (
    report_date       DATE          NOT NULL,
    store_id          INT           NOT NULL,
    store_name        VARCHAR(100),
    city              VARCHAR(50),
    total_orders      INT           NOT NULL DEFAULT 0,
    total_items       INT           NOT NULL DEFAULT 0,
    gross_revenue     NUMERIC(14,2) NOT NULL DEFAULT 0,
    net_revenue       NUMERIC(14,2) NOT NULL DEFAULT 0,
    total_discount    NUMERIC(14,2) NOT NULL DEFAULT 0,
    total_profit      NUMERIC(14,2) NOT NULL DEFAULT 0,
    avg_order_value   NUMERIC(10,2),
    dwh_updated_at    TIMESTAMP     NOT NULL DEFAULT NOW(),
    PRIMARY KEY (report_date, store_id)
);


CREATE TABLE IF NOT EXISTS data_mart.mart_customer_summary (
    customer_id         INT           NOT NULL PRIMARY KEY,
    full_name           VARCHAR(101),
    city                VARCHAR(50),
    gender              CHAR(1),
    age_group           VARCHAR(20),
    first_order_date    DATE,
    last_order_date     DATE,
    total_orders        INT           NOT NULL DEFAULT 0,
    total_items         INT           NOT NULL DEFAULT 0,
    total_spent         NUMERIC(14,2) NOT NULL DEFAULT 0,
    avg_order_value     NUMERIC(10,2),
    favorite_category   VARCHAR(50),              
    dwh_updated_at      TIMESTAMP     NOT NULL DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS data_mart.mart_product_performance (
    product_id          INT           NOT NULL PRIMARY KEY,
    product_name        VARCHAR(150),
    category            VARCHAR(50),
    brand               VARCHAR(50),
    current_price       NUMERIC(10,2),
    total_quantity_sold INT           NOT NULL DEFAULT 0,
    total_revenue       NUMERIC(14,2) NOT NULL DEFAULT 0,
    total_profit        NUMERIC(14,2) NOT NULL DEFAULT 0,
    profit_margin_pct   NUMERIC(5,2),
    total_orders        INT           NOT NULL DEFAULT 0,
    avg_discount        NUMERIC(5,2),
    dwh_updated_at      TIMESTAMP     NOT NULL DEFAULT NOW()
);

INSERT INTO dwh.dim_date (date_key, full_date, day_of_week, day_name,
    day_of_month, day_of_year, week_of_year, month_num, month_name,
    quarter, year, is_weekend)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT,
    d,
    EXTRACT(ISODOW FROM d)::SMALLINT,
    TO_CHAR(d, 'Day'),
    EXTRACT(DAY FROM d)::SMALLINT,
    EXTRACT(DOY FROM d)::SMALLINT,
    EXTRACT(WEEK FROM d)::SMALLINT,
    EXTRACT(MONTH FROM d)::SMALLINT,
    TO_CHAR(d, 'Month'),
    EXTRACT(QUARTER FROM d)::SMALLINT,
    EXTRACT(YEAR FROM d)::SMALLINT,
    EXTRACT(ISODOW FROM d) IN (6,7)
FROM generate_series('2022-01-01'::DATE, '2026-12-31'::DATE, '1 day') d;
