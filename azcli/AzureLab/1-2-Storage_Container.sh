#!/bin/bash

##############################################################################
## Storage container: create, list and delete
##############################################################################

RG=LabXRG
LOC=francecentral
STORAGE_NAME=labxstorage123

# Set variables of the storage account
export AZURE_STORAGE_ACCOUNT=$STORAGE_NAME
export AZURE_STORAGE_ACCESS_KEY={primary_key}

# Create some test containers
echo "--> Create 3 containers on the storage account"
az storage container create --name labx-test-container-001
az storage container create --name labx-test-container-002
az storage container create --name labx-prod-container-001
read -p "Press any key to continue!"

# List only the containers with a specific prefix
echo "--> List all containers on the storage account"
az storage container list --prefix "labx-test-" --query "[*].[name]" --output tsv
read -p "Press any key to continue!"

# Delete all containers start with "labx-test-"
echo "--> Delete all containers start with labx-test-"
for container in `az storage container list --prefix "labx-test-" --query "[*].[name]" --output tsv`; do
    az storage container delete --name $container
    done
read -p "Press any key to continue!"

# List all containers
echo "--> List all containers of the storage account"
az storage container list --output table
read -p "Press any key to continue!"
