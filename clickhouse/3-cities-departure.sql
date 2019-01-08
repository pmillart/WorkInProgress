SELECT OriginCityName, uniq(Dest) AS u
FROM ontime GROUP BY OriginCityName ORDER BY u DESC LIMIT 20
;
