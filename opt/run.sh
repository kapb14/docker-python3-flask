#!/bin/bash

PORT="${SERVER_PORT:-55000}"
WORKERS=${SERVER_WORKERS:-2}
CONN_LIMIT=${SERVER_CONN_LIMIT:-1000}

cd /app


msg(){
  echo -e "[$(date +%F)] $@"
}


check_requirements(){
  msg "check for requirements.txt"
  if [[ -f requirements.txt ]]; then
    msg "found requirements.txt in /app folder - try to install some packages from it"
    pip install --no-cache-dir -r requirements.txt
  fi
}

check_app_files(){
  find /app -name '*.py' -type f
}

get_app_files(){
  grep -r -m 1 'Flask(__name__)' *.py | grep -v '^__init__.py' | awk $'{print $1}'
}


run_example(){
  msg "run an example /opt/app.py with gunicorn"
  cd /opt
  gunicorn \
    --workers ${WORKERS} \
    --worker-connections ${CONN_LIMIT} \
    --access-logfile - \
    --error-logfile - \
    --bind 0.0.0.0:${PORT} \
    --reload \
    --log-level info \
    --name flask \
    app:app
}

run_app(){
  msg "run an application $1:$2 with gunicorn"
  gunicorn \
    --workers ${WORKERS} \
    --worker-connections ${CONN_LIMIT} \
    --access-logfile - \
    --error-logfile - \
    --bind 0.0.0.0:${PORT} \
    --reload \
    --log-level info \
    --name flask \
    $1:$2
}


if check_app_files | egrep '.*'; then
  get_app_files
  APP_FILE="$(basename $(grep -r -m 1 'Flask(__name__)' *.py | grep -v '^__init__.py' | awk $'{print $1}' | head -n 1 | cut -d ':' -f 1) .py)"
  APP_NAME="$(grep -r -m 1 'Flask(__name__)' *.py | grep -v '^__init__.py' | awk $'{print $1}' | head -n 1 | cut -d ':' -f 2)"
  msg "APP_FILE:   ${APP_FILE}"
  msg "APP_NAME:   ${APP_NAME}"
  run_app ${APP_FILE} ${APP_NAME}
else
  run_example
fi



