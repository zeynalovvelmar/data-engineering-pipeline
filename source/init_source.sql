
CREATE TABLE IF NOT EXISTS stores (
    store_id     SERIAL        PRIMARY KEY,
    store_name   VARCHAR(100)  NOT NULL,
    city         VARCHAR(50)   NOT NULL,
    country      VARCHAR(50)   NOT NULL DEFAULT 'Azerbaijan',
    address      VARCHAR(200),
    phone        VARCHAR(20),
    email        VARCHAR(100),
    opened_date  DATE          NOT NULL,
    is_active    BOOLEAN       NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id  SERIAL        PRIMARY KEY,
    store_id     INT           NOT NULL REFERENCES stores(store_id),
    first_name   VARCHAR(50)   NOT NULL,
    last_name    VARCHAR(50)   NOT NULL,
    email        VARCHAR(100)  NOT NULL UNIQUE,
    phone        VARCHAR(20),
    hire_date    DATE          NOT NULL,
    job_title    VARCHAR(50)   NOT NULL,
    salary       NUMERIC(10,2) NOT NULL,
    is_active    BOOLEAN       NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id  SERIAL        PRIMARY KEY,
    first_name   VARCHAR(50)   NOT NULL,
    last_name    VARCHAR(50)   NOT NULL,
    email        VARCHAR(100)  NOT NULL UNIQUE,
    phone        VARCHAR(20),
    city         VARCHAR(50),
    country      VARCHAR(50)   NOT NULL DEFAULT 'Azerbaijan',
    birth_date   DATE,
    gender       CHAR(1)       CHECK (gender IN ('M','F')),
    created_at   TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
    product_id      SERIAL        PRIMARY KEY,
    product_name    VARCHAR(150)  NOT NULL,
    category        VARCHAR(50)   NOT NULL,
    brand           VARCHAR(50),
    price           NUMERIC(10,2) NOT NULL,
    cost            NUMERIC(10,2) NOT NULL,
    stock_quantity  INT           NOT NULL DEFAULT 0,
    is_active       BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
    order_id      SERIAL        PRIMARY KEY,
    customer_id   INT           NOT NULL REFERENCES customers(customer_id),
    store_id      INT           NOT NULL REFERENCES stores(store_id),
    employee_id   INT           NOT NULL REFERENCES employees(employee_id),
    order_date    DATE          NOT NULL,
    status        VARCHAR(20)   NOT NULL DEFAULT 'completed'
                                CHECK (status IN ('pending','completed','cancelled','refunded')),
    total_amount  NUMERIC(12,2) NOT NULL,
    created_at    TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS order_items (
    item_id      SERIAL        PRIMARY KEY,
    order_id     INT           NOT NULL REFERENCES orders(order_id),
    product_id   INT           NOT NULL REFERENCES products(product_id),
    quantity     INT           NOT NULL CHECK (quantity > 0),
    unit_price   NUMERIC(10,2) NOT NULL,
    discount     NUMERIC(5,2)  NOT NULL DEFAULT 0.00,
    total_price  NUMERIC(12,2) NOT NULL,
    created_at   TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id      SERIAL        PRIMARY KEY,
    order_id        INT           NOT NULL REFERENCES orders(order_id),
    payment_method  VARCHAR(20)   NOT NULL
                                  CHECK (payment_method IN ('cash','card','online','transfer')),
    amount          NUMERIC(12,2) NOT NULL,
    payment_date    TIMESTAMP     NOT NULL DEFAULT NOW(),
    status          VARCHAR(20)   NOT NULL DEFAULT 'success'
                                  CHECK (status IN ('success','failed','pending','refunded')),
    transaction_ref VARCHAR(50)
);



--TRUNCATE payments, order_items, orders, customers, products, employees, stores RESTART IDENTITY CASCADE;

--SELECT pid, age(clock_timestamp(), query_start), usename, query, state
--FROM pg_stat_activity
--WHERE state != 'idle' AND query NOT ILIKE '%pg_stat_activity%'
--ORDER BY query_start DESC;
--select * from payments

INSERT INTO stores (store_name, city, country, address, phone, email, opened_date, is_active) VALUES
    ('TechMart Baki Merkez',  'Baki',     'Azerbaijan', 'Nizami kuc. 12',        '+994121001001', 'baki.merkez@techmart.az', '2018-03-15', TRUE),
    ('TechMart Gence',        'Gence',    'Azerbaijan', 'Huseyin Cavid pr. 5',   '+994222001002', 'gence@techmart.az',       '2019-06-01', TRUE),
    ('TechMart Sumqayit',     'Sumqayit', 'Azerbaijan', 'Aliaga Vahid kuc. 88',  '+994183001003', 'sumqayit@techmart.az',    '2020-01-10', TRUE),
    ('TechMart Lankaran',     'Lankaran', 'Azerbaijan', 'Xan Bagi kuc. 3',       '+994251001004', 'lankaran@techmart.az',    '2021-09-20', TRUE),
    ('TechMart Baki Xetai',   'Baki',     'Azerbaijan', 'Xetai pr. 100',         '+994121001005', 'baki.xetai@techmart.az',  '2022-04-05', TRUE);


INSERT INTO employees (store_id, first_name, last_name, email, phone, hire_date, job_title, salary, is_active) VALUES
    (1, 'Ayten',  'Quliyeva',    'ayten.quliyeva@techmart.az',   '+994501110001', '2018-03-15', 'Store Manager',   2800.00, TRUE),
    (1, 'Rauf',   'Aliyev',      'rauf.aliyev@techmart.az',      '+994501110002', '2019-01-10', 'Sales Associate', 1400.00, TRUE),
    (1, 'Gunel',  'Huseynova',   'gunel.huseynova@techmart.az',  '+994501110003', '2020-05-20', 'Sales Associate', 1350.00, TRUE),
    (2, 'Tural',  'Mammadov',    'tural.mammadov@techmart.az',   '+994502220001', '2019-06-01', 'Store Manager',   2600.00, TRUE),
    (2, 'Sevinc', 'Nacafova',    'sevinc.nacafova@techmart.az',  '+994502220002', '2020-03-15', 'Sales Associate', 1350.00, TRUE),
    (3, 'Elnur',  'Babayev',     'elnur.babayev@techmart.az',    '+994503330001', '2020-01-10', 'Store Manager',   2500.00, TRUE),
    (3, 'Nermin', 'Resulova',    'nermin.resulova@techmart.az',  '+994503330002', '2020-08-01', 'Sales Associate', 1300.00, TRUE),
    (3, 'Kamran', 'Isayev',      'kamran.isayev@techmart.az',    '+994503330003', '2021-02-14', 'Sales Associate', 1300.00, TRUE),
    (4, 'Nigar',  'Ahmadova',    'nigar.ahmadova@techmart.az',   '+994504440001', '2021-09-20', 'Store Manager',   2400.00, TRUE),
    (4, 'Vusal',  'Karimov',     'vusal.karimov@techmart.az',    '+994504440002', '2022-01-03', 'Sales Associate', 1250.00, TRUE),
    (5, 'Lala',   'Mustafayeva', 'lale.mustafayeva@techmart.az', '+994505550001', '2022-04-05', 'Store Manager',   2700.00, TRUE),
    (5, 'Orxan',  'Hasanov',     'orxan.hasanov@techmart.az',    '+994505550002', '2022-06-15', 'Sales Associate', 1400.00, TRUE);

select * from customers
INSERT INTO customers (first_name, last_name, email, phone, city, country, birth_date, gender, created_at, updated_at) VALUES
    ('Ali',     'Huseynov',      'ali.huseynov@gmail.com',       '+994501234501', 'Baki',     'Azerbaijan', '1990-04-12', 'M', '2023-01-05 09:10:00', '2023-01-05 09:10:00'),
    ('Gunel',   'Aliyeva',       'gunel.aliyeva@gmail.com',      '+994501234502', 'Baki',     'Azerbaijan', '1995-07-23', 'F', '2023-01-18 11:22:00', '2024-03-10 14:00:00'),
    ('Murad',   'Qasimov',       'murad.qasimov@mail.ru',        '+994501234503', 'Gence',    'Azerbaijan', '1988-11-30', 'M', '2023-02-03 08:45:00', '2023-02-03 08:45:00'),
    ('Aynur',   'Nasirov',       'aynur.nasirov@gmail.com',      '+994501234504', 'Sumqayit', 'Azerbaijan', '1992-02-14', 'F', '2023-02-20 13:30:00', '2024-01-15 10:20:00'),
    ('Samir',   'Rahimov',       'samir.rahimov@mail.ru',        '+994501234505', 'Baki',     'Azerbaijan', '1985-09-08', 'M', '2023-03-07 16:00:00', '2023-03-07 16:00:00'),
    ('Leyla',   'Mammadova',     'leyla.mammadova@gmail.com',    '+994501234506', 'Baki',     'Azerbaijan', '1998-12-25', 'F', '2023-03-22 10:15:00', '2023-03-22 10:15:00'),
    ('Rasad',   'Abbasov',       'rasad.abbasov@gmail.com',      '+994501234507', 'Lankaran', 'Azerbaijan', '1991-06-17', 'M', '2023-04-10 09:00:00', '2024-02-20 11:30:00'),
    ('Konul',   'Hasanova',      'konul.hasanova@mail.ru',       '+994501234508', 'Gence',    'Azerbaijan', '1994-03-05', 'F', '2023-04-28 14:45:00', '2023-04-28 14:45:00'),
    ('Cavid',   'Ismayilov',     'cavid.ismayilov@gmail.com',    '+994501234509', 'Baki',     'Azerbaijan', '1987-08-20', 'M', '2023-05-15 11:00:00', '2023-05-15 11:00:00'),
    ('Sabnam',  'Yusifova',      'sabnam.yusifova@gmail.com',    '+994501234510', 'Sumqayit', 'Azerbaijan', '1996-01-09', 'F', '2023-05-30 15:20:00', '2024-04-05 09:00:00'),
    ('Farid',   'Quliyev',       'farid.quliyev@mail.ru',        '+994501234511', 'Baki',     'Azerbaijan', '1989-10-14', 'M', '2023-06-12 10:30:00', '2023-06-12 10:30:00'),
    ('Nermin',  'Ahmadova',      'nermin.ahmadova@gmail.com',    '+994501234512', 'Baki',     'Azerbaijan', '1993-05-28', 'F', '2023-06-25 13:00:00', '2023-06-25 13:00:00'),
    ('Bahruz',  'Karimli',       'bahruz.karimli@gmail.com',     '+994501234513', 'Gence',    'Azerbaijan', '1986-07-04', 'M', '2023-07-08 09:45:00', '2024-05-01 16:00:00'),
    ('Xadica',  'Rasulova',      'xadica.rasulova@mail.ru',      '+994501234514', 'Lankaran', 'Azerbaijan', '1997-02-19', 'F', '2023-07-20 11:15:00', '2023-07-20 11:15:00'),
    ('Elnur',   'Babazada',      'elnur.babazada@gmail.com',     '+994501234515', 'Baki',     'Azerbaijan', '1990-11-03', 'M', '2023-08-05 14:00:00', '2023-08-05 14:00:00'),
    ('Turkan',  'Humbatova',     'turkan.humbatova@gmail.com',   '+994501234516', 'Sumqayit', 'Azerbaijan', '1995-04-22', 'F', '2023-08-18 10:00:00', '2024-06-10 08:30:00'),
    ('Zaur',    'Allahverdiyev', 'zaur.allahverdiyev@mail.ru',   '+994501234517', 'Baki',     'Azerbaijan', '1983-09-11', 'M', '2023-09-01 09:20:00', '2023-09-01 09:20:00'),
    ('Aysel',   'Mehdiyeva',     'aysel.mehdiyeva@gmail.com',    '+994501234518', 'Gence',    'Azerbaijan', '1999-06-30', 'F', '2023-09-15 15:40:00', '2023-09-15 15:40:00'),
    ('Nicat',   'Alizade',       'nicat.alizade@gmail.com',      '+994501234519', 'Baki',     'Azerbaijan', '1992-12-07', 'M', '2023-10-02 11:50:00', '2024-07-15 12:00:00'),
    ('Zahra',   'Qambarova',     'zahra.qambarova@mail.ru',      '+994501234520', 'Lankaran', 'Azerbaijan', '1988-03-15', 'F', '2023-10-20 13:10:00', '2023-10-20 13:10:00'),
    ('Parviz',  'Suleymanov',    'parviz.suleymanov@gmail.com',  '+994501234521', 'Baki',     'Azerbaijan', '1991-08-25', 'M', '2023-11-03 09:30:00', '2023-11-03 09:30:00'),
    ('Sevinc',  'Valiyeva',      'sevinc.valiyeva@gmail.com',    '+994501234522', 'Sumqayit', 'Azerbaijan', '1994-01-18', 'F', '2023-11-18 14:20:00', '2024-08-01 10:00:00'),
    ('Tural',   'Nacafov',       'tural.nacafov@mail.ru',        '+994501234523', 'Baki',     'Azerbaijan', '1987-05-09', 'M', '2023-12-01 10:45:00', '2023-12-01 10:45:00'),
    ('Lala',    'Ibrahimova',    'lala.ibrahimova@gmail.com',    '+994501234524', 'Gence',    'Azerbaijan', '1996-10-12', 'F', '2023-12-15 12:00:00', '2023-12-15 12:00:00'),
    ('Kamran',  'Musayev',       'kamran.musayev@gmail.com',     '+994501234525', 'Baki',     'Azerbaijan', '1984-07-21', 'M', '2024-01-08 09:00:00', '2024-09-01 11:00:00');


INSERT INTO products (product_name, category, brand, price, cost, stock_quantity, is_active, created_at, updated_at) VALUES
    ('iPhone 15 Pro 256GB',       'Telefon',  'Apple',    2499.00, 1900.00,  45, TRUE,  '2023-01-01 08:00:00', '2024-06-01 10:00:00'),
    ('Samsung Galaxy S24 Ultra',  'Telefon',  'Samsung',  2199.00, 1650.00,  38, TRUE,  '2023-01-01 08:00:00', '2024-05-15 09:00:00'),
    ('Xiaomi 14 Pro',             'Telefon',  'Xiaomi',    999.00,  720.00,  60, TRUE,  '2023-03-10 08:00:00', '2024-04-10 08:00:00'),
    ('iPhone 14 128GB',           'Telefon',  'Apple',    1599.00, 1200.00,  25, TRUE,  '2023-01-01 08:00:00', '2023-01-01 08:00:00'),
    ('Samsung Galaxy A55',        'Telefon',  'Samsung',   699.00,  500.00,  80, TRUE,  '2023-06-01 08:00:00', '2024-03-20 08:00:00'),
    ('MacBook Pro 14 M3',         'Noutbuk',  'Apple',    3999.00, 3100.00,  20, TRUE,  '2023-02-01 08:00:00', '2024-07-01 08:00:00'),
    ('Dell XPS 15 i7',            'Noutbuk',  'Dell',     2299.00, 1750.00,  15, TRUE,  '2023-02-01 08:00:00', '2023-02-01 08:00:00'),
    ('Lenovo ThinkPad X1 Carbon', 'Noutbuk',  'Lenovo',   2099.00, 1600.00,  18, TRUE,  '2023-04-15 08:00:00', '2024-02-10 08:00:00'),
    ('Asus ZenBook 14 OLED',      'Noutbuk',  'Asus',     1199.00,  890.00,  30, TRUE,  '2023-05-01 08:00:00', '2023-05-01 08:00:00'),
    ('HP EliteBook 840 G10',      'Noutbuk',  'HP',       1899.00, 1420.00,  12, TRUE,  '2023-07-01 08:00:00', '2024-01-15 08:00:00'),
    ('iPad Pro 12.9 M2',          'Planset',  'Apple',    1999.00, 1500.00,  22, TRUE,  '2023-01-15 08:00:00', '2024-05-20 08:00:00'),
    ('Samsung Galaxy Tab S9+',    'Planset',  'Samsung',  1299.00,  970.00,  28, TRUE,  '2023-03-01 08:00:00', '2024-03-01 08:00:00'),
    ('Xiaomi Pad 6 Pro',          'Planset',  'Xiaomi',    599.00,  420.00,  40, TRUE,  '2023-06-15 08:00:00', '2023-06-15 08:00:00'),
    ('AirPods Pro 2nd Gen',       'Aksesuar', 'Apple',     499.00,  340.00, 100, TRUE,  '2023-01-01 08:00:00', '2024-06-15 08:00:00'),
    ('Samsung Galaxy Watch 6',    'Aksesuar', 'Samsung',   399.00,  270.00,  55, TRUE,  '2023-07-15 08:00:00', '2024-04-01 08:00:00'),
    ('Anker 65W GaN Charger',     'Aksesuar', 'Anker',      89.00,   45.00, 200, TRUE,  '2023-02-15 08:00:00', '2023-02-15 08:00:00'),
    ('Logitech MX Master 3S',     'Aksesuar', 'Logitech',  199.00,  130.00,  75, TRUE,  '2023-04-01 08:00:00', '2024-02-28 08:00:00'),
    ('Sony WH-1000XM5',           'Aksesuar', 'Sony',      449.00,  310.00,  35, FALSE, '2023-01-20 08:00:00', '2024-08-10 08:00:00');


INSERT INTO orders (customer_id, store_id, employee_id, order_date, status, total_amount, created_at) VALUES
    ( 1,  1,  2, '2023-02-10', 'completed',  2998.00, '2023-02-10 10:30:00'),
    ( 3,  2,  5, '2023-02-18', 'completed',  2199.00, '2023-02-18 14:00:00'),
    ( 5,  1,  3, '2023-03-05', 'completed',  4998.00, '2023-03-05 11:15:00'),
    ( 2,  1,  2, '2023-03-22', 'completed',   499.00, '2023-03-22 09:45:00'),
    ( 7,  4, 10, '2023-04-08', 'completed',  1999.00, '2023-04-08 15:30:00'),
    ( 4,  3,  7, '2023-04-20', 'completed',  1198.00, '2023-04-20 10:00:00'),
    ( 6,  1,  3, '2023-05-03', 'completed',  2299.00, '2023-05-03 13:20:00'),
    ( 9,  1,  2, '2023-05-17', 'completed',   999.00, '2023-05-17 11:00:00'),
    (11,  5, 12, '2023-06-01', 'completed',  3999.00, '2023-06-01 09:30:00'),
    (13,  2,  5, '2023-06-15', 'completed',  2099.00, '2023-06-15 14:45:00'),
    ( 8,  3,  8, '2023-07-02', 'completed',   699.00, '2023-07-02 10:15:00'),
    (15,  1,  3, '2023-07-18', 'completed',  2998.00, '2023-07-18 12:00:00'),
    (10,  5, 11, '2023-08-05', 'completed',  1299.00, '2023-08-05 15:00:00'),
    (12,  2,  4, '2023-08-22', 'completed',   588.00, '2023-08-22 10:30:00'),
    (17,  1,  2, '2023-09-07', 'completed',  4998.00, '2023-09-07 09:00:00'),
    (14,  4,  9, '2023-09-20', 'completed',  1599.00, '2023-09-20 13:45:00'),
    (19,  1,  3, '2023-10-04', 'completed',   898.00, '2023-10-04 11:30:00'),
    (16,  3,  7, '2023-10-19', 'completed',  2199.00, '2023-10-19 14:00:00'),
    (21,  5, 12, '2023-11-02', 'completed',  3998.00, '2023-11-02 10:00:00'),
    (18,  2,  5, '2023-11-16', 'completed',   599.00, '2023-11-16 15:30:00'),
    (20,  1,  2, '2023-12-01', 'completed',  1199.00, '2023-12-01 09:45:00'),
    ( 1,  1,  3, '2023-12-20', 'completed',   499.00, '2023-12-20 11:00:00'),
    (23,  5, 11, '2024-01-08', 'completed',  2999.00, '2024-01-08 10:30:00'),
    (22,  3,  8, '2024-01-22', 'completed',  1998.00, '2024-01-22 14:15:00'),
    (25,  1,  2, '2024-02-05', 'completed',  4299.00, '2024-02-05 09:30:00'),
    (24,  2,  5, '2024-02-19', 'completed',   399.00, '2024-02-19 12:00:00'),
    ( 2,  1,  3, '2024-03-04', 'completed',  2498.00, '2024-03-04 10:15:00'),
    ( 5,  5, 12, '2024-03-18', 'completed',  1199.00, '2024-03-18 15:00:00'),
    ( 7,  4, 10, '2024-04-01', 'completed',   899.00, '2024-04-01 09:00:00'),
    (13,  2,  4, '2024-04-15', 'completed',  3499.00, '2024-04-15 13:30:00'),
    ( 9,  1,  2, '2024-05-02', 'completed',  2699.00, '2024-05-02 11:00:00'),
    (15,  3,  7, '2024-05-20', 'completed',   789.00, '2024-05-20 14:45:00'),
    (19,  1,  3, '2024-06-03', 'completed',  1999.00, '2024-06-03 10:30:00'),
    (11,  5, 11, '2024-06-17', 'completed',   498.00, '2024-06-17 09:15:00'),
    ( 3,  2,  5, '2024-07-01', 'completed',  2099.00, '2024-07-01 12:00:00'),
    (17,  1,  2, '2024-07-15', 'completed',  1299.00, '2024-07-15 15:30:00'),
    (21,  3,  8, '2024-08-02', 'completed',  2999.00, '2024-08-02 10:00:00'),
    ( 4,  4,  9, '2024-08-16', 'completed',   699.00, '2024-08-16 13:00:00'),
    (25,  1,  3, '2024-09-01', 'cancelled',  1999.00, '2024-09-01 09:30:00'),
    ( 6,  5, 12, '2024-09-15', 'completed',  2499.00, '2024-09-15 11:45:00');


INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount, total_price, created_at) VALUES
    ( 1,  4, 1, 1599.00,   0.00, 1599.00, '2023-02-10 10:30:00'),
    ( 1, 14, 1,  499.00,   0.00,  499.00, '2023-02-10 10:30:00'),
    ( 1, 16, 1,   89.00,   0.00,   89.00, '2023-02-10 10:30:00'),
    ( 2,  2, 1, 2199.00,   0.00, 2199.00, '2023-02-18 14:00:00'),
    ( 3,  6, 1, 3999.00,   0.00, 3999.00, '2023-03-05 11:15:00'),
    ( 3,  9, 1, 1199.00, 200.00,  999.00, '2023-03-05 11:15:00'),
    ( 4, 14, 1,  499.00,   0.00,  499.00, '2023-03-22 09:45:00'),
    ( 5, 11, 1, 1999.00,   0.00, 1999.00, '2023-04-08 15:30:00'),
    ( 6, 14, 2,  499.00,  50.00,  948.00, '2023-04-20 10:00:00'),
    ( 6, 17, 1,  199.00,  49.00,  150.00, '2023-04-20 10:00:00'),
    ( 7,  7, 1, 2299.00,   0.00, 2299.00, '2023-05-03 13:20:00'),
    ( 8,  3, 1,  999.00,   0.00,  999.00, '2023-05-17 11:00:00'),
    ( 9,  6, 1, 3999.00,   0.00, 3999.00, '2023-06-01 09:30:00'),
    (10,  8, 1, 2099.00,   0.00, 2099.00, '2023-06-15 14:45:00'),
    (11,  5, 1,  699.00,   0.00,  699.00, '2023-07-02 10:15:00'),
    (12,  1, 1, 2499.00,   0.00, 2499.00, '2023-07-18 12:00:00'),
    (12, 14, 1,  499.00,   0.00,  499.00, '2023-07-18 12:00:00'),
    (13, 12, 1, 1299.00,   0.00, 1299.00, '2023-08-05 15:00:00'),
    (14, 16, 2,   89.00,  10.00,  168.00, '2023-08-22 10:30:00'),
    (14, 17, 1,  199.00, 179.00,   20.00, '2023-08-22 10:30:00'),
    (15,  6, 1, 3999.00,   0.00, 3999.00, '2023-09-07 09:00:00'),
    (15,  9, 1, 1199.00, 200.00,  999.00, '2023-09-07 09:00:00'),
    (16,  4, 1, 1599.00,   0.00, 1599.00, '2023-09-20 13:45:00'),
    (17, 15, 2,  399.00,  49.00,  749.00, '2023-10-04 11:30:00'),
    (17, 16, 1,   89.00,   0.00,   89.00, '2023-10-04 11:30:00'),
    (18,  2, 1, 2199.00,   0.00, 2199.00, '2023-10-19 14:00:00'),
    (19, 15, 2,  399.00,   0.00,  798.00, '2023-11-02 10:00:00'),
    (19,  6, 1, 3999.00, 799.00, 3200.00, '2023-11-02 10:00:00'),
    (20, 13, 1,  599.00,   0.00,  599.00, '2023-11-16 15:30:00'),
    (21,  9, 1, 1199.00,   0.00, 1199.00, '2023-12-01 09:45:00'),
    (22, 14, 1,  499.00,   0.00,  499.00, '2023-12-20 11:00:00'),
    (23,  1, 1, 2499.00,   0.00, 2499.00, '2024-01-08 10:30:00'),
    (23, 16, 1,   89.00,   0.00,   89.00, '2024-01-08 10:30:00'),
    (24,  5, 2,  699.00, 200.00, 1198.00, '2024-01-22 14:15:00'),
    (25,  6, 1, 3999.00,   0.00, 3999.00, '2024-02-05 09:30:00'),
    (25,  4, 1, 1599.00, 299.00, 1300.00, '2024-02-05 09:30:00'),
    (26, 15, 1,  399.00,   0.00,  399.00, '2024-02-19 12:00:00'),
    (27,  1, 1, 2499.00,   0.00, 2499.00, '2024-03-04 10:15:00'),
    (28,  9, 1, 1199.00,   0.00, 1199.00, '2024-03-18 15:00:00'),
    (29, 15, 1,  399.00,   0.00,  399.00, '2024-04-01 09:00:00'),
    (29, 16, 2,   89.00,  89.00,   89.00, '2024-04-01 09:00:00'),
    (30, 11, 1, 1999.00,   0.00, 1999.00, '2024-04-15 13:30:00'),
    (30,  8, 1, 2099.00, 599.00, 1500.00, '2024-04-15 13:30:00'),
    (31,  7, 1, 2299.00,   0.00, 2299.00, '2024-05-02 11:00:00'),
    (31, 17, 1,  199.00,  99.00,  100.00, '2024-05-02 11:00:00'),
    (32,  3, 1,  999.00, 299.00,  700.00, '2024-05-20 14:45:00'),
    (32, 16, 1,   89.00,   0.00,   89.00, '2024-05-20 14:45:00'),
    (33, 11, 1, 1999.00,   0.00, 1999.00, '2024-06-03 10:30:00'),
    (34, 14, 2,  499.00, 250.00,  498.00, '2024-06-17 09:15:00'),
    (35,  8, 1, 2099.00,   0.00, 2099.00, '2024-07-01 12:00:00'),
    (36, 12, 1, 1299.00,   0.00, 1299.00, '2024-07-15 15:30:00'),
    (37,  1, 1, 2499.00,   0.00, 2499.00, '2024-08-02 10:00:00'),
    (37, 14, 1,  499.00,   0.00,  499.00, '2024-08-02 10:00:00'),
    (38,  5, 1,  699.00,   0.00,  699.00, '2024-08-16 13:00:00'),
    (39, 11, 1, 1999.00,   0.00, 1999.00, '2024-09-01 09:30:00'),
    (40,  1, 1, 2499.00,   0.00, 2499.00, '2024-09-15 11:45:00');


INSERT INTO payments (order_id, payment_method, amount, payment_date, status, transaction_ref) VALUES
    ( 1, 'card',      2998.00, '2023-02-10 10:35:00', 'success',  'TXN-2023-0001'),
    ( 2, 'card',      2199.00, '2023-02-18 14:05:00', 'success',  'TXN-2023-0002'),
    ( 3, 'transfer',  4998.00, '2023-03-05 11:20:00', 'success',  'TXN-2023-0003'),
    ( 4, 'cash',       499.00, '2023-03-22 09:50:00', 'success',  'TXN-2023-0004'),
    ( 5, 'card',      1999.00, '2023-04-08 15:35:00', 'success',  'TXN-2023-0005'),
    ( 6, 'online',    1198.00, '2023-04-20 10:05:00', 'success',  'TXN-2023-0006'),
    ( 7, 'card',      2299.00, '2023-05-03 13:25:00', 'success',  'TXN-2023-0007'),
    ( 8, 'cash',       999.00, '2023-05-17 11:05:00', 'success',  'TXN-2023-0008'),
    ( 9, 'transfer',  3999.00, '2023-06-01 09:35:00', 'success',  'TXN-2023-0009'),
    (10, 'card',      2099.00, '2023-06-15 14:50:00', 'success','TXN-2023-0010'),
    (11, 'cash',       699.00, '2023-07-02 10:20:00', 'success',  'TXN-2023-0011'),
    (12, 'card',      2998.00, '2023-07-18 12:05:00', 'success',  'TXN-2023-0012'),
    (13, 'online',    1299.00, '2023-08-05 15:05:00', 'success',  'TXN-2023-0013'),
    (14, 'cash',       588.00, '2023-08-22 10:35:00', 'success',  'TXN-2023-0014'),
    (15, 'transfer',  4998.00, '2023-09-07 09:05:00', 'success',  'TXN-2023-0015'),
    (16, 'card',      1599.00, '2023-09-20 13:50:00', 'success',  'TXN-2023-0016'),
    (17, 'online',     898.00, '2023-10-04 11:35:00', 'success',  'TXN-2023-0017'),
    (18, 'card',      2199.00, '2023-10-19 14:05:00', 'success',  'TXN-2023-0018'),
    (19, 'transfer',  3998.00, '2023-11-02 10:05:00', 'success',  'TXN-2023-0019'),
    (20, 'cash',       599.00, '2023-11-16 15:35:00', 'success',  'TXN-2023-0020'),
    (21, 'card',      1199.00, '2023-12-01 09:50:00', 'success',  'TXN-2023-0021'),
    (22, 'cash',       499.00, '2023-12-20 11:05:00', 'success',  'TXN-2023-0022'),
    (23, 'card',      2999.00, '2024-01-08 10:35:00', 'success',  'TXN-2024-0001'),
    (24, 'online',    1998.00, '2024-01-22 14:20:00', 'success',  'TXN-2024-0002'),
    (25, 'transfer',  4299.00, '2024-02-05 09:35:00', 'success',  'TXN-2024-0003'),
    (26, 'cash',       399.00, '2024-02-19 12:05:00', 'success',  'TXN-2024-0004'),
    (27, 'card',      2498.00, '2024-03-04 10:20:00', 'success',  'TXN-2024-0005'),
    (28, 'online',    1199.00, '2024-03-18 15:05:00', 'success',  'TXN-2024-0006'),
    (29, 'cash',       899.00, '2024-04-01 09:05:00', 'success',  'TXN-2024-0007'),
    (30, 'card',      3499.00, '2024-04-15 13:35:00', 'success',  'TXN-2024-0008'),
    (31, 'transfer',  2699.00, '2024-05-02 11:05:00', 'success',  'TXN-2024-0009'),
    (32, 'online',     789.00, '2024-05-20 14:50:00', 'success',  'TXN-2024-0010'),
    (33, 'card',      1999.00, '2024-06-03 10:35:00', 'success',  'TXN-2024-0011'),
    (34, 'cash',       498.00, '2024-06-17 09:20:00', 'success',  'TXN-2024-0012'),
    (35, 'card',      2099.00, '2024-07-01 12:05:00', 'success',  'TXN-2024-0013'),
    (36, 'online',    1299.00, '2024-07-15 15:35:00', 'success',  'TXN-2024-0014'),
    (37, 'card',      2999.00, '2024-08-02 10:05:00', 'success',  'TXN-2024-0015'),
    (38, 'cash',       699.00, '2024-08-16 13:05:00', 'success',  'TXN-2024-0016'),
    (39, 'card',      1999.00, '2024-09-01 09:35:00', 'refunded', 'TXN-2024-0017'),
    (40, 'card',      2499.00, '2024-09-15 11:50:00', 'success',  'TXN-2024-0018');






--INSERT INTO payments (order_id, payment_method, amount, payment_date, status, transaction_ref) VALUES
--    ( 44, 'card',      28.00, '2025-02-10 10:35:00', 'success',  'TXN-2026-0001')
--    
--    
--
--INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount, total_price, created_at) VALUES
--    ( 44,  4, 1, 28.00,   0.00, 28.00, '2025-02-10 10:35:00')
--    
--    

-- Foreign Keys
ALTER TABLE employees  DROP CONSTRAINT IF EXISTS employees_store_id_fkey;
ALTER TABLE orders     DROP CONSTRAINT IF EXISTS orders_customer_id_fkey;
ALTER TABLE orders     DROP CONSTRAINT IF EXISTS orders_store_id_fkey;
ALTER TABLE orders     DROP CONSTRAINT IF EXISTS orders_employee_id_fkey;
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS order_items_order_id_fkey;
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS order_items_product_id_fkey;
ALTER TABLE payments   DROP CONSTRAINT IF EXISTS payments_order_id_fkey;

-- Check Constraints
ALTER TABLE customers   DROP CONSTRAINT IF EXISTS customers_gender_check;
ALTER TABLE orders      DROP CONSTRAINT IF EXISTS orders_status_check;
ALTER TABLE order_items DROP CONSTRAINT IF EXISTS order_items_quantity_check;
ALTER TABLE payments    DROP CONSTRAINT IF EXISTS payments_payment_method_check;
ALTER TABLE payments    DROP CONSTRAINT IF EXISTS payments_status_check;
