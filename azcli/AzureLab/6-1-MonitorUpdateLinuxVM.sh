#!/bin/bash

##############################################################################
## Monitor & Update a Linux VM
##############################################################################

RG=LabXRG
LOC=francecentral
VM_NAME=LabXVM
STORAGE_NAME=labxstorage123

# Create VM
echo "--> Create VM"
az vm create \
  --resource-group $RG \
  --name $VM_NAME \
  --image UbuntuLTS \
  --admin-username labuser \
  --generate-ssh-keys
read -p "Press any key to continue!"

# Enable boot diagnostics
echo "--> Enable boot diagnostics"
az storage account create \
  --resource-group $RG \
  --name $STORAGE_NAME \
  --sku Standard_LRS \
  --location $LOC

bloburi=$(az storage account show --resource-group $RG --name $STORAGE_NAME --query 'primaryEndpoints.blob' -o tsv)

az vm boot-diagnostics enable \
  --resource-group $RG \
  --name $VM_NAME \
  --storage $bloburi
read -p "Press any key to continue!"

# View boot diagnostics
echo "--> View boot diagnostics - Deallocate VM"
az vm deallocate --resource-group $RG --name $VM_NAME
read -p "Press any key to continue!"

echo "--> View boot diagnostics - Start VM"
az vm start --resource-group $RG --name $VM_NAME
read -p "Press any key to continue!"

echo "--> View boot diagnostics - Get boot diagnostic"
az vm boot-diagnostics get-boot-log --resource-group $RG --name $VM_NAME
