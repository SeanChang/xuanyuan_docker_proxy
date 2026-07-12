---
image: johngong/syncthing-relay-discosrv
description: "包含relaysrv:2.0.10和discosrv:2.0.10组件，为syncthing同步工具提供中继连接与节点发现服务的服务器镜像。"
source: https://xuanyuan.cloud/zh/r/johngong/syncthing-relay-discosrv
canonical: https://xuanyuan.cloud/zh/r/johngong/syncthing-relay-discosrv
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/johngong/syncthing-relay-discosrv" title="johngong/syncthing-relay-discosrv Docker 镜像中文简介、标签列表与拉取命令">johngong/syncthing-relay-discosrv 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Syncthing 中继与发现服务器 Docker 镜像文档


## 镜像概述

本镜像基于 Syncthing 项目，集成中继服务器（strelaysrv）和发现服务器（stdiscosrv），提供 Syncthing 设备间的中继转发与节点发现功能。适用于搭建私有 Syncthing 中继网络，解决设备间直接连接困难问题，提升同步稳定性。


## 核心功能与特性

- **集成双服务器**：同时支持中继服务器（strelaysrv）和发现服务器（stdiscosrv），可独立启用或禁用
- **版本信息**：strelaysrv 2.0.10、stdiscosrv 2.0.10
- **多架构支持**：兼容 amd64、arm64v8、arm32v7 架构
- **灵活配置**：支持速率限制（全局/每会话）、超时设置、持久化证书与数据库
- **权限控制**：可自定义运行用户 UID/GID，适配不同环境权限要求


## 使用场景

- 搭建私有 Syncthing 中继网络，加速跨网络设备同步
- 部署本地发现服务器，提升局域网或私有网络内设备发现效率
- NAS 环境（如群晖）中部署，提供稳定的中继与发现服务
- 需要控制数据传输速率、保障同步安全性的企业或个人场景


## 版本信息

| 组件名       | 版本   | 支持架构                |
|--------------|--------|-------------------------|
| strelaysrv   | 2.0.10 | amd64; arm64v8; arm32v7 |
| stdiscosrv   | 2.0.10 | amd64; arm64v8; arm32v7 |


## 安装与部署

### 镜像下载

| 镜像源       | 拉取命令                                          |
|--------------|---------------------------------------------------|
| DockerHub    | `docker pull docker.xuanyuan.run/johngong/syncthing-relay-discosrv:latest` |
| GitHub Container Registry | `docker pull ***-ghcr.xuanyuan.run/gshang2017/syncthing-relay-discosrv:latest` |


### Docker 命令行部署

#### 快速启动（默认配置）

```bash
docker run -d \
  --name=syncthing-relay-discosrv \
  -p 22067:22067 \
  -p 22070:22070 \
  -p 8443:8443 \
  --restart unless-stopped \
  docker.xuanyuan.run/johngong/syncthing-relay-discosrv:latest
```

#### 自定义配置示例（持久化+速率限制）

```bash
docker run -d \
  --name=syncthing-relay-discosrv \
  -p 22067:22067 \
  -p 22070:22070 \
  -p 8443:8443 \
  -v /path/to/local/config:/config \  # 持久化配置、证书与数据库
  -e UID=1024 \
  -e GID=1024 \
  -e GLOBAL_RATE=200000000 \  # 全局速率限制 200MB/s
  -e PER_SESSION_RATE=20000000 \  # 每会话速率限制 20MB/s
  --restart unless-stopped \
  johngong/syncthing-relay-discosrv:latest
```


### 群晖 NAS 部署

#### 卷配置（可选）

| 本地文件夹          | 容器路径 | 说明                                                                 |
|---------------------|----------|----------------------------------------------------------------------|
| `/volume1/docker/syncthing-config` | `/config` | 持久化配置目录，包含证书（/config/certs）和数据库（/config/discosrvdb），避免重装后 Device ID 变更 |

#### 端口配置

| 本地端口 | 容器端口 | 说明                                   |
|----------|----------|----------------------------------------|
| 22067    | 22067    | 中继服务器协议监听端口                 |
| 22070    | 22070    | 中继服务器状态监控端口                 |
| 8443     | 8443     | 发现服务器监听端口                     |

#### 环境变量配置

在群晖 Docker 界面「环境」选项卡中添加以下变量：

| 变量名                | 值示例          | 说明                                                                 |
|-----------------------|-----------------|----------------------------------------------------------------------|
| UID                   | 1000            | 运行用户 UID，默认 1000                                              |
| GID                   | 1000            | 运行用户 GID，默认 1000                                              |
| ENABLE_STDISCOSRV     | true            | 是否启用发现服务器（true/false），默认 true                          |
| ENABLE_STRELAYSRV     | true            | 是否启用中继服务器（true/false），默认 true                          |
| GLOBAL_RATE           | 100000000       | 全局速率限制（bytes/s），默认 100000000（100MB/s）                   |
| PER_SESSION_RATE      | 10000000        | 每会话速率限制（bytes/s），默认 10000000（10MB/s）                   |
| MESSAGE_TIMEOUT       | 1m30s           | 消息超时时间，默认 1m30s                                             |
| NATWORK_TIMEOUT       | 3m0s            | 客户端-中继服务器操作超时时间，默认 3m0s                              |
| PING_INTERVAL         | 1m30s           | 心跳包发送间隔，默认 1m30s                                           |
| PROVIDED_BY           | "My Private Relay" | 中继提供者标识，默认 "strelaysrv"                                   |


## 配置参数详解

### 基础命令参数

| 参数形式                  | 说明                                   |
|---------------------------|----------------------------------------|
| `--name=syncthing-relay-discosrv` | 容器名称，建议保持默认以便识别         |
| `-restart unless-stopped` | 容器重启策略，确保服务持续运行         |


### 端口映射

| 端口映射       | 说明                                                                 |
|----------------|----------------------------------------------------------------------|
| `-p 22067:22067` | 中继服务器核心端口，用于设备间中继数据传输                           |
| `-p 22070:22070` | 中继服务器状态端口，可通过 `http://<IP>:22070/status` 查看中继状态   |
| `-p 8443:8443`   | 发现服务器端口，用于设备节点发现和地址解析                           |


### 卷挂载

| 挂载形式                | 说明                                                                 |
|-------------------------|----------------------------------------------------------------------|
| `-v /local/config:/config` | 持久化配置目录，**推荐设置**。包含：<br>- 证书（/config/certs）：服务器 TLS 证书，决定 Device ID<br>- 数据库（/config/discosrvdb）：发现服务器节点数据 |


### 环境变量

| 变量名                | 类型/取值范围      | 默认值           | 说明                                                                 |
|-----------------------|--------------------|------------------|----------------------------------------------------------------------|
| UID                   | 整数               | 1000             | 运行用户 UID，需与宿主机用户权限匹配                                 |
| GID                   | 整数               | 1000             | 运行用户 GID，需与宿主机用户权限匹配                                 |
| ENABLE_STDISCOSRV     | true/false         | true             | 是否启用 stdiscosrv（发现服务器）                                    |
| ENABLE_STRELAYSRV     | true/false         | true             | 是否启用 strelaysrv（中继服务器）                                    |
| GLOBAL_RATE           | 整数（bytes/s）    | 100000000        | 全局中继数据传输速率限制，0 表示无限制                               |
| PER_SESSION_RATE      | 整数（bytes/s）    | 10000000         | 单个设备会话的速率限制，0 表示无限制                                 |
| MESSAGE_TIMEOUT       | 时间字符串（如 1m30s） | 1m30s            | 中继消息等待超时时间                                                 |
| NATWORK_TIMEOUT       | 时间字符串（如 3m0s）  | 3m0s             | 客户端与中继服务器的连接超时时间                                     |
| PING_INTERVAL         | 时间字符串（如 1m30s） | 1m30s            | 中继服务器向客户端发送心跳包的间隔                                   |
| PROVIDED_BY           | 字符串             | "strelaysrv"     | 中继服务器标识，可自定义（如组织名称），用于客户端识别               |
| POOLS                 | 字符串（逗号分隔URL） | 空               | 中继服务器池地址列表，留空则为私有中继，不接入公共池                 |
| DISCO_OTHER_OPTION    | 字符串             | 空               | 发现服务器额外参数，如 `-debug`（调试模式）、`-metrics`（启用指标），详见 [Syncthing stdiscosrv 文档](https://docs.syncthing.net/users/stdiscosrv.html) |
| RELAY_OTHER_OPTION    | 字符串             | 空               | 中继服务器额外参数，如 `-ext-address`（指定外部地址）、`-protocol`（指定传输协议），详见 [Syncthing strelaysrv 文档](https://docs.syncthing.net/users/strelaysrv.html) |


## 容器管理

### 基本操作

```bash
# 启动容器
docker start syncthing-relay-discosrv

# 停止容器
docker stop syncthing-relay-discosrv

# 重启容器
docker restart syncthing-relay-discosrv

# 查看容器日志（获取 Device ID 等关键信息）
docker logs syncthing-relay-discosrv

# 删除容器（需先停止）
docker rm syncthing-relay-discosrv

# 删除镜像
docker rmi johngong/syncthing-relay-discosrv:latest
```


## 客户端配置

### 获取服务器 Device ID

1. **通过容器日志获取**：
   ```bash
   docker logs syncthing-relay-discosrv | grep "Device ID"
   ```
   输出示例：`Device ID: ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM`


### Syncthing 客户端设置

#### 1. 全局连接配置
进入 Syncthing 客户端界面 → **操作** → **设置** → **连接**：

- **协议监听地址**：添加中继服务器地址  
  格式：`relay://<服务器IP或域名>:22067/?id=<Device ID>`  
  示例：`relay://syncthing-relay.example.com:22067/?id=ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM`

- **全球发现服务器**：添加私有发现服务器（若启用）  
  格式：`https://<服务器IP或域名>:8443/?id=<Device ID>`  
  示例：`https://syncthing-disco.example.com:8443/?id=ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM`

- **连接选项**：勾选「启用中继」，按需启用「本地发现」（局域网环境）。


#### 2. 远程设备高级配置
针对特定远程设备，进入 **远程设备** → 选择设备 → **编辑** → **高级** → **地址列表**：

- 添加中继服务器地址，格式同上：  
  `relay://syncthing-relay.example.com:22067/?id=ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM`


## 参考与致谢

### 项目链接
- GitHub 源码：[https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)
- 基于 Syncthing 官方项目：[https://github.com/syncthing](https://github.com/syncthing)


### 官方文档
- Syncthing 中继服务器文档：[https://docs.syncthing.net/users/strelaysrv.html](https://docs.syncthing.net/users/strelaysrv.html)
- Syncthing 发现服务器文档：[https://docs.syncthing.net/users/stdiscosrv.html](https://docs.syncthing.net/users/stdiscosrv.html)
- Syncthing 客户端使用指南：[https://docs.syncthing.net/users/](https://docs.syncthing.net/users/)
