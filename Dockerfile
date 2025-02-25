# 基础镜像 python3.6-mysql5.6-redis
FROM registry.cn-hangzhou.aliyuncs.com/hw_wei/py_mysql_redis:1.0

# 描述
MAINTAINER HttpRunnerManager

# 复制文件
# 由于add/copy的文件必须使用上下文目录的内容, 因此要先将xxx文件拷贝到当前目录
# https://www.367783.net/hosting/5025.html
COPY ./ /apps/HttpRunnerManager/

# 安装依赖, -i指定豆瓣仓库
# 安装库 dwebsocket 报错（无法解决放弃）：UnicodeDecodeError: 'ascii' codec can't decode byte 0xc3 in posit
RUN pip install -r /apps/HttpRunnerManager/requirements.txt -i https://pypi.douban.com/simple \
    && pip uninstall -y tornado \
    && pip install tornado==5.1.1 -i https://pypi.douban.com/simple

# 暴露端口, 跟HttpRunnerManager端口一样
EXPOSE 8080 5555

# 启动命令
# 1 启动容器后, 进入容器bash手动启动 start.sh -- 直接 docker run -t 添加-t参数即可
#CMD ["/bin/sh", "-c", "while true; do sleep 100; done"] # 让进程一直跑, 否则容器会exit
# 2 自动启动
ENTRYPOINT ["/apps/HttpRunnerManager/start.sh"]