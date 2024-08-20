create database Medical;
use Medical;
CREATE TABLE Inventory (
    BillDate DATE,
    TQty INT,
    UCPwithoutGST DECIMAL(10,2),
    PurGSTPer DECIMAL(5,2),
    MRP DECIMAL(10,2),
    TotalCost DECIMAL(10,2),
    TotalDiscount DECIMAL(10,2),
    NetSales DECIMAL(10,2),
    ReturnMRP DECIMAL(10,2),
    GenericName VARCHAR(255),
    SubCategory VARCHAR(255),
    SubCategoryL3 VARCHAR(255),
    AnonymizedBillNo VARCHAR(255),
    AnonymizedSpecialisation VARCHAR(255)
);
select * from Inventory;-- display table loaded or not

describe Inventory;

/* covert datatype BillDate TEXT TO date */
SELECT BillDate FROM Inventory LIMIT 10;

ALTER TABLE INVENTORY MODIFY BillDate DATE;

SELECT
    TQty,
    CASE 
        WHEN TQty < 0 THEN TQty 
        ELSE 0 
    END AS Returned_Qty,
    CASE 
        WHEN TQty > 0 THEN TQty 
        ELSE 0 
    END AS Quantity
FROM Inventory;

/*First momemt of Business Decision/ Mesure of central Tendency*/
#mean
select AVG(TQty) AS mean_TQty
from Inventory; -- Mean for TQty 1.71
select AVG(TotalCost) As mean_TotalCost
from Inventory; -- Mean for TotalCost 538.69 
select AVG(NetSales) As mean_NetSales
from Inventory; -- Mean for NetSales 963.84
Select AVG(ReturnMRP) As mean_ReturnMRP
from Inventory; -- Mean of 116.06

# median
select TQty As median_TQty
From(select TQty, Row_Number() over (order by TQty) As row_num,
            count(*) over() As total_count
            from Inventory
)
As subquery
Where row_num = (total_count + 1) /2 or row_num = (total_count + 2)/2; -- median for TQty 1

select TotalCost As median_TotalCost
From(select TotalCost, Row_Number() over (order by TotalCost) As row_num,
            count(*) over() As total_count
            from Inventory
)
As subquery
Where row_num = (total_count + 1) /2 or row_num = (total_count + 2)/2; -- median for TotaCost 77.28

select NetSales As median_NetSales
From(select NetSales, Row_Number() over (order by NetSales) As row_num,
            count(*) over() As total_count
            from Inventory
)
As subquery
Where row_num = (total_count + 1) /2 or row_num = (total_count + 2)/2; -- median for NetSales 99.4

select ReturnMRP As median_ReturnMRP
from(select ReturnMRP, Row_Number() over(order by ReturnMRP) As row_num,
            count(*) over() As total_count
            from Inventory
)
As subquery
where row_num = (total_count + 1) / 2 or row_num = (total_count + 2)/2; -- median for ReturnMRP 0

#mode
select TQty As mode_TQty
from(
     select TQty, count(*) As frequency
     from Inventory
     group by TQty
     order By frequency DESC
     LIMIT 1
) As subquery; -- mode for TQty 1


#mode
select Totalcost As mode_TotalCost
from(
     select TotalCost, count(*) As frequency
     from Inventory
     group by TotalCost
     order by frequency Desc
     limit 1
)As subquery; -- mode for TotalCost 10.92

#mode
select NetSales As mode_NetSales
from(
     select NetSales, count(*) As frequency
     from Inventory 
     group by NetSales
     order by frequency Desc
     limit 1
) As subquery; -- mode for NetSales 0

#mode
select ReturnMRP As mode_ReturnMRP
from(
select ReturnMRP, count(*) As frequency
from Inventory
group by ReturnMRP
order by frequency Desc
limit 1
) as subquery; -- mode for ReturnMRP  0

/*Second Moment of Business Decision / Mesures of dispersion*/
#variance
select variance(TQty) As TQty_variance
from Inventory; -- Variance for TQty 10.35

select variance(TotalCost) As TotalCost_variance
from Inventory; -- Variance for 4531490.75

select variance(NetSales) As NetSales_variance
from Inventory; -- Variance for NetSales 10255590.62

Select variance(ReturnMRP) As ReturnMRP_variance
from Inventory; -- Variance for ReturnMRP 1211851.22

#Standard Deviation
select STDDEV(TQty) As TQty_STDDEV
from Inventory; -- Standard deviation for TQty 3.21

select STDDEV(TotalCost) As TotalCost_STDDEV
from Inventory;-- Standard deviation for TotalCost 2128.72

select STDDEV(NetSales) As NetSales_STDDEV
from Inventory; -- Standard deviation for Netsales 3202.43

select STDDEV(ReturnMRP) As ReturnMRP_STDDEV
from Inventory; -- Standard deviation for ReturnMRP 1100.84

#Range
select MAX(TQty) - MIN(TQty) As Tqty_Range
from Inventory; -- Range for TQty 498

select MAX(TotalCost) - MIN(TotalCost) As TotalCost_range
from Inventory; -- Range for TotalCost 121054.5

select MAX(NetSales) - MIN(NetSales) As NetSales_range
from Inventory;-- Range for NetSales 100620

select MAX(ReturnMRP) - MIN(ReturnMRP) As ReturnMRP
from Inventory; -- Range for ReturnMRP 160801.2

/*Third Moment of Business Decision*/
SELECT
    (
	   SUM(POWER(TQty - (SELECT AVG(TQty) FROM Inventory), 3)) / 
	   (COUNT(*) * POWER((SELECT STDDEV(TQty) FROM Inventory), 3))
    ) AS skewness
from Inventory; -- skewness for TQty -15.83

SELECT
    (
	   SUM(POWER(TotalCost - (SELECT AVG(TotalCost) FROM Inventory), 3)) / 
	   (COUNT(*) * POWER((SELECT STDDEV(TotalCost) FROM Inventory), 3))
    ) AS skewness
from Inventory; -- skewness for TotalCost 14.18

SELECT
    (
	   SUM(POWER(NetSales - (SELECT AVG(NetSales) FROM Inventory), 3)) / 
	   (COUNT(*) * POWER((SELECT STDDEV(NetSales) FROM Inventory), 3))
    ) AS skewness
from Inventory; -- Skewness for NetSales 8.98

SELECT
    (
        SUM(POWER(ReturnMRP - (SELECT AVG(ReturnMRP) FROM Inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(ReturnMRP) FROM Inventory), 3))
    ) AS skewness
from Inventory; -- skewness for ReturnMRP 48.25

/*Fourth Moment of Business Decision*/
select
     (
        (SUM(POWER(TQty - (select AVG(TQty) from Inventory), 3)) /
        (COUNT(*) * POWER((select STDDEV(TQty) from Inventory), 4))) - 3
	  ) As kurtosis
from Inventory; -- kurtosis for TQty -7.92

select
     (
       (SUM(POWER(TotalCost - (select AVG(TotalCost) from Inventory), 3)) /
       (COUNT(*) * POWER(( select STDDEV(TotalCost) from Inventory), 4))) - 3
	 ) As kurtosis
from Inventory;-- kurtosis for TotalCost -2.99

select
     (
       (SUM(POWER(NetSales - (select AVG(NetSales) from Inventory), 3)) /
       (COUNT(*) * POWER(( select STDDEV(NetSales) from Inventory), 4))) - 3
	 ) as kurtosis
from Inventory;-- kurtosis for Netsales -2.99

select
     (
      (SUM(POWER(ReturnMRP - (Select AVG(ReturnMRP) from Inventory), 3)) /
      (COUNT(*) * POWER(( SELECT STDDEV(ReturnMRP) from Inventory), 4))) - 3
     ) As kurtosis
from Inventory;-- kurtosis for ReturnMRP -2.95



/*sum of units of Returned Quantity*/
select sum(TQty) from Inventory where TQty < 0; -- Returned quantity units = 24524


/*sum of units Sales Quantity*/
select sum(TQty) from Inventory where TQty > 0; -- Sum of units Sales Quantity 170279

/*Total NetSales/Sum of NetSales */
select sum(NetSales) from Inventory; -- Total NetSales (sum)= 81927099.29 Rupees

/*Total Profit*/
SELECT 
    (SUM(NetSales) + SUM(ReturnMRP)) - SUM(TotalCost) AS Total_Profit
FROM 
    Inventory;-- Total Profit = 46003112.35 Rupees


/* Largest Sales*/
select GenericName, Sum(NetSales) As Total_Sales
From Inventory
Group By GenericName
Order By Total_Sales DESC
LIMIT 10;  -- Largest Sales MEROPENEM 1GM INJ  11053954.92 RUPEES

/*Lowest Sales*/
Select GenericName, sum(NetSales) As Total_Sales
From Inventory
Group By GenericName
Order By Total_sales ASC
LIMIT 10; -- Lowest Sales ALTEPLASE 20MG    0 Rupees

/*Largest sales for year 2020 top ten*/
select GenericName, Sum(NetSales) As Total_Sales
From Inventory
Where YEAR(Billdate) = 2020
Group By GenericName
Order By Total_Sales DESC
LIMIT 10; -- Largest sales for year 2020 HUMAN ALBUMIN 20% INJ = 3082658.5 Rupees

/*largest sales for year 2021 top ten*/
select GenericName, sum(NetSales) As Total_Sales
From Inventory
Where Year(Billdate) = 2021
Group By GenericName
Order By Total_Sales DESC
LIMIT 10; -- largest sales for year 2021 MEROPENEM 1GM INJ  5342419.16

/*largest sales for year 2022 top ten*/
select GenericName, sum(Netsales) As Total_Sales
From Inventory
where Year(BillDate) = 2022
Group By GenericName
Order By Total_Sales DESC
LIMIT 10;-- largest sales for year 2022 HUMAN ALBUMIN 25% INJ  4203900 Rupees


SELECT 
    table_name AS `Inventory`, 
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS `Size in MB`
FROM 
    information_schema.TABLES
WHERE 
    table_schema = 'Medical'
    AND table_name = 'Inventory';-- to know the size of table 16.55 MB
    
        
    SELECT 
    (SELECT COUNT(*) FROM Inventory) AS row_count, 
    (SELECT COUNT(*) 
     FROM information_schema.COLUMNS 
     WHERE TABLE_SCHEMA = 'Medical' 
     AND TABLE_NAME = 'Inventory') AS column_count;-- count rows and columns
     

/*total*/
SELECT 
    SubCategory,
    SUM(NetSales) AS TotalNetSales
FROM 
    Inventory
WHERE 
    YEAR(BillDate) = 2021
GROUP BY 
    SubCategory
ORDER BY 
    TotalNetSales DESC;
/**/
SELECT 
    GenericName,
    SUM(NetSales) AS TotalNetSales
FROM 
    Inventory
WHERE 
    YEAR(BillDate) = 2022
GROUP BY 
    GenericName
ORDER BY 
    TotalNetSales DESC
LIMIT 5;

SELECT 
    GenericName,
    MRP
FROM 
    Inventory
ORDER BY 
    MRP DESC
LIMIT 5;