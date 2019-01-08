SELECT DayOfWeek, count() AS c, avg(DepDelay >  60) AS delays
FROM ontime GROUP BY DayOfWeek ORDER BY DayOfWeek
;

