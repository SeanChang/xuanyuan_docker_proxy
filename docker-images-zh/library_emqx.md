---
image: library/emqx
description: "已弃用；这是一款专为物联网（IoT）、工业物联网（IIoT）、联网车辆等场景设计的最具可扩展性的开源MQTT消息代理，具备高效处理大规模设备连接的能力，曾广泛应用于各类智能设备互联与数据传输领域，为海量终端提供稳定可靠的通信支持。"
source: https://xuanyuan.cloud/zh/r/library/emqx
canonical: https://xuanyuan.cloud/zh/r/library/emqx
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/emqx" title="library/emqx Docker 镜像中文简介、标签列表与拉取命令">library/emqx — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/emqx" title="library/emqx Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/emqx</a>

# EMQX Docker 镜像使用指南


## 重要通知
自 v5.9.0 版本起，EMQX 已将原开源版与企业版的所有功能整合，统一采用 Business Source License (BSL) 1.1 许可证。  
- 若需了解变更原因，可阅读[官方博客]()。  
- 关于新许可证的更多信息，可参考[EMQX 许可常见问题]()。  

因此，EMQX 已停止发布 `emqx` 官方 Docker 镜像。v5.9.0 及以上版本仅通过以下 Docker Hub 仓库提供：  
- [`emqx/emqx`]([])  
- [`emqx/emqx-enterprise`]([])  


## 基本信息
- **维护者**：[EMQ Technologies]([])  
- **获取帮助**：[GitHub Discussions]([]) 或 []()  


## 支持的标签及 Dockerfile 链接
| 标签                     | 对应 Dockerfile 链接                                                                 |
|--------------------------|-------------------------------------------------------------------------------------|
| `5.7.2`, `5.7`           | [链接]([]) |
| `5.8.8`, `5.8`, `5`, `latest` | [链接]([]) |  


## 更多参考信息
- **提交问题**：[GitHub Issues]([])  
- **支持的架构**：`amd64`（[链接]([])）、`arm64v8`（[链接]([])）  
- **镜像详情**：包含元数据、传输大小等，见 [repo-info 仓库 `emqx` 目录]([])（[历史记录]([])）  
- **镜像更新**：关注 [official-images 仓库 `library/emqx` 标签]([]) 或 [文件历史]([])  
- **描述来源**：[docs 仓库 `emqx` 目录]([])（[历史记录]([])）  


## 关于 EMQX
EMQX 是一款高性能、高可扩展的开源 MQTT  broker，单集群可连接超 1 亿 IoT 设备，支持每秒 100 万条消息吞吐量及亚毫秒级延迟。  
- 支持 MQTT 5.0/3.x、HTTP、QUIC、WebSocket 等协议，提供 TLS/SSL 加密及多种认证机制，确保双向通信安全。  
- 内置 SQL 规则引擎，可实时提取、过滤、丰富和转换 IoT 数据；采用无主分布式架构，支持高可用与水平扩展，运维友好且可观测性强。  
- 全球超 2 万家企业用户，覆盖 50 多个国家和地区，连接超 1 亿设备，服务于 HPE、VMware、上汽大众等 70 余家财富 500 强企业的关键 IoT、工业物联网及车联网场景。  


## 使用指南

### 运行 EMQX
通过 Docker 命令启动 EMQX 容器：  
```bash
docker run -d --name emqx emqx:${tag}
```  
示例（映射控制台端口 18083 和 MQTT 端口 1883）：  
```bash
docker run -d --name emqx -p 18083:18083 -p 1883:1883 emqx:latest
```  
容器内 EMQX 以 `emqx` 用户身份运行。


### 配置
EMQX 配置文件 `etc/emqx.conf` 中的所有参数可通过环境变量设置，转换规则如下：  
- 移除前缀 `EMQX_`  
- 大写字母转小写  
- `__` 替换为 `.`  

例如：  
- `EMQX_DASHBOARD__DEFAULT_PASSWORD` 对应 `dashboard.default_password`（控制台默认密码）  
- `EMQX_NODE__COOKIE` 对应 `node.cookie`（节点 cookie）  

示例：设置控制台密码为 `mysecret`  
```bash
docker run -d --name emqx -e EMQX_DASHBOARD__DEFAULT_PASSWORD=mysecret -p 18083:18083 -p 1883:1883 emqx:latest
```  
更多配置细节见 [官方文档]()。


### 节点名称配置
环境变量 `EMQX_NODE__NAME` 用于指定节点名称，默认格式为 `<容器名>@<容器 IP>`。若未指定，EMQX 会根据运行环境或节点发现配置自动生成。


### 集群部署
EMQX 支持多种集群方式（如静态节点列表、DNS 等），详见 [集群文档]()。以下为 Docker Compose 静态节点集群示例：  

1. 创建 `compose.yaml`：  
```yaml
services:
  emqx1:
    image: emqx:latest
    environment:
      - "EMQX_NODE__NAME=[邮箱已删除]"
      - "EMQX_CLUSTER__DISCOVERY_STRATEGY=static"
      - "EMQX_CLUSTER__STATIC__SEEDS=[[邮箱已删除], [邮箱已删除]]"
    networks:
      emqx-bridge:
        aliases: ["node1.emqx.io"]

  emqx2:
    image: emqx:latest
    environment:
      - "EMQX_NODE__NAME=[邮箱已删除]"
      - "EMQX_CLUSTER__DISCOVERY_STRATEGY=static"
      - "EMQX_CLUSTER__STATIC__SEEDS=[[邮箱已删除], [邮箱已删除]]"
    networks:
      emqx-bridge:
        aliases: ["node2.emqx.io"]

networks:
  emqx-bridge: { driver: bridge }
```  

2. 启动集群：  
```bash
docker compose -p my_emqx up -d
```  

3. 检查集群状态：  
```bash
docker exec -it my_emqx_emqx1_1 sh -c "emqx ctl cluster status"
```  
预期输出：  
```
Cluster status: #{running_nodes => ['[邮箱已删除]','[邮箱已删除]'], stopped_nodes => []}
```  


### 持久化数据
需持久化以下目录（数据部分存储于 `/opt/emqx/data/mnesia/${node_name}`，需固定节点名称以恢复状态）：  
- `/opt/emqx/data`（数据文件）  
- `/opt/emqx/log`（日志文件）  

Docker Compose 配置示例（使用命名卷）：  
```yaml
volumes:
  vol-emqx-data: { name: foo-emqx-data }
  vol-emqx-log: { name: foo-emqx-log }

services:
  emqx:
    image: emqx:latest
    restart: always
    environment:
      EMQX_NODE__NAME: foo_emqx@127.0.0.1  # 固定节点名称（单节点可用回环 IP）
    volumes:
      - vol-emqx-data:/opt/emqx/data
      - vol-emqx-log:/opt/emqx/log
```  


### 内核调优（Linux 主机）
推荐参考 [性能调优指南]()。若需通过 Docker 调优内核参数（Docker 版本 ≥1.12），示例命令如下：  
```bash
docker run -d --name emqx -p 18083:18083 -p 1883:1883 \
  --sysctl fs.file-max=2097152 \
  --sysctl fs.nr_open=2097152 \
  --sysctl net.core.somaxconn=32768 \
  --sysctl net.ipv4.tcp_max_syn_backlog=16384 \
  --sysctl net.core.netdev_max_backlog=16384 \
  --sysctl net.ipv4.ip_local_port_range="1000 65535" \
  --sysctl net.core.rmem_default=262144 \
  --sysctl net.core.wmem_default=262144 \
  --sysctl net.core.rmem_max=16777216 \
  --sysctl net.core.wmem_max=16777216 \
  --sysctl net.core.optmem_max=16777216 \
  --sysctl net.ipv4.tcp_rmem="1024 4096 16777216" \
  --sysctl net.ipv4.tcp_wmem="1024 4096 16777216" \
  --sysctl net.ipv4.tcp_max_tw_buckets=1048576 \
  --sysctl net.ipv4.tcp_fin_timeout=15 \
  emqx:latest
```  
> 注意：不要以特权模式运行容器或挂载系统目录调优内核，存在安全风险。  


## 许可证信息
- 镜像中 EMQX 软件的许可证见 [LICENSE 文件]([])。  
- 镜像可能包含基础系统（如 Bash）及其他依赖软件，其许可证需参考各自声明。  
- 自动检测的许可信息可在 [repo-info 仓库 `emqx` 目录]([]) 查看。  

使用前请确保遵守所有包含软件的许可证要求。
