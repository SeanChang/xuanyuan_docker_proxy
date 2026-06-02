---
image: bitnami/neo4j
description: "Bitnami提供的安全镜像，用于运行Neo4j图数据库，具备安全加固特性，支持高效部署与使用。"
source: https://xuanyuan.cloud/zh/r/bitnami/neo4j
canonical: https://xuanyuan.cloud/zh/r/bitnami/neo4j
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/neo4j" title="bitnami/neo4j Docker 镜像中文简介、标签列表与拉取命令">bitnami/neo4j — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/neo4j" title="bitnami/neo4j Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/neo4j</a>

# Bitnami Neo4j 镜像文档

## 镜像概述和主要用途

Neo4j 是一个高性能的图形数据库，具备成熟稳健数据库的所有特性，如友好的查询语言和ACID事务支持。Bitnami Neo4j 镜像提供了一个预先配置、随时可用的 Neo4j 部署方案，适用于开发和生产环境。

[Neo4j 官方网站](https://www.neo4j.org/)

**商标说明**：本软件列表由 Bitnami 打包。所提及的 respective 商标归各自公司所有，使用这些商标并不意味着任何关联或认可。

## 核心功能和特性

### Neo4j 核心功能
- 高性能图形数据存储和处理
- Cypher 查询语言支持
- ACID 事务保证
- 高可用性和水平扩展能力
- 丰富的索引功能和查询优化

### Bitnami 镜像特性
- 安全优化的容器配置
- 简化的部署和配置流程
- 非 root 用户运行，增强安全性
- 预配置的持久化存储
- 支持环境变量自定义配置
- 集成 APOC 库，增强数据处理能力

### Bitnami 安全镜像优势
- 构建安全且企业就绪的开源软件容器
- 更快地分类安全漏洞，通过行业标准 VEX/KEV 提供 CVE 风险透明度
- 使用最小化操作系统 (Photon Linux)，减少攻击面同时保持可扩展性
- 持续构建的镜像，在上游补丁发布后数小时内更新
- 跨平台一致性，Bitnami 容器、虚拟机和云镜像使用相同的组件和配置方法
- 提供签名验证、SBOM、病毒扫描报告等元数据，符合 SLSA-3 标准

## 使用场景和适用范围

- 社交网络分析和推荐系统
- 知识图谱构建和查询
- 欺诈检测和风险管理
- 网络和IT基础设施监控
- 路径查找和路由优化
- 开发和测试环境中的图形数据库需求
- 生产环境中的企业级图形数据应用

## 快速入门

```console
docker run --name neo4j bitnami/neo4j:latest
```

默认凭据和可用配置选项详见[环境变量](#环境变量)部分。

## 获取镜像

推荐通过 Docker Hub Registry 获取 Bitnami Neo4j Docker 镜像：

```console
docker pull bitnami/neo4j:latest
```

如需使用特定版本，可拉取带版本标签的镜像。可在 [Docker Hub Registry](https://hub.docker.com/r/bitnami/neo4j/tags/) 查看可用版本列表。

```console
docker pull bitnami/neo4j:[TAG]
```

也可通过克隆仓库自行构建镜像：

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

> 请将上述命令中的 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 占位符替换为正确的值。

## 部署方案示例

### 使用 Docker Run 部署

```console
docker run -d \
  --name neo4j \
  -p 7474:7474 \
  -p 7473:7473 \
  -p 7687:7687 \
  -e NEO4J_PASSWORD=mysecretpassword \
  -v /path/to/neo4j-data:/bitnami \
  bitnami/neo4j:latest
```

### 使用 Docker Compose 部署

创建 `docker-compose.yml` 文件：

```yaml
version: '2'

services:
  neo4j:
    image: bitnami/neo4j:latest
    ports:
      - 7474:7474
      - 7473:7473
      - 7687:7687
    environment:
      - NEO4J_PASSWORD=mysecretpassword
      - NEO4J_HTTPS_ENABLED=true
    volumes:
      - neo4j_data:/bitnami
    networks:
      - neo4j_network

networks:
  neo4j_network:
    driver: bridge

volumes:
  neo4j_data:
    driver: local
```

启动服务：

```console
docker-compose up -d
```

## 持久化数据

若删除容器，所有数据和配置将丢失。为避免数据丢失，应挂载卷以持久化数据，即使容器被删除后数据也能保留。

应在 `/bitnami` 路径挂载卷。以下示例定义了一个名为 `neo4j_data` 的 Docker 卷，Neo4j 应用状态将在此卷中持久保存。

### 使用主机目录挂载

```console
docker run -v /path/to/neo4j-persistence:/bitnami bitnami/neo4j:latest
```

### 使用 Docker Compose 挂载

修改 `docker-compose.yml` 文件：

```yaml
neo4j:
  ...
  volumes:
    - /path/to/neo4j-persistence:/bitnami
  ...
```

> **注意**：由于这是一个非 root 容器，挂载的文件和目录必须对 UID `1001` 具有适当的权限。

## 网络配置

### 连接到其他容器

利用 Docker 容器网络，一个容器中运行的服务可以轻松被其他应用容器访问，反之亦然。连接到同一网络的容器可以使用容器名称作为主机名进行通信。

#### 使用命令行

**步骤 1：创建网络**

```console
docker network create neo4j-network --driver bridge
```

**步骤 2：在网络中启动 Neo4j 容器**

使用 `--network <NETWORK>` 参数将容器附加到 `neo4j-network` 网络：

```console
docker run --name neo4j-node1 --network neo4j-network bitnami/neo4j:latest
```

**步骤 3：运行其他容器**

在 `docker run` 命令中使用相同的 `--network NETWORK` 标志启动其他容器。如果为容器设置了名称，则可以在网络中用作主机名。

#### 使用 Docker Compose

Docker Compose 默认会自动设置一个新网络并将所有部署的服务附加到该网络。以下是显式定义网络的示例：

```yaml
version: '2'

networks:
  neo4j-network:
    driver: bridge

services:
  neo4j:
    image: bitnami/neo4j:latest
    networks:
      - neo4j-network
    ports:
      - 7474:7474
      - 7473:7473
      - 7687:7687
```

启动容器：

```console
docker-compose up -d
```

## 配置说明

### 环境变量

#### 可自定义环境变量

| 名称                                      | 描述                                                                 | 默认值                     |
|-------------------------------------------|----------------------------------------------------------------------|---------------------------|
| `NEO4J_HOST`                              | 用于配置 Neo4j 广播地址的主机名，可以是 IP 或域名                      | `nil`                     |
| `NEO4J_BIND_ADDRESS`                      | Neo4j 绑定地址                                                       | `0.0.0.0`                 |
| `NEO4J_ALLOW_UPGRADE`                     | 允许自动模式升级                                                     | `true`                    |
| `NEO4J_PASSWORD`                          | Neo4j 密码                                                           | `bitnami1`                |
| `NEO4J_APOC_IMPORT_FILE_ENABLED`          | 允许使用 apoc 库导入文件                                             | `true`                    |
| `NEO4J_APOC_IMPORT_FILE_USE_NEO4J_CONFIG` | 对 apoc 库使用 neo4j 配置                                            | `false`                   |
| `NEO4J_BOLT_PORT_NUMBER`                  | Bolt 协议使用的端口                                                  | `7687`                    |
| `NEO4J_HTTP_PORT_NUMBER`                  | HTTP 协议使用的端口                                                  | `7474`                    |
| `NEO4J_HTTPS_PORT_NUMBER`                 | HTTPS 协议使用的端口                                                 | `7473`                    |
| `NEO4J_BOLT_ADVERTISED_PORT_NUMBER`       | Bolt 协议的广播端口                                                  | `$NEO4J_BOLT_PORT_NUMBER` |
| `NEO4J_HTTP_ADVERTISED_PORT_NUMBER`       | HTTP 协议的广播端口                                                  | `$NEO4J_HTTP_PORT_NUMBER` |
| `NEO4J_HTTPS_ADVERTISED_PORT_NUMBER`      | HTTPS 协议的广播端口                                                 | `$NEO4J_HTTPS_PORT_NUMBER`|
| `NEO4J_HTTPS_ENABLED`                     | 启用 HTTPS 连接器                                                    | `false`                   |
| `NEO4J_BOLT_TLS_LEVEL`                    | Bolt 连接器的加密级别，允许值：REQUIRED, OPTIONAL, DISABLED          | `DISABLED`                |

#### 只读环境变量

| 名称                        | 描述                                                                 | 值                                  |
|-----------------------------|----------------------------------------------------------------------|------------------------------------|
| `NEO4J_BASE_DIR`            | Neo4j 安装目录                                                       | `${BITNAMI_ROOT_DIR}/neo4j`        |
| `NEO4J_VOLUME_DIR`          | Neo4j 卷目录                                                         | `/bitnami/neo4j`                   |
| `NEO4J_DATA_DIR`            | Neo4j 数据目录                                                       | `$NEO4J_VOLUME_DIR/data`           |
| `NEO4J_RUN_DIR`             | Neo4j 临时目录                                                       | `${NEO4J_BASE_DIR}/run`            |
| `NEO4J_LOGS_DIR`            | Neo4j 日志目录                                                       | `${NEO4J_BASE_DIR}/logs`           |
| `NEO4J_LOG_FILE`            | Neo4j 日志文件                                                       | `${NEO4J_LOGS_DIR}/neo4j.log`      |
| `NEO4J_PID_FILE`            | Neo4j PID 文件                                                      | `${NEO4J_RUN_DIR}/neo4j.pid`       |
| `NEO4J_CONF_DIR`            | Neo4j 配置目录                                                       | `${NEO4J_BASE_DIR}/conf`           |
| `NEO4J_DEFAULT_CONF_DIR`    | Neo4j 默认配置目录                                                   | `${NEO4J_BASE_DIR}/conf.default`   |
| `NEO4J_PLUGINS_DIR`         | Neo4j 插件目录                                                       | `${NEO4J_BASE_DIR}/plugins`        |
| `NEO4J_METRICS_DIR`         | Neo4j 指标目录                                                       | `${NEO4J_VOLUME_DIR}/metrics`      |
| `NEO4J_CERTIFICATES_DIR`    | Neo4j 证书目录                                                       | `${NEO4J_VOLUME_DIR}/certificates` |
| `NEO4J_IMPORT_DIR`          | Neo4j 导入目录                                                       | `${NEO4J_VOLUME_DIR}/import`       |
| `NEO4J_MOUNTED_CONF_DIR`    | Neo4j 挂载配置目录                                                   | `${NEO4J_VOLUME_DIR}/conf/`        |
| `NEO4J_MOUNTED_PLUGINS_DIR` | Neo4j 挂载插件目录                                                   | `${NEO4J_VOLUME_DIR}/plugins/`     |
| `NEO4J_INITSCRIPTS_DIR`     | Neo4j 初始化脚本目录                                                 | `/docker-entrypoint-initdb.d`      |
| `NEO4J_CONF_FILE`           | Neo4j 配置文件                                                       | `${NEO4J_CONF_DIR}/neo4j.conf`     |
| `NEO4J_APOC_CONF_FILE`      | Neo4j APOC 配置文件                                                  | `${NEO4J_CONF_DIR}/apoc.conf`      |
| `NEO4J_DAEMON_USER`         | Neo4j 系统用户                                                       | `neo4j`                            |
| `NEO4J_DAEMON_GROUP`        | Neo4j 系统组                                                        | `neo4j`                            |
| `JAVA_HOME`                 | Java 安装目录                                                        | `${BITNAMI_ROOT_DIR}/java`         |

#### 设置环境变量的方法

启动 Neo4j 镜像时，可以通过 Docker Compose 文件或 `docker run` 命令行传递一个或多个环境变量来调整实例配置。

**使用 Docker Compose 指定环境变量**

修改 `docker-compose.yml` 文件：

```yaml
neo4j:
  ...
  environment:
    - NEO4J_BOLT_PORT_NUMBER=7777
  ...
```

**使用 Docker 命令行指定环境变量**

```console
docker run -d -e NEO4J_BOLT_PORT_NUMBER=7777 --name neo4j bitnami/neo4j:latest
```

### 使用自定义配置文件

要加载自己的配置文件，需要将其挂载到容器中 `/bitnami/neo4j/conf` 目录。

**使用 Docker Compose**

修改 `docker-compose.yml` 文件：

```yaml
neo4j:
  ...
  volumes:
    - /local/path/to/your/confDir:/bitnami/neo4j/conf
  ...
```

### 添加额外的 Neo4j 插件

要添加额外的插件，需要将其挂载到容器中 `/bitnami/neo4j/plugins` 目录。

**使用 Docker Compose 添加插件**

修改 `docker-compose.yml` 文件：

```yaml
neo4j:
  ...
  volumes:
    - /local/path/to/your/plugins:/bitnami/neo4j/plugins
  ...
```

### Bitnami 安全镜像中的 FIPS 配置

Bitnami 安全镜像提供额外功能和设置来配置具有 FIPS 功能的容器。可配置以下环境变量：

- `OPENSSL_FIPS`：OpenSSL 是否运行在 FIPS 模式。值：`yes`（默认）、`no`。

## 日志管理

Bitnami neo4j Docker 镜像将容器日志发送到 `stdout`。查看日志：

```console
docker logs neo4j
```

或使用 Docker Compose：

```console
docker-compose logs neo4j
```

如果希望以不同方式处理容器日志，可以使用 `--log-driver` 选项配置容器[日志驱动程序](https://docs.docker.com/engine/admin/logging/overview/)。默认配置下，Docker 使用 `json-file` 驱动程序。

## 维护与升级

### 升级镜像

Bitnami 会尽快提供包含安全补丁的最新版本 neo4j。建议按照以下步骤升级容器：

**步骤 1：获取更新的镜像**

```console
docker pull bitnami/neo4j:latest
```

如果使用 Docker Compose，将 image 属性的值更新为 `bitnami/neo4j:latest`。

**步骤 2：停止并备份当前运行的容器**

使用以下命令停止当前运行的容器：

```console
docker stop neo4j
```

或使用 Docker Compose：

```console
docker-compose stop neo4j
```

接下来，使用以下命令对持久卷 `/path/to/neo4j-persistence` 进行快照：

```console
rsync -a /path/to/neo4j-persistence /path/to/neo4j-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

如果升级失败，可以使用此快照恢复数据库状态。

**步骤 3：删除当前运行的容器**

```console
docker rm -v neo4j
```

或使用 Docker Compose：

```console
docker-compose rm -v neo4j
```

**步骤 4：运行新镜像**

从新镜像重新创建容器，必要时恢复备份：

```console
docker run --name neo4j bitnami/neo4j:latest
```

或使用 Docker Compose：

```console
docker-compose up neo4j
```

## 版本变更记录

### 4.3.0-debian-10-r17

- 减小容器大小。配置逻辑现在基于 `rootfs/` 文件夹中的 Bash 脚本。此外，容器现在默认启用了最新稳定版本的 [apoc 库](https://github.com/neo4j-contrib/neo4j-apoc-procedures)。

- 配置文件不再持久化，因此建议删除 `/bitnami/neo4j/conf/` 中的持久化文件，以避免潜在的升级问题。

### 3.4.3-r13

- Neo4j 容器已迁移到非 root 用户方案。以前，容器以 `root` 用户身份运行，Neo4j 守护进程以 `neo4j` 用户身份启动。从现在开始，容器和 Neo4j 守护进程都以用户 `1001` 运行。因此，数据目录必须可由该用户写入。可以通过将 Dockerfile 中的 `USER 1001` 更改为 `USER root` 来恢复此行为。

## 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将改进其公共目录，在新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)下提供精选的强化、安全聚焦的镜像。作为此过渡的一部分：

- 首次向社区用户授予对流行容器镜像的安全优化版本的访问权限。
- Bitnami 将开始在其免费层中弃用对非强化、基于 Debian 的软件镜像的支持，并将逐步从公共目录中删除非最新标签。因此，社区用户将只能
