SELECT
    OriginCityName,
    DestCityName,
    count(*) AS flights,
    bar(flights, 0, 20000, 40)
FROM ontime WHERE Year = 2015 GROUP BY OriginCityName, DestCityName ORDER BY flights DESC LIMIT 20
;

