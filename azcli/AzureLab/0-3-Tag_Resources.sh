#!/bin/bash

##############################################################################
## Tag: create, find and delete
##############################################################################

RG=LabXRG
LOC=francecentral
RES_NAME=LabXVM

# Create a resource
echo "--> Create a resource"
az vm create --resource-group $RG --name $RES_NAME --image UbuntuLTS --generate-ssh-keys
read -p "Press any key to continue!"

# Tag resource group
echo "--> Tag resource group"
az group update -n $RG --set tags.Environment=Test tags.Dept=IT
read -p "Press any key to continue!"

# Add a third tag on resource group
echo "--> Add a third tag on resource group"
az group update -n $RG --set tags.Project=Documentation
read -p "Press any key to continue!"

# Apply tags on the resource group on all resources in this resource group
echo "--> Apply tags on the resource group on all resources in this resource group"
# Get the tags for the resource group
jsontag=$(az group show -n $RG --query tags)

# Reformat from JSON to space-delimited and equals sign
t=$(echo $jsontag | tr -d '"{},' | sed 's/: /=/g')

# Get the resource IDs for all resources in the resource group
r=$(az resource list -g $RG --query [].id --output tsv)

# Loop through each resource ID
for resid in $r
do
  # Get the tags for this resource
  jsonrtag=$(az resource show --id $resid --query tags)

  # Reformat from JSON to space-delimited and equals sign
  rt=$(echo $jsonrtag | tr -d '"{},' | sed 's/: /=/g')

  # Reapply the updated tags to this resource
  az resource tag --tags $t$rt --id $resid
done
read -p "Press any key to continue!"

# Find resources by tag
echo "--> Find resources by tag"
az resource list --tag Environment=Test --query [].name
read -p "Press any key to continue!"

# Execute an action on a resource thanks to a tag
echo "--> Execute an action on a resource thanks to a tag"
az vm stop --ids $(az resource list --tag Environment=Test --query "[?type=='Microsoft.Compute/virtualMachines'].id" --output tsv)
read -p "Press any key to continue!"

# Delete all tags on a resource group
echo "--> Delete all tags on a resource group"
az group update -n $RG --remove tags