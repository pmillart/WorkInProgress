#!/bin/bash

##############################################################################
## Linux VM: automate configuration with secured access
##############################################################################

RG=LabXRG
VM_NAME=LabXVMSecuredCustom
KEYVAULT_NAME=labxkeyvault
CERT_NAME=mycert

# Create an azure Key Vault
echo "--> Create an azure Key Vault"
az keyvault create \
    --resource-group $RG \
    --name $KEYVAULT_NAME \
    --enabled-for-deployment
read -p "Press any key to continue!"

# Generate certificate and store in Key Vault
echo "--> Generate certificate and store in Key Vault"
az keyvault certificate create \
    --vault-name $KEYVAULT_NAME \
    --name $CERT_NAME \
    --policy "$(az keyvault certificate get-default-policy)"
read -p "Press any key to continue!"

# Prepare certificate for use with VM
echo "--> Prepare certificate for use with VM"
secret=$(az keyvault secret list-versions \
    --vault-name $KEYVAULT_NAME \
    --name $CERT_NAME \
    --query "[?attributes.enabled].id" --output tsv)
vm_secret=$(az vm secret format --secret "$secret")
read -p "Press any key to continue!"

# Create a secure VM
echo "--> Create a secure VM"
az vm create \
    --resource-group $RG \
    --name $VM_NAME \
    --image UbuntuLTS \
    --admin-username labuser \
    --generate-ssh-keys \
    --custom-data cloud-init-secured.txt \
    --secrets "$vm_secret"
read -p "Press any key to continue!"

# Open port 443 to allow Https traffic to host
echo "--> Open port 443"
az vm open-port --port 443 -g $RG --name $VM_NAME

# Test Web App: browse with a navigator https://{IPPublic}
