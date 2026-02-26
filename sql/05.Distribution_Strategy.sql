USE dairy
GO
PRINT 'III. Distribution Strategy'
GO
PRINT 'Q8. Suggested distribution plan (%) for each product across sales channels (Revenue + Sell-through + Margin + Holding Cost)'
GO

WITH channel_kpis AS (
    SELECT
        [Product Name],
        [Sales Channel],
        COUNT(*) AS No_of_Records,
        SUM([Quantity (liters/kg)]) AS Total_Produced,
        SUM([Quantity Sold (liters/kg)]) AS Total_Sold,
        SUM([Quantity in Stock (liters/kg)]) AS Total_Stock,
        SUM([Approx# Total Revenue(INR)]) AS Total_Revenue,
        ROUND(SUM([Quantity Sold (liters/kg)]) * 100.0 /
            NULLIF(SUM([Quantity (liters/kg)]), 0),
        2) AS Sell_Through_Pct,
        ROUND(AVG(([Price per Unit (sold)] - [Price per Unit]) * 1.0 /
                NULLIF([Price per Unit (sold)], 0)
            ) * 100.0,
        2) AS Avg_Margin_Pct,
        -- Let's Assume holding cost rate of 20% for modelling purposes
        ROUND(SUM([Quantity in Stock (liters/kg)] * [Price per Unit] * 0.20),
        2) AS Est_Annual_Holding_Cost_INR
    FROM dairy_dataset$
    GROUP BY [Product Name],[Sales Channel]
)
SELECT
    [Product Name],
    [Sales Channel],
    No_of_Records,
    Total_Produced,
    Total_Sold,
    Total_Stock,
    ROUND(Total_Revenue, 2) AS Total_Revenue_INR,
    Sell_Through_Pct,
    Avg_Margin_Pct,
    Est_Annual_Holding_Cost_INR,
    ROUND(Total_Revenue * 100.0 /
        NULLIF(SUM(Total_Revenue) OVER (PARTITION BY [Product Name]), 0),2) AS Suggested_Distribution_Pct,
    CASE WHEN Sell_Through_Pct >= 70 AND Avg_Margin_Pct >= 20 AND Est_Annual_Holding_Cost_INR < 50000
    THEN 'Increase Allocation'
    WHEN Sell_Through_Pct < 40 AND Avg_Margin_Pct < 10
    THEN 'Reduce Allocation' ELSE 'Maintain Allocation' END AS Distribution_Decision
FROM channel_kpis
ORDER BY
    [Product Name] ASC,
    Suggested_Distribution_Pct DESC;
