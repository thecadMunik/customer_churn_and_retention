/* Data Quality Check  */

SELECT * 
FROM Accountinfo;

select *
from Customerinfo;


/* Check for duplicates */

select CustomerId, count(CustomerId) as Counts
from Customerinfo
group by CustomerId
having count(CustomerId) > 1;
-- it means theres no duplicate in the Customerinfo table --

select CustomerId, count(CustomerId) as Counts
from Accountinfo
group by CustomerId
having count(CustomerId) > 1;
-- it means theres no duplicate in the Accountinfo table --

/* Check for Null Values */
select
sum(case when CustomerId is null then 1 else 0 end) as cust_null,
sum(case when LastName is null then 1 else 0 end) as ln_null,
sum(case when Country is null then 1 else 0 end) as cnt_null,
sum(case when Gender is null then 1 else 0 end) as gd_null,
sum(case when Age is null then 1 else 0 end) as age_null
from Customerinfo;
-- it means theres no null values in the Customerinfo table --

select
sum(case when CustomerId is null then 1 else 0 end) as cust_null,
sum(case when CreditScore is null then 1 else 0 end) as cred_null,
sum(case when Tenure is null then 1 else 0 end) as ten_null,
sum(case when Balance is null then 1 else 0 end) as bal_null,
sum(case when Products is null then 1 else 0 end) as prod_null,
sum(case when CreditCard is null then 1 else 0 end) as ccard_null,
sum(case when ActiveMember is null then 1 else 0 end) as act_null,
sum(case when Exited is null then 1 else 0 end) as exit_null
from Accountinfo;
-- it means theres no null values in the Accountinfo table --

/* Check for Outliers */
-- 1. Min and Max Age --
select min(Age) as min_age, max(Age) as max_age, avg(Age) as avg_age
from Customerinfo;

-- 2. Min and Max CreditScore --
select min(CreditScore) as min_cs, max(CreditScore) as max_cs, avg(CreditScore) as avg_cs
from Accountinfo;

-- 3. Check for Negative Balance --
select min(Balance) as min_cs, max(Balance) as max_cs, avg(Balance) as avg_cs
from Accountinfo;

select CustomerId, Balance
from Accountinfo
where Balance < 0;
-- There's no record less than 0 --

/* Domain Validation */

SELECT DISTINCT Gender
FROM CustomerInfo;
-- Gender only contains Male and Female, there's no inconsistencies --

SELECT DISTINCT Exited
FROM AccountInfo;
-- There's just 0 and 1 as binary values --

SELECT DISTINCT ActiveMember
FROM Accountinfo;
-- There's just 0 and 1 as binary values --

SELECT DISTINCT CreditCard
FROM Accountinfo;
-- There's just 0 and 1 as binary values --

SELECT DISTINCT Country
FROM Customerinfo;
-- There's no inconsistencies with the countries--


/* PRELIMINARY EXPLORATORY DATA ANALYSIS 
Initial exploratory analysis conducted separately on customer demographic and account-level
tables to understand distributions, customer composition, and engagement characteristics prior 
to table joins */

-- Number of records --
SELECT COUNT(*) AS total_records
FROM Customerinfo;

SELECT COUNT(*) AS total_records
FROM Accountinfo;
/* There are 10,000 records each in both tables */

-- Number of customers in each country --
SELECT Country, COUNT(CustomerId) AS customer_count
FROM Customerinfo
GROUP BY Country
ORDER BY customer_count DESC;

-- Gender Distribution --
SELECT Gender, COUNT(CustomerId) AS customer_count
FROM CustomerInfo
GROUP BY Gender
ORDER BY customer_count DESC;

-- Churn Distribution --
SELECT Exited, COUNT(CustomerId) AS Customer_count
FROM AccountInfo
GROUP BY Exited;

-- OR --
SELECT 
    CASE WHEN Exited = 1 THEN 'Churned'
    WHEN Exited = 0 THEN 'Retained'
    END AS Churn_status, COUNT(CustomerId) AS Customer_count
FROM AccountInfo
GROUP BY Exited;

-- Active Distribution --
SELECT ActiveMember, COUNT(CustomerId) AS Customer_count
FROM AccountInfo
GROUP BY ActiveMember;

-- OR --
SELECT 
    CASE WHEN ActiveMember = 1 THEN 'Active'
    WHEN ActiveMember = 0 THEN 'Inactive'
    END AS Active_status,
    COUNT(CustomerId) AS Customer_count
FROM AccountInfo
GROUP BY ActiveMember;

-- Product Distribution --
SELECT Products, COUNT(CustomerId) AS Customer_count
FROM AccountInfo
GROUP BY Products
ORDER BY Products;

-- Credit Card Distribution --
SELECT CreditCard, COUNT(CustomerId) AS Customer_count
FROM AccountInfo
GROUP BY CreditCard;


/* Column Derivation Phase */

-- Customer Age 
-- First ALTER the table and add a column --
ALTER Table CustomerInfo
ADD AgeGroup as 
CASE
	WHEN Age BETWEEN 18 AND 35 THEN 'Young Adults'
	WHEN Age BETWEEN 36 AND 45 THEN 'Middle-Aged Adults'
	WHEN Age BETWEEN 46 AND 55 THEN 'Pre-Older Adults'
	ELSE 'Older Adults'
END

ALTER TABLE Customerinfo
DROP COLUMN Age_group;

SELECT *
FROM Customerinfo;


-- ALTER AccountInfo Table
ALTER TABLE Accountinfo
ADD 
	ChurnStatus VARCHAR(40),
	ActiveStatus VARCHAR(40),
	BalanceCat VARCHAR(40),
	CreditScoreCat VARCHAR(40),
	TenureCat VARCHAR(40),
	ProductCat VARCHAR(40);

-- Update the Accountinfo new columns --

UPDATE Accountinfo
SET
ChurnStatus = CASE
	WHEN Exited = 1 then 'Churned'
	WHEN Exited = 0 then 'Not Churned'
	ELSE 'Unknown'
	END,

ActiveStatus = CASE
	WHEN ActiveMember = 1 then 'Active'
	WHEN ActiveMember = 0 then 'Inactive'
	ELSE 'Unknown'
	END,

BalanceCat = CASE
	WHEN Balance <= 30000 THEN 'Very Low'
	WHEN Balance BETWEEN 30001 AND 50000 THEN 'Low'
	WHEN Balance BETWEEN 50001 AND 80000 THEN 'Mid'
	ELSE 'High'
	END,

CreditScoreCat = CASE
	WHEN CreditScore <= 580 THEN 'Poor'
	WHEN CreditScore BETWEEN 581 AND 669 THEN 'Fair'
	WHEN CreditScore BETWEEN 670 AND 739 THEN 'Good'
	WHEN CreditScore BETWEEN 740 AND 799 THEN 'Very Good'
	WHEN CreditScore BETWEEN 800 AND 850 THEN 'Excellent'
	ELSE 'Out of Range'
	END,

TenureCat = CASE 
	WHEN Tenure <= 2 THEN 'New'
	WHEN Tenure BETWEEN 3 AND 5 THEN 'Established'
	ELSE 'Loyal'
	END,

ProductCat = CASE  
	WHEN Products <= 1 THEN 'Low'
	WHEN Products <= 2 THEN 'Moderate'
	ELSE 'High Engagement'
	END;

-- Add a new CreditCardCategory
ALTER Table AccountInfo
ADD CreditCardStatus as 
CASE
	WHEN CreditCard = 1 then 'Holder'
	WHEN CreditCard = 0 then 'Non-Holder'
	ELSE 'Unknown'
END

SELECT * 
FROM Accountinfo;




/* Create new Consolidated Data by joining Customer table
and Account table using View function*/

CREATE VIEW CustomerDetails as 
SELECT 
a.*,
c.Age,
c.Country,
c.Gender,
c.LastName,
c.Age_group
FROM Accountinfo as a
	LEFT JOIN Customerinfo as c 
	ON a.CustomerId = c.CustomerId;

SELECT * FROM CustomerDetails;

CREATE OR ALTER VIEW CustomerDetails AS
SELECT
    a.CustomerId,
    a.ChurnStatus,
    a.ActiveStatus,
    a.CreditCardStatus,
    a.Balance,
    a.BalanceCat,
    a.CreditScoreCat,
    a.TenureCat,
    a.ProductCat,
    c.Country,
    c.Gender,
    c.LastName,
    c.Age,
    c.AgeGroup
FROM Accountinfo AS a
LEFT JOIN Customerinfo AS c
    ON a.CustomerId = c.CustomerId;


 



_WHEN Product_Category = ‘Moderate Engagement’ OR Tenure_Category = ‘Established’
	THEN ‘Medium Risk’

ELSE ‘Lower Risk’


-- Create Segmenmtation Table

CREATE VIEW ChurnRiskLevel AS
SELECT CustomerID, Country, AgeGroup, CreditScoreCat, BalanceCat, ActiveStatus, ChurnStatus, 
TenureCat, ProductCat,
CASE WHEN CreditScoreCat IN ('Poor', 'Fair')
	AND BalanceCat = 'Very Low'
	AND ProductCat = 'Low'
	AND TenureCat = 'New'
    THEN 'High Risk'

    WHEN (CreditScoreCat IN ('Poor', 'Fair') AND BalanceCat IN ('Very Low', 'Low'))
    OR (CreditScoreCat IN ('Poor', 'Fair') AND ProductCat = 'Low')
    OR (BalanceCat IN ('Very Low', 'Low') AND ProductCat = 'Low')
    THEN 'Elevated Risk'

    WHEN ProductCat = 'Moderate' OR TenureCat = 'Established'
    THEN 'Medium Risk'

    ELSE 'Lower Risk'
    END AS ChurnRisk
FROM CustomerDetails


SELECT *
FROM ChurnRiskLevel;

SELECT CustomerID, ActiveStatus, ChurnStatus
FROM ChurnRiskLevel
WHERE ActiveStatus = 'Active';

DROP VIEW IF EXISTS CustomerChurnSegment;
GO


/* DEEP DIVE ANALYSIS */

-- No of churn in each country
SELECT Country, COUNT(Customerid) AS ChurnedCustomers
FROM CustomerDetails
WHERE ChurnStatus = 'Churned'
GROUP BY Country
ORDER BY ChurnedCustomers DESC;

SELECT Country,COUNT(CustomerId) AS TotalCustomers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers
FROM CustomerDetails
GROUP BY Country
ORDER BY ChurnedCustomers DESC;


-- No of churn in each country and gender
SELECT Country, Gender, COUNT(*) AS ChurnedCustomers
FROM CustomerDetails
WHERE ChurnStatus = 'Churned'
GROUP BY Country, Gender
ORDER BY Country, Gender;

-- Overall Churn Rate
SELECT
    COUNT(CASE WHEN ChurnStatus = 'Churned' THEN 1 END) AS ChurnedCustomers,
    COUNT(*) AS TotalCustomers,
    CAST(
        COUNT(CASE WHEN ChurnStatus = 'Churned' THEN 1 END) * 100.0 / COUNT(*)
        AS DECIMAL(5,2)
    ) AS OverallChurnRatePct
FROM CustomerDetails;


SELECT COUNT(CustomerId) as TotalCustomers,
SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS No_of_churned,
100*SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(CustomerId) as perc
FROM CustomerDetails;


-- Churn Rate by Age Group

SELECT AgeGroup, COUNT(CustomerId) as TotalCustomers,
SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS No_of_churned,
100*SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(CustomerId) as perc
FROM CustomerDetails
GROUP BY AgeGroup;


SELECT AgeGroup, COUNT(CustomerId) AS TotalCustomers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS No_of_churned,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(CustomerId) AS perc_by_row,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / (SELECT SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) 
           FROM CustomerDetails) AS perc_by_column
FROM CustomerDetails
GROUP BY AgeGroup;



-- Churn Rate by Risk Segment 
SELECT ChurnRisk,COUNT(CustomerID) AS TotalCustomers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(CustomerID) AS perc_by_row,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / (SELECT SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) 
    FROM CustomerDetails) AS perc_by_column
FROM ChurnRiskLevel
GROUP BY ChurnRisk;

-- Churn Rate by Country
SELECT Country, ChurnRisk,COUNT(Customerid) AS Customers
FROM ChurnRiskLevel
GROUP BY Country, ChurnRisk
ORDER BY Country, ChurnRisk;

-- Churn Rate by Engagement
SELECT ActiveStatus, COUNT(CustomerId) AS TotalCustomers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(CustomerID) AS perc_by_row,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / (SELECT SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) 
    FROM CustomerDetails) AS perc_by_column
FROM CustomerDetails
GROUP BY ActiveStatus;

-- Churn Rate by Products
SELECT ProductCat,COUNT(Customerid) AS TotalCustomers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(CustomerID) AS perc_by_row,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / (SELECT SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) 
    FROM CustomerDetails) AS perc_by_column
FROM CustomerDetails
GROUP BY ProductCat
ORDER BY TotalCustomers DESC;

-- Churn Rate by Tenure
SELECT
    TenureCat,COUNT(Customerid) AS TotalCustomers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(CustomerID) AS perc_by_row,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / (SELECT SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) 
    FROM CustomerDetails) AS perc_by_column
FROM CustomerDetails
GROUP BY TenureCat
ORDER BY ChurnedCustomers DESC;

-- Churn Rate by CreditScore
SELECT
    CreditScoreCat,COUNT(Customerid) AS TotalCustomers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(CustomerID) AS perc_by_row,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / (SELECT SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) 
    FROM CustomerDetails) AS perc_by_column
FROM CustomerDetails
GROUP BY CreditScoreCat
ORDER BY ChurnedCustomers DESC;

-- Churn Rate by Balance
SELECT
    BalanceCat,COUNT(Customerid) AS TotalCustomers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(CustomerID) AS perc_by_row,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / (SELECT SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) 
    FROM CustomerDetails) AS perc_by_column
FROM CustomerDetails
GROUP BY BalanceCat
ORDER BY ChurnedCustomers DESC;


-- Churn by credit card
SELECT
    CreditCardStatus,COUNT(Customerid) AS TotalCustomers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(CustomerID) AS perc_by_row,
    100 * SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) / (SELECT SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) 
    FROM CustomerDetails) AS perc_by_column
FROM CustomerDetails
GROUP BY CreditCardStatus
ORDER BY ChurnedCustomers DESC;

-- Churn by Country, Agegroup and Engagement
SELECT 
    Country,
    AgeGroup,
    ActiveStatus,
    COUNT(CustomerId) AS TotalCustomers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers
FROM CustomerDetails
GROUP BY Country, AgeGroup, ActiveStatus
ORDER BY Country, ChurnedCustomers DESC;

-- ActiveStatus × Credit Card × Churn
SELECT 
    ActiveStatus,
    CreditCardStatus,
    COUNT(CustomerId) AS TotalCustomers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers
FROM CustomerDetails
GROUP BY ActiveStatus, CreditCardStatus
ORDER BY ChurnedCustomers DESC;


SELECT 
    Country,
    ChurnStatus,
    SUM(Balance) AS TotalBalance
FROM CustomerDetails
GROUP BY Country, ChurnStatus
ORDER BY Country;


With CustomerCounts AS
(
SELECT ChurnStatus,ActiveStatus, COUNT (CustomerId) AS No_of_Customers
FROM CustomerDetails
GROUP BY ChurnStatus,ActiveStatus
)
SELECT ChurnStatus,ActiveStatus, No_of_Customers,
Cast(No_of_Customers *100.0 /Sum(No_of_Customers) Over() AS Decimal(10,2)) As percentage_Total
FROM CustomerCounts











