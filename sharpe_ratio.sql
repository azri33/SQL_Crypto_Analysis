-- Sharpe Ratio measures risk-adjusted return
-- It shows how much return is generated for each unit of risk taken
-- It is calculated by dividing the average portfolio return by its volatility, then annualizing the result
-- A higher Sharpe Ratio indicates better risk-adjusted performance


WITH portfolio_returns AS (
    SELECT
        date,
        SUM(
            CASE
                WHEN symbol = 'BTC' THEN daily_return * 0.4
                WHEN symbol = 'ETH' THEN daily_return * 0.3
                WHEN symbol = 'SOL' THEN daily_return * 0.2
                WHEN symbol = 'XRP' THEN daily_return * 0.1
            END
        ) AS daily_return
    FROM (
        SELECT
            date,
            symbol,
            (close_price / LAG(close_price)
                OVER (PARTITION BY symbol ORDER BY date) - 1
            ) AS daily_return
        FROM crypto_prices
    ) r
    WHERE daily_return IS NOT NULL
    GROUP BY date
)
SELECT
    AVG(daily_return) / STDDEV(daily_return) * SQRT(365) AS sharpe_ratio
FROM portfolio_returns;