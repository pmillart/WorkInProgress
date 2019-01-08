SELECT Carrier, count() AS c, round(quantileTDigest(0.99)(DepDelay), 2) AS q
FROM ontime GROUP BY Carrier ORDER BY q DESC
;

