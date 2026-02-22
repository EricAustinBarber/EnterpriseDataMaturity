# Secret Inventory Template

Use this template as the system of record for all secrets used by the Enterprise Data Maturity application and supporting services.

## Inventory Table

| Secret Name | Environment | System/Service | Purpose | Auth Type (Secret/Cert/Token) | Storage Location (Key Vault) | Consuming Workload (API/ADF/Databricks/GHA) | Owner (Team) | Rotation Frequency | Last Rotated | Expires On | Break-Glass Access Group | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| sec-example-api-token-dev | dev | Example SaaS API | Pull metadata payload | Token | kv-edm-dev-core | API | Data Platform Eng | 90 days | YYYY-MM-DD | YYYY-MM-DD | Entra-EDM-BreakGlass | Replace with real value |

## Required Validation Rules

1. Every production secret must have an owner team and expiry date.
2. No secret may be shared across `dev`, `test`, and `prod`.
3. Every secret must map to at least one consuming workload.
4. Break-glass access group must be defined for prod secrets.
5. Rotation frequency must be defined (30/60/90/180 days or policy-specific).

## Review Cadence

- Weekly: expired or near-expiry secrets.
- Monthly: owner attestations and unused secret cleanup.
- Quarterly: full inventory audit and least-privilege revalidation.

## Optional Extended Fields

If needed, extend with:
- Data Classification
- Regulatory Scope (PII/PCI/SOX/etc.)
- Incident Reference
- Previous Secret Version

## First-Pass Example Entries (dev/test/prod)

Use these as starter records and replace placeholders with real values.

| Secret Name | Environment | System/Service | Purpose | Auth Type (Secret/Cert/Token) | Storage Location (Key Vault) | Consuming Workload (API/ADF/Databricks/GHA) | Owner (Team) | Rotation Frequency | Last Rotated | Expires On | Break-Glass Access Group | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| sec-edm-api-oauth-client-secret-dev | dev | Entra App | API outbound integration auth | Secret | kv-edm-dev-core | API | Platform Engineering | 90 days | TBD | TBD | Entra-EDM-BreakGlass | Prefer certificate/federation in next phase |
| sec-edm-api-oauth-client-secret-test | test | Entra App | API outbound integration auth | Secret | kv-edm-test-core | API | Platform Engineering | 90 days | TBD | TBD | Entra-EDM-BreakGlass | Test-only value |
| sec-edm-api-oauth-client-secret-prod | prod | Entra App | API outbound integration auth | Secret | kv-edm-prod-core | API | Platform Engineering | 60 days | TBD | TBD | Entra-EDM-BreakGlass | Prod strict rotation |
| sec-edm-adf-sql-connection-string-dev | dev | Azure SQL Metadata DB | ADF linked service connection | Secret | kv-edm-dev-core | ADF | Data Engineering | 90 days | TBD | TBD | Entra-EDM-BreakGlass | Migrate to Entra auth where possible |
| sec-edm-adf-sql-connection-string-test | test | Azure SQL Metadata DB | ADF linked service connection | Secret | kv-edm-test-core | ADF | Data Engineering | 90 days | TBD | TBD | Entra-EDM-BreakGlass | Environment isolated |
| sec-edm-adf-sql-connection-string-prod | prod | Azure SQL Metadata DB | ADF linked service connection | Secret | kv-edm-prod-core | ADF | Data Engineering | 60 days | TBD | TBD | Entra-EDM-BreakGlass | High criticality |
| sec-edm-dbx-external-api-token-dev | dev | External API | Databricks enrichment call | Token | kv-edm-dev-core | Databricks | Data Platform Eng | 90 days | TBD | TBD | Entra-EDM-BreakGlass | Accessed via KV-backed secret scope |
| sec-edm-dbx-external-api-token-test | test | External API | Databricks enrichment call | Token | kv-edm-test-core | Databricks | Data Platform Eng | 90 days | TBD | TBD | Entra-EDM-BreakGlass | Non-prod token |
| sec-edm-dbx-external-api-token-prod | prod | External API | Databricks enrichment call | Token | kv-edm-prod-core | Databricks | Data Platform Eng | 60 days | TBD | TBD | Entra-EDM-BreakGlass | Monitor usage anomalies |
| sec-edm-gha-webhook-signing-key-dev | dev | GitHub Actions | Deployment webhook signing | Secret | kv-edm-dev-core | GHA | DevOps | 180 days | TBD | TBD | Entra-EDM-BreakGlass | Prefer OIDC over secret auth where possible |
