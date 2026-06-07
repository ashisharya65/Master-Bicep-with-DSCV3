# 🔥 Day 1: IaC Fundamentals & Environment Setup

---

## Section 1: What is Infrastructure as Code (IaC)?

### The Analogy — The Recipe Book vs. Cooking From Memory

Imagine you're a head chef at a restaurant chain with 50 locations. You have two choices:

- **Option A (Manual — "ClickOps"):** You fly to each restaurant and personally cook the signature dish, adjusting by taste, memory, and gut feeling. Every location tastes slightly different. When you're sick, nobody can replicate it.

- **Option B (IaC — "The Recipe"):** You write an exact recipe — ingredients, quantities, temperatures, timing — and give it to every kitchen. Every location produces the identical dish. Any chef can follow it. You can update the recipe in one place and all locations adapt.

**IaC is Option B for your cloud infrastructure.**

Instead of clicking through the Azure Portal to create a VM, a network, and a storage account (which is slow, error-prone, and impossible to replicate exactly), you write **code files** that describe what you want. Then you run a command, and Azure builds it for you — exactly the same way, every time.

### Why IaC Matters — The 5 Pillars

| Pillar | Without IaC | With IaC |
|--------|-------------|----------|
| **Repeatability** | "I clicked 47 things, can you do it exactly the same?" | Run the same file → identical result every time |
| **Version Control** | "What changed? Who changed it? When?" | `git log` shows every change, by whom, when, and why |
| **Speed** | 45 minutes clicking through Portal | 3 minutes running a deployment command |
| **Collaboration** | "Don't touch my environment!" | Pull request → code review → merge → deploy |
| **Drift Detection** | "Why is prod different from staging?!" | Compare code files → spot differences instantly |

> **🏭 Why This Matters in Production:**  
> At scale (50+ resources, multiple environments), manual provisioning is unsustainable. Every major cloud team uses IaC. It's not optional — it's table stakes.

---

## Section 2: Why Azure Bicep? (And Not ARM Templates or Terraform?)

### The Short History

```
2014 ──── ARM Templates (JSON) ──── Verbose, painful, hard to read
   │
   │       "We need something better..."
   │
2020 ──── Azure Bicep (DSL) ──────── Clean, concise, transpiles TO ARM
   │
   │       "But what about Terraform?"
   │
   └───── Terraform (HCL) ──────── Multi-cloud, but extra state management
```

### The Analogy — Types of Vehicles

- **ARM Templates** = Driving a stick-shift truck. Full control, but exhausting. Every turn requires five manual actions. Nobody *wants* to drive it, but it gets the job done.

- **Azure Bicep** = Driving a modern automatic car with GPS. Same roads (Azure), same destination, but the ride is smooth, the syntax is clean, and the car (compiler) handles the messy stuff for you.

- **Terraform** = A universal vehicle that drives on ANY road (Azure, AWS, GCP). Incredibly versatile, but you need to manage your own garage (state file) and fuel station (providers).

### Bicep vs ARM — Side by Side

**ARM Template (JSON) — 16 lines of boilerplate:**
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2023-01-01",
      "name": "mystorageaccount",
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "Standard_LRS"
      },
      "kind": "StorageV2",
      "properties": {}
    }
  ]
}
```

**Bicep — 7 lines of clarity:**
```bicep
// Deploy a Storage Account using Azure Bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'mystorageaccount'           // Globally unique name
  location: resourceGroup().location  // Same region as the resource group
  sku: {
    name: 'Standard_LRS'             // Locally redundant storage (cheapest)
  }
  kind: 'StorageV2'                  // General-purpose v2 (recommended)
}
```

**What's happening in that Bicep code?**

| Line | What It Does |
|------|-------------|
| `resource storageAccount` | Declares a resource and gives it a **symbolic name** (used to reference it in code, NOT the actual Azure name) |
| `'Microsoft.Storage/storageAccounts@2023-01-01'` | The **resource type** + **API version** — tells Azure exactly what kind of resource and which API to use |
| `= {` | Everything inside the braces defines the resource's properties |
| `name:` | The **actual name** of the resource in Azure (must be globally unique for storage accounts) |
| `location:` | Where in the world to deploy it. `resourceGroup().location` means "same region as the resource group" |
| `sku.name:` | The pricing/redundancy tier |
| `kind:` | The type of storage account |

> ✅ **Key insight:** Bicep files (`.bicep`) get **transpiled** (converted) into ARM JSON behind the scenes. Azure only understands ARM. Bicep is a **developer-friendly layer** on top of ARM — like TypeScript is to JavaScript.

### Bicep vs Terraform — When to Choose Which

| Factor | Azure Bicep | Terraform |
|--------|-------------|-----------|
| **Cloud Support** | Azure ONLY | Multi-cloud (Azure, AWS, GCP, etc.) |
| **State Management** | None needed (Azure IS the state) | You manage a state file (can get complex) |
| **Day-0 Support** | New Azure features available immediately | New features may lag weeks/months |
| **Learning Curve** | Lower (if you know Azure) | Moderate (HCL syntax + state concepts) |
| **Community** | Growing fast | Massive and mature |
| **Best For** | Azure-only shops | Multi-cloud or cloud-agnostic teams |

> ⚠️ **Common Mistake:** People think they must choose one forever. In reality, many enterprises use **Bicep for Azure-native** and **Terraform for multi-cloud**. They're not enemies — they're different tools for different jobs.

> **🏭 Why This Matters in Production:**  
> If your company is 100% Azure (which is increasingly common), Bicep gives you zero-lag access to new Azure features, no state file headaches, and first-party Microsoft support.

---

## Section 3: Environment Setup — Your Workbench

Before we write any code, we need our tools ready. Think of this like a carpenter setting up their workshop before building furniture.

### Tool 1: Visual Studio Code

```powershell
# Windows — install via winget
winget install Microsoft.VisualStudioCode
```

### Tool 2: Bicep Extension for VS Code

This gives you IntelliSense (auto-complete), syntax highlighting, and error detection.

```
1. Open VS Code
2. Press Ctrl+Shift+X (Extensions panel)
3. Search "Bicep"
4. Install the one by Microsoft (blue muscle 💪 icon)
```

### Tool 3: Azure CLI

Azure CLI (`az`) is how you talk to Azure from the terminal.

```powershell
# Windows — install via winget
winget install Microsoft.AzureCLI

# Verify installation
az --version
```

After installing, sign in:

```powershell
# Login to Azure (opens browser for authentication)
az login

# See all your subscriptions
az account list --output table

# Set your active subscription
az account set --subscription "YOUR-SUBSCRIPTION-ID"
```

### Tool 4: Bicep CLI (Built into Azure CLI)

```powershell
# Install/upgrade Bicep CLI
az bicep install

# Verify version
az bicep version
# Expected: Bicep CLI version 0.28+ (as of 2026)
```

### ✅ Verification Checklist — Run All 5

```powershell
code --version          # VS Code installed?
az --version            # Azure CLI installed?
az bicep version        # Bicep CLI installed?
az account show -o table  # Logged into Azure?
# Create test.bicep, type "res" → see autocomplete? Extension works!
```

> ⚠️ **Common Mistake:** Forgetting `az login` before deploying → cryptic auth error. Always verify with `az account show` first.

---

## 🔗 The Big Picture — How Bicep + DSC V3 Work Together

This is the workflow you'll master by Day 21:

```
┌─────────────────────────────────────────────────────────┐
│                   YOUR CLOUD WORKFLOW                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   STEP 1: PROVISION (Azure Bicep)                       │
│   ┌───────────────────────────────┐                     │
│   │ VNet, Subnets, NSGs, VMs,    │                     │
│   │ Key Vault, Storage Account   │  ← "Build the house"│
│   └──────────────┬────────────────┘                     │
│                  │                                       │
│                  ▼                                       │
│   STEP 2: CONFIGURE (DSC V3)                            │
│   ┌───────────────────────────────┐                     │
│   │ Install IIS, set registry,   │                     │
│   │ configure firewall, harden   │  ← "Furnish the     │
│   │ SSH, install packages        │     house"           │
│   └──────────────┬────────────────┘                     │
│                  │                                       │
│                  ▼                                       │
│   STEP 3: MONITOR (Azure Machine Configuration)         │
│   ┌───────────────────────────────┐                     │
│   │ Continuous compliance check, │                     │
│   │ drift detection, reporting   │  ← "Building        │
│   │                              │     inspector"       │
│   └───────────────────────────────┘                     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Bicep** = Build the house (create Azure infrastructure)  
**DSC V3** = Furnish the house (configure OS-level state)  
**Azure Machine Configuration** = Building inspector (continuous compliance)

Days 1–8 focus on Step 1. Days 9–16 on Step 2. Days 17–21 bring it all together.

---

## 🚀 Your First Deployment — Hello, Resource Group!

Let's prove your environment works. A Resource Group is a logical container (like a folder) for Azure resources:

```powershell
# Create your first Resource Group
az group create --name rg-IACTraining-day1 --location eastus

# Verify it exists
az group show --name rg-IACTraining-day1 --output table
```

Expected output:
```
Name                 Location    Status
-------------------  ----------  ---------
rg-IACTraining-day1   eastus      Succeeded
```

🎉 **You just provisioned your first Azure resource from the command line!**

> ⚠️ **Cleanup** (to avoid any charges):
> ```powershell
> az group delete --name rg-IACTraining-day1 --yes --no-wait
> ```

---

## 📌 Key Takeaways — Day 1

1. **IaC** = Define infrastructure in code files instead of clicking through a portal
2. **Bicep** = Azure's native IaC language — clean syntax that transpiles to ARM JSON
3. **Bicep vs Terraform** = Bicep for Azure-only, Terraform for multi-cloud — both are valid
4. **Bicep + DSC V3** = Bicep builds infra, DSC V3 configures OS state — two halves of one workflow
5. **Always verify** your tools with the 5-command checklist before writing code

---
