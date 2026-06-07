# Day 4: Data Types, Expressions & Functions

---

## Day 3 Rapid Recap

- **`param`** = user-provided input (with optional default values)
- **`var`** = computed values inside the template (NOT user-provided)
- **`output`** = values returned after deployment (resource ID, endpoints, etc.)
- **Decorators:** `@description`, `@allowed`, `@minLength`, `@maxLength`, `@minValue`, `@maxValue`, `@secure()`
- **Pass params:** inline `--parameters key='val'` or via JSON parameter file

---

## Section 1: Data Types in Depth

You've already seen `string`, `int`, and `bool`. Let's go deeper into each 
type and two important ones you haven't used yet: `array` and `object`.

### String

```bicep
param name string = 'hello'

// String interpolation — embed expressions inside strings
var greeting = 'Hello, ${name}!'        // → 'Hello, hello!'

// Multi-line strings — use triple quotes
var longText = '''
This is line one.
This is line two.
No need for escape characters here.
'''
```

**String interpolation** is the `${}` syntax. Everything inside `${}` is 
evaluated as an expression:

```bicep
param project string = 'myapp'
param env string = 'dev'

var resourceName = '${project}-${env}-storage'    // → 'myapp-dev-storage'
var resourceName2 = '${project}${env}sa'          // → 'myappdevsa'
```

> ⚠️ **Common Mistake:** You CANNOT use string interpolation inside single-quoted 
> strings without the `${}` wrapper. `'project-env'` is literal text, not a 
> variable reference.

### Integer

```bicep
param count int = 3
param port int = 443

var doubled = count * 2          // → 6
var nextPort = port + 1          // → 444
```

Supports standard math: `+`, `-`, `*`, `/`, `%` (modulo).

### Boolean

```bicep
param enableHttps bool = true
param enableBackup bool = false
```

Used heavily with conditions (Day 7) and the ternary operator (covered below).

### Array

An ordered list of values:

```bicep
// Array of strings
param allowedRegions array = [
  'eastus'
  'westus'
  'centralindia'
]

// Array of integers
var ports = [80, 443, 8080]

// Accessing elements (zero-indexed)
var firstRegion = allowedRegions[0]    // → 'eastus'
var httpsPort = ports[1]               // → 443
```

> ⚠️ **Array items are separated by newlines** (no commas needed in Bicep, 
> though commas also work). This is different from JSON.

### Object

A collection of key-value pairs (like a dictionary or map):

```bicep
param tags object = {
  environment: 'dev'
  project: 'myapp'
  owner: 'ashish'
}

// Accessing properties
var env = tags.environment           // → 'dev'
var owner = tags['owner']            // → 'ashish' (bracket syntax also works)
```

**Nested objects:**
```bicep
var config = {
  storage: {
    sku: 'Standard_LRS'
    kind: 'StorageV2'
  }
  network: {
    addressPrefix: '10.0.0.0/16'
  }
}

var storageSku = config.storage.sku    // → 'Standard_LRS'
```

---

## Section 2: The Ternary Operator — Inline If/Else

The ternary operator lets you choose between two values based on a condition:

```
<condition> ? <value-if-true> : <value-if-false>
```

```bicep
param isProduction bool = false

// If production, use GRS (geo-redundant). Otherwise, use LRS (cheapest).
var skuName = isProduction ? 'Standard_GRS' : 'Standard_LRS'

// If production, use 3 instances. Otherwise, use 1.
var instanceCount = isProduction ? 3 : 1
```

This is extremely useful for environment-specific configurations:

```bicep
param environment string = 'dev'

var sku = environment == 'prod' ? 'Standard_GRS' : 'Standard_LRS'
var tier = environment == 'prod' ? 'Premium' : 'Standard'
```

> ✅ **Best Practice:** Use ternary for simple either/or decisions. For complex 
> multi-branch logic, wait for Day 7 (conditions).

---

## Section 3: Built-in Functions

Bicep has many built-in functions. Here are the ones you'll use most often:

### `resourceGroup()` — Get Resource Group Info

Returns an object with details about the current resource group:

```bicep
var rgName = resourceGroup().name           // → 'rg-myapp-dev'
var rgLocation = resourceGroup().location   // → 'eastus'
var rgId = resourceGroup().id               // → '/subscriptions/.../resourceGroups/rg-myapp-dev'
```

### `subscription()` — Get Subscription Info

```bicep
var subId = subscription().subscriptionId   // → 'eb85cc75-9f5e-...'
var subName = subscription().displayName    // → 'My Azure Subscription'
var tenantId = subscription().tenantId      // → 'xxxxxxxx-xxxx-...'
```

### `uniqueString()` — Generate Deterministic Unique Hash

This is the function you already used in Day 2! It generates a **13-character 
deterministic hash** from the input values:

```bicep
// Same input → always same output (deterministic)
var hash1 = uniqueString(resourceGroup().id)     // → 'a4x7k2m9p3q1w'

// Different input → different output
var hash2 = uniqueString(subscription().subscriptionId)  // → different hash

// Multiple inputs
var hash3 = uniqueString(resourceGroup().id, 'storage')  // → yet another hash
```

**Why it's useful:** Storage Account names must be globally unique across ALL 
of Azure. `uniqueString()` generates a hash based on your resource group ID, 
which is unique to your subscription — so the name is practically guaranteed 
to be unique:

```bicep
param projectName string = 'myapp'

var storageName = '${projectName}${uniqueString(resourceGroup().id)}'
// → 'myappa4x7k2m9p3q1w' (unique per resource group)
```

> ⚠️ **Important:** `uniqueString()` is deterministic — the same input ALWAYS 
> produces the same output. It's NOT random. Deploy twice with the same RG → 
> same hash → same storage name → Azure updates existing resource instead of 
> creating a duplicate.

### `toLower()` and `toUpper()` — Case Conversion

```bicep
var lower = toLower('Hello World')   // → 'hello world'
var upper = toUpper('Hello World')   // → 'HELLO WORLD'
```

Useful for storage accounts (must be lowercase):
```bicep
param name string = 'MyStorage'
var storageName = toLower(name)      // → 'mystorage'
```

### `length()` — Get Length of String, Array, or Object

```bicep
var strLen = length('hello')           // → 5
var arrLen = length(['a', 'b', 'c'])   // → 3
var objLen = length({ a: 1, b: 2 })    // → 2 (number of keys)
```

### `contains()` — Check if Value Exists

```bicep
var hasItem = contains(['dev', 'prod'], 'dev')      // → true
var hasKey = contains({ name: 'app' }, 'name')       // → true
var hasSubstr = contains('hello world', 'world')     // → true
```

### `empty()` — Check if Value is Empty

```bicep
var isEmpty1 = empty('')          // → true
var isEmpty2 = empty([])          // → true
var isEmpty3 = empty('hello')     // → false
```

### `replace()` — Replace Text in String

```bicep
var result = replace('hello-world', '-', '_')    // → 'hello_world'
```

### `split()` and `join()` — Break Apart and Combine

```bicep
var parts = split('a,b,c', ',')        // → ['a', 'b', 'c']
var joined = join(['a', 'b', 'c'], '-') // → 'a-b-c'
```

### `substring()` — Extract Part of a String

```bicep
var sub = substring('hello world', 0, 5)    // → 'hello'
//                   string, startIndex, length
```

### `format()` — Formatted Strings

```bicep
var msg = format('Storage {0} in {1}', 'mysa', 'eastus')
// → 'Storage mysa in eastus'
```

---

## Section 4: Combining Functions — Real Patterns

### Pattern 1: Guaranteed Unique Lowercase Name

```bicep
param projectName string

var storageName = toLower('${projectName}${uniqueString(resourceGroup().id)}')
```

### Pattern 2: Environment-Aware SKU Selection

```bicep
param environment string = 'dev'

var skuName = environment == 'prod' ? 'Standard_GRS' : 'Standard_LRS'
var storageTier = environment == 'prod' ? 'Hot' : 'Cool'
```

### Pattern 3: Common Tags Computed From Parameters

```bicep
param projectName string
param environment string

var commonTags = {
  environment: environment
  project: projectName
  uniqueId: uniqueString(resourceGroup().id)
  deployedAt: 'bicep'
}
```

### Pattern 4: Naming Convention with Subscription Info

```bicep
param projectName string
param environment string

var prefix = '${projectName}-${environment}'
var storageName = toLower('${projectName}${environment}${uniqueString(subscription().subscriptionId)}')
var vnetName = '${prefix}-vnet'
var subnetName = '${prefix}-subnet'
```

---

## Key Takeaways — Day 4

1. **5 data types:** `string`, `int`, `bool`, `array`, `object`
2. **String interpolation:** `'${variable}'` embeds expressions in strings
3. **Ternary operator:** `condition ? trueValue : falseValue` for inline decisions
4. **`resourceGroup()`** returns `.name`, `.location`, `.id`
5. **`subscription()`** returns `.subscriptionId`, `.displayName`, `.tenantId`
6. **`uniqueString()`** generates a deterministic 13-char hash — key for globally unique names
7. **`toLower()`** ensures lowercase (required for storage accounts)
8. **`contains()`**, **`empty()`**, **`length()`** for checking values
9. **`replace()`**, **`split()`**, **`join()`**, **`substring()`** for string manipulation
10. **Combine functions** for real-world naming patterns
