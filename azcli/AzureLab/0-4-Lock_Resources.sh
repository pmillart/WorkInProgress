#!/bin/bash

##############################################################################
## Lock: Lock and unclock a resource to prevent deletion
##############################################################################

RG=LabXRG
LOC=francecentral
RES_NAME=LabXVM

# Add CanNotDelete lock to the VM
echo "--> Add CanNotDelete lock to the VM"
az lock create --name LockVM \
  --lock-type CanNotDelete \
  --resource-group $RG \
  --resource-name $RES_NAME \
  --resource-type Microsoft.Compute/virtualMachines

# Add CanNotDelete lock to the network security group
echo "--> Add CanNotDelete lock to the network security group"
az lock create --name LockNSG \
  --lock-type CanNotDelete \
  --resource-group $RG \
  --resource-name $RES_NAME"NSG" \
  --resource-type Microsoft.Network/networkSecurityGroups
read -p "Press any key to continue!"

# Try to delete the resource group
echo "--> Try to delete the resource group"
az group delete --name $RG
read -p "Press any key to continue!"

# Unlock resources
echo "--> Unlock resources"
vmlock=$(az lock show --name LockVM \
  --resource-group $RG \
  --resource-type Microsoft.Compute/virtualMachines \
  --resource-name $RES_NAME --output tsv --query id)
nsglock=$(az lock show --name LockNSG \
  --resource-group $RG \
  --resource-type Microsoft.Network/networkSecurityGroups \
  --resource-name $RES_NAME"NSG" --output tsv --query id)
az lock delete --ids $vmlock $nsglock
read -p "Press any key to continue!"

# Retry to delete the resource group
echo "--> Retry to delete the resource group"
az group delete --name $RG
