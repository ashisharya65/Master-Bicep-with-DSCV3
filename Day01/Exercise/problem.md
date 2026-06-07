# 🔨 Exercise 01 — Environment Setup & First CLI Deployment

> **Day:** 1 | **Track:** Azure Bicep | **Difficulty:** Beginner

---

## 📋 Project Requirements

This exercise validates that your environment is correctly set up and you
can interact with Azure from the command line. **No Bicep code required yet.**

### Task 1: Verify Your Toolchain

Run each of these commands and capture the output (copy-paste into your
solution file):

```powershell
# 1. Verify VS Code is installed
code --version

# 2. Verify Azure CLI is installed
az --version

# 3. Verify Bicep CLI is installed
az bicep version

# 4. Verify you're logged into Azure
az account show --output table
```

### Task 2: Create and Inspect a Resource Group

```powershell
# 1. Create a Resource Group
az group create --name rg-IACTraining-day1 --location eastus

# 2. Verify it was created
az group show --name rg-IACTraining-day1 --output table

# 3. List ALL resource groups in your subscription
az group list --output table
```

### Task 3: Explore Azure CLI (Understanding the Tool)

Answer these questions by running CLI commands yourself:

1. What Azure regions are available to you? 
   (Hint: `az account list-locations --output table`)

2. What is the difference between `--output table`, `--output json`, 
   and `--output yaml`? Run the same command with all three and observe.

3. How do you find help for any `az` command? 
   (Hint: try `az group create --help`)

### Task 4: Clean Up

```powershell
# Delete the resource group to avoid any charges
az group delete --name rg-IACTraining-day1 --yes --no-wait

# Verify deletion is in progress
az group list --output table
```

---

## 🎯 Learning Objectives

By completing this exercise, you will:
- [x] Confirm all 4 tools are installed and working
- [x] Successfully authenticate to Azure via CLI
- [x] Create and delete an Azure Resource Group from the terminal
- [x] Navigate Azure CLI help and output formats
- [x] Understand that CLI is the foundation for ALL future Bicep deployments

---

## ⭐ Bonus Challenge

Find out how many Azure **resource providers** are registered in your 
subscription. A resource provider is what enables you to create specific 
types of resources (e.g., `Microsoft.Storage` lets you create Storage 
Accounts, `Microsoft.Compute` lets you create VMs).

```powershell
# Hint: explore this command
az provider list --output table
```

Count how many show `Registered` status and note the top 5 most 
interesting ones you find.

---

## 🧹 Cleanup

```powershell
az group delete --name rg-IACTraining-day1 --yes --no-wait
```
