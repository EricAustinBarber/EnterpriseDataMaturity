# ADF Metadata Quality and Maturity Review

## 1. Scope

Metadata database and objects under review:
- `adf.dataSource`
- `adf.dataProcess`
- `adf.dataProcessDependency`
- `adf.executionLog`
- related views/stored procedures used for orchestration and monitoring

Environment(s):
- `dev` / `test` / `prod` (mark applicable)

Current assessment focus:
- `prod` (based on current evidence extracts)

Initial baseline evidence reviewed:
- `assessments/evidence/adf.datasource.csv` (`444` rows, `37` columns)
- `assessments/evidence/adf.dataprocess.csv` (`808` rows, `25` columns)
- `assessments/evidence/adf.dataProcessDependency.csv` (`968` rows, `9` columns)
- `assessments/evidence/adf.executionLog.csv` (`1,792,841` rows, `20` columns)
- `assessments/evidence/adf.operationMetricLog.csv` (`820,718` rows, `20` columns)

Repository indicators from `assessments/external/DW2023-DataFactory`:
- Pipelines: `83`
- Datasets: `21`
- Linked services: `21`
- Triggers: `28`
- Integration runtimes: `2`

## 2. Evidence Collection

Primary extraction script:
- `assessments/adf_extracts.sql`

Collect and store extracts in `assessments/evidence/` (ignored in git):
- table row counts by environment
- null/missing key field checks
- duplicate key checks
- orphan dependency checks
- stale/unused source/process records
- execution log quality checks (return states, error classes)

## 3. Assessment Checklist

| Check ID | Check | Status (Pass/Partial/Fail) | Evidence Path | Notes |
|---|---|---|---|---|
| ADF-01 | `adf.dataSource` has complete ownership/classification fields | Partial | adf.datasource.csv | Technical connection fields complete; owner/classification governance fields not evident in export |
| ADF-02 | `adf.dataSource` contains no duplicate source-object mappings | Partial | adf.datasource.csv | No direct duplicate check implemented yet; key completeness is strong |
| ADF-03 | `adf.dataProcess` mappings are complete and current | Partial | adf.dataprocess.csv | Strong completeness of process path and PK columns; staleness check pending |
| ADF-04 | `adf.dataProcessDependency` has no orphan or circular dependencies | Partial | adf.dataProcessDependency.csv | Duplicate dependency pairs not observed; orphan/cycle detection pending |
| ADF-05 | Execution logs have normalized return states | Partial | adf.executionLog.csv | Start/end/error flags present; explicit normalized return-state field not in extract |
| ADF-06 | Failed runs have actionable error classification | Partial | adf.executionLog.csv | Error flag available; standardized error class mapping not yet evidenced |
| ADF-07 | Last execution timestamps are consistently updated | Partial | dataSource/dataProcess CSVs | Timestamp fields present; consistency check by source/process pending |
| ADF-08 | Stale/deprecated metadata records are identified and flagged | Partial | adf.* CSVs | `isEnabled` exists; stale/deprecated policy not yet reviewed |
| ADF-09 | Environment parity across dev/test/prod metadata is controlled | Partial | ADF repo + evidence | Promote flags present; parity validation not yet executed |
| ADF-10 | Key Vault references are used instead of inline secrets | Partial | ADF repo linked services | Key Vault linked services present; inline secret audit pending |

## 4. Findings Summary

- High priority findings:
- Execution and metric logs are very large; no evidence yet of retention/archival policy in assessment package.
- Error flag exists but standardized error classification for maturity scoring is not yet materialized.

- Medium priority findings:
- Governance fields (owner/classification) are not visible in metadata extracts and need source-of-truth mapping.
- 209 dependency rows are disabled (`isEnabled = false`), requiring cleanup/justification review.

- Low priority findings:
- None recorded in baseline pass.

## 5. Remediation Backlog

| Item ID | Priority | Action | Owner | Target Release | Status |
|---|---|---|---|---|---|
| ADF-R01 | H | Define and implement standardized error classification model for `adf.executionLog` failures | Data Engineering | TBD | Open |
| ADF-R02 | H | Define retention/archival strategy for execution and operation metric logs | Platform + Data Engineering | TBD | Open |
| ADF-R03 | M | Validate/clean disabled dependency rows and document intended inactive flows | Data Engineering | TBD | Open |
| ADF-R04 | M | Add/associate governance ownership/classification mapping for metadata-driven objects | Data Governance + Data Engineering | TBD | Open |
