USE dairy
GO
PRINT 'B. EXPLORATORY DATA ANALYSIS(EDA)'
GO

PRINT 'I. Sales Performance'
GO
PRINT '1. Which product sells most ?'
GO
SELECT [Product Name], SUM([Quantity Sold (liters/kg)]) AS 'Total Sale',
ROUND(SUM([Quantity Sold (liters/kg)]) * 100.0 / SUM(SUM([Quantity Sold (liters/kg)])) OVER(),2) AS Percent_of_Total
FROM dairy_dataset$
GROUP BY [Product Name]
ORDER BY [Total Sale] DESC;
GO
PRINT '2. Which brand generates the highest revenue?'
SELECT [Brand], SUM([Approx# Total Revenue(INR)]) AS 'Total Revenue (INR)',
ROUND( SUM([Approx# Total Revenue(INR)])*100.0/SUM( SUM([Approx# Total Revenue(INR)])) OVER(),2) AS 'Total Revenue in %'
FROM dairy_dataset$
GROUP BY [Brand]
ORDER BY [Total Revenue (INR)] DESC
GO
PRINT '3.Which location earns the most revenue?'
GO
SELECT [Location], SUM([Approx# Total Revenue(INR)]) AS 'Total Revenue (INR)',
ROUND( SUM([Approx# Total Revenue(INR)])*100.0/SUM( SUM([Approx# Total Revenue(INR)])) OVER(),2) AS 'Total Revenue in %'
FROM dairy_dataset$
GROUP BY [Location]
ORDER BY [Total Revenue (INR)] DESC
GO
PRINT '4. What is the Average sell-through rate per product?'
GO
SELECT [Product Name], 
ROUND(SUM([Quantity Sold (liters/kg)])*100.0/SUM([Quantity (liters/kg)]),2) AS 'AVG Sell through rate in %'
FROM dairy_dataset$
GROUP BY [Product Name]
ORDER BY [AVG Sell through rate in %] DESC
GO

PRINT 'II. Shelf Life and Storage'
GO
PRINT '5. Which products expire fastest?'
GO
SELECT [Product Name], 
MIN([Shelf Life (days)]) AS 'MIN Shelf life',
AVG([Shelf Life (days)]) AS 'AVG Shelf life',
MAX([Shelf Life (days)]) AS 'MAX Shelf life'
FROM dairy_dataset$
GROUP BY [Product Name]
ORDER BY [AVG Shelf life] ASC
GO
Print '6. Which storage condition results in longer shelf life?'
GO
SELECT [Storage Condition], COUNT(*) AS 'Total Storage Conditions',
MIN([Shelf Life (days)]) AS 'MIN Shelf Life (days)',
AVG([Shelf Life (days)]) AS 'AVG Shelf Life (days)',
MAX([Shelf Life (days)]) AS 'MAX Shelf Life (days)'
From dairy_dataset$
GROUP BY [Storage Condition]
ORDER BY [AVG Shelf Life (days)] DESC
GO
Print '7. What is the relationship between Storage condition revenue?'
GO
SELECT [Storage Condition], COUNT(*) AS 'Total Storage Conditions',
MIN([Approx# Total Revenue(INR)]) AS 'MIN Revenue(INR)',
AVG([Approx# Total Revenue(INR)]) AS 'AVG Revenue(INR)',
MAX([Approx# Total Revenue(INR)]) AS 'MAX Revenue(INR)',
SUM([Approx# Total Revenue(INR)]) AS 'Total Revenue(INR)'
From dairy_dataset$
GROUP BY [Storage Condition]
ORDER BY [Total Revenue(INR)] DESC
GO

PRINT 'III. Farm Operations'
GO
PRINT '8. What is the relationship between Farm size and Total Land Area (Acres)?'
GO
SELECT [Farm Size], Count(*) as 'Total No of Farms',
Min([Total Land Area (Acres)]) AS 'MIN Land Area (Acres)',
AVG([Total Land Area (Acres)]) AS 'AVG Land Area (Acres)',
MAX([Total Land Area (Acres)]) AS 'MAX Land Area (Acres)'
FROM dairy_dataset$
GROUP BY [Farm Size]
ORDER BY [AVG Land Area (Acres)] DESC
GO
PRINT '9. What is the relationship between Farm size and Number of Cows?'
GO
SELECT [Farm Size], Count(*) as 'Total No of Farms',
Min([Number of Cows]) AS 'MIN NO OF COWS',
AVG([Number of Cows]) AS 'AVG NO OF COWS',
MAX([Number of Cows]) AS 'MAX NO OF COWS'
FROM dairy_dataset$
GROUP BY [Farm Size]
ORDER BY [AVG NO OF COWS] DESC
GO
PRINT '10. What is the relationship between Farm size and Total revenue(INR)?'
GO
SELECT [Farm Size], Count(*) as 'Total No of Farms',
Min([Approx# Total Revenue(INR)]) AS 'MIN Revenue(INR)',
AVG([Approx# Total Revenue(INR)]) AS 'AVG Revenue(INR)',
MAX([Approx# Total Revenue(INR)]) AS 'MAX Revenue(INR)',
SUM([Approx# Total Revenue(INR)]) AS 'Total Revenue(INR)'
FROM dairy_dataset$
GROUP BY [Farm Size]
ORDER BY [Total Revenue(INR)] DESC
GO

PRINT 'IV. Inventory Behavior'
GO
PRINT '11. Which products require higher reorder quantities'
GO
SELECT [Product Name], COUNT(*) AS 'Total No of Reorders',
MIN([Reorder Quantity (liters/kg)]) AS 'MIN Reorder Quantity (liters/kg)',
AVG([Reorder Quantity (liters/kg)]) AS 'AVG Reorder Quantity (liters/kg)',
MAX([Reorder Quantity (liters/kg)]) AS 'MAX Reorder Quantity (liters/kg)',
SUM([Reorder Quantity (liters/kg)]) AS 'Total Suggested Reorder Quantity (liters/kg)'
From dairy_dataset$
GROUP BY [Product Name]
ORDER BY [AVG Reorder Quantity (liters/kg)] DESC
GO
PRINT '12. What is the average minimum stock threshold for each product?'
GO
SELECT [Product Name],
MIN([Minimum Stock Threshold (liters/kg)]) AS 'MIN of Minimum Stock Threshold (liters/kg)',
AVG([Minimum Stock Threshold (liters/kg)]) AS 'AVG of Minimum Stock Threshold (liters/kg)',
MAX([Minimum Stock Threshold (liters/kg)]) AS 'MAX of Minimum Stock Threshold (liters/kg)',
SUM([Minimum Stock Threshold (liters/kg)]) AS 'Total Minimum Stock Threshold (liters/kg)'
From dairy_dataset$
GROUP BY [Product Name]
ORDER BY [AVG of Minimum Stock Threshold (liters/kg)] DESC
GO
PRINT '13. Which Sales Channel generates most revenue?'
GO
SELECT [Sales Channel], COUNT(*) AS [Total No of Sales],
SUM([Approx# Total Revenue(INR)]) AS 'Total Revenue (INR)',
ROUND( SUM([Approx# Total Revenue(INR)])*100.0/SUM( SUM([Approx# Total Revenue(INR)])) OVER(),2) AS 'Total Revenue in %'
FROM dairy_dataset$
GROUP BY [Sales Channel]
ORDER BY [Total Revenue (INR)] DESC;
