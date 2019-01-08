SELECT
    DestCityName,
    any(total),
    avg(abs(monthly * 12 - total) / total) AS avg_month_diff
FROM
(
    SELECT DestCityName, count() AS total
    FROM ontime GROUP BY DestCityName HAVING total > 100000
)
ALL INNER JOIN
(
    SELECT DestCityName, Month, count() AS monthly
    FROM ontime GROUP BY DestCityName, Month HAVING monthly > 10000
)
USING DestCityName
GROUP BY DestCityName
ORDER BY avg_month_diff DESC
LIMIT 20
;
