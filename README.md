# tfc_azure_lz_core

Deploy core infrastructure for an Azure Landing Zone using Terraform Cloud. This module sets up the foundational management group hierarchy and security principals.

## Features

- **Management Group Hierarchy**
  - Root Management Group
  - Nested Management Groups
- **Azure AD Security Groups**
  - Automated group creation per management group
  - Role assignments (Owner, Contributor, Reader)
- **Foundational Governance Structure**

## Prerequisites

- Terraform Cloud account
- Azure tenant
- Azure AD application with configured federation (or any other preferred authentication method), with the following permissions:
  - Create management groups
  - Create security groups
  - Assign RBAC roles

## Technical Requirements

- Terraform `~> 1.0`
- Azure Provider (`azurerm`) `~> 4.0`
- Azure AD Provider (`azuread`) `~> 3.0`

## Required Environment Variables

| Variable                 | Description                                                                         |
|--------------------------|-------------------------------------------------------------------------------------|
| `ARM_SUBSCRIPTION_ID`    | Azure Subscription ID (used by Terraform, not directly involved in this deployment) |
| `ARM_TENANT_ID`          | Azure Tenant (Directory) ID                                                         |
| `TFC_AZURE_PROVIDER_AUTH`| Enables Terraform Cloud Azure provider authentication (set to `true`)               |
| `TFC_AZURE_RUN_CLIENT_ID`| Client ID of the Azure AD application used for dynamic credentials                  |

## Usage

1. Clone the repository.
2. Edit `config/management_groups_tree.json`. **Do not change the keys**, only modify 'name' values if you don't want to use default names. Ensure all names are unique.
3. Set the `parent_mng_group_name` variable in the Terraform Cloud Workspace, this is your root management group name.
4. Deploy

## Deployment Structure

```
.
├── main.tf                                 # Main resource definitions
├── variables.tf                            # Input variables
├── outputs.tf                              # Output values
├── versions.tf                             # Provider and Terraform versions
├── locals.tf                               # Local variables
└── config/management_groups_tree.json      # Management group tree configuration
```

## Next Steps

After deploying this core module, continue with:

1. Subscription management deployment\import
2. Policy deployments:
   - Management policies (tags, naming standards, resource restrictions)
   - Compliance policies (SOC2, industry-specific standards)
   - Internal security policies

## Contributing

Please refer to the project's contribution guidelines.
