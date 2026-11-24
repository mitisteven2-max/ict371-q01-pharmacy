-- ICT371 Q1 (e): v_low_stock
CREATE OR REPLACE VIEW v_low_stock AS
SELECT medicine_id,
       medicine_name,
       unit_price,
       stock_qty AS remaining_stock
FROM medicines
WHERE stock_qty < 10;
