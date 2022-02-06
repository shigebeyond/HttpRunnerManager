from django import template
try:  # py3
    from shlex import quote
except ImportError:  # py2
    from pipes import quote

register = template.Library()   #register的名字是固定的,不可改变

# 利用装饰器 @register.simple_tag 自定义标签
@register.simple_tag
def to_curl(request, compressed=False, verify=True): # request是dict
    """
    Returns string with curl command by provided request dict object

    Parameters
    ----------
    compressed : bool
        If `True` then `--compressed` argument will be added to result
    """
    parts = [
        ('curl', None),
        # ('-X', request['method']),
    ]
    if request['method'].lower() == 'get':
        parts += [('-G', None)]

    for k, v in sorted(request['headers'].items()):
        parts += [('-H', '{0}: {1}'.format(k, v))]

    if request['body']:
        body = request['body']
        if isinstance(body, bytes):
            body = body.decode('utf-8')
        parts += [('-d', body)]

    if compressed:
        parts += [('--compressed', None)]

    if not verify:
        parts += [('--insecure', None)]

    parts += [(None, request['url'])]

    flat_parts = []
    for k, v in parts:
        if k:
            flat_parts.append(quote(k))
        if v:
            flat_parts.append(quote(v))

    return ' '.join(flat_parts)
