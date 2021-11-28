---Create a function, input: order id; return: total of that order. 
--List invoices and use that function to attach the order total to the other fields of invoices. 

CREATE FUNCTION Sales.OrderTotal (@orderid INT)
RETURNS TABLE
AS 
RETURN (
	SELECT OrderID, SUM(Quantity * UnitPrice) AS Total
	FROM Sales.OrderLines
WHERE OrderID = @orderid
	GROUP BY OrderID
		)

SELECT *
FROM Sales.Invoices i
	CROSS APPLY Sales.OrderTotal(OrderID) f
