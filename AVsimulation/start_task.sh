# check pool
az batch account login --name testaccbatch --resource-group testaccbatch 

az batch pool show --pool-id testaccpool --query "allocationState"


az batch job create --id myjob --pool-id testaccpool

for i in {1..15}
do
   az batch task create --task-id mytask$i --job-id myjob --command-line "/bin/bash -c 'printenv | grep AZ_BATCH; sleep 60s'"
done

