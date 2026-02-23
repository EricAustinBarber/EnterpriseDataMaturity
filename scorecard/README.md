# Scorecard Start Kit

This folder is the implementation start point for collecting and scoring maturity data across:
- ADF/metadata SQL (pipeline health)
- Databricks (engineering standards)
- Bigeye (observability)
- Alation (catalog/governance)

## Files

- `source-connectors.yaml`: source systems and collection endpoints by environment.
- `critical-datasets-template.csv`: critical dataset inventory and ownership mapping.
- `metric-catalog.csv`: scorecard metric definitions and formulas.
- `collection-runbook.md`: execution workflow for ingest, standardize, score, and publish.

## How To Start

1. Fill `critical-datasets-template.csv` with your priority datasets.
2. Fill `source-connectors.yaml` with real endpoints/IDs/tables.
3. Confirm metric ownership and thresholds in `metric-catalog.csv`.
4. Execute the runbook in `collection-runbook.md` for first baseline run.
