# Entra and Managed Identity Role Matrix

This matrix defines recommended access boundaries for human users, service principals, and managed identities.

## 1. Principal Types

- Human users via Entra groups
- Workload identities (system-assigned or user-assigned managed identities)
- CI/CD identity (GitHub OIDC federation principal)

## 2. Recommended Group and Identity Model

| Principal / Group | Scope | Purpose | Key Azure Roles | Key Notes |
|---|---|---|---|---|
| Entra-EDM-Platform-Admins | Subscription / RG | Platform administration | Contributor (scoped), Key Vault Administrator (scoped) | Avoid broad Owner assignment |
| Entra-EDM-Data-Engineers | Data RG, Databricks | Data engineering operations | Storage Blob Data Contributor, Data Factory Contributor, Databricks workspace role | No direct prod secret write |
| Entra-EDM-ReadOnly-Auditors | Subscription / Logs | Audit and compliance visibility | Reader, Log Analytics Reader | No secret read by default |
| mi-edm-api-<env> | App RG | API runtime secret retrieval and service calls | Key Vault Secrets User, specific data-plane roles | Runtime-only access |
| mi-edm-adf-<env> | Data Factory | ADF access to Key Vault and storage/SQL | Key Vault Secrets User, Storage Blob Data Contributor, SQL roles as needed | Environment-scoped only |
| mi-edm-dbx-<env> | Databricks workloads | Databricks external access | Key Vault Secrets User, storage/data roles | Use Key Vault-backed scope |
| sp-edm-github-oidc-<env> | CI/CD | GitHub Actions deployment identity | Contributor (RG scoped), AcrPush, Key Vault Secrets User (if required) | Federated credential, no client secret |
| Entra-EDM-BreakGlass | Prod only | Emergency controlled access | Time-bound PIM elevation | Use incident process only |

## 3. Minimum Permission Rules

1. Scope roles to resource group or resource, not whole subscription when possible.
2. Split control-plane admin and data-plane runtime access.
3. Production secrets:
- read allowed to runtime managed identities
- write allowed only to restricted admin group
4. CI identity must use OIDC federation; avoid static credentials.
5. Human users should not fetch production app secrets for day-to-day operations.

## 4. Key Vault Access Policy Model

Preferred:
- Azure RBAC for Key Vault access (centralized governance).

If legacy access policies are in use:
- restrict `Get`/`List` for runtime identities only
- no broad wildcard permissions for user groups
- remove dormant principals quarterly

## 5. SQL/Warehouse Access Pattern

- Prefer Entra auth and managed identities.
- Use database roles:
- `db_datareader` for read-only workloads
- custom execution roles for procedures/jobs
- avoid shared SQL admin credentials for applications

## 6. Periodic Access Review Checklist

Monthly:
- review role assignments by principal type
- identify excessive permissions
- confirm identity ownership still valid

Quarterly:
- full recertification of production access
- break-glass group membership audit
