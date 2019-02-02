#!/bin/bash

##############################################################################
## Linux VM: capture image (part 2)
##############################################################################

RG=LabXRG
VM_NAME=LabXVM
IMAGE_NAME=LabXImage

# Deprovision the VM
echo "--> Deprovision the VM: Execute the command into the VM via SSH" 
# Connect ot the VM via SSH (ssh labuser@<public ip>)
# Type: sudo waagent -deprovision+user -force
# Exit
read -p "Press any key to continue!"

# Create VM image
echo "--> Create VM image" 
echo "  - Deallocate"
az vm deallocate --resource-group $RG --name $VM_NAME
read -p "Press any key to continue!"

echo "  - Generalize"
az vm generalize --resource-group $RG --name $VM_NAME
read -p "Press any key to continue!"

echo "  - Capture"
az image create --resource-group $RG --name $IMAGE_NAME --source $VM_NAME
read -p "Press any key to continue!"

echo "  - List"
az image list --output table
read -p "Press any key to continue!"

# Create a new VM from the captured image
echo "--> Create a new VM from the captured image"
az vm create \
   --resource-group $RG \
   --name $VM_NAME"New" \
   --image $IMAGE_NAME\
   --admin-username labuser \
   --ssh-key-value ~/.ssh/id_rsa.pub
read -p "Press any key to continue!"

# Verify the deployment
echo "--> Verify the deployment"
az vm show \
   --resource-group $RG \
   --name $VM_NAME"New" \
   --show-details
