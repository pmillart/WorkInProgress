#!/bin/bash

##############################################################################
## Load Balancing: use data disks with a VM Scale Set
##############################################################################

RG=LabXRG
LOC=francecentral
VM_NAME=LabXVMSS
SCALESET_NAME=$VM_NAME"_ScaleSet"

# Create a scale set with data disks
#echo "--> Create a scale set with data disks"
#az vmss create \
#    --resource-group $RG \
#    --name $SCALESET_NAME \
#    --image UbuntuLTS \
#    --upgrade-policy-mode automatic \
#    --custom-data cloud-init.txt \
#    --admin-username labuser \
#    --generate-ssh-keys \
#    --data-disk-sizes-gb 50
#read -p "Press any key to continue!"

# Add data disks on the Scale Set
echo "--> Add data disks on the Scale Set"
az vmss disk attach \
    --resource-group $RG \
    --name $SCALESET_NAME \
    --size-gb 50 \
    --lun 2
read -p "Press any key to continue!"

# Detach data disks on the Scale Set
echo "Detach data disks on the Scale Set"
az vmss disk detach \
    --resource-group $RG \
    --name $SCALESET_NAME \
    --lun 2