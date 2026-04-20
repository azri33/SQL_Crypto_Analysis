-- Volatility helps us understand risk
-- High volatility = daily returns fluctuate a lot (less stable, higher risk & potential return)
-- Low volatility = daily returns are more stable (lower risk, slower growth)
-- We use a CTE called "returns" as a temporary table
-- Volatility is measured using standard deviation (STDDEV), which shows how much returns deviate from the average
-- To calculate annual volatility: multiply STDDEV(daily_return) by sqrt(365)
-- Note: Crypto trades 24/7, so we use 365 instead of 252


WITH returns AS (
    SELECT
        symbol,
        (close_price / LAG(close_price)
            OVER (PARTITION BY symbol ORDER BY date) - 1
        ) AS daily_return
    FROM crypto_prices
)
SELECT
    symbol,
    STDDEV(daily_return) * SQRT(365) AS annual_volatility
FROM returns
GROUP BY symbol;
