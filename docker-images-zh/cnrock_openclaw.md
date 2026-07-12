---
image: cnrock/openclaw
description: "OpenClaw/Moltbot/Clawdbot 镜像，提供 root 权限支持，适用于多架构环境部署。"
source: https://xuanyuan.cloud/zh/r/cnrock/openclaw
canonical: https://xuanyuan.cloud/zh/r/cnrock/openclaw
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cnrock/openclaw" title="cnrock/openclaw Docker 镜像中文简介、标签列表与拉取命令">cnrock/openclaw 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenClaw/Moltbot/Clawdbot 镜像文档

## 镜像概述
OpenClaw/Moltbot/Clawdbot 是一款支持多架构的 Docker 镜像，内置 root 权限，旨在为跨架构环境下的应用部署提供灵活支持。该镜像适用于需要在不同硬件架构（如 x86、ARM 等）上运行的场景，同时通过 root 权限支持复杂的系统级操作需求。

## 核心功能与特性
- **多架构支持**：兼容多种硬件架构，可在不同架构的设备上无缝运行
- **root 权限**：内置 root 用户权限，支持需要系统级操作的应用场景
- **灵活性**：适用于各类需要跨架构部署的应用需求

## 使用场景
- 跨架构应用测试与部署
- 需要 root 权限的系统级应用运行
- 多架构环境下的服务编排与管理

## 使用方法

### 基本运行命令
```bash
docker run -it --rm docker.xuanyuan.run/openclaw/moltbot:latest
```

### 挂载数据卷（示例）
如需持久化数据或共享文件，可通过 `-v` 参数挂载本地目录：
```bash
docker run -it --rm -v /本地目录:/容器内目录 docker.xuanyuan.run/openclaw/moltbot:latest
```

### 环境变量配置
目前官方未提供特定环境变量说明，可根据实际应用需求自行设置：
```bash
docker run -it --rm -e KEY=VALUE docker.xuanyuan.run/openclaw/moltbot:latest
```

## 注意事项
- 由于镜像包含 root 权限，建议在安全可控的环境中使用
- 具体应用功能需参考对应软件（OpenClaw/Moltbot/Clawdbot）的官方文档
- 多架构支持需确保 Docker 环境已配置相应架构的支持（如通过 `docker buildx` 等工具）
