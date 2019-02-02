#!/bin/bash

##############################################################################
## Storage account: create, list, delete and renew keys
##############################################################################

RG=LabXRG
LOC=francecentral
STORAGE_NAME=labxstorage123

# Create a general-purpose standard storage account
echo "--> Create a standard storage account"
az storage account create --name $STORAGE_NAME --resource-group $RG --location $LOC --sku Standard_RAGRS --encryption blob
read -p "Press any key to continue!"

# List the storage account access keys
echo "--> List keyx of the storage account"
az storage account keys list -g $RG --account-name $STORAGE_NAME
read -p "Press any key to continue!"

# Renew (rotate) the PRIMARY access key
echo "--> Renew the primary key of the storage account"
az storage account keys renew -g $RG --account-name $STORAGE_NAME --key primary
read -p "Press any key to continue!"

# Renew (rotate) the SECONDARY access key
echo "--> Renew the secondary key of the storage account"
az storage account keys renew -g $RG --account-name $STORAGE_NAME --key secondary
read -p "Press any key to continue!"

# Delete the storage account
echo "--> Delete Storage account -> type 'no'!"
az storage account delete -g $RG -n $STORAGE_NAME
echo "Storage account not deleted because it's reuse!"
