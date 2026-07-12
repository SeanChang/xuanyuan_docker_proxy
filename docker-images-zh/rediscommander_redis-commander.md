---
image: rediscommander/redis-commander
description: "基于Alpine的redis-commander镜像，提供Redis数据库的Web管理工具，支持多种数据类型操作和多服务器管理。"
source: https://xuanyuan.cloud/zh/r/rediscommander/redis-commander
canonical: https://xuanyuan.cloud/zh/r/rediscommander/redis-commander
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rediscommander/redis-commander" title="rediscommander/redis-commander Docker 镜像中文简介、标签列表与拉取命令">rediscommander/redis-commander 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Redis Commander

Redis Commander 是一个用 Node.js 编写的 Redis Web 管理工具，提供直观的图形界面用于管理 Redis 服务器数据。

## 镜像概述和主要用途

本镜像是基于 Alpine 系统构建的 redis-commander 应用，旨在提供轻量级、易部署的 Redis 可视化管理解决方案。通过 Web 界面，用户可以方便地连接、监控和管理一个或多个 Redis 服务器，支持多种数据类型的查看、添加、更新和删除操作，适用于开发、测试和生产环境中的 Redis 实例管理。

## 核心功能和特性

- **多服务器管理**：支持同时连接和管理多个不同的 Redis 服务器
- **数据类型支持**：
  * Strings（字符串）：完全支持查看、添加、更新和删除
  * Lists（列表）：完全支持查看、添加、更新和删除
  * Sets（集合）：完全支持查看、添加、更新和删除
  * Sorted Set（有序集合）：完全支持查看、添加、更新和删除
  * Streams（流）：基于 HFXBus 项目的基本支持，可查看、添加和删除数据
  * ReJSON 文档：基本支持，仅可查看 ReJSON 类型键的值
- **连接方式**：支持直接连接 Redis 服务器或通过 Redis 哨兵（Sentinel）间接连接
- **安全特性**：支持 HTTP 基本认证，可通过密码或密码哈希保护访问
- **灵活配置**：通过配置文件、环境变量或命令行参数进行配置

## 使用场景和适用范围

- **开发环境**：开发人员可通过图形界面快速调试和管理 Redis 数据
- **测试环境**：测试人员可直观地验证 Redis 数据操作结果
- **生产环境**：运维人员可监控 Redis 服务器状态和数据，进行必要的数据管理操作
- **多实例管理**：适用于需要同时管理多个 Redis 服务器或集群的场景

## 详细使用方法和配置说明

### 安装和运行

#### 通过 npm 安装（非 Docker 方式）

```bash
$ npm install -g redis-commander
$ redis-commander
```

> 注意：目前不支持通过 yarn 安装，请使用 npm 作为包管理器。

#### 通过 Docker 镜像运行

使用 Docker 镜像 `rediscommander/redis-commander`，具体说明见下文。

### 命令行选项

```
$ redis-commander --help
选项:
  --redis-port                         Redis服务器端口                               [string]
  --redis-host                         Redis服务器主机                               [string]
  --redis-socket                       Redis Unix套接字路径                         [string]
  --redis-password                     Redis密码                                   [string]
  --redis-db                           Redis数据库索引                               [string]
  --redis-label                        连接显示标签                                 [string]
  --redis-tls                          使用TLS连接Redis服务器或哨兵                  [boolean] [default: false]
  --redis-optional                     服务器不可用时不进行永久自动重连              [boolean] [default: false]
  --sentinel-port                      Redis哨兵端口                                 [string]
  --sentinel-host                      Redis哨兵主机                                 [string]
  --sentinels                          哨兵列表，格式为host:port的逗号分隔字符串       [string]
  --sentinel-name                      哨兵组名称                                   [string]  [default: mymaster]
  --sentinel-password                  哨兵实例密码                                 [string]
  --http-auth-username, --http-u       HTTP认证用户名                                [string]
  --http-auth-password, --http-p       HTTP认证密码                                [string]
  --http-auth-password-hash, --http-h  HTTP认证密码哈希                              [string]
  --address, -a                        服务器绑定地址                                 [string]  [default: 0.0.0.0]
  --port, -p                           服务器监听端口                                 [string]  [default: 8081]
  --url-prefix, -u                     URL前缀                                     [string]  [default: ""]
  --root-pattern, --rp                 Redis键的根模式                               [string]  [default: "*"]
  --read-only                          只读模式启动                                 [boolean] [default: false]
  --trust-proxy                        运行在代理后（启用Express "trust proxy"）      [boolean|string] [default: false]
  --nosave, --ns                       不将新连接保存到配置文件                       [boolean] [default: true]
  --noload, --nl                       不从配置文件加载连接                           [boolean] [default: false]
  --use-scan, --sc                     使用SCAN代替KEYS命令                          [boolean] [default: false]
  --clear-config, --cc                 清除配置文件
  --migrate-config                     将$HOME下的旧配置文件迁移到新格式
  --scan-count, --sc                   每次SCAN的大小                               [integer] [default: 100]
  --no-log-data                        不记录Redis存储的数据值                        [boolean] [default: false]
  --open                               自动打开浏览器访问Redis-Commander              [boolean] [default: false]
  --folding-char, --fc                 树视图中键的折叠字符                           [character] [default: ":"]
  --test, -t                           测试最终配置（文件、环境变量、命令行）
```

连接可通过直接连接 Redis 服务器或间接通过哨兵实例建立。

### 配置

Redis Commander 可通过配置文件、环境变量或命令行参数进行配置。配置值的优先级从低到高为：配置文件 < 环境变量 < 命令行参数。

#### 配置文件

使用 `node-config` 模块（https://github.com/lorenwest/node-config），默认使用 JSON 语法：

- `default.json` - 包含所有默认值，**不应修改**
- `local.json` - 可选文件，用于存储本地覆盖默认值的配置及启动时使用的 Redis 连接列表
- `local-<NODE_ENV>.json` - 仅用于存储连接信息！通过 UI 添加或删除连接时会被覆盖。在 Docker 容器中，此文件用于存储从 REDIS_HOSTS 环境变量解析的所有连接，会覆盖 `local.json` 中定义的连接

更多配置文件信息可参考 node-config 文档（https://github.com/lorenwest/node-config/wiki/Configuration-Files）。

#### 配置验证

启动时添加 `--test` 参数可检查最终配置（文件、环境变量、命令行参数），输出中会列出所有无效配置键。配置测试不会检查主机名或 IP 地址是否可解析。

更多配置信息见文档：[docs/configuration.md](docs/configuration.md) 和 [docs/connections.md](docs/connections.md)。

### 环境变量

以下环境变量可用于启动 Redis Commander（无论是普通应用还是 Docker 容器），定义在 `config/custom-environment-variables.json` 文件中：

```
HTTP_USER              - HTTP认证用户名
HTTP_PASSWORD          - HTTP认证密码
HTTP_PASSWORD_HASH     - HTTP认证密码哈希
ADDRESS                - 服务器绑定地址
PORT                   - 服务器监听端口
READ_ONLY              - 只读模式
URL_PREFIX             - URL前缀
ROOT_PATTERN           - Redis键的根模式
NOSAVE                 - 不保存新连接到配置文件
NO_LOG_DATA            - 不记录数据值
FOLDING_CHAR           - 树视图折叠字符
VIEW_JSON_DEFAULT      - 默认以JSON格式查看值
USE_SCAN               - 使用SCAN代替KEYS
SCAN_COUNT             - SCAN命令每次扫描大小
FLUSH_ON_IMPORT        - 导入时清空数据库
REDIS_CONNECTION_NAME  - Redis连接名称
REDIS_LABEL            - 连接显示标签
CLIENT_MAX_BODY_SIZE   - 客户端最大请求体大小
BINARY_AS_HEX          - 二进制数据以十六进制显示
```

### Docker 部署

所有上述环境变量均可用于 Docker 镜像，此外还有以下 Docker 特有环境变量（定义在 Docker 启动脚本中）：

```
HTTP_PASSWORD_FILE       - 包含HTTP密码的文件路径
HTTP_PASSWORD_HASH_FILE  - 包含HTTP密码哈希的文件路径
REDIS_PORT               - Redis服务器端口
REDIS_HOST               - Redis服务器主机
REDIS_SOCKET             - Redis Unix套接字路径
REDIS_TLS                - 使用TLS连接Redis
REDIS_PASSWORD           - Redis密码
REDIS_PASSWORD_FILE      - 包含Redis密码的文件路径
REDIS_DB                 - Redis数据库索引
REDIS_HOSTS              - Redis主机列表（逗号分隔）
REDIS_OPTIONAL           - 服务器不可用时不自动重连
SENTINEL_PORT            - 哨兵端口
SENTINEL_HOST            - 哨兵主机
SENTINEL_NAME            - 哨兵组名称
SENTINEL_PASSWORD        - 哨兵密码
SENTINEL_PASSWORD_FILE   - 包含哨兵密码的文件路径
SENTINELS                - 哨兵列表（host:port格式，逗号分隔）
K8S_SIGTERM              - Kubernetes SIGTERM处理（默认"0"，设为"1"以支持K8s零停机替换）
```

#### REDIS_HOSTS 格式

`REDIS_HOSTS` 环境变量是逗号分隔的主机定义列表，每个主机应遵循以下格式之一：

- `hostname`
- `label:hostname`
- `label:hostname:port`
- `label:hostname:port:dbIndex`
- `label:hostname:port:dbIndex:password`

> 注意：通过 `REDIS_HOSTS` 定义的连接不支持 TLS。如需使用 TLS 连接远程 Redis 服务器，请将连接配置写入配置文件（详见 [docs/connections.md](docs/connections.md) 中的复杂示例）。

容器启动后，Redis Commander 可通过 [localhost:8081](http://localhost:8081) 访问。

#### 使用 docker-compose

```yaml
version: '3'
services:
  redis:
    container_name: redis
    hostname: redis
    image: docker.xuanyuan.run/redis

  redis-commander:
    container_name: redis-commander
    hostname: redis-commander
    image: docker.xuanyuan.run/rediscommander/redis-commander:latest
    restart: always
    environment:
    - REDIS_HOSTS=local:redis:6379
    ports:
    - "8081:8081"
```

#### 不使用 docker-compose

##### 最简单方式

如果 Redis 运行在 `localhost:6379`，只需：

```bash
docker run --rm --name redis-commander -d \
  -p 8081:8081 \
  docker.xuanyuan.run/rediscommander/redis-commander:latest
```

##### 指定单个主机

```bash
docker run --rm --name redis-commander -d \
  --env REDIS_HOSTS=10.10.20.30 \
  -p 8081:8081 \
  docker.xuanyuan.run/rediscommander/redis-commander:latest
```

##### 指定多个带标签的主机

```bash
docker run --rm --name redis-commander -d \
  --env REDIS_HOSTS=local:localhost:6379,myredis:10.10.20.30 \
  -p 8081:8081 \
  docker.xuanyuan.run/rediscommander/redis-commander:latest
```

### Kubernetes 部署

示例部署文件见 [k8s/redis-commander/deployment.yaml](k8s/redis-commander/deployment.yaml)。

如果集群中已在默认命名空间运行 Redis，可通过 `kubectl apply -f k8s/redis-commander` 部署 Redis Commander。如未运行 Redis，可通过 `kubectl apply -f k8s/redis` 部署简单的 Redis Pod。

也可在部署规范中添加容器：

```yaml
containers:
- name: redis-commander
  image: docker.xuanyuan.run/rediscommander/redis-commander
  env:
  - name: REDIS_HOSTS
    value: instance1:redis:6379
  ports:
  - name: redis-commander
    containerPort: 8081
```

> Kubernetes 已知问题：使用 REDIS_HOSTS 仅适用于无密码的 Redis 数据库。对于密码保护的 Redis，必须指定 REDIS_HOST。

### Helm Chart

可使用 Helm 在任何 Kubernetes 集群上安装应用。目前没有 Helm 仓库，需本地检出仓库中的 Helm 源：

```bash
helm -n myspace install redis-web-ui ./k8s/helm-chart/redis-commander
```

更多关于此 Helm Chart 及其值的文档见 [k8s/helm-chart/README.md](k8s/helm-chart/README.md)。

### OpenShift V3 部署

使用 Node.js 镜像构建器：

1. 打开目录，选择 Node.js 模板
2. 指定应用名称和 [redis-commander GitHub 仓库 URL](https://github.com/joeferner/redis-commander.git)
3. 点击 "高级选项" 链接
4. （可选）指定路由主机名（如未指定将自动生成）
5. 在部署配置部分：
   * 添加 `REDIS_HOST` 环境变量，值为 Redis 服务名称（如 `redis`）
   * 添加 `REDIS_PORT` 环境变量，值为 Redis 服务暴露端口（如 `6379`）
   * 从 Redis 模板生成的密钥添加值：
     * 名称：`REDIS_PASSWORD`
     * 资源：`redis`
     * 键：`database-password`
6. （可选）指定标签（如 `appl=redis-commander-dev1`），便于后续删除：
   ```bash
   oc delete all --selector appl=redis-commander-dev1
   ```

### 辅助脚本

#### 生成 BCrypt 密码哈希

Redis Commander 支持设置明文密码或 BCrypt 密码哈希进行 HTTP 认证。可使用脚本 `bin/bcrypt-password.js` 生成哈希，需通过 `-p` 参数指定密码：

```bash
$ git clone https://github.com/joeferner/redis-commander.git
$ cd redis-commander/bin
$ node bcrypt-password.js -p myplainpass
$2b$10BQPbC8dlxeEqB/nXOkyjr.tlafGZ28J3ug8sWIMRoeq5LSVOXpl3W
```

生成的哈希可通过以下方式设置：
- 配置文件：`server.httpAuth.passwordHash`
- 环境变量：`HTTP_PASSWORD_HASH`
- 命令行：`--http-auth-password-hash`
- Docker 容器：通过 `HTTP_PASSWORD_HASH_FILE` 指定包含哈希的文件路径

### 基于此镜像构建其他镜像

如需以此镜像为基础构建其他镜像，需在 Dockerfile 中先执行 `apk update`，再添加其他 apk 包（如 `apk add foo`）。为减小镜像大小，可像本 Dockerfile 一样删除临时 apk 配置。
