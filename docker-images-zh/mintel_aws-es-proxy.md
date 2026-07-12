---
image: mintel/aws-es-proxy
description: "aws-es-proxy是一个位于HTTP客户端与Amazon Elasticsearch服务之间的代理工具，使用AWS Signature Version 4自动签名请求，并支持Kibana请求，简化对需要IAM认证的Elasticsearch服务的访问。"
source: https://xuanyuan.cloud/zh/r/mintel/aws-es-proxy
canonical: https://xuanyuan.cloud/zh/r/mintel/aws-es-proxy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mintel/aws-es-proxy" title="mintel/aws-es-proxy Docker 镜像中文简介、标签列表与拉取命令">mintel/aws-es-proxy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# aws-es-proxy

## 镜像概述

aws-es-proxy是一个轻量级Web服务器应用，作为HTTP客户端（浏览器、curl等）与Amazon Elasticsearch服务之间的代理。它能使用最新的AWS Signature Version 4对请求进行签名，再转发至Amazon Elasticsearch服务，并将响应返回给客户端。同时支持自动签名Kibana请求，简化对需要IAM认证的Elasticsearch服务的访问。

## 核心功能与特性

- **AWS签名支持**：自动使用AWS Signature Version 4对请求进行签名，无需手动处理认证
- **Kibana兼容**：自动签名Kibana请求，可直接通过代理访问Kibana界面
- **多认证方式**：支持AWS凭证文件、环境变量及IAM角色认证
- **灵活配置**：可自定义监听地址、端口、请求超时等参数
- **日志功能**：支持 verbose 模式打印请求详情，及日志文件输出
- **安全增强**：可选HTTP Basic Auth认证保护代理访问

## 使用场景

- 本地开发环境访问需要IAM认证的Amazon Elasticsearch服务
- 通过标准Elasticsearch客户端（如Kibana、curl、ES客户端库）连接AWS Elasticsearch
- 在无法直接配置AWS签名的环境中访问Elasticsearch服务
- 需要监控Elasticsearch请求与响应的场景

## 安装与使用

### Docker 运行

#### v0.9及更新版本（latest标签指向最新发布版）：

```sh
docker run --rm -v ~/.aws:/root/.aws -p 9200:9200 docker.xuanyuan.run/abutaha/aws-es-proxy:v1.0 -endpoint https://dummy-host.ap-southeast-2.es.amazonaws.com -listen 0.0.0.0:9200
```

#### v0.8版本：

```sh
docker run --rm -it docker.xuanyuan.run/abutaha/aws-es-proxy ./aws-es-proxy -endpoint https://dummy-host.ap-southeast-2.es.amazonaws.com
```

#### 自定义暴露端口：

通过`PORT_NUM`环境变量指定暴露端口：

```sh
docker run --rm -v ~/.aws:/root/.aws -e PORT_NUM=8080 -p 8080:8080 docker.xuanyuan.run/abutaha/aws-es-proxy:latest -endpoint https://your-es-endpoint.amazonaws.com -listen 0.0.0.0:8080
```

## 配置说明

### AWS凭证配置

使用前需配置AWS IAM用户凭证，支持以下方式：

#### 1. AWS凭证文件

创建`~/.aws/credentials`文件：

```
[default]
aws_access_key_id = AKID1234567890
aws_secret_access_key = MY-SECRET-KEY
```

Docker运行时通过挂载目录将凭证文件传递给容器：`-v ~/.aws:/root/.aws`

#### 2. 环境变量

设置以下环境变量：

```sh
export AWS_ACCESS_KEY_ID=AKID1234567890
export AWS_SECRET_ACCESS_KEY=MY-SECRET-KEY
```

在Docker中使用`-e`参数传递：

```sh
docker run --rm -e AWS_ACCESS_KEY_ID=AKID1234567890 -e AWS_SECRET_ACCESS_KEY=MY-SECRET-KEY -p 9200:9200 docker.xuanyuan.run/abutaha/aws-es-proxy:latest -endpoint https://your-es-endpoint.amazonaws.com
```

#### 3. IAM角色

支持使用IAM角色，需修改Elasticsearch访问策略允许该角色访问。示例策略：

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::012345678910:role/ec2-aws-elasticsearch"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:eu-west-1:012345678910:domain/test-es-domain/*"
    }
  ]
}
```

### 命令行参数

通过`-h`查看所有可用参数：

```sh
./aws-es-proxy -h
Usage of ./aws-es-proxy:
  -auth              启用HTTP Basic Auth认证
  -debug             打印调试信息
  -endpoint string   Amazon ElasticSearch服务端点（例如：https://dummy-host.eu-west-1.es.amazonaws.com）
  -listen string     本地监听地址和端口（默认："127.0.0.1:9200"）
  -log-to-file       将用户请求和ElasticSearch响应记录到文件
  -no-sign-reqs      禁用AWS Signature v4签名
  -password string   HTTP Basic Auth密码
  -pretty            美化verbose输出和文件日志格式
  -realm string      认证领域描述
  -remote-terminate  允许HTTP远程终止代理
  -timeout int       设置请求超时时间（秒），默认15
  -username string   HTTP Basic Auth用户名
  -verbose           打印用户请求详情
  -version           打印aws-es-proxy版本
```

### 环境变量

- `ENDPOINT`：指定Amazon Elasticsearch服务端点，替代`-endpoint`参数
- `PORT_NUM`：指定Docker容器暴露端口（仅Docker使用）

## 使用示例

### 基本使用

通过命令行参数指定端点：

```sh
docker run --rm -v ~/.aws:/root/.aws -p 9200:9200 docker.xuanyuan.run/abutaha/aws-es-proxy:latest -endpoint https://test-es-somerandomvalue.eu-west-1.es.amazonaws.com
```

通过环境变量指定端点：

```sh
docker run --rm -v ~/.aws:/root/.aws -e ENDPOINT=https://test-es-somerandomvalue.eu-west-1.es.amazonaws.com -p 9200:9200 docker.xuanyuan.run/abutaha/aws-es-proxy:latest
```

### 自定义监听地址和端口

```sh
docker run --rm -v ~/.aws:/root/.aws -p 8080:8080 docker.xuanyuan.run/abutaha/aws-es-proxy:latest -endpoint https://your-es-endpoint.amazonaws.com -listen 0.0.0.0:8080
```

### 启用Verbose模式

```sh
docker run --rm -v ~/.aws:/root/.aws -p 9200:9200 docker.xuanyuan.run/abutaha/aws-es-proxy:latest -endpoint https://your-es-endpoint.amazonaws.com -verbose
```

### 启用HTTP Basic Auth

```sh
docker run --rm -v ~/.aws:/root/.aws -p 9200:9200 docker.xuanyuan.run/abutaha/aws-es-proxy:latest -endpoint https://your-es-endpoint.amazonaws.com -auth -username admin -password secret
```

## HTTP客户端使用

启动代理后，可通过以下方式访问Elasticsearch服务：

- **Elasticsearch API**：访问 http://localhost:9200
- **Kibana**：访问 http://localhost:9200/_plugin/kibana/app/kibana
- **AWS OpenSearch Dashboards**：访问 http://localhost:9200/_dashboards/app/home#/

例如，使用curl查询集群健康状态：

```sh
curl http://localhost:9200/_cluster/health?pretty
