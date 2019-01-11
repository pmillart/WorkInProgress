clickhouse-client  < create.sql
xz -v -c -d < /datadisk/clickhouse/ontime.csv.xz | clickhouse-client --query="INSERT INTO ontime FORMAT CSV"
