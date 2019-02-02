#!/bin/bash

##############################################################################
## Linux VM: quick create
##############################################################################

RG=LabXRG
VM_NAME=LabXVM01

# List VM images
echo "--> List VM images" 
az vm image list --output table
read -p "Press any key to continue!"

# List CentOS VM images only (wait a few seconds)
echo "--> List CentOS VM images only" 
az vm image list --offer CentOS --all --output table
read -p "Press any key to continue!"

# Quick create a VM
echo "--> Quick create VM" 
az vm create --resource-group $RG --name $VM_NAME --image CentOS --admin-username labuser --generate-ssh-keys
