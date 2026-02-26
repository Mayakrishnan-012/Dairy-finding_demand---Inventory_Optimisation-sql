create database dairy
GO
use dairy
GO
PRINT 'A. data understaning'
GO
EXEC sp_help dairy_dataset$
GO

PRINT 'Checking null values in row wise'
GO
SELECT * ,
(CASE WHEN Location is NULL THEN 1 ELSE 0 END +
CASE WHEN [Total Land Area (acres)] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Number of Cows] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Farm Size] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Product ID] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Product Name] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Brand] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Quantity (liters/kg)] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Price per Unit] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Total Value] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Shelf Life (days)] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Storage Condition] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Production Date] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Expiration Date] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Quantity Sold (liters/kg)] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Price per Unit (sold)] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Approx# Total Revenue(INR)] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Customer Location] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Sales Channel] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Quantity in Stock (liters/kg)] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Minimum Stock Threshold (liters/kg)] IS NULL THEN 1 ELSE 0 END +
CASE WHEN [Reorder Quantity (liters/kg)] IS NULL THEN 1 ELSE 0 END
) AS NULL_COUNT
FROM dairy_dataset$
GO

PRINT 'Checking null values in column wise'
GO
SELECT *
FROM dairy_dataset$
WHERE Location IS NULL
   OR [Total Land Area (acres)] IS NULL
   OR [Number of Cows] IS NULL
   OR [Farm Size] IS NULL
   OR [Date] IS NULL
   OR [Product ID] IS NULL
   OR [Product Name] IS NULL
   OR [Brand] IS NULL
   OR [Quantity (liters/kg)] IS NULL
   OR [Price per Unit] IS NULL
   OR [Total Value] IS NULL
   OR [Shelf Life (days)] IS NULL
   OR [Storage Condition] IS NULL
   OR [Production Date] IS NULL
   OR [Expiration Date] IS NULL
   OR [Quantity Sold (liters/kg)] IS NULL
   OR [Price per Unit (sold)] IS NULL
   OR [Approx# Total Revenue(INR)] IS NULL
   OR [Customer Location] IS NULL
   OR [Sales Channel] IS NULL
   OR [Quantity in Stock (liters/kg)] IS NULL
   OR [Minimum Stock Threshold (liters/kg)] IS NULL
   OR [Reorder Quantity (liters/kg)] IS NULL
GO

PRINT 'Checking the negative values'
GO
SELECT * FROM dairy_dataset$
WHERE [Total Land Area (acres)] <0
OR [Number of Cows] < 0
OR [Product ID] < 0
OR [Quantity (liters/kg)] < 0
OR [Price per Unit] < 0
OR [Total Value] < 0
OR [Shelf Life (days)] < 0
OR [Quantity Sold (liters/kg)] <0 
OR [Price per Unit (sold)] <0
OR [Approx# Total Revenue(INR)] <0
OR [Quantity in Stock (liters/kg)] <0
OR [Minimum Stock Threshold (liters/kg)] <0
OR [Reorder Quantity (liters/kg)] <0
GO

PRINT 'Checking impossible dates'
GO
SELECT * FROM dairy_dataset$
WHERE [Production Date] > [Expiration Date]
GO

PRINT 'Checking impossible values'
GO
SELECT * FROM dairy_dataset$
WHERE [Quantity (liters/kg)]< [Quantity Sold (liters/kg)]
OR [Quantity (liters/kg)] < [Quantity in Stock (liters/kg)]
OR ([Quantity (liters/kg)]- [Quantity Sold (liters/kg)]) < [Quantity in Stock (liters/kg)]
OR ([Quantity Sold (liters/kg)] + [Quantity in Stock (liters/kg)]) > [Quantity (liters/kg)]
OR DATEDIFF(day, [Production Date],[Expiration Date]) <> [Shelf Life (days)];
