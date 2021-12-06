--27.	Create a new table called ods.ConfirmedDeviveryJson with 3 columns (id, date, value) . 
--Create a stored procedure, input is a date. 
--The logic would load invoice information (all columns) 
--as well as invoice line information (all columns) and forge them 
--into a JSON string and then insert into the new table just created. 
--Then write a query to run the stored procedure for each DATE 
--that customer id 1 got something delivered to him.


CREATE TABLE ods.ConfirmedDeviveryJson 
	(ID INT PRIMARY KEY,
	Date DATE,
	Value NVARCHAR(MAX))

GO

CREATE PROCEDURE ods.InsertInvoicesOfDate
	@Date DATE
AS
BEGIN 
DECLARE @i NVARCHAR(MAX) = '';
DECLARE @oi NVARCHAR(MAX) = '';
DECLARE @column NVARCHAR(MAX);
DECLARE @query NVARCHAR(MAX);
DECLARE @json NVARCHAR(MAX);


SELECT @i =  @i + 'i.' + COLUMN_NAME + ', '
FROM (SELECT COLUMN_NAME
	FROM(
		SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = N'Invoices') a
		WHERE COLUMN_NAME != 'InvoiceDate'
	) b

SELECT @oi = @oi + 'oi.' + COLUMN_NAME + ', '
FROM (
	SELECT COLUMN_NAME 
	FROM(
		SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'InvoiceLines') a
		WHERE COLUMN_NAME NOT IN ('InvoiceID', 'LastEditedBy', 'LastEditedWhen')
	) b

SET @column = @i + SUBSTRING(@oi, 0, LEN(@oi))

SET @query = 'SET @json = (SELECT ID = oi1.InvoiceLineID, Date = i1.InvoiceDate,
					Value = (
						SELECT ' + @column + '
						FROM Sales.Invoices i
				JOIN Sales.InvoiceLines oi ON i.InvoiceID = oi.InvoiceID
						WHERE oi.InvoiceLineID = oi1.InvoiceLineID
					FOR JSON PATH, ROOT(''Value''), INCLUDE_NULL_VALUES)
					FROM Sales.Invoices i1
				JOIN Sales.InvoiceLines oi1 ON i1.InvoiceID = oi1.InvoiceID
					WHERE i1.InvoiceDate = @Date
					FOR JSON PATH, INCLUDE_NULL_VALUES)'


EXEC SP_EXECUTESQL @query, N'@Date DATE, @json NVARCHAR(MAX) OUT', @Date, @json OUT



INSERT INTO ods.ConfirmedDeviveryJson 
SELECT *
FROM OPENJSON(@json)
WITH(
	ID INT '$.ID',
	Date DATE '$.Date',
	Value NVARCHAR(MAX) '$.Value' AS JSON)
END

GO

DECLARE @loop NVARCHAR(MAX) = ''
SELECT @loop = @loop + N'EXEC ods.InsertInvoicesOfDate ''' + CAST(InvoiceDate AS NVARCHAR)+ '''; '
FROM (SELECT DISTINCT InvoiceDate
	FROM Sales.Invoices
	WHERE CustomerID = 1) a

EXEC SP_EXECUTESQL @loop
