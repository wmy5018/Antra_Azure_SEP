---For merging Logon and Person information into WorldWideImporters database, 
---these two parts of information can be merged into only one table called Application.People. 
---Firstly, in order to make sure the data integrity of primary key constraint, 
---We need to DECLARE a variable called @maxid that stores the maximum PersonID and then add this maximum value to the BussinessEntityID. 
---This operation makes sure that we will not violate the primary key constraint. 
---Since names in Adventure Works database are split into first names and last names, we need to combine first and last name together to make sure we can match it to Application.People. 
---For IsPermittedToLogon, IsExternalLogonProvider and IsSystemUser information that is not allowed to be NULL and can not be found in Adventures Works database, we set all to 0. For PassWordHash information, we convert it to VARBINARY data type to match it to main database. 
---For IsEmployee and IsSalesperson information, we use two LEFT JOIN operation to check whether it is 1 or 0. Because some PhoneNumber information has different data structures, we use SUBSTRING function to extract same part. 










DECLARE @maxid INT;
DECLARE @col NVARCHAR(MAX) = '';
DECLARE @query NVARCHAR(MAX);

SELECT @maxid = MAX(personID)
FROM Application.People

SELECT p.BusinessEntityID + @maxid AS PersonID, 
p.FirstName + ' ' + p.LastName AS FullName, p.FirstName AS PreferredName, 
0 AS IsPermittedToLogon, e.EmailAddress AS LogonName, 
0 AS IsExternalLogonProvider, CONVERT(VARBINARY, pa.PasswordHash) AS HashedPassword,
0 AS IsSystemUser, 
CASE WHEN em.BusinessEntityID IS NOT NULL THEN 1 ELSE 0 END AS IsEmployee,
	CASE WHEN s.BusinessEntityID IS NOT NULL THEN 1 ELSE 0 END AS IsSalesperson,
	'(' + LEFT(RIGHT(ph.PhoneNumber, 12), 3) + ') ' + RIGHT(ph.PhoneNumber, 8) AS PhoneNumber,
	e.EmailAddress AS EmailAddress, 1 AS LastEditedBy
INTO #person
FROM AdventureWorks2019.Person.Person p
	JOIN AdventureWorks2019.Person.EmailAddress e ON p.BusinessEntityID = e.BusinessEntityID
	JOIN AdventureWorks2019.Person.[Password] pa ON p.BusinessEntityID = pa.BusinessEntityID
	LEFT JOIN AdventureWorks2019.HumanResources.Employee em ON p.BusinessEntityID = em.BusinessEntityID
	LEFT JOIN AdventureWorks2019.Sales.SalesPerson s ON p.BusinessEntityID = s.BusinessEntityID
	JOIN AdventureWorks2019.Person.PersonPhone ph ON p.BusinessEntityID = ph.BusinessEntityID

SELECT @col = @col + name +','
FROM tempdb.sys.columns
WHERE OBJECT_ID = OBJECT_ID('tempdb..#person')

SET @col = SUBSTRING(@col, 0, LEN(@col))

SET @query = 'INSERT INTO Application.People (' + @col +')
				SELECT *
				FROM #person'

EXEC(@query)
