#!/bin/bash

##############################################################################
## VM Network: create and update VNIC
##############################################################################

RG=LabXRG
LOC=francecentral
VM_NAME=LabXVM

# Create a virtual NIC
echo "--> Create a virtual NIC"
az network nic create \
    --resource-group $RG \
    --name $VM_NAME"_VNIC" \
    --vnet-name $VM_NAME"_VNet" \
    --subnet $VM_NAME"_BackEndSubnet" \
    --public-ip-address $VM_NAME"_PublicIP" \
    --network-security-group $VM_NAME"_NSG"
read -p "Press any key to continue!"

# Create a VM with previous NIC
echo "--> Create a VM with previous NIC"
az vm create \
    --resource-group $RG \
    --name $VM_NAME \
    --image CentOS \
    --size Standard_DS4_v2 \
    --admin-username labuser \
    --generate-ssh-keys \
    --nics $VM_NAME"_VNIC"
# Open SSH port
az vm open-port --port 22 -g $RG -n $VM_NAME
read -p "Press any key to continue!"

# Enable Accelerated Networking on existing VM
echo "--> Enable Accelerated Networking on existing VM"
echo "  - Deallocate the VM"
az vm deallocate --resource-group $RG --name $VM_NAME
echo "  - Update NIC with accelerated networking option"
az network nic update --name $VM_NAME"_VNIC" --resource-group $RG --accelerated-networking true
echo "  - Start VM"
az vm start --resource-group $RG --name $VM_NAME
# Check the accelerated netwoking on the vm
# ssh labuser@<your-public-ip-address>
# Command to check device (Mellanox VF): lspci
# Check activity: ethtool -S eth0 | grep vf_
