# 🔥 Day 5: Dependencies & Existing Resources

---

## Section 1: Implicit vs. Explicit Dependencies

### The Analogy — Building a House vs. Scheduling the Inspections

When building a house, some tasks naturally depend on others:
- **Implicit Dependency (Natural Flow):** You cannot build the walls until you have poured the foundation. The walls physically sit on the foundation. In Bicep, referencing one resource's output (like a Subnet ID) inside another resource (like a Network Interface) creates this natural flow automatically.
- **Explicit Dependency (Administrative Flow):** You *can* paint the walls while the electricians are wiring the lights, but the building inspector requires that the wiring be completed *before* the drywall is sealed. There is no physical connection between the paint and the wire, but you are forcing a rule. This is `dependsOn` in Bicep.

---

### Bicep's Dependency Graph

Bicep doesn't deploy resources from top to bottom. Instead, it reads the entire file, builds a **Directed Acyclic Graph (DAG)** of dependencies, and deploys everything it can in **parallel**.

```
       ┌────────────────────────┐
       │   Virtual Network      │
       └───────────┬────────────┘
                   │ (Implicit: Subnet Reference)
                   ▼
       ┌────────────────────────┐
       │   Network Interface    │
       └───────────┬────────────┘
                   │ (Implicit: NIC Reference)
                   ▼
       ┌────────────────────────┐
       │     Virtual Machine    │
       └───────────┬────────────┘
                   │ (Explicit: dependsOn)
                   ▼
       ┌────────────────────────┐
       │   VM Custom Script     │
       │      Extension         │
       └────────────────────────┘
```

---

### Implicit Dependencies (The Golden Path)

Whenever you reference a symbolic property of one resource inside another, Bicep creates an **implicit dependency**. You do not need to do anything else.

```bicep
// Resource 1: Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-prod-eastus'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: 'sn-web'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    }
  }
}

// Resource 2: Network Interface (Implicitly depends on VNet)
resource nic 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-webserver'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          // This reference creates the implicit dependency!
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}
```

Bicep is smart. Because we wrote `vnet.properties.subnets[0].id` in the `nic` definition, Bicep knows it **must** finish deploying the `vnet` before starting to deploy the `nic`.

---

### Explicit Dependencies (The Escape Hatch)

Sometimes, there is no direct parameter or property reference between two resources, but one **must** still deploy before another. For this, we use the `dependsOn` array.

#### Scenario: Installing Software via Custom Script Extension
A VM must be fully online before we run a script to configure it. While Bicep automatically handles VM-to-NIC dependencies, VM extensions can occasionally fail if they trigger before the VM's OS has finished initial boot sequences.

```bicep
resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: 'vm-webserver'
  // ... VM properties
}

resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = {
  name: 'InstallIIS'
  parent: vm // Child resource syntax creates an implicit dependency
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    // ...
  }
}
```

Wait, what if you have a database schema deployment tool running in a container instance, and it must wait for an Azure SQL Database to be ready, but the container doesn't reference any SQL outputs directly? You would use `dependsOn`:

```bicep
resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: 'app-db-migrator'
  // ... APP properties
  dependsOn: [
    sqlDatabase // Forces container app to wait until SQL database is fully deployed
  ]
}
```

> ⚠️ **Production Guideline:** Minimize the use of `dependsOn`. 95% of your dependencies should be implicit. Overusing `dependsOn` makes code harder to maintain and limits Azure's ability to deploy resources in parallel, slowing down deployments.

---

## Section 2: Referencing Existing Resources

### The Analogy — Inviting a Guest to Dinner

Imagine you are cooking dinner:
- **Deploying a Resource:** You buy groceries, prep the food, and cook it from scratch.
- **Using an `existing` Resource:** You invite a neighbor over. You didn't *make* the neighbor; they already exist in the neighborhood. You just need to know their address and name to invite them into your home.

In cloud terms, you often deploy new apps that need to connect to a **pre-existing** database, Virtual Network, or Key Vault managed by a different team or created in a separate step. We reference them using the `existing` keyword.

---

### The `existing` Syntax

To reference an existing resource, declare it with the `existing` keyword. You must provide:
1. The **resource type** and **API version** (must match the resource exactly).
2. The **symbolic name** (to use within Bicep).
3. The **actual resource name** in Azure.

```bicep
// Reference an existing Storage Account
resource preExistingStorage 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: 'stsharedprodeastus001'
}

// Now you can reference its properties!
output storageBlobEndpoint string = preExistingStorage.properties.primaryEndpoints.blob
```

> 🔒 **Crucial Rule:** When you mark a resource as `existing`, Bicep will **never** modify, delete, or redeploy it. It is read-only. It is purely used to query its properties (like resource IDs, endpoints, or keys) for other resources to use.

---

### Cross-Scope References

Existing resources don't always live in the same Resource Group. Bicep allows referencing resources across different Resource Groups or even Subscriptions.

#### Pattern 1: Different Resource Group (Same Subscription)

Use the `scope` property with the `resourceGroup()` function:

```bicep
// Reference a Hub VNet in a different resource group
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: 'vnet-hub-prod'
  scope: resourceGroup('rg-networking-hub') // Specify the target Resource Group name
}
```

#### Pattern 2: Different Subscription (Same Tenant)

Use the `scope` property with the `subscription()` function:

```bicep
// Reference a shared key vault in a different subscription
resource sharedKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: 'kv-shared-core-prod'
  scope: resourceGroup('11111111-2222-3333-4444-555555555555', 'rg-shared-secrets')
}
```

---

## Section 3: Circular Dependencies & Diagnostics

### What is a Circular Dependency?

A circular dependency occurs when Resource A depends on Resource B, and Resource B depends on Resource A. Bicep cannot determine which one to deploy first, resulting in a build error.

```
       ┌────────────────────────┐
       │       Resource A       │
       └───────────┬────────────┘
                   ▲            │
                   │            │ Depends On
        Depends On │            ▼
       ┌───────────┴────────────┐
       │       Resource B       │
       └────────────────────────┘
```

#### Example of a Circular Dependency (Broken Code):
```bicep
// Bad Bicep code: This will fail compilation!
resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: 'app-frontend'
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'asp-frontend'
  properties: {
    // CRITICAL ERROR: App Plan trying to get Web App name
    hostingEnvironmentProfile: {
      id: webApp.name 
    }
  }
}
```

#### How to Fix Circular Dependencies:
1. **Analyze the Graph:** Determine which relationship is invalid. (An App Service Plan doesn't actually need to know the name of the app it is hosting at creation time).
2. **Break the Loop:** Remove the reference that is causing the cycle.
3. **Use Output Helper Files / Configurations:** If two resources must exchange data, use a third resource (like an App Setting, or deployment script) to bridge the gap after both are created.

---

## 📌 Key Takeaways — Day 5

1. **Implicit Dependencies** are created automatically when you reference one resource's symbolic property in another resource.
2. **Explicit Dependencies** (`dependsOn`) should only be used as a last resort when no property reference exists but execution ordering is mandatory.
3. **The `existing` keyword** allows you to read properties of already-deployed resources safely, without redeploying them.
4. **Scoping** allows you to fetch `existing` resources across Resource Groups (`resourceGroup('rgName')`) or Subscriptions (`resourceGroup('subId', 'rgName')`).
5. **Circular Dependencies** cause compilation errors; they must be broken by refactoring dependencies or removing unnecessary property references.
