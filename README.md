# Enterprise Data Maturity Application

## Environment Documentation:

## Data Maturity Model:

Sundt is developing an enterprise data maturity model that uses data observability and catalog capabilities to strengthen data culture and accelerate AI-ready data products.

## Current Data Pipeline Inventory (As-Is)

Current-state view of known pipeline sources and processing flow from `docs/Sundt Documentation.docx`. Update owner and classification fields as you validate with domain teams.

| Source System | Owner | Type | Ingestion Path | Processing Path | Serving/Consumption Path | Contains PII? | Criticality (H/M/L) | Current State | Notes |
|---|---|---|---|---|---|---|---|---|---|
| RedShift | TBD | Data Warehouse | ADF metadata-driven source-to-bronze (`adf.dataSource`) | Databricks bronze/silver/gold via ADF metadata (`adf.dataProcess`, `adf.dataProcessDependency`) | Databricks SQL Warehouse + Power BI datasets | TBD | H | Active | Referenced by ADF dataset naming (`dsRedShift`) |
| Salesforce | TBD | CRM/API | ADF metadata-driven source-to-bronze (`adf.dataSource`) | Databricks bronze/silver/gold via ADF metadata | Databricks SQL Warehouse + Power BI datasets | TBD | H | Active | Trigger pattern example exists (`*_trSalesforceWeekly`) |
| InEight | TBD | SaaS/API | ADF ingestion + metadata-driven orchestration | Databricks transformations and RLS-related table updates | Power BI RLS dataset refresh + web app support tables | TBD | H | Active | Referenced as source for contact/RLS updates |
| Cosential | TBD | CRM/API | ADF ingestion + metadata-driven orchestration | Databricks transformations and RLS-related table updates | Power BI RLS dataset refresh + web app support tables | TBD | H | Active | Referenced as source for contact/RLS updates |
| On-Prem SQL Sources | TBD | SQL | ADF via self-hosted IR to ADLS raw/bronze | Databricks bronze/silver/gold via ADF metadata | Databricks SQL Warehouse + Power BI datasets | TBD | H | Active | Uses shared Dev/Test self-hosted IR and separate Prod IR |
| File Drops (CSV/JSON/XLSX) | TBD | File | ADF copy to ADLS raw (retained as source format) | Databricks conversion/processing to Delta layers | Databricks SQL Warehouse + Power BI datasets | TBD | M | Active | JSON/CSV/XLSX described as current ingestion patterns |
| Bigeye | Data Engineering / Data Governance (TBD) | Data Observability Platform | Connectors to warehouse/lakehouse datasets and pipeline outputs | Automated quality/freshness/volume checks and anomaly monitoring | Operational monitoring, alerting, and data reliability reporting | Unknown | H | Active | Used for data monitoring and observability |
| Alation | Data Governance (TBD) | Data Catalog / Metadata Platform | Metadata ingestion from warehouse/lakehouse and BI assets | Cataloging, metadata enrichment, stewardship, and lineage context | Data discovery, governance, and trusted data product enablement | Unknown | H | Active | Enterprise data catalog for metadata management |

## Recommended Artifacts

- `docs/Roadmap-Data-Maturity-AI-Readiness.md`: modernization roadmap and AI-readiness assessment framework.
- `docs/Data-Maturity-Scorecard-and-Assessment-Framework.md`: scoring model for pipeline health, Databricks standards, Bigeye, and Alation.
- `docs/Enterprise-Data-Maturity-Application-Plan.md`: connection, ingest, processing, and end-to-end application blueprint.
- `docs/Systems-Tools-and-Versioning-Blueprint.md`: required enterprise systems, software stack, and versioning baseline.
- `docs/Secrets-Management-Strategy.md`: Azure-native secrets handling strategy for apps, logs, servers, and warehouse connections.
- `docs/Secret-Inventory-Template.md`: template to inventory and govern all application and platform secrets.
- `docs/Entra-Managed-Identity-Role-Matrix.md`: role and permission model for users, service principals, and managed identities.
- `docs/GitHub-Actions-OIDC-Azure-Checklist.md`: checklist for secure GitHub Actions authentication to Azure via OIDC.
- `docs/GitHub-Azure-Environment-Handoff-Guide.md`: role-based setup and validation guide for GitHub admin and Azure admin handoff.
- `justfile`: Windows-friendly task runner for tool checks and diagram generation.
- `.tool-versions` and `.asdfrc`: `asdf` version pinning and behavior config for local/CI consistency.
- `diagrams/enterprise_maturity_architecture.py`: Python diagrams source for architecture visualization.

## Local Setup Checks

- `just asdf-install`: install/pin asdf-managed runtimes in WSL.
- `just asdf-doctor`: verify asdf toolchain plus non-asdf Azure CLI and .NET checks.
- `just platform-doctor`: verify Windows-hosted Azure CLI and .NET.
- `just workstation-doctor`: run full baseline checks in one command.

## CI/CD Workflows

- `.github/workflows/01-ci.yml`: CI checks for `dev/main/release/*/hotfix/*` PRs and feature/hotfix pushes.
- `.github/workflows/02-build-and-deploy-dev.yml`: build and deploy to `dev` on push to `dev` (or manual run).
- `.github/workflows/03-promote-test-and-prod.yml`: auto promote `release/*` to `test`, manual promotion to `test`/`prod` with branch guard for prod.

Required GitHub Environment `secrets` (dev/test/prod):
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

Required GitHub Environment `vars` (dev/test/prod):
- `ACR_NAME`
- `AZURE_RESOURCE_GROUP`
- `CONTAINER_APP_NAME`
