CREATE VIEW Sales.StockItemByYear AS
	WITH cte0 AS (
		SELECT StockGroupName, 2013 AS [Year]
		FROM Warehouse.StockGroups
		UNION ALL
		SELECT StockGroupName, [Year] + 1
		FROM cte0
		WHERE [Year] < 2017
		),
	cte1 AS (
	SELECT YEAR(o.OrderDate) AS [Year], sg.StockGroupName, SUM(ol.Quantity) AS Quantity
	FROM Sales.Orders o
		JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
		JOIN Warehouse.StockItems s ON ol.StockItemID =s.StockItemID
		JOIN Warehouse.StockItemStockGroups g ON g.StockItemID = s.StockItemID
		JOIN Warehouse.StockGroups sg ON g.StockGroupID = sg.StockGroupID
	WHERE YEAR(o.OrderDate) BETWEEN 2013 AND 2017
	GROUP BY YEAR(o.OrderDate), sg.StockGroupName
	),

	cte2 AS (
	SELECT c0.StockGroupName, c0.[Year], ISNULL(c1.Quantity, 0) AS Quantity
	FROM cte0 c0
		LEFT JOIN cte1 c1 ON c0.[Year] = c1.[Year]
							AND c0.StockGroupName = c1.StockGroupName
	)

	SELECT StockGroupName, [2013], [2014], [2015], [2016], [2017]
	FROM cte2
	PIVOT
		(
			MIN(Quantity) FOR 
			Year IN ([2013], [2014], [2015], [2016], [2017])
		) TBL
