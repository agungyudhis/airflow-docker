from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta
import pandas as pd
import os


def my_callable(*args, **kwargs):
    data = pd.DataFrame({'a': [1, 2, 3], 'b': [4, 2, 4]})
    data.to_csv(f'/home/data/test.csv', index=False)
    print("Hello from PythonOperator")
    print(pd.__version__)
    print(os.path.dirname(os.path.realpath(__file__)))
    return "AAAA"


def my_callable2(*args, **kwargs):
    return "Success"


# [END import_module]

# [START default_args]
# These args will get passed on to each operator
# You can override them on a per-task basis during operator initialization
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': timedelta(minutes=1),
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2016, 1, 1),
    # 'wait_for_downstream': False,
    # 'dag': dag,
    # 'sla': timedelta(hours=2),
    # 'execution_timeout': timedelta(seconds=300),
    # 'on_failure_callback': some_function,
    # 'on_success_callback': some_other_function,
    # 'on_retry_callback': another_function,
    # 'sla_miss_callback': yet_another_function,
    # 'trigger_rule': 'all_success'
}
# [END default_args]

# [START instantiate_dag]
with DAG(
    'tutorial',
    default_args=default_args,
    description='A simple tutorial DAG',
    schedule_interval=timedelta(days=1),
    start_date=datetime(2021, 1, 1),
    catchup=False,
    tags=['example'],
) as dag:

    t1 = PythonOperator(
        task_id='my_python_task',
        python_callable=my_callable,
        op_kwargs={'key': 'value'}
    )

    t2 = PythonOperator(
        task_id='my_python_task2',
        python_callable=my_callable2,
        op_kwargs={'key': 'value'}
    )

    t1 >> t2
