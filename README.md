# Terraform Labs

This repository contains comprehensive Terraform configurations for deploying Azure infrastructure using Azure Verified Modules (AVM) and standard patterns. It includes educational labs progressing from basic networking to advanced machine learning infrastructure.

## Quick Overview

### Core Directories

| Directory | Purpose | Status |
|-----------|---------|--------|
| **01-backend/** | Azure Storage backend setup for remote state | Foundation |
| **02-network/** | Virtual network and networking infrastructure | Foundation |
| **03-application/** | Application deployment resources | Foundation |
| **task3_AVM_from_scratch/** | Building infrastructure with AVM modules | Learning |
| **task4_AzureAI_with_ML/** | Complete ML infrastructure with security | Advanced |
| **avm-lab/** | AVM module exploration and testing | Reference |
| **modules/demo/** | Reusable demo module | Example |

### Task Overview

#### Task 3: AVM from Scratch
Learn to build Azure infrastructure using Azure Verified Modules with:
- Resource Group (AVM)
- Virtual Network & Subnet (AVM)
- Storage Account with Private Endpoints (AVM)
- Private DNS Zone for name resolution

[Read full documentation](task3_AVM_from_scratch/README.md)

#### Task 4: Azure AI with Machine Learning
Enterprise-grade AI/ML infrastructure featuring:
- Azure Machine Learning Workspace
- Virtual Machine with Bastion access
- Key Vault for secrets management
- Storage Account & Application Insights
- Multi-subnet virtual network with security isolation

[Read full documentation](task4_AzureAI_with_ML/README.md)

## Project Structure

```
.
├── main.tf                              # Root module configuration
├── variables.tf                         # Root module variable definitions
├── outputs.tf                           # Root module outputs
├── terraform.tfvars                     # Default variable values
├── contoso.europe.tfvars                # Europe region configuration
├── contoso.uk.tfvars                    # UK region configuration
│
├── 01-backend/                          # Backend setup for remote state
│   ├── main.tf
│   ├── terraform.tf
│   └── variables.tf
│
├── 02-network/                          # Networking infrastructure
│   ├── main.tf
│   ├── terraform.tf
│   └── variables.tf
│
├── 03-application/                      # Application resources
│   ├── main.tf
│   ├── terraform.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── variables.tf
│
├── task3_AVM_from_scratch/              # Task 3: Basic AVM usage
│   ├── main.tf
│   ├── terraform.tf
│   ├── variables.tf
│   └── README.md
│
├── task4_AzureAI_with_ML/               # Task 4: Advanced ML infrastructure
│   ├── main.tf
│   ├── terraform.tf
│   ├── variables.tf
│   ├── vnet.tf
│   ├── vm.tf
│   ├── bastion.tf
│   ├── keyvault.tf
│   ├── storage.tf
│   ├── app-insights.tf
│   ├── locals.tf
│   └── README.md
│
├── avm-lab/                             # AVM module reference implementation
│   ├── main.tf
│   ├── terraform.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   ├── outputs.tf
│   ├── data.tf
│   ├── locals.tf
│   ├── avm.*.tf                         # Individual AVM module files
│   └── terraform.tfstate*
│
├── modules/
│   └── demo/                            # Reusable demo module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
│
├── storage_account/                     # Storage account configuration
│   └── main.tf
│
└── assets/                              # Diagrams and documentation
    ├── task3.png                        # Task 3 architecture diagram
    └── task4.png                        # Task 4 architecture diagram
```

## Features

- **Modular Design**: Reusable modules for infrastructure components
- **Multi-Environment Support**: Separate `.tfvars` files for different environments/regions
- **Azure Backend**: Remote state management using Azure Storage
- **Azure Verified Modules**: Official AVM modules for best-practice infrastructure
- **Enterprise Security**: Network isolation, managed identities, and secrets management
- **Progressive Learning**: Tasks organized from basic to advanced

## Learning Path

This repository is designed as a progressive learning experience:

1. **Foundation (01-04)**: Start with backend setup, networking, and basic application resources
2. **Task 3 - AVM Fundamentals**: Learn Azure Verified Modules with a simple storage + networking example
3. **Task 4 - Advanced Infrastructure**: Build an enterprise ML platform with multiple security layers and compute resources
4. **AVM Lab**: Explore individual AVM modules in detail

## Resource Deployment

The configurations deploy various Azure resources including:

- Resource Groups
- Virtual Networks & Subnets
- Virtual Machines (Linux/Windows)
- Storage Accounts
- Key Vaults
- Application Insights
- Azure Bastion
- Azure Machine Learning Workspaces
- Private DNS Zones
- Private Endpoints

## Getting Started by Task

### For Beginners: Tasks 1-2 (Foundation)

Start with the numbered directories to understand basic Terraform and Azure concepts:

```bash
cd 01-backend
terraform init
terraform plan
terraform apply
```

Then progress to `02-network` and `03-application`.

### For Intermediate: Task 3 (AVM Fundamentals)

Learn Azure Verified Modules with a focused example:

```bash
cd task3_AVM_from_scratch
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

**Key Concepts**: AVM modules, private endpoints, DNS resolution

### For Advanced: Task 4 (ML Infrastructure)

Build a complete enterprise ML platform with security best practices:

```bash
cd task4_AzureAI_with_ML
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

**Key Concepts**: Multi-subnet networking, managed identities, bastion access, secrets management, ML workspace integration

## Module Documentation

- [Task 3: AVM from Scratch](task3_AVM_from_scratch/README.md) - Simple AVM usage with storage and networking
- [Task 4: Azure AI with ML](task4_AzureAI_with_ML/README.md) - Enterprise ML infrastructure
- [Demo Module](modules/demo/README.md) - Reusable infrastructure module

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) ~> 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and configured
- Azure subscription with appropriate permissions
- Azure Storage Account for remote state (optional but recommended)

## Getting Started

### 1. Authentication

Log in to Azure:

```bash
az login
```

### 2. Initialize Terraform

**Option A: Local State**

```bash
terraform init
```

**Option B: Remote State (Azure Storage)**

```bash
terraform init \
    -backend-config="storage_account_name=<your-storage-account>" \
    -backend-config="container_name=tfstate" \
    -backend-config="key=terraform.tfstate" \
    -backend-config="use_azuread_auth=true"
```

### 3. Plan

Review the planned changes:

```bash
terraform plan
```

Or use a specific variable file:

```bash
terraform plan -var-file="contoso.uk.tfvars"
terraform plan -var-file="contoso.europe.tfvars"
```

### 4. Apply

Deploy the infrastructure:

```bash
terraform apply
```

Or with a specific configuration:

```bash
terraform apply -var-file="contoso.uk.tfvars"
```

### 5. Destroy

Remove all deployed resources:

```bash
terraform destroy
```

## Configuration

### Variables

Key variables defined in `variables.tf`:

| Variable | Type | Description | Default |
|----------|------|-------------|---------|
| `prefix` | string | Prefix for all resources | "contoso" |
| `region` | string | Azure region for deployment | "UK South" |
| `resource_groups` | map(string) | Map of resource groups to create | - |
| `virtual_networks` | map(object) | Virtual network configurations | - |
| `tags` | map(any) | Tags to apply to resources | - |

### Supported Regions

- UK South
- UK West
- North Europe
- West Europe
- East US
- West US

### Example Configuration

See `terraform.tfvars` for a complete example:

```hcl
resource_groups = {
  dev     = "research_dev_rg"
  staging = "research_staging_rg"
  prod    = "research_prod_rg"
}

tags = {
  cost_center = "contoso research"
}

virtual_networks = {
  dev = {
    name               = "vnet-dev"
    resource_group_key = "dev"
    address_space      = ["10.0.0.0/16"]
    subnets = {
      subnet1 = {
        name           = "subnet-dev-1"
        address_prefix = "10.0.0.0/24"
      }
    }
  }
}
```

## Module: Demo

The `demo` module handles the creation of:

- **Resource Groups**: Environment-based resource groups
- **Virtual Networks**: VNets with configurable address spaces
- **Subnets**: Dynamically created subnets within VNets

For more details, see [modules/demo/README.md](modules/demo/README.md).

## Outputs

- `resource_group_ids`: IDs of created resource groups

## Best Practices

1. **Always run `terraform plan`** before applying changes
2. **Use remote state** for team collaboration
3. **Use separate `.tfvars` files** for different environments
4. **Tag resources** appropriately for cost tracking and management
5. **Review state files** regularly and ensure they're backed up

## Troubleshooting

### Backend Configuration Issues

If you encounter errors during `terraform init` with remote backend:

- Verify storage account name and container exist
- Ensure you have appropriate RBAC permissions (Storage Blob Data Contributor)
- Check Azure AD authentication is working: `az account show`

### Provider Version Conflicts

If you see provider version errors:

```bash
terraform init -upgrade
```

## License

[Add your license information here]

## Contributing

[Add contribution guidelines here]
