/*
ADF metadata extraction and quality baseline script
Aligned to assessments/adf-metadata-review.md checks (ADF-01 .. ADF-10)
*/

SET NOCOUNT ON;

DECLARE @days_back INT = 14;

/* ============================================================
   Section 1: Core Extracts (source evidence)
   ============================================================ */

SELECT *
FROM adf.dataSource;

SELECT *
FROM adf.dataProcess;

SELECT *
FROM adf.dataProcessDependency;

SELECT *
FROM adf.executionLog
WHERE pipelineTriggerTimestamp >= DATEADD(day, -@days_back, GETDATE());

SELECT *
FROM adf.operationMetricLog
WHERE executionTimestamp >= DATEADD(day, -@days_back, GETDATE());

/* ============================================================
   Section 2: Metadata completeness and hygiene checks
   ============================================================ */

/* ADF-01: Required field completeness in adf.dataSource */
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(dataSourceName)), '') IS NULL THEN 1 ELSE 0 END) AS missing_dataSourceName,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(dataSourceType)), '') IS NULL THEN 1 ELSE 0 END) AS missing_dataSourceType,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(objectSchema)), '') IS NULL THEN 1 ELSE 0 END) AS missing_objectSchema,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(objectName)), '') IS NULL THEN 1 ELSE 0 END) AS missing_objectName,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(connectionSecretName)), '') IS NULL THEN 1 ELSE 0 END) AS missing_connectionSecretName
FROM adf.dataSource;

/* ADF-02: Potential duplicate source-object mappings */
SELECT
    dataSourceName,
    objectSchema,
    objectName,
    COUNT(*) AS duplicate_count
FROM adf.dataSource
GROUP BY dataSourceName, objectSchema, objectName
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, dataSourceName, objectSchema, objectName;

/* ADF-03: Required field completeness in adf.dataProcess */
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(dataProcess)), '') IS NULL THEN 1 ELSE 0 END) AS missing_dataProcess,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(objectSchema)), '') IS NULL THEN 1 ELSE 0 END) AS missing_objectSchema,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(objectName)), '') IS NULL THEN 1 ELSE 0 END) AS missing_objectName,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(dataProcessPathOrProcedure)), '') IS NULL THEN 1 ELSE 0 END) AS missing_dataProcessPathOrProcedure,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(primaryKeyColumns)), '') IS NULL THEN 1 ELSE 0 END) AS missing_primaryKeyColumns
FROM adf.dataProcess;

/* ADF-04: Orphan dependencies (source/destination not found in dataProcess) */
SELECT
    d.dataProcessDependencyId,
    d.dataProcess,
    d.sourceObjectSchema,
    d.sourceObjectName,
    d.destinationObjectSchema,
    d.destinationObjectName
FROM adf.dataProcessDependency d
LEFT JOIN adf.dataProcess src
    ON src.objectSchema = d.sourceObjectSchema
   AND src.objectName = d.sourceObjectName
LEFT JOIN adf.dataProcess dst
    ON dst.objectSchema = d.destinationObjectSchema
   AND dst.objectName = d.destinationObjectName
WHERE src.dataProcessID IS NULL
   OR dst.dataProcessID IS NULL
ORDER BY d.dataProcessDependencyId;

/* ADF-04: Duplicate dependency pairs */
SELECT
    sourceObjectSchema,
    sourceObjectName,
    destinationObjectSchema,
    destinationObjectName,
    COUNT(*) AS duplicate_count
FROM adf.dataProcessDependency
GROUP BY sourceObjectSchema, sourceObjectName, destinationObjectSchema, destinationObjectName
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

/* ADF-08: Disabled metadata records by table */
SELECT 'adf.dataSource' AS table_name, COUNT(*) AS disabled_count
FROM adf.dataSource
WHERE isEnabled = 0
UNION ALL
SELECT 'adf.dataProcess' AS table_name, COUNT(*) AS disabled_count
FROM adf.dataProcess
WHERE isEnabled = 0
UNION ALL
SELECT 'adf.dataProcessDependency' AS table_name, COUNT(*) AS disabled_count
FROM adf.dataProcessDependency
WHERE isEnabled = 0;

/* ============================================================
   Section 3: Execution log quality and maturity checks
   ============================================================ */

/* ADF-05 and ADF-06: Execution health summary */
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN isStart = 1 THEN 1 ELSE 0 END) AS start_rows,
    SUM(CASE WHEN isEnd = 1 THEN 1 ELSE 0 END) AS end_rows,
    SUM(CASE WHEN isError = 1 THEN 1 ELSE 0 END) AS error_rows,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(pipelineName)), '') IS NULL THEN 1 ELSE 0 END) AS missing_pipelineName,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(objectSchema)), '') IS NULL THEN 1 ELSE 0 END) AS missing_objectSchema,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(objectName)), '') IS NULL THEN 1 ELSE 0 END) AS missing_objectName
FROM adf.executionLog
WHERE pipelineTriggerTimestamp >= DATEADD(day, -@days_back, GETDATE());

/* ADF-05: Derived return-state classification (transitional until standardized model exists) */
SELECT
    CASE
        WHEN isError = 1 THEN 'Failed'
        WHEN isEnd = 1 AND isError = 0 THEN 'Succeeded'
        WHEN isStart = 1 AND isEnd = 0 AND isError = 0 THEN 'InProgressOrAbandoned'
        ELSE 'Unknown'
    END AS derived_return_state,
    COUNT(*) AS row_count
FROM adf.executionLog
WHERE pipelineTriggerTimestamp >= DATEADD(day, -@days_back, GETDATE())
GROUP BY
    CASE
        WHEN isError = 1 THEN 'Failed'
        WHEN isEnd = 1 AND isError = 0 THEN 'Succeeded'
        WHEN isStart = 1 AND isEnd = 0 AND isError = 0 THEN 'InProgressOrAbandoned'
        ELSE 'Unknown'
    END
ORDER BY row_count DESC;

/* ADF-06: Top failing pipelines for triage */
SELECT TOP 25
    pipelineName,
    COUNT(*) AS error_count
FROM adf.executionLog
WHERE pipelineTriggerTimestamp >= DATEADD(day, -@days_back, GETDATE())
  AND isError = 1
GROUP BY pipelineName
ORDER BY error_count DESC, pipelineName;

/* ============================================================
   Section 4: Operation metric quality checks
   ============================================================ */

/* Metric completeness for operationMetricLog */
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(objectSchema)), '') IS NULL THEN 1 ELSE 0 END) AS missing_objectSchema,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(objectName)), '') IS NULL THEN 1 ELSE 0 END) AS missing_objectName,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(pipelineName)), '') IS NULL THEN 1 ELSE 0 END) AS missing_pipelineName
FROM adf.operationMetricLog
WHERE executionTimestamp >= DATEADD(day, -@days_back, GETDATE());

/* Top metric-producing pipelines */
SELECT TOP 25
    pipelineName,
    COUNT(*) AS metric_rows
FROM adf.operationMetricLog
WHERE executionTimestamp >= DATEADD(day, -@days_back, GETDATE())
GROUP BY pipelineName
ORDER BY metric_rows DESC, pipelineName;
