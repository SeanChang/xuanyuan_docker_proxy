---
image: itzg/mc-router
description: "根据请求的服务器地址，将我的世界客户端连接路由到后端服务器。"
source: https://xuanyuan.cloud/zh/r/itzg/mc-router
canonical: https://xuanyuan.cloud/zh/r/itzg/mc-router
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/itzg/mc-router" title="itzg/mc-router Docker 镜像中文简介、标签列表与拉取命令">itzg/mc-router 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# mc-router Docker镜像文档

[![GitHub issues](https://img.shields.io/github/issues/itzg/mc-router.svg)](https://github.com/itzg/mc-router/issues)
[![Docker Pulls](https://img.shields.io/docker/pulls/itzg/mc-router.svg)](https://cloud.docker.com/u/itzg/repository/docker/itzg/mc-router)
[![GitHub release](https://img.shields.io/github/release/itzg/mc-router.svg)](https://github.com/itzg/mc-router/releases)
[![CircleCI](https://circleci.com/gh/itzg/mc-router.svg?style=svg)](https://circleci.com/gh/itzg/mc-router)
[![Buy me a coffee](https://img.shields.io/badge/Donate-Buy%20me%20a%20coffee-orange.svg)](https://www.buymeacoffee.com/itzg)


## 镜像概述和主要用途

mc-router 是一款基于请求的服务器地址将 Minecraft 客户端连接路由至后端服务器的工具。通过动态配置路由规则，可实现多后端服务器的统一入口管理，简化多服务器部署场景下的客户端访问流程。


## 核心功能和特性

- **基于请求地址路由**：根据客户端请求的服务器地址（主机名）将连接转发至指定后端服务器
- **动态路由管理**：通过 REST API 实现路由规则的增、删、查操作，支持默认路由配置
- **多环境支持**：原生支持 Docker Compose 集成和 Kubernetes 环境，包括服务自动发现
- **轻量级部署**：仅需暴露路由服务端口，后端 Minecraft 服务器无需直接暴露至外部网络


## 使用场景和适用范围

- **多版本 Minecraft 服务器管理**：通过不同域名/地址区分 vanilla、forge、fabric 等不同版本服务器
- **动态后端扩展**：无需重启服务即可添加/移除后端服务器节点
- **Kubernetes 环境下的服务编排**：结合 K8s 服务自动发现，实现后端服务的动态扩缩容适配
- **统一入口管理**：对外仅暴露单个端口，简化防火墙配置和外部访问策略


## 使用方法和配置说明

### 命令行参数

| 参数                | 默认值       | 说明                                                                 |
|---------------------|--------------|----------------------------------------------------------------------|
| `--port`            | `25565`      | 监听 Minecraft 客户端连接的端口                                       |
| `--api-binding`     | 无           | 用于提供 API 请求的主机:端口绑定（如 `0.0.0.0:8080`）                 |
| `--mapping`         | 无           | 路由映射规则，格式为 `externalHostname=host:port`，支持多次指定       |
| `--in-kube-cluster` | 无（需显式指定） | 启用 Kubernetes 集群内服务自动发现（仅在 K8s 环境中使用）             |


### Docker 快速启动

#### 基本运行命令

```bash
docker run -d \
  --name mc-router \
  -p 25565:25565 \
  docker.xuanyuan.run/itzg/mc-router \
  --mapping=vanilla.example.com=vanilla-server:25565 \
  --mapping=forge.example.com=forge-server:25565 \
  --api-binding=0.0.0.0:8080
```

#### 参数说明
- `-p 25565:25565`：映射容器内监听端口至主机，接收客户端连接
- `--mapping`：配置静态路由规则，将客户端请求的 `vanilla.example.com` 转发至后端 `vanilla-server:25565`
- `--api-binding`：开放 API 接口，用于动态管理路由


### Docker Compose 配置

#### 架构说明

以下示例通过 Docker Compose 配置两个 Minecraft 后端服务（`vanilla` 和 `forge`）及路由服务（`router`）。后端服务通过内部网络通信，无需暴露外部端口；路由服务作为唯一入口，通过 `--mapping` 映射客户端请求的主机名至内部服务。

![Docker Compose 架构图](https://raw.githubusercontent.com/itzg/mc-router/master/docs/compose-diagram.png)

#### 示例配置文件

```yaml
version: '3.8'

services:
  router:
    image: docker.xuanyuan.run/itzg/mc-router
    ports:
      - "25565:25565"
    command: --mapping=vanilla.example.com=vanilla:25565 --mapping=forge.example.com=forge:25565
    depends_on:
      - vanilla
      - forge

  vanilla:
    image: docker.xuanyuan.run/itzg/minecraft-server
    environment:
      - EULA=TRUE
      - VERSION=1.20.1
    volumes:
      - vanilla-data:/data

  forge:
    image: docker.xuanyuan.run/itzg/minecraft-server
    environment:
      - EULA=TRUE
      - TYPE=FORGE
      - VERSION=1.20.1
    volumes:
      - forge-data:/data

volumes:
  vanilla-data:
  forge-data:
```

#### 测试配置

1. 在本地 `hosts` 文件中添加解析：
   ```
   127.0.0.1 vanilla.example.com
   127.0.0.1 forge.example.com
   ```
2. 启动服务：`docker-compose up -d`
3. 客户端分别通过 `vanilla.example.com` 和 `forge.example.com` 连接不同后端服务器


### Kubernetes 环境使用

#### 服务自动发现

在 Kubernetes 集群中部署时，通过 `--in-kube-cluster` 参数启用服务自动发现，mc-router 会监听带有以下注解的服务：

- `mc-router.itzg.me/externalServerName`: 客户端用于连接的外部主机名，服务的 ClusterIP 和目标端口将自动注册为路由后端
- `mc-router.itzg.me/defaultServer`: 配置默认路由，当无匹配路由时转发至该服务

**示例服务注解配置**：
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mc-forge
  annotations:
    "mc-router.itzg.me/externalServerName": "forge.example.com"
spec:
  selector:
    app: mc-forge
  ports:
    - port: 25565
      targetPort: 25565
```

#### 部署示例

通过以下命令部署包含自动发现功能的 mc-router 及示例后端服务：

```bash
kubectl apply -f https://raw.githubusercontent.com/itzg/mc-router/master/docs/k8s-example-auto.yaml
```

**部署架构**：
![Kubernetes 部署架构图](https://github.com/itzg/mc-router/blob/master/docs/example-deployment-auto.drawio.png?raw=true)

**注意事项**：
- 部署依赖 `mc-stable` 和 `mc-snapshot` 两个持久卷声明（PVC）
- 若使用 NodePort 暴露服务，需确保节点端口范围包含 25565（可通过修改 kube-apiserver 配置 `--service-node-port-range=25000-32767` 实现）


## REST API

### 路由规则管理

#### `GET /routes`
- **功能**：获取当前所有配置的路由规则
- **响应**：JSON 格式的路由列表，示例：
  ```json
  [
    {"serverAddress": "vanilla.example.com", "backend": "vanilla:25565"},
    {"serverAddress": "forge.example.com", "backend": "forge:25565"}
  ]
  ```

#### `POST /routes`
- **功能**：添加新路由规则
- **请求体**：JSON 格式，指定客户端请求地址和后端服务
  ```json
  {
    "serverAddress": "CLIENT REQUESTED SERVER ADDRESS",  // 客户端请求的服务器地址（如 "test.example.com"）
    "backend": "HOST:PORT"  // 后端服务地址（如 "test-server:25565"）
  }
  ```

#### `POST /defaultRoute`
- **功能**：配置默认路由（当无匹配规则时使用）
- **请求体**：JSON 格式，指定默认后端服务
  ```json
  {
    "backend": "HOST:PORT"  // 默认后端服务地址（如 "fallback-server:25565"）
  }
  ```

#### `DELETE /routes/{serverAddress}`
- **功能**：删除指定服务器地址的路由规则
- **路径参数**：`serverAddress` - 需删除的客户端请求地址（如 "test.example.com"）
- **响应**：204 No Content（成功）或 404 Not Found（路由不存在）
