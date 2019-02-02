#!/bin/bash

##############################################################################
## VM Network: create and update VNET
##############################################################################

RG=LabXRG
LOC=francecentral
VM_NAME=LabXVM

# Create virtual network
echo "--> Create virtual network" 
az network vnet create --resource-group $RG \
    --name $VM_NAME"_VNet" \
    --address-prefix 10.0.0.0/16 \
    --subnet-name $VM_NAME"_FrontEndSubnet" \
    --subnet-prefix 10.0.1.0/24
read -p "Press any key to continue!"

# Create subnet
echo "--> Create subnet" 
az network vnet subnet create --resource-group $RG \
    --vnet-name $VM_NAME"_VNet" \
    --name $VM_NAME"_BackEndSubnet" \
    --address-prefix 10.0.2.0/24
read -p "Press any key to continue!"

# Create a public IP address
echo "--> Create a public IP address" 
az network public-ip create --resource-group $RG \
    --name $VM_NAME"_PublicIP"
read -p "Press any key to continue!"

# Create network security group
echo "--> Create network security group" 
az network nsg create --resource-group $RG \
    --name $VM_NAME"_NSG"
read -p "Press any key to continue!"

# Update existing subnet
echo "--> Update existing subnet" 
az network vnet subnet update --resource-group $RG \
    --vnet-name $VM_NAME"_VNet" \
    --name $VM_NAME"_BackEndSubnet" \
    --network-security-group $VM_NAME"_NSG"
read -p "Press any key to continue!"

# Secure incoming traffic
echo "--> Secure incoming traffic" 
az network nsg rule create --resource-group $RG \
    --nsg-name $VM_NAME"_NSG" \
    --name http \
    --access allow \
    --protocol Tcp \
    --direction Inbound \
    --priority 200 \
    --source-address-prefix "*" \
    --source-port-range "*" \
    --destination-address-prefix "*" \
    --destination-port-range 80
read -p "Press any key to continue!"

# Check NSG configuration
echo "--> Check NSG configuration" 
az network nsg rule list --resource-group $RG \
    --nsg-name $VM_NAME"_NSG" \
    --output table
