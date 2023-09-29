select * from Department
select * from FactRetailSales
select * from Store_Details
select * from RetailFixedCost
select * from DimDate
select distinct StoreLocation  from Store_Details

create or alter function Get_Total_Sales()
returns float
as
begin
declare @TotalSales float
select @TotalSales = sum([Sales Amount]) from FactRetailSales
return @TotalSales
end

print ('Total Sales Is: ')  print dbo.Get_Total_Sales()

-- creation some of stored procedures

-- create stored procedure to show total sales by storetype

create or alter proc Sales_By_StoreType
as
select sum([Sales Amount]) as [Sales Amount],StoreType
from FactRetailSales join Store_Details
on FactRetailSales.StoreID = Store_Details.StoreID
group by StoreType

exec Sales_By_StoreType
----------------------------------------------------------------------------
-- create stored procedure to show total sales by year
create or alter proc Sales_By_Year
as
select sum([sales amount]) as [Sales Amount],year(Date) as Year
from FactRetailSales
group by year(Date)
order by year(Date)

exec Sales_By_Year

----------------------------------------------------------------------------

-- create stored procedure to show total sales by department

create or alter proc Sales_By_Department
as
select sum([Sales Amount]) as [Sales Amount],Department
from FactRetailSales join Department
on FactRetailSales.CategoryID = Department.CategoryID
group by Department

exec Sales_By_Department

----------------------------------------------------------------------------

-- create stored procedure to show total sales by storelocation 

create or alter proc Sales_By_StoreLocation
as
select sum([Sales Amount]) as [Sales Amount],StoreLocation
from FactRetailSales join Store_Details
on FactRetailSales.StoreID = Store_Details.StoreID
group by StoreLocation
order by sum([Sales Amount])desc

exec Sales_By_StoreLocation

----------------------------------------------------------------------------

-- create stored procedure to show total profit by year

create or alter proc Profit_By_Year
as
select sum([margin amount] * [sales amount]) as profit ,year(DimDate.Date) as year
from FactRetailSales join DimDate
on FactRetailSales.Date = DimDate.Date
group by year(DimDate.Date)
order by year

exec Profit_By_Year

----------------------------------------------------------------------------

-- create stored procedure to show total profit by month in specific year

create or alter proc Profit_By_Month (@Year int)
as
select sum([margin amount] * [sales amount]) as profit ,DimDate.MonthName
from FactRetailSales join DimDate on FactRetailSales.Date=DimDate.Date
where @Year = year(DimDate.Date)
group by DimDate.MonthName
order by sum([margin amount] * [sales amount]) desc


exec Profit_By_Month '2017'
exec Profit_By_Month '2018'
exec Profit_By_Month '2019'

----------------------------------------------------------------------------

-- create stored procedure to show total profit by End of the week in specific year and month

create or alter proc Profit_By_Week (@Year int, @month int)
as
select sum([margin amount]*[sales amount])as Profit,Date as [End Of Week]
from FactRetailSales 
where @Year = year(Date) and @month  = Month(Date) 
group by Date,Date,DATEPART(WEEK,Date)
order by day(Date)

exec Profit_By_Week '2017','1'
exec Profit_By_Week  '2018','3'
exec Profit_By_Week  '2019','6'