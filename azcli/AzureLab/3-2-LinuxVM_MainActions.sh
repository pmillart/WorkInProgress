#!/bin/bash

##############################################################################
## Linux VM: main actions and properties
##############################################################################

RG=LabXRG
VM_NAME=LabXVM01

# Get IP address
echo "--> Get IP address" 
az vm list-ip-addresses --resource-group $RG --name $VM_NAME --output table
read -p "Press any key to continue!"

# Open port 80
echo "--> Open port 80" 
az vm open-port --port 80 -g $RG -n $VM_NAME
read -p "Press any key to continue!"

# Find the power state
echo "--> Show power state" 
az vm get-instance-view -g $RG -n $VM_NAME --query instanceView.statuses[1] --output table
read -p "Press any key to continue!"

# Stop virtual machine
echo "--> Stop VM" 
az vm stop -g $RG -n $VM_NAME
read -p "Press any key to continue!"

# List VM with details
echo "--> List VM with details" 
az vm list -g $RG -d
read -p "Press any key to continue!"

# Start virtual machine
echo "--> Start VM" 
az vm start -g $RG -n $VM_NAME
read -p "Press any key to continue!"

# Add CanNotDelete lock to the VM
echo "--> Add CanNotDelete lock to the VM" 
az lock create --name LockVM \
  --lock-type CanNotDelete \
  --resource-group $RG \
  --resource-name $VM_NAME \
  --resource-type Microsoft.Compute/virtualMachines
read -p "Press any key to continue!"

# Delete the VM
echo "--> Delete VM" 
az vm delete -g $RG -n $VM_NAME --yes
read -p "Press any key to continue!"

# Delete Lock on the VM
echo "--> Delete lock on the VM" 
vmlock=$(az lock show --name LockVM \
  --resource-group $RG \
  --resource-type Microsoft.Compute/virtualMachines \
  --resource-name $VM_NAME --output tsv --query id)
az lock delete --ids $vmlock
read -p "Press any key to continue!"

# Retry delete the VM
echo "--> Retry delete VM" 
az vm delete -g $RG -n $VM_NAME --yes
