# ☁️ Azure Infrastructure & Configuration Mastery: Bicep + DSC V3

[![Azure](https://img.shields.io/badge/Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![Bicep](https://img.shields.io/badge/Bicep-0078D4?style=for-the-badge&logo=bicep&logoColor=white)](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
[![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![DSC V3](https://img.shields.io/badge/DSC_V3-Rust_CLI-E34F26?style=for-the-badge&logo=rust&logoColor=white)](https://learn.microsoft.com/en-us/powershell/dsc/overview)

## 📖 About This Repository

This repository documents my 21-day intensive learning journey bridging **Infrastructure as Code (IaC)** and **Configuration as Code (CaC)** in Microsoft Azure. 

The goal of this project is to build a production-grade skill set that provisions Azure infrastructure using **Azure Bicep** and enforces OS-level configuration compliance using the new Rust-based **Microsoft DSC V3**. This dual-technology approach ensures that not only is the infrastructure deployed consistently, but the guest operating systems are securely configured and strictly monitored for drift via Azure Machine Configuration.

---

## 🚀 The 21-Day Journey

The curriculum is broken down into three distinct phases. Each directory in this repository corresponds to a specific day, complete with conceptual notes, hands-on mini-projects, code reviews, and deployable templates.

### Phase A: Azure Bicep (Days 1–8)
Mastering the core of Azure infrastructure provisioning.
* **Day 1-2:** IaC Fundamentals, Environment Setup, and Syntax.
* **Day 3-5:** Parameters, Variables, Data Types, Expressions, and Explicit/Implicit Dependencies.
* **Day 6-8:** Modularity, Advanced Control Flows (Loops/Conditions), Scopes, and CI/CD pipelines.

### Phase B: Microsoft DSC V3 (Days 9–16)
Deep dive into the next generation of Desired State Configuration.
* **Day 9-10:** DSC V3 Architecture (Rust CLI), YAML/JSON Configs, and Environment Prep.
* **Day 11-13:** Built-in Resources, PowerShell Adapters for legacy support, and inter-resource references.
* **Day 14-16:** Drift Detection, Cross-Platform Linux Configuration, and Custom Resource Manifesting.

### Phase C: Convergence & Production (Days 17–21)
Bringing it all together into a unified, automated deployment.
* **Day 17-18:** Azure Machine Configuration integration and full-stack deployment patterns.
* **Day 19-21:** **The Capstone Project.** A complete, end-to-end multi-tier architecture deployment featuring networking, compute (Windows & Linux), Key Vaults, and strict OS-level compliance driven by GitHub Actions.

---

## 🛠️ Tech Stack & Tools

* **Infrastructure Provisioning:** Azure Bicep
* **OS Configuration:** Microsoft DSC V3 (YAML/JSON schema), PowerShell, Bash
* **Compliance & Governance:** Azure Machine Configuration (Guest Config), Azure Policy
* **Automation/CI-CD:** GitHub Actions, Azure CLI (`az`), DSC CLI (`dsc`)
* **Environment:** Visual Studio Code

---
