
/*Q1- Retrieve information about the products with colours that are not null and not silver nor black nor white
and list price is between £75 and £750. Rename the column StandardCost as Price. Finally, please sort
the results by list price in descending order**/

SELECT *
	,[StandardCost] [Price]
	FROM
	[Production].[Product]

WHERE [Color] IS NOT NULL 
	AND [Color] NOT IN ('Silver','Black', 'Red', 'White')
	AND [ListPrice] BETWEEN 75 AND 750

ORDER BY [ListPrice] DESC                        



/*Q2- Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 and
female employees born between 1972 and 1975 and hire date between 2001 and 2002.*/

SELECT *
	,YEAR ([BirthDate]) BirthYear
	,YEAR ([HireDate]) HireYear

FROM [HumanResources].[Employee]

WHERE [Gender] = 'M' AND 
	YEAR ([BirthDate]) BETWEEN 1962 AND 1970 AND
	YEAR ([HireDate]) > 2001                       ---19 ROWS


SELECT *
	,YEAR ([BirthDate]) BirthYear
	,YEAR ([HireDate]) HireYear

FROM [HumanResources].[Employee]

WHERE [Gender] = 'F' AND 
	YEAR ([BirthDate]) BETWEEN 1972 AND 1975 AND 
	YEAR ([HireDate]) BETWEEN 2001 AND 2002      ----0 ROWS



SELECT *
	,YEAR ([BirthDate]) BirthYear
	,YEAR ([HireDate]) HireYear

FROM [HumanResources].[Employee]

WHERE [Gender] = 'M' AND 
	YEAR ([BirthDate]) BETWEEN 1962 AND 1970 AND
	YEAR ([HireDate]) > 2001   


	OR [Gender] = 'F' AND 
	YEAR ([BirthDate]) BETWEEN 1972 AND 1975 AND
	YEAR ([HireDate]) BETWEEN 2001 AND 2002      ----19 ROWS



/*Q3 Create a list of 10 most expensive products that have a product number beginning with ‘BK’. Include
only the product ID, Name and colour.*/

SELECT TOP 10
	[ProductID]
	,[Name]
	,[Color]

FROM [Production].[Product]

WHERE [ProductNumber] LIKE 'BK%'

ORDER BY [ListPrice] DESC        ---10 ROWS



/*Q4 First create a list of all the contact people where the first 4 characters of their last name are equal to the
first 4 characters of their email address. Second find all the contact people whose first name and the last name begin with the same character,
create a new column called full name combining their first name and their last name. Finally add a
column with the length of the full name.*/

--1
SELECT [FirstName]
	, [LastName]
	, PE.EmailAddress

FROM [Person].[Person] PP

	INNER JOIN [Person].[EmailAddress] PE
	ON PP.BusinessEntityID = PE.BusinessEntityID

WHERE LEFT ([LastName], 4) = LEFT([EmailAddress], 4)


--2
SELECT CONCAT ([FirstName], ' ', [LastName]) [Full Name]
	, LEN (CONCAT ([FirstName], ' ', [LastName])) FullName_Lenght

FROM [Person].[Person]

WHERE LEFT([FirstName], 1) = LEFT([LastName], 1)



/*Q5 Return all product subcategories that take an average of 3 days or longer to manufacture.*/

SELECT PP.ProductSubcategoryID
	,PPS.Name
	,PP.DaysToManufacture
	,AVG ([DaysToManufacture]) AvgManufactureDays

FROM [Production].[Product] PP

	INNER JOIN [Production].[ProductSubcategory] PPS 
	ON PP.ProductSubcategoryID = PPS.ProductCategoryID

GROUP BY PP.DaysToManufacture
	,PP.ProductSubcategoryID
	,PPS.Name

HAVING AVG ([DaysToManufacture]) >=3     ---25 ROWS



/*Q6 Create a price segmentation for products by defining a criteria that places each item in a segment as
follows: If price is less than £200 then it’s low value. 
If price is between £201 and £750 then it is mid value.
If price is between £751 and £1250 then it is mid to high value. 
All else is higher value. Filter the
results only for products that are black, silver and red (colour).*/

SELECT[ProductID]
	,[Name]
	,[Color]
	,[ListPrice]

,CASE
	WHEN[ListPrice] < 200 THEN 'low value'
	WHEN [ListPrice] BETWEEN 201 AND 750 THEN 'mid value'
	WHEN [ListPrice] BETWEEN 751 AND 1250 THEN 'mid to high value'

	ELSE 'higher value'

	END AS Price_Segmentation

FROM [Production].[Product]

WHERE [Color] = 'Black' OR 
	[Color] = 'Silver' OR 
	[Color] = 'Red'                ----174 ROWS



/*Q7 How many distinct job titles are there in the Employee table.*/

SELECT COUNT (DISTINCT [JobTitle]) DistinctJobTitles

FROM [HumanResources].[Employee] -----67



/*Q8 Use the Employee table and calculate the ages of each employee at the time of hiring.*/

SELECT [BusinessEntityID]
	,[JobTitle]
	,[HireDate]
	,DATEDIFF (YY,[BirthDate],[HireDate]) AgeAtHireTime

FROM [HumanResources].[Employee]



/*Q9 How many employees will be due a Long Service Award 
in the next 5 years, if long service is 20 years?*/

SELECT HRE.[BusinessEntityID]
	, CONCAT ([FirstName], ' ', [LastName]) [Full Name]
	, [JobTitle]
	, [HireDate] 
	, DATEDIFF (YY, HRE.[HireDate], (DATEADD(YY, 5, GETDATE()))) LongYearsService

FROM [HumanResources].[Employee] HRE
	JOIN [Person].[Person] PP
	ON HRE.BusinessEntityID = PP.BusinessEntityID

WHERE (PP.PersonType = 'EM' OR PP.PersonType = 'SP') AND
    DATEDIFF (YY, HRE.[HireDate], (DATEADD(YY, 5, GETDATE()))) >= 20

ORDER BY DATEDIFF (YY, HRE.[HireDate], (DATEADD(YY, 5, GETDATE()))) ASC


/*Q10 How many more years does each employee have to work before
reaching retirement, if the retirement age is 65?*/

SELECT HRE.BusinessEntityID
	, CONCAT (PP.[FirstName],' ',[LastName]) EmployeeName
	, DATEDIFF (YY, [BirthDate], GETDATE()) Age
	,  DATEDIFF (YY, [BirthDate], GETDATE())-65 YearsToRetirement

FROM [HumanResources].[Employee] HRE

	INNER JOIN [Person].[Person] PP
	ON PP.BusinessEntityID = HRE.BusinessEntityID

WHERE PP.PersonType = 'EM' AND
	DATEDIFF (YY, [BirthDate], GETDATE())-65 >0

ORDER BY DATEDIFF (YY, [BirthDate], GETDATE())-65 DESC


/*Q11 Implement a new pricing policy on the product table based on the colour of the item
Create a column called Newprice with the following values: If the colour is white please increase
the price by 8%, If yellow reduce the price by 7.5%, If black increase the price by 17.2%.
If multi, silver, silver/black or blue take the square root of the price and double that value.
For each item, calculate a commission of 37.5% of new prices.*/

WITH CTE_Npc  AS

	(SELECT [Name]
	, [Color]
	, [ListPrice]

		, CASE 
		WHEN [Color] = 'White' THEN [ListPrice] * 1.08
		WHEN [Color] = 'Yellow' THEN [ListPrice] * 0.925 
		WHEN [Color] = 'Black' THEN [ListPrice] * 1.172
		WHEN [Color] IN ('Multi', 'Silver', 'Silver/Black',  'Blue')  THEN SQRT ([ListPrice]) *2

		ELSE [ListPrice]
		END AS NewPrice

		, CASE
		WHEN [Color] = 'White' THEN ([ListPrice] * 1.08) *0.375
		WHEN [Color] = 'Yellow' THEN ([ListPrice] * 0.925) *0.375
		WHEN [Color] = 'Black' THEN ([ListPrice] * 1.172) *0.375
		WHEN [Color] IN ('Multi', 'Silver', 'Silver/Black',  'Blue')  THEN (SQRT ([ListPrice]) *2) *0.375

		ELSE [ListPrice]
		END AS Commission

	FROM [Production].[Product])

SELECT [Name], [Color], [ListPrice], Newprice, Commission

FROM CTE_Npc



/*Q12 Print the information about all the Sales.Person and their sales quota. For every Sales person you
should provide their FirstName, LastName, HireDate, SickLeaveHours and Region where they work.*/

SELECT PP.FirstName
	, PP.LastName
	, SSP.SalesQuota
	, HRE.HireDate
	, HRE.SickLeaveHours
	, PCR.Name Region


FROM [Sales].[SalesPerson] SSP

	INNER JOIN [Person].[Person] PP
	ON SSP.BusinessEntityID = PP.BusinessEntityID

	INNER JOIN [HumanResources].[Employee] HRE
	ON HRE.BusinessEntityID = PP.BusinessEntityID


	INNER JOIN [Person].[BusinessEntity] PBE
	ON PBE.BusinessEntityID = PP.BusinessEntityID

	INNER JOIN [Person].[BusinessEntityAddress] PBEA
	ON PBEA.BusinessEntityID = PBE.BusinessEntityID

	INNER JOIN [Person].[Address] PA
	ON PA.AddressID = PBEA.AddressID

	INNER JOIN [Person].[StateProvince] PSP
	ON PSP.StateProvinceID = PA.StateProvinceID

	INNER JOIN [Person].[CountryRegion] PCR
	ON PCR.CountryRegionCode = PSP.CountryRegionCode

WHERE PP.PersonType = 'SP'



/*Q13 Using adventure works, write a query to extract the following information.
• Product name
• Product category name
• Product subcategory name
• Sales person
• Revenue
• Month of transaction
• Quarter of transaction
• Region*/


SELECT PP.Name Product_Name
	, PC.Name Product_catName
	, PSC.Name Product_SubcatName
	, CONCAT (PPR.[FirstName], ' ', PPR.[LastName]) Sales_Person
	, SOD.[LineTotal] Revenue
	, DATENAME (MM, SOH.[OrderDate]) TransactionMonth
	, DATEPART (QQ, SOH.[OrderDate]) TransactionQuarter
	, PCR.[Name] Region 


FROM [Sales].[SalesOrderHeader] SOH

	INNER JOIN [Sales].[SalesOrderDetail] SOD
	ON SOH.SalesOrderID = SOD.SalesOrderID

	INNER JOIN [Production].[Product] PP
	ON PP.ProductID = SOD.ProductID

	LEFT JOIN [Production].[ProductSubcategory] PSC
	ON PSC.ProductSubcategoryID = PP.ProductSubcategoryID

	LEFT JOIN [Production].[ProductCategory] PC
	ON PC.ProductCategoryID = PSC.ProductCategoryID

	INNER JOIN [Sales].[SalesPerson] SSP
	ON SSP.BusinessEntityID = SOH.SalesPersonID

	INNER JOIN [Person].[Person] PPR
	ON PPR.BusinessEntityID = SSP.BusinessEntityID

	INNER JOIN [Sales].[SalesTerritory]  SST
	ON SST.TerritoryID = SOH.TerritoryID

	INNER JOIN [Person].[CountryRegion] PCR
	ON PCR.CountryRegionCode = SST.CountryRegionCode


/*Q14 Display the information about the details of an order i.e. order number, order date, amount of order,
which customer gives the order and which salesman works for that customer and how much
commission he gets for an order.*/

SELECT SP.BusinessEntityID
	, CONCAT (PP.[FirstName], ' ', PP.[LastName]) SalesPerson
	, SC.[CustomerID]
	, SOH.[OnlineOrderFlag]
	, ss.Name StoreName
	, SOH.[SalesOrderID]
	, CAST (SOH.[OrderDate] AS DATE) Date
	, SUM (0.375*[TotalDue]) Commission

FROM [Sales].[SalesOrderHeader] SOH

	LEFT JOIN [Sales].[Customer] SC
	ON SC.CustomerID = SOH.CustomerID

	LEFT JOIN [Sales].[Store] SS
	ON SC.StoreID = SS.BusinessEntityID

	LEFT JOIN [Sales].[SalesPerson] SP
	ON SP.BusinessEntityID = SS.SalesPersonID

	LEFT JOIN [Person].[Person] PP
	ON PP.BusinessEntityID = SP.BusinessEntityID

GROUP BY SP.BusinessEntityID
	, CONCAT (PP.[FirstName], ' ', PP.[LastName]) 
	, SC.[CustomerID]
	, SOH.[OnlineOrderFlag]
	, ss.Name 
	, SOH.[SalesOrderID]
	, CAST (SOH.[OrderDate] AS DATE) 



/*Q15 For all the products calculate
• Commission as 14.790% of standard cost,
• Margin, if standard cost is increased or decreased as follows:
- Black: +22%,
- Red: -12%
- Silver: +15%
- Multi: +5%
- White: Two times original cost divided by the square root of cost
- For other colors, standard cost remains the same.*/


SELECT [Name]
	, [Color]
	, [StandardCost]
	, [ListPrice]
	, SUM ([StandardCost] *0.14790) Commission
	

		, CASE 
		WHEN [Color] = 'Black' THEN [ListPrice]- ([StandardCost] *1.22)
		WHEN [Color] = 'Red' THEN [ListPrice]- ([StandardCost] *0.88)
		WHEN [Color] = 'Silver' THEN [ListPrice]- ([StandardCost] *1.15)
		WHEN [Color] = 'Multi' THEN [ListPrice]- ([StandardCost] *0.95)
		WHEN [Color] = 'White' THEN (2 * [StandardCost]) / SQRT([StandardCost])
		
		ELSE [StandardCost]
		END AS Margin 

FROM [Production].[Product]

GROUP BY [Name]
	, [Color]
	, [StandardCost]
	, [ListPrice]



/*Q16 Create a view to find out the top 5 most expensive products for each colour*/

CREATE VIEW Production.TopExpensive AS

	SELECT TOP (5) *

	FROM [Production].[Product]

	ORDER BY [ListPrice] DESC

----
SELECT *

FROM [Production].[TopExpensive]



