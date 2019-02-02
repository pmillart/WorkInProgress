#!/bin/bash

##############################################################################
## Clean All Resources
##############################################################################

RG=LabXRG
LOC=francecentral

# Delete the resource group
az group delete -n $RG --yes

# Create the resource group
az group create -n $RG --location $LOC
echo "==> The Resource Group has been cleaned!"
