WITH cte0 AS (
	SELECT ol.StockItemID, c.DeliveryCityID, COUNT(*) AS Delivery
	FROM Sales.OrderLines ol
		JOIN Sales.Orders o ON o.OrderID = ol.OrderID
		JOIN sales.Customers c ON o.CustomerID = c.CustomerID
	WHERE YEAR(o.OrderDate) = 2016
	GROUP BY ol.StockItemID, c.DeliveryCityID),

cte1 AS(
	SELECT StockItemID, DeliveryCityID
	FROM ( 
		SELECT StockItemID, DeliveryCityID, 
			DENSE_RANK() OVER(PARTITION BY DeliveryCityId ORDER BY Delivery DESC) AS rnk
		FROM cte0) a
	WHERE rnk = 1
)

SELECT c.CityName, ISNULL(s.StockItemName, 'No Sale') AS MostDelivery
FROM cte1 c1 JOIN Warehouse.StockItems s ON c1.StockItemID = s.StockItemID
	RIGHT JOIN Application.Cities c ON c1.DeliveryCityID = c.CityID
