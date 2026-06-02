---
image: docker/desktop-stats
description: "Docker Desktop云助手镜像，用于辅助Docker Desktop与云服务的集成配置及管理，简化云环境下的容器操作流程。"
source: https://xuanyuan.cloud/zh/r/docker/desktop-stats
canonical: https://xuanyuan.cloud/zh/r/docker/desktop-stats
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [docker/desktop-stats — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/docker/desktop-stats)

含镜像标签、拉取命令、部署文档与相关推荐。

[docker/desktop-stats Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/docker/desktop-stats)

# Docker Desktop Cloud Helper Image 文档


## 1. 镜像概述和主要用途

Docker Desktop Cloud Helper Image 是一款专为 Docker Desktop 设计的辅助工具镜像，主要用于简化 Docker Cloud 引擎内容的探索与分析流程。该镜像作为 Docker Desktop 生态的一部分，提供轻量级交互能力，帮助用户便捷地查看、检索和分析 Docker Cloud 引擎中的各类资源信息（如容器、镜像、网络配置等），无需手动配置复杂的 API 交互逻辑。


## 2. 核心功能和特性

### 核心功能
- 与 Docker Cloud 引擎建立安全连接，支持内容探索与信息检索；
- 解析并展示 Docker Cloud 引擎中的核心资源元数据（容器状态、镜像详情、网络拓扑等）；
- 提供结构化输出格式（如 JSON、表格），便于后续分析或集成到自动化流程。

### 主要特性
- **轻量级设计**：镜像体积小巧，启动快速，资源占用低；
- **无缝集成**：与 Docker Desktop 原生兼容，无需额外依赖配置；
- **简化流程**：内置预设交互逻辑，减少手动编写 API 请求的复杂度；
- **安全认证**：支持 Docker Cloud 标准认证机制，确保连接安全性。


## 3. 使用场景和适用范围

### 适用场景
- **开发者调试**：在本地开发环境中，通过 Docker Desktop 快速查看 Docker Cloud 引擎中的运行容器、镜像版本等信息，辅助排查部署或运行时问题；
- **管理员运维**：Docker Cloud 引擎管理员需定期检查引擎资源占用、配置状态时，简化信息收集流程；
- **教学与演示**：向团队展示 Docker Cloud 引擎结构或资源关系时，提供直观的内容探索工具。

### 适用范围
- 已安装 Docker Desktop 的用户（Windows/macOS/Linux 平台）；
- 需要与 Docker Cloud 引擎（v2.0+）交互的场景；
- 具备 Docker Cloud 引擎访问权限（如 API 密钥、访问令牌）的用户。


## 4. 使用方法和配置说明

### 4.1 基本使用方法
该镜像需通过 Docker 命令行或 Docker Compose 启动，启动前需配置 Docker Cloud 引擎连接参数（如引擎 URL、认证信息）。运行后，可通过命令行交互或输出文件获取探索结果。


### 4.2 环境变量配置
启动镜像时，需通过环境变量指定 Docker Cloud 引擎连接及运行参数，常用变量说明如下：

| 环境变量名                | 描述                                                                 | 是否必填 | 默认值       |
|---------------------------|----------------------------------------------------------------------|----------|--------------|
| `DOCKER_CLOUD_ENGINE_URL` | Docker Cloud 引擎的 API 访问地址（如 `https://cloud-engine.example.com:2376`） | 是       | -            |
| `DOCKER_CLOUD_API_KEY`    | 用于认证的 Docker Cloud API 密钥（需具备引擎内容读取权限）            | 是       | -            |
| `EXPLORATION_SCOPE`       | 探索范围，可选值：`all`（全部资源）、`containers`（仅容器）、`images`（仅镜像） | 否       | `all`        |
| `OUTPUT_FORMAT`           | 结果输出格式，可选值：`json`、`table`、`text`                         | 否       | `table`      |
| `LOG_LEVEL`               | 日志级别，可选值：`debug`、`info`、`warn`、`error`                   | 否       | `info`       |
| `REQUEST_TIMEOUT`         | API 请求超时时间（秒）                                               | 否       | `30`         |


### 4.3 挂载卷配置
如需持久化探索结果或共享 Docker Desktop 配置，可通过 `-v` 参数挂载本地目录至容器内指定路径：

- **结果持久化**：挂载本地目录至 `/app/results`，容器将探索结果输出至该目录（文件名为 `exploration-<timestamp>.<format>`）；
- **配置共享**：挂载 Docker Desktop 配置目录（如 `~/.docker/config.json`）至 `/root/.docker/config.json`，复用本地 Docker 认证信息。


## 5. 部署方案示例

### 5.1 使用 `docker run` 命令部署
以下示例通过 `docker run` 启动镜像，探索 Docker Cloud 引擎全部资源，并以 JSON 格式输出结果至本地 `./results` 目录：

```bash
docker run -it --rm \
  -e DOCKER_CLOUD_ENGINE_URL="https://cloud-engine.example.com:2376" \
  -e DOCKER_CLOUD_API_KEY="your-api-key-here" \
  -e EXPLORATION_SCOPE="all" \
  -e OUTPUT_FORMAT="json" \
  -v "$(pwd)/results:/app/results" \
  docker/desktop-cloud-helper:latest
```

**参数说明**：
- `-it`：交互式运行，支持实时查看日志输出；
- `--rm`：容器退出后自动删除；
- `-v "$(pwd)/results:/app/results"`：挂载本地 `results` 目录至容器内，保存输出结果。


### 5.2 使用 `docker-compose` 部署
创建 `docker-compose.yml` 文件，配置如下：

```yaml
version: '3.8'
services:
  cloud-helper:
    image: docker/desktop-cloud-helper:latest
    environment:
      - DOCKER_CLOUD_ENGINE_URL=https://cloud-engine.example.com:2376
      - DOCKER_CLOUD_API_KEY=your-api-key-here
      - EXPLORATION_SCOPE=containers
      - OUTPUT_FORMAT=table
      - LOG_LEVEL=debug
    volumes:
      - ./results:/app/results
      - ~/.docker/config.json:/root/.docker/config.json:ro  # 只读挂载本地 Docker 配置
    restart: "no"  # 仅运行一次
```

启动命令：
```bash
docker-compose up
```


## 6. 注意事项
- 确保 `DOCKER_CLOUD_API_KEY` 具备足够权限（至少包含 `read` 权限），避免因权限不足导致探索失败；
- 若 Docker Cloud 引擎启用 TLS 认证，需确保本地 Docker Desktop 已配置对应 CA 证书（可通过挂载证书文件至容器 `/etc/ssl/certs` 目录实现）；
- 对于大规模引擎（资源数量 >1000），建议设置 `REQUEST_TIMEOUT` 为 `60` 秒以上，避免请求超时。
