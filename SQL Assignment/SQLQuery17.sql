---Solution1
SELECT 
	JSON_VALUE(s.CustomFields, '$.CountryOfManufacture') AS Country, 
	SUM(ol.Quantity) AS Quantity
FROM sales.Orders o
	JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
	JOIN Warehouse.StockItems s ON ol.StockItemID = s.StockItemID
WHERE YEAR(o.OrderDate) = 2015
GROUP BY JSON_VALUE(s.CustomFields, '$.CountryOfManufacture')


---Solution2, Quantity of China is different
SELECT
	Country,
	SUM(pq) AS Quantity
FROM
(
SELECT
	ol.PickedQuantity AS pq,
	JSON_VALUE(CustomFields,'$.CountryOfManufacture') AS Country
FROM 
	Sales.OrderLines AS ol
JOIN 
	Warehouse.StockItems AS s
ON ol.StockItemID = s.StockItemID
JOIN Sales.Orders AS o
ON o.OrderID = ol.OrderID AND YEAR(o.OrderDate) = 2015
)TEMP 
GROUP BY Country
