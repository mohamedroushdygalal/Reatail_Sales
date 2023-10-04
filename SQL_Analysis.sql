-- SQL Analysis Queries

-- Write Query to compare between total sales for every store type and
-- which store type has a maximum total sales?

select sum([Sales Amount]) as [Sales Amount],StoreType
from FactRetailSales join Store_Details
on FactRetailSales.StoreID = Store_Details.StoreID
group by StoreType
order by [Sales Amount] Desc

-- Write Query to compare between total sales for every store location and
-- which store location has a maximum total sales?

select sum([Sales Amount]) as [Sales Amount],StoreLocation
from FactRetailSales join Store_Details
on FactRetailSales.StoreID = Store_Details.StoreID
group by StoreLocation
order by  [Sales Amount] Desc

-- Write Query to compare between total sales and profit amount for each category and
-- which category has a maximum total sales and profit?

select Category,sum([Sales Amount]) as [Sales Amount],sum(Profit_Amount) as [Profit Amount]
from FactRetailSales join Department
on FactRetailSales.CategoryID = Department.CategoryID
group by Category
order by [Sales Amount] Desc

-- Write Query to compare between total sales and profit for each subcategory and
-- which subcategory has a maximum total sales and profit?

select sum([Sales Amount]) as [Sales Amount],sum([Profit_Amount]) as [Total Profit],SubCategory
from FactRetailSales join Department
on FactRetailSales.CategoryID = Department.CategoryID
group by SubCategory
order by [Sales Amount] Desc

-- Over last three years, comparison between them in terms of total sales and profit

select year(Date)as Year,sum([sales amount])as [Sales Amount],sum([Profit_Amount])as [Total Profit]
from FactRetailSales
group by year(Date)
order by [Sales Amount] Desc;
go

-- Quering comparison between months over each year in terms of total sales and profit

create or alter proc Total_Sales_And_Profit_By_Month (@Year int)
as
select DimDate.MonthName,sum([sales amount])as [Sales Amount],sum([Profit_Amount])as [Total Profit]
from FactRetailSales join DimDate on FactRetailSales.Date=DimDate.Date
where @Year = year(DimDate.Date)
group by DimDate.MonthName
order by [Total Profit] Desc

Exec Total_Sales_And_Profit_By_Month '2017'
Exec Total_Sales_And_Profit_By_Month '2018'
Exec Total_Sales_And_Profit_By_Month '2019'

-- Quering comparison between storetypes with location over last year in terms of total sales 
-- and targetsales setting an indicator column

select StoreType,StoreLocation,year(RetailFixedCost.Date) as year,
sum([Sales Amount]) as [Sales Amount] , sum(TargetSales) as TargetSales,
case 
    when sum([Sales Amount]) > sum(TargetSales)  then 'High'
    when sum([Sales Amount]) < sum(TargetSales) then 'Low'
End as [Sales Evaluation]
from RetailFixedCost join Store_Details
on RetailFixedCost.StoreID = Store_Details.StoreID
join FactRetailSales
on FactRetailSales.StoreID = Store_Details.StoreID
where RetailFixedCost.StoreID < 99
group by StoreType,StoreLocation,year(RetailFixedCost.Date)
Having year(RetailFixedCost.Date) = 2019
order by [Sales Amount] Desc


-- what is the next and past profit amount of all subcategories in clothing category? 
WITH ProfitSummary AS (
SELECT category,Subcategory,SUM([Profit_Amount]) AS [Profit_Amount],
       ROW_NUMBER() OVER (ORDER BY SUM([Profit_Amount]) ) AS RowNum
FROM FactRetailSales JOIN Department ON FactRetailSales.CategoryID = Department.CategoryID
WHERE category = 'clothing'
GROUP BY category, Subcategory)

SELECT ss.category,ss.Subcategory,ss.[Profit_Amount],
       LEAD(ss.[Profit_Amount]) OVER (ORDER BY ss.RowNum) AS [Lead Profit],
       LAG(ss.[Profit_Amount]) OVER (ORDER BY ss.RowNum) AS [Lag Profit]
FROM ProfitSummary ss
ORDER BY ss.RowNum;

-- Which store has maximum standard deviation i.e., the Wages vary a lot?

select storeid,STDEV(Wages) as wages_standard_deviation from RetailFixedCost 
group by storeid 
order by wages_standard_deviation 