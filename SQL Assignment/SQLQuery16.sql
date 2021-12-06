USE WideWorldImporters;
GO

SELECT StockItemID, StockItemName
FROM Warehouse.StockItems
WHERE JSON_VALUE(CustomFields, '$.CountryOfManufacture') = 'China'
