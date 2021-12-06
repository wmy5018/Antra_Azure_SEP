USE WideWorldImporters;
GO

SELECT OrderID
FROM Sales.Invoices
WHERE JSON_VALUE(ReturnedDeliveryData, '$.Events[1].Comment') IS NOT NULL
