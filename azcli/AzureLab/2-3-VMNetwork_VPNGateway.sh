#!/bin/bash

##############################################################################
## VM Network: create and manage VPN Gateway
##############################################################################

RG=LabXRG
LOC=francecentral
VNET_NAME=LabXVNet1
ADDRESSSPACE=10.11.0.0/16
SUBTNET_NAME=LabXSubnet1
SUBNET=10.11.0.0/24
GATEWAYSUBNET=10.11.255.0/27
LocalNetworkGatewayName=LabXSite2
GatewayName=LabXVNet1GW
GatewaySubnet=LabXGatewaySubnet
PublicIP=LabXVNet1GWIP
VPNType=RouteBased

# Create virtual network
echo "--> Create virtual network" 
az network vnet create --resource-group $RG \
    --name $VNET_NAME \
    --address-prefix $ADDRESSSPACE \
    --location $LOC \
    --subnet-name $SUBTNET_NAME \
    --subnet-prefix $SUBNET
read -p "Press any key to continue!"

# Create the gateway subnet
echo "--> Create subnet" 
az network vnet subnet create --resource-group $RG \
    --name GatewaySubnet \
    --address-prefix $GATEWAYSUBNET \
    --vnet-name $VNET_NAME
read -p "Press any key to continue!"

# Create the local network gateway
echo "--> Create the local network gateway" 
az network local-gateway create --resource-group $RG \
    --gateway-ip-address 23.99.221.164 \
    --name $LocalNetworkGatewayName \
    --local-address-prefixes 10.0.0.0/24 20.0.0.0/24
read -p "Press any key to continue!"

# Request a Public IP address
echo "--> Request a Public IP address" 
az network public-ip create --resource-group $RG \
    --name $PublicIP \
    --allocation-method Dynamic
read -p "Press any key to continue!"

# Create the VPN gateway
echo "--> Create the VPN gateway" 
az network vnet-gateway create --resource-group $RG \
    --name $GatewayName \
    --public-ip-address $PublicIP \
    --vnet $VNET_NAME \
    --gateway-type Vpn \
    --vpn-type $VPNType \
    --sku VpnGw1 \
    --no-wait
