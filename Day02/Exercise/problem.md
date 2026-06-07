# 🔨 Exercise 02 — Deploy Your First Storage Account with Bicep

> **Day:** 2 | **Track:** Azure Bicep | **Difficulty:** Beginner

---

## 📋 Project Requirements

Write a Bicep file (`main.bicep`) that deploys **one Storage Account** with 
the following specifications:

1. **Resource type:** `Microsoft.Storage/storageAccounts`
2. **Name:** Globally unique (use your initials + some numbers, e.g., `asday2sa2026`)
   - Rules: 3–24 characters, lowercase letters and numbers ONLY
3. **Location:** Dynamic — use `resourceGroup().location`
4. **SKU:** `Standard_LRS`
5. **Kind:** `StorageV2`
6. **Tags:** Add these three tags:
   - `environment` = `dev`
   - `project` = `IACTraining-day2`
   - `owner` = your name

---

## 🎯 Learning Objectives

This exercise reinforces:
- [ ] Writing a `resource` declaration from scratch
- [ ] Using the correct resource type and API version
- [ ] Understanding symbolic name vs actual Azure name
- [ ] Using `resourceGroup().location` for dynamic location
- [ ] Adding tags to a resource
- [ ] Deploying with `az deployment group create`

---

## 🏗️ Architecture

```
Resource Group: rg-IACTraining-day2 (eastus)
└── Storage Account (StorageV2, Standard_LRS, tagged)
```

---

## 🚀 Deployment Commands

```powershell
# Step 1: Create the Resource Group
az group create --name rg-IACTraining-day2 --location eastus

# Step 2: Deploy your Bicep file
az deployment group create \
  --resource-group rg-IACTraining-day2 \
  --template-file main.bicep

# Step 3: Verify
az storage account list --resource-group rg-IACTraining-day2 --output table
```

---

## 💡 Hints (Don't peek unless stuck!)

<details>
<summary>Hint 1: API version</summary>

A recent stable API version for Storage Accounts is `2023-01-01`.
</details>

<details>
<summary>Hint 2: Tags syntax</summary>

Tags are a property at the same level as `name`, `location`, `sku`. They use
an object syntax with key-value pairs: `tags: { key: 'value' }`.
</details>

---

## ⭐ Bonus Challenge

After deploying, run `az bicep build --file main.bicep` and open the generated 
`main.json`. Compare your clean Bicep with the verbose ARM JSON. How many more 
lines does the ARM version have?

---

## 🧹 Cleanup

```powershell
az group delete --name rg-IACTraining-day2 --yes --no-wait
```