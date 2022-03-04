# Create your tasks here
from __future__ import absolute_import, unicode_literals

import os
import shutil

from celery import shared_task
from django.core.exceptions import ObjectDoesNotExist

from ApiManager.models import ProjectInfo
from ApiManager.utils.common import timestamp_to_datetime
from ApiManager.utils.emails import send_email_reports
from ApiManager.utils.operation import add_test_reports
from ApiManager.utils.runner import run_by_project, run_by_module, run_by_suite
from ApiManager.utils.testcase import get_time_stamp
from httprunner import HttpRunner, logger

# 生成支持顺序: 文件生成顺序 = 执行顺序 => 文件名前加上序号
# 加载也支持顺序: 按文件名排序
# 1 改造 FileUtils.load_folder_files() 方法 -- 支持加载顺序 -- 失败
'''
from httprunner.utils import FileUtils

load_folder_files1 = FileUtils.load_folder_files
def load_folder_files2(folder_path, recursive=True):
    files = load_folder_files1(folder_path, recursive)
    if len(files) > 1:
        files.sort()
    return files
FileUtils.load_folder_files = load_folder_files2
'''
# 2 改造 TestcaseLoader.load_testsets_by_path() -- 支持加载顺序 -- 成功
from httprunner.testcase import TestcaseLoader

load_testsets_by_path1 = TestcaseLoader.load_testsets_by_path
def load_testsets_by_path2(path):
    items = load_testsets_by_path1(path)
    if len(items) > 1:
        items.sort(key=lambda item:item['config']['path']) # 按文件名排序
    return items
TestcaseLoader.load_testsets_by_path = load_testsets_by_path2

# 3 改造 httprunner.client.HttpSession.request() -- 支持打印curl + fix get请求不能传递data + fix不能传递cookie
from httprunner.client import HttpSession
import curlify

request1 = HttpSession.request
def request2(self, method, url, name=None, **kwargs):
    # fix bug： get请求不能传递data， 否则会导致以下问题： get请求的data会被转为body，请求会多出content-length请求头，而client又不发body，从而导致： 1 HttpSession请求时server会接收不到data对应的请求参数 2 curl请求时server一直在等待body
    if method.upper() == 'GET' and 'data' in kwargs and kwargs['data']:
        data = kwargs['data']
        # 将data转为query string
        if '?' in url:
            query_string = '&'
        else:
            query_string = '?'
        for k, v in data.items():
            query_string += f"{k}={v}&"
        url += query_string
        kwargs['data'] = None

    # fix bug: 不能传递cookie
    if 'headers' in kwargs and 'cookie' in kwargs['headers']:
        cookie = kwargs['headers']['cookie']
        kwargs['cookies'] = dict([l.split("=", 1) for l in cookie.split("; ")]) # cookie字符串转化为字典

    res = request1(self, method, url, name, **kwargs)
    # 打印curl
    cmd = curlify.to_curl(res.request)
    print('发送请求：' + cmd)
    return res
HttpSession.request = request2

@shared_task
def main_hrun(testset_path, report_name):
    """
    用例运行
    :param testset_path: dict or list
    :param report_name: str
    :return:
    """
    logger.setup_logger('INFO')
    print(f'异步执行用例目录: {testset_path} => 生成报告: {report_name}')
    kwargs = {
        "failfast": False,
    }
    runner = HttpRunner(**kwargs)
    runner.run(testset_path)
    shutil.rmtree(testset_path)

    runner.summary = timestamp_to_datetime(runner.summary)
    report_path = add_test_reports(runner, report_name=report_name)
    os.remove(report_path)
    return runner


@shared_task
def project_hrun(name, base_url, project, receiver):
    """
    异步运行整个项目
    :param env_name: str: 环境地址
    :param project: str
    :return:
    """
    logger.setup_logger('INFO')
    kwargs = {
        "failfast": False,
    }
    runner = HttpRunner(**kwargs)
    id = ProjectInfo.objects.get(project_name=project).id

    testcase_dir_path = os.path.join(os.getcwd(), "suite")
    testcase_dir_path = os.path.join(testcase_dir_path, get_time_stamp())

    run_by_project(id, base_url, testcase_dir_path)

    runner.run(testcase_dir_path)
    shutil.rmtree(testcase_dir_path)

    runner.summary = timestamp_to_datetime(runner.summary)
    report_path = add_test_reports(runner, report_name=name)

    if receiver != '':
        send_email_reports(receiver, report_path)
    os.remove(report_path)


@shared_task
def module_hrun(name, base_url, module, receiver):
    """
    异步运行模块
    :param env_name: str: 环境地址
    :param project: str：项目所属模块
    :param module: str：模块名称
    :return:
    """
    logger.setup_logger('INFO')
    kwargs = {
        "failfast": False,
    }
    runner = HttpRunner(**kwargs)
    module = list(module)

    testcase_dir_path = os.path.join(os.getcwd(), "suite")
    testcase_dir_path = os.path.join(testcase_dir_path, get_time_stamp())

    try:
        for value in module:
            run_by_module(value[0], base_url, testcase_dir_path)
    except ObjectDoesNotExist:
        return '找不到模块信息'

    runner.run(testcase_dir_path)

    shutil.rmtree(testcase_dir_path)
    runner.summary = timestamp_to_datetime(runner.summary)
    report_path = add_test_reports(runner, report_name=name)

    if receiver != '':
        send_email_reports(receiver, report_path)
    os.remove(report_path)


@shared_task
def suite_hrun(name, base_url, suite, receiver):
    """
    异步运行模块
    :param env_name: str: 环境地址
    :param project: str：项目所属模块
    :param module: str：模块名称
    :return:
    """
    logger.setup_logger('INFO')
    kwargs = {
        "failfast": False,
    }
    runner = HttpRunner(**kwargs)
    suite = list(suite)

    testcase_dir_path = os.path.join(os.getcwd(), "suite")
    testcase_dir_path = os.path.join(testcase_dir_path, get_time_stamp())

    try:
        for value in suite:
            run_by_suite(value[0], base_url, testcase_dir_path)
    except ObjectDoesNotExist:
        return '找不到Suite信息'

    runner.run(testcase_dir_path)

    shutil.rmtree(testcase_dir_path)

    runner.summary = timestamp_to_datetime(runner.summary)
    report_path = add_test_reports(runner, report_name=name)

    if receiver != '':
        send_email_reports(receiver, report_path)
    os.remove(report_path)
