SELECT *
FROM dbo.City

SELECT *
FROM dbo.Customer_ID

SELECT *
FROM dbo.Taxi_Data

SELECT *
FROM dbo.Transaction_ID

--Cleaning the Data

ALTER TABLE dbo.City
ALTER COLUMN Users int

ALTER TABLE dbo.City
ALTER COLUMN Population int

ALTER TABLE dbo.Taxi_Data
ALTER COLUMN Date_of_Travel DATE

--Percentage of the Population that uses the Taxi
SELECT
	City, 
	(CONVERT(float,Users)/CONVERT(float,Population))*100 AS User_Percentage
FROM dbo.City
ORDER BY User_Percentage DESC;


--Payment Mode Distribution
SELECT
	Payment_Mode,
	COUNT(*) AS Sum_of_Payment_Type,
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER (),2)AS Percent_of_Total
FROM dbo.Transaction_ID
GROUP BY Payment_Mode



--Gender Distribution
SELECT
	Gender,
	COUNT(*) AS Sum_of_Gender,
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER (),2)AS Percent_of_Total
FROM dbo.Customer_ID
GROUP BY Gender


--Average Age of Taxi Customer By City and Gender
SELECT
	dbo.Taxi_Data.City AS City,
	dbo.Customer_ID.Gender AS Gender,
	ROUND(AVG(CAST(dbo.Customer_ID.Age AS FLOAT)),2) AS AVG_Age
FROM	
	 dbo.Customer_ID 
	 JOIN dbo.Transaction_ID
		ON dbo.Customer_ID.Customer_ID = dbo.Transaction_ID.Customer_ID
	 JOIN dbo.Taxi_Data
		ON dbo.Transaction_ID.Transaction_ID = dbo.Taxi_Data.Transaction_ID
GROUP BY City, Gender
ORDER BY City

--Average Income of Customers Per City
SELECT
	dbo.Taxi_Data.City AS City,
	ROUND(AVG(CAST(dbo.Customer_ID.Income AS FLOAT)),2) AS AVG_Income
FROM	
	 dbo.Customer_ID
	 JOIN dbo.Transaction_ID
		ON dbo.Customer_ID.Customer_ID = dbo.Transaction_ID.Customer_ID
	 JOIN dbo.Taxi_Data
		ON dbo.Transaction_ID.Transaction_ID = dbo.Taxi_Data.Transaction_ID
GROUP BY City
ORDER BY AVG_Income DESC

--Calculating Total Transactions Per City/Company
SELECT 
	City, Company, 
	COUNT(*) AS Total_Transactions,
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER (),2)AS Percent_of_Total
FROM dbo.Taxi_Data
GROUP BY City, Company
ORDER BY City, Company

--Calculating Average Profit Per Cab Ride Per City/Company
SELECT City, Company, 
	ROUND(AVG(CAST(Price_Charged AS FLOAT)),2) AS AVG_Price_Charged,
	ROUND(AVG(CAST(Cost_of_Trip AS FLOAT)),2) AS AVG_Cost_to_Company,
	(ROUND(AVG(CAST(Price_Charged AS FLOAT)),2))-(ROUND(AVG(CAST(Cost_of_Trip AS FLOAT)),2)) AS AVG_Profit_Per_Trip
FROM dbo.Taxi_Data
GROUP BY City, Company
ORDER BY City, Company

--Calculating Total Cost, Total Revenue, Total Profit, and Profit Margin Per Company
SELECT Company,
	ROUND(SUM(CAST(Price_Charged AS FLOAT)),2) AS Total_Cost,
	ROUND(SUM(CAST(Cost_of_Trip AS FLOAT)),2) AS Total_Revenue,
	(ROUND(SUM(CAST(Price_Charged AS FLOAT)),2))-(ROUND(SUM(CAST(Cost_of_Trip AS FLOAT)),2)) AS Total_Profit,
	ROUND(((SUM(CAST(Price_Charged AS FLOAT)))-(SUM(CAST(Cost_of_Trip AS FLOAT))))/(SUM(CAST(Cost_of_Trip AS FLOAT)))*100,2) AS Profit_Margin
FROM dbo.Taxi_Data
GROUP BY Company
ORDER BY Total_Profit DESC

--Calculating Total Cost, Total Revenue, Total Profit, and Profit Margin Per Company and City
SELECT Company, City,
	ROUND(SUM(CAST(Price_Charged AS FLOAT)),2) AS Total_Revenue,
	ROUND(SUM(CAST(Cost_of_Trip AS FLOAT)),2) AS Total_Cost,
	(ROUND(SUM(CAST(Price_Charged AS FLOAT)),2))-(ROUND(SUM(CAST(Cost_of_Trip AS FLOAT)),2)) AS Total_Profit,
	 ROUND(((SUM(CAST(Price_Charged AS FLOAT))) - (SUM(CAST(Cost_of_Trip AS FLOAT))))/(SUM(CAST(Price_Charged AS FLOAT)))*100,2) AS Profit_Margin
FROM dbo.Taxi_Data
GROUP BY Company, City
ORDER BY Company DESC


--Taxi Rides Each Day 2016-2018
SELECT 
	Date_of_Travel, Company,
	COUNT(Date_of_Travel) AS Num_of_Rides
FROM dbo.Taxi_Data
GROUP BY Date_of_Travel, Company
ORDER BY Date_of_Travel, Company


--Timeline of Profit Margins per Company
SELECT 
	Date_of_Travel, Company,
	COUNT(Date_of_Travel) AS Num_of_Rides,
	ROUND(SUM(CAST(Price_Charged AS FLOAT)),2) AS Daily_Cost,
	ROUND(SUM(CAST(Cost_of_Trip AS FLOAT)),2) AS Daily_Revenue,
	(ROUND(SUM(CAST(Price_Charged AS FLOAT)),2))-(ROUND(SUM(CAST(Cost_of_Trip AS FLOAT)),2)) AS Daily_Profit,
	ROUND(((SUM(CAST(Price_Charged AS FLOAT)))-(SUM(CAST(Cost_of_Trip AS FLOAT))))/(SUM(CAST(Cost_of_Trip AS FLOAT)))*100,2) AS Daily_Profit_Margin
FROM dbo.Taxi_Data
GROUP BY Date_of_Travel, Company
ORDER BY Date_of_Travel, Company

--Market Share Per Company
SELECT
	Company,
	ROUND(SUM(CAST(Price_Charged AS FLOAT)),2) AS Revenue,
	ROUND(SUM(CAST(Price_Charged AS FLOAT))/(
										SELECT ROUND(SUM(CAST(Price_Charged AS FLOAT)),2)
										FROM dbo.Taxi_Data)*100,2) AS Market_Share
FROM dbo.Taxi_Data
GROUP BY Company

