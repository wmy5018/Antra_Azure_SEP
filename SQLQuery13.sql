WITH cte0 AS (
	SELECT s.StockGroupID, SUM(p.OrderedOuters) AS PurchaseQuantity
	FROM Purchasing.PurchaseOrderLines p
		JOIN Warehouse.StockItemStockGroups s ON p.StockItemID = s.StockItemID
	GROUP BY s.StockGroupID
),

cte1 AS (
	SELECT s.StockGroupID, SUM(o.Quantity) AS SaleQuantity
	FROM Sales.OrderLines o
		JOIN Warehouse.StockItemStockGroups s ON o.StockItemID = s.StockItemID
	GROUP BY s.StockGroupID)

SELECT s.StockGroupName, ISNULL(c0.PurchaseQuantity, 0) AS PurchaseQuantity, ISNULL(c1.SaleQuantity, 0) AS SaleQuantity,
	ISNULL(c0.PurchaseQuantity, 0) - ISNULL(c1.SaleQuantity, 0) AS RemainingQuantity
FROM Warehouse.StockGroups s
	LEFT JOIN cte0 c0 ON s.StockGroupID = c0.StockGroupID
	LEFT JOIN cte1 c1 ON s.StockGroupID = c1.StockGroupID
