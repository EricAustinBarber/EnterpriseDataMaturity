# Collection Runbook (Scorecard)

## 1. Goal

Collect, normalize, and score maturity data from ADF, Databricks, Bigeye, and Alation.

## 2. Inputs

- `source-connectors.yaml`
- `critical-datasets-template.csv`
- `metric-catalog.csv`

## 3. Collection Workflow

1. Extract raw evidence from each source.
2. Load into raw tables:
- `raw_pipeline_runs`
- `raw_databricks_standards`
- `raw_bigeye_monitors`
- `raw_bigeye_alerts`
- `raw_alation_assets`
3. Standardize into staging models:
- `stg_pipeline_execution`
- `stg_databricks_practices`
- `stg_observability_coverage`
- `stg_catalog_governance`
4. Join to critical dataset inventory.
5. Compute section and total scores.
6. Publish views and dashboards.
7. Write maturity attributes to Alation (controlled step).

## 4. Minimum Fields To Validate Before Scoring

## ADF / Pipeline

- `run_id`
- `pipeline_name`
- `dataset_name`
- `start_ts`
- `end_ts`
- `return_state`
- `error_class`

## Databricks

- `dataset_name`
- `notebook_name`
- `is_parameterized`
- `is_delta`
- `merge_pattern`
- `hygiene_status`

## Bigeye

- `dataset_name`
- `monitor_type`
- `alert_id`
- `severity`
- `owner`
- `runbook_link`

## Alation

- `dataset_name`
- `endorsed_flag`
- `owner`
- `steward`
- `business_definition`
- `lineage_present`

## 5. Daily/Recurring Operations

1. Run ingestion jobs.
2. Check ingestion completeness counts by source.
3. Check schema drift for source payloads.
4. Compute score outputs.
5. Flag failed or stale datasets for triage.

## 6. Weekly Governance Operations

1. Review low-scoring datasets by domain.
2. Review Bigeye coverage gaps.
3. Review Alation metadata and endorsement gaps.
4. Assign remediation owner and due date.

## 7. First Baseline Run Checklist

- Source connector registry populated with real endpoints.
- Critical dataset inventory includes top-priority domains.
- Metric thresholds reviewed by engineering and governance leads.
- Secrets and identities configured per `docs/Secrets-Management-Strategy.md`.
- End-to-end run completed for at least one domain.
