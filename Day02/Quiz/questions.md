# Day 02 Quiz — Bicep Syntax & First Resource

> **Difficulty:** 1 Easy, 2 Medium, 2 Tricky (Scenario-based)

---

### Q1 (Easy)
What is the purpose of the **symbolic name** in a Bicep resource declaration?

- **A)** It becomes the actual name of the resource in Azure
- **B)** It is a nickname used to reference the resource within the Bicep file only
- **C)** It is the name of the Resource Group the resource deploys into
- **D)** It is sent to Azure as a tag on the resource

---

### Q2 (Medium)
What does `resourceGroup().location` return when used inside a Bicep file?

- **A)** The location you specified in the `targetScope` line
- **B)** The default location configured in Azure CLI via `az configure`
- **C)** The Azure region of the Resource Group that the template is being deployed into
- **D)** The region closest to your current physical location

---

### Q3 (Medium)
You write this Bicep file and deploy it. What does Azure actually receive?

```bicep
resource myVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: 'vnet-prod'
  location: 'westus'
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
  }
}
```

- **A)** The `.bicep` file is sent directly to Azure Resource Manager
- **B)** The `.bicep` file is converted to a PowerShell script and executed
- **C)** The Bicep CLI transpiles it into an ARM JSON template, which is then sent to Azure Resource Manager
- **D)** The `.bicep` file is converted to Terraform HCL and deployed via the Terraform provider

---

### Q4 (Tricky — Scenario)
You try to deploy this Bicep file but get an error. What is wrong?

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'My_Storage_Account!'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
```

- **A)** The symbolic name `storageAccount` contains a capital letter which is not allowed
- **B)** The API version `2023-01-01` is too old and no longer supported
- **C)** The resource name `My_Storage_Account!` is invalid — Storage Account names must be 3–24 characters, lowercase letters and numbers only
- **D)** The `kind` property should be inside the `properties` block, not at the top level

---

### Q5 (Tricky — Scenario)
You deploy a Bicep file with `az deployment group create` and it succeeds. You then open the Azure Portal and see the resource. You also notice a `main.json` file was NOT created in your local directory. Why?

- **A)** The deployment failed silently — check the Portal for errors
- **B)** The Bicep-to-ARM transpilation happens in memory during deployment — a `.json` file is only created if you explicitly run `az bicep build`
- **C)** The `.json` file was created but immediately deleted after deployment
- **D)** You need to add `--generate-arm` flag to the deployment command
