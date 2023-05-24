SELECT * FROM myfirstdatabase.hw_01_phone;

SELECT product_name, manufacturer, price
FROM myfirstdatabase.hw_01_phone
WHERE product_count > 2;

SELECT *
FROM myfirstdatabase.hw_01_phone
WHERE manufacturer = 'Samsung';

SELECT *
FROM myfirstdatabase.hw_01_phone
WHERE product_name LIKE '%Iphone%';

SELECT *
FROM myfirstdatabase.hw_01_phone
WHERE product_name LIKE '%Samsung%';

SELECT *
FROM myfirstdatabase.hw_01_phone
WHERE product_name REGEXP '[0-9]';

SELECT *
FROM myfirstdatabase.hw_01_phone
WHERE product_name REGEXP '[8]';