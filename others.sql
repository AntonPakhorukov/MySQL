USE myfirstdatabase;

CREATE TABLE Products
(
Id INT PRIMARY KEY AUTO_INCREMENT,
ProductName VARCHAR(20) NOT NULL,
Manufacturer VARCHAR(20) NOT NULL,
ProductCount INT DEFAULT 0,
Price DECIMAL
);

INSERT INTO Products (ProductName, Manufacturer, ProductCount, Price)
VALUES
("Iphone X", "Apple", 3, 76000),
("Iphone 8", "Apple", 2, 51000),
("Galaxy S9", "Samsung", 2, 56000),
("Galaxy S8", "Samsung", 2, 41000),
("P20 Pro", "Huawei", 1, 36000);

SELECT * FROM Prohw_01_phoneducts;

UPDATE Products SET Price = Price + 50;

SELECT * FROM Products;

ALTER TABLE Products ADD COLUMN Country VARCHAR(20);

SELECT * FROM Products;

ALTER TABLE Products DROP Country;

SELECT * FROM Products;

UPDATE Products SET Price = Price - 50;

SELECT * FROM Products
WHERE Manufacturer NOT IN ("Apple", "Huawei");

CREATE VIEW CopyProducts AS
SELECT Price, ProductCount, Manufacturer
FROM Products
WHERE Manufacturer = 'Apple';

SELECT * FROM CopyProducts;

ALTER VIEW CopyProducts AS
SELECT Price, ProductCount, Manufacturer, ProductName
FROM Products
WHERE Manufacturer = 'Apple';

SELECT * FROM CopyProducts;

ALTER VIEW CopyProducts AS
SELECT Price, ProductCount, Manufacturer, ProductName
FROM Products
WHERE Manufacturer = 'Samsung';

SELECT * FROM CopyProducts;

DROP VIEW CopyProducts;

CREATE TABLE testView
(
Id INT,
Count INT
);

SELECT * FROM testView;