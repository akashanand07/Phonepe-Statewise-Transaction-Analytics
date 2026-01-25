CREATE DATABASE phonepay_analysis;
USE phonepay_analysis;
CREATE TABLE phonepe_state_transactions (
    state CHAR(2),
    year INT,
    quarter INT,
    txn_type VARCHAR(15),
    txn_count BIGINT,
    txn_amount_cr DECIMAL(12,2)
);
DESCRIBE phonepe_state_transactions; 
SELECT COUNT(*) FROM phonepe_state_transactions;
ALTER TABLE phonepe_state_transactions
ADD PRIMARY KEY (state, year, quarter, txn_type);
SELECT
    state,
    ROUND(SUM(txn_amount_cr), 2) AS total_amount_cr
FROM phonepe_state_transactions
GROUP BY state
ORDER BY total_amount_cr DESC;
SELECT
    txn_type,
    ROUND(SUM(txn_amount_cr), 2) AS total_amount_cr,
    SUM(txn_count) AS total_txn_count
FROM phonepe_state_transactions
GROUP BY txn_type
ORDER BY total_amount_cr DESC;
SELECT
    year,
    ROUND(SUM(txn_amount_cr), 2) AS total_amount_cr,
    ROUND(
        (SUM(txn_amount_cr) -
         LAG(SUM(txn_amount_cr)) OVER (ORDER BY year))
        / LAG(SUM(txn_amount_cr)) OVER (ORDER BY year) * 100,
        2
    ) AS yoy_growth_pct
FROM phonepe_state_transactions
GROUP BY year
ORDER BY year;
SELECT
    state,
    ROUND(
        (SUM(CASE WHEN year = 2024 THEN txn_amount_cr END) -
         SUM(CASE WHEN year = 2020 THEN txn_amount_cr END))
        / SUM(CASE WHEN year = 2020 THEN txn_amount_cr END) * 100,
        2
    ) AS growth_pct
FROM phonepe_state_transactions
GROUP BY state
HAVING SUM(CASE WHEN year = 2020 THEN txn_amount_cr END) > 0
ORDER BY growth_pct DESC;
SELECT
    year,
    txn_type,
    ROUND(SUM(txn_amount_cr), 2) AS total_amount_cr
FROM phonepe_state_transactions
WHERE txn_type IN ('P2P', 'Merchant')
GROUP BY year, txn_type
ORDER BY year, txn_type;
SELECT
    quarter,
    ROUND(SUM(txn_amount_cr), 2) AS total_amount_cr
FROM phonepe_state_transactions
GROUP BY quarter
ORDER BY quarter;
