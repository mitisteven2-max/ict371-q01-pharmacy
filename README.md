# ICT371 Q1 - Pharmacy Stock and Daily Sales

**Student:** Steven Miti (202405283)  
**DBMS:** PostgreSQL (13+) with the pg_cron extension

## How to run
Use a fresh database for this question:
```bash
createdb ict371_q01
psql -d ict371_q01 -f run_all.sql
```
Files run in this order: schema/seed, function, procedure, trigger, view,
index, scheduled job, sales loading (through the procedure), tests.
The trigger is installed **before** `08_load_sales.sql`, so every sale
also writes to `stock_audit`.

| Part | File |
|------|------|
| (a) Tables + seed | `01_schema_seed.sql`, `08_load_sales.sql` |
| (b) Function | `02_function.sql` |
| (c) Procedure | `03_procedure.sql` |
| (d) Trigger | `04_trigger.sql` |
| (e) View | `05_view.sql` |
| (f) Index | `06_index.sql` |
| (g) Scheduled job | `07_scheduled_job.sql` |

## Index justification
`idx_sales_medicine_sold_on ON sales (medicine_id, sold_on)`.
The query filters `medicine_id` by equality and `sold_on` by range, so the
equality column goes first and the range column second. PostgreSQL can then
jump to one medicine's entries and read only the dates in range, already
sorted, instead of scanning the whole table. Reversing the order would force
a scan across every medicine's dates.

## Output
_Paste screenshots / output of `09_tests.sql` and the `EXPLAIN` plan here._
