#!/bin/bash

##############################################################################
## Resource Group: create, list and delete
##############################################################################

RG=LabXRG
LOC=francecentral
RES_NAME=LabXResource

# Create a resource group
echo "--> Create a resource group"
az group create --name $RG --location $LOC
read -p "Press any key to continue!"

# List all resource groups
echo "--> List all resource groups"
az group list --output table
read -p "Press any key to continue!"

# Delete a resource group
echo "--> Delete resource group"
az group delete -n $RG --yes
echo "Resource Group deleted!"
read -p "Press any key to continue!"

# Recreate the same resource group for the suite
echo "--> Recreate the resource group for the suite..."
az group create --name $RG --location $LOC
echo "Recreate the same Resource Group for the suite..."
