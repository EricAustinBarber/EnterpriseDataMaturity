# Assessments Workspace

Use this folder for source-system readiness assessments before score calculation.

## Purpose

Track two immediate actions:
1. Databricks notebook transformation completeness review.
2. ADF metadata model quality/maturity review.

## Folder Layout

- `databricks-transformation-review.md`: checklist and findings for notebook/repo review.
- `adf-metadata-review.md`: checklist and findings for ADF metadata tables.
- `assessment-tracker.csv`: issue/action tracker across both assessments.
- `prod-adf-baseline-summary.md`: prod-focused ADF metadata and execution baseline summary.
- `databricks-implementation-summary.md`: implementation summary for transformations/functions by layer.
- `databricks-notebook-inventory.csv`: notebook inventory extracted from Databricks repo.
- `databricks-function-inventory.csv`: function/transformation item catalog extracted from notebooks.
- `prod-pipeline-risk-list.md`: production pipeline risk summary and top-risk view.
- `prod-pipeline-risk-list.csv`: production pipelines with errors ranked by risk.
- `prod-pipeline-risk-list-all.csv`: all observed production pipelines ranked by risk (including zero-error pipelines).
- `external/` (ignored): local clone location for external repos (e.g., Databricks notebooks, Azure Data Factory repo, Azure SQL Server for Pipeline Metadata).
- `evidence/` (ignored): extracted evidence snapshots and exports.

## Execution Order

1. Clone external notebook repo to `assessments/external/`.
2. Run Databricks transformation assessment.
3. Pull ADF metadata evidence and run metadata assessment.
4. Record findings/remediation in `assessment-tracker.csv`.
5. Feed resolved findings into scorecard ingestion/scoring.
