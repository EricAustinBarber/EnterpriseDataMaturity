# Production Pipeline Risk List

Generated from `assessments/evidence/adf.executionLog.csv` (production extract).

- Pipelines with at least one error: **34**
- Total error rows across all pipelines: **3509**

## Category Distribution

- bronze_ingestion_or_processing: 20
- silver_transform_orchestration: 7
- gold_transform_orchestration: 5
- serving_or_application_integration: 2

## Highest Risk Pipelines (Top 20 by Risk Score)

| Pipeline | Category | Risk Score | Errors | Error Rate % |
|---|---|---:|---:|---:|
| plSilverToGoldChild | gold_transform_orchestration | 1614.06 | 1059 | 0.253 |
| plBronzeToSilver | silver_transform_orchestration | 1015.81 | 620 | 0.09 |
| plSourceToBronzeSecureFileSystemClueAll | bronze_ingestion_or_processing | 1009.0 | 6 | 50.0 |
| plMdwToPbiParentWebAppRLSTables | serving_or_application_integration | 778.7 | 55 | 34.81 |
| plMdwToPbiChildWebAppRLSTables | serving_or_application_integration | 709.89 | 46 | 31.944 |
| plSilverToGoldParent | gold_transform_orchestration | 588.84 | 228 | 0.867 |
| plSourceToBronzeAsqlInEight | bronze_ingestion_or_processing | 387.57 | 211 | 0.104 |
| plSourceToBronzeSql | bronze_ingestion_or_processing | 377.49 | 198 | 0.2 |
| plSourceToBronzeSqlCosential | bronze_ingestion_or_processing | 369.14 | 186 | 0.182 |
| plSourceToBronzeSqlE1 | bronze_ingestion_or_processing | 319.53 | 155 | 0.202 |
| plSourceToBronzeRestApiCosetial | bronze_ingestion_or_processing | 282.48 | 107 | 0.949 |
| plSourceToBronzeAsqlQdr | bronze_ingestion_or_processing | 265.12 | 140 | 0.281 |
| plSourceToBronzeSqlDEstimator | bronze_ingestion_or_processing | 204.67 | 74 | 0.383 |
| plSourceToBronzeAsql | bronze_ingestion_or_processing | 184.38 | 84 | 0.394 |
| plSourceToBronzeRestApiPbi | bronze_ingestion_or_processing | 142.23 | 69 | 1.112 |
| plSourceToBronzeSharepoint | bronze_ingestion_or_processing | 138.49 | 55 | 0.3 |
| plSourceToGold | gold_transform_orchestration | 114.78 | 41 | 2.289 |
| plSourceToGoldIneight | gold_transform_orchestration | 91.65 | 15 | 3.432 |
| plSourceToBronzeSoapApiB2G | bronze_ingestion_or_processing | 59.25 | 27 | 0.938 |
| plSourceToBronzeRestApiScheduleValidator | bronze_ingestion_or_processing | 50.18 | 15 | 1.384 |

## Full List

- `assessments/prod-pipeline-risk-list.csv`
- `assessments/prod-pipeline-risk-list-all.csv` (includes pipelines with zero recorded errors)
