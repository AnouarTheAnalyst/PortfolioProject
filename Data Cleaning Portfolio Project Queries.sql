/*

Cleaning Data in SQL Queries

*/

-- Remove Duplicate 
-- Standardize Data 
-- Change value to positive 
-- Null value and blank 
--  Remove any column 


CREATE TABLE  Sales_data
LIKE Sales ; 

Select *
From Sales_data;

Insert Sales_data
Select*
From sales;

Select *
From Sales_data;

-- Remove Duplicate 

Select *,
row_number() over(
 Partition by InvoiceNo , StockCode, Description , CustomerId , InvoiceDate) as Row_num
From Sales_data;


WITH Duplicate_cte AS
(
Select *,
row_number() over(
 Partition by InvoiceNo , StockCode, Description,Quantity , InvoiceDate, UnitPrice ,CustomerId , Country,Discount,PaymentMethod,ShippingCost,Category,SalesChannel,
 ReturnStatus ,ShipmentProvider,WarehouseLocation,OrderPriority ) as Row_num
 From Sales_data
)
Select*
from Duplicate_cte
where Row_num > 1 ;
Select*
 from Sales_data
 where InvoiceNo = '100005', '100188','999891';
 
CREATE TABLE `sales_data1` (
  `InvoiceNo` int DEFAULT NULL,
  `StockCode` text,
  `Description` text,
  `Quantity` int DEFAULT NULL,
  `InvoiceDate` text,
  `UnitPrice` double DEFAULT NULL,
  `CustomerID` text,
  `Country` text,
  `Discount` double DEFAULT NULL,
  `PaymentMethod` text,
  `ShippingCost` text,
  `Category` text,
  `SalesChannel` text,
  `ReturnStatus` text,
  `ShipmentProvider` text,
  `WarehouseLocation` text,
  `OrderPriority` text ,
  `Row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


Select* 
from sales_data1;

INSERT INTO sales_data1
Select *,
row_number() over(
 Partition by InvoiceNo , StockCode, Description,Quantity , InvoiceDate, UnitPrice ,CustomerId , Country,Discount,PaymentMethod,ShippingCost,Category,SalesChannel,
 ReturnStatus ,ShipmentProvider,WarehouseLocation,OrderPriority ) as Row_num
 From Sales_data;
 
 Select*
From sales_data1
where Row_num =1;

Delete 
from sales_data1
Where Row_num >1 ;

Select*
From sales_data2
where InvoiceNo = '100005';

-- Standardize Date Format

 ## Convert values from negative to positive 
 
Select Quantity
from sales_data1
where Quantity = '';

Select Quantity ,  abs(Quantity) as Correct_Quantity
from sales_data1;

Update Sales_data1
set Quantity = abs(Quantity);

Select Quantity 
from sales_data1;

select UnitPrice
from sales_data1
where UnitPrice < 0;

Update Sales_data1
set UnitPrice = abs(UnitPrice);

select UnitPrice
from sales_data1
where UnitPrice < 0;
select Discount
from sales_data1
where Discount <0;

-- Change blank value to null

select count(CustomerID)
from sales_data1
where CustomerID = '';

# 4978 customerID is blank

Select *
from sales_data1
where CustomerID = null ;

### No Null Values 

update Sales_data1
set CustomerID = Null                      
Where CustomerID = '';

Select s1.InvoiceNo , s1.WarehouseLocation  , s2.InvoiceNo ,s2.WarehouseLocation 
from sales_data1 s1
join sales_data1 s2
	on s1.InvoiceNo = s2.InvoiceNo
where s1.CustomerID is null and s2.CustomerID is not null ;

update sales_data1 as s1
join sales_data1 as s2
	on s1.InvoiceNo = s2.InvoiceNo
set s1.CustomerID = s2.CustomerID
where s1.CustomerID is null and s2.CustomerID is not null;


Select *
from sales_data1
where WarehouseLocation = '' ;

### No Null Values 

update Sales_data1
set WarehouseLocation = Null                      #101316  114425
Where WarehouseLocation = '';

select WarehouseLocation
from sales_data1
where WarehouseLocation is null;

Select s1.InvoiceNo , s1.WarehouseLocation  , s2.InvoiceNo ,s2.WarehouseLocation 
from sales_data1 s1
join sales_data1 s2
	on s1.InvoiceNo = s2.InvoiceNo
where s1.WarehouseLocation is null and s2.WarehouseLocation is not null ;

update sales_data1 as s1
join sales_data1 as s2
	on s1.InvoiceNo = s2.InvoiceNo
set s1.WarehouseLocation = s2.WarehouseLocation
where s1.WarehouseLocation is null and s2.WarehouseLocation is not null;

select*
from sales_data1
where InvoiceNo = '101316';



select Count(distinct(InvoiceNo))
from sales_data1;



select ShippingCost
from sales_data1
where ShippingCost = ''
;
update Sales_data1
set ShippingCost = Null                      
Where ShippingCost = '';

Select s1.InvoiceNo , s1.ShippingCost  , s2.InvoiceNo ,s2.ShippingCost ,s1.CustomerID ,s1.WarehouseLocation , 
s1.Country, s2.CustomerID , s2.WarehouseLocation , s2.Country , s1.StockCode , s2.StockCode
from sales_data1 s1
join sales_data1 s2
	on s1.InvoiceNo = s2.InvoiceNo
where s1.ShippingCost  is null and s2.ShippingCost is not null ;


update Sales_data1
set ShippingCost = Null                     
Where ShippingCost = '';

-- change Date Format

select InvoiceDate , substring(InvoiceDate,1,10)
from sales_data1;

update sales_data1
set InvoiceDate = substring(InvoiceDate,1,10) ;


select InvoiceDate 
from sales_data1;

select InvoiceDate , str_to_date(InvoiceDate, '%d/%m/%Y') 
from sales_data1;

update sales_data1
set InvoiceDate =str_to_date(InvoiceDate, '%d/%m/%Y') ;

Alter table sales_data1
modify column InvoiceDate date ;

select InvoiceDate
from sales_data1;


-- Delete Unused Columns
alter table sales_data1
Drop column Row_num;

Select* 
from sales_data1;


--  Do Same Calculate 

-- Total Sales = '62723064.21'
select Round(sum(UnitPrice * Quantity),2)
from sales_data1;

select Round(sum(UnitPrice * Quantity * (1-Discount)),2)
From sales_data1;

-- Total Revenue = '45440908.15'
select Round(sum(UnitPrice * Quantity * (1-Discount)),2)
From sales_data1;

-- Total Return = 4894
select count(ReturnStatus)
From sales_data1
where ReturnStatus = 'Returned';
-- Total not Returend = '44888'
select count(ReturnStatus)
From sales_data1
where ReturnStatus = 'Not Returned';

-- total Order = '49782'

select distinct(count(InvoiceNo))
From sales_data1;

select (ShipmentProvider)
from sales_data1
