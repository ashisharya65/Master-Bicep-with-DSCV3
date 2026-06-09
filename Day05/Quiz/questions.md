# 📝 Day 05 Quiz — Dependencies & Existing Resources

> **Difficulty:** 1 Easy, 2 Medium, 2 Tricky (Scenario-based)

---

### Q1 (Easy)
How does Azure Bicep primarily determine the order in which to deploy resources?

- **A)** It deploys resources sequentially from the top of the file to the bottom.
- **B)** It parses the file, builds a dependency graph using implicit and explicit relationships, and deploys as much as possible in parallel.
- **C)** It deploys resources in alphabetical order based on their symbolic names.
- **D)** It uploads all resource templates to Azure simultaneously and lets the Azure Resource Manager (ARM) resolve dependencies during execution.

---

### Q2 (Medium)
You use the `existing` keyword to reference a SQL Server that was created manually by another team. What happens when you execute your Bicep deployment?

- **A)** Bicep will recreate the SQL Server with default properties if the configuration has drifted.
- **B)** Bicep will fail the deployment because Bicep deployments cannot mix IaC-managed resources with manually created resources.
- **C)** Bicep reads the properties of the SQL Server to use in other resource declarations, but does not deploy or modify the server.
- **D)** Bicep updates the SQL Server configuration to match the API version declared in your Bicep file.

---

### Q3 (Medium)
You need to reference an existing Log Analytics Workspace named `law-core-prod` that resides in a different Resource Group named `rg-monitoring` within the same subscription. Which of the following is the correct syntax?

- **A)** 
  ```bicep
  resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
    name: 'law-core-prod'
    scope: resourceGroup('rg-monitoring')
  }
  ```
- **B)** 
  ```bicep
  resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
    name: 'law-core-prod'
    scope: 'rg-monitoring'
  }
  ```
- **C)** 
  ```bicep
  resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
    name: 'law-core-prod/rg-monitoring'
  }
  ```
- **D)** 
  ```bicep
  resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
    name: 'law-core-prod'
    scope: subscription('rg-monitoring')
  }
  ```

---

### Q4 (Tricky — Scenario)
You are writing a Bicep template to deploy a Web App and its App Service Plan. You write the following code:

```bicep
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'plan-prod'
  location: resourceGroup().location
  sku: { name: 'S1' }
  dependsOn: [ webApp ]
}

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: 'app-web-prod'
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
  }
}
```

What will happen when you try to compile/build this Bicep file?

- **A)** The file will compile successfully, and Azure will deploy the Web App first, then the App Service Plan.
- **B)** Compilation will fail with a circular dependency error because `appServicePlan` explicitly depends on `webApp`, and `webApp` implicitly depends on `appServicePlan` via `serverFarmId`.
- **C)** The deployment will run but fail in Azure because a Web App cannot exist without a service plan.
- **D)** Bicep will ignore the explicit `dependsOn` statement because the implicit reference takes precedence.

---

### Q5 (Tricky — Scenario)
You want to deploy an Azure Key Vault secret, and you need to assign it to an existing Key Vault named `kv-prod-secrets`. This Key Vault was deployed in a different subscription. Which of the following details MUST you provide to reference this existing Key Vault?

- **A)** Only the tenant ID and resource name of the Key Vault.
- **B)** The target subscription ID, the Resource Group name where the Key Vault resides, and the resource name of the Key Vault.
- **C)** The Azure AD Object ID of the Key Vault and its resource name.
- **D)** Key Vaults in different subscriptions cannot be referenced using the `existing` keyword; you must use a Bicep module instead.
