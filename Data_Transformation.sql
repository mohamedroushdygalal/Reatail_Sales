-- Some Tranformations

-- Set data type of storesize from varchar to float  
alter table store_Details alter column StoreSize Float 

-- Rename Department columns
EXEC sp_rename 'Department.Department', 'Category', 'COLUMN';
EXEC sp_rename 'Department.Group', 'SubCategory', 'COLUMN';

-- Adding Profit Amount as Computed Column 
alter table FactRetailSales add Profit_Amount 
as(isnull([Margin Amount],0) * isnull([Sales Amount],0)) PERSISTED

-- update Store_Details(StoreType) by replacing 'StoreType:' with nothing
update Store_Details
set StoreType = REPLACE(StoreType,'StoreType:','')

-- update Store_Details(StoreSize) by replacing 'Sqft:' with nothing
update Store_Details
set StoreSize = REPLACE(StoreSize,'Sqft','')

-- update Store_Details(StoreLocation) by replacing ' ;USA Division' with nothing
update Store_Details
set StoreLocation = REPLACE(StoreLocation,' ;USA Division','')

-- update Store_Details(StoreLocation) by replacing 'USA Division; ' with nothing
update Store_Details
set StoreLocation = REPLACE(StoreLocation,'USA Division; ','')