---
image: jitsi/jvb
description: "用于Jitsi Meet的Jitsi Videobridge镜像，提供视频桥接服务以支持视频会议中的媒体流传输。"
source: https://xuanyuan.cloud/zh/r/jitsi/jvb
canonical: https://xuanyuan.cloud/zh/r/jitsi/jvb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jitsi/jvb" title="jitsi/jvb Docker 镜像中文简介、标签列表与拉取命令">jitsi/jvb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Jitsi Meet - Jitsi Videobridge 容器镜像


## 镜像概述和主要用途  
本镜像为 Jitsi Meet 视频会议系统的核心组件 **Jitsi Videobridge (JVB)** 容器化版本。Jitsi Meet 是一款开源、可自托管的实时视频会议解决方案，而 JVB 作为其媒体服务器，负责在多方会议中高效路由视频流，实现低延迟、高质量的音视频传输。该镜像旨在简化 Jitsi Meet 部署流程，支持通过 Docker 快速搭建可扩展的视频会议服务。


## 核心功能和特性  
Jitsi Videobridge 作为 Jitsi Meet 的核心媒体组件，具备以下关键功能：  
- **SFU 架构**：采用选择性转发单元（Selective Forwarding Unit）技术，仅向参会者转发其所需的媒体流，降低带宽占用。  
- **WebRTC 兼容**：基于 WebRTC 标准，支持浏览器原生接入，无需安装额外客户端。  
- **低延迟传输**：优化媒体路由逻辑，确保实时音视频交互延迟低于 300ms。  
- **多用户支持**：单实例可稳定支持数百人同时参会（具体取决于服务器资源）。  
- **加密通信**：默认启用 TLS/DTLS 加密，保障音视频流和信令传输安全。  
- **水平扩展**：支持多 JVB 实例集群部署，通过负载均衡提升并发会议容量。  


## 使用场景和适用范围  
### 适用场景  
- 企业内部/跨组织视频会议、远程协作；  
- 在线教育（小班课、直播授课）；  
- 社区/开源项目远程会议；  
- 虚拟活动（Webinar、线上研讨会）。  

### 适用范围  
- 需要**自托管**视频会议解决方案的组织或团队；  
- 对数据隐私、定制化需求较高的场景；  
- 具备基础服务器运维能力的开发者或运维人员。  


## 使用方法和配置说明  
### 前提条件  
- 已安装 Docker 和 Docker Compose（推荐使用 Docker Compose 管理多服务依赖）；  
- 服务器需开放必要端口（如 80/443 TCP、10000 UDP 等，具体取决于配置）；  
- 建议配置域名及 SSL 证书（用于 HTTPS 访问）。  


### 基本部署流程  
Jitsi Meet 部署通常涉及多个组件（如 Web 前端、XMPP 服务器 Prosody、JVB 等），官方推荐通过 Docker Compose 统一管理。以下为简化步骤：  

#### 1. 获取部署资源  
克隆官方 Docker 部署仓库：  
```bash
git clone https://github.com/jitsi/docker-jitsi-meet.git
cd docker-jitsi-meet
```

#### 2. 配置环境变量  
复制环境变量模板并修改关键参数：  
```bash
cp env.example .env
```  
编辑 `.env` 文件，配置核心参数（详见「配置参数与环境变量」部分）。  

#### 3. 生成必要密码  
运行脚本自动生成服务间认证密码：  
```bash
./gen-passwords.sh
```

#### 4. 启动服务  
```bash
docker-compose up -d
```  

服务启动后，通过 `PUBLIC_URL` 配置的地址（如 `https://meet.example.com`）访问会议系统。  


### Docker 部署方案示例  
以下为 `docker-compose.yml` 核心片段（完整配置请参考官方仓库），展示 JVB 服务的基本定义：  

```yaml
version: '3'

services:
  jvb:
    image: docker.xuanyuan.run/jitsi/jvb:latest  # 当前镜像
    restart: unless-stopped
    ports:
      - "10000:10000/udp"  # JVB 媒体传输端口（UDP）
    environment:
      - TZ=${TZ}
      - PUBLIC_URL=${PUBLIC_URL}
      - JVB_AUTH_USER=${JVB_AUTH_USER}
      - JVB_AUTH_PASSWORD=${JVB_AUTH_PASSWORD}
      - JVB_BREWERY_MUC=${JVB_BREWERY_MUC}
      - JVB_PORT=${JVB_PORT}
      - JVB_MUC_NICKNAME=${JVB_MUC_NICKNAME}
      - JVB_STUN_SERVERS=${JVB_STUN_SERVERS}
      - JICOFO_AUTH_USER=${JICOFO_AUTH_USER}
      - JICOFO_AUTH_PASSWORD=${JICOFO_AUTH_PASSWORD}
      - JVB_ENABLE_APIS=${JVB_ENABLE_APIS}
    volumes:
      - ${CONFIG}/jvb:/config
```  


## 配置参数与环境变量  
JVB 行为通过环境变量配置，关键参数如下（完整列表见 [官方手册](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker)）：  

| 环境变量                | 描述                                                                 | 默认值                          |
|-------------------------|----------------------------------------------------------------------|---------------------------------|
| `TZ`                    | 容器时区                                                             | `UTC`                           |
| `PUBLIC_URL`            | 会议系统对外访问 URL（需包含协议，如 `https://meet.example.com`）    | 无（必填）                      |
| `JVB_PORT`              | JVB 媒体传输端口（UDP）                                              | `10000`                         |
| `JVB_AUTH_USER`         | JVB 与 Prosody 通信的认证用户名                                      | `jvb`                           |
| `JVB_AUTH_PASSWORD`     | JVB 与 Prosody 通信的认证密码（由 `gen-passwords.sh` 自动生成）      | 随机字符串                      |
| `JVB_STUN_SERVERS`      | STUN 服务器列表（用于 NAT 穿透）                                     | `stun:stun.l.google.com:19302`  |
| `JVB_ENABLE_APIS`       | 启用的 JVB API（如 `rest,colibri`，用于监控和管理）                  | `""`（默认禁用）                |
| `JVB_MAX_MEMORY`        | JVB 进程最大内存限制                                                 | `512M`                          |  


## 补充信息：JaaS（Jitsi as a Service）  
若无需自托管，可考虑 8x8 提供的 **Jitsi as a Service (JaaS)**：一款企业级视频会议平台，基于 Jitsi 技术栈，提供全球分布式部署、SLA 保障和品牌定制能力。详情见 [JaaS 官网](https://jaas.8x8.vc/)。  


**参考链接**  
- 项目仓库：[github.com/jitsi/docker-jitsi-meet](https://github.com/jitsi/docker-jitsi-meet)  
- 官方手册：[Jitsi Docker 部署指南](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker)
