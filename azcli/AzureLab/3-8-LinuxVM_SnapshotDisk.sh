#!/bin/bash

##############################################################################
## Linux VM: snapshot disk
##############################################################################

RG=LabXRG
VM_NAME=LabXVMDD01
RESTOREVM_NAME=LabXVMDD01RESTORE
OSDISKSNAPSHOT_NAME=$VM_NAME"_OSDiskFromSnapShot"

# Create snapshot
echo "--> Create snapshot" 
osdiskid=$(az vm show -g $RG -n $VM_NAME --query "storageProfile.osDisk.managedDisk.id" -o tsv)
az snapshot create \
    --resource-group $RG \
    --source "$osdiskid" \
    --name osDisk-backup
read -p "Press any key to continue!"

# Create disk from snapshot
echo "Create disk from snapshot"
az disk create --resource-group $RG --name $OSDISKSNAPSHOT_NAME --source osDisk-backup
read -p "Press any key to continue!"

# Restore virtual machine from snapshot
echo "--> Restore virtual machine from snapshot"

echo "- Delete VM"
az vm delete -g $RG -n $VM_NAME
read -p "Press any key to continue!"

echo "- Create a new virtual machine from the snapshot disk"
az vm create \
    --resource-group $RG \
    --name $RESTOREVM_NAME \
    --attach-os-disk $OSDISKSNAPSHOT_NAME \
    --os-type linux
read -p "Press any key to continue!"

echo "- Reattach data disk"
#datadisk=$(az disk list -g $RG --query "[?contains(name,'$VM_NAME')].[name]" -o tsv)
#az vm disk attach –g $RG –-vm-name $RESTOREVM_NAME –-disk $datadisk
