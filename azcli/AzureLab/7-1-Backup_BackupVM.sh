#!/bin/bash

##############################################################################
## Backup a Linux VM
##############################################################################

RG=LabXRG
LOC=francecentral
VM_NAME=LabXVM
BACKUP_NAME=LabXBackupVault

# Create Backup Vault
echo "--> Create Backup Vault"
az backup vault create --resource-group $RG \
    --name $BACKUP_NAME \
    --location $LOC
read -p "Press any key to continue!"

# Enable backup for an Azure VM
echo "--> Enable backup for an Azure VM"
az backup protection enable-for-vm \
    --resource-group $RG \
    --vault-name $BACKUP_NAME \
    --vm $VM_NAME \
    --policy-name DefaultPolicy
read -p "Press any key to continue!"

# Start a backup job
echo "--> Start a backup job"
az backup protection backup-now \
    --resource-group $RG \
    --vault-name $BACKUP_NAME \
    --container-name $VM_NAME \
    --item-name $VM_NAME \
    --retain-until 10-12-2018
read -p "Press any key to continue!"

# Monitor the backup job
echo "--> Monitor the backup job"
az backup job list \
    --resource-group $RG \
    --vault-name $BACKUP_NAME \
    --output table
read -p "Press any key to continue!"

# Clean up backup
echo "--> Clean up backup"
az backup protection disable \
    --resource-group $RG \
    --vault-name $BACKUP_NAME \
    --container-name $VM_NAME \
    --item-name $VM_NAME \
    --delete-backup-data true
az backup vault delete \
    --resource-group $RG \
    --name $BACKUP_NAME \
