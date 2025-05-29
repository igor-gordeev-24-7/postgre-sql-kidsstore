-- Создание типа ENUM для статуса заказов
CREATE TYPE order_status AS ENUM ('Новый', 'В обработке', 'Отправлен', 'Выполнен', 'Отменён');

-- Категории товаров
CREATE TABLE IF NOT EXISTS Categories (
    CategoryID SERIAL PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Поставщики
CREATE TABLE IF NOT EXISTS Suppliers (
    SupplierID SERIAL PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL UNIQUE,
    ContactPerson VARCHAR(100),
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Address VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Товары
CREATE TABLE IF NOT EXISTS Products (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price NUMERIC(10,2) NOT NULL,
    StockQuantity INT NOT NULL,
    ImageURL VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CategoryID INT REFERENCES Categories(CategoryID) ON DELETE SET NULL,
    SupplierID INT REFERENCES Suppliers(SupplierID) ON DELETE SET NULL
);

-- Клиенты
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Address VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Сотрудники
CREATE TABLE IF NOT EXISTS Employees (
    EmployeeID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(100),
    HireDate DATE,
    Salary NUMERIC(10,2),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Роли пользователей
CREATE TABLE IF NOT EXISTS Roles (
    RoleID SERIAL PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL UNIQUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Пользователи системы
CREATE TABLE IF NOT EXISTS Users (
    UserID SERIAL PRIMARY KEY,
    EmployeeID INT REFERENCES Employees(EmployeeID) ON DELETE SET NULL,
    Username VARCHAR(50) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    RoleID INT REFERENCES Roles(RoleID) ON DELETE CASCADE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Заказы
CREATE TABLE IF NOT EXISTS Orders (
    OrderID SERIAL PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID INT REFERENCES Customers(CustomerID) ON DELETE SET NULL,
    EmployeeID INT REFERENCES Employees(EmployeeID) ON DELETE SET NULL,
    TotalAmount NUMERIC(10,2) NOT NULL,
    Status order_status DEFAULT 'Новый',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Состав заказа
CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderDetailID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID) ON DELETE CASCADE,
    ProductID INT REFERENCES Products(ProductID) ON DELETE SET NULL,
    Quantity INT NOT NULL,
    UnitPrice NUMERIC(10,2) NOT NULL,
    TotalPrice NUMERIC(10,2) GENERATED ALWAYS AS (Quantity * UnitPrice) STORED
);

-- Отчёты по продажам
CREATE TABLE IF NOT EXISTS SalesReports (
    ReportID SERIAL PRIMARY KEY,
    ReportDate DATE NOT NULL,
    ProductID INT REFERENCES Products(ProductID) ON DELETE SET NULL,
    QuantitySold INT NOT NULL,
    Revenue NUMERIC(12,2) NOT NULL
);

-- Лог действий сотрудников
CREATE TABLE IF NOT EXISTS ActivityLogs (
    LogID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Users(UserID) ON DELETE SET NULL,
    Action VARCHAR(255) NOT NULL,
    "Timestamp" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);