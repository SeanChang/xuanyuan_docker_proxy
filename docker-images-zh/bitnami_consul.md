---
image: bitnami/consul
description: "Bitnami提供的Consul安全镜像，用于服务发现、配置管理及服务网格部署，具备安全加固特性。"
source: https://xuanyuan.cloud/zh/r/bitnami/consul
canonical: https://xuanyuan.cloud/zh/r/bitnami/consul
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/consul" title="bitnami/consul Docker 镜像中文简介、标签列表与拉取命令">bitnami/consul 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami HashiCorp Consul 镜像文档


## 镜像概述和主要用途

### 关于 HashiCorp Consul
HashiCorp Consul 是一款用于在基础设施中发现和配置服务的工具，提供服务发现、配置管理和分段功能，支持多数据中心部署，是微服务架构中的关键组件。

### Bitnami 镜像特点
Bitnami HashiCorp Consul 镜像是经过安全加固的容器化发行版，旨在简化 Consul 的部署和管理。该镜像遵循非 root 用户运行原则，提供最小化攻击面，并支持持久化存储、集群部署和灵活配置。


## ⚠️ 重要通知：Bitnami 镜像仓库即将变更
自 2025 年 8 月 28 日起，Bitnami 将调整其公共镜像仓库，推出**Bitnami Secure Images（安全镜像）** 计划，主要变更包括：
- 社区用户首次可访问安全优化版容器镜像。
- 逐步弃用非加固的 Debian 基础镜像，免费 tier 将仅保留少量加固镜像（仅 `latest` 标签），适用于开发环境。
- 现有所有镜像（包括历史版本标签，如 `2.50.0`、`10.6`）将在两周内迁移至 `docker.io/bitnamilegacy` 仓库，不再接收更新。
- 生产环境推荐使用 Bitnami Secure Images，包含加固容器、攻击面缩减、CVE 透明度（VEX/KEV）、SBOM 和企业支持。

更多详情见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 核心功能和特性

### Consul 核心功能
- **服务发现**：自动注册和发现服务实例，支持健康检查。
- **配置管理**：集中存储和分发服务配置，动态更新。
- **分段与安全**：基于身份的服务网格功能，加密服务间通信。
- **多数据中心**：跨数据中心的服务发现和复制。

### Bitnami 镜像特性
- **非 root 容器**：以 UID 1001 运行，降低特权攻击风险。
- **安全加固**：基于 Photon Linux 最小操作系统，减少攻击面。
- **持久化支持**：数据卷挂载确保配置和状态持久化。
- **集群部署**：简化多节点集群配置，支持自动加入集群。
- **标准化配置**：环境变量和配置文件两种配置方式，兼容 Bitnami 其他镜像。
- **供应链安全**：提供 SBOM、签名验证、CVE 透明度报告（VEX/KEV）。


## 使用场景和适用范围
- **开发环境**：快速搭建本地 Consul 服务，验证服务发现和配置逻辑。
- **微服务架构**：作为服务网格的核心组件，管理服务注册与发现。
- **云原生部署**：配合 Kubernetes 或 Docker Swarm，提供分布式服务协调。
- **多团队协作**：集中管理跨团队服务配置，避免配置冲突。
- **CI/CD 流水线**：集成到自动化部署流程，动态调整服务配置。


## 详细的使用方法和配置说明

### 获取镜像

#### 拉取官方镜像
推荐从 Docker Hub 拉取最新版安全镜像：
```console
docker pull docker.xuanyuan.run/bitnami/consul:latest
```

如需特定版本，可指定标签（注意：2025 年 8 月后非 `latest` 标签将迁移至 `bitnamilegacy` 仓库）：
```console
docker pull docker.xuanyuan.run/bitnami/consul:[TAG]  # 例如 bitnami/consul:1.16.0
```

#### 本地构建镜像
从源码构建（需替换 `APP`、`VERSION`、`OPERATING-SYSTEM` 占位符）：
```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/consul:latest .
```


### 快速启动
使用 `docker run` 快速启动单节点 Consul：
```console
docker run --name consul -p 8500:8500 docker.xuanyuan.run/bitnami/consul:latest
```
访问 `http://localhost:8500` 即可打开 Consul UI。


### 持久化数据
Consul 数据（配置、状态、Raft 日志）默认存储在 `/bitnami`，需挂载卷以避免容器删除后数据丢失：

#### Docker 命令
```console
docker run -v /本地路径/consul-data:/bitnami docker.xuanyuan.run/bitnami/consul:latest
```

#### Docker Compose
```yaml
version: '2'
services:
  consul:
    image: docker.xuanyuan.run/bitnami/consul:latest
    volumes:
      - /本地路径/consul-data:/bitnami  # 本地目录挂载
    # 或使用命名卷
    # volumes:
    #   - consul-data:/bitnami
volumes:
  consul-data:
    driver: local
```

> **注意**：挂载的本地目录需确保 UID 1001 有读写权限，可通过 `chown -R 1001:1001 /本地路径/consul-data` 调整。


### 连接其他容器
通过 Docker 网络实现容器间通信，容器名作为 hostname。

#### 手动创建网络（Docker 命令）
1. 创建桥接网络：
   ```console
   docker network create consul-network --driver bridge
   ```

2. 启动 Consul 节点并加入网络：
   ```console
   docker run --name consul-node1 --network consul-network docker.xuanyuan.run/bitnami/consul:latest
   ```

3. 其他容器加入同一网络即可通过 `consul-node1` 访问 Consul。

#### Docker Compose 网络配置
自动创建网络并连接服务：
```yaml
version: '2'
networks:
  consul-network:
    driver: bridge
services:
  consul:
    image: docker.xuanyuan.run/bitnami/consul:latest
    networks:
      - consul-network
    ports:  # 暴露常用端口
      - 8300:8300  # RPC 端口
      - 8301:8301/tcp  # LAN Serf 端口（TCP）
      - 8301:8301/udp  # LAN Serf 端口（UDP）
      - 8500:8500  # HTTP API/UI 端口
      - 8600:8600/tcp  # DNS 端口（TCP）
      - 8600:8600/udp  # DNS 端口（UDP）
```


### 部署 Consul 集群
通过 Docker Compose 快速搭建 3 节点 Consul 集群（生产环境建议使用 Helm Chart）。

#### 完整 docker-compose.yml
```yaml
version: '2'
services:
  consul-node1:  # 主节点（启用 UI）
    image: docker.xuanyuan.run/bitnami/consul:latest
    environment:
      - CONSUL_BOOTSTRAP_EXPECT=3  # 期望的集群节点数
      - CONSUL_CLIENT_LAN_ADDRESS=0.0.0.0  # 客户端绑定地址
      - CONSUL_DISABLE_KEYRING_FILE=true  # 禁用密钥环文件
      - CONSUL_RETRY_JOIN_ADDRESS=consul-node1  # 重试加入的节点地址
      - CONSUL_ENABLE_UI=true  # 启用 UI
    ports:
      - 8300:8300
      - 8301:8301/tcp
      - 8301:8301/udp
      - 8500:8500  # UI 端口
      - 8600:8600/tcp
      - 8600:8600/udp
    volumes:
      - consul-node1-data:/bitnami

  consul-node2:  # 从节点（禁用 UI）
    image: docker.xuanyuan.run/bitnami/consul:latest
    environment:
      - CONSUL_BOOTSTRAP_EXPECT=3
      - CONSUL_CLIENT_LAN_ADDRESS=0.0.0.0
      - CONSUL_DISABLE_KEYRING_FILE=true
      - CONSUL_RETRY_JOIN_ADDRESS=consul-node1  # 加入主节点
      - CONSUL_ENABLE_UI=false
    volumes:
      - consul-node2-data:/bitnami

  consul-node3:  # 从节点（禁用 UI）
    image: docker.xuanyuan.run/bitnami/consul:latest
    environment:
      - CONSUL_BOOTSTRAP_EXPECT=3
      - CONSUL_CLIENT_LAN_ADDRESS=0.0.0.0
      - CONSUL_DISABLE_KEYRING_FILE=true
      - CONSUL_RETRY_JOIN_ADDRESS=consul-node1
      - CONSUL_ENABLE_UI=false
    volumes:
      - consul-node3-data:/bitnami

volumes:
  consul-node1-data:
    driver: local
  consul-node2-data:
    driver: local
  consul-node3-data:
    driver: local
```

启动集群：
```console
docker-compose up -d
```


### 配置说明

#### 环境变量

##### 可自定义环境变量
| 变量名                          | 描述                                   | 默认值       |
|---------------------------------|----------------------------------------|--------------|
| `CONSUL_RPC_PORT_NUMBER`        | RPC 端口号                             | `8300`       |
| `CONSUL_HTTP_PORT_NUMBER`       | HTTP API/UI 端口号                     | `8500`       |
| `CONSUL_HTTPS_PORT_NUMBER`      | HTTPS 端口号（-1 表示禁用）            | `-1`         |
| `CONSUL_DNS_PORT_NUMBER`        | DNS 端口号                             | `8600`       |
| `CONSUL_AGENT_MODE`             | 代理模式（`server` 或 `client`）       | `server`     |
| `CONSUL_DISABLE_KEYRING_FILE`   | 禁用密钥环文件                         | `false`      |
| `CONSUL_SERF_LAN_ADDRESS`       | LAN Serf 绑定地址                      | `0.0.0.0`    |
| `CONSUL_SERF_LAN_PORT_NUMBER`   | LAN Serf 端口号                        | `8301`       |
| `CONSUL_CLIENT_LAN_ADDRESS`     | 客户端 HTTP/DNS 绑定地址               | `0.0.0.0`    |
| `CONSUL_RETRY_JOIN_ADDRESS`     | 集群加入地址（LAN）                    | `127.0.0.1`  |
| `CONSUL_RETRY_JOIN_WAN_ADDRESS` | 跨数据中心加入地址（WAN）              | `127.0.0.1`  |
| `CONSUL_BIND_INTERFACE`         | 绑定网络接口（如 `eth0`）              | `nil`        |
| `CONSUL_BIND_ADDR`              | 绑定 IP 地址（覆盖接口配置）           | `nil`        |
| `CONSUL_ENABLE_UI`              | 启用 UI                                | `true`       |
| `CONSUL_BOOTSTRAP_EXPECT`       | 集群启动期望节点数（仅 server 模式）   | `1`          |
| `CONSUL_RAFT_MULTIPLIER`        | Raft 选举超时乘数                      | `1`          |
| `CONSUL_LOCAL_CONFIG`           | JSON 格式的本地配置（覆盖默认）        | `nil`        |
| `CONSUL_GOSSIP_ENCRYPTION`       | 是否启用 Gossip 加密（`yes`/`no`）     | `no`         |
| `CONSUL_GOSSIP_ENCRYPTION_KEY`  | Gossip 加密密钥（Base64 编码 16 字节） | `nil`        |
| `CONSUL_DATACENTER`             | 数据中心名称                           | `dc1`        |
| `CONSUL_DOMAIN`                 | DNS 域名                               | `consul`     |
| `CONSUL_NODE_NAME`              | 节点名称                               | `nil`（自动生成）|
| `CONSUL_DISABLE_HOST_NODE_ID`   | 禁用基于主机的节点 ID                  | `true`       |

##### 只读环境变量（内部使用）
| 变量名                          | 描述                                   | 值                                      |
|---------------------------------|----------------------------------------|-----------------------------------------|
| `CONSUL_BASE_DIR`               | 安装目录                               | `${BITNAMI_ROOT_DIR}/consul`            |
| `CONSUL_CONF_DIR`               | 配置目录                               | `${CONSUL_BASE_DIR}/conf`               |
| `CONSUL_CONF_FILE`              | 主配置文件                             | `${CONSUL_CONF_DIR}/consul.json`        |
| `CONSUL_DATA_DIR`               | 数据存储目录                           | `${CONSUL_VOLUME_DIR}`                  |
| `CONSUL_VOLUME_DIR`             | 持久化卷挂载点                        | `/bitnami/consul`                       |


#### 自定义配置文件

##### 通过环境变量注入配置
使用 `CONSUL_LOCAL_CONFIG` 传入 JSON 配置，覆盖默认设置：
```console
docker run -e CONSUL_LOCAL_CONFIG='{
  "datacenter": "us_west",
  "server": true,
  "enable_debug": true
}' --name consul bitnami/consul:latest
```

##### 挂载配置文件
将自定义配置文件挂载到 `/opt/bitnami/consul/conf` 目录（容器内路径）：
```yaml
# docker-compose.yml 示例
services:
  consul:
    image: docker.xuanyuan.run/bitnami/consul:latest
    volumes:
      - ./local/conf:/opt/bitnami/consul/conf  # 本地配置目录挂载
```
> 配置文件需命名为 `.json` 或 `.hcl`，Consul 会按字母顺序加载所有文件。


#### 配置 Gossip 加密
Gossip 加密用于保护集群内节点通信，需生成 16 字节 Base64 密钥：

1. 生成密钥：
   ```console
   docker run --rm docker.xuanyuan.run/bitnami/consul:latest consul keygen
   ```
   输出示例：`jH8t9eXz0aB1cD2eF3gH4iJ5kL6mN7oP8qR9sT0uV`

2. 启动容器时传入密钥：
   ```console
   docker run -e CONSUL_GOSSIP_ENCRYPTION=yes -e CONSUL_GOSSIP_ENCRYPTION_KEY=jH8t9eXz0aB1cD2eF3gH4iJ5kL6mN7oP8qR9sT0uV --name consul docker.xuanyuan.run/bitnami/consul:latest
   ```


#### FIPS 配置（仅安全镜像）
Bitnami 安全镜像支持 FIPS 模式，通过环境变量控制：
- `OPENSSL_FIPS`：是否启用 OpenSSL FIPS 模式（`yes`/`no`，默认 `yes`）。


### 日志管理
容器日志输出到 `stdout`，可通过 `docker logs` 查看：
```console
docker logs consul  # 查看单个容器日志
docker-compose logs consul  # Docker Compose 日志
```

配置日志驱动（如 JSON 文件、ELK 等）：
```console
docker run --log-driver json-file --log-opt max-size=10m --name consul bitnami/consul:latest
```


### 维护与升级

#### 升级镜像
1. 拉取最新镜像：
   ```console
   docker pull docker.xuanyuan.run/bitnami/consul:latest
   ```

2. 停止并备份当前容器（假设使用卷挂载持久化）：
   ```console
   docker stop consul
   rsync -a /path/to/consul-data /path/to/consul-data.bkp.$(date +%Y%m%d)  # 备份数据
   ```

3. 删除旧容器并启动新容器：
   ```console
   docker rm consul
   docker run -v /path/to/consul-data:/bitnami --name consul docker.xuanyuan.run/bitnami/consul:latest
   ```


## 变更记录

### 重要版本变更
- **Debian 1.6.1-r6 / Oracle 1.6.1-r7**：减小镜像体积，配置逻辑迁移至 Bash 脚本；环境变量重命名（兼容旧变量）：
  - `CONSUL_UI` → `CONSUL_ENABLE_UI`
  - `CONSUL_SERVER_MODE` → `CONSUL_AGENT_MODE`
  - `CONSUL_RETRY_JOIN` → `CONSUL_RETRY_JOIN_ADDRESS`

- **1.4.0-r16**：迁移至非 root 用户（UID 1001），数据目录需确保该用户有读写权限。


## Kubernetes 部署
推荐使用 Bitnami Helm Chart 部署到 Kubernetes：
```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-consul bitnami/consul
```
详细文档见 [Bitnami Consul Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/consul)。


## 问题反馈与贡献
- **问题报告**：通过 [GitHub Issues](https://github.com/bitnami/containers/issues/new/choose) 提交。
- **贡献代码**： Fork 仓库后提交 [Pull Request](https://
