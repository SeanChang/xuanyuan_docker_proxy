---
image: traefik/whoami
description: "轻量级Go语言Web服务器，可将操作系统信息和HTTP请求打印到输出。"
source: https://xuanyuan.cloud/zh/r/traefik/whoami
canonical: https://xuanyuan.cloud/zh/r/traefik/whoami
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/traefik/whoami" title="traefik/whoami Docker 镜像中文简介、标签列表与拉取命令">traefik/whoami — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/traefik/whoami" title="traefik/whoami Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/traefik/whoami</a>

# traefik/whoami 镜像文档

[![Docker Pulls](https://img.shields.io/docker/pulls/traefik/whoami.svg)](https://hub.docker.com/r/traefik/whoami/)
[![Build Status](https://github.com/traefik/whoami/workflows/Main/badge.svg?branch=master)](https://github.com/traefik/whoami/actions)


## 镜像概述与主要用途

traefik/whoami 是一个轻量级的 Go 语言 Web 服务器，主要用途是打印操作系统信息和 HTTP 请求详情到输出。该镜像设计简洁，适合用于快速验证 HTTP 服务、调试请求参数及网络配置。


## 核心功能与特性

### 核心功能
- **请求信息展示**：通过 HTTP 端点返回服务器 OS 信息（主机名、IP 地址）及请求详情（方法、头信息等）
- **多格式响应**：支持 JSON 格式输出（`/api` 端点）
- **基准测试支持**：提供固定响应端点（`/bench`）
- **动态响应生成**：可生成指定大小的响应数据（`/data` 端点）
- **WebSocket 测试**：支持 WebSocket 回显功能（`/echo` 端点）
- **健康检查控制**：可动态修改健康检查状态码（`/health` 端点）

### 主要特性
- 轻量级设计，资源占用低
- 支持自定义端口、服务名称
- 内置 TLS 支持（含双向 TLS）
- 详细日志输出（verbose 模式）
- 多协议支持（HTTP、WebSocket）


## 使用场景与适用范围

### 典型使用场景
- **开发调试**：快速验证 HTTP 请求参数、头信息、源 IP 等
- **网络测试**：验证容器网络连通性、端口映射及代理配置
- **健康检查测试**：模拟服务健康状态变化，测试监控告警机制
- **性能测试**：生成指定大小的响应数据，测试网络吞吐量
- **WebSocket 验证**：调试 WebSocket 连接及数据传输

### 适用范围
- 开发环境服务调试
- 测试环境功能验证
- CI/CD 流程中的服务可用性检查
- 网络配置验证工具


## 使用方法与配置说明

### 端点说明（Paths）

#### `/[?wait=d]`
- **功能**：返回基础 whoami 信息，包括主机名、IP 地址及 HTTP 请求详情
- **参数**：可选 `wait` 查询参数，指定响应延迟时间，格式遵循 Go 的 [`time.Duration`](https://golang.org/pkg/time/#ParseDuration)（如 `/?wait=100ms` 表示延迟 100 毫秒）

#### `/api`
- **功能**：以 JSON 格式返回 whoami 信息（包含主机名、IP、请求详情等结构化数据）

#### `/bench`
- **功能**：始终返回固定响应 `1`，用于基准测试或简单可用性验证

#### `/data?size=n[&unit=u]`
- **功能**：生成指定大小的响应数据
- **参数**：
  - `size=n`：必填，指定数据大小数值
  - `unit=u`：可选，单位（支持 `KB`、`MB`、`GB`、`TB`，默认单位：字节）

#### `/echo`
- **功能**：WebSocket 回显服务，接收客户端发送的消息并原样返回

#### `/health`
- **功能**：健康检查端点，支持动态修改响应状态码
  - `GET`/`HEAD` 等方法：返回由 `POST` 方法设置的状态码
  - `POST` 方法：通过请求体设置状态码（如 `POST -d '500'` 会将后续 GET 请求状态码改为 500）


### 配置参数（Flags 与环境变量）

| 标志（Flag） | 环境变量              | 描述                                   |
|--------------|-----------------------|----------------------------------------|
| `cert`       | -                     | TLS 证书路径（启用 HTTPS 时需指定）    |
| `key`        | -                     | TLS 私钥路径（与 `cert` 配合使用）     |
| `cacert`     | -                     | CA 证书链路径（启用双向 TLS 时需指定） |
| `port`       | `WHOAMI_PORT_NUMBER`  | 服务监听端口（默认：`80`）             |
| `name`       | `WHOAMI_NAME`         | 服务名称（自定义标识）                 |
| `verbose`    | -                     | 启用详细日志输出                       |


## 部署方案示例

### Docker Run 示例

#### 1. 基础运行（随机端口映射）
```console
# 启动容器并随机映射端口
docker run -d -P --name whoami-test traefik/whoami

# 查看映射的端口（假设输出为 32769）
docker inspect --format '{{ .NetworkSettings.Ports }}' whoami-test
# 输出示例：map[80/tcp:[{0.0.0.0 32769}]]

# 访问服务获取信息
curl "http://0.0.0.0:32769"
# 输出示例：
# Hostname :  6e0030e67d6a
# IP :  127.0.0.1
# IP :  ::1
# IP :  172.17.0.27
# IP :  fe80::42:acff:fe11:1b
# GET / HTTP/1.1
# Host: 0.0.0.0:32769
# User-Agent: curl/7.35.0
# Accept: */*
```

#### 2. 指定端口与名称
```console
# 启动容器，指定端口 8080 和名称 "my-whoami"
docker run -d -p 8080:80 --name my-whoami traefik/whoami --port 80 --name "my-whoami-service"

# 或通过环境变量指定
docker run -d -p 8080:80 -e WHOAMI_PORT_NUMBER=80 -e WHOAMI_NAME="my-whoami-service" --name my-whoami traefik/whoami
```

#### 3. 启用 TLS
```console
# 挂载证书目录并启用 TLS
docker run -d -P -v ./certs:/certs --name whoami-tls traefik/whoami \
  --cert /certs/example.cert \
  --key /certs/example.key \
  --cacert /certs/ca.cert  # 双向 TLS 需指定 CA 证书
```


### Docker Compose 示例

```yaml
version: '3.9'

services:
  whoami:
    image: traefik/whoami
    container_name: whoami-service
    ports:
      - "8080:2001"  # 容器内端口 2001 映射到主机 8080
    command:
      - --port=2001  # 覆盖默认端口为 2001
      - --name=iamfoo  # 自定义服务名称
      - --verbose  # 启用详细日志
    environment:
      - WHOAMI_NAME=iamfoo  # 环境变量方式设置名称（与 command 中 --name 效果相同）
    restart: unless-stopped
```


## 示例操作

### 1. 测试健康检查状态码修改
```console
# 设置健康检查状态码为 500
curl -X POST -d '500' http://localhost:8080/health

# 验证健康检查响应（应返回 500 状态码）
curl -v http://localhost:8080/health
# 输出示例：
# *   Trying ::1:8080...
# * TCP_NODELAY set
# * Connected to localhost (::1) port 8080 (#0)
# > GET /health HTTP/1.1
# > Host: localhost:8080
# > User-Agent: curl/7.65.3
# > Accept: */*
# > 
# * Mark bundle as not supporting multiuse
# < HTTP/1.1 500 Internal Server Error
# < Date: Mon, 16 Sep 2019 22:52:40 GMT
# < Content-Length: 0
```

### 2. 生成指定大小响应数据
```console
# 生成 2KB 大小的响应数据
curl -v "http://localhost:8080/data?size=2&unit=KB"
# 响应体为 2048 字节的随机数据
```

### 3. WebSocket 回显测试
使用 wscat 工具测试 WebSocket 回显：
```console
# 安装 wscat（需 Node.js 环境）
npm install -g wscat

# 连接到 /echo 端点
wscat -c ws://localhost:8080/echo

# 输入任意消息，服务端会原样返回
> Hello whoami!
< Hello whoami!
