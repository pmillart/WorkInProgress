export NVMe="/dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1"
export CLICKHOUSEDATA="/datadisk/clickhouse"
export CLICKHOUSELABEL="clickhouse-data"


echo "y"|mdadm --create /dev/md0 -f --level=0 --assume-clean --raid-devices=4 $NVMe
mdadm --monitor --daemonise /dev/md0
mkfs.ext4 -G 4096 -F /dev/md0
e2label /dev/md0 $CLICKHOUSELABEL

mkdir -p $CLICKHOUSEDATA
#Adding nofail: Si changemement de machine, les NVMe sont détruits et peuvent empecher de démarrer lle server
grep $CLICKHOUSELABEL /etc/fstab || echo "LABEL=$CLICKHOUSELABEL $CLICKHOUSEDATA ext4 rw,noatime,discard,nobarrier,nofail,data=ordered 0 0" >> /etc/fstab
mount  $CLICKHOUSEDATA

chown clickhouse:clickhouse $CLICKHOUSEDATA
