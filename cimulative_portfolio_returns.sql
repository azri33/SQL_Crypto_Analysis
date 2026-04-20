-- This analysis extends the portfolio return model by incorporating actual investment capital of rm 10000
-- Starting with an initial capital of RM10,000, the query simulates how the portfolio grows over time based on the predefined asset allocation 
-- The results reflect the real monetary growth of the portfolio, aligned with the weighted returns
-- This model can be further enhanced by adjusting portfolio weights or initial capital to optimize returns
-- The capital would be rm 10000


WITH portfolio AS (
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
    GROUP BY date
)
SELECT
    date,
    ROUND (10000 * EXP(SUM(LN(1 + daily_return)) OVER (ORDER BY date)), 2) AS cumulative_growth
FROM portfolio;
