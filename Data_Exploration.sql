use ReatailSales
-- Data Exploration 
select * from FactRetailSales
select * from Department
select * from Store_Details
select * from RetailFixedCost

select count(distinct StoreID) as No_Stores from FactRetailSales
select count(distinct Category) as No_Category from Department
select count(SubCategory) as No_SubCategory from Department

select Category,count(*) as No_SubCategories
from Department
group by Category


select distinct StoreLocation  from Store_Details
select distinct StoreType  from Store_Details
select distinct Category  from Department
select distinct SubCategory  from Department


select max([Sales Amount]) from FactRetailSales
select min([Sales Amount]) from FactRetailSales
select sum([Sales Amount]) from FactRetailSales
select avg([Sales Amount]) from FactRetailSales
select max([Margin Amount]) from FactRetailSales
select min([Margin Amount]) from FactRetailSales
select avg([Margin Amount]) from FactRetailSales
select max([Profit_Amount]) from FactRetailSales
select min([Profit_Amount]) from FactRetailSales
select avg([Profit_Amount]) from FactRetailSales;
go

-- Display Subcategory related to specofic category 
create or alter function Get_SubCategory(@Category varchar(50))
returns table
as 
return 
select CategoryID,SubCategory from department 
where @Category = Category
go
select * from Get_DepartmentGroups('Clothing')

--- display some information about column in some tables
SELECT 
    COLUMN_NAME, 
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Store_Details' 
AND COLUMN_NAME = 'StoreSize'

SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'FactRetailSales' 
AND COLUMN_NAME = 'Sales Amount'

SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'FactRetailSales' 
AND COLUMN_NAME = 'Margin Amount'

SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'FactRetailSales' 
AND COLUMN_NAME = 'Profit_Amount'


Exec sp_help 'dbo.Store_Details'
Exec sp_help 'dbo.FactRetailSales'
Exec sp_help 'dbo.RetailFixedCost'