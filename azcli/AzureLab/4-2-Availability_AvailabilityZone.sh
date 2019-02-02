#!/bin/bash

##############################################################################
## Availability: create a VM in an availability zone
##############################################################################

RG=LabXRG
LOC=francecentral
VM_NAME=LabXVM04

# Check VM SKU availability
echo "Check VM SKU availability"
az vm list-skus --location $LOC --output table
read -p "Press any key to continue!"

# Create virtual machine in a specific zone
echo "Create virtual machine in a specific zone"
az vm create --resource-group $RG \
    --name $VM_NAME \
    --location $LOC \
    --image CentOS \
    --generate-ssh-keys \
    --zone 1
read -p "Press any key to continue!"

# Confirm zone for managed disk
echo "Confirm zone for managed disk"
osdiskname=$(az vm show -g $RG -n $VM_NAME --query 'storageProfile.osDisk.name' -o tsv)
az disk show -g $RG --name $osdiskname
read -p "Press any key to continue!"

# Confirm zone for IP address
echo "Confirm zone for IP address"
ipaddressname=$(az vm list-ip-addresses -g $RG -n $VM_NAME --query "[].virtualMachine.network.publicIpAddresses[].name" -o tsv)
az network public-ip show -g $RG --name $ipaddressname
read -p "Press any key to continue!"
