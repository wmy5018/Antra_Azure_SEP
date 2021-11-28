CREATE SCHEMA ods

GO

CREATE TABLE ods.Orders
(OrderID INT PRIMARY KEY,
OrderDate DATE,
OrderTotal DECIMAL(18, 2),
CustomerID INT)

GO

CREATE PROCEDURE ods.OrderTotalOfDate
	@OrderDate DATE
AS 

IF EXISTS (SELECT 1 FROM ods.Orders WHERE OrderDate = @OrderDate)
	BEGIN
		RAISERROR('Date Exists ', 16, 1)
	END
ELSE
	BEGIN
		BEGIN TRANSACTION
			INSERT INTO ods.Orders
			SELECT o.OrderID, o.OrderDate, f.Total, o.CustomerID
			FROM Sales.Orders o
				CROSS APPLY Sales.OrderTotal(OrderID) f
			WHERE o.OrderDate = @OrderDate
		COMMIT
	END
GO
EXEC ods.OrderTotalOfDate '2013-01-01'
EXEC ods.OrderTotalOfDate '2013-01-02'
EXEC ods.OrderTotalOfDate '2013-01-03'
EXEC ods.OrderTotalOfDate '2013-01-04'
EXEC ods.OrderTotalOfDate '2013-01-05'
