SELECT 
     Stock.StockItemName,
	 COUNT(Stock.StockItemName) AS Quantity
FROM 
	Purchasing.PurchaseOrders AS P
JOIN 
	Purchasing.PurchaseOrderLines AS PL
ON PL.PurchaseOrderID = P.PurchaseOrderID 
JOIN 
	Warehouse.StockItems_Archive AS Stock
ON PL.StockItemID = Stock.StockItemID
--WHERE P.OrderDate BETWEEN '2013-01-01' AND '2013-12-31'
WHERE YEAR(P.OrderDate) ='2013'

GROUP BY Stock.StockItemName