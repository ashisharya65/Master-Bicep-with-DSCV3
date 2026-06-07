# Exercise 04 — Functions & Expressions in Action

> **Day:** 4 | **Track:** Azure Bicep | **Difficulty:** Intermediate

---

## 📋 Project Requirements

Write a Bicep file (`main.bicep`) that deploys **two Storage Accounts** using 
functions, expressions, and the ternary operator. The template should 
demonstrate smart naming and environment-aware configuration.

### Parameters

| Parameter | Type | Default | Decorators |
|-----------|------|---------|------------|
| `projectName` | string | (required) | `@description`, `@minLength(2)`, `@maxLength(10)` |
| `environment` | string | `'dev'` | `@description`, `@allowed`: `dev`, `staging`, `prod` |
| `location` | string | `resourceGroup().location` | `@description` |

### Variables (must use functions)

| Variable | Logic |
|----------|-------|
| `primaryStorageName` | `toLower()` of `projectName` + `environment` + first 6 chars of `uniqueString(resourceGroup().id)` — must be max 24 chars |
| `logsStorageName` | `toLower()` of `projectName` + `'logs'` + first 6 chars of `uniqueString(resourceGroup().id)` |
| `skuName` | Ternary: if `environment == 'prod'` → `'Standard_GRS'`, else → `'Standard_LRS'` |
| `accessTier` | Ternary: if `environment == 'prod'` → `'Hot'`, else → `'Cool'` |
| `commonTags` | Object with: `environment`, `project` (from params), `uniqueId` (from `uniqueString`), `region` (from `resourceGroup().location`) |

### Resources

1. **Primary Storage Account** — `StorageV2`, uses `skuName` variable, tagged with `commonTags`
2. **Logs Storage Account** — `BlobStorage`, `Standard_LRS`, access tier from `accessTier` variable, tagged with `commonTags`

### Outputs

| Output | Type | Value |
|--------|------|-------|
| `primaryStorageName` | string | Name of primary storage |
| `logsStorageName` | string | Name of logs storage |
| `primaryBlobEndpoint` | string | Primary blob endpoint of the primary storage |
| `environmentConfig` | object | Object with keys: `sku`, `accessTier`, `region` |

---

## 🎯 Learning Objectives

- [ ] Use `uniqueString()` and `substring()` for unique naming
- [ ] Use `toLower()` to enforce naming rules
- [ ] Use ternary operator for environment-aware configuration
- [ ] Create an object variable with computed values
- [ ] Return an `object` type output
- [ ] Deploy multiple resources with shared variables

---

## 🏗️ Architecture

```
Resource Group: rg-day4 (eastus)
├── Primary Storage (StorageV2, env-aware SKU)
└── Logs Storage (BlobStorage, env-aware access tier)
```

---

## 🚀 Deployment Commands

```powershell
# Create Resource Group
az group create --name rg-day4 --location eastus

# Deploy for dev
az deployment group create \
  --resource-group rg-day4 \
  --template-file main.bicep \
  --parameters projectName='myapp'

# Deploy for prod (observe different SKU and access tier)
az deployment group create \
  --resource-group rg-day4 \
  --template-file main.bicep \
  --parameters projectName='myapp' environment='prod'
```

---

## 💡 Hints

<details>
<summary>Hint 1: Getting first 6 characters of uniqueString</summary>

Use `substring(uniqueString(resourceGroup().id), 0, 6)` to get only the first 
6 characters of the hash.
</details>

<details>
<summary>Hint 2: BlobStorage requires accessTier</summary>

When `kind` is `BlobStorage`, you must set `accessTier` inside the `properties` 
block: `properties: { accessTier: accessTier }`.
</details>

<details>
<summary>Hint 3: Object output</summary>

You can construct an object inline in an output:
`output myObj object = { key1: value1, key2: value2 }`
</details>

---

## ⭐ Bonus Challenge

Add a third variable called `namingPrefix` that uses `format()` function 
to build a standardized prefix like `myapp-dev`. Then use this prefix 
in at least one resource's tags.

---

## 🧹 Cleanup

```powershell
az group delete --name rg-day4 --yes --no-wait
```
