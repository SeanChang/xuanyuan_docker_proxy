---
image: eosphorosai/dbgpt-openai
description: "轻量级Docker镜像，仅包含DB-GPT中的代理模型，适用于CPU环境。"
source: https://xuanyuan.cloud/zh/r/eosphorosai/dbgpt-openai
canonical: https://xuanyuan.cloud/zh/r/eosphorosai/dbgpt-openai
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/eosphorosai/dbgpt-openai" title="eosphorosai/dbgpt-openai Docker 镜像中文简介、标签列表与拉取命令">eosphorosai/dbgpt-openai — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/eosphorosai/dbgpt-openai" title="eosphorosai/dbgpt-openai Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/eosphorosai/dbgpt-openai</a>

# DB-GPT Proxy (CPU) 镜像文档


## 一、镜像概述

DB-GPT Proxy (CPU) 镜像是一个轻量级Docker镜像，专为DB-GPT项目设计，仅包含代理模型组件，且完全基于CPU运行。该镜像专注于提供模型请求的代理、路由与管理功能，作为DB-GPT生态中的请求中转层，简化模型服务的接入与流量控制，适用于无GPU资源或资源受限的环境。


## 二、核心功能和特性

### 2.1 核心功能
- **请求代理与转发**：接收客户端请求并转发至后端模型服务，支持多模型服务的路由分发。
- **请求管理**：包含基础的请求验证、超时控制、负载均衡（简易版）功能。
- **轻量级中转**：专注于代理逻辑，无冗余组件，降低资源占用。

### 2.2 关键特性
- **轻量级设计**：镜像体积小，启动速度快，运行时资源占用低（内存、CPU）。
- **纯CPU支持**：无需GPU环境，可在普通CPU服务器或开发机上运行。
- **配置灵活**：通过环境变量动态调整代理行为（端口、后端地址、日志级别等）。
- **DB-GPT兼容**：与DB-GPT项目的模型服务组件无缝对接，遵循统一接口规范。


## 三、使用场景和适用范围

### 3.1 典型场景
- **开发与测试环境**：快速搭建DB-GPT代理服务，验证模型请求流程。
- **CPU资源受限场景**：部署在无GPU的服务器或边缘设备（如开发机、低配置云服务器）。
- **分布式部署**：作为DB-GPT分布式架构的前端代理节点，转发请求至后端多模型服务。
- **轻量级模型服务**：构建仅需代理功能的简化版DB-GPT服务（无需完整的知识库或UI组件）。

### 3.2 适用范围
- 对GPU资源无依赖的场景。
- 需要请求转发、负载均衡或流量控制的模型服务架构。
- DB-GPT项目的轻量化部署或组件化集成。


## 四、使用方法和配置说明

### 4.1 前置要求
- 已安装Docker Engine（20.10+版本）。
- 网络可访问后端模型服务（DB-GPT模型服务或兼容API的模型服务）。


### 4.2 获取镜像
假设镜像托管于Docker Hub（实际请替换为官方仓库地址）：
```bash
docker pull dbgpt/proxy-cpu:latest
```


### 4.3 快速启动（docker run）
通过`docker run`命令启动容器，需指定端口映射和后端模型服务地址：

```bash
docker run -d \
  --name dbgpt-proxy \
  -p 8000:8000 \  # 宿主机端口:容器内代理端口
  -e PROXY_PORT=8000 \  # 容器内代理服务端口（默认8000）
  -e BACKEND_MODEL_URL="http://model-service:8001" \  # 后端模型服务地址（必填）
  -e LOG_LEVEL="INFO" \  # 日志级别（默认INFO，可选：DEBUG/WARN/ERROR）
  -e REQUEST_TIMEOUT=30 \  # 请求超时时间（秒，默认30）
  dbgpt/proxy-cpu:latest
```


### 4.4 docker-compose配置示例
创建`docker-compose.yml`文件，定义代理服务及依赖（如后端模型服务，此处假设后端模型服务已独立部署）：

```yaml
version: '3.8'
services:
  dbgpt-proxy:
    image: dbgpt/proxy-cpu:latest
    container_name: dbgpt-proxy
    ports:
      - "8000:8000"  # 代理服务端口映射
    environment:
      - PROXY_PORT=8000
      - BACKEND_MODEL_URL="http://model-service:8001"  # 后端模型服务地址（需替换为实际地址）
      - LOG_LEVEL="INFO"
      - REQUEST_TIMEOUT=30
    restart: unless-stopped
    networks:
      - dbgpt-network  # 与后端模型服务共享网络（确保通信）

networks:
  dbgpt-network:
    driver: bridge
```

启动命令：`docker-compose up -d`


### 4.5 配置参数说明（环境变量）
| 环境变量名          | 描述                                  | 默认值    | 是否必填 |
|---------------------|---------------------------------------|-----------|----------|
| `PROXY_PORT`        | 代理服务监听端口（容器内）            | 8000      | 否       |
| `BACKEND_MODEL_URL` | 后端模型服务的HTTP地址（含端口）      | 无        | **是**   |
| `LOG_LEVEL`         | 日志输出级别（DEBUG/INFO/WARN/ERROR） | INFO      | 否       |
| `REQUEST_TIMEOUT`   | 后端请求超时时间（秒）                | 30        | 否       |
| `MAX_CONCURRENT`    | 最大并发请求数                        | 100       | 否       |
| `ALLOWED_IPS`       | 允许访问的客户端IP（逗号分隔，如"192.168.1.0/24"） | 所有IP    | 否       |


### 4.6 端口说明
- 容器内默认暴露端口：`8000`（代理服务端口，可通过`PROXY_PORT`调整）。
- 宿主机需映射此端口（如`-p 8000:8000`）以对外提供服务。


## 五、注意事项
- **无GPU支持**：镜像仅支持CPU运行，不可用于依赖GPU的代理加速场景。
- **后端依赖**：需确保`BACKEND_MODEL_URL`指向可用的DB-GPT模型服务（或兼容API的模型服务），否则代理无法正常转发请求。
- **网络连通性**：容器需与后端模型服务处于同一网络（或通过公网地址访问），建议使用Docker网络（如bridge、overlay）确保通信。
