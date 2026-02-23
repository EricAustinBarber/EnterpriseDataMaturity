# Databricks Implementation Summary

## Inventory Baseline

- Notebook files inventoried: 536
- Function and transformation items cataloged: 219

## Catalog by Layer

- utility: 123
- 100_raw_to_bronze: 37
- 300_silver_to_gold: 28
- 000_source_to_raw: 11
- security: 6
- maintenance: 5
- miscellaneous_scripts: 5
- environment_promotion: 4

## Catalog by Item Type

- python_def: 218
- sql_table: 1

## Top Files by Function/Item Density

- utility/common_functions.py: 58
- utility/odbc_sql_server.py: 27
- utility/gold_table_processor.py: 17
- 300_silver_to_gold/equipment/silver_to_gold_fact_maint_schedule.py: 13
- security/security_functions.py: 6
- utility/jdbc_sql_server.py: 5
- utility/recursive_query_processor.py: 5
- 300_silver_to_gold/conformed/silver_to_gold_dim_date.py: 5
- 100_raw_to_bronze/vairkko/raw_to_bronze_vairkko_certifications.py: 5
- utility/nano_second_timer.py: 4
- 100_raw_to_bronze/tradetapp/source_to_bronze_financials.py: 4
- maintenance/maintenance_define_schedulevalidator_schema.py: 3
- utility/log_operation_metrics.py: 3
- utility/user_defined_functions.py: 3
- environment_promotion/metadata_promotion_scripts/run_adf_promote_metadata_pipeline.py: 3

## Referenced Inventories

- `assessments/databricks-notebook-inventory.csv`
- `assessments/databricks-function-inventory.csv`
