--26.	Revisit your answer in (19).
--Convert the result into an XML string and save it to the server using TSQL FOR XML PATH.


SELECT Year AS '@Year',
	[Novelty Items] AS NoveltyItems,
	[Clothing], 
	[Mugs],
	[T-Shirts],
	[Airline Novelties] AS AirlineNovelties, 
	[Computing Novelties] AS ComputingNovelties, 
	[USB Novelties] AS USBNovelties, 
	[Furry Footwear] AS FurryFootwear, 
	[Toys], 
	[Packaging Materials] AS PackagingMaterials
FROM Sales.StockItemByName 
FOR XML PATH('StockItems')


???
