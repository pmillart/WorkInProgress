#!/bin/bash

##############################################################################
## Linux VM: create and attach data disks
##############################################################################

RG=LabXRG
VM_NAME=LabXVMDD01

# Attach disk at VM creation
echo "--> Attach disk at VM creation" 
az vm create \
  --resource-group $RG \
  --name $VM_NAME \
  --image UbuntuLTS \
  --size Standard_DS2_v2 \
  --generate-ssh-keys \
  --data-disk-sizes-gb 128 128
read -p "Press any key to continue!"

# Attach disk to existing VM
echo "Attach disk to existing VM"
az vm disk attach \
    --resource-group $RG \
    --vm-name $VM_NAME \
    --disk $VM_NAME"DataDisk03" \
    --size-gb 128 \
    --sku Premium_LRS \
    --new
