from datetime import datetime
from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

with DAG(
    dag_id="data_mart_dag",
    schedule=None,
    start_date=datetime(2024, 1, 1),
    catchup=False,
) as dag:
    load_marts = SQLExecuteQueryOperator(
        task_id="load_data_marts",
        conn_id="target_db",
        sql="sql/mart_modeling.sql",
    )
