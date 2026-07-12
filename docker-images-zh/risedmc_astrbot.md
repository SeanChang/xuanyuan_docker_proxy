---
image: risedmc/astrbot
description: "开源一站式Agentic个人和群聊助手，支持QQ、Telegram、企业微信等主流即时通讯软件部署，内置轻量化ChatUI，可快速构建个人AI伙伴、智能客服、自动化助手及企业知识库，重启容器自动拉取最新项目框架。"
source: https://xuanyuan.cloud/zh/r/risedmc/astrbot
canonical: https://xuanyuan.cloud/zh/r/risedmc/astrbot
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/risedmc/astrbot" title="risedmc/astrbot Docker 镜像中文简介、标签列表与拉取命令">risedmc/astrbot 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# AstrBot Docker镜像文档

## 镜像概述

AstrBot是一个开源的一站式Agentic个人和群聊助手，可在QQ、Telegram、企业微信、飞书、钉钉、Slack等数十款主流即时通讯软件上部署。此外，它内置类似OpenWebUI的轻量化ChatUI，为个人、开发者和团队打造可靠、可扩展的对话式智能基础设施。无论是个人AI伙伴、智能客服、自动化助手，还是企业知识库，AstrBot都能在即时通讯软件平台的工作流中快速构建AI应用。

- [官网](https://astrbot.app/)
- [博客](https://blog.astrbot.app/)
- [文档](https://github.com/AstrBotDevs/AstrBot/blob/master/README_zh.md)
- [GitHub](https://github.com/AstrBotDevs/AstrBot)

## 核心功能和特性

- **多平台支持**：兼容QQ、Telegram、企业微信、飞书、钉钉、Slack等数十款主流即时通讯软件
- **轻量化ChatUI**：内置类似OpenWebUI的界面，提供直观的交互体验
- **开源可扩展**：基于开源项目构建，支持自定义扩展和二次开发
- **自动更新**：重启容器会自动拉取最新项目框架，保持功能同步
- **灵活部署**：支持Docker容器化部署，简化安装和维护流程

## 使用场景

- **个人AI伙伴**：作为私人智能助手，提供信息查询、任务提醒等服务
- **团队智能客服**：集成到企业IM工具，实现客户咨询的自动化响应
- **自动化助手**：通过自定义规则实现工作流程自动化，提升协作效率
- **企业知识库**：构建基于IM平台的内部知识检索系统，方便团队信息共享

## 使用方法和配置说明

### 1. 运行容器

#### Docker CLI

```powershell
docker run -d --name docker.xuanyuan.run/astrbot -p 6185:6185 -v .\data:/AstrBot/data astrbot
```

#### docker-compose

```yaml
services:
  astrbot:
    image: docker.xuanyuan.run/risedmc/astrbot:latest
    container_name: astrbot
    ports:
      - "6185:6185"
    volumes:
      - /path/to/astrbot/data:/AstrBot/data
    environment:
      - TZ=Asia/Shanghai
    restart: unless-stopped
```

#### docker-compose（napcat集成）

```yaml
services:
  napcat:
    environment:
      - NAPCAT_UID=${NAPCAT_UID:-1000}
      - NAPCAT_GID=${NAPCAT_GID:-1000}
      - MODE=astrbot
    ports:
      - 6099:6099
    container_name: napcat
    restart: always
    image: docker.xuanyuan.run/mlikiowa/napcat-docker:latest
    volumes:
      - /mnt/nas/docker/astrbot/data:/AstrBot/data
      - /mnt/nas/docker/napcat/config:/app/napcat/config
      - /mnt/nas/docker/napcat/ntqq:/app/.config/QQ
    networks:
      - astrbot_network
  astrbot:
    image: docker.xuanyuan.run/risedmc/astrbot:latest
    container_name: astrbot
    ports:
      - 6185:6185 # 必选，AstrBot WebUI端口
      - 6199:6199 # 可选，QQ个人号WebSocket端口
    volumes:
      - /mnt/nas/docker/astrbot/data:/AstrBot/data
    environment:
      - TZ=Asia/Shanghai
    networks:
      - astrbot_network
    restart: unless-stopped
networks:
  astrbot_network:
    driver: bridge
```

### 2. 数据管理

- **数据存储位置**：容器内的 `/AstrBot/data` 目录，用于存储配置文件、聊天记录、知识库等数据
- **持久化方法**：通过 `-v` 参数将本地目录挂载到容器的 `/AstrBot/data` 目录，确保数据持久化保存

### 3. 端口配置

- **默认端口**：6185（WebUI端口，必选）
- **可选端口**：6199（QQ个人号WebSocket端口，根据需要映射）
- **端口映射**：使用 `-p 主机端口:容器端口` 参数将容器端口映射到主机，如 `-p 6185:6185`
