SELECT * 
FROM dbo.listings;

--Data Exploration
SELECT DISTINCT room_type
FROM dbo.listings;

SELECT * 
FROM dbo.listings
WHERE neighbourhood_group IS NOT NULL;

SELECT * 
FROM dbo.listings
WHERE license IS NOT NULL;

--Data Cleaning
ALTER TABLE dbo.listings
DROP COLUMN neighbourhood_group;

ALTER TABLE dbo.listings
DROP COLUMN license;

ALTER TABLE dbo.listings
ALTER COLUMN price FLOAT;

--More Data Exploration
SELECT 
	ROUND(AVG(price),2) AS avg_price,
	MIN(price) AS min_price,
	MAX(price) AS max_price
FROM dbo.listings
WHERE availability_365 > 0

SELECT *
FROM dbo.listings
WHERE price = 1
--Most Expensive Neighbourhoods
SELECT 
	neighbourhood,
	ROUND(AVG(price),2) AS avg_price
FROM dbo.listings
GROUP BY neighbourhood
ORDER BY avg_price DESC;

--Most Popular Neighbourhoods
SELECT 
	neighbourhood,
	AVG(number_of_reviews) AS avg_num_of_reviews
FROM dbo.listings
GROUP BY neighbourhood
ORDER BY avg_num_of_reviews DESC;

--Number of Properties per Neighbourhood
SELECT 
	neighbourhood,
	COUNT(id) as total_listings
FROM dbo.listings
GROUP BY neighbourhood
ORDER BY total_listings DESC;

--Distribution of Room Types
SELECT
	COUNT(CASE WHEN room_type = 'Hotel room' THEN 1 END) AS Hotel_Count,
	COUNT(CASE WHEN room_type = 'Shared room' THEN 1 END) AS Shared_Count,
	COUNT(CASE WHEN room_type = 'Private room' THEN 1 END) AS Private_Count,
	COUNT(CASE WHEN room_type = 'Entire home/apt' THEN 1 END) AS Home_Count
FROM dbo.listings;

--Distribution of Availability
SELECT
	SUM(CASE WHEN availability_365 < 14 THEN 1 END) AS limited_availability,
	SUM(CASE WHEN availability_365 >= 14 AND availability_365 < 100 THEN 1 END) AS moderate_availability,
	SUM(CASE WHEN availability_365 >= 100 AND availability_365 <= 355 THEN 1 END) AS frequent_availability,
	SUM(CASE WHEN availability_365 = 365 THEN 1 END) AS always_available
FROM dbo.listings;

--Average Number of Properties Listed by Hosts
SELECT
	(CAST(COUNT(DISTINCT(id))AS FLOAT))/(CAST(COUNT(DISTINCT(host_id))AS FLOAT)) AS avg_listings_per_host
FROM dbo.listings;
