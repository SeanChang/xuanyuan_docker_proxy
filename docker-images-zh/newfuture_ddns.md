---
image: newfuture/ddns
description: "基于Alpine的DDNS服务，用于将域名动态更新到本机IP，支持dnspod、阿里DNS、CloudFlare、华为云、DNSCOM等服务商。"
source: https://xuanyuan.cloud/zh/r/newfuture/ddns
canonical: https://xuanyuan.cloud/zh/r/newfuture/ddns
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/newfuture/ddns" title="newfuture/ddns Docker 镜像中文简介、标签列表与拉取命令">newfuture/ddns — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/newfuture/ddns" title="newfuture/ddns Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/newfuture/ddns</a>

# [<img src="https://ddns.newfuture.cc/doc/img/ddns.svg" width="32px" height="32px"/>](https://ddns.newfuture.cc) DDNS

> 自动更新 DNS 解析到本机 IP 地址，支持 IPv4 和 IPv6，本地（内网）IP 和公网 IP。

[![Github Release](https://img.shields.io/github/v/release/NewFuture/DDNS?&logo=github&style=flatten)](https://github.com/NewFuture/DDNS/releases/latest)
[![PyPI](https://img.shields.io/pypi/v/ddns.svg?label=ddns&logo=pypi&style=flatten)](https://pypi.org/project/ddns/)
[![Docker Image Version](https://img.shields.io/docker/v/newfuture/ddns?label=newfuture/ddns&logo=docker&&sort=semver&style=flatten)](https://hub.docker.com/r/newfuture/ddns)
[![Build Status](https://github.com/NewFuture/DDNS/actions/workflows/build.yml/badge.svg?event=push)](https://github.com/NewFuture/DDNS/actions/workflows/build.yml)
[![Publish](https://github.com/NewFuture/DDNS/actions/workflows/publish.yml/badge.svg)](https://github.com/NewFuture/DDNS/actions/workflows/publish.yml)

## 镜像概述和主要用途

DDNS是一个轻量级Docker镜像，用于自动将DNS记录更新到本机当前IP地址。支持IPv4/IPv6、本地(内网)和公网IP，兼容多种DNS服务商，包括dnspod、阿里DNS、CloudFlare、华为云、DNSCOM等。该镜像设计用于在家庭网络、小型服务器或任何需要动态IP地址管理的场景中，保持域名解析与当前IP地址同步。

## 核心功能和特性

### 容器与平台特性
- Docker兼容和跨平台支持
- 基于Alpine Linux，镜像体积小（< 7MB）
- 支持多种硬件架构（amd64、arm64、arm/v7、arm/v6、ppc64le、s390x、386、riscv64）
- 内置定时任务，默认每5分钟自动更新一次
- 无需外部依赖，开箱即用
- 性能优化，资源占用低

### 配置与功能特性
- 支持IPv4和IPv6地址
- 可识别本地(内网)IP和公网IP
- 多配置方式：CLI命令行参数、JSON配置文件、环境变量
- 支持多域名同时更新
- 调试模式支持，便于问题排查

## 使用场景和适用范围

1. **家庭网络环境**：家庭宽带通常使用动态IP，通过DDNS保持域名解析到当前IP
2. **小型服务器**：没有固定公网IP的服务器环境
3. **开发测试环境**：需要从外部访问内网服务时
4. **物联网设备**：远程管理需要动态IP跟踪的物联网设备
5. **多IP环境**：需要同时管理IPv4和IPv6地址的场景

## 详细的使用方法和配置说明

### 镜像版本

DDNS镜像版本(Docker Tag)：
- `latest`: 最新稳定版(默认)
- `next`: 下一个测试版本
- `edge`: 最新开发版，不稳定(master分支)

```bash
# 拉取最新稳定版
docker pull newfuture/ddns:latest
# 或直接使用
docker pull newfuture/ddns
```

指定特定版本：
```bash
docker pull newfuture/ddns:v4.0.0
```

### 镜像源

镜像会同步发布到以下源：
- [Docker Hub](https://hub.docker.com/r/newfuture/ddns): `docker.io/newfuture/ddns`
- [GitHub Packages](https://github.com/newfuture/DDNS/pkgs/container/ddns): `ghcr.io/newfuture/ddns`

使用GitHub源：
```bash
docker pull ghcr.io/newfuture/ddns
```

### 运行方式

DDNS Docker镜像支持三种配置方式：命令行、环境变量和配置文件。

#### 使用命令行参数 (CLI)

当设置命令行参数时，容器将直接运行DDNS程序，不会启用定时任务。适合一次性运行或调试。

```bash
# 查看帮助
docker run --rm newfuture/ddns -h

# 基本使用示例
docker run --rm -v /local/config/:/ddns/ --network=host newfuture/ddns \
  --dns=dnspod \
  --id=12345 \
  --token=mytokenkey \
  --ipv4=www.example.com \
  --ipv4=ipv4.example.com \
  --index4 public \
  --index4 0

# 启用调试模式
docker run --rm -v /local/config/:/ddns/ --network=host newfuture/ddns \
  --dns=dnspod \
  --id=12345 \
  --token=mytokenkey \
  --ipv4=www.example.com \
  --debug
```

#### 使用环境变量 (ENV)

环境变量需加上DDNS前缀，推荐全大写。数组类型需要使用JSON格式或者单引号包裹。

```bash
docker run -d \
  -e DDNS_DNS=dnspod \
  -e DDNS_ID=12345 \
  -e DDNS_TOKEN=mytokenkey \
  -e DDNS_IPV4=example.com,www.example.com \
  -e DDNS_INDEX4=['public',0] \
  --network host \
  --name ddns \
  newfuture/ddns
```

使用环境变量文件：
```bash
docker run -d --env-file .env --network host --name ddns newfuture/ddns
```

支持的主要环境变量：

| 环境变量 | 描述 | 示例 |
|---------|------|------|
| DDNS_DNS | DNS服务商 | dnspod |
| DDNS_ID | API访问ID | 12345 |
| DDNS_TOKEN | API访问令牌 | mytokenkey |
| DDNS_IPV4 | IPv4域名列表 | example.com,www.example.com |
| DDNS_IPV6 | IPv6域名列表 | ipv6.example.com |
| DDNS_INDEX4 | IPv4地址获取方式 | ['public',0] |
| DDNS_INDEX6 | IPv6地址获取方式 | ['public',0] |
| DDNS_LOG_LEVEL | 日志级别 | WARNING |
| DDNS_PROXY | HTTP代理 | http://proxy:port |

#### 使用配置文件

Docker容器内的工作目录是`/ddns/`，默认配置文件路径为容器内的`/ddns/config.json`。

```bash
docker run -d \
  -v /host/config/:/ddns/ \
  --network host \
  --name ddns \
  newfuture/ddns
```

其中`/host/config/`是您本地包含`config.json`的目录。基本的config.json格式示例：

```json
{
  "dns": "dnspod",
  "id": "12345",
  "token": "mytokenkey",
  "ipv4": ["example.com", "www.example.com"],
  "index4": ["public", 0]
}
```

### 网络模式

#### host网络模式

使用`--network host`让容器直接使用宿主机网络，可正确获取宿主机IP地址。

```bash
docker run -d \
  -e DDNS_DNS=dnspod \
  -e DDNS_ID=12345 \
  -e DDNS_TOKEN=mytokenkey \
  -e DDNS_IPV4=example.com \
  --network host \
  --name ddns \
  newfuture/ddns
```

#### bridge网络模式（默认）

容器使用独立网络栈，需使用`public`模式获取公网IP：

```bash
docker run -d \
  -e DDNS_DNS=dnspod \
  -e DDNS_ID=12345 \
  -e DDNS_TOKEN=mytokenkey \
  -e DDNS_IPV4=example.com \
  -e DDNS_INDEX4=public \
  --name ddns \
  newfuture/ddns
```

### 高级配置

#### 多域名配置

环境变量方式配置多域名：

```bash
docker run -d \
  -e DDNS_DNS=dnspod \
  -e DDNS_ID=12345 \
  -e DDNS_TOKEN=mytokenkey \
  -e DDNS_IPV4='["example.com", "www.example.com", "sub.example.com"]' \
  --network host \
  --name ddns \
  newfuture/ddns
```

命令行参数方式配置多域名：

```bash
docker run --rm --network host newfuture/ddns \
  --dns dnspod \
  --id 12345 \
  --token mytokenkey \
  --ipv4 ipv4.example.com \
  --ipv4 www.example.com
```

#### 启用IPv6支持

1. 编辑`/etc/docker/daemon.json`：

```json
{
    "ipv6": true,
    "fixed-cidr-v6": "fd00::/80"
}
```

2. 重启Docker服务：

```bash
sudo systemctl restart docker
```

3. 启动容器时启用IPv6：

```bash
docker run -d \
  --network host \
  -e DDNS_DNS=dnspod \
  -e DDNS_ID=12345 \
  -e DDNS_TOKEN=mytokenkey \
  -e DDNS_IPV6=example.com \
  --name ddns \
  newfuture/ddns
```

### Docker Compose部署方案

#### 基本环境变量配置

创建`docker-compose.yml`文件：

```yaml
version: "3"
services:
    ddns:
        image: newfuture/ddns:latest
        restart: always
        network_mode: host
        environment:
            - DDNS_DNS=dnspod
            - DDNS_ID=12345
            - DDNS_TOKEN=mytokenkey
            - DDNS_IPV4=example.com,www.example.com
            - DDNS_INDEX4=['public','url:https://api.ipify.org']
            - DDNS_LOG_LEVEL=WARNING
```

#### 使用配置文件

```yaml
version: "3"
services:
    ddns:
        image: newfuture/ddns:latest
        restart: always
        network_mode: host
        volumes:
            - ./config:/ddns
```

运行Docker Compose：
```bash
docker-compose up -d
```

### 自定义镜像

如需在容器中添加其他工具或自定义环境，可基于官方镜像创建Dockerfile：

```dockerfile
FROM newfuture/ddns:latest

# 安装额外工具
RUN apk add --no-cache curl

# 添加自定义脚本
COPY custom-script.sh /bin/
RUN chmod +x /bin/custom-script.sh

# 可选：覆盖默认入口点
# ENTRYPOINT ["/bin/custom-script.sh"]
```

## 排障和常见问题

### 容器无法获取正确的IP地址

**问题**：DDNS无法正确获取主机IP

**解决方案**：
1. 使用`--network host`网络模式
2. 设置`-e DDNS_INDEX4=public`强制使用公网API获取IP

### 未收到定时任务更新

**问题**：容器运行但不自动更新DNS

**解决方案**：
1. 检查容器日志：`docker logs ddns`
2. 确认容器状态：`docker ps -a`
3. 手动执行更新：`docker exec ddns /bin/ddns`

### 容器启动后立即退出

**问题**：容器启动后立即退出

**解决方案**：
1. 以交互方式运行查看错误：`docker run -it --rm newfuture/ddns`
2. 检查环境变量或配置文件是否正确设置

### 网络连接问题

**问题**：容器无法连接到DNS服务商API

**解决方案**：
1. 检查网络连接：`docker exec ddns ping api.dnspod.cn`
2. 配置HTTP代理：`-e DDNS_PROXY=http://proxy:port`

## 更多资源

- [DDNS GitHub 主页](https://github.com/NewFuture/DDNS)
- [Docker Hub - newfuture/ddns](https://hub.docker.com/r/newfuture/ddns)
- [环境变量配置详情](https://ddns.newfuture.cc/doc/env.html)
- [JSON 配置文件详情](https://ddns.newfuture.cc/doc/json.html)
- [命令行参数详情](https://ddns.newfuture.cc/doc/cli.html)
