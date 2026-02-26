USE dairy
GO
PRINT 'C. Business Insights'
GO
PRINT 'I. Understand the Demand'
GO
PRINT 'Q1. Which Dairy Products Exhibit the Highest Seasonal Demand, Based on Sell-Through Rates and Shelf Life?'
GO
SELECT [Product Name],
MONTH([Production Date]) AS [Month_of_Production],
COUNT(*) AS [No_of_Sales],
MIN([Shelf Life (days)]) AS [Min_Shelf_Life],
ROUND(AVG([Shelf Life (days)]),2) AS [AVG_Shelf_Life],
MAX([Shelf Life (days)]) AS [MAX_Shelf_Life],
ROUND(SUM([Quantity Sold (liters/kg)])*100.0
		/NULLIF(SUM([Quantity (liters/kg)]),0),2) AS [Sell_through_rate]
FROM dairy_dataset$
GROUP BY [Product Name],MONTH([Production Date])
ORDER BY [Product Name] ASC,
		 [Sell_through_rate] DESC,
		 [AVG_Shelf_Life] DESC
GO
PRINT 'Q2. Which Brand Achieves the Highest Sell-Through and Revenue for each Product?'
GO
SELECT [Product Name],
[Brand],
COUNT(*) AS [No_of_Sales],
MIN([Approx# Total Revenue(INR)]) AS [MIN_Total_Revenue],
MAX([Approx# Total Revenue(INR)]) AS [MAX_Total_Revenue],
ROUND(SUM([Approx# Total Revenue(INR)]),2) AS [SUM_of_Total_Revenue],
ROUND(SUM([Quantity Sold (liters/kg)])*100.0
		/NULLIF(SUM([Quantity (liters/kg)]),0),2) AS [Sell_through_rate]
FROM dairy_dataset$
GROUP BY [Product Name],[Brand]
ORDER BY [Product Name] ASC,
		 [Sell_through_rate] DESC,
		 [SUM_of_Total_Revenue] DESC
GO
PRINT 'Q3. Which Storage Conditions Minimize Wastage and Maximize Shelf Life for Each Product?'
GO
SELECT  [Product Name],
		[Storage Condition],
		COUNT(*) AS [No_of_Sales],
		SUM(CASE 
            WHEN DATEDIFF(day, [Date], [Expiration Date]) < 0
            THEN [Quantity in Stock (liters/kg)]
            ELSE 0
        END
    ) AS [Quantity_in_Waste],
		MIN([Shelf Life (days)]) AS [Min_Shelf_Life],
		ROUND(AVG([Shelf Life (days)]),2) AS [AVG_Shelf_Life],
		MAX([Shelf Life (days)]) AS [MAX_Shelf_Life]
FROM dairy_dataset$
GROUP BY [Product Name],[Storage Condition]
ORDER BY [Product Name] ASC,
		 [Quantity_in_Waste] DESC,
		 [AVG_Shelf_Life] DESC
GO
PRINT 'Q4. Which Sales Channel Delivers the Highest Sell-Through and Revenue for Each Product?'
GO
SELECT  [Product Name],
		[Sales Channel],
		COUNT(*) AS [No_of_Sales],
		MIN([Approx# Total Revenue(INR)]) AS [MIN_Total_Revenue],
		MAX([Approx# Total Revenue(INR)]) AS [MAX_Total_Revenue],
		ROUND(SUM([Approx# Total Revenue(INR)]),2) AS [SUM_of_Total_Revenue],
		ROUND(SUM([Quantity Sold (liters/kg)])*100.0
		/NULLIF(SUM([Quantity (liters/kg)]),0),2) AS [Sell_through_rate_%]
FROM dairy_dataset$
GROUP BY [Product Name],[Sales Channel]
ORDER BY [Product Name] ASC,
		 [Sell_through_rate_%] DESC,
		 [SUM_of_Total_Revenue] DESC;
