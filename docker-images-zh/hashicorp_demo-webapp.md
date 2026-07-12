---
image: hashicorp/demo-webapp
description: "Nomad 101培训课程中使用的示例Web应用。"
source: https://xuanyuan.cloud/zh/r/hashicorp/demo-webapp
canonical: https://xuanyuan.cloud/zh/r/hashicorp/demo-webapp
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hashicorp/demo-webapp" title="hashicorp/demo-webapp Docker 镜像中文简介、标签列表与拉取命令">hashicorp/demo-webapp 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Nomad 101 培训示例 Web 应用镜像文档


## 1. 镜像概述和主要用途

### 1.1 概述  
本镜像是 Nomad 101 培训课程配套的示例 Web 应用容器化封装，基于轻量级基础镜像构建，提供简化的 HTTP 服务能力，用于演示容器化应用在 Nomad 调度系统中的部署、运行及管理流程。

### 1.2 主要用途  
作为 Nomad 101 培训课程的核心实践工具，用于辅助学员理解容器化应用的生命周期管理，包括：  
- Nomad 任务定义与调度  
- 容器网络与端口映射  
- 环境变量配置注入  
- 健康检查与服务可用性验证  
- 基础资源（CPU/内存）限制  


## 2. 核心功能和特性  

### 2.1 核心功能  
- **基础 HTTP 服务**：提供 HTTP 接口，支持 GET 请求并返回预设文本或自定义消息。  
- **健康检查接口**：内置健康检查端点，用于验证应用运行状态。  
- **配置可定制化**：支持通过环境变量调整服务端口、响应消息等基础参数。  

### 2.2 特性  
- **轻量级**：基于 Alpine Linux 基础镜像，镜像体积小，启动速度快。  
- **兼容性**：适配 Nomad 基础调度功能，支持 task driver 为 Docker 的任务定义。  
- **可观测性**：默认输出结构化日志，便于调试和状态追踪。  


## 3. 使用场景和适用范围  

### 3.1 使用场景  
- **Nomad 101 培训课程实践**：作为学员操作练习的标准案例，用于演示 Nomad 任务创建、运行、停止、伸缩等基础操作。  
- **Nomad 基础功能验证**：验证 Nomad 集群的容器运行环境、网络配置、资源分配等基础能力。  

### 3.2 适用范围  
- **仅限培训/学习环境**：不具备生产级功能（如高可用、数据持久化、安全加固等），严禁用于生产系统。  
- **Nomad 入门学习**：适合 Nomad 新手理解容器调度流程，不适用于复杂业务场景。  


## 4. 使用方法和配置说明  

### 4.1 镜像获取  
本镜像需从 Nomad 101 培训课程指定的仓库获取（如课程内部 Registry 或本地构建）。假设镜像标签为 `nomad101-sample-webapp:latest`。


### 4.2 基础使用流程  

#### 4.2.1 本地 Docker 环境运行  
通过 `docker run` 命令启动容器，验证应用基础功能：  
```bash
# 基本运行（默认配置）
docker run -d --name nomad101-sample-webapp -p 8080:8080 docker.xuanyuan.run/nomad101-sample-webapp:latest

# 验证服务可用性（访问默认 HTTP 接口）
curl http://localhost:8080
# 预期输出：默认响应消息（如 "Nomad 101 Sample Web App Running"）
```

#### 4.2.2 自定义配置运行  
通过环境变量调整服务行为（详见 4.3 环境变量说明）：  
```bash
# 自定义端口、响应消息和健康检查路径
docker run -d --name nomad101-sample-webapp \
  -p 9000:9000 \
  -e PORT=9000 \
  -e MESSAGE="Hello from Nomad 101 Training" \
  -e HEALTHCHECK_PATH="/health" \
  docker.xuanyuan.run/nomad101-sample-webapp:latest

# 验证自定义配置
curl http://localhost:9000  # 输出自定义 MESSAGE
curl http://localhost:9000/health  # 验证健康检查接口（返回 HTTP 200）
```


### 4.3 环境变量说明  
| 环境变量名          | 描述                     | 默认值              | 示例值                          |  
|---------------------|--------------------------|---------------------|---------------------------------|  
| `PORT`              | 服务监听端口             | `8080`              | `9000`                          |  
| `MESSAGE`           | HTTP 根路径响应消息      | `"Nomad 101 Sample Web App Running"` | `"Custom Training Message"`     |  
| `HEALTHCHECK_PATH`  | 健康检查接口路径         | `"/health"`         | `"/status"`                     |  
| `LOG_LEVEL`         | 日志级别（debug/info/warn/error） | `"info"`         | `"debug"`                       |  


### 4.4 健康检查验证  
应用默认内置健康检查接口，可通过以下方式验证：  
```bash
# 检查容器健康状态（Docker 原生健康检查）
docker inspect --format='{{.State.Health.Status}}' nomad101-sample-webapp
# 预期输出：healthy

# 直接访问健康检查接口
curl -I http://localhost:8080/health  # 预期响应：HTTP/1.1 200 OK
```


## 5. Docker 部署示例  

### 5.1 基础 `docker run` 命令  
```bash
# 启动服务并映射宿主机端口 8080，设置自定义消息
docker run -d \
  --name nomad101-webapp-demo \
  -p 8080:8080 \
  -e MESSAGE="Nomad 101 Training - Docker Run Demo" \
  --health-cmd "curl -f http://localhost:8080/health || exit 1" \
  --health-interval docker.xuanyuan.run/5s \
  --health-timeout 2s \
  --health-retries 3 \
  nomad101-sample-webapp:latest
```

### 5.2 Docker Compose 配置（可选）  
适用于多容器协同演示场景（如配合 Nomad 客户端容器）：  
```yaml
# docker-compose.yml
version: '3.8'
services:
  nomad101-webapp:
    image: docker.xuanyuan.run/nomad101-sample-webapp:latest
    container_name: nomad101-webapp
    ports:
      - "8080:8080"
    environment:
      - PORT=8080
      - MESSAGE="Nomad 101 Compose Demo"
      - LOG_LEVEL=debug
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 5s
      timeout: 2s
      retries: 3
    restart: unless-stopped
```

启动命令：  
```bash
docker-compose up -d
```


## 6. 注意事项  
- **镜像来源**：需确保使用 Nomad 101 培训课程提供的官方镜像，避免非官方镜像导致功能异常。  
- **资源限制**：在 Nomad 环境中部署时，建议设置基础资源限制（如 `cpu=100m`, `memory=64Mi`），符合培训环境资源规划。  
- **清理说明**：培训结束后，需通过 `docker rm -f` 或 Nomad 任务销毁命令清理容器，避免占用环境资源。
