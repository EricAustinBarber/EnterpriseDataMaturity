# Systems, Tools, and Versioning Blueprint

## 1. Purpose

Define the required systems and tools to build an enterprise-grade Data Maturity Application in Azure, with:
- Rust-first API layer
- PySpark/Databricks for data operations
- React/Next.js frontend
- Azure-native identity, secrets, platform, and container services

## 2. Target Architecture Stack

## Core application layers

- Frontend: Next.js + TypeScript
- API layer: Rust (`axum`) preferred, `.NET` as approved fallback
- Data processing: Databricks + PySpark + Delta Lake
- Orchestration: Azure Data Factory and/or Databricks Workflows
- Metadata/governance: Alation
- Observability: Bigeye + Azure Monitor + App Insights

## Azure platform services

- Identity: Microsoft Entra ID
- Secrets: Azure Key Vault
- Container registry: Azure Container Registry (ACR)
- Container runtime: Azure Container Apps (recommended) or AKS for advanced control
- API gateway: Azure API Management
- Storage: ADLS Gen2
- Data platform: Azure Databricks
- CI/CD: Azure DevOps Pipelines
- Logging/metrics: Azure Monitor + Log Analytics + Application Insights

## 3. Recommended Toolchain Versions (Baseline)

Use pinned major/minor versions to reduce environment drift.

Version manager standard:
- `asdf` with repository-managed `.tool-versions`
- `.asdfrc` committed for consistent `asdf` behavior

- `just`: `1.39.x`
- `python`: `3.11.x`
- `uv` (Python package manager): `0.5.x`
- `rust`: `1.82.x`
- `cargo`: bundled with Rust toolchain
- `.NET SDK` (fallback API): `8.0.x`
- `node`: `22.x`
- `pnpm`: `9.x`
- `azure-cli`: `2.67.x`
- `terraform` (if used): `1.10.x`
- `bicep` (if used): `0.31.x`
- `graphviz` (for diagrams rendering): `10.x`

Note:
- For Windows + VS Code, install Graphviz system binaries and ensure `dot` is on `PATH`.
- Pin exact patch versions in CI once initial smoke tests pass.

## 4. API Layer Decision

Primary:
- Rust + `axum`
- OpenAPI generation (`utoipa` or equivalent)
- JWT/OIDC validation with Entra-issued tokens
- Structured logging and tracing (`tracing`)

Fallback:
- `.NET 8 Web API` if team capacity or integration constraints require faster ramp-up.

## 5. Data Engineering Standards

- PySpark notebooks/jobs must be parameterized by environment and dataset.
- Delta tables as default storage format.
- Incremental loads use deterministic merge/upsert (`MERGE`) or approved idempotent replace strategy.
- Sanitization required for null/type/domain checks.
- Table hygiene required (`OPTIMIZE`, `VACUUM`, retention policy).
- Partitioning and clustering strategy documented and validated.
- File-size health monitored (small-file control and compaction policy).

## 6. Frontend Standards

- Next.js with TypeScript
- UI framework: enterprise-approved component library
- Auth: Entra ID via OIDC/OAuth2
- API access through APIM-managed endpoints

## 7. Security and Identity Standards

- All workload secrets in Key Vault.
- Managed identities preferred over static secrets.
- API authorization enforced through Entra ID app roles/scopes.
- Least privilege RBAC across Azure resources.
- Audit and access logs centralized in Log Analytics.

## 8. Deployment and Environment Model

- Environments: `dev`, `test`, `prod`
- Separate resource groups/subscriptions as required by policy
- CI/CD gates:
- lint/test gate
- security scanning gate
- integration validation gate
- promotion approval gate

## 9. Repository Structure (Suggested)

```text
enterprise-data-maturity/
  api/                      # Rust API service (axum)
  frontend/                 # Next.js frontend
  dataops/                  # PySpark jobs/notebooks and shared libs
  infra/                    # IaC (Terraform or Bicep)
  diagrams/                 # Python diagrams sources
  docs/                     # Architecture and standards docs
  justfile                  # Local dev and CI task runner
```

## 10. Professional-Grade Tooling Checklist

- Source control and branch policy in Azure DevOps
- Automated build/test/lint pipelines
- SAST/dependency/container vulnerability scanning
- Secrets scanning in CI
- Centralized observability and alert routing
- Disaster recovery and backup strategy
- Data governance integration (Alation)
- Data quality and anomaly monitoring (Bigeye)

## 11. Initial Build Sequence

1. Confirm final tool versions and lock CI images.
2. Scaffold project modules (`api`, `frontend`, `dataops`, `infra`).
3. Implement identity and secrets baseline (Entra + Key Vault).
4. Set up container build/deploy (ACR + Container Apps/AKS).
5. Integrate Bigeye and Alation evidence into scorecard ingestion.
6. Publish first architecture and operational dashboards.

## 12. Windows + VS Code + WSL asdf Workflow

1. Install WSL2 + Ubuntu.
2. Install `asdf` in WSL shell.
3. In this repo, run `just asdf-install`.
4. Verify with `just asdf-current`.
5. Run `just workstation-doctor` for combined asdf + Azure CLI + .NET validation.
