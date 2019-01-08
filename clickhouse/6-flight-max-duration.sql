SELECT OriginCityName, DestCityName, count(*) AS flights, avg(AirTime) AS duration
FROM ontime
GROUP BY OriginCityName, DestCityName
ORDER BY duration DESC
LIMIT 20
;
