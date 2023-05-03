#Name: Grant Wills
#Project: Google Capstone / Cyclistic
#Date: March 25, 2023

#Documentation of all data cleaning and manipulation

# quickly load each csv file into a new table
set global local_infile =1;

use cyclistic_db;

load data local infile '\\Raw Data\\202302-divvy-tripdata\\202302-divvy-tripdata.csv'
into table `2023_02-tripdata`
fields terminated by ','
ignore 1 rows;


#Combining 12 months of trip data into one table
INSERT INTO `all_tripdata`
SELECT * 
FROM (
	SELECT *
	FROM `2022_03-tripdata`
	UNION ALL
	SELECT *
	FROM `2022_04-tripdata`
    UNION ALL
    SELECT *
    FROM `2022_05-tripdata`
    UNION ALL
	SELECT *
	FROM `2022_06-tripdata`
	UNION ALL
	SELECT *
	FROM `2022_07-tripdata`
    UNION ALL
    SELECT *
    FROM `2022_08-tripdata`
    UNION ALL
    SELECT *
	FROM `2022_09-tripdata`
	UNION ALL
	SELECT *
	FROM `2022_10-tripdata`
    UNION ALL
    SELECT *
    FROM `2022_11-tripdata`
    UNION ALL
    SELECT *
	FROM `2022_12-tripdata`
	UNION ALL
	SELECT *
	FROM `2023_01-tripdata`
    UNION ALL
    SELECT *
    FROM `2023_02-tripdata`
) a 


#Create column for length of each trip in time. NOTE: 101 entries have a negative ride_length, so they have been removed from the table
ALTER TABLE `all_tripdata`
ADD COLUMN ride_length time;

SET SQL_SAFE_UPDATES = 0;
UPDATE `all_tripdata` SET ride_length = TIMEDIFF(ended_at, started_at);

DELETE FROM `all_tripdata`
WHERE ride_length < 0;


#Create column for day of week of each trip (1=Sunday, 7=Saturday)
ALTER TABLE `all_tripdata`
ADD COLUMN week_day int;

UPDATE `all_tripdata` SET week_day = DAYOFWEEK(started_at);


#Create column for the distance of each trip using latitude and longitude coordinates (in meters rounded to 2 decimal places)
ALTER TABLE `all_tripdata`
ADD COLUMN ride_distance double;

UPDATE `all_tripdata` SET ride_distance = ROUND(ST_Distance_Sphere(point(start_lng,start_lat), point(end_lng,end_lat)),2);


#Remove 5,411 entries with ride lengths exceeding 24 hours. Most of these are casual users so they likely didn't know the meter was running
DELETE FROM `all_tripdata`
WHERE ride_length > '24:00:00'

