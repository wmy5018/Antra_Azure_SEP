----23.	Rewrite your stored procedure in (21). 
--Now with a given date, it should wipe out all the order data prior to the input date 
--and load the order data that was placed in the next 7 days following the input date.

DROP PROCEDURE ods.OrderTotalOfDate;

CREATE PROCEDURE ods.NewOrderTotalOfDate
	@OrderDate DATE
AS 

BEGIN TRANSACTION
	DELETE FROM ods.Orders
	WHERE OrderDate < @OrderDate
COMMIT

BEGIN TRANSACTION
	MERGE ods.Orders T
	USING (	
			SELECT o.OrderID, o.OrderDate, f.Total, o.CustomerID
			FROM Sales.Orders o
				CROSS APPLY Sales.OrderTotal(OrderID) f
			WHERE DATEDIFF(d, @OrderDate, OrderDate) BETWEEN 1 AND 7
			) R
	ON T.OrderID = R.OrderID
	WHEN NOT MATCHED
		THEN INSERT VALUES (R.OrderID, R.OrderDate, R.Total, R.CustomerID);
COMMIT
