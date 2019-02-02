#!/bin/bash

##############################################################################
## Load Balancing: create a VM Scale Set
##############################################################################

RG=LabXRG
LOC=francecentral
VM_NAME=LabXVMSS
SCALESET_NAME=$VM_NAME"_ScaleSet"
LB_NAME=$VM_NAME"_ScaleSetLB"
LBRULE_NAME=$VM_NAME"_ScaleSetLBRule"
IPPUBLIC_NAME=$VM_NAME"_ScaleSetLBPublicIP"
IPFRONT_NAME="loadBalancerFrontEnd"
IPBACK_NAME=$VM_NAME"_ScaleSetLBBEPool"

# Create a scale set
echo "--> Create a scale set"
az vmss create \
    --resource-group $RG \
    --name $SCALESET_NAME \
    --image UbuntuLTS \
    --upgrade-policy-mode automatic \
    --custom-data cloud-init.txt \
    --admin-username labuser \
    --generate-ssh-keys
read -p "Press any key to continue!"

# Create a load balancer rule
echo "--> Create a load balancer rule"
az network lb rule create \
    --resource-group $RG \
    --name $LBRULE_NAME \
    --lb-name $LB_NAME \
    --backend-pool-name $IPBACK_NAME \
    --backend-port 80 \
    --frontend-ip-name $IPFRONT_NAME \
    --frontend-port 80 \
    --protocol tcp
read -p "Press any key to continue!"

# Test load balancer of VM Scale Set
echo "--> Test load balancer of the VM Scale Set"
ippublic=$(az network public-ip show -g $RG -n $IPPUBLIC_NAME --query [ipAddress] --output tsv)
echo "Test Load Balancer of the VM Scale Set: browse with a navigator http://"$ippublic
