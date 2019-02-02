#!/bin/bash

##############################################################################
## Load Balancing: manage tasks of a VM Scale Set
##############################################################################

RG=LabXRG
LOC=francecentral
VM_NAME=LabXVMSS
SCALESET_NAME=$VM_NAME"_ScaleSet"

# View VMs in the Scale Set
echo "--> View VMs in the Scale Set"
az vmss list-instances \
  --resource-group $RG \
  --name $SCALESET_NAME \
  --output table
read -p "Press any key to continue!"

# Show the scale set capacity
echo "--> Show the scale set capacity"
az vmss show \
    --resource-group $RG \
    --name $SCALESET_NAME \
    --query [sku.capacity] \
    --output table
read -p "Press any key to continue!"

# Manually increase VM instances
echo "--> Manually increase VM instances"
az vmss scale \
    --resource-group $RG \
    --name $SCALESET_NAME \
    --new-capacity 3
read -p "Press any key to continue!"

# Get connection information
echo "--> Get connection info"
az vmss list-instance-connection-info \
    --resource-group $RG \
    --name $SCALESET_NAME
