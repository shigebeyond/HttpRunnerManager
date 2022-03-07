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