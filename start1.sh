#!/bin/bash

echo '1 启动web'
python /apps/HttpRunnerManager/manage.py runserver 0.0.0.0:8080 &
python /apps/HttpRunnerManager/manage.py celery -A HttpRunnerManager worker --loglevel=info &
python /apps/HttpRunnerManager/manage.py celery beat --loglevel=info &
celery flower --address=0.0.0.0 --port=5555 --broker=redis://192.168.0.184/6
