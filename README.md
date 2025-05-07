# tfc_azure_lz_core

Deploy the core infrastructure for the Azure landing zone using Terraform Cloud. This module establishes the foundational management group hierarchy and security principals.

## Features

- Management Group Hierarchy
  - Root Management Group
  - Management Groups
- Azure AD Security Groups
  - Automated group creation for each management group
  - RBAC role assignments (Owner, Contributor, Reader)
- Foundational Governance Structure

## Prerequisites

- Terraform Cloud account
- Azure tenant
- Azure AD application with configured federation (I'm using federation, you can use other auth methods you prefer) and all required permissions (create management groups, create security groups, assign roles)

## Technical Requirements

- Terraform ~> 1.0
- Azure Provider (azurerm) ~> 4.0
- Azure AD Provider (azuread) ~> 3.0

## Required Environment Variables

- `ARM_SUBSCRIPTION_ID`: Azure Subscription ID (you first default subscription id, not in use in this deployment, but needed by Terraform)
- `ARM_TENANT_ID`: Azure Tenant (Directory) ID (value: your tenant ID)
- `TFC_AZURE_PROVIDER_AUTH`: Enable Terraform Cloud Azure Provider Authentication (value: true)
- `TFC_AZURE_RUN_CLIENT_ID`: Client ID for Azure AD App used in dynamic credentials (value: your app client ID)

## Usage
 - clone repo
 - edit config/management_groups_tree.json , dont change keys, only values. Remeber that names must be unique
 - provide value for the `parent_mng_group_name` variable at Workspace variables, this is your root management group name
 - run `terraform init` and `terraform apply`
 
## Module Structure

```
.
├── main.tf                                 # Main resource definitions
├── variables.tf                            # Input variables
├── outputs.tf                              # Output values
├── versions.tf                             # Provider and terraform versions
├── locals.tf                               # Local variables
└── config/management_groups_tree.json      # Management groups tree configuration
```

## Next Steps

After deploying this core deployment, proceed with:
1. Subscription management deployment
2. Policy deployments:
   - Management policies (tags, naming, resources)
   - Compliance policies (SOC2 and others industries known policies)
   - Internal security policies

## Contributing

Please refer to the contribution guidelines for this project.