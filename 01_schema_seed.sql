-- ICT371 Q1 (a): Tables, constraints and medicine seed data
DROP TABLE IF EXISTS daily_sales, stock_audit, sales, medicines CASCADE;

CREATE TABLE medicines (
    medicine_id    SERIAL PRIMARY KEY,
    medicine_name  VARCHAR(100) NOT NULL UNIQUE,
    unit_price     NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
    stock_qty      INTEGER       NOT NULL CHECK (stock_qty >= 0)
);

CREATE TABLE sales (
    sale_id      SERIAL PRIMARY KEY,
    medicine_id  INTEGER       NOT NULL REFERENCES medicines(medicine_id),
    quantity     INTEGER       NOT NULL CHECK (quantity > 0),
    unit_price   NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
    sold_on      DATE          NOT NULL
);

CREATE TABLE stock_audit (
    audit_id     SERIAL PRIMARY KEY,
    medicine_id  INTEGER   NOT NULL REFERENCES medicines(medicine_id),
    old_qty      INTEGER   NOT NULL,
    new_qty      INTEGER   NOT NULL,
    changed_at   TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE daily_sales (
    sales_date    DATE PRIMARY KEY,
    total_qty     INTEGER       NOT NULL CHECK (total_qty >= 0),
    total_amount  NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0)
);

-- Seed medicines (sales are loaded later through pr_record_sale)
INSERT INTO medicines (medicine_name, unit_price, stock_qty) VALUES
    ('Paracetamol 500mg', 2.50, 100),
    ('Amoxicillin 250mg', 8.00,  40),
    ('Ibuprofen 400mg',   3.75,  12);
