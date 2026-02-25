USE dairy
GO
PRINT 'II. Inventary Optimisation'
GO
PRINT 'Q5. How can reorder quantities be dynamically optimised at product-location level using demand, shortage, and expiry risk indicators?'
GO
WITH product_kpis AS (
    SELECT
        [Product Name],
        [Location],
        -- Demand signal
        ROUND(
            SUM([Quantity Sold (liters/kg)]) * 100.0 /
            NULLIF(SUM([Quantity (liters/kg)]), 0),
        2) AS Sell_Through_Pct, 
        -- Shelf-life pressure (remaining days at reporting date)
        AVG(DATEDIFF(day, [Date], [Expiration Date])) AS Avg_Remaining_Days,
        SUM([Quantity in Stock (liters/kg)]) AS Total_Stock,
        SUM([Reorder Quantity (liters/kg)]) AS Old_Total_Reorder,
        SUM([Minimum Stock Threshold (liters/kg)]) AS Total_Threshold
    FROM dairy_dataset$
    WHERE DATEDIFF(day, [Date], [Expiration Date]) >= 0  -- ignore already-expired rows for "remaining days"
    GROUP BY [Product Name],[Location]
),
rules AS (
    SELECT
        *,
        CASE WHEN (Total_Stock + Old_Total_Reorder) < Total_Threshold THEN 1 ELSE 0 END AS Shortage_Risk_Flag,
        CASE WHEN Avg_Remaining_Days < 7 THEN 1 ELSE 0 END AS Expiry_Risk_Flag,

        CASE
            -- High demand
            WHEN Sell_Through_Pct >= 70 AND (Total_Stock + Old_Total_Reorder) < Total_Threshold THEN 0.30
            WHEN Sell_Through_Pct >= 70 THEN 0.15

            -- Moderate demand
            WHEN Sell_Through_Pct >= 45 AND Sell_Through_Pct < 70 AND Avg_Remaining_Days < 7 THEN 0.00
            WHEN Sell_Through_Pct >= 45 AND Sell_Through_Pct < 70 THEN 0.10

            -- Low demand
            WHEN Sell_Through_Pct < 45 AND Avg_Remaining_Days < 7 THEN -0.40
            ELSE -0.20
        END AS Reorder_Adjustment_Rate
    FROM product_kpis
)
SELECT
    [Product Name],
    [Location],
    Sell_Through_Pct,
    ROUND(Avg_Remaining_Days, 2) AS Avg_Remaining_Days,
    Total_Stock,
    Old_Total_Reorder,
    Total_Threshold,
    Shortage_Risk_Flag,
    Expiry_Risk_Flag,
    Reorder_Adjustment_Rate,
    ROUND(Old_Total_Reorder * (1 + Reorder_Adjustment_Rate), 2) AS Suggested_New_Reorder
FROM rules
ORDER BY [Product Name] ASC,
		 Suggested_New_Reorder DESC
GO
PRINT 'Q6. How can reorder quantities be dynamically optimised at product-Season level using demand, shortage, and expiry risk indicators?'
GO
WITH product_kpis AS (
    SELECT
        [Product Name],
        MONTH([Production Date]) AS [Month_of_Production],
        -- Demand signal
        ROUND(
            SUM([Quantity Sold (liters/kg)]) * 100.0 /
            NULLIF(SUM([Quantity (liters/kg)]), 0),
        2) AS Sell_Through_Pct, 
        -- Shelf-life pressure (remaining days at reporting date)
        AVG(DATEDIFF(day, [Date], [Expiration Date])) AS Avg_Remaining_Days,
        SUM([Quantity in Stock (liters/kg)]) AS Total_Stock,
        SUM([Reorder Quantity (liters/kg)]) AS Old_Total_Reorder,
        SUM([Minimum Stock Threshold (liters/kg)]) AS Total_Threshold
    FROM dairy_dataset$
    WHERE DATEDIFF(day, [Date], [Expiration Date]) >= 0  -- ignore already-expired rows for "remaining days"
    GROUP BY [Product Name],MONTH([Production Date])
),
rules AS (
    SELECT
        *,
        CASE WHEN (Total_Stock + Old_Total_Reorder) < Total_Threshold THEN 1 ELSE 0 END AS Shortage_Risk_Flag,
        CASE WHEN Avg_Remaining_Days < 7 THEN 1 ELSE 0 END AS Expiry_Risk_Flag,

        CASE
            -- High demand
            WHEN Sell_Through_Pct >= 70 AND (Total_Stock + Old_Total_Reorder) < Total_Threshold THEN 0.30
            WHEN Sell_Through_Pct >= 70 THEN 0.15

            -- Moderate demand
            WHEN Sell_Through_Pct >= 45 AND Sell_Through_Pct < 70 AND Avg_Remaining_Days < 7 THEN 0.00
            WHEN Sell_Through_Pct >= 45 AND Sell_Through_Pct < 70 THEN 0.10

            -- Low demand
            WHEN Sell_Through_Pct < 45 AND Avg_Remaining_Days < 7 THEN -0.40
            ELSE -0.20
        END AS Reorder_Adjustment_Rate
    FROM product_kpis
)
SELECT
    [Product Name],
    [Month_of_Production],
    Sell_Through_Pct,
    ROUND(Avg_Remaining_Days, 2) AS Avg_Remaining_Days,
    Total_Stock,
    Old_Total_Reorder,
    Total_Threshold,
    Shortage_Risk_Flag,
    Expiry_Risk_Flag,
    Reorder_Adjustment_Rate,
    ROUND(Old_Total_Reorder * (1 + Reorder_Adjustment_Rate), 2) AS Suggested_New_Reorder
FROM rules
ORDER BY [Product Name] ASC,
		 Suggested_New_Reorder DESC
GO
PRINT 'Q7. A Multi-Dimensional Inventory Replenishment Model Integrating Product, Location, and Seasonal Demand Variation?'
GO
WITH product_kpis AS (
    SELECT
        [Product Name],
        [Location],
        MONTH([Production Date]) AS [Month_of_Production],
        -- Demand signal
        ROUND(
            SUM([Quantity Sold (liters/kg)]) * 100.0 /
            NULLIF(SUM([Quantity (liters/kg)]), 0),
        2) AS Sell_Through_Pct, 
        -- Shelf-life pressure (remaining days at reporting date)
        AVG(DATEDIFF(day, [Date], [Expiration Date])) AS Avg_Remaining_Days,
        SUM([Quantity in Stock (liters/kg)]) AS Total_Stock,
        SUM([Reorder Quantity (liters/kg)]) AS Old_Total_Reorder,
        SUM([Minimum Stock Threshold (liters/kg)]) AS Total_Threshold
    FROM dairy_dataset$
    WHERE DATEDIFF(day, [Date], [Expiration Date]) >= 0  -- ignore already-expired rows for "remaining days"
    GROUP BY [Product Name],[Location],MONTH([Production Date])
),
rules AS (
    SELECT
        *,
        CASE WHEN (Total_Stock + Old_Total_Reorder) < Total_Threshold THEN 1 ELSE 0 END AS Shortage_Risk_Flag,
        CASE WHEN Avg_Remaining_Days < 7 THEN 1 ELSE 0 END AS Expiry_Risk_Flag,

        CASE
            -- High demand
            WHEN Sell_Through_Pct >= 70 AND (Total_Stock + Old_Total_Reorder) < Total_Threshold THEN 0.30
            WHEN Sell_Through_Pct >= 70 THEN 0.15

            -- Moderate demand
            WHEN Sell_Through_Pct >= 45 AND Sell_Through_Pct < 70 AND Avg_Remaining_Days < 7 THEN 0.00
            WHEN Sell_Through_Pct >= 45 AND Sell_Through_Pct < 70 THEN 0.10

            -- Low demand
            WHEN Sell_Through_Pct < 45 AND Avg_Remaining_Days < 7 THEN -0.40
            ELSE -0.20
        END AS Reorder_Adjustment_Rate
    FROM product_kpis
)
SELECT
    [Product Name],
    [Location],
    [Month_of_Production],
    Sell_Through_Pct,
    ROUND(Avg_Remaining_Days, 2) AS Avg_Remaining_Days,
    Total_Stock,
    Old_Total_Reorder,
    Total_Threshold,
    Shortage_Risk_Flag,
    Expiry_Risk_Flag,
    Reorder_Adjustment_Rate,
    ROUND(Old_Total_Reorder * (1 + Reorder_Adjustment_Rate), 2) AS Suggested_New_Reorder
FROM rules
ORDER BY [Product Name] ASC,
		 Suggested_New_Reorder DESC;
