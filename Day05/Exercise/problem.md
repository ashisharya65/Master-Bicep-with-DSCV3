# 🔨 Exercise 05 — Cross-Resource Group References & Diagnostic Settings

> **Day:** 5 | **Track:** Azure Bicep | **Difficulty:** Intermediate

---

## 📋 Project Scenario

Your company enforces a strict corporate governance policy: **All Storage Accounts must stream their audit logs to a central Log Analytics Workspace.**

To simulate a real enterprise environment, you will work with two resource groups:
1. `rg-hub-monitoring` (Simulates a central IT subscription/resource group hosting the shared Log Analytics Workspace).
2. `rg-project-app` (Your project team's resource group where you will deploy a new Storage Account).

You must write a Bicep template that deploys the new Storage Account in your project resource group, references the *existing* Log Analytics Workspace in the hub resource group, and creates a **Diagnostic Setting** to bind them together.

---

## 🛠️ Step-by-Step Instructions

### Step 1: Create the "Pre-Existing" Hub Monitoring Infrastructure

Before writing your Bicep code, you need to create the central Log Analytics Workspace. Run the following Azure CLI commands in your terminal:

```bash
# 1. Create the Hub Monitoring Resource Group
az group create --name rg-hub-monitoring --location eastus

# 2. Create the central Log Analytics Workspace
az monitor log-analytics workspace create \
  --resource-group rg-hub-monitoring \
  --workspace-name law-corporate-central-eastus
```

---

### Step 2: Set Up the Project Environment

Next, create the resource group where your project's storage account will live:

```bash
# Create the Project Resource Group
az group create --name rg-project-app --location eastus
```

---

### Step 3: Write Your Bicep Code (`main.bicep`)

Create a file named `main.bicep` in this directory (`Day05/Exercise/`). Your Bicep code must meet the following requirements:

1. **Parameters:**
   - `projectName` (string, max length 10) - Used as the prefix for the storage account name.
   - `environment` (string, allowed values: `dev`, `prod`) - Defaults to `dev`.
   - `location` (string) - Defaults to the current resource group's location.

2. **Existing Workspace Reference:**
   - Reference the Log Analytics Workspace (`law-corporate-central-eastus`) in `rg-hub-monitoring` using the `existing` keyword and the correct cross-resource-group `scope`.

3. **Storage Account:**
   - Deploy a Storage Account using standard naming conventions (e.g. `${projectName}${environment}stg${uniqueString(resourceGroup().id)}`).
   - Sku: `Standard_LRS`.
   - Kind: `StorageV2`.

4. **Diagnostic Setting:**
   - Deploy a Diagnostic Setting resource (`Microsoft.Insights/diagnosticSettings`).
   - The diagnostic setting must target the **Storage Account Blob Services** sub-resource (Type: `Microsoft.Storage/storageAccounts/blobServices`).
   - Name the diagnostic setting `'log-to-central-law'`.
   - Set the `workspaceId` to the resource ID of the existing Log Analytics Workspace.
   - Enable `StorageRead`, `StorageWrite`, and `StorageDelete` logs.

*Hint for Diagnostic Setting on Blob Services:*
```bicep
// Reference the blob services sub-resource of your storage account
resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' existing = {
  parent: storageAccount
  name: 'default'
}

// Target the diagnostic setting at the blobServices resource scope
resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'log-to-central-law'
  scope: blobServices
  properties: {
    workspaceId: existingWorkspace.id
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
  }
}
```

---

### Step 4: Deploy and Validate

Deploy your template to the `rg-project-app` resource group using Azure CLI:

```bash
az deployment group create \
  --resource-group rg-project-app \
  --template-file main.bicep \
  --parameters projectName=myproj environment=dev
```

Verify in the Azure Portal (or using CLI) that:
1. The storage account is deployed in `rg-project-app`.
2. Under **Diagnostic settings** -> **blob** of the storage account, the logs are pointing to the workspace `law-corporate-central-eastus` in `rg-hub-monitoring`.

---

## 🎯 Learning Objectives

By completing this exercise, you will:
- [ ] Implement the `existing` resource pattern to read existing resource metadata.
- [ ] Configure `scope` references to link resources across different Resource Groups.
- [ ] Understand sub-resource structures (`parent` property) in Azure.
- [ ] Automate audit logging setups using Diagnostic Settings in Bicep.

---

## 🧹 Cleanup

To avoid incurring charges, delete both resource groups once you are done:

```bash
az group delete --name rg-project-app --yes --no-wait
az group delete --name rg-hub-monitoring --yes --no-wait
```
