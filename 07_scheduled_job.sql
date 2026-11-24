-- ICT371 Q1 (g): pr_refresh_sales + pg_cron schedule
CREATE OR REPLACE PROCEDURE pr_refresh_sales(p_day DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_day IS NULL THEN
        RAISE EXCEPTION 'p_day is required';
    END IF;

    -- Upsert: rerunning REPLACES the totals, never adds to them.
    -- An aggregate without GROUP BY always returns one row, so a day
    -- with no sales is stored as 0 / 0.00.
    INSERT INTO daily_sales (sales_date, total_qty, total_amount)
    SELECT p_day,
           COALESCE(SUM(quantity), 0),
           COALESCE(SUM(quantity * unit_price), 0)
    FROM sales
    WHERE sold_on = p_day
    ON CONFLICT (sales_date) DO UPDATE
    SET total_qty    = EXCLUDED.total_qty,
        total_amount = EXCLUDED.total_amount;
END;
$$;

-- Requires pg_cron in shared_preload_libraries (postgresql.conf)
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Daily at 00:15, for the previous day (named job: rerunning this
-- statement updates the same job instead of creating a duplicate)
SELECT cron.schedule(
    'refresh_sales_daily',
    '15 0 * * *',
    $$CALL pr_refresh_sales(CURRENT_DATE - 1)$$
);

-- Inspect:
-- SELECT jobid, jobname, schedule, command FROM cron.job;
-- SELECT * FROM cron.job_run_details ORDER BY start_time DESC LIMIT 5;
