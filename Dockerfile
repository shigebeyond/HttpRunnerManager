# 基础镜像
FROM silverlogic/python3.6

# 描述
MAINTAINER HttpRunnerManager

# 定义匿名数据卷, 挂到/var/lib/docker/tmp/
# 必须是容器内部路径, 不能是宿主路径
# 如果要使用宿主路径, 请在 docker run时用-v做好宿主与容器的路径映射
# https://blog.csdn.net/fangford/article/details/88873104
#VOLUME "/data1"

# 复制文件
# 由于add/copy的文件必须使用上下文目录的内容, 因此要先将xxx文件拷贝到当前目录
# https://www.367783.net/hosting/5025.html
COPY ./ /apps/HttpRunnerManager/

# 安装依赖
RUN pip install -r /apps/HttpRunnerManager/requirements.txt \
    && pip uninstall -y tornado \
    && pip install tornado==5.1.1

# 暴露端口, 跟HttpRunnerManager端口一样
EXPOSE 8080 5555

# 启动命令
# 1 启动容器后, 进入容器bash手动启动 start.sh -- 直接 docker run -t 添加-t参数即可
#CMD ["/bin/sh", "-c", "while true; do sleep 100; done"] # 让进程一直跑, 否则容器会exit
# 2 自动启动
ENTRYPOINT ["/apps/HttpRunnerManager/start.sh"]
