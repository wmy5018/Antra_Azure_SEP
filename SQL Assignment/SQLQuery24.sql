--24.	Consider the JSON file:
--Looks like that it is our missed purchase orders. 
--Migrate these data into Stock Item, Purchase Order and Purchase Order Lines tables.
--Of course, save the script.

DECLARE @json NVARCHAR(MAX) = N'{
   "PurchaseOrders":[
      {
         "StockItemName":"Panzer Video Game",
         "Supplier":"7",
         "UnitPackageId":"1",
         "OuterPackageId":[
            6,
            7
         ],
         "Brand":"EA Sports",
         "LeadTimeDays":"5",
         "QuantityPerOuter":"1",
         "TaxRate":"6",
         "UnitPrice":"59.99",
         "RecommendedRetailPrice":"69.99",
         "TypicalWeightPerUnit":"0.5",
         "CountryOfManufacture":"Canada",
         "Range":"Adult",
         "OrderDate":"2018-01-01",
         "DeliveryMethod":"Post",
         "ExpectedDeliveryDate":"2018-02-02",
         "SupplierReference":"WWI2308"
      },
      {
         "StockItemName":"Panzer Video Game",
         "Supplier":"5",
         "UnitPackageId":"1",
         "OuterPackageId":"7",
         "Brand":"EA Sports",
         "LeadTimeDays":"5",
         "QuantityPerOuter":"1",
         "TaxRate":"6",
         "UnitPrice":"59.99",
         "RecommendedRetailPrice":"69.99",
         "TypicalWeightPerUnit":"0.5",
         "CountryOfManufacture":"Canada",
         "Range":"Adult",
         "OrderDate":"2018-01-025",
         "DeliveryMethod":"Post",
         "ExpectedDeliveryDate":"2018-02-02",
         "SupplierReference":"269622390"
      }
   ]
}'


WITH cte AS (
(SELECT *
FROM OPENJSON(@json, '$.PurchaseOrders')
WITH (
	StockItemName NVARCHAR(50),
	Supplier INT,
	UnitPackageId INT,
	OuterPackageId NVARCHAR(MAX) AS JSON,
	Brand NVARCHAR(20),
	LeadTimeDays INT,
	QuantityPerOuter INT,
	TaxRate DECIMAL(18, 3),
	UnitPrice DECIMAL(18, 2),
	RecommendedRetailPrice DECIMAL(18, 2),
	TypicalWeightPerUnit DECIMAL(18, 3),
	CountryOfManufacture NVARCHAR(50),
	Range NVARCHAR(20),
	OrderDate NVARCHAR(20),
	DeliveryMethod NVARCHAR(20),
	ExpectedDeliveryDate NVARCHAR(20),
	SupplierReference NVARCHAR(20)
	)
	CROSS APPLY OPENJSON(OuterPackageId) WITH (NewOuterPackageId INT '$') 
	)
	
	UNION ALL

	(SELECT *
	FROM OPENJSON(@json, '$.PurchaseOrders')
	WITH (

	StockItemName NVARCHAR(50),
	Supplier INT,
	UnitPackageId INT,
	OuterPackageId NVARCHAR(MAX),
	Brand NVARCHAR(20),
	LeadTimeDays INT,
	QuantityPerOuter INT,
	TaxRate DECIMAL(18, 3),
	UnitPrice DECIMAL(18, 2),
	RecommendedRetailPrice DECIMAL(18, 2),
	TypicalWeightPerUnit DECIMAL(18, 3),
	CountryOfManufacture NVARCHAR(50),
	Range NVARCHAR(20),
	OrderDate NVARCHAR(20),
	DeliveryMethod NVARCHAR(20),
	ExpectedDeliveryDate NVARCHAR(20),
	SupplierReference NVARCHAR(20),
	OuterPackageId INT
		)
	)
)

DECLARE @maxid INT = (SELECT MAX(StockItemID)
						FROM Warehouse.StockItems);

SELECT IDENTITY(INT, 1, 1) AS StockItemId, * INTO #stock
FROM cte WHERE OuterPackageId is NOT NULL

INSERT INTO Warehouse.StockItems (StockItemID, StockItemName, SupplierID, UnitPackageId, OuterPackageId, Brand, LeadTimeDays, QuantityPerOuter, IsChillerStock, TaxRate, UnitPrice, RecommendedRetailPrice, TypicalWeightPerUnit, LastEditedBy)
SELECT StockItemId + @maxid, StockItemName + '(' + CAST(StockItemID AS NVARCHAR) + ')' , Supplier, UnitPackageId, NewOuterPackageId, Brand, LeadTimeDays, QuantityPerOuter, 0, TaxRate, UnitPrice, RecommendedRetailPrice, TypicalWeightPerUnit, 1
FROM #stock
