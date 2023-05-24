USE seminars;

DROP TABLE worker;
CREATE TABLE worker
(
Id INT PRIMARY KEY AUTO_INCREMENT,
FirstName VARCHAR(20),
SurName VARCHAR(20),
Position VARCHAR(20),
Seniority INT,
Salary INT,
Age INT
);

INSERT INTO worker (FirstName, SurName, Position, Seniority, Salary, Age)
VALUES
("Вася", "Васькин", "Начальник", 12, 100000, 60), 
("Петя", "Васькин", "Инженер", 4, 80000, 60),
("Катя", "Васькин", "Рабочий", 8, 50000, 60),
("Катерина", "Васькина", NULL, 8, 50000, 60),
("Игорь", "Васькин", "Рабочий", 5, 100000, 60),
("Мила", "Васькин", "Инженер", 4, 70000, 60),
("Юра", "Васькин", "Рабочий", 7, 60000, 60),
("Мила", "Васькин", NULL, 8, 50000, 60),
("Евгений", "Васькин", "Рабочий", 2, 55000, 60),
("Михаил", "Васькин", "Рабочий", 1, 40000, 60),
("Николай", "Васькин", "Начальник", 5, 40000, 60),
("Мария", "Васькин", "Уборщица", 8, 10000, 49);

SELECT * FROM worker;

SELECT FirstName, SurName,
IF (Position IS NULL, 'N/A', Position) Position,
Seniority, Salary, Age
FROM worker;

SELECT @MaxSalary := Max(Salary) AS SALARY FROM worker;

SELECT @MAXSALARY;

SELECT IF (MAX(Salary) / 2 > AVG(Salary), 'Yes', 'No') FROM worker;



