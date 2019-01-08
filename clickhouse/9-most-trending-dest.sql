SELECT
    DestCityName,
    sum(Year = 2014) AS c2014,
    sum(Year = 2015) AS c2015,
    c2015 / c2014 AS diff
FROM ontime
WHERE Year IN (2014, 2015)
GROUP BY DestCityName
HAVING c2014 >  10000 AND c2015 >  1000 AND diff >  1
ORDER BY diff DESC
;

