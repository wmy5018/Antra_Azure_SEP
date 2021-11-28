CREATE TABLE ods.StockItems(
	StockItemID INT PRIMARY KEY,
	StockItemName NVARCHAR(100) NOT NULL,
	SupplierID INT NOT NULL,
	ColorID INT NULL,
	UnitPackageID INT NOT NULL,
	OuterPackageID INT NOT NULL,
	Brand NVARCHAR(50) NULL,
	Size NVARCHAR(20) NULL,
	LeadTimeDays INT NOT NULL,
	QuantityPerOuter INT NOT NULL,
	IsChillerStock BIT NOT NULL,
	Barcode NVARCHAR(50) NULL,
	TaxRate DECIMAL(18, 3) NOT NULL,
	UnitPrice DECIMAL(18, 2) NOT NULL,
	RecommendedRetailPrice DECIMAL(18, 2) NULL,
	TypicalWeightPerUnit DECIMAL(18, 3) NOT NULL,
	MarketingComments NVARCHAR(MAX) NULL,
	InternalComments NVARCHAR(MAX) NULL,
	CountryOfManufacture NVARCHAR(20) NULL,
	[Range] NVARCHAR(20) NULL,
	Shelflife NVARCHAR(20) NULL
)

MERGE INTO ods.StockItems AS T
USING Warehouse.StockItems AS R
ON T.StockItemID = R.StockItemID
WHEN NOT MATCHED 
THEN INSERT VALUES (R.StockItemID, R.StockItemName, R.SupplierID, R.ColorID, 
		R.UnitPackageID, R.OuterPackageID, R.Brand, R.Size, R.LeadTimeDays, 
		R.QuantityPerOuter, R.IsChillerStock, R.Barcode, R.TaxRate, R.UnitPrice,
		R.RecommendedRetailPrice, R.TypicalWeightPerUnit, R.MarketingComments,
		R.InternalComments, JSON_VALUE(R.CustomFields, '$.CountryOfManufacture'),
		JSON_VALUE(R.CustomFields, '$.Range'), JSON_VALUE(R.CustomFields, '$.ShelfLife'));
