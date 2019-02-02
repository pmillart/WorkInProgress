#!/bin/bash

##############################################################################
## Availability: create VMs in an availability set
##############################################################################

RG=LabXRG
AS_NAME=LabXAvailabilitySet
VM_NAME=LabXVMAS
VNET_NAME=LabXVNet
SUBNET_NAME=LabXSubNet

# Create an availability set
echo "Create an availability set"
az vm availability-set create --resource-group $RG \
    --name $AS_NAME \
    --platform-fault-domain-count 2 \
    --platform-update-domain-count 2
read -p "Press any key to continue!"

# Create VMs inside an availability set
echo "Create 2 VM placed on the availability set"
for i in `seq 1 2`; do
    az vm create -g $RG \
        --name $VM_NAME$i \
        --availability-set $AS_NAME \
        --size Standard_DS1_v2 \
        --vnet-name $VNET_NAME \
        --subnet $SUBNET_NAME \
        --image CentOS \
        --admin-username labxuser \
        --generate-ssh-keys
    done
read -p "Press any key to continue!"

# Check for available VM sizes
echo "List all VM sizes for the availability set"
az vm availability-set list-sizes -g $RG --name $AS_NAME --output table
