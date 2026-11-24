-- ICT371 Q1 (f): index for one medicine's sales in a sold_on range
-- medicine_id first (equality), sold_on second (range scan).
CREATE INDEX IF NOT EXISTS idx_sales_medicine_sold_on
    ON sales (medicine_id, sold_on);

ANALYZE sales;

-- The tables are tiny, so discourage a sequential scan for the demonstration
SET enable_seqscan = off;

EXPLAIN
SELECT sale_id, quantity, unit_price, sold_on
FROM sales
WHERE medicine_id = 1
  AND sold_on BETWEEN DATE '2026-11-20' AND DATE '2026-11-23';

RESET enable_seqscan;
