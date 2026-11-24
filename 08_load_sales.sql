-- ICT371 Q1 (a): six valid sales, loaded THROUGH pr_record_sale
-- (run after the trigger exists so stock_audit is populated too)
CALL pr_record_sale(1, 20, DATE '2026-11-20');
CALL pr_record_sale(1, 10, DATE '2026-11-21');
CALL pr_record_sale(2, 15, DATE '2026-11-21');
CALL pr_record_sale(3,  5, DATE '2026-11-22');
CALL pr_record_sale(2, 10, DATE '2026-11-22');
CALL pr_record_sale(1, 30, DATE '2026-11-23');
