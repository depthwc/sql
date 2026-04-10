
-- Chapter 1 Background to T-SQL Querying and Programming --

USE TSQL2012;
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
	DROP TABLE dbo.Employees;
CREATE TABLE dbo.Employees
(
 empid INT NOT NULL,
 firstname VARCHAR(30) NOT NULL,
 lastname VARCHAR(30) NOT NULL,
 hiredate DATE NOT NULL,
 mgrid INT NULL,
 ssn VARCHAR(20) NOT NULL,
 salary MONEY NOT NULL
);




ALTER TABLE dbo.Employees
	ADD CONSTRAINT PK_Employees
	PRIMARY KEY(empid);


 ALTER TABLE dbo.Employees
	ADD CONSTRAINT UNQ_Employees_ssn
	UNIQUE(ssn);


IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL
	DROP TABLE dbo.Orders;
CREATE TABLE dbo.Orders
(
 orderid INT NOT NULL,
 empid INT NOT NULL,
 custid VARCHAR(10) NOT NULL,
 orderts DATETIME2 NOT NULL,
 qty INT NOT NULL,
 CONSTRAINT PK_Orders
 PRIMARY KEY(orderid),
 CONSTRAINT FK_Orders_Employees FOREIGN KEY(empid) REFERENCES dbo.Employees(empid)
);


ALTER TABLE dbo.Orders
	ADD CONSTRAINT FK_Orders_Employees
	FOREIGN KEY(empid)
	REFERENCES dbo.Employees(empid);



ALTER TABLE dbo.Employees
	ADD CONSTRAINT FK_Employees_Employees
	FOREIGN KEY(mgrid)
	REFERENCES dbo.Employees(empid);

ALTER TABLE dbo.Employees
	ADD CONSTRAINT CHK_Employees_salary
	CHECK(salary > 0.00);

ALTER TABLE dbo.Orders
	ADD CONSTRAINT DFT_Orders_orderts
	DEFAULT(SYSDATETIME()) FOR orderts;


DROP TABLE dbo.Orders, dbo.Employees;


-- Chapter 2 Single-Table Queries -- 


SELECT * from Sales.Orders

USE TSQL2012;
SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear;



SELECT
 empid,
 YEAR(orderdate) AS orderyear,
 COUNT(DISTINCT custid) AS numcusts
FROM Sales.Orders
GROUP BY empid, YEAR(orderdate);


SELECT DISTINCT country,empid
FROM HR.Employees
ORDER BY empid;


SELECT TOP (5) percent orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

SELECT TOP (5) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;


SELECT TOP (5) WITH TIES orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;


SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate, orderid
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;


SELECT orderid, custid, val,
	ROW_NUMBER() OVER(PARTITION BY custid
	ORDER BY val) AS rownum
FROM Sales.OrderValues
ORDER BY custid, val;


SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderid IN(10248, 10249, 10250);

SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderid BETWEEN 10300 AND 10310;


SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE N'D%';


SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20080101';

SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20080101'
 AND empid IN(1, 3, 5);


SELECT orderid, productid, qty, unitprice, discount,
	qty * unitprice * (1 - discount) AS val
FROM Sales.OrderDetails;


SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE
	custid = 1
	AND empid IN(1, 3, 5)
	OR custid = 85
	AND empid IN(2, 4, 6);


SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE
	(custid = 1
	AND empid IN(1, 3, 5))
	OR
	(custid = 85
	AND empid IN(2, 4, 6));


SELECT productid, productname, categoryid,
	CASE categoryid
		WHEN 1 THEN 'Beverages'
		WHEN 2 THEN 'Condiments'
		WHEN 3 THEN 'Confections'
		WHEN 4 THEN 'Dairy Products'
		WHEN 5 THEN 'Grains/Cereals'
		WHEN 6 THEN 'Meat/Poultry'
		WHEN 7 THEN 'Produce'
		WHEN 8 THEN 'Seafood'
		ELSE 'Unknown Category'
	END AS categoryname
FROM Production.Products;



SELECT orderid, custid, val,
	CASE
		WHEN val < 1000.00 THEN 'Less than 1000'
		WHEN val BETWEEN 1000.00 AND 3000.00 THEN 'Between 1000 and 3000'
		WHEN val > 3000.00 THEN 'More than 3000'
		ELSE 'Unknown'
	END AS valuecategory
FROM Sales.OrderValues;


SELECT custid, country, region, city
FROM Sales.Customers
WHERE region = N'WA';

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region <> N'WA';

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region = NULL;

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region is Null;

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region <> N'WA'
 OR region IS NULL;

 SELECT
	orderid,
	YEAR(orderdate) AS orderyear,
	orderyear + 1 AS nextyear
FROM Sales.Orders;


SELECT col1, col2
FROM dbo.T1
WHERE
	CASE
	WHEN col1 = 0 THEN 'no' -- or 'yes' if row should be returned
	WHEN col2/col1 > 2 THEN 'yes'
	ELSE 'no'
 END = 'yes';


SELECT empid, firstname + N' ' + lastname AS fullname
FROM HR.Employees;

SELECT custid, country, region, city,
 country + N',' + region + N',' + city AS location
FROM Sales.Customers;


-- functions

SELECT custid, country, region, city,
	country + COALESCE( N',' + region, N'') + N',' + city AS location
FROM Sales.Customers;

SELECT custid, country, region, city,
	CONCAT(country, N',' + region, N',' + city) AS location
FROM Sales.Customers;

SELECT SUBSTRING('abcde', 2, 3);

SELECT RIGHT('abcde', 3);

SELECT LEFT('abcde', 3);

SELECT LEN(N'abcde');

SELECT DATALENGTH(N'abcde');
SELECT DATALENGTH('abcde');

SELECT CHARINDEX(' ','Itzik Ben-Gan ',7);

SELECT PATINDEX('%[0-4]%', 'abcd123efgh');

SELECT REPLACE('1-a 2-b', '-', ':');

SELECT empid, lastname,
	LEN(lastname) - LEN(REPLACE(lastname, 'e', '')) AS numoccur
FROM HR.Employees;

SELECT REPLICATE('abc', 3);

SELECT supplierid,
	RIGHT(REPLICATE('0', 9) + CAST(supplierid AS VARCHAR(10)), 10) AS strsupplierid
FROM Production.Suppliers;

SELECT STUFF('xyz', 2, 1, 'abc');

SELECT UPPER('Itzik Ben-Gan');

SELECT LOWER('Itzik Ben-Gan');

SELECT RTRIM(LTRIM(' abc '));
SELECT LTRIM(LTRIM(' abc '));

SELECT FORMAT(1759, '000000000');

-- LIKE

SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'D%';

SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'___e%';

SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'[ABC]%';

SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'[A-H]%';


SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'[^A-E]%';


-- datetime

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate = '20070212';

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate = CAST('20070212' AS DATETIME);


SET LANGUAGE British;
SELECT CAST('24/12/2007' AS DATETIME);
SET LANGUAGE us_english;
SELECT CAST('02/24/2007' AS DATETIME);

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate = '20070212';


SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20070212'
 AND orderdate < '20070213';


SELECT
 GETDATE() AS [GETDATE],
 CURRENT_TIMESTAMP AS [CURRENT_TIMESTAMP],
 GETUTCDATE() AS [GETUTCDATE],
 SYSDATETIME() AS [SYSDATETIME],
 SYSUTCDATETIME() AS [SYSUTCDATETIME],
 SYSDATETIMEOFFSET() AS [SYSD]

SELECT
 CAST(SYSDATETIME() AS DATE) AS [current_date],
 CAST(SYSDATETIME() AS TIME) AS [curr]

 SELECT CAST('20090212' AS DATE);

 SELECT CAST(SYSDATETIME() AS DATE);	

 SELECT CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112);

 SELECT CAST(CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS DATETIME);

 SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '-05:00');

 SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '+00:00');

 SELECT DATEADD(year, 1, '20090212');

 SELECT
 DATEADD(
 day,
 DATEDIFF(day, '20010101', CURRENT_TIMESTAMP), '20010101');


 SELECT
 DATEFROMPARTS(2012, 02, 12),
 DATETIME2FROMPARTS(2012, 02, 12, 13, 30, 5, 1, 7),
 DATETIMEFROMPARTS(2012, 02, 12, 13, 30, 5, 997),
 DATETIMEOFFSETFROMPARTS(2012, 02, 12, 13, 30, 5, 1, -8, 0, 7),
 SMALLDATETIMEFROMPARTS(2012, 02, 12, 13, 30),
 TIMEFROMPARTS(13, 30, 5, 1, 7);


 SELECT EOMONTH(SYSDATETIME());

USE TSQL2012;
SELECT SCHEMA_NAME(schema_id) AS table_schema_name, name AS table_name
FROM sys.tables;


SELECT
 name AS column_name,
 TYPE_NAME(system_type_id) AS column_type,
 max_length,
 collation_name,
 is_nullable
FROM sys.columns
WHERE object_id = OBJECT_ID(N'Sales.Orders');


-- System Stored Procedures and Functions

EXEC sys.sp_tables;

EXEC sys.sp_help
 @objname = N'Sales.Orders';

EXEC sys.sp_columns
 @table_name = N'Orders',
 @table_owner = N'Sales';

 EXEC sys.sp_helpconstraint
 @objname = N'Sales.Orders';

 SELECT
 SERVERPROPERTY('ProductLevel');

 SELECT
 DATABASEPROPERTYEX(N'TSQL2012', 'Collation');

 SELECT
 OBJECTPROPERTY(OBJECT_ID(N'Sales.Orders'), 'TableHasPrimaryKey');


seleCT
 COLUMNPROPERTY(OBJECT_ID(N'Sales.Orders'), N'shipcountry', 'AllowsNull');


 -- Chapter 2 exercises

 -- 1

 SELECT * 
 FROM Sales.Orders
 WHERE year(orderdate) = 2007 and month(orderdate) = 6

 -- 2

 SELECT * 
 FROM Sales.Orders
 WHERE day(orderdate) = day(EOMONTH(orderdate))

 -- 3

 SELECT * 
 FROM HR.Employees
 WHERE lastname LIKE '%a%a%'

 -- 4

SELECT orderid, SUM(qty * unitprice) as total
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty * unitprice)> 10000
ORDER BY orderid

-- 5

SELECT TOP(3) shipcountry, AVG(freight) as avgfreight
FROM Sales.Orders
WHERE year(shippeddate) = 2007
GROUP BY shipcountry
ORDER BY avgfreight DESC 

-- 6

SELECT custid, orderdate, orderid, ROW_NUMBER() OVER(partition by custid order by custid) as nvm
FROM Sales.Orders
-- GROUP BY orderid, orderdate,custid
ORDER BY custid

-- 7

SELECT *,
CASE
	WHEN titleofcourtesy = 'Ms.' OR  titleofcourtesy = 'Mrs.' THEN 'Female'
	WHEN titleofcourtesy = 'Mr.' THEN 'Male'
	ELSE 'Unknown'
	END as Gander
FROM HR.Employees

-- 8

SELECT custid, region
FROM Sales.Customers
ORDER BY 
	CASE WHEN region IS NULL then 1 ELSE 0 END, region




-- Chapter 3 Joins -- 

-- cross join

USE TSQL2012;
SELECT C.custid, E.empid
FROM Sales.Customers AS C CROSS JOIN HR.Employees AS E;


SELECT C.custid, E.empid
FROM Sales.Customers AS C, HR.Employees AS E;

SELECT
	E1.empid, E1.firstname, E1.lastname,
	E2.empid, E2.firstname, E2.lastname
FROM HR.Employees AS E1 CROSS JOIN HR.Employees AS E2;


-- inner join

SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E JOIN Sales.Orders AS O ON E.empid = O.empid;


---

USE TSQL2012;
IF OBJECT_ID('Sales.OrderDetailsAudit', 'U') IS NOT NULL
 DROP TABLE Sales.OrderDetailsAudit;
CREATE TABLE Sales.OrderDetailsAudit
(
 lsn INT NOT NULL IDENTITY,
 orderid INT NOT NULL,
 productid INT NOT NULL,
 dt DATETIME NOT NULL,
 loginname sysname NOT NULL,
 columnname sysname NOT NULL,
 oldval SQL_VARIANT,
 newval SQL_VARIANT,
 CONSTRAINT PK_OrderDetailsAudit PRIMARY KEY(lsn),
 CONSTRAINT FK_OrderDetailsAudit_OrderDetails
 FOREIGN KEY(orderid, productid)
 REFERENCES Sales.OrderDetails(orderid, productid)
);

sELECT
 E1.empid, E1.firstname, E1.lastname,
 E2.empid, E2.firstname, E2.lastname
FROM HR.Employees AS E1
 JOIN HR.Employees AS E2
 ON E1.empid < E2.empid;


 SELECT
 C.custid, C.companyname, O.orderid,
 OD.productid, OD.qty
FROM Sales.Customers AS C
 JOIN Sales.Orders AS O
 ON C.custid = O.custid
 JOIN Sales.OrderDetails AS OD
 ON O.orderid = OD.orderid;


 -- outer join


SELECT C.custid, C.companyname, O.orderid
FROM Sales.Customers AS C
 LEFT OUTER JOIN Sales.Orders AS O
 ON C.custid = O.custid;\


 SELECT C.custid, C.companyname
FROM Sales.Customers AS C
 LEFT OUTER JOIN Sales.Orders AS O
 ON C.custid = O.custid
WHERE O.orderid IS NULL;


-- excersises


-- 1

SELECT E.empid, E.firstname, E.lastname, N.n
FROM HR.Employees AS E CROSS JOIN dbo.Nums AS N
WHERE N.n <= 5
ORDER BY n, empid;

-- 1.2

SELECT E.empid, DATEADD(day, D.n - 1, '20090612') AS dt
FROM HR.Employees AS E CROSS JOIN dbo.Nums AS D
WHERE D.n <= DATEDIFF(day, '20090612', '20090616') + 1
ORDER BY empid, dt;

-- 2

SELECT * FROM Sales.Customers
SELECT * FROM Sales.Orders
SELECT * FROM Sales.OrderDetails


SELECT C.custid, COUNT(DISTINCT O.orderid) as numorders, SUM(OD.qty) as totalqty
FROM Sales.Customers as C right join Sales.Orders as O ON C.custid=O.custid right join Sales.OrderDetails as OD ON O.orderid = OD.orderid
WHERE C.country = 'USA'
GROUP BY C.custid
ORDER BY C.custid


SELECT C.custid,O.orderid, OD.qty 
FROM Sales.Customers as C right join Sales.Orders as O ON C.custid=O.custid right join Sales.OrderDetails as OD ON O.orderid = OD.orderid
WHERE C.country = 'USA'
--GROUP BY C.custid
ORDER BY C.custid, O.orderid


--3

SELECT * FROM Sales.Customers
SELECT * FROM Sales.Orders


SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers as C left join Sales.Orders as O ON C.custid = O.custid

--4

SELECT C.custid, C.companyname
FROM Sales.Customers as C left join Sales.Orders as O ON C.custid = O.custid
WHERE O.orderid is NULL


--5
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers as C left join Sales.Orders as O ON C.custid = O.custid
WHERE O.orderdate = '20070212'

--6

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C LEFT OUTER JOIN Sales.Orders AS O ON O.custid = C.custid AND O.orderdate = '20070212';



-- Chapter 4 Subqueries --

USE TSQL2012;
DECLARE @maxid AS INT = (SELECT MAX(orderid)
	FROM Sales.Orders);
SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE orderid = @maxid;


SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE orderid = (SELECT MAX(O.orderid) FROM Sales.Orders AS O);


SELECT orderid
FROM Sales.Orders
WHERE empid =	(SELECT E.empid 
				FROM HR.Employees AS E 
				WHERE E.lastname LIKE N'B%');

--excersises

--1 

SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders
WHERE orderdate = (SELECT MAX(orderdate) FROM Sales.Orders)

--2

SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders
WHERE custid = (SELECT custid FROM Sales.Orders
				GROUP BY custid
				HAVING COUNT(orderid) = (SELECT  TOP(1) COUNT(orderid) as ord
				FROM Sales.Orders
				GROUP BY custid
				ORDER BY ord desc))



--3

SELECT * FROM HR.Employees
SELECT * FROM Sales.Orders


SELECT empid, firstname, lastname
FROM HR.Employees
WHERE empid not in(SELECT distinct empid
					FROM Sales.Orders
					WHERE orderdate >= '20080501')


--4

SELECT * FROM Sales.Customers
SELECT * FROM HR.Employees


SELECT distinct country FROM Sales.Customers
WHERE country not in (SELECT distinct country FROM HR.Employees)


-- 5

SELECT * FROM Sales.Orders


SELECT custid, orderid, orderdate, empid  FROM Sales.Orders as main
WHERE orderdate = (SELECT MAX(orderdate) as ld 
					FROM Sales.Orders as sbq1
					WHERE sbq1.custid = main.custid)
ORDER by custid

SELECT custid, orderid, orderdate, empid
FROM Sales.Orders AS O1
WHERE orderdate =
 (SELECT MAX(O2.orderdate)
 FROM Sales.Orders AS O2
 WHERE O2.custid = O1.custid)
ORDER BY custid;


-- 6

SELECT * FROM Sales.Customers
SELECT * FROM Sales.Orders;



SELECT distinct custid, companyname FROM Sales.Customers
WHERE custid in
(SELECT distinct custid FROM Sales.Orders
WHERE year(orderdate) = 2007 and custid NOT IN
(SELECT custid FROM Sales.Orders
WHERE year(orderdate) = 2008))
ORDER BY custid


-- 7

