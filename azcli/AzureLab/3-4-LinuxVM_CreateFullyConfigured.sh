#!/bin/bash

##############################################################################
## Linux VM: create a fully configured
##############################################################################

RG=LabXRG
VM_NAME=LabXVM03
VNET_NAME=$VM_NAME"Vnet"
SUBNET_NAME=$VM_NAME"Subnet"
IPPUBLIC_NAME=$VM_NAME"PublicIP"
NSG_NAME=$VM_NAME"NSG"
NIC_NAME=$VM_NAME"Nic"

# Create a virtual network
echo "--> Create a virtual network"
az network vnet create --resource-group $RG \
    --name $VNET_NAME \
    --subnet-name $SUBNET_NAME
read -p "Press any key to continue!"

# Create a public IP address
echo "--> Create a public IP address"
az network public-ip create -g $RG --name $IPPUBLIC_NAME
read -p "Press any key to continue!"

# Create a network security group
echo "--> Create a network security group"
az network nsg create -g $RG --name $NSG_NAME
read -p "Press any key to continue!"

# Create a virtual network card and associate with public IP address and NSG
echo "--> Create a virtual network card"
az network nic create -g $RG \
    --name $NIC_NAME \
    --vnet-name $VNET_NAME \
    --subnet $SUBNET_NAME \
    --network-security-group $NSG_NAME \
    --public-ip-address $IPPUBLIC_NAME
read -p "Press any key to continue!"

# Create a new virtual machine, this create SSH keys if not present
echo "--> Create a new VM"
az vm create -g $RG \
    --name $VM_NAME \
    --nics $NIC_NAME \
    --image CentOS \
    --generate-ssh-keys
read -p "Press any key to continue!"

# Open port 22 to allow SSh traffic to host
echo "--> Open port 22"
az vm open-port --port 22 -g $RG -n $VM_NAME
read -p "Press any key to continue!"

# Clean all resources
echo "--> Clean all resources"
./0-0-CleanAllResources.sh
