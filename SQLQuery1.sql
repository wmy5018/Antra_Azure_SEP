--1.List of Persons¡¯ full name, all their fax and phone numbers, 
-- as well as the phone number and fax of the company they are working for (if any). 
USE WideWorldImporters
GO

SELECT 
	FullName, 
	p.FaxNumber,
	p.PhoneNumber, 
	CustomerName AS CompanyName
FROM Application.People p LEFT JOIN Sales.Customers c
ON p.PersonID = c.PrimaryContactPersonID 
					OR p.PersonID = c.AlternateContactPersonID