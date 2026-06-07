# Day 04 Quiz — Data Types, Expressions & Functions

> **Difficulty:** 1 Easy, 2 Medium, 2 Tricky (Scenario-based)

---

### Q1 (Easy)
What does `uniqueString(resourceGroup().id)` return?

- **A)** A random string that changes every time you deploy
- **B)** A deterministic 13-character hash that is always the same for the same input
- **C)** The name of the resource group
- **D)** A GUID (36-character unique identifier)

---

### Q2 (Medium)
What is the result of this expression?

```bicep
var name = toLower('MyApp${substring(uniqueString('seed'), 0, 4)}')
```

- **A)** `'MyAppa1b2'` — `toLower` only affects the `'MyApp'` part, not the hash
- **B)** `'myappa1b2'` — `toLower` converts the entire resulting string to lowercase
- **C)** An error — you cannot nest functions inside string interpolation
- **D)** `'myapp'` — `substring` and `uniqueString` are ignored inside `toLower`

---

### Q3 (Medium)
Which of these correctly accesses the second element of an array in Bicep?

```bicep
var regions = ['eastus', 'westus', 'centralindia']
```

- **A)** `regions[2]`
- **B)** `regions[1]`
- **C)** `regions.1`
- **D)** `regions(1)`

---

### Q4 (Tricky — Scenario)
You deploy this template with `--parameters environment='staging'`:

```bicep
param environment string = 'dev'

var sku = environment == 'prod' ? 'Standard_GRS' : 'Standard_LRS'

resource stg 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'mystore123'
  location: resourceGroup().location
  sku: { name: sku }
  kind: 'StorageV2'
}
```

What SKU does the storage account get?

- **A)** `Standard_GRS` because `staging` is close to `prod`
- **B)** `Standard_LRS` because the ternary only checks for `'prod'` — anything else gets the false branch
- **C)** An error because `staging` is not handled by the ternary operator
- **D)** `Standard_LRS` because the default value `'dev'` is used regardless of what you pass

---

### Q5 (Tricky — Scenario)
What is wrong with this code?

```bicep
param project string = 'app'
param env string = 'dev'

var storageName = '${project}-${env}-storage-account-primary-data'

resource stg 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: resourceGroup().location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
}
```

- **A)** String interpolation cannot use two variables in the same string
- **B)** The variable `storageName` contains hyphens and exceeds 24 characters — both violate Storage Account naming rules
- **C)** The `param` keyword cannot have default values when used with string interpolation
- **D)** The `kind` property is not valid for Storage Accounts
