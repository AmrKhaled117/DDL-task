
-- Task 1: Company Database Schema DDL

CREATE DATABASE CompanyDB;
GO

USE CompanyDB;
GO

CREATE SCHEMA HR;
GO

CREATE TABLE HR.Department (
    DNum INT PRIMARY KEY IDENTITY(10,10),
    DName VARCHAR(100) NOT NULL UNIQUE,
    ManagerSSN INT UNIQUE
);

CREATE TABLE HR.Employee (
    SSN INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    City VARCHAR(100) DEFAULT 'Cairo',
    Salary DECIMAL(10, 2) CHECK (Salary > 0),
    Email VARCHAR(255) NOT NULL UNIQUE,
    DeptID INT NOT NULL,
    FOREIGN KEY (DeptID) REFERENCES HR.Department(DNum)
        ON UPDATE CASCADE ON DELETE SET DEFAULT
);

ALTER TABLE HR.Department
ADD CONSTRAINT FK_Manager FOREIGN KEY (ManagerSSN)
REFERENCES HR.Employee(SSN)
ON UPDATE CASCADE ON DELETE SET NULL;

CREATE TABLE HR.Dependent (
    DependentID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    Relationship VARCHAR(50),
    EmployeeSSN INT NOT NULL,
    FOREIGN KEY (EmployeeSSN) REFERENCES HR.Employee(SSN)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE HR.Project (
    ProjID INT PRIMARY KEY IDENTITY(1,1),
    ProjName VARCHAR(100) NOT NULL,
    DeptID INT NOT NULL,
    FOREIGN KEY (DeptID) REFERENCES HR.Department(DNum)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE HR.Works_On (
    SSN INT,
    ProjID INT,
    HoursWorked DECIMAL(5,2) CHECK (HoursWorked >= 0),
    PRIMARY KEY (SSN, ProjID),
    FOREIGN KEY (SSN) REFERENCES HR.Employee(SSN)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ProjID) REFERENCES HR.Project(ProjID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE HR.Employee
ADD HireDate DATE DEFAULT GETDATE();

ALTER TABLE HR.Employee
ALTER COLUMN City NVARCHAR(150);

-- ALTER TABLE HR.Employee
-- DROP CONSTRAINT UQ__Employee__Email; -- Update with actual constraint name if needed

ALTER TABLE HR.Dependent
ADD CONSTRAINT FK_Employee_Dependent FOREIGN KEY (EmployeeSSN)
REFERENCES HR.Employee(SSN)
ON DELETE CASCADE;

INSERT INTO HR.Department (DName)
VALUES ('Engineering'), ('Marketing'), ('HR');

INSERT INTO HR.Employee (SSN, Name, Gender, Salary, Email, DeptID)
VALUES 
(101, 'Alice Smith', 'F', 90000, 'alice@company.com', 10),
(102, 'Bob Johnson', 'M', 85000, 'bob@company.com', 10),
(103, 'Carol King', 'F', 80000, 'carol@company.com', 20);

UPDATE HR.Department SET ManagerSSN = 101 WHERE DNum = 10;

INSERT INTO HR.Project (ProjName, DeptID)
VALUES 
('AI Research', 10),
('Marketing Campaign', 20);

INSERT INTO HR.Works_On (SSN, ProjID, HoursWorked)
VALUES 
(101, 1, 40),
(102, 1, 30),
(103, 2, 20);

INSERT INTO HR.Dependent (Name, Gender, Relationship, EmployeeSSN)
VALUES 
('Tom', 'M', 'Son', 101),
('Anna', 'F', 'Daughter', 102);
