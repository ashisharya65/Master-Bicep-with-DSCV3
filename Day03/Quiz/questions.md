# Day 03 Quiz — Parameters, Variables & Outputs

> **Difficulty:** 1 Easy, 2 Medium, 2 Tricky (Scenario-based)

---

### Q1 (Easy)
What is the difference between a `param` and a `var` in Bicep?

- **A)** `param` values are computed inside the template; `var` values are provided by the user
- **B)** `param` values are provided by the user at deployment time; `var` values are computed inside the template
- **C)** Both are identical — they are interchangeable keywords
- **D)** `param` is for strings only; `var` is for all other data types

---

### Q2 (Medium)
What happens if you deploy this template WITHOUT providing the `storageAccountName` parameter?

```bicep
@minLength(3)
param storageAccountName string

param location string = resourceGroup().location
```

- **A)** It deploys successfully using an empty string for the name
- **B)** It deploys successfully using the resource group's name as the storage account name
- **C)** The deployment fails because `storageAccountName` has no default value and is required
- **D)** The deployment fails because `@minLength(3)` prevents empty values

---

### Q3 (Medium)
Which decorator would you use to ensure a password parameter is NOT visible in Azure deployment logs or Portal history?

- **A)** `@allowed()`
- **B)** `@description('sensitive')`
- **C)** `@secure()`
- **D)** `@maxLength(128)`

---

### Q4 (Tricky — Scenario)
You have this Bicep file:

```bicep
@allowed(['dev', 'prod'])
param env string = 'dev'

var storageName = '${env}storage'

resource stg 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: resourceGroup().location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
}

output name string = stg.name
```

You deploy with: `--parameters env='staging'`

What happens?

- **A)** It deploys a storage account named `stagingstorage`
- **B)** The deployment fails because `'staging'` is not in the `@allowed` list
- **C)** The deployment succeeds but uses the default value `'dev'` instead
- **D)** The deployment fails because the variable `storageName` cannot use string interpolation

---

### Q5 (Tricky — Scenario)
You deploy this template and the deployment succeeds. What will the output `blobUrl` contain?

```bicep
param name string = 'testsa2026'

resource stg 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: resourceGroup().location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
}

output blobUrl string = stg.properties.primaryEndpoints.blob
```

- **A)** An empty string because `properties` is not defined in the resource block
- **B)** The full blob endpoint URL like `https://testsa2026.blob.core.windows.net/`
- **C)** The deployment fails because you cannot access `properties` in outputs
- **D)** The string `stg.properties.primaryEndpoints.blob` literally
