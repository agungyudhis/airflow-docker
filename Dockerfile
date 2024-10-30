# First-time build can take upto 10 mins.

FROM apache/airflow:slim-2.10.2

ENV AIRFLOW_HOME=/opt/airflow

# Create the user

WORKDIR $AIRFLOW_HOME

USER root
RUN apt-get update -qq && apt-get install vim -qqq

COPY requirements.txt .

RUN python3 -m pip install --upgrade pip

RUN python3 -m pip install --no-cache-dir -r requirements.txt
RUN python3 -m pip install psycopg2-binary

RUN mkdir /home/data

# Create the AIRFLOW_HOME directory and change its ownership to the airflow user
RUN chown -R airflow: ${AIRFLOW_HOME}
RUN chown -R airflow: /home/data

# Customize the airflow.cfg file
RUN echo "[core]" > ${AIRFLOW_HOME}/airflow.cfg && \
    echo "airflow_home = ${AIRFLOW_HOME}" >> ${AIRFLOW_HOME}/airflow.cfg && \
    echo "executor = LocalExecutor" >> ${AIRFLOW_HOME}/airflow.cfg

# Switch back to the airflow user
USER airflow

USER ${AIRFLOW_UID}
