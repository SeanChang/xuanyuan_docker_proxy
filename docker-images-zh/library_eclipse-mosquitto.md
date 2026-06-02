---
image: library/eclipse-mosquitto
description: "Eclipse Mosquitto是一款开源的消息代理软件，它全面实现了MQTT协议的5.0版、3.1.1版及3.1版标准，作为轻量级发布/订阅消息传输协议的关键组件，该消息代理能够高效接收、存储并转发来自各类客户端的消息，广泛适用于物联网设备通信、移动应用数据交互及分布式系统集成等场景，凭借其开源特性、轻量化设计与良好的协议兼容性，成为开发者构建可靠消息传递系统的优选工具。"
source: https://xuanyuan.cloud/zh/r/library/eclipse-mosquitto
canonical: https://xuanyuan.cloud/zh/r/library/eclipse-mosquitto
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/eclipse-mosquitto" title="library/eclipse-mosquitto Docker 镜像中文简介、标签列表与拉取命令">library/eclipse-mosquitto — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/eclipse-mosquitto" title="library/eclipse-mosquitto Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/eclipse-mosquitto</a>

# Eclipse Mosquitto Docker 镜像使用说明


## 快速参考

### 维护方  
[Eclipse 基金会]([])  

### 获取帮助渠道  
[Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])  


## 支持的标签及对应 Dockerfile 链接  

- [`2.0.22`, `2.0.22-openssl`, `2.0`, `2.0-openssl`, `2`, `2-openssl`, `openssl`, `latest`]([])  
- [`1.6.15-openssl`, `1.6-openssl`]([])  


## 快速参考（续）

### 问题反馈地址  
[[]]([])  

### 支持的架构  
（[更多信息]([])）  
[`amd64`]([])、[`arm32v6`]([])、[`arm64v8`]([])、[`i386`]([])、[`ppc64le`]([])、[`s390x`]([])  

### 镜像详情  
[repo-info 仓库的 `repos/eclipse-mosquitto/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  

### 镜像更新  
[official-images 仓库的 `library/eclipse-mosquitto` 标签]([])  
[official-images 仓库的 `library/eclipse-mosquitto` 文件]([])（[历史记录]([])）  

### 本文档来源  
[docs 仓库的 `eclipse-mosquitto/` 目录]([])（[历史记录]([])）  


## 什么是 Eclipse Mosquitto？  

Eclipse Mosquitto 是 MQTT 协议（版本 5、3.1.1 和 3.1）的开源服务器实现。官网：[]  

![logo]([])  


## Eclipse Mosquitto 与 Cedalo  

[Cedalo]([]) 为 Eclipse Mosquitto 提供商业支持、企业级 MQTT 产品、专业服务及培训。  


## 如何使用本镜像  

### 目录结构  
镜像中预设了三个目录，分别用于配置、持久化存储和日志：  
- `/mosquitto/config`（配置目录）  
- `/mosquitto/data`（数据存储目录）  
- `/mosquitto/log`（日志目录）  

建议本地也按此结构创建目录，以便映射容器内目录。  


### 配置方法  
默认运行时使用镜像内置的配置。如需自定义配置，可按以下步骤操作：  

1. 在本地创建配置文件：`$PWD/mosquitto/config/mosquitto.conf`  
2. 运行容器时，将本地配置目录挂载到容器的 `/mosquitto/config`：  
   ```bash
   docker run -it -p 1883:1883 -v "$PWD/mosquitto/config:/mosquitto/config" eclipse-mosquitto
   ```  

**配置示例**：  
如需启用数据持久化并指定日志路径，可在 `mosquitto.conf` 中添加：  
```ini
persistence true          # 启用持久化
persistence_location /mosquitto/data/  # 数据存储路径
log_dest file /mosquitto/log/mosquitto.log  # 日志文件路径
```  

> **注意**：若通过卷（volume）挂载目录，数据会在容器重启后保留。  


### 运行容器  
根据需求选择以下命令运行容器：  

#### 基础运行（仅挂载配置目录）  
```bash
docker run -it -p 1883:1883 -v "$PWD/mosquitto/config:/mosquitto/config" eclipse-mosquitto
```  

#### 完整挂载（配置、数据、日志目录均映射到本地）  
```bash
docker run -it -p 1883:1883 \
  -v "$PWD/mosquitto/config:/mosquitto/config" \
  -v "$PWD/mosquitto/data:/mosquitto/data" \
  -v "$PWD/mosquitto/log:/mosquitto/log" \
  eclipse-mosquitto
```  

#### 自定义端口  
若配置文件中修改了默认端口（如新增 8080 端口），需在运行时同步映射端口：  
```bash
docker run -it -p 1883:1883 -p 8080:8080 \
  -v "$PWD/mosquitto/config:/mosquitto/config" \
  eclipse-mosquitto
```  


## 许可证  
Eclipse Mosquitto 基于 [EPL]([])/[EDL]([]) 许可证发布。  

与所有 Docker 镜像类似，本镜像可能包含其他软件（如基础系统的 Bash 等），其许可证需另行遵守。更多许可证信息可参考 [repo-info 仓库的 `eclipse-mosquitto/` 目录]([])。  

使用前请确保遵守镜像中所有软件的相关许可证。
