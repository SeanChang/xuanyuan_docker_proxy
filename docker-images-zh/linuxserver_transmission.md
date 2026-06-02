---
image: linuxserver/transmission
description: "这是由LinuxServer.io提供的Transmission容器，其中Transmission是一款轻量级开源BitTorrent客户端，支持高效文件传输，兼容BitTorrent、DHT等多种协议；该容器采用Docker技术构建，便于快速部署、轻松管理和灵活扩展，适用于个人用户或服务器环境，LinuxServer.io作为专注于开源容器开发的团队，确保其具备良好的安全性与稳定性。"
source: https://xuanyuan.cloud/zh/r/linuxserver/transmission
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[linuxserver/transmission](https://xuanyuan.cloud/zh/r/linuxserver/transmission)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/transmission 容器介绍


## 关于LinuxServer.io团队

LinuxServer.io团队专注于提供高质量Docker容器，其容器具有以下特点：  
- 应用定期及时更新  
- 简单的用户权限映射（通过PGID、PUID设置）  
- 基于s6 overlay的自定义基础镜像  
- 每周基础系统更新，通过共享层减少存储空间、 downtime和带宽占用  
- 常规安全更新  

团队社区支持渠道：  
- [博客]([])：容器使用指南、教程及观点分享  
- []()：实时社区交流与技术支持  
- [论坛]([])：社区讨论与问题反馈  
- [GitHub]([])：源代码仓库  
- [Open Collective]([])：支持团队的捐赠渠道  


## Transmission简介

[Transmission]([]) 是一款简洁高效的BitTorrent客户端，具备以下核心功能：  
- 加密传输、Web管理界面、节点交换  
- 支持磁力链接、DHT、µTP协议  
- UPnP/NAT-PMP端口转发、Web种子、监控目录  
-  tracker编辑、全局/单任务速度限制等  


## 支持的架构

容器通过Docker manifest实现多平台支持，拉取 `lscr.io/linuxserver/transmission:latest` 即可自动匹配对应架构。也可通过标签指定具体架构：  

| 架构       | 支持状态 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅        | amd64-\<版本标签\>     |  
| arm64      | ✅        | arm64v8-\<版本标签\>   |  


## 应用设置

### 基础配置  
- Web管理界面默认端口：9091  
- `settings.json` 文件位于 `/config` 目录，**修改前需停止容器**，否则变更无法保存。  


### WebUI安全认证  
通过 `USER` 和 `PASS` 环境变量设置用户名和密码，**不要直接编辑 `settings.json`**，否则可能导致容器无法正常停止。  


### 自动更新阻止列表  
1. 需在 `settings.json` 中启用 `"blocklist-enabled": true`，并配置有效的 `blocklist-url`。  
2. 容器会在每天凌晨3点（服务器本地时间）自动下载、解压阻止列表并重启Transmission服务。  


### 白名单设置  
- `WHITELIST`：逗号分隔的IP白名单，启用 `rpc-whitelist`；留空则禁用。  
- `HOST_WHITELIST`：逗号分隔的域名白名单，启用 `rpc-host-whitelist`；留空则禁用。  


### 自定义BT端口  
通过 `PEERPORT` 环境变量指定BT监听端口（TCP/UDP），需与Docker映射端口一致，禁用随机端口选择。  


### 高级运行模式  
- **只读文件系统**：支持以只读模式运行，详见 [文档]([])。  
- **非root用户**：支持非root权限运行，详见 [文档]([])。  


## 使用方法

### 前置说明  
除非标记为“可选”，否则以下参数为必填项。  


### docker-compose（推荐）  
```yaml
---
services:
  transmission:
    image: lscr.io/linuxserver/transmission:latest
    container_name: transmission
    environment:
      - PUID=1000               # 用户ID（详见下方说明）
      - PGID=1000               # 组ID（详见下方说明）
      - TZ=Etc/UTC              # 时区（如 Asia/Shanghai）
      - TRANSMISSION_WEB_HOME=  # 可选，自定义WebUI路径
      - USER=                   # 可选，WebUI用户名
      - PASS=                   # 可选，WebUI密码
      - WHITELIST=              # 可选，IP白名单（逗号分隔）
      - PEERPORT=               # 可选，BT端口
      - HOST_WHITELIST=         # 可选，域名白名单（逗号分隔）
    volumes:
      - /path/to/transmission/data:/config   # 配置文件目录
      - /path/to/downloads:/downloads        # 可选，下载目录
      - /path/to/watch/folder:/watch         # 可选，监控目录（自动加载torrent文件）
    ports:
      - 9091:9091               # WebUI端口
      - 51413:51413             # BT TCP端口
      - 51413:51413/udp         # BT UDP端口
    restart: unless-stopped
```  


### docker cli  
```bash
docker run -d \
  --name=transmission \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e TRANSMISSION_WEB_HOME= `# 可选` \
  -e USER= `# 可选` \
  -e PASS= `# 可选` \
  -e WHITELIST= `# 可选` \
  -e PEERPORT= `# 可选` \
  -e HOST_WHITELIST= `# 可选` \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v /path/to/transmission/data:/config \
  -v /path/to/downloads:/downloads `# 可选` \
  -v /path/to/watch/folder:/watch `# 可选` \
  --restart unless-stopped \
  lscr.io/linuxserver/transmission:latest
```  


## 参数说明  

| 参数                          | 功能描述                                                                 |  
|-------------------------------|--------------------------------------------------------------------------|  
| `-p 9091:9091`                | Web管理界面端口                                                          |  
| `-p 51413:51413`              | BT传输TCP端口                                                           |  
| `-p 51413:51413/udp`          | BT传输UDP端口                                                           |  
| `-e PUID=1000`                | 用户ID，解决权限问题（通过 `id your_user` 命令获取）                     |  
| `-e PGID=1000`                | 组ID，同上                                                              |  
| `-e TZ=Etc/UTC`               | 时区，如 `Asia/Shanghai`                                                |  
| `-e TRANSMISSION_WEB_HOME=`   | 自定义WebUI路径                                                         |  
| `-e USER=`                    | WebUI用户名                                                             |  
| `-e PASS=`                    | WebUI密码                                                               |  
| `-e WHITELIST=`               | IP白名单（逗号分隔），对应 `rpc-whitelist` 设置                         |  
| `-e PEERPORT=`                | BT端口，对应 `peer-port` 设置                                           |  
| `-e HOST_WHITELIST=`          | 域名白名单（逗号分隔），对应 `rpc-host-whitelist` 设置                  |  
| `-v /config`                  | 配置文件和日志存储目录                                                  |  
| `-v /downloads`               | 下载文件存储目录（可选）                                                |  
| `-v /watch`                   | 监控目录（自动加载torrent文件，可选）                                   |  
| `--read-only=true`            | 只读文件系统模式（需配合上述文档配置）                                   |  
| `--user=1000:1000`            | 非root用户运行（需配合上述文档配置）                                     |  


## 补充配置  

### 环境变量从文件读取  
通过 `FILE__` 前缀从文件加载环境变量，例如：  
```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable  # 从文件内容设置 MYVAR
```  


### Umask设置  
通过 `-e UMASK=022` 调整服务文件权限掩码（Umask值为权限减法，非直接设置权限）。  


### 用户/组ID说明  
使用 `id your_user` 命令获取当前用户的UID和GID，例如：  
```bash
id your_user  # 输出示例：uid=1000(your_user) gid=1000(your_user)
```  
确保宿主机目录权限与PUID/PGID匹配，避免权限问题。  


## Docker Mods  
容器支持通过 [Docker Mods]([]) 扩展功能，可查看：  
- [Transmission专用Mods]([])  
- [通用Mods]([])  


## 支持与维护  

### 容器管理命令  
- **进入容器终端**：  
  ```bash
  docker exec -it transmission /bin/bash
  ```  
- **实时查看日志**：  
  ```bash
  docker logs -f transmission
  ```  
- **查看容器版本**：  
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' transmission
  ```  
- **查看镜像版本**：  
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/transmission:latest
  ```  


### 更新方法  

#### 通过docker-compose  
- 更新镜像：  
  ```bash
  docker-compose pull transmission  # 单个镜像
  # 或 docker-compose pull  # 所有镜像
  ```  
- 重启容器：  
  ```bash
  docker-compose up -d transmission  # 单个容器
  # 或 docker-compose up -d  # 所有容器
  ```  
- 清理旧镜像：  
  ```bash
  docker image prune
  ```  


#### 通过docker run  
- 更新镜像：  
  ```bash
  docker pull lscr.io/linuxserver/transmission:latest
  ```  
- 重启容器（保留配置）：  
  ```bash
  docker stop transmission && docker rm transmission
  # 重新执行docker run命令（配置会保留在宿主机的/config目录）
  ```  


### 更新通知  
推荐使用 [Diun]([]) 监控镜像更新，不建议使用自动更新工具。  


## 本地构建  
如需自定义镜像，可本地构建：  
```bash
git clone [] docker-transmission
docker build --no-cache --pull -t lscr.io/linuxserver/transmission:latest .
```  
跨架构构建（如x86_64构建arm64）：  
```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset  # 注册qemu
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/transmission:arm64v8-latest .  # 指定架构Dockerfile
```  


## 版本历史  
- **29.11.24**：修复PEERPORT参数设置  
- **07.10.23**：从LinuxServer仓库安装unrar  
- **10.08.23**：升级unrar至6.2.10  
- **10.06.23**：升级unrar至6.2.8，新增transmission-extra包  
- **25.05.23**：弃用armhf架构  
- **14.05.23**：显式安装transmission-remote  
- **02.03.23**：添加cron初始化支持用户自定义定时任务  
- **08.02.23**：基于Alpine Edge重构，移除第三方UI包  
- **05.01.23**：重构至Alpine 3.17，恢复GNU findutils包  
- **02.11.22**：重构至Alpine 3.16，迁移至s6v3  
- **更早版本**：详见[GitHub历史]([])
