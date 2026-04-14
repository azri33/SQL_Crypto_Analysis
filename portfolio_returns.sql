-- Portfolio returns (one of my favorite parts of the analysis)
-- Using a CTE to store the temporary result
-- To calculate daily portfolio returns, I allocate my investment across 4 cryptocurrencies with a ratio of 4:3:2:1
-- By applying SUM, I combine the weighted returns to get the overall daily portfolio return


WITH returns AS (
    SELECT
        date,
        symbol,
        (close_price / LAG(close_price)
            OVER (PARTITION BY symbol ORDER BY date) - 1
        ) AS daily_return
    FROM crypto_prices
)
SELECT
    date,
     ROUND(
        SUM(
            CASE
                WHEN symbol = 'BTC' THEN daily_return * 0.4
                WHEN symbol = 'ETH' THEN daily_return * 0.3
                WHEN symbol = 'SOL' THEN daily_return * 0.2
                WHEN symbol = 'XRP' THEN daily_return * 0.1
            END
         ) * 100, 2
    ) AS portfolio_daily_return_pct
FROM returns
GROUP BY date
ORDER BY date;