---
image: dockercloud/server-proxy
description: "提供Docker Cloud Federation相关镜像，包括客户端交互、API转发、认证授权及集群注册功能，实现本地与远程Docker集群的安全连接和管理。"
source: https://xuanyuan.cloud/zh/r/dockercloud/server-proxy
canonical: https://xuanyuan.cloud/zh/r/dockercloud/server-proxy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dockercloud/server-proxy" title="dockercloud/server-proxy Docker 镜像中文简介、标签列表与拉取命令">dockercloud/server-proxy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Docker Cloud Federation

## 镜像概述

Docker Cloud Federation 提供一系列镜像集合，用于实现本地与远程Docker集群的连接、认证和管理。这些镜像协同工作，支持通过Docker ID进行身份验证，实现远程Docker集群的安全访问和操作。

## 镜像仓库

| 仓库 | 描述 |
|------|------|
| [dockercloud/client](client/) | 提供交互式shell，使用Docker ID凭据与远程Docker集群通信 |
| [dockercloud/client-proxy](client-proxy/) | 将本地Docker API调用转发至远程swarm集群，并在每个请求中注入Docker ID授权信息 |
| [dockercloud/server-proxy](server-proxy/) | 对传入的Docker API调用进行身份验证和授权，然后转发至本地Docker引擎 |
| [dockercloud/registration](registration/) | 将swarm集群注册到Docker Cloud，并启动server-proxy |

## 核心功能和特性

- **身份验证与授权**：基于Docker ID的身份验证机制，确保集群访问安全
- **API转发**：实现本地与远程Docker集群间的API请求转发
- **集群注册**：简化将现有swarm集群注册到Docker Cloud的流程
- **跨环境管理**：支持通过本地CLI工具管理远程Docker集群

## 使用场景

- 远程Docker swarm集群的管理和操作
- 跨云环境（AWS、Azure）的Docker集群统一管理
- 需要安全认证的多用户Docker集群访问控制

## 使用方法

### 远程swarm端

#### 自有集群注册

```bash
docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock docker.xuanyuan.run/dockercloud/registration
```

#### AWS环境部署（包含Docker Cloud注册，夜间构建）

[![Docker for AWS](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?#/stacks/new?stackName=D4A-Nightly&templateURL=https://docker-for-aws.s3.amazonaws.com/aws/cloud-nightly/latest.json)

#### Azure环境部署（包含Docker Cloud注册）

[![Docker for Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fdocker-for-azure.s3.amazonaws.com%2Fazure%2Fbeta%2Fazure-v1.12.1-cloud-beta5.json)

### 客户端

#### 客户端容器

```bash
docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock -e DOCKER_HOST docker.xuanyuan.run/dockercloud/client
```

该命令会交互式请求Docker ID凭据和要连接的远程swarm。登录后，将显示如下`export`命令：

```bash
# 现在可以通过执行以下命令开始使用swarm namespace/swarmname：
export DOCKER_HOST=tcp://0.0.0.0:32781
```

新的`DOCKER_HOST`环境变量指向客户端代理发布的端口，使本地CLI可直接与远程集群通信，客户端代理会自动注入适当的凭据。

## 更新方法

### 远程swarm端

执行以下命令更新：

```bash
docker service update --image dockercloud/server-proxy:latest dockercloud-server-proxy
```

### 客户端

1. 通过以下命令移除客户端代理容器：
   ```bash
   docker rm -f client_proxy_<namespace>_<swarmname>
   ```
2. 拉取最新客户端镜像：
   ```bash
   docker pull docker.xuanyuan.run/dockercloud/client
   ```
3. 创建新的客户端代理：
   ```bash
   docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock -e DOCKER_HOST docker.xuanyuan.run/dockercloud/client <namespace>/<swarmname>
   ```

## 已知问题

- 如果使用docker machine，请执行`unset DOCKER_TLS_VERIFY`确保环境变量中没有`DOCKER_TLS_VERIFY=1`，否则会收到以下TLS错误：
  ```
  $ docker ps
  An error occurred trying to connect: Get https://192.168.99.100:32769/v1.23/containers/json: tls: oversized record received with length 20527
