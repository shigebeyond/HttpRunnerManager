#!/bin/bash

echo '1 启动web'
python3 manage.py runserver 0.0.0.0:8080 &

if [ "$1" == -a ]
then
  echo '2 启动celery'
  echo '2.1 启动worker'
  python3 manage.py celery -A HttpRunnerManager worker --loglevel=info &
  echo '2.2 启动定时任务监听器'
  python3 manage.py celery beat --loglevel=info &
  echo '2.3 启动任务监控后台' 
  celery flower --address=0.0.0.0 --port=5555 --broker=redis://192.168.0.184/6 &
fi