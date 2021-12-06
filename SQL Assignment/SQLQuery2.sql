SELECT CustomerName AS CompanyName
FROM Sales.Customers c
	JOIN Application.People p ON c.PrimaryContactPersonID = p.PersonID 
						AND c.PhoneNumber = p.PhoneNumber
