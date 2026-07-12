---
image: dyrnq/openclaw
description: "OpenClaw是一款可在自有设备运行的个人AI助手，支持通过WhatsApp、Telegram等多种通讯渠道交互，提供跨平台语音功能及实时Canvas控制，网关作为控制平面，核心为智能助手功能。"
source: https://xuanyuan.cloud/zh/r/dyrnq/openclaw
canonical: https://xuanyuan.cloud/zh/r/dyrnq/openclaw
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dyrnq/openclaw" title="dyrnq/openclaw Docker 镜像中文简介、标签列表与拉取命令">dyrnq/openclaw 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenClaw 镜像文档

## 镜像概述

OpenClaw 是一款可在个人设备上部署的个人AI助手，旨在通过用户已使用的通讯渠道提供智能交互服务。该镜像包含OpenClaw的控制平面（网关），核心功能为智能助手服务，支持多平台交互与控制。

## 核心功能与特性

### 多渠道支持
支持通过以下通讯渠道进行交互：
- WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、iMessage、BlueBubbles、IRC
- Microsoft Teams、Matrix、Feishu、LINE、Mattermost、Nextcloud Talk、Nostr
- Synology Chat、Tlon、Twitch、Zalo、Zalo Personal、WebChat

### 跨平台语音交互
- 在macOS、iOS、Android系统上支持语音输入与输出功能

### 实时Canvas控制
- 可渲染用户控制的实时Canvas界面

## 使用场景与适用范围

- **个人智能助手**：作为个人日常事务处理、信息查询的AI助手
- **多平台统一交互**：在多种通讯工具中统一使用AI助手功能
- **跨设备协作**：通过不同设备（手机、电脑）访问同一AI助手服务
- **语音交互场景**：需要语音输入输出的便捷交互场景

## 使用方法与配置说明

### 前提条件
- 支持Docker的个人设备（如电脑、服务器等）
- 对应通讯渠道的API访问权限或配置

### 获取镜像
```bash
docker pull ***-ghcr.xuanyuan.run/openclaw/openclaw
```

### 基本运行命令
```bash
docker run -d \
  --name openclaw \
  -p [端口映射] \
  -v [数据卷挂载路径]:/app/data \
  ***-ghcr.xuanyuan.run/openclaw/openclaw
```

### 配置说明
详细配置参数及环境变量请参考官方GitHub仓库文档：  
[https://github.com/openclaw/openclaw](https://github.com/openclaw/openclaw)

### docker-compose示例
```yaml
version: '3'
services:
  openclaw:
    image: ***-ghcr.xuanyuan.run/openclaw/openclaw
    container_name: openclaw
    ports:
      - "8080:8080"  # 根据实际需求调整端口
    volumes:
      - ./openclaw-data:/app/data
    restart: unless-stopped
```

## 参考链接
- 官方代码仓库：[https://github.com/openclaw/openclaw](https://github.com/openclaw/openclaw)
