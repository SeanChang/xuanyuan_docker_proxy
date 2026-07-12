---
image: portainer/portainer-updater
description: "用于自动更新Portainer软件的工具"
source: https://xuanyuan.cloud/zh/r/portainer/portainer-updater
canonical: https://xuanyuan.cloud/zh/r/portainer/portainer-updater
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/portainer/portainer-updater" title="portainer/portainer-updater Docker 镜像中文简介、标签列表与拉取命令">portainer/portainer-updater 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Portainer Updater 镜像文档


## 镜像概述和主要用途  
Portainer Updater 是一款用于自动更新 Portainer 软件的工具镜像。它能够监控 Portainer 版本更新，自动检测新版本发布，下载并更新 Portainer 容器，同时确保数据卷和配置文件的安全性。该工具旨在简化 Portainer 的维护流程，适用于需要保持 Portainer 最新状态以获取安全补丁、功能更新的个人或企业环境。


## 核心功能和特性  
- **自动版本检测**：定期检查 Portainer 官方仓库（GitHub 或 Docker Hub）的最新版本，支持 Community Edition (CE) 和 Business Edition (BE)。  
- **容器安全更新**：更新过程中保留 Portainer 数据卷（如 `/data`），确保配置和数据不丢失。  
- **灵活的更新策略**：支持按时间间隔自动检查更新，可配置仅更新主版本、次版本或补丁版本。  
- **多版本兼容**：适配 Portainer v2.x 及以上版本，支持 Docker 和 Kubernetes 环境中的 Portainer 实例。  
- **轻量低耗**：基于 Alpine 基础镜像，资源占用低，可长期后台运行。  
- **日志与通知**：提供详细更新日志，支持通过环境变量配置外部通知（如 Webhook）。  


## 使用场景和适用范围  
- **个人 Docker 环境**：自动维护 Portainer 最新版，无需手动检查和更新。  
- **企业运维流程**：集成到自动化运维管道（CI/CD）中，统一管理多节点 Portainer 实例的更新。  
- **安全合规场景**：确保 Portainer 及时获取安全补丁，符合企业安全策略。  
- **多实例管理**：通过配置文件批量管理多个 Portainer 容器的更新（需结合自定义配置）。  


## 详细使用方法和配置说明  


### 前置条件  
1. 目标主机已安装 Docker 或 Docker Compose。  
2. Portainer 容器已运行（推荐使用官方镜像 `portainer/portainer-ce` 或 `portainer/portainer-be`）。  
3. 确保 Portainer Updater 容器可访问 Docker 守护进程（挂载 `/var/run/docker.sock`）。  


### 部署方式  


#### 1. Docker Run 命令  
直接通过 `docker run` 启动 Portainer Updater 容器，示例如下：  
```bash
docker run -d \
  --name portainer-updater \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \  # 必需，用于操作 Docker 容器
  -e PORTAINER_CONTAINER_NAME="portainer" \       # 目标 Portainer 容器名称（必填）
  -e CHECK_INTERVAL="24h" \                       # 检查更新间隔（默认 24h）
  -e UPDATE_STRATEGY="all" \                      # 更新策略（all/main/minor/patch）
  portainer/portainer-updater:latest
```


#### 2. Docker Compose 配置  
创建 `docker-compose.yml` 文件，示例如下：  
```yaml
version: '3.8'
services:
  portainer-updater:
    image: docker.xuanyuan.run/portainer/portainer-updater:latest
    container_name: portainer-updater
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - PORTAINER_CONTAINER_NAME=portainer  # 目标 Portainer 容器名称
      - CHECK_INTERVAL=12h                  # 每 12 小时检查一次更新
      - UPDATE_ONLY_SECURE=true             # 仅更新安全补丁版本
      - LOG_LEVEL=info                      # 日志级别（debug/info/warn/error）
      - NOTIFY_WEBHOOK=https://your-webhook-url  # 更新完成后触发的 Webhook
```


### 环境变量配置  
Portainer Updater 通过环境变量控制行为，支持以下参数：  

| 环境变量名                | 描述                                                                 | 默认值          | 是否必填 |
|---------------------------|----------------------------------------------------------------------|-----------------|----------|
| `PORTAINER_CONTAINER_NAME` | 目标 Portainer 容器名称（需与实际运行容器名称一致）                  | `portainer`     | 否       |
| `PORTAINER_IMAGE`         | Portainer 镜像名称（CE: `portainer/portainer-ce`；BE: `portainer/portainer-be`） | `portainer/portainer-ce` | 否       |
| `CHECK_INTERVAL`          | 检查更新的时间间隔（支持 `h`/`m`/`s`，如 `24h`、`30m`）             | `24h`           | 否       |
| `UPDATE_STRATEGY`         | 更新策略：`all`（所有版本）、`major`（主版本）、`minor`（次版本）、`patch`（补丁） | `all`           | 否       |
| `UPDATE_ONLY_SECURE`      | 是否仅更新安全相关版本（依赖 Portainer 官方安全公告）                | `false`         | 否       |
| `SKIP_CONFIRM`            | 是否跳过更新确认（直接执行更新）                                    | `true`          | 否       |
| `LOG_LEVEL`               | 日志级别：`debug`/`info`/`warn`/`error`                             | `info`          | 否       |
| `NOTIFY_WEBHOOK`          | 更新成功/失败后触发的 Webhook URL（支持 JSON  payload）              | 无              | 否       |
| `DOCKER_HOST`             | Docker 守护进程地址（默认本地 `unix:///var/run/docker.sock`）        | `unix:///var/run/docker.sock` | 否       |


### 更新流程说明  
1. **版本检测**：按 `CHECK_INTERVAL` 定期请求 Portainer 官方仓库（Docker Hub 或 GitHub Release），获取最新版本号。  
2. **版本对比**：根据 `UPDATE_STRATEGY` 判断是否需要更新（如主版本 `2.x` → `3.x`，或补丁版本 `2.18.1` → `2.18.2`）。  
3. **容器更新**：  
   - 停止当前 Portainer 容器（保留数据卷）。  
   - 拉取最新 Portainer 镜像。  
   - 以原参数（端口、数据卷、网络等）重新启动容器。  
4. **结果通知**：更新成功/失败后，通过 `NOTIFY_WEBHOOK` 发送通知（如状态码、日志摘要）。  


### 注意事项  
1. **数据备份**：首次运行前建议手动备份 Portainer 数据卷（默认路径 `/var/lib/docker/volumes/portainer_data`）。  
2. **网络权限**：确保容器可访问外网（用于拉取镜像和检测版本）。  
3. **容器名称匹配**：`PORTAINER_CONTAINER_NAME` 必须与实际运行的 Portainer 容器名称一致，否则无法识别目标容器。  
4. **版本兼容性**：仅支持 Portainer v2.x 及以上版本，v1.x 需手动迁移后使用。  


## 示例配置  


### 示例 1：基础自动更新（默认配置）  
```bash
docker run -d \
  --name portainer-updater \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker.xuanyuan.run/portainer/portainer-updater:latest
```


### 示例 2：指定更新策略和通知  
```yaml
# docker-compose.yml
version: '3.8'
services:
  portainer-updater:
    image: docker.xuanyuan.run/portainer/portainer-updater:latest
    container_name: portainer-updater
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - PORTAINER_CONTAINER_NAME=my-portainer  # 假设 Portainer 容器名为 "my-portainer"
      - PORTAINER_IMAGE=portainer/portainer-be  # Business Edition
      - CHECK_INTERVAL=12h  # 每 12 小时检查一次
      - UPDATE_STRATEGY=minor  # 仅更新次版本（如 2.18.x → 2.19.x）
      - NOTIFY_WEBHOOK=https://hooks.slack.com/services/XXX  # Slack 通知
      - LOG_LEVEL=debug  # 输出详细日志用于调试
```


### 示例 3：仅更新安全补丁  
```bash
docker run -d \
  --name portainer-updater-secure \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e UPDATE_ONLY_SECURE=true \
  -e CHECK_INTERVAL=6h \  # 每 6 小时检查安全更新
  portainer/portainer-updater:latest
