# Day 3: Parameters, Variables & Outputs

---

## Day 2 Rapid Recap

- **`resource`** keyword declares Azure resources
- **Symbolic name** = in-file nickname (camelCase), NOT the Azure name
- **Resource type format:** `Provider/Type@YYYY-MM-DD` 
- **`resourceGroup().location`** = dynamic location instead of hardcoding
- **Deploy:** `az deployment group create --resource-group <rg> --template-file <file>`
- **`az bicep build`** = transpile to ARM JSON on disk

---

## Section 1: The Problem — Static Templates Don't Scale

Look at what we built on Day 2:

```bicep
resource stgaccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'mystg12345'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
```

This works, but it has problems:

| Problem | Why It's Bad |
|---------|-------------|
| Name is hardcoded | Can't reuse this file for a second storage account |
| SKU is hardcoded | Dev needs `Standard_LRS`, prod needs `Standard_GRS` — two separate files? |
| No output | After deployment, you don't know the storage account's ID or endpoint |

**Solution:** Parameters make templates accept input. Variables simplify repeated values. Outputs return information after deployment.

Think of it like a function:
```
Parameters = function arguments (input)
Variables  = local variables (internal computation)
Outputs    = return values (what you get back)
```

---

## Section 2: Parameters — Making Templates Accept Input

### The `param` Keyword

```bicep
// Declare a parameter
param storageAccountName string
```

That's it. This tells Bicep: "When someone deploys this file, they MUST provide a value for `storageAccountName`."

### Using Parameters in Resources

```bicep
param storageAccountName string
param location string

resource stgAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName        // ← Using the parameter
  location: location              // ← Using the parameter
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
```

Now the same file can deploy storage accounts with ANY name in ANY region.

### Parameter Types

Bicep supports these data types for parameters:

| Type | Example | Use Case |
|------|---------|----------|
| `string` | `'hello'` | Names, locations, SKUs |
| `int` | `42` | Counts, sizes, ports |
| `bool` | `true` / `false` | Enable/disable features |
| `array` | `['a', 'b', 'c']` | Lists of values |
| `object` | `{ key: 'value' }` | Complex configurations |

```bicep
param name string
param instanceCount int
param enableBackup bool
param allowedIPs array
param tags object
```

### Default Values

If you don't want to FORCE the user to provide a value every time, set a default:

```bicep
// Required — user MUST provide this
param storageAccountName string

// Optional — uses 'Standard_LRS' if not provided
param skuName string = 'Standard_LRS'

// Optional — uses resource group location if not provided
param location string = resourceGroup().location
```

> ⚠️ **Common Mistake:** If a parameter has no default value and you don't 
> provide it during deployment, the deployment FAILS with an error.

---

## Section 3: Parameter Decorators — Adding Rules

Decorators are special annotations (starting with `@`) that add validation 
rules and metadata to parameters. They go on the line ABOVE the parameter.

### `@description` — Document What It Does

```bicep
@description('The globally unique name for the storage account.')
param storageAccountName string
```

This shows up in IntelliSense and in the Azure Portal when deploying via the UI.

### `@allowed` — Restrict to Specific Values

```bicep
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
])
param skuName string = 'Standard_LRS'
```

If someone tries to pass `'Premium_LRS'`, deployment fails with a clear error. 
This prevents invalid configurations.

### `@minLength` and `@maxLength` — String Length Rules

```bicep
@minLength(3)
@maxLength(24)
param storageAccountName string
```

Storage Account names must be 3–24 characters. This catches bad names BEFORE 
deployment instead of getting a cryptic Azure error.

### `@minValue` and `@maxValue` — Number Range Rules

```bicep
@minValue(1)
@maxValue(10)
param instanceCount int = 1
```

### `@secure` — Hide Sensitive Values

```bicep
@secure()
param adminPassword string
```

This ensures the password is:
- NOT logged in deployment history
- NOT visible in the Azure Portal deployment details
- Treated as sensitive by Azure

> ✅ **Best Practice:** Always use `@secure()` for passwords, connection 
> strings, API keys, and any secret values.

### Combining Multiple Decorators

You can stack decorators:

```bicep
@description('Name of the storage account. Must be globally unique.')
@minLength(3)
@maxLength(24)
param storageAccountName string
```

---

## Section 4: Variables — Internal Computed Values

Variables are values you compute INSIDE the template. They're not provided 
by the user — they're calculated from parameters or hardcoded for reuse.

### The `var` Keyword

```bicep
param projectName string = 'myapp'
param environment string = 'dev'

// Variable — computed from parameters
var storageName = '${projectName}${environment}sa'
```

### When to Use Variables vs Parameters

| Use Case | Use Parameter | Use Variable |
|----------|:---:|:---:|
| User needs to provide a value | ✅ | ❌ |
| Value is computed from other values | ❌ | ✅ |
| Value is reused in multiple places | Maybe | ✅ |
| Value should be validated with decorators | ✅ | ❌ |

### Practical Example

```bicep
param projectName string
param environment string = 'dev'

// Variables — computed once, used many times
var storageName = '${projectName}${environment}sa'
var appName = '${projectName}-${environment}-app'
var commonTags = {
  environment: environment
  project: projectName
  deployedBy: 'bicep'
}

resource stgAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName          // ← Using variable
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: commonTags           // ← Using variable (reused object)
}
```

Notice how `commonTags` is defined once and can be reused across multiple 
resources — that's the power of variables.

> ⚠️ **Variables vs Parameters:** Variables CANNOT have decorators (`@allowed`, 
> `@description`, etc.). Only parameters can.

---

## Section 5: Outputs — Returning Values After Deployment

After a deployment completes, you often need information back — like the 
resource ID, a URL, or an endpoint. That's what outputs are for.

### The `output` Keyword

```bicep
output storageAccountId string = stgAccount.id
```

Format:
```
output <name> <type> = <value>
```

### Accessing Resource Properties

Every deployed resource exposes properties you can reference using the 
symbolic name:

```bicep
resource stgAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'mystorageacct2026'
  location: resourceGroup().location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
}

// Outputs — values returned after deployment
output storageId string = stgAccount.id
output storageName string = stgAccount.name
output primaryEndpoint string = stgAccount.properties.primaryEndpoints.blob
```

After deployment, the CLI shows these outputs:

```json
"outputs": {
  "storageId": { "value": "/subscriptions/.../storageAccounts/mystorageacct2026" },
  "storageName": { "value": "mystorageacct2026" },
  "primaryEndpoint": { "value": "https://mystorageacct2026.blob.core.windows.net/" }
}
```

### Output Types

Outputs support the same types as parameters: `string`, `int`, `bool`, 
`array`, `object`.

```bicep
output accountName string = stgAccount.name
output isDeployed bool = true
output endpoints object = stgAccount.properties.primaryEndpoints
```

---

## Section 6: Passing Parameters During Deployment

### Method 1: Inline via CLI

```powershell
az deployment group create \
  --resource-group rg-day3 \
  --template-file main.bicep \
  --parameters storageAccountName='myuniquestore123' skuName='Standard_GRS'
```

### Method 2: From a JSON Parameter File

Create a file called `main.parameters.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "value": "myuniquestore123"
    },
    "skuName": {
      "value": "Standard_GRS"
    }
  }
}
```

Deploy with:
```powershell
az deployment group create \
  --resource-group rg-day3 \
  --template-file main.bicep \
  --parameters main.parameters.json
```

> ⚠️ **Common Mistake:** The JSON parameter file has a specific schema. Don't 
> forget the `$schema` and `contentVersion` at the top, and each parameter must 
> be wrapped in a `"value"` object.

### Method 3: Mix Both (Override specific values)

```powershell
az deployment group create \
  --resource-group rg-day3 \
  --template-file main.bicep \
  --parameters main.parameters.json \
  --parameters skuName='Standard_ZRS'
```

The inline parameter overrides the file's value for `skuName`.

---

## Section 7: Putting It All Together — Complete Example

```bicep
// =========== PARAMETERS ===========

@description('Project name used as prefix for all resources.')
@minLength(2)
@maxLength(10)
param projectName string

@description('Deployment environment.')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string = 'dev'

@description('Azure region for deployment.')
param location string = resourceGroup().location

@description('Storage Account SKU.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
])
param skuName string = 'Standard_LRS'

// =========== VARIABLES ===========

var storageName = '${projectName}${environment}sa'
var commonTags = {
  environment: environment
  project: projectName
}

// =========== RESOURCES ===========

resource stgAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  tags: commonTags
}

// =========== OUTPUTS ===========

output storageAccountId string = stgAccount.id
output storageAccountName string = stgAccount.name
output blobEndpoint string = stgAccount.properties.primaryEndpoints.blob
```

Deploy:
```powershell
az deployment group create \
  --resource-group rg-day3 \
  --template-file main.bicep \
  --parameters projectName='myapp' environment='dev'
```

---

## Key Takeaways — Day 3

1. **`param`** = input values from the user (like function arguments)
2. **`var`** = computed values inside the template (like local variables)
3. **`output`** = values returned after deployment (like return values)
4. **Decorators** = `@description`, `@allowed`, `@minLength`, `@maxLength`, `@minValue`, `@maxValue`, `@secure()`
5. **Default values** make parameters optional: `param x string = 'default'`
6. **Pass parameters** via CLI inline (`--parameters key='val'`) or via JSON parameter file
7. **`@secure()`** hides sensitive values from deployment logs — always use for secrets
8. **Variables** for computed values reused across resources (e.g., `commonTags`)
