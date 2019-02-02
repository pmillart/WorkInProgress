#!/bin/bash

##############################################################################
## Linux VM: quick create with specific size
##############################################################################

RG=LabXRG
LOC=francecentral
VM_NAME=LabXVM02

# List all available VM sizes
echo "--> List all available VM sizes"
az vm list-sizes --location $LOC --output table
read -p "Press any key to continue!"

# Quick create a VM with specific size
echo "--> Quick create a VM with specific size"
az vm create --resource-group $RG --name $VM_NAME --image CentOS --size Standard_F4s --generate-ssh-keys
read -p "Press any key to continue!"

# Show the current size of the VM
echo "--> Show the current size of the VM"
az vm show -g $RG -n $VM_NAME --query hardwareProfile.vmSize
read -p "Press any key to continue!"

# Check if the desired size is available on the current Azure cluster
echo "--> Check if desired size is available on the current Azure cluster"
az vm list-vm-resize-options -g $RG -n $VM_NAME --query [].name
read -p "Press any key to continue!"

# Resize the VM (Warning the VM will reboot during the operation)
echo "--> Resize the VM"
az vm resize -g $RG -n $VM_NAME --size Standard_DS4_v2

# Resize the VM:
#   if the desired size is not on the current cluster, the VM needs to be deallocated before the resize operation can occur
#echo "--> Quick create a VM with specific size"
#az vm deallocate --resource-group LabXRG --name LabXVM02
#az vm resize --resource-group LabXRG --name LabXVM02 --size Standard_GS1
#az vm start --resource-group LabXRG --name LabXVM02
