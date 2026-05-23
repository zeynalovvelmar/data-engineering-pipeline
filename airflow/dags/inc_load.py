from datetime import datetime
from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

with DAG(
    dag_id="incremental_load_dag",
    schedule=None,
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=["staging", "incremental"],
) as dag:
    start = EmptyOperator(task_id="start")
    end = EmptyOperator(task_id="end")

    execute_incremental_load = SQLExecuteQueryOperator(
        task_id="execute_incremental_load",
        conn_id="target_db",
        sql="sql/inc_load_tables.sql",
    )

    start >> execute_incremental_load >> end
