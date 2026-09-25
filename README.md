# Data Engineering Pipeline (DWH & Data Mart)

Comprehensive ETL project simulating a multi-layer Data Warehouse architecture (Raw -> DWH -> Mart) supporting both Full and Incremental loads.

## Tech Stack
- **Orchestration:** Airflow
- **Processing:** Python (ETL)
- **Storage:** PostgreSQL (DWH & Mart layers)

## Project Structure
- \ull_load.py\ & \inc_load.py\: Load logic scripts.
- \dwh_layer.py\ & \data_mart.py\: Layer processing.
- \*.sql\: Schema definitions for all layers.