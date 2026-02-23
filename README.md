# Enterprise Data Maturity Application

## Environment Documentation:

## Data Maturity Model:

Sundt is developing an enterprise data maturity model that uses data observability and catalog capabilities to strengthen data culture and accelerate AI-ready data products.

## Current Data Source Landscape

Note: `docs/Sundt Documentation.docx` is historical baseline documentation and is no longer a complete inventory of current sources.

Current source types in scope include:
- Azure SQL databases and Azure SQL servers
- SQL Server (cloud and on-premises)
- APIs and SaaS application integrations
- Flat files (CSV, JSON, XLSX, parquet)
- Integration/orchestration tooling feeds
- Observability and catalog metadata feeds (Bigeye, Alation)

## Current Inventory (Maintain Here)

Use this table as the live source inventory for planning, onboarding, and maturity scoring.

| Source System | Owner | Source Type | Platform/Host | Ingestion Pattern | Processing Pattern | Serving/Consumption | Contains PII? | Criticality | Current State | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| Azure SQL - Source Group A | TBD | Azure SQL | Azure | ADF metadata-driven ingest | Databricks bronze/silver/gold | SQL Warehouse + BI | TBD | H | Active | Replace with actual server/database names |
| SQL Server - Source Group B | TBD | SQL Server | Azure/On-Prem | ADF via managed or self-hosted IR | Databricks bronze/silver/gold | SQL Warehouse + BI | TBD | H | Active | Capture auth method and connectivity path |
| API Integrations - Group C | TBD | API/SaaS | Vendor Cloud | ADF/Notebook API ingestion | Databricks normalization and harmonization | SQL Warehouse + BI/App | TBD | H | Active | Include rate limits and token strategy |
| Flat Files - Group D | TBD | File | ADLS/SFTP/Share | Scheduled and event-driven file loads | Databricks schema and quality processing | SQL Warehouse + BI | TBD | M | Active | Track file contract/versioning |
| Integration Tool Feeds - Group E | TBD | Integration Tool | Mixed | Tool-specific connectors and pipeline orchestration | Standardized mapping to curated layers | App/BI/Operational Consumers | TBD | H | Active | List tool names and owners |
| Bigeye | Data Engineering / Governance | Observability Metadata | Bigeye | Monitor/alert metadata ingest | Scorecard and incident analytics | Ops dashboards and governance | N | H | Active | Data reliability and early detection coverage |
| Alation | Data Governance | Catalog Metadata | Alation | Catalog/lineage metadata ingest | Stewardship and maturity attributes | Governance and discovery workflows | N | H | Active | Endorsement and metadata completeness |

## Scorecard Implementation Start

- `scorecard/README.md`: implementation entry point for scorecard collection.
- `scorecard/source-connectors.yaml`: source registry for ADF, Databricks, Bigeye, and Alation collection.
- `scorecard/critical-datasets-template.csv`: dataset ownership and criticality inventory template.
- `scorecard/metric-catalog.csv`: weighted metric definitions, formulas, and thresholds.
- `scorecard/collection-runbook.md`: recurring execution steps for ingest, normalize, score, and publish.
- `docs/Connection-First-Execution-Guide.md`: secure connectivity-first validation workflow before scoring.
- `scorecard/scripts/connection_probe.py`: live source connectivity probes using Entra + Key Vault (no plaintext secrets).

## Assessment Workspace (Pre-Scoring)

- `assessments/README.md`: execution order for Databricks and ADF metadata assessment work.
- `assessments/databricks-transformation-review.md`: completeness checklist for notebook transformations.
- `assessments/adf-metadata-review.md`: quality/maturity checklist for ADF metadata tables.
- `assessments/assessment-tracker.csv`: shared remediation tracker across assessments.

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
- `just setup-scorecard`: install scorecard probe dependencies.
- `just scorecard-probe ENV=dev`: run secure live connectivity probe for an environment.

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
