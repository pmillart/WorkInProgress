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
container_name="labx-prod-container-001"
blob_name="newfile.pptx"
file_to_upload="azurelab.pptx"
destination_file="~/mypptx.pptx"

# Upload file
echo "--> Uploading the file on the storage account" 
az storage blob upload --container-name $container_name --file $file_to_upload --name $blob_name
read -p "Press any key to continue!"

# List blob
echo "--> List blobs on the storage account" 
az storage blob list --container-name $container_name --output table
read -p "Press any key to continue!"

# Downlink file
echo "--> Download the file from the storage account" 
az storage blob download --container-name $container_name --name $blob_name --file $destination_file --output table
