-- ICT371 Q1: demonstration queries

-- (b) function
SELECT fn_sale_value(1, 4) AS value_of_4_paracetamol;      -- 10.00

-- (b) rejections
DO $$ BEGIN PERFORM fn_sale_value(999, 1);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;
DO $$ BEGIN PERFORM fn_sale_value(1, 0);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;

-- (c) invalid sale (oversell) leaves tables unchanged
SELECT stock_qty AS stock_before FROM medicines WHERE medicine_id = 3;
DO $$ BEGIN CALL pr_record_sale(3, 500, CURRENT_DATE);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;
SELECT stock_qty AS stock_after  FROM medicines WHERE medicine_id = 3;
SELECT count(*) AS sales_rows FROM sales;                  -- still 6

-- (d) audit trail (one row per sale; none for unchanged stock)
UPDATE medicines SET stock_qty = stock_qty WHERE medicine_id = 1;  -- no audit row
UPDATE medicines SET unit_price = 2.60 WHERE medicine_id = 1;      -- no audit row
UPDATE medicines SET unit_price = 2.50 WHERE medicine_id = 1;
SELECT * FROM stock_audit ORDER BY audit_id;

-- (e) view after the sales: Ibuprofen has 7 left
SELECT * FROM v_low_stock;

-- (g) run the job twice: totals must stay the same
CALL pr_refresh_sales(DATE '2026-11-21');
CALL pr_refresh_sales(DATE '2026-11-21');
SELECT * FROM daily_sales ORDER BY sales_date;            

-- (f) EXPLAIN again now that the tables contain data
ANALYZE sales;

-- The tables are tiny, so discourage a sequential scan for the demonstration
SET enable_seqscan = off;

EXPLAIN
SELECT sale_id, quantity, unit_price, sold_on
FROM sales
WHERE medicine_id = 1
  AND sold_on BETWEEN DATE '2026-11-20' AND DATE '2026-11-23';

RESET enable_seqscan;
