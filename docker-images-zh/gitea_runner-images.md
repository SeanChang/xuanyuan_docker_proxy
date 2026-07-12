---
image: gitea/runner-images
description: "act_runner用于运行工作流的官方镜像。"
source: https://xuanyuan.cloud/zh/r/gitea/runner-images
canonical: https://xuanyuan.cloud/zh/r/gitea/runner-images
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gitea/runner-images" title="gitea/runner-images Docker 镜像中文简介、标签列表与拉取命令">gitea/runner-images 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Gitea Runner Images 镜像文档

## 概述
Gitea Runner Images 是 Gitea act_runner 的官方镜像，专为运行工作流设计，提供一致、可靠的执行环境，确保工作流在不同环境中具有可重复性和稳定性。该镜像由 Gitea 官方维护，与 act_runner 工具深度集成，是 Gitea Actions 生态的核心组成部分。

## 核心功能与特性

### 官方支持与兼容性
- 与 Gitea act_runner 完全兼容，确保工作流执行逻辑与官方规范一致
- 持续同步 Gitea Actions 功能更新，支持最新的工作流语法和特性

### 预配置运行环境
- 内置常用 CI/CD 工具链，包括但不限于 Git、Docker、构建工具（如 Maven、Gradle、npm）、测试框架等
- 提供多种基础系统版本（如 Ubuntu、Alpine 等），适配不同场景需求

### 高效与轻量
- 镜像体积优化，减少资源占用和拉取时间
- 支持多架构（如 amd64、arm64），适配不同硬件环境

### 安全与稳定
- 基于官方基础镜像构建，定期更新以修复安全漏洞
- 严格的版本控制，确保环境一致性和可追溯性

## 使用场景

### Gitea CI/CD 工作流执行
作为 act_runner 的运行环境，用于执行 Gitea 仓库中的 Actions 工作流，实现代码构建、测试、打包、部署等自动化流程。

### 本地工作流调试
开发者可在本地使用该镜像模拟 Gitea Actions 环境，调试工作流配置，减少线上环境问题。

### 企业级自动化部署
在企业内部 CI/CD 系统中作为标准执行环境，确保跨团队、跨项目的工作流执行一致性。

## 使用方法

### 前提条件
- 已安装 Docker 环境（Docker Engine 20.10+ 或兼容版本）
- 已获取 Gitea 实例的访问 URL 和 act_runner 注册令牌（token）

### 基本使用（Docker Run）
通过 `docker run` 命令直接启动镜像，示例如下：

```bash
docker run -d \
  --name gitea-runner \
  -e GITEA_INSTANCE_URL="https://your-gitea-instance.com" \
  -e RUNNER_TOKEN="your-runner-token" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker.xuanyuan.run/gitea/runner-images:latest
```

#### 参数说明：
- `-e GITEA_INSTANCE_URL`: Gitea 实例的 URL 地址（必填）
- `-e RUNNER_TOKEN`: act_runner 注册令牌（从 Gitea 实例获取，必填）
- `-v /var/run/docker.sock:/var/run/docker.sock`: 挂载 Docker 守护进程套接字（如需在工作流中使用 Docker 命令时必填）

### Docker Compose 配置
创建 `docker-compose.yml` 文件，配置如下：

```yaml
version: '3.8'

services:
  gitea-runner:
    image: docker.xuanyuan.run/gitea/runner-images:latest
    container_name: gitea-runner
    restart: always
    environment:
      - GITEA_INSTANCE_URL=https://your-gitea-instance.com
      - RUNNER_TOKEN=your-runner-token
      - RUNNER_NAME=my-runner # 可选，自定义 runner 名称
      - RUNNER_LABELS=docker,linux # 可选，自定义 runner 标签
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - runner-data:/data # 可选，持久化 runner 配置数据

volumes:
  runner-data:
```

启动命令：
```bash
docker-compose up -d
```

### 环境变量配置
| 环境变量名               | 描述                                   | 是否必填 | 默认值           |
|--------------------------|----------------------------------------|----------|------------------|
| `GITEA_INSTANCE_URL`     | Gitea 实例的基础 URL                   | 是       | -                |
| `RUNNER_TOKEN`           | 用于注册 runner 的令牌                 | 是       | -                |
| `RUNNER_NAME`            | Runner 显示名称                        | 否       | 容器 ID 前 8 位  |
| `RUNNER_LABELS`          | Runner 标签，逗号分隔                  | 否       | `default`        |
| `RUNNER_MAX_JOBS`        | 最大并发任务数                         | 否       | 1                |
| `LOG_LEVEL`              | 日志级别（debug, info, warn, error）   | 否       | `info`           |

### 版本选择
镜像标签遵循 `{基础系统}-{版本}` 格式，例如：
- `ubuntu-22.04-latest`: 基于 Ubuntu 22.04 的最新版本
- `alpine-3.18-latest`: 基于 Alpine 3.18 的最新版本

可通过 [Gitea 容器镜像仓库](https://gitea.com/gitea/runner-images) 获取完整标签列表。

## 注意事项
- 确保 Gitea 实例 URL 和令牌正确，否则 runner 无法注册
- 挂载 `docker.sock` 时需注意权限控制，避免安全风险
- 生产环境建议使用固定版本标签（如 `ubuntu-22.04-v1.0.0`）而非 `latest`，确保环境稳定性
- 如需自定义工具或依赖，可基于该镜像构建派生镜像，或通过工作流步骤动态安装
