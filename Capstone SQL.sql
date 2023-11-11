CREATE DATABASE CapstoneRecords

USE CapstoneRecords


CREATE SCHEMA Sales

CREATE TABLE Sales.Sales
(
OrderID INT IDENTITY (141234,1) PRIMARY KEY,
Quantity INT,
Price DECIMAL (10,2),
Revenue DECIMAL(10,2),
Product nvarchar (20),
Purchase Address nvarchar (20)
)

CREATE TABLE Sales.Finance
(
Revenue DECIMAL (10,2),
PAT DECIMAL (10,2),
Sales YTD DECIMAL (10,2),
)



CREATE SCHEMA Product

CREATE TABLE Products.Products
(
ProductID INT IDENTITY (1,1) PRIMARY KEY,
Product nvarchar (20),
Segment nvarchar (20),
)


CREATE SCHEMA Dates

CREATE TABLE Dates.Dates
(
OrderID INT IDENTITY (141234,1),
Order_Date DATE,










