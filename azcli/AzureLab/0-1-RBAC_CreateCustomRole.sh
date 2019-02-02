#!/bin/bash

##############################################################################
## RBAC: create a custom role
##############################################################################

# Create a custom role (before execute, insert the subscription id)
echo "--> Create a custom role"
az role definition create --role-definition "./custom-role.json"
read -p "Press any key to continue!"

# List custom roles
echo "--> List custome roles"
az role definition list --custom-role-only true
read -p "Press any key to continue!"

# Update a custom role (before execute, add in actions section: "Microsoft.Resources/deployments/*")
echo "--> Update a custome role"
az role definition update --role-definition "./custom-role.json"
read -p "Press any key to continue!"

# Delete a custome role
echo "--> Delete a custome role"
az role definition delete --name "Reader Support Tickets"
