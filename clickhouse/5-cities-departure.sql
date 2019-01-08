SELECT OriginCityName, count() AS c, avg(DepDelay >  60) AS delays
FROM ontime
GROUP BY OriginCityName
HAVING c >  100000
ORDER BY delays DESC
LIMIT 20
;

