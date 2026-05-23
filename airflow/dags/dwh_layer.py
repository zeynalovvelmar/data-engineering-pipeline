from datetime import datetime
from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

with DAG(
    dag_id="dwh_modeling_dag",
    schedule=None,
    start_date=datetime(2024, 1, 1),
    catchup=False,
) as dag:
    execute_modeling = SQLExecuteQueryOperator(
        task_id="execute_modeling",
        conn_id="target_db",
        sql="sql/dwh_modeling.sql",
    )
