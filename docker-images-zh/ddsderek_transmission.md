---
image: ddsderek/transmission
description: "优化的Transmission BitTorrent客户端Docker镜像，用于便捷部署和运行BT下载服务。"
source: https://xuanyuan.cloud/zh/r/ddsderek/transmission
canonical: https://xuanyuan.cloud/zh/r/ddsderek/transmission
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ddsderek/transmission" title="ddsderek/transmission Docker 镜像中文简介、标签列表与拉取命令">ddsderek/transmission 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# transmission Docker镜像文档


## 镜像概述与主要用途

transmission Docker镜像是一个改进版的Transmission BitTorrent客户端容器化方案。Transmission是一款轻量级、跨平台的开源BitTorrent客户端，支持下载和分享文件。本镜像优化了配置灵活性、Web UI多样性及部署便捷性，适用于需要通过Docker快速搭建BT下载服务的场景。


## 核心功能与特性

- **多Web UI支持**：内置多种Web管理界面，包括Transmission Web Control、Transmissionic、Combustion等，可按需切换  
- **用户认证保护**：支持自定义用户名和密码，增强Web界面访问安全性  
- **灵活的权限控制**：通过PUID/PGID指定运行用户ID和组ID，避免文件权限冲突  
- **自定义路径配置**：可指定下载目录、监视目录及配置文件存储路径，适应不同存储需求  
- **端口与网络优化**：支持自定义BT传输端口（TCP/UDP）及RPC端口，适配网络环境  
- **时区设置**：支持通过TZ环境变量配置时区，确保日志和任务时间准确  
- **配置持久化**：配置文件、日志等数据存储在独立卷中，容器重启后配置不丢失  


## 使用场景与适用范围

- **个人文件下载**：家庭用户搭建私有BT下载服务，管理影视、软件等文件下载  
- **家庭媒体中心**：配合NAS或媒体服务器，自动下载并整理媒体文件  
- **私有种子分享**：小型团队或个人通过私有种子分享文件，控制访问权限  
- **服务器环境部署**：在VPS或服务器上轻量部署，资源占用低，适合长期运行  


## 部署与使用方法

### 环境要求

- Docker Engine 19.03+  
- Docker Compose（可选，用于编排部署）  
- 宿主机需开放对应端口（默认9091、51413）  


### 部署方式

#### 1. Docker Compose部署

创建`docker-compose.yml`文件，配置如下：

```yaml
version: "2.1"
services:
  transmission:
    image: docker.xuanyuan.run/ddsderek/transmission:latest
    container_name: transmission
    environment:
      - PUID=1000                # 运行用户ID（建议设为当前用户ID）
      - PGID=1000                # 运行组ID（建议设为当前用户组ID）
      - UMASK=022                # 文件权限掩码（默认022，控制新文件权限）
      - TZ=Asia/Shanghai         # 时区（如Asia/Shanghai、Europe/London等）
      - USER=admin               # Web界面登录用户名（可选，不设置则无需认证）
      - PASS=password            # Web界面登录密码（需与USER同时设置）
      - TRANSMISSION_WEB_HOME=/trguing-cn/  # Web UI路径（可选，详见参数说明）
    volumes:
      - /path/to/data:/config    # 配置文件及日志存储路径（需替换为实际路径）
      - /path/to/downloads:/downloads  # 下载文件存储路径（需替换为实际路径）
      - /path/to/watch:/watch    # 监视目录（放置.torrent文件自动开始下载，需替换为实际路径）
    ports:
      - 9091:9091                # Web界面及RPC端口
      - 51413:51413              # BT传输TCP端口
      - 51413:51413/udp          # BT传输UDP端口
    restart: unless-stopped      # 容器重启策略（异常退出后自动重启）
```

启动容器：  
```bash
docker-compose up -d
```


#### 2. Docker CLI部署

直接通过命令行启动容器：

```bash
docker run -d \
  --name=transmission \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=022 \
  -e TZ=Asia/Shanghai \
  -e USER=admin \
  -e PASS=password \
  -e TRANSMISSION_WEB_HOME=/trguing-cn/ \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v /path/to/data:/config \          # 替换为实际配置文件路径
  -v /path/to/downloads:/downloads \  # 替换为实际下载路径
  -v /path/to/watch:/watch \          # 替换为实际监视目录路径
  --restart unless-stopped \
  ddsderek/transmission:latest
```


## 配置参数详解

### 端口映射（-p）

| 参数          | 功能说明                     |
|---------------|------------------------------|
| `-p 9091:9091` | Web管理界面及RPC服务端口     |
| `-p 51413:51413` | BT传输TCP端口（种子连接）   |
| `-p 51413:51413/udp` | BT传输UDP端口（DHT网络） |


### 环境变量（-e）

| 参数                          | 功能说明                                                                 |
|-------------------------------|--------------------------------------------------------------------------|
| `PUID=1000`                   | 运行容器的用户ID，用于控制文件权限（建议设为当前用户ID，可通过`id`命令查看） |
| `PGID=1000`                   | 运行容器的组ID，与PUID配合确保文件访问权限                                 |
| `UMASK=022`                   | 文件权限掩码，控制新创建文件的默认权限（022表示文件权限为644，目录为755）   |
| `TZ=Asia/Shanghai`            | 容器时区，影响日志时间、任务调度等（如`Europe/London`、`America/New_York`）|
| `USER=username`               | Web界面登录用户名（可选，不设置则无需认证）                               |
| `PASS=password`               | Web界面登录密码（需与USER同时设置，否则认证不生效）                       |
| `WHITELIST=iplist`            | RPC访问IP白名单（逗号分隔IP列表，如`192.168.1.0/24,127.0.0.1`）            |
| `PRCPORT=rpcport`             | Web RPC服务端口（默认9091，如需自定义需同步修改端口映射）                  |
| `PEERPORT=peerport`           | BT传输端口（TCP/UDP，默认51413，需同步修改端口映射）                      |
| `HOST_WHITELIST=dnsname list` | RPC访问DNS名称白名单（逗号分隔域名列表，如`example.com,localhost`）        |
| `TRANSMISSION_WEB_HOME=path`  | Web UI界面路径，可选值：<br>`/transmission-web-control/`、`/transmissionic/`、`/combustion/`、`/kettu/`、`/flood/`、`/trguing/`、`/trguing-cn/`（中文界面） |
| `DOWNLOAD_DIR=/downloads`     | 下载文件存储目录（默认`/downloads`，修改时需同步更新卷挂载路径`-v`）       |


### 卷挂载（-v）

| 参数              | 功能说明                                                                 |
|-------------------|--------------------------------------------------------------------------|
| `-v /config`      | 存储Transmission配置文件（settings.json）、日志及状态数据，确保配置持久化 |
| `-v /downloads`   | 下载文件存储路径（需与`DOWNLOAD_DIR`环境变量一致，默认`/downloads`）      |
| `-v /watch`       | 监视目录：放入此目录的`.torrent`文件将自动开始下载                         |
