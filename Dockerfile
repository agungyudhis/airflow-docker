# First-time build can take upto 10 mins.

FROM apache/airflow:slim-2.10.2

ENV AIRFLOW_HOME=/opt/airflow

# Create the user

WORKDIR $AIRFLOW_HOME

USER root
RUN apt update -q
RUN apt install vim -qqq
RUN apt install software-properties-common -qqq
RUN apt install python3-launchpadlib -qqq
RUN apt install default-libmysqlclient-dev -qqq
RUN apt install build-essential -qqq
RUN apt install pkg-config -qqq

COPY requirements.txt .

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install mysqlclient apache-airflow-providers-mysql
RUN python3 -m pip install apache-airflow-providers-amazon
RUN python3 -m pip install psycopg2-binary
RUN python3 -m pip install boto3

RUN apt install python3.11 python3.11-venv -qqq

RUN python3.11 -m venv /opt/airflow/venv1
RUN /opt/airflow/venv1/bin/pip install --upgrade pip
RUN /opt/airflow/venv1/bin/pip install --no-cache-dir -r requirements.txt
RUN /opt/airflow/venv1/bin/pip install psycopg2-binary

RUN mkdir /home/data

# Create the AIRFLOW_HOME directory and change its ownership to the airflow user
RUN chown -R airflow: ${AIRFLOW_HOME}
RUN chown -R airflow: /home/data

# Switch back to the airflow user
USER airflow

USER ${AIRFLOW_UID}
