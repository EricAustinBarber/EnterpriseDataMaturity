# Enterprise Data Maturity Application Plan

## 1. Objective

Design an end-to-end application that:
- Connects to platform and governance systems
- Ingests execution, engineering, monitoring, and catalog evidence
- Computes maturity and health scores
- Publishes operational and governance reporting
- Feeds maturity results back to Alation

## 2. End-to-End Scope

Systems in scope:
- Azure Data Factory and metadata SQL (`adf.executionLog`, related views)
- Databricks lakehouse (notebooks, Delta table metadata, job execution evidence)
- Bigeye (monitors, alerts, coverage, response evidence)
- Alation (endorsement, metadata completeness, stewardship attributes)

Outputs in scope:
- Pipeline health metrics
- Databricks standards maturity metrics
- Bigeye observability adoption metrics
- Alation governance maturity metrics
- Unified enterprise data maturity scorecard

## 3. Connection Plan

## A. ADF and Metadata SQL Connection

- Source: Azure SQL metadata database containing `adf.executionLog` and denormalized monitoring views
- Access pattern: service principal with least privilege (read only)
- Ingestion mode: scheduled incremental extraction by `run_id`/`end_ts`

## B. Databricks Connection

- Source: notebook repos, job run metadata, and Delta table metadata
- Access pattern: service principal/pat with workspace and SQL warehouse read access
- Ingestion mode:
- metadata pull for tables/jobs/notebooks
- computed standards evidence via Databricks SQL/notebook jobs

## C. Bigeye Connection

- Source: dataset monitor inventory and alert events
- Access pattern: API token or service credential with read access to monitors and incidents
- Ingestion mode: incremental by event timestamp

## D. Alation Connection

- Source: catalog assets, endorsement flags, metadata fields, stewardship fields
- Access pattern: API/service account with read plus controlled write for maturity attributes
- Ingestion mode:
- read metadata inventory incrementally
- writeback maturity score and tier after validation

## 4. Data Ingest Plan

## A. Landing Layer

Create raw ingestion tables/files for each source:
- `raw_pipeline_runs`
- `raw_databricks_standards`
- `raw_bigeye_monitors`
- `raw_bigeye_alerts`
- `raw_alation_assets`

Include:
- source timestamp
- ingestion timestamp
- source system identifier
- ingestion run id

## B. Standardization Layer

Normalize to canonical models:
- `stg_pipeline_execution`
- `stg_databricks_practices`
- `stg_observability_coverage`
- `stg_catalog_governance`

Standardize keys:
- `dataset_id`
- `dataset_name`
- `domain_name`
- `source_system`

## C. Curated Scorecard Layer

Create marts:
- `mart_dataset_maturity_score`
- `mart_domain_maturity_score`
- `mart_pipeline_health`
- `mart_governance_adoption`

Each mart must include:
- score version
- scoring date
- calculation lineage (source run ids)

## 5. Processing Plan

## A. Pipeline Health Processing

- Calculate runtime, return state distribution, failure classes, and recovery metrics
- Produce health status per pipeline and dataset

## B. Databricks Standards Processing

- Evaluate notebook and table standards checks
- Convert checklist outputs into section score
- Track evidence status (`Pass`, `Partial`, `Fail`)

## C. Bigeye Processing

- Map critical datasets to monitor coverage
- Classify detection as proactive vs reactive
- Compute coverage and alert quality metrics

## D. Alation Processing

- Calculate metadata completeness percentage
- Evaluate endorsement coverage
- Assign governance maturity status per dataset

## E. Unified Scoring

- Combine section scores into total score per dataset
- Aggregate to domain and enterprise scores
- Persist score history for trend analysis

## 6. End-to-End Application Design

## A. Orchestration

- Use ADF (or Databricks workflows) as master orchestration
- Ordered flow:
1. Ingest sources
2. Normalize models
3. Compute scores
4. Publish dashboards
5. Write maturity attributes to Alation

## B. Compute

- Databricks for transformation and scoring logic
- Delta tables for all managed scorecard datasets

## C. Storage

- ADLS/Delta medallion pattern for application data

## D. Serving

- SQL warehouse views for scorecard consumption
- Power BI dashboards for operational and governance audiences

## E. Governance and Security

- Role-based access on scorecard marts
- Sensitive attributes masked by policy
- Full audit logs for score writeback to Alation

## 7. Application Data Model (Minimum)

Core entities:
- `dataset`
- `pipeline_run`
- `databricks_assessment`
- `bigeye_monitor`
- `bigeye_alert`
- `alation_asset`
- `maturity_score`
- `maturity_dimension_score`

Required relationships:
- one dataset to many pipeline runs
- one dataset to many monitor records
- one dataset to one current Alation asset profile
- one dataset to many historical scores

## 8. Operational Controls

- Data quality checks on every ingest feed
- Duplicate detection on run/event ingestion
- Late-arriving event handling
- Score recalculation policy with versioning
- Exception queue for unmapped datasets

## 9. Reporting and Decision Flow

## Operational view

- Daily/recurring pipeline health
- Failed runs and recovery posture
- Bigeye alerts and unresolved issues

## Governance view

- Alation endorsement and metadata completeness
- Domain maturity score and gap drivers
- Dataset-level remediation backlog

## Executive view

- Enterprise maturity index
- AI-readiness progression by domain
- Top risks and remediation progress

## 10. Ordered Delivery Plan

1. Confirm critical dataset scope and ownership list.
2. Implement source connectors and raw ingestion tables.
3. Build standardized staging models.
4. Build score computation models and validation tests.
5. Publish dashboards and governance scorecards.
6. Enable controlled writeback of maturity to Alation.
7. Run pilot on priority domains and refine scoring rules.
8. Expand to full enterprise dataset inventory.
