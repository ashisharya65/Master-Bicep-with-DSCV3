
# Verify VS Code is installed
code --version

# Verify Azure CLI is installed
az --version

# Verify Bicep CLI is installed
az bicep version

# Verify you're logged into Azure
az account show --output table

# Create a Resource Group
az group create --name rg-day1 --location eastus

# Verify it was created
az group show --name rg-day1 --output table

# List ALL resource groups in your subscription
az group list --output table

# Delete the resource group to avoid any charges
az group delete --name rg-day1 --yes --no-wait
