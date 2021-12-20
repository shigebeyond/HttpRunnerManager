#!/bin/bash

echo '1 启动mysql'
service mysql start 

echo '2 启动redis'
redis-server &

# cd项目目录
cd `dirname $0`

echo '3 初始化数据'
mysql -uroot -p123456 <hrun.sql


echo '4 启动web'
python manage.py runserver 0.0.0.0:8080 &

echo '5 启动celery'
echo '5.1 启动worker'
python manage.py celery -A HttpRunnerManager worker --loglevel=info &
echo '5.2 启动定时任务监听器'
python manage.py celery beat --loglevel=info &
echo '5.3 启动任务监控后台'
celery flower --address=0.0.0.0 --port=5555 --broker=redis://127.0.0.1