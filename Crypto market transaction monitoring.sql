-- this is SQL-Advanced 2025 --
-- Crypto market transaction monitoring --

WITH difference AS (
    SELECT
        sender,
        dt,
        amount,
        TIMESTAMPDIFF(MINUTE, LAG(dt) OVER (PARTITION BY sender ORDER BY dt), dt) AS diff_minute,
        ROW_NUMBER() OVER (PARTITION BY sender ORDER BY dt) AS rownumber
    FROM `transactions`
),
rn AS (
    SELECT
        *,
        CASE WHEN diff_minute IS NULL OR ABS(diff_minute) >= 60 THEN 1 ELSE 0 END AS new_sequence
    FROM difference
),
sequences AS (
    SELECT
        *,
        SUM(new_sequence) OVER (PARTITION BY sender ORDER BY dt) AS sequence_id
    FROM rn
)
SELECT
    sender,
    MIN(dt) AS Sequence_start,
    MAX(dt) AS Sequence_end,
    COUNT(rownumber) AS transactions_count,
    SUM(amount) AS transactions_sum
FROM sequences
GROUP BY sender, sequence_id
HAVING transactions_sum >= 150
ORDER BY sender, Sequence_start, Sequence_end;
