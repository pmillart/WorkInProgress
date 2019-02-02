#!/bin/bash

##############################################################################
## Load Balancing: remove a VM from the load balancer
##############################################################################

RG=LabXRG
LOC=francecentral
VM_NAME=LabXVM
LB_NAME=$VM_NAME"_LoadBalancer"
IPBACK_NAME=$VM_NAME"_IPBackEndPool"
VNET_NAME=$VM_NAME"_VNet"
NIC_NAME=$VM_NAME"_NIC"

# Remove a VM from the load balancer
echo "--> Remove a VM from the load balancer"
az network nic ip-config address-pool remove \
    --resource-group $RG \
    --nic-name $NIC_NAME"2" \
    --ip-config-name ipConfig1 \
    --lb-name $LB_NAME \
    --address-pool $IPBACK_NAME

az network lb address-pool show \
    --resource-group $RG \
    --lb-name $LB_NAME \
    --name $IPBACK_NAME \
    --query backendIpConfigurations \
    --output tsv | cut -f4
