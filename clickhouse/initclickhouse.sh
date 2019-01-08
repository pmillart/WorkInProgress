export NVMe="/dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1"
export CLICKHOUSEDATA="/home/patrick/clickhouse"
export CLICKHOUSELABEL="clickhouse-data"


echo "y"|mdadm --create /dev/md0 -f --level=0 --assume-clean --raid-devices=4 $NVMe
mdadm --monitor --daemonise /dev/md0
mkfs.ext4 -F /dev/md0
e2label /dev/md0 $CLICKHOUSELABEL

mkdir -p $CLICKHOUSEDATA
echo "LABEL=$CLICKHOUSELABEL $CLICKHOUSEDATA ext4 rw,relatime,nobarrier,nofail,stripe=512,data=ordered 0 0" >> /etc/fstab
mount  $CLICKHOUSEDATA

chown clickhouse:clickhouse $CLICKHOUSEDATA
