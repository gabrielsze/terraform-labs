# Terraform Labs

This repository contains Terraform configurations for deploying Azure infrastructure with a modular design.

## Project Structure

```
.
├── main.tf                    # Root module configuration
├── variables.tf               # Root module variable definitions
├── outputs.tf                 # Root module outputs
├── terraform.tfvars           # Default variable values
├── contoso.europe.tfvars      # Europe region configuration
├── contoso.uk.tfvars          # UK region configuration
├── modules/
│   └── demo/                  # Demo module for Azure resources
│       ├── main.tf            # Resource definitions
│       ├── variables.tf       # Module variables
│       ├── outputs.tf         # Module outputs
│       └── README.md          # Module documentation
└── storage_account/           # Storage account configuration
```

## Features

- **Modular Design**: Reusable modules for infrastructure components
- **Multi-Environment Support**: Separate `.tfvars` files for different environments/regions
- **Azure Backend**: Remote state management using Azure Storage
- **Resource Deployment**:
  - Resource Groups
  - Virtual Networks
  - Subnets (with dynamic subnet creation)

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
