#!/bin/bash

##############################################################################
## Load Balancing: create a standard load balancing
##############################################################################

RG=LabXRG
LOC=francecentral
VM_NAME=LabXVM
IPPUBLIC_NAME=$VM_NAME"_IPPublic"
LB_NAME=$VM_NAME"_LoadBalancer"
IPFRONT_NAME=$VM_NAME"_IPFrontEndPool"
IPBACK_NAME=$VM_NAME"_IPBackEndPool"
HEALTHPROBE_NAME=$VM_NAME"_HealthProbe"
LBRULE_NAME=$VM_NAME"_LoadBalancerRule"
VNET_NAME=$VM_NAME"_VNet"
SUBNET_NAME=$VM_NAME"_SubNet"
NSG_NAME=$VM_NAME"_NSG"
NSGRULE_NAME=$VM_NAME"_NSGRule"
NIC_NAME=$VM_NAME"_NIC"
AS_NAME=$VM_NAME"_AvailabilitySet"

# Create a public IP address
echo "--> Create a public IP address"
az network public-ip create \
    --resource-group $RG \
    --name $IPPUBLIC_NAME
read -p "Press any key to continue!"

# Create a load balancer
echo "--> Create a load balancer"
az network lb create \
    --resource-group $RG \
    --name $LB_NAME \
    --frontend-ip-name $IPFRONT_NAME \
    --backend-pool-name $IPBACK_NAME \
    --public-ip-address $IPPUBLIC_NAME
read -p "Press any key to continue!"

# Create a health probe
echo "--> Create a health probe"
az network lb probe create \
    --resource-group $RG \
    --lb-name $LB_NAME \
    --name $HEALTHPROBE_NAME \
    --protocol tcp \
    --port 80
read -p "Press any key to continue!"

# Create a load balancer rule
echo "--> Create a load balancer rule"
az network lb rule create \
    --resource-group $RG \
    --lb-name $LB_NAME \
    --name $LBRULE_NAME \
    --protocol tcp \
    --frontend-port 80 \
    --backend-port 80 \
    --frontend-ip-name $IPFRONT_NAME \
    --backend-pool-name $IPBACK_NAME \
    --probe-name $HEALTHPROBE_NAME
read -p "Press any key to continue!"

# Create network resources
echo "--> Create network resources"
echo " - Create a virtual network"
az network vnet create \
    --resource-group $RG \
    --name $VNET_NAME \
    --subnet-name $SUBNET_NAME

echo " - Create a network security group"
az network nsg create \
    --resource-group $RG \
    --name $NSG_NAME

echo " - Create a network security group rule"
az network nsg rule create \
    --resource-group $RG \
    --nsg-name $NSG_NAME \
    --name $NSGRULE_NAME \
    --priority 1001 \
    --protocol tcp \
    --destination-port-range 80

echo " - Create network interfaces"
for i in `seq 1 3`; do
    az network nic create \
        --resource-group $RG \
        --name $NIC_NAME$i \
        --vnet-name $VNET_NAME \
        --subnet $SUBNET_NAME \
        --network-security-group $NSG_NAME \
        --lb-name $LB_NAME \
        --lb-address-pools $IPBACK_NAME
done
read -p "Press any key to continue!"

# Create virtual machines
echo "--> Create an availability set"
az vm availability-set create \
    --resource-group $RG \
    --name $AS_NAME

echo "--> Create virtual machines"
for i in `seq 1 3`; do
    az vm create \
        --resource-group $RG \
        --name $VM_NAME$i \
        --availability-set $AS_NAME \
        --nics $NIC_NAME$i \
        --image UbuntuLTS \
        --admin-username labuser \
        --generate-ssh-keys \
        --custom-data cloud-init.txt \
        --no-wait
done
read -p "Press any key to continue!"

# Test load balancer
echo "--> Test load balancer"
ippublic=$(az network public-ip show -g $RG -n $IPPUBLIC_NAME --query [ipAddress] --output tsv)
echo "Test Load Balancer: browse with a navigator http://"$ippublic
