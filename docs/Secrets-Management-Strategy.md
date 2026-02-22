# Secrets Management Strategy

## 1. Objective

Manage secrets for application connections, system logs, servers, and warehouse access without storing credentials in code, notebooks, pipelines, or CI files.

## 2. Azure-First Design

- Identity provider: Microsoft Entra ID
- Secret store: Azure Key Vault
- Runtime access: Managed identities (system-assigned or user-assigned)
- API policy secrets: API Management named values backed by Key Vault
- Data platform secret use: Databricks Key Vault-backed secret scopes

## 3. Secret Classes and Handling Rules

## A. Application Connection Secrets

Examples:
- External SaaS API keys
- Service principal client secrets (temporary only)
- Partner integration tokens

Rules:
- Store only in Key Vault.
- Prefer certificate auth or workload identity over long-lived client secrets.
- Never place values in `appsettings`, `.env`, notebooks, or repo files.

## B. System Log and Monitoring Credentials

Examples:
- Log sink/auth tokens
- Webhook signing secrets

Rules:
- Use managed identity when Azure service supports Entra auth.
- For non-Azure sinks, store token in Key Vault and inject at runtime only.

## C. Server and Compute Access Secrets

Examples:
- VM/local admin passwords
- SSH keys

Rules:
- Eliminate where possible using Entra/managed identity and RBAC.
- If unavoidable, store in Key Vault with strict access policies and rotation.

## D. Warehouse and Data Platform Secrets

Examples:
- SQL connection strings
- JDBC tokens
- Databricks-to-external-system credentials

Rules:
- Use Entra auth to SQL/warehouse where supported.
- If password/token is required, pull from Key Vault at runtime.
- For Databricks, use Key Vault-backed secret scopes; grant scope ACLs to groups, not users.

## 4. Environment Pattern

Per environment (`dev`, `test`, `prod`):
- Separate Key Vault per environment
- Separate managed identity per workload/environment
- No cross-environment secret reuse
- Distinct secret values and rotation schedules

Suggested naming:
- Key Vault: `kv-edm-<env>-core`
- Secret names: `sec-<system>-<purpose>-<env>`
- Identity names: `mi-edm-<workload>-<env>`

## 5. Access Model (Least Privilege)

- Grant `get/list` only to required managed identities.
- Use Entra groups for human/operator access.
- Restrict write/update/delete to a limited platform-admin group.
- Enable Key Vault auditing and monitor access anomalies.

## 6. Injection Pattern by Component

## API layer (Rust/.NET)

- App reads secret references (not values) from config.
- At startup/runtime, app fetches secret from Key Vault using managed identity.
- Cache in memory only; never log secret values.

## ADF pipelines

- Linked services reference Key Vault secrets.
- Avoid inline secure strings in pipeline JSON.
- Keep parameter files value-free (references only).

## Databricks / PySpark

- Create Key Vault-backed secret scopes.
- Retrieve at runtime via `dbutils.secrets.get`.
- Do not print, persist, or checkpoint secrets.

## GitHub Actions / CI

- Use OIDC federation to Azure instead of stored cloud credentials.
- Keep only non-sensitive IDs in repo variables.
- Store emergency fallback secrets in GitHub environment secrets with expiry and strict approvals.

## 7. Rotation and Expiry Policy

- Define owner, rotation period, and last-rotated metadata for each secret.
- Rotate high-risk secrets first (external API tokens, DB passwords).
- Force rotation on incident, owner change, or policy exception.
- Use versionless Key Vault references where supported so services receive updated secret versions.

## 8. Governance Controls

- Secret inventory with:
- secret name
- owner
- system
- environment
- auth type
- rotation interval
- last rotation date
- expiration date

- Monthly control checks:
- expired/near-expiry secrets
- unused secrets
- over-privileged identities
- hardcoded secret scan findings

## 9. Immediate Implementation Steps

1. Create per-environment Key Vaults and managed identities.
2. Build secret inventory sheet/table and assign owners.
3. Migrate existing pipeline/app/notebook credentials into Key Vault.
4. Switch ADF linked services and Databricks secret scopes to Key Vault-backed flow.
5. Implement OIDC in GitHub Actions for Azure auth.
6. Enable audit dashboard for Key Vault access and rotation compliance.

## 10. Non-Negotiable Rules

- No plaintext secrets in repo, notebooks, pipeline definitions, or chat artifacts.
- No shared secrets across environments.
- No user-specific secret ownership for production workloads.
- No production secret access without documented break-glass process.
