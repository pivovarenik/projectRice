-- Скрипт инициализации тестовых данных для School DB
-- Database First Entity Framework (Contoso University)

USE School;
GO

-- Очистка существующих данных
DELETE FROM Enrollment;
DELETE FROM Course;
DELETE FROM Department;
DELETE FROM Person;
GO

-- Сброс IDENTITY для таблиц
DBCC CHECKIDENT ('Person', RESEED, 0);
DBCC CHECKIDENT ('Department', RESEED, 0);
DBCC CHECKIDENT ('Enrollment', RESEED, 0);
GO

-- Вставка кафедр (Departments)
SET IDENTITY_INSERT Department ON;
INSERT INTO Department (DepartmentID, Name) VALUES 
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'Engineering'),
(4, 'Physics');
SET IDENTITY_INSERT Department OFF;
GO

-- Вставка курсов (Courses)
INSERT INTO Course (CourseID, Title, Credits, DepartmentID) VALUES 
(1045, 'Calculus', 4, 2),
(1050, 'Chemistry', 3, 3),
(2021, 'Composition', 3, 1),
(2042, 'Literature', 4, 1),
(3141, 'Trigonometry', 4, 2),
(4022, 'Microeconomics', 3, 1),
(4041, 'Macroeconomics', 3, 1),
(4061, 'Quantum Physics', 4, 4);
GO

-- Вставка студентов (Students)
SET IDENTITY_INSERT Person ON;
INSERT INTO Person (PersonID, LastName, FirstMidName, EnrollmentDate, Discriminator) VALUES 
(1, 'Alexander', 'Carson', '2019-09-01', 'Student'),
(2, 'Alonso', 'Meredith', '2017-09-01', 'Student'),
(3, 'Anand', 'Arturo', '2018-09-01', 'Student'),
(4, 'Barzdukas', 'Gytis', '2017-09-01', 'Student'),
(5, 'Li', 'Yan', '2017-09-01', 'Student'),
(6, 'Justice', 'Peggy', '2016-09-01', 'Student'),
(7, 'Norman', 'Laura', '2018-09-01', 'Student'),
(8, 'Olivetto', 'Nino', '2019-09-01', 'Student'),
(9, 'Петров', 'Иван', '2020-09-01', 'Student'),
(10, 'Сидорова', 'Мария', '2020-09-01', 'Student');
SET IDENTITY_INSERT Person OFF;
GO

-- Вставка записей о зачислении на курсы (Enrollments)
SET IDENTITY_INSERT Enrollment ON;
INSERT INTO Enrollment (EnrollmentID, CourseID, StudentID, Grade) VALUES 
(1, 1050, 1, 3.50),
(2, 1045, 1, 4.00),
(3, 1050, 2, 3.70),
(4, 4022, 2, 3.50),
(5, 4041, 2, 4.00),
(6, 1045, 3, 3.20),
(7, 3141, 3, NULL),
(8, 2021, 3, 3.70),
(9, 1050, 4, 3.00),
(10, 1045, 5, 3.50),
(11, 2042, 6, 3.30),
(12, 2021, 7, NULL),
(13, 4061, 8, 4.00),
(14, 1045, 9, 3.80),
(15, 2021, 10, NULL);
SET IDENTITY_INSERT Enrollment OFF;
GO

-- Проверка данных
SELECT COUNT(*) AS DepartmentCount FROM Department;
SELECT COUNT(*) AS CourseCount FROM Course;
SELECT COUNT(*) AS StudentCount FROM Person WHERE Discriminator = 'Student';
SELECT COUNT(*) AS EnrollmentCount FROM Enrollment;
GO

PRINT 'Тестовые данные успешно загружены!';
GO
