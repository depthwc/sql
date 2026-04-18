


-- BEGIN TRANSACTION;

-- DELETE FROM Sales.OrderDetails
-- WHERE orderid = 1;

-- SELECT * FROM sales.OrderDetails;

-- ROLLBACK TRANSACTION;



CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

INSERT INTO Products (ProductID, ProductName, Category, Price, Stock) VALUES
(1, 'Laptop A', 'Electronics', 1200.00, 5),
(2, 'Laptop B', 'Electronics', 1500.00, 0),
(3, 'Phone A', 'Electronics', 800.00, 15),
(4, 'Phone B', 'Electronics', 950.00, 2),
(5, 'TV A', 'Electronics', 2000.00, 8),

(6, 'Sofa A', 'Furniture', 700.00, 3),
(7, 'Sofa B', 'Furniture', 1200.00, 0),
(8, 'Table A', 'Furniture', 300.00, 20),
(9, 'Chair A', 'Furniture', 150.00, 12),
(10, 'Bed A', 'Furniture', 1800.00, 7),

(11, 'Shirt A', 'Clothing', 50.00, 25),
(12, 'Shirt B', 'Clothing', 70.00, 5),
(13, 'Jacket A', 'Clothing', 200.00, 0),
(14, 'Jeans A', 'Clothing', 120.00, 9),
(15, 'Shoes A', 'Clothing', 300.00, 2),

(16, 'Apple', 'Groceries', 2.00, 100),
(17, 'Milk', 'Groceries', 3.50, 0),
(18, 'Bread', 'Groceries', 1.50, 30),
(19, 'Cheese', 'Groceries', 5.00, 4),
(20, 'Meat', 'Groceries', 15.00, 6);


SELECT DISTINCT ProductID, Category, MAX(Price) OVER(PARTITION BY Category ORDER BY ProductID) as max_price , Stock, IIF(Stock = 0 , 'Out of Stock', IIF(Stock BETWEEN 1 and 10, 'Low Stock', 'In Stock')) as StockStatus
FROM Products
ORDER BY max_price DESC
OFFSET 5 ROWS


create table letters
(letter char(1));

insert into letters
values ('a'), ('a'), ('a'), 
  ('b'), ('c'), ('d'), ('e'), ('f');



SELECT letter, 
CASE
    WHEN letter = 'b'  THEN 0
    ELSE 1
END AS letter_values
FROM letters
ORDER BY letter_values, letter;



SELECT letter, IFF(letter = 'b',3,ROW_NUMBER() OVER(ORDER BY letter))  AS row_number
FROM letters



IF OBJECT_ID('Employees', 'U') IS NOT NULL
    DROP TABLE Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

IF OBJECT_ID('Employees', 'U') IS NOT NULL
    DROP TABLE Employees;
CREATE TABLE Employees
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);
go
INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');


SELECT * , ROW_NUMBER() OVER(ORDER BY EmployeeID) AS row_number FROM Employees;


;WITH C as (
    SELECT EmployeeID, ManagerID, JobTitle, 0 as depth 
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    SELECT e.EmployeeID, e.ManagerID, e.JobTitle, C.depth + 1 
    FROM Employees as E INNER JOIN C on E.ManagerID = C.EmployeeID
)


SELECT * FROM C
ORDER BY depth, EmployeeID;




CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);



INSERT INTO WorkLog (EmployeeID, EmployeeName, Department, WorkDate, HoursWorked)
VALUES
(1, 'Alice',   'HR',    '2024-03-01', 8),
(2, 'Bob',     'IT',    '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice',   'HR',    '2024-03-03', 6),
(2, 'Bob',     'IT',    '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);


SELECT * FROM WorkLog;



IF OBJECT_ID('vw_MonthlyWorkSummary','V') IS NOT NULL
    DROP VIEW vw_MonthlyWorkSummary;
GO
CREATE VIEW vw_MonthlyWorkSummary 
AS
SELECT EmployeeID, EmployeeName, Department, SUM(HoursWorked) OVER(PARTITION BY EmployeeID) AS TotalHoursWorkedE, SUM(HoursWorked) OVER(PARTITION BY Department) AS TotalHoursWorkedD,
AVG(HoursWorked) OVER(PARTITION BY Department) AS AVGHoursWorkedD

FROM WorkLog
GO

SELECT * FROM vw_MonthlyWorkSummary

;


CREATE PROCEDURE c @i int, @j int
AS
BEGIN
    SELECT @i+@j AS aplusb
END
GO


EXECUTE c @i=1, @j=7

go 

CREATE FUNCTION dbo.AddTwoNumbers
(
    @i INT,
    @j INT
)
RETURNS INT
AS
BEGIN
    RETURN @i + @j
END
GO

SELECT dbo.AddTwoNumbers(3, 5) AS Result;