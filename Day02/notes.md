# 🔥 Day 2: Bicep Syntax & Your First Resource

---

## 🔄 Day 1 Rapid Recap (2 minutes)

Before we start, quick recall:
- **IaC** = Define infrastructure in code → version control, repeatability, speed
- **Bicep** = Azure's native IaC language → transpiles to ARM JSON
- **Bicep vs Terraform** = Bicep for Azure-only (no state file), Terraform for multi-cloud
- **Tools** = VS Code + Bicep Extension + Azure CLI + Bicep CLI
- **CLI basics** = `az group create`, `az group delete`, `--output table/json/yaml`

Today we start writing actual Bicep code. This is where the real fun begins. 🚀

---

## Section 1: The `.bicep` File — What's Inside?

### The Analogy — A Filled-Out Form

Think of a `.bicep` file like a government application form. The form has:
- A **title** (what kind of resource you're requesting)
- **Fields to fill** (name, location, configuration)
- **An office that processes it** (Azure Resource Manager)

You fill out the form (write Bicep), submit it (deploy), and the government 
(Azure) creates exactly what you requested.

### File Structure

A `.bicep` file is a plain text file with the `.bicep` extension. At its 
simplest, it contains **resource declarations** — each one telling Azure 
"I want this thing to exist."

```bicep
// This is a comment (single line)

/* 
   This is a 
   multi-line comment 
*/

// A resource declaration — the core building block of Bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'mystorageacct2026'
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
```

That's it. That's a complete, deployable Bicep file. Let's break down every piece.

---

## Section 2: The `resource` Declaration — Anatomy

This is the most important thing you'll learn today. Every resource in Bicep 
follows this pattern:

```
resource <symbolicName> '<resourceType>@<apiVersion>' = {
  name: '<actualAzureName>'
  location: '<region>'
  // ... other properties
}
```

Let's dissect each part:

### Part 1: `resource` keyword

This tells Bicep "I'm declaring a resource." Every Azure resource you want to 
create starts with this keyword.

### Part 2: Symbolic Name (`storageAccount`)

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
//      ^^^^^^^^^^^^^^
//      This is the SYMBOLIC NAME
```

- This is a **nickname** you give the resource **inside your Bicep file only**
- It does NOT appear in Azure — Azure never sees this name
- Used to **reference** this resource elsewhere in your code
- Must be unique within the file
- Convention: use camelCase (`storageAccount`, `myVirtualNetwork`, `webAppPlan`)

> ⚠️ **Common Mistake:** Confusing the symbolic name with the actual Azure 
> resource name. They are completely different things!

**Example of referencing via symbolic name (you'll use this a lot later):**
```bicep
// Later in the file, you can reference this resource:
output storageId string = storageAccount.id
//                         ^^^^^^^^^^^^^^ ← using the symbolic name
```

### Part 3: Resource Type (`Microsoft.Storage/storageAccounts`)

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
//                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                       RESOURCE TYPE @ API VERSION
```

The resource type tells Azure **what kind of resource** to create. The format is:

```
<ResourceProvider>/<ResourceType>
```

| Part | Example | Meaning |
|------|---------|---------|
| Resource Provider | `Microsoft.Storage` | The Azure service (Storage service) |
| Resource Type | `storageAccounts` | The specific resource within that service |

**Common Resource Types you'll see:**

| Resource | Type String |
|----------|-------------|
| Storage Account | `Microsoft.Storage/storageAccounts` |
| Virtual Network | `Microsoft.Network/virtualNetworks` |
| Virtual Machine | `Microsoft.Compute/virtualMachines` |
| App Service | `Microsoft.Web/sites` |
| Key Vault | `Microsoft.KeyVault/vaults` |
| SQL Database | `Microsoft.Sql/servers/databases` |

> 💡 **How to find resource types:** In VS Code with the Bicep extension, type 
> `resource myRes '` and IntelliSense will show you all available types!

### Part 4: API Version (`@2023-01-01`)

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
//                                                         ^^^^^^^^^^
//                                                         API VERSION
```

- Every Azure resource has **multiple API versions** (dates like `2023-01-01`)
- The API version determines **which properties are available**
- Newer versions may add new features (e.g., a new encryption option)
- Format is always `@YYYY-MM-DD`

> ✅ **Best Practice:** Use the latest **stable** API version. Avoid preview 
> versions (`2024-01-01-preview`) in production unless you need a specific 
> preview feature.

> 💡 **How to find the latest API version:** In VS Code, type the resource type 
> and the Bicep extension will suggest available API versions.

### Part 5: The `= {` and Properties

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'mystorageacct2026'    // REQUIRED — the actual name in Azure
  location: 'eastus'           // REQUIRED — Azure region
  sku: {                       // REQUIRED — pricing/redundancy tier
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'            // REQUIRED — type of storage account
}
```

The `= { }` block contains the **properties** that configure your resource:

| Property | Required? | What It Does |
|----------|-----------|-------------|
| `name` | ✅ Always | The actual name of the resource in Azure. This is what shows up in the Portal |
| `location` | ✅ Usually | The Azure region where the resource is deployed |
| `sku` | Depends | The pricing/performance tier |
| `kind` | Depends | The subtype of the resource |
| `properties` | Depends | Additional configuration (nested object) |
| `tags` | ❌ Optional | Key-value pairs for organizing resources |

> ⚠️ **Common Mistake:** Each resource type has different required properties. 
> A Storage Account needs `sku` and `kind`, but a Virtual Network needs 
> `addressSpace`. The Bicep extension will show red squiggles for missing 
> required properties.

---

## Section 3: `targetScope` — Where Are You Deploying?

Every Bicep file has a **target scope** — the level at which resources are 
deployed. By default, it's `resourceGroup`.

```bicep
// This line is OPTIONAL if deploying to a resource group (it's the default)
targetScope = 'resourceGroup'
```

The four scopes are:

| Scope | What It Means | Example Use |
|-------|---------------|-------------|
| `resourceGroup` | Deploy into a specific RG (default) | Storage Accounts, VMs, VNets |
| `subscription` | Deploy at the subscription level | Creating Resource Groups, Policies |
| `managementGroup` | Deploy at management group level | Policies across subscriptions |
| `tenant` | Deploy at the tenant root | Management Group creation |

For now, we'll always use the default (`resourceGroup`), so you don't need to 
add this line. But it's important to know it exists because on Day 8 we'll 
deploy at other scopes.

> ✅ **For today:** Don't add `targetScope` to your file — the default 
> `resourceGroup` is what we need.

---

## Section 4: Dynamic Location with `resourceGroup().location`

Hardcoding `location: 'eastus'` works, but it's not flexible. What if you 
want to deploy to `westus` or `centralindia`?

**Better approach — use the resource group's location:**

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'mystorageacct2026'
  location: resourceGroup().location  // ← Dynamic! Uses the RG's location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
```

`resourceGroup()` is a **built-in function** that returns information about the 
resource group you're deploying into. `.location` gets its region.

**Why this is better:**
- Create the RG in `eastus` → storage deploys in `eastus`
- Create the RG in `centralindia` → storage deploys in `centralindia`
- Your Bicep file works for ANY region without changing code

> ✅ **Best Practice:** Almost always use `resourceGroup().location` instead of 
> hardcoding a region. We'll learn even better approaches (parameters) on Day 3.

---

## Section 5: How to Deploy — The Full Workflow

Here's the complete workflow to go from Bicep file to live Azure resources:

### Step 1: Write your Bicep file

Save it as `main.bicep` (convention — you can name it anything).

### Step 2: Create a Resource Group (if it doesn't exist)

```powershell
az group create --name rg-cloudforge-day2 --location eastus
```

### Step 3: Deploy the Bicep file

```powershell
az deployment group create \
  --resource-group rg-cloudforge-day2 \
  --template-file main.bicep
```

**What happens behind the scenes:**
```
Your main.bicep
      │
      ▼ (Bicep CLI transpiles)
ARM JSON template
      │
      ▼ (Sent to Azure)
Azure Resource Manager
      │
      ▼ (ARM processes)
Resource Created! ✅
```

### Step 4: Verify in CLI or Portal

```powershell
# CLI verification
az storage account list --resource-group rg-cloudforge-day2 --output table

# Or check the Azure Portal → Resource Groups → rg-cloudforge-day2
```

### Step 5: Clean up (delete when done practicing)

```powershell
az group delete --name rg-cloudforge-day2 --yes --no-wait
```

---

## Section 6: Seeing the Transpiled ARM JSON

Want to see what Bicep compiles into? Use `az bicep build`:

```powershell
# Transpile Bicep → ARM JSON (creates main.json in same directory)
az bicep build --file main.bicep
```

This creates a `main.json` file. Open it and compare — you'll see the same 
Storage Account but wrapped in verbose ARM JSON. This is what Azure actually 
receives.

> 💡 **Reverse direction also works!** If you have an ARM template, you can 
> convert it to Bicep:
> ```powershell
> az bicep decompile --file template.json
> ```

---

## Section 7: Adding Tags — Organizing Resources

Tags are key-value pairs that help you organize, search, and track costs:

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'mystorageacct2026'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: {
    environment: 'dev'
    project: 'cloudforge-training'
    owner: 'ashish'
  }
}
```

> ✅ **Best Practice:** Always add tags in production. At minimum: `environment`, 
> `project`, and `owner`. This makes cost tracking and resource management much 
> easier.

---

## 📌 Key Takeaways — Day 2

1. **`resource`** is the core building block — every Azure resource starts with this keyword
2. **Symbolic name** = nickname in code (camelCase) ≠ actual Azure name
3. **Resource type** = `Provider/Type@YYYY-MM-DD` (e.g., `Microsoft.Storage/storageAccounts@2023-01-01`)
4. **API version** = determines available properties — use latest stable
5. **`resourceGroup().location`** = dynamic location — better than hardcoding
6. **`targetScope`** = where you deploy (default is `resourceGroup`)
7. **Deploy** = `az deployment group create --resource-group <rg> --template-file <file>`
8. **`az bicep build`** = see the transpiled ARM JSON

---
