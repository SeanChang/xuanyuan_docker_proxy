---
image: n8nio/runners
description: "n8nio/runners 是 n8nio 官方推出的任务运行器 Docker 镜像，专为开源工作流自动化平台 n8n 的代码执行场景设计，核心功能是承接 n8n 中 Code Node 发送的用户自定义 JavaScript 或 Python 代码任务，通过独立容器实现代码执行的隔离与资源管控。该镜像需作为 sidecar 容器与 n8n 主实例协同部署，目前（截至 2025 年 9 月）处于 Beta 测试阶段。"
source: https://xuanyuan.cloud/zh/r/n8nio/runners
canonical: https://xuanyuan.cloud/zh/r/n8nio/runners
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/n8nio/runners" title="n8nio/runners Docker 镜像中文简介、标签列表与拉取命令">n8nio/runners — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/n8nio/runners" title="n8nio/runners Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/n8nio/runners</a>

# n8n 任务运行器 Docker 镜像使用指南

## 快速参考

### 维护方
由 n8nio 官方团队维护（n8n 开源项目官方）。

### 帮助渠道
可通过 n8n 官方文档（Task Runners 专题）、GitHub 仓库 Issues 板块或 n8n 社区论坛获取支持。

### 支持的标签及对应 Dockerfile 链接
- Beta 版本标签：latest（最新测试版）、beta（明确标识测试版）
- Dockerfile 可通过 n8n 官方代码仓库或 Docker Hub 镜像页面查看

### 问题反馈地址
n8n GitHub Issues：https://github.com/n8n-io/n8n/issues

### 支持的架构
主要支持 amd64 架构，兼容主流 Linux 容器环境。

### 镜像详情
包含元数据、传输大小等信息，可访问 Docker Hub 镜像页面查看。

### 镜像更新
随 n8n 主版本迭代同步更新，Beta 阶段更新频率依赖测试进度。

### 本文档来源
基于 n8n 官方文档、Docker Hub 描述及镜像特性整理，详情参考 n8n 任务运行器官方指南。


## 什么是 n8nio/runners

n8nio/runners 是 n8n 任务运行体系的核心执行组件，与 n8n 主实例、Code Node 共同构成请求-代理-执行闭环：

1. **角色定位**：作为外部任务执行器，通过隔离环境运行用户代码，避免代码异常影响 n8n 主服务稳定性
2. **核心组件**：内置 JavaScript 运行器、Python 运行器、任务启动器（Task Runner Launcher），以及完整的 JS/Python 运行时与依赖库
3. **运行模式**：仅支持外部模式，需由 Kubernetes 或 Docker Compose 等编排工具作为 sidecar 部署，与 n8n 主实例通过共享密钥通信
4. **核心价值**：实现代码执行的资源隔离、并发控制与生命周期管理，适配 n8n 分布式部署场景（如队列模式下的多 Worker 协同）


## 如何使用本镜像

### 启动 sidecar 实例（基础配置）

需与 n8n 主实例共享网络，通过环境变量配置通信参数：

```bash
docker run --name n8n-runners \
  --network n8n-network \
  -e N8N_RUNNERS_ENABLED=true \
  -e N8N_RUNNERS_MODE=external \
  -e N8N_RUNNERS_AUTH_TOKEN=<随机安全密钥> \
  -e N8N_RUNNERS_TASK_BROKER_URI=n8n-main:5679 \
  -d n8nio/runners:latest
```

- --network：加入与 n8n 主实例相同的网络，确保通信可达
- N8N_RUNNERS_AUTH_TOKEN：与 n8n 主实例一致的共享密钥，用于身份验证
- N8N_RUNNERS_TASK_BROKER_URI：n8n 主实例中任务代理的地址与端口

### 与 n8n 主实例集成（Docker Compose）

典型分布式部署示例，包含 n8n 主服务、PostgreSQL 数据库及 runners 侧车：

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: n8n
      POSTGRES_PASSWORD: n8n-pass
      POSTGRES_DB: n8n
    volumes:
      - postgres-data:/var/lib/postgresql/data

  n8n-main:
    image: n8nio/n8n:latest
    ports:
      - 5678:5678
    environment:
      DB_TYPE: postgresdb
      DB_POSTGRESDB_HOST: postgres
      DB_POSTGRESDB_PASSWORD: n8n-pass
      N8N_RUNNERS_ENABLED: true
      N8N_RUNNERS_MODE: external
      N8N_RUNNERS_AUTH_TOKEN: my-secure-token-123
      N8N_RUNNERS_BROKER_LISTEN_ADDRESS: 0.0.0.0
    volumes:
      - n8n-data:/home/node/.n8n
    depends_on:
      - postgres

  n8n-runners:
    image: n8nio/runners:latest
    environment:
      N8N_RUNNERS_AUTH_TOKEN: my-secure-token-123
      N8N_RUNNERS_TASK_BROKER_URI: n8n-main:5679
      N8N_RUNNERS_MAX_CONCURRENCY: 5
      NODE_OPTIONS: --max-old-space-size=2048
    depends_on:
      - n8n-main

volumes:
  postgres-data:
  n8n-data:
```

启动命令：docker compose up -d


## 容器 shell 访问与日志查看

### 进入容器终端

```bash
docker exec -it n8n-runners sh
```

### 查看任务执行日志（排查代码运行异常）

```bash
docker logs n8n-runners
```


## 配置说明

核心配置通过环境变量实现，无需额外配置文件，关键参数如下：

- **N8N_RUNNERS_AUTH_TOKEN**：必选，与 n8n 主实例一致的共享密钥，用于安全通信
- **N8N_RUNNERS_TASK_BROKER_URI**：必选，n8n 主实例中任务代理的地址（格式：主机名:端口）
- **N8N_RUNNERS_MAX_CONCURRENCY**：可选，默认 5，最大并发执行的代码任务数
- **NODE_OPTIONS**：可选，Node.js 运行参数，如 --max-old-space-size=2048 限制内存使用
- **GENERIC_TIMEZONE**：可选，与 n8n 主实例一致的时区（如 Asia/Shanghai），确保时间同步


## 数据持久化

该镜像无本地状态存储，无需持久化数据，但需确保：
- n8n 主实例的 /home/node/.n8n 目录已通过数据卷持久化（存储工作流与凭证）
- 代码执行的输入/输出数据由 n8n 主实例管理，runners 仅负责临时执行


## 注意事项

### 版本兼容性
Beta 阶段需与 n8n 主实例版本严格一致，避免 API 不兼容导致任务失败。

### 权限控制
容器内以非 root 用户运行，无需额外调整权限，但需确保与 n8n 主实例的网络通信未被防火墙阻断。

### 资源限制
建议通过 Docker --memory 或 Kubernetes 资源配额限制内存使用，避免代码执行耗尽宿主机资源。

### 健康检查
内置健康检查端点 GET /healthz（端口 5680），可配置编排工具监控容器状态。


## 许可信息

镜像基于 n8n 的 Fair-Code Sustainable Use License 许可协议，允许非商业自托管部署，商业使用需遵循官方许可条款，详情参考 n8n 许可说明 https://n8n.io/license/
