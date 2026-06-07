# ☁️ Azure Infrastructure & Configuration Mastery: Bicep + DSC V3

[![Azure](https://img.shields.io/badge/Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![Bicep](https://img.shields.io/badge/Bicep-0078D4?style=for-the-badge&logo=bicep&logoColor=white)](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
[![Azure CLI](https://img.shields.io/badge/Azure_CLI-000000?style=for-the-badge&logo=windows-terminal&logoColor=white)](https://learn.microsoft.com/en-us/cli/azure/)
[![DSC V3](https://img.shields.io/badge/DSC_V3-Rust_CLI-E34F26?style=for-the-badge&logo=rust&logoColor=white)](https://learn.microsoft.com/en-us/powershell/dsc/overview)
[![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)

## 📖 About This Repository

This repository documents my 21-day intensive learning journey bridging **Infrastructure as Code (IaC)** and **Configuration as Code (CaC)** in Microsoft Azure. 

The goal of this project is to build a production-grade skill set that provisions Azure infrastructure using **Azure Bicep** and enforces OS-level configuration compliance using the new Rust-based **Microsoft DSC V3**. 

---

## 📂 Daily Learning Structure

To keep the learning process strictly organized and easy to follow, this repository is structured **day-by-day**. 

Inside every `DayXX` folder, you will find a complete, self-contained learning module consisting of three main components:

* 📖 **`notes.md`**: The core conceptual breakdown, syntax explanations, and architectural patterns for that day's specific topic. Start here to understand the theory.
* 🧠 **`Quiz/`**: A dedicated directory for daily knowledge validation. It contains a `questions.md` file to test the concepts learned, and an `answers.md` file with detailed explanations for every option.
* 🔨 **`ExerciseXX/`**: The hands-on practice section. This folder contains a `problem.md` detailing the real-world scenario and requirements, alongside the deployable infrastructure code (such as `main.bicep` or DSC config files) to solve it.

---

## 🚀 The 21-Day Curriculum

The journey follows a strict 3-phase path leading up to a final Capstone integration:

1. **Phase A: Azure Bicep (Days 1–8)** - Mastering core infrastructure provisioning, modules, loops, and CI/CD parameters.
2. **Phase B: Microsoft DSC V3 (Days 9–16)** - Deep dive into the next generation of Desired State Configuration (Rust CLI, YAML/JSON Configs, Drift Detection).
3. **Phase C: Convergence & Production (Days 17–21)** - Bridging DSC and Bicep via Azure Machine Configuration for full-stack, policy-driven deployment, culminating in a production-ready Capstone project.

---

## 🛠️ Tech Stack & Tools

* **Infrastructure Provisioning:** Azure Bicep, ARM Templates
* **OS Configuration:** Microsoft DSC V3 (YAML/JSON schema), PowerShell, Bash
* **Compliance & Governance:** Azure Machine Configuration (Guest Config), Azure Policy
* **Automation/CI-CD:** GitHub Actions, Azure CLI (`az`), DSC CLI (`dsc`)

---

> *"Infrastructure without configuration is just an empty building. Configuration without infrastructure is just a blueprint. Mastering both is the engineering standard."*
