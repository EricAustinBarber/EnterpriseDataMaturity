# Data Maturity Scorecard and Assessment Framework

## 1. Purpose

This scorecard evaluates:
- Pipeline execution health (runtime and return state)
- Databricks engineering standard adoption
- Bigeye monitoring coverage and proactive detection
- Alation metadata and endorsement maturity

The output is a dataset-level and domain-level maturity score that can be tracked over time.

## 2. Scorecard Structure

Total score: `100`

- Section A: Pipeline Health and Reliability (`30`)
- Section B: Databricks Engineering Standards (`30`)
- Section C: Bigeye Observability Adoption (`20`)
- Section D: Alation Catalog and Governance (`20`)

Maturity bands:
- `0-39`: Initial
- `40-59`: Developing
- `60-79`: Defined
- `80-89`: Managed
- `90-100`: Optimized

## 3. Section A: Pipeline Health and Reliability (30)

### Metrics

1. Pipeline success rate (`10`)
- Formula: `successful_runs / total_runs * 100`
- Target: `>= 98%`

2. Mean pipeline runtime variance (`8`)
- Formula: `abs(current_avg_runtime - baseline_runtime) / baseline_runtime`
- Score higher when variance is low
- Target: `<= 15% variance`

3. Failure recovery time (`6`)
- Formula: median time from failure to successful rerun
- Target: `<= agreed operational threshold`

4. Return state completeness (`6`)
- % runs with normalized end state (`Succeeded`, `Failed`, `Cancelled`, `TimedOut`) and error classification
- Target: `100% classified`

### Data sources

- `adf.executionLog` and monitoring views in metadata SQL database
- ADF run history (pipeline + activity level)

## 4. Section B: Databricks Engineering Standards (30)

### Metrics

1. Parameterized notebook adoption (`5`)
- % production notebooks using parameters/widgets and environment abstraction

2. Delta table compliance (`5`)
- % target tables in Delta format with expected table properties

3. Merge/upsert standardization (`5`)
- % incremental loads using deterministic merge (`MERGE`) or controlled create/replace pattern

4. Data sanitization controls (`5`)
- % datasets with documented sanitization and validation rules (null handling, type casting, bad record treatment)

5. Table hygiene (`4`)
- Vacuum/optimize policies defined and executed per standard

6. Partitioning and clustering quality (`4`)
- % large tables with validated partition strategy and clustering (`ZORDER`/clustering keys where appropriate)

7. File-size efficiency (`2`)
- % large Delta tables within target small-file threshold and healthy average file size

### Evidence checks

- Notebook code review checklist
- `DESCRIBE DETAIL` and table history review
- Delta maintenance jobs and log evidence
- Data quality test results

## 5. Section C: Bigeye Observability Adoption (20)

### Metrics

1. Dataset monitor coverage (`8`)
- % critical datasets with active Bigeye monitors

2. Early-detection coverage (`6`)
- % critical datasets monitored for freshness, volume, schema, and distribution anomalies

3. Alert actionability (`4`)
- % alerts with owner, severity, and runbook linked

4. Proactive response effectiveness (`2`)
- % incidents detected by Bigeye before business/user escalation

### Evidence checks

- Bigeye monitor inventory by dataset
- Alert logs with timestamp, severity, owner, and resolution data

## 6. Section D: Alation Catalog and Governance (20)

### Metrics

1. Endorsed flag coverage (`6`)
- % critical datasets marked endorsed/certified

2. Metadata completeness (`8`)
- % critical datasets with minimum metadata fields completed:
- Owner
- Steward
- Business definition
- Technical description
- Sensitivity classification
- Lineage links
- Usage guidance

3. Stewardship freshness (`3`)
- % catalog entries reviewed/attested by owner/steward

4. Maturity reporting completeness (`3`)
- % scored datasets reported back to Alation as maturity attributes/tags

### Evidence checks

- Alation API exports or governance reports
- Endorsement and stewardship audit logs

## 7. Dataset-Level Scoring Model

For each dataset, compute:

`dataset_score = A + B + C + D`

Where:
- `A` in `[0,30]`
- `B` in `[0,30]`
- `C` in `[0,20]`
- `D` in `[0,20]`

Then compute domain score:

`domain_score = average(dataset_score for datasets in domain)`

Enterprise score:

`enterprise_score = weighted_average(domain_score by domain criticality)`

## 8. Pipeline Health Tracking Model

Track each run with normalized fields:

- `run_id`
- `pipeline_name`
- `source_system`
- `dataset_name`
- `start_ts`
- `end_ts`
- `duration_seconds`
- `return_state`
- `error_class`
- `recovered_flag`
- `recovery_duration_seconds`

Required return states:
- `Succeeded`
- `Failed`
- `Cancelled`
- `TimedOut`

## 9. Databricks Standards Assessment Checklist

For each production notebook/table, score `0` (no), `1` (partial), `2` (yes):

- Notebook is parameterized for environment and source object
- Uses Delta table semantics
- Incremental logic uses merge or approved idempotent pattern
- Data sanitization rules are explicit and tested
- Table hygiene jobs are configured
- Partitioning/clustering strategy documented and validated
- File-size health is measured and within target range

Convert checklist result to Section B score.

## 10. Bigeye and Alation Integration Expectations

For each critical dataset:

- Bigeye:
- Has baseline monitors: freshness, volume, schema, anomaly
- Alerts mapped to owner and incident workflow

- Alation:
- Has endorsed status decision
- Metadata completeness at defined threshold
- Linked lineage and usage context
- Receives maturity score/tag update from scorecard process

## 11. Minimum Viable Reporting Outputs

1. Pipeline health dashboard
- success rate, runtime trend, failed runs by error class, recovery trend

2. Databricks standards dashboard
- adoption coverage by practice and by domain

3. Bigeye coverage dashboard
- monitor coverage and proactive detection rate

4. Alation governance dashboard
- endorsement coverage and metadata completeness

5. Enterprise maturity scorecard
- section scores, total score, and trend

## 12. Ordered Implementation Steps

1. Finalize critical dataset list and domain ownership.
2. Build run-level pipeline health mart from ADF/metadata logs.
3. Build Databricks standards evidence table.
4. Ingest Bigeye monitor/alert inventory into scorecard mart.
5. Ingest Alation metadata/endorsement inventory into scorecard mart.
6. Implement scoring SQL/notebook logic.
7. Publish scorecard outputs to dashboard and governance review.
8. Write maturity back to Alation attributes/tags for each dataset.
