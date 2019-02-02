#!/bin/bash

##############################################################################
## Linux VM: automate configuration
##############################################################################

RG=LabXRG
VM_NAME=LabXVMCustom

# Create a virtual machine custom
echo "--> Create a virtual machine custom"
az vm create \
    --resource-group $RG \
    --name $VM_NAME \
    --image UbuntuLTS \
    --admin-username labuser \
    --generate-ssh-keys \
    --custom-data cloud-init.txt
read -p "Press any key to continue!"

# Open port 80 to allow Http traffic to host
echo "--> Open port 80"
az vm open-port --port 80 -g $RG --name $VM_NAME

# Test Web App: browse with a navigator http://{IPPublic}
