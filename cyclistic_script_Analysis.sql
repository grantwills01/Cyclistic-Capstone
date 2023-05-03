#found that start_station_id 13022 occurs most frequently
SELECT
	start_station_id,
    cnt,
    DENSE_RANK() OVER(
		ORDER BY cnt DESC
	) as rnk
FROM
	(
		SELECT start_station_id, count(*) as cnt
		FROM cyclistic_db.all_tripdata
		GROUP BY start_station_id
	)x


#calculate average distance of each ride in meters and average length of each ride in minutes
SELECT member_casual, ROUND(AVG(ride_distance),0) as avg_ride_distance, CAST(ROUND(AVG(ride_length),0) AS TIME) as avg_ride_length
FROM cyclistic_db.all_tripdata
GROUP BY member_casual

#calculate which days of the week casuals and members prefer to ride
SELECT week_day, count(member_casual) as count
FROM cyclistic_db.all_tripdata
WHERE member_casual LIKE 'casual%'
GROUP BY week_day
ORDER BY week_day

#how many members and casuals use the service each month
SELECT MONTHNAME(started_at) AS month, count(member_casual) as count
FROM cyclistic_db.all_tripdata
WHERE member_casual LIKE 'member%'
GROUP BY month