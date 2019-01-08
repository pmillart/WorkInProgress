SELECT Carrier, min(Year), max(Year), count()
FROM ontime GROUP BY Carrier HAVING max(Year) < 2015 ORDER BY count() DESC
;
