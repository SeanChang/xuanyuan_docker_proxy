---
image: tenstartups/isy-smartthings-server
description: "这是一个ISY994i设备服务器镜像，用于桥接Insteon设备与SmartThings Hub，实现智能家居生态的互联互通及设备控制。"
source: https://xuanyuan.cloud/zh/r/tenstartups/isy-smartthings-server
canonical: https://xuanyuan.cloud/zh/r/tenstartups/isy-smartthings-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tenstartups/isy-smartthings-server" title="tenstartups/isy-smartthings-server Docker 镜像中文简介、标签列表与拉取命令">tenstartups/isy-smartthings-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Insteon Server

## 镜像概述
该镜像提供ISY994i设备服务器功能，旨在连接Insteon设备与SmartThings Hub，解决不同智能家居生态的兼容性问题，帮助用户统一管理和控制跨品牌智能设备。

## 核心功能
1. 建立ISY994i与SmartThings Hub的通信链路
2. 同步Insteon设备状态至SmartThings平台
3. 支持通过SmartThings远程控制Insteon设备
4. 提供稳定的设备数据传输与交互能力

## 使用场景
1. 将Insteon品牌设备接入SmartThings智能家居生态
2. 统一管理多品牌智能设备，配置跨平台自动化场景
3. 提升智能家居系统的兼容性与易用性

## 配置说明
需根据实际环境配置以下参数（具体以官方文档为准）：
- ISY994i设备的IP地址及认证信息
- SmartThings Hub的接入凭证与通信端口
- 设备同步频率与数据传输协议设置

## 部署示例
### Docker Run命令
```bash
docker run -d \
  --name isy-smartthings-server \
  -p 8080:8080 \
  -e ISY_IP="你的ISY设备IP" \
  -e SMARTTHINGS_TOKEN="你的SmartThings凭证" \
  docker.xuanyuan.run/tenstartups/isy-smartthings-server
```

### Docker Compose示例
```yaml
version: '3'
services:
  isy-smartthings:
    image: tenstartups/isy-smartthings-server
    container_name: isy-smartthings-server
    ports:
      - "8080:8080"
    environment:
      - ISY_IP=你的ISY设备IP
      - SMARTTHINGS_TOKEN=你的SmartThings凭证
    restart: unless-stopped
