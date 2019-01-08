SELECT OriginCityName, count(*) AS flights
FROM ontime GROUP BY OriginCityName ORDER BY flights DESC LIMIT 20;

