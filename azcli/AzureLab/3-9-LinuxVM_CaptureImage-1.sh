#!/bin/bash

##############################################################################
## Linux VM: capture image (part 1)
##############################################################################

RG=LabXRG
VM_NAME=LabXVM
IMAGE_NAME=LabX_Image

# Quick create a VM
echo "--> Quick create VM" 
az vm create --resource-group $RG --name $VM_NAME --image CentOS --admin-username labuser --generate-ssh-keys
