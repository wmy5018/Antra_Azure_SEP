---25. Revisit your answer in (19). 
---Convert the result in JSON string 
---and save it to the server using TSQL FOR JSON PATH.

SELECT Year AS Year,
	[Novelty Items] AS 'StockGroup.Novelty Items',
	[Clothing] AS 'StockGroup.Clothing', 
	[Mugs] AS 'StockGroup.Mugs',
	[T-Shirts] AS 'StockGroup.T-Shirts',
	[Airline Novelties] AS 'StockGroup.Airline Novelties', 
	[Computing Novelties] AS 'StockGroup.Computing Novelties', 
	[USB Novelties] AS 'StockGroup.USB Novelties', 
	[Furry Footwear] AS 'StockGroup.Furry Footwear', 
	[Toys] AS 'StockGroup.Toys', 
	[Packaging Materials] AS 'StockGroup.Packaging Materials'
FROM Sales.StockItemByName 
FOR JSON PATH

