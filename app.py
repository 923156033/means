#!/bin/python
# coding=utf-8
import requests
import prometheus_client
from prometheus_client.core import CollectorRegistry
from prometheus_client import Gauge
from flask import Response, Flask


# 定义函数，返回接口响应码
def http_code(url):
    try:
        url = url
        response = requests.post(url)
        return response.status_code
    except:
        return 666


app = Flask(__name__)

# 定义一个仓库，存放数据
REGISTRY = CollectorRegistry(auto_describe=False)
url_http_code = Gauge("url_http_code", "request http_code of the url",
                      ["service", "url", "status_code"], registry=REGISTRY)
service_list = [{"serverName": "baseServer", "url": "http://192.168.0.16:7800"},
                {"serverName": "ServicePlatform", "url": "http://192.168.0.16:7813"},
                {"serverName": "PublicServer", "url": "http://192.168.0.16:7805"}]


# 定义路由
@app.route("/metrics")
def api_response():
    for i in service_list:
        service = i.get("serverName")
        url = i.get("url")
        status_code = http_code(url)
        url_http_code.labels(service, url, status_code).set(status_code)
    return Response(prometheus_client.generate_latest(url_http_code),
                    mimetype="text/plain")


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=3531, debug=True)
