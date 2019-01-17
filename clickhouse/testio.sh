export CLICKHOUSEDATA="/datadisk/clickhouse"

sudo apt install fio

echo "[global]
size=30g
direct=1
iodepth=128
ioengine=libaio
bs=4k

[reader1]
rw=randread
directory=$CLICKHOUSEDATA
[reader2]
rw=randread
directory=$CLICKHOUSEDATA
[reader3]
rw=randread
directory=$CLICKHOUSEDATA
[reader4]
rw=randread
directory=$CLICKHOUSEDATA

[writer1]
rw=randwrite
directory=$CLICKHOUSEDATA
rate_iops=12500
[writer2]
rw=randwrite
directory=$CLICKHOUSEDATA
rate_iops=12500
[writer3]
rw=randwrite
directory=$CLICKHOUSEDATA
rate_iops=12500
[writer4]
rw=randwrite
directory=$CLICKHOUSEDATA
rate_iops=12500" > fioreadwrite.ini
sudo fio --runtime 30 fioreadwrite.ini
