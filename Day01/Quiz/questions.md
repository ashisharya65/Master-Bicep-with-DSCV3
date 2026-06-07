# 📝 Day 01 Quiz — IaC Fundamentals & Environment Setup

> **Difficulty:** 1 Easy, 2 Medium, 2 Tricky (Scenario-based)

---

### Q1 (Easy)
What does "Infrastructure as Code" mean?

- **A)** Writing Python scripts to monitor Azure resources
- **B)** Defining cloud infrastructure in code files that can be versioned, reviewed, and reused
- **C)** Using the Azure Portal to create resources and then exporting the template
- **D)** Automating the installation of software on virtual machines

---

### Q2 (Medium)
What happens when you run `az deployment group create --template-file main.bicep`?

- **A)** Azure directly reads and executes the `.bicep` file
- **B)** The Bicep CLI transpiles the `.bicep` file into an ARM (JSON) template, then Azure deploys that ARM template
- **C)** The `.bicep` file is uploaded to Azure Blob Storage and executed by a serverless function
- **D)** Bicep sends REST API calls directly to each resource provider, bypassing ARM completely

---

### Q3 (Medium)
Which of the following is a key advantage of Azure Bicep over Terraform when working exclusively with Azure?

- **A)** Bicep supports multi-cloud deployments (AWS, GCP, Azure)
- **B)** Bicep has a larger community and more third-party modules
- **C)** Bicep requires no state file management — Azure itself is the source of truth
- **D)** Bicep uses HCL syntax which is easier to learn than JSON

---

### Q4 (Tricky — Scenario)
Your company has 3 environments: dev, staging, and production. A junior admin manually created the staging environment through the Azure Portal last month. Now staging behaves differently from production and nobody knows why. Which IaC pillar would have **prevented** this problem?

- **A)** Speed — deploying faster would have avoided the issue
- **B)** Repeatability — using the same code file for all environments ensures identical configurations
- **C)** Collaboration — having more people click through the Portal would have caught the mistake
- **D)** Drift Detection — IaC would have automatically fixed the staging environment in real-time

---

### Q5 (Tricky — Scenario)
You are setting up your Bicep development environment. You run `az bicep version` and get an error: `'bicep' is not recognized`. You then run `az --version` and it works fine. What is the most likely cause and fix?

- **A)** Azure CLI is not installed — reinstall it with `winget install Microsoft.AzureCLI`
- **B)** You need to run `az login` first before Bicep commands work
- **C)** The Bicep CLI is not installed yet — run `az bicep install` to install it
- **D)** Your VS Code Bicep extension is missing — install it from the Extensions panel
