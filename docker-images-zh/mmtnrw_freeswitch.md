---
image: mmtnrw/freeswitch
description: "基于Alpine的Docker化Freeswitch镜像，提供轻量级开源电话软交换服务，支持语音、视频通信。"
source: https://xuanyuan.cloud/zh/r/mmtnrw/freeswitch
canonical: https://xuanyuan.cloud/zh/r/mmtnrw/freeswitch
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mmtnrw/freeswitch" title="mmtnrw/freeswitch Docker 镜像中文简介、标签列表与拉取命令">mmtnrw/freeswitch 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# freeswitch-docker 镜像文档


## 1. 镜像概述和主要用途

freeswitch-docker 是一个基于 Alpine Linux 的 Docker 化 FreeSWITCH 镜像，旨在提供轻量级、可移植的 FreeSWITCH 软交换服务部署方案。该镜像将开源通信引擎 FreeSWITCH 与容器化技术结合，支持快速搭建 IP 语音（VoIP）、视频通信、电话系统等实时通信应用，适用于开发、测试及生产环境的高效部署。


## 2. 核心功能和特性

### 2.1 FreeSWITCH 核心功能
- **多协议支持**：兼容 SIP、WebRTC、H.323、MGCP 等主流通信协议。
- **媒体处理**：支持 G.711、G.729、OPUS 等语音编解码，以及 VP8、H.264 视频编解码。
- **呼叫控制**：提供 IVR（交互式语音响应）、呼叫转移、会议、录音、转接等呼叫流程管理能力。
- **扩展性**：支持 Lua/JavaScript 脚本扩展，可自定义业务逻辑（如拨号计划、呼叫路由）。
- **高可用性**：支持集群部署和故障转移，满足高并发通信场景需求。


### 2.2 Docker 镜像特性
- **轻量级**：基于 Alpine Linux 构建，镜像体积小，资源占用低。
- **环境隔离**：容器化部署确保 FreeSWITCH 运行环境与主机系统隔离，避免依赖冲突。
- **快速部署**：简化传统 FreeSWITCH 复杂的安装配置流程，支持一键启动服务。
- **可移植性**：兼容 Docker 生态系统，可在任何支持 Docker 的环境（物理机、云服务器、K8s）中运行。
- **配置持久化**：支持通过数据卷挂载自定义配置文件，实现配置复用和动态更新。


## 3. 使用场景和适用范围

### 3.1 典型应用场景
- **企业 IP 电话系统**：构建基于 SIP 的企业内部电话网络，支持分机通信、外线接入。
- **呼叫中心**：部署具备 IVR 导航、队列管理、通话录音功能的呼叫中心系统。
- **视频会议平台**：通过 WebRTC 协议实现浏览器端实时音视频会议。
- **VoIP 服务集成**：作为软交换核心，为第三方应用提供语音通信能力（如客服系统、社交软件）。
- **开发测试环境**：快速搭建 FreeSWITCH 测试环境，验证 SIP 协议交互、呼叫流程逻辑。


### 3.2 适用范围
- 通信服务提供商（CSP）、VoIP 运营商
- 企业 IT 部门（部署内部通信系统）
- 软件开发团队（集成语音/视频功能到应用）
- 中小型呼叫中心
- 教育、医疗等行业的远程通信场景


## 4. 详细使用方法和配置说明

### 4.1 镜像获取
通过 Docker Hub 拉取镜像（假设镜像名称为 `freeswitch-docker`）：
```bash
docker pull docker.xuanyuan.run/freeswitch-docker
```


### 4.2 基本运行示例（docker run）
```bash
docker run -d \
  --name freeswitch \
  --restart=always \
  -p 5060:5060/udp \    # SIP UDP 端口（默认）
  -p 5060:5060/tcp \    # SIP TCP 端口（可选，用于 TLS 或可靠传输）
  -p 8080:8080/tcp \    # WebRTC  signaling/API 端口（默认）
  -p 16384-16394:16384-16394/udp \  # RTP 媒体端口范围（根据并发需求调整）
  -v /host/path/freeswitch/conf:/etc/freeswitch \  # 挂载自定义配置文件
  -v /host/path/freeswitch/log:/var/log/freeswitch \  # 挂载日志目录
  -v /host/path/freeswitch/recordings:/var/lib/freeswitch/recordings \  # 挂载录音目录
  freeswitch-docker
```


### 4.3 Docker Compose 配置示例
创建 `docker-compose.yml` 文件：
```yaml
version: '3'
services:
  freeswitch:
    image: docker.xuanyuan.run/freeswitch-docker
    container_name: freeswitch
    restart: always
    ports:
      - "5060:5060/udp"       # SIP UDP
      - "5060:5060/tcp"       # SIP TCP
      - "8080:8080/tcp"       # WebRTC/API
      - "16384-16394:16384-16394/udp"  # RTP 端口
    volumes:
      - ./conf:/etc/freeswitch        # 配置文件目录
      - ./log:/var/log/freeswitch     # 日志目录
      - ./recordings:/var/lib/freeswitch/recordings  # 录音存储
    environment:
      - FS_LOG_LEVEL=info             # 日志级别（可选：debug/info/warn/error）
      - FS_SIP_PORT=5060              # 自定义 SIP 端口（默认 5060）
```

启动服务：
```bash
docker-compose up -d
```


### 4.4 配置参数说明

#### 4.4.1 端口映射
| 端口/协议       | 用途说明                          | 备注                     |
|-----------------|-----------------------------------|--------------------------|
| 5060/udp        | SIP 信令（UDP 模式，默认）        | 标准 SIP 端口            |
| 5060/tcp        | SIP 信令（TCP 模式，可选）        | 用于需要可靠传输的场景   |
| 8080/tcp        | WebRTC  signaling/HTTP API        | FreeSWITCH 内置 HTTP 服务|
| 16384-16394/udp | RTP 媒体流传输（默认范围）        | 根据并发通话数调整范围   |


#### 4.4.2 环境变量
| 环境变量名       | 取值范围          | 说明                          |
|------------------|-------------------|-------------------------------|
| FS_LOG_LEVEL     | debug/info/warn/error | 设置日志输出级别，默认 info   |
| FS_SIP_PORT      | 1-65535           | 自定义 SIP 信令端口，默认 5060|
| FS_PASSWORD      | 字符串            | FreeSWITCH 管理控制台密码     |


#### 4.4.3 数据卷挂载
| 容器内路径                          | 用途说明                          | 建议挂载方式               |
|-------------------------------------|-----------------------------------|----------------------------|
| /etc/freeswitch                     | FreeSWITCH 配置文件目录           | 本地目录挂载（自定义配置） |
| /var/log/freeswitch                 | 运行日志存储目录                  | 本地目录挂载（日志持久化） |
| /var/lib/freeswitch/recordings      | 通话录音存储目录                  | 本地目录挂载（数据备份）   |


### 4.5 自定义配置
1. **配置文件结构**：通过挂载 `/etc/freeswitch` 目录，可修改核心配置文件，如：
   - `sip_profiles/`：SIP 协议配置（如外部配置 `external.xml`、内部配置 `internal.xml`）
   - `dialplan/`：拨号计划配置（定义呼叫路由规则）
   - `vars.xml`：全局变量配置（如端口、编解码、网络参数）

2. **配置生效**：修改配置文件后，需重启容器使配置生效：
   ```bash
   docker restart freeswitch
   ```


## 5. 注意事项
- **端口冲突**：确保宿主机端口未被其他服务占用（如 5060 端口可能被其他 SIP 服务占用）。
- **防火墙配置**：需开放容器映射的端口（尤其是 RTP 端口范围），避免通信中断。
- **性能优化**：高并发场景下，建议调整 RTP 端口范围、增加容器 CPU/内存资源。
- **数据备份**：定期备份挂载的配置文件、日志和录音目录，防止数据丢失。
- **镜像更新**：通过 `docker pull docker.xuanyuan.run/freeswitch-docker` 获取最新镜像，更新前备份配置文件。
