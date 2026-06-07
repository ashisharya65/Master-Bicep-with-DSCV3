# Exercise 03 — Dynamic Storage Account with Parameters, Variables & Outputs

> **Day:** 3 | **Track:** Azure Bicep | **Difficulty:** Beginner-Intermediate

---

## 📋 Project Requirements

Write a Bicep file (`main.bicep`) that deploys **one Storage Account** using 
parameters, variables, and outputs. The template must be reusable across 
different environments.

### Parameters (all must have appropriate decorators)

| Parameter | Type | Required? | Default | Decorators |
|-----------|------|:---------:|---------|------------|
| `projectName` | string | Yes | — | `@description`, `@minLength(2)`, `@maxLength(10)` |
| `environment` | string | No | `'dev'` | `@description`, `@allowed` with values: `dev`, `staging`, `prod` |
| `location` | string | No | `resourceGroup().location` | `@description` |
| `skuName` | string | No | `'Standard_LRS'` | `@description`, `@allowed` with values: `Standard_LRS`, `Standard_GRS`, `Standard_ZRS` |

### Variables

| Variable | Logic |
|----------|-------|
| `storageName` | Concatenation of `projectName` + `environment` + `'sa'` |
| `commonTags` | Object with keys: `environment`, `project`, `createdBy` (your name) |

### Resource

- **Storage Account** with:
  - Name from `storageName` variable
  - Location from `location` parameter
  - SKU from `skuName` parameter
  - Kind: `StorageV2`
  - Tags from `commonTags` variable

### Outputs

| Output Name | Type | Value |
|-------------|------|-------|
| `storageAccountId` | string | Resource ID of the storage account |
| `storageAccountName` | string | Name of the storage account |
| `blobEndpoint` | string | Primary blob endpoint URL |

---

## 🎯 Learning Objectives

- [ ] Declare parameters with appropriate types and default values
- [ ] Apply decorators: `@description`, `@allowed`, `@minLength`, `@maxLength`
- [ ] Create variables using string interpolation
- [ ] Create an object variable for reusable tags
- [ ] Declare outputs that reference deployed resource properties
- [ ] Deploy with inline parameters via CLI

---

## 🏗️ Architecture

```
Resource Group: rg-day3 (eastus)
└── Storage Account ({projectName}{environment}sa)
    ├── SKU: parameterized
    ├── Tags: from variable
    └── Outputs: ID, Name, Blob Endpoint
```

---

## 🚀 Deployment Commands

```powershell
# Create Resource Group
az group create --name rg-day3 --location eastus

# Deploy with parameters
az deployment group create \
  --resource-group rg-day3 \
  --template-file main.bicep \
  --parameters projectName='myapp' environment='dev'

# Deploy again for a DIFFERENT environment (reuse!)
az deployment group create \
  --resource-group rg-day3 \
  --template-file main.bicep \
  --parameters projectName='myapp' environment='staging' skuName='Standard_GRS'
```

---

## 💡 Hints

<details>
<summary>Hint 1: String interpolation syntax</summary>

Use `'${variable1}${variable2}suffix'` to concatenate values inside a string.
</details>

<details>
<summary>Hint 2: Accessing blob endpoint</summary>

After a storage account is deployed, its blob endpoint is at:
`stgAccount.properties.primaryEndpoints.blob`
</details>

---

## ⭐ Bonus Challenge

Deploy the same template twice with different `environment` values (`dev` and 
`staging`). Verify both storage accounts exist in the same resource group with 
different names and tags.

---

## 🧹 Cleanup

```powershell
az group delete --name rg-day3 --yes --no-wait
```
