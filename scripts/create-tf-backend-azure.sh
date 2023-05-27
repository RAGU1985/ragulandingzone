#!/usr/bin/env bash

set -euo pipefail

REPO_ID=${REPO_ID:-"12345"}
RESOURCE_GROUP_NAME=${RESOURCE_GROUP_NAME:-"rg-github-terraform-$REPO_ID"}
RESOURCE_GROUP_LOCATION=${RESOURCE_GROUP_LOCATION:-"brazilsouth"}
STORAGE_ACCOUNT_NAME=${STORAGE_ACCOUNT_NAME:-"stgithubtf$REPO_ID"}
STORAGE_ACCOUNT_SKU=${STORAGE_ACCOUNT_SKU:-"Standard_LRS"}
CONTAINER_NAME=${CONTAINER_NAME:-"tfstate"}

# Register GITHUB OUTPUTS

echo "STORAGE_ACCOUNT_NAME=$STORAGE_ACCOUNT_NAME" >> $GITHUB_OUTPUT
echo "CONTAINER_NAME=$CONTAINER_NAME" >> $GITHUB_OUTPUT
echo "RESOURCE_GROUP_NAME=$RESOURCE_GROUP_NAME" >> $GITHUB_OUTPUT

# Register GITHUB_ENV

echo "STORAGE_ACCOUNT_NAME=$STORAGE_ACCOUNT_NAME" >> $GITHUB_ENV
echo "CONTAINER_NAME=$CONTAINER_NAME" >> $GITHUB_ENV
echo "RESOURCE_GROUP_NAME=$RESOURCE_GROUP_NAME" >> $GITHUB_ENV


# Check if Blob Container exists
# ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv || echo )
# if [[ ! -z "$ACCOUNT_KEY" ]]; then
#   echo "Found Account key for $RESOURCE_GROUP_NAME -- $STORAGE_ACCOUNT_NAME"

#   count=$(az storage container list \
#     --account-name $STORAGE_ACCOUNT_NAME \
#     --account-key $ACCOUNT_KEY \
#     --query '[*].name' \
#     -o tsv | grep $CONTAINER_NAME -c)

#   if [[ $count -gt 0 ]]; then
#     echo "Container Blob $CONTAINER_NAME Found, aborting Terraform Backend Setup"
#     exit 0
#   fi

# else
#   echo "Account Key not found for $RESOURCE_GROUP_NAME -- $STORAGE_ACCOUNT_NAME"
# fi

# echo "Creating Resource Group, Storage Account and Container Blob..."

# Create Resource Group
az group create \
  --name $RESOURCE_GROUP_NAME \
  --location $RESOURCE_GROUP_LOCATION

# Create Storage Account
az storage account create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $STORAGE_ACCOUNT_NAME \
  --location $RESOURCE_GROUP_LOCATION\
  --sku $STORAGE_ACCOUNT_SKU \
  --kind StorageV2 \
  --encryption-services blob \
  --https-only false \
  --allow-blob-public-access true

# Adjust Storage Account public network access
#az storage account network-rule add \
#    -g $RESOURCE_GROUP_NAME \
#    --account-name $STORAGE_ACCOUNT_NAME \
#    --ip-address $STORAGE_ACCOUNT_NETWORK_IPS

# Get Storage Account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# workaround network-rule add
# sleep 30

# Create Blob Container
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --account-key $ACCOUNT_KEY

# Enable storage versioning
az storage account blob-service-properties update \
    --account-name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --enable-versioning true

# Register output to stdout
echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"