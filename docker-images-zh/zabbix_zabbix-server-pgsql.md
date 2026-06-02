---
image: zabbix/zabbix-server-pgsql
description: "支持PostgreSQL数据库的Zabbix服务器镜像，用于部署和运行Zabbix监控系统。"
source: https://xuanyuan.cloud/zh/r/zabbix/zabbix-server-pgsql
canonical: https://xuanyuan.cloud/zh/r/zabbix/zabbix-server-pgsql
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zabbix/zabbix-server-pgsql" title="zabbix/zabbix-server-pgsql Docker 镜像中文简介、标签列表与拉取命令">zabbix/zabbix-server-pgsql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

![logo](https://assets.zabbix.com/img/logo/zabbix_logo_500x131.png)

# Zabbix Server (PostgreSQL) 镜像文档

## 1. 镜像概述和主要用途

### 1.1 Zabbix简介
Zabbix是企业级开源分布式监控解决方案，可监控网络参数、服务器健康状态及完整性。其灵活的通知机制允许用户为几乎任何事件配置基于电子邮件的告警，实现对服务器问题的快速响应。Zabbix还提供基于存储数据的报告和数据可视化功能，适用于容量规划。

### 1.2 Zabbix Server简介
Zabbix Server是Zabbix软件的核心进程，负责数据轮询与陷阱接收、触发器计算、向用户发送通知。它是Zabbix Agent和Proxy报告系统可用性与完整性数据的中心组件，还可通过简单服务检查远程监控网络服务（如Web服务器、邮件服务器）。

### 1.3 镜像概述
本镜像为官方Zabbix Server Docker镜像，基于PostgreSQL数据库，支持Alpine Linux v3.22、Ubuntu 24.04 (noble)、CentOS Stream 10及Oracle Linux 10。镜像启动时会自动执行以下流程：
- 检查数据库可用性
- 检查`POSTGRES_DB`数据库是否存在，不存在则创建
- 检查`dbversion`表是否存在，不存在则创建Zabbix Server数据库 schema 并初始化数据样本


## 2. 核心功能和特性

- **数据采集**：支持轮询（主动检查）和陷阱（被动接收）两种数据采集模式
- **触发器与告警**：实时计算触发器状态，支持多级别告警通知（邮件、短信等）
- **数据库集成**：自动初始化PostgreSQL数据库，支持数据库高可用配置（如PgBouncer）
- **扩展能力**：支持加载自定义模块（`LoadModule`）、外部脚本和告警脚本
- **多平台支持**：基于Alpine、Ubuntu、Oracle Linux等多种基础镜像，适应不同环境需求
- **安全特性**：支持TLS加密通信，支持通过文件或Docker Secrets管理敏感信息（如数据库密码）


## 3. 使用场景和适用范围

- **企业级监控**：监控大规模服务器集群、网络设备、应用服务的可用性与性能
- **IT基础设施监控**：监控CPU、内存、磁盘、网络等系统资源，及时发现瓶颈
- **业务服务监控**：通过HTTP、数据库查询等方式监控Web服务、数据库服务等业务组件
- **容量规划**：基于历史数据趋势分析，预测资源需求，支持扩容决策
- **DevOps环境**：与容器化部署流程集成，快速搭建监控环境，支持CI/CD流水线


## 4. 使用方法和配置说明

### 4.1 快速启动Zabbix Server

#### 基本启动命令
```bash
docker run --name some-zabbix-server-pgsql \
  -e DB_SERVER_HOST="some-postgres-server" \
  -e POSTGRES_USER="some-user" \
  -e POSTGRES_PASSWORD="some-password" \
  --init -d zabbix/zabbix-server-pgsql:tag
```

**参数说明**：
- `some-zabbix-server-pgsql`：容器名称
- `some-postgres-server`：PostgreSQL服务器IP或DNS名称
- `some-user`：PostgreSQL数据库用户名
- `some-password`：PostgreSQL数据库密码
- `tag`：指定镜像版本（如`alpine-7.4-latest`，完整标签列表见[Docker Hub](https://hub.docker.com/r/zabbix/zabbix-server-pgsql/tags/)）

> **注意**：Zabbix Server依赖`fping`工具执行ICMP检查。若容器以rootless模式或受限环境运行，可能出现`fping: Operation not permitted`错误，需添加`--cap-add=net_raw`参数。非root环境还需修改sysctl：`net.ipv4.ping_group_range=0 1995`（1995为zabbix用户GID）。

#### Docker Compose示例
```yaml
version: '3.8'
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: zabbix
      POSTGRES_PASSWORD: zabbix
      POSTGRES_DB: zabbix
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: always

  zabbix-server:
    image: zabbix/zabbix-server-pgsql:alpine-7.4-latest
    environment:
      DB_SERVER_HOST: postgres
      POSTGRES_USER: zabbix
      POSTGRES_PASSWORD: zabbix
      POSTGRES_DB: zabbix
      ZBX_STARTPOLLERS: 10
      ZBX_CACHESIZE: 64M
    ports:
      - "10051:10051"
    depends_on:
      - postgres
    restart: always

volumes:
  postgres-data:
```

### 4.2 容器访问与日志查看

#### 进入容器Shell
```bash
docker exec -ti some-zabbix-server-pgsql /bin/bash
```

#### 查看Zabbix Server日志
```bash
docker logs some-zabbix-server-pgsql
```

### 4.3 环境变量配置

Zabbix Server支持通过环境变量调整配置，以下为核心变量说明：

#### 数据库连接参数
| 变量名                          | 用途                                  | 默认值       |
|---------------------------------|---------------------------------------|--------------|
| `DB_SERVER_HOST`                | PostgreSQL服务器IP或DNS名称           | postgres-server |
| `DB_SERVER_PORT`                | PostgreSQL服务器端口                  | 5432         |
| `POSTGRES_USER`                 | 数据库用户名                          | zabbix       |
| `POSTGRES_PASSWORD`             | 数据库密码                            | zabbix       |
| `POSTGRES_USER_FILE`            | 存储数据库用户名的文件路径（替代`POSTGRES_USER`） | - |
| `POSTGRES_PASSWORD_FILE`        | 存储数据库密码的文件路径（替代`POSTGRES_PASSWORD`） | - |
| `POSTGRES_DB`                   | Zabbix数据库名称                      | zabbix       |
| `POSTGRES_USE_IMPLICIT_SEARCH_PATH` | 禁用显式设置search_path（适配PgBouncer等场景） | false |

#### 敏感信息管理（通过Docker Secrets）
**创建Secrets**：
```bash
printf "zabbix" | docker secret create POSTGRES_USER -
printf "zabbix" | docker secret create POSTGRES_PASSWORD -
```

**使用Secrets启动容器**：
```bash
docker run --name some-zabbix-server-pgsql \
  -e DB_SERVER_HOST="some-postgres-server" \
  -e POSTGRES_USER_FILE=/run/secrets/POSTGRES_USER \
  -e POSTGRES_PASSWORD_FILE=/run/secrets/POSTGRES_PASSWORD \
  --init -d zabbix/zabbix-server-pgsql:tag
```

#### 核心服务配置参数
| 变量名                          | 用途                                  | 默认值       |
|---------------------------------|---------------------------------------|--------------|
| `ZBX_LISTENPORT`                | 服务监听端口                          | 10051        |
| `ZBX_STARTPOLLERS`              | 轮询进程数                            | 5            |
| `ZBX_STARTPINGERS`              | ICMP Ping进程数                       | 1            |
| `ZBX_CACHESIZE`                 | 配置缓存大小                          | 8M           |
| `ZBX_HISTORYCACHESIZE`          | 历史数据缓存大小                      | 16M          |
| `ZBX_DEBUGLEVEL`                | 调试级别（0-5，0=基本信息，5=详细调试） | 3            |
| `ZBX_JAVAGATEWAY_ENABLE`        | 是否启用Java Gateway                  | false        |
| `ZBX_JAVAGATEWAY`               | Java Gateway地址                      | zabbix-java-gateway |
| `ZBX_ENABLE_SNMP_TRAPS`         | 是否启用SNMP Trap接收                 | false        |

> **完整变量列表**：所有变量与`zabbix_server.conf`配置参数对应，例如`ZBX_LOGSLOWQUERIES`对应`LogSlowQueries`，详细说明见[官方文档](https://www.zabbix.com/documentation/current/manual/appendix/config/zabbix_server)。

### 4.4 卷挂载配置

Zabbix Server支持以下卷挂载，用于扩展功能或持久化数据：

| 卷路径                          | 用途                                  | 对应配置参数       |
|---------------------------------|---------------------------------------|--------------------|
| `/usr/lib/zabbix/alertscripts`  | 自定义告警脚本目录                    | `AlertScriptsPath` |
| `/usr/lib/zabbix/externalscripts` | 外部检查脚本目录                      | `ExternalScripts`  |
| `/var/lib/zabbix/modules`       | 自定义模块目录（用于`LoadModule`）    | -                  |
| `/var/lib/zabbix/enc`           | TLS证书文件目录（如CA、证书、密钥）   | `TLSCAFile`等      |
| `/var/lib/zabbix/ssh_keys`      | SSH检查/动作的密钥文件目录            | `SSHKeyLocation`   |
| `/var/lib/zabbix/snmptraps`     | SNMP Trap日志文件目录（需与`snmptraps`容器共享） | - |
| `/var/lib/zabbix/mibs`          | SNMP MIB文件目录（不支持子目录）      | -                  |
| `/var/lib/zabbix/export`        | 实时数据导出目录（事件、历史数据JSON） | `ExportFileSize`   |

**示例：挂载告警脚本卷**
```bash
docker run --name some-zabbix-server-pgsql \
  -v /host/alertscripts:/usr/lib/zabbix/alertscripts \
  -e DB_SERVER_HOST="some-postgres-server" \
  --init -d zabbix/zabbix-server-pgsql:tag
```


## 5. 镜像版本与变体

### 5.1 支持的Zabbix版本
| Zabbix版本 | 标签示例（Alpine/Ubuntu/Oracle Linux）          |
|------------|------------------------------------------------|
| 6.0        | `alpine-6.0-latest`, `ubuntu-6.0-latest`       |
| 7.0        | `alpine-7.0-latest`, `ol-7.0-latest`           |
| 7.2        | `alpine-7.2-latest`, `ubuntu-7.2-latest`       |
| 7.4（最新）| `alpine-latest`, `ubuntu-latest`, `latest`     |
| 8.0（开发版）| `alpine-trunk`, `ubuntu-trunk`                 |

> **说明**：`latest`标签默认基于Alpine Linux，镜像会随Zabbix新版本发布自动更新。

### 5.2 镜像变体

#### `alpine-<version>`
基于Alpine Linux，镜像体积最小（约5MB基础镜像），适合对镜像大小敏感的场景。使用musl libc替代glibc，部分依赖glibc的软件可能存在兼容性问题。

#### `ubuntu-<version>`
基于Ubuntu 24.04，兼容性好，包含更多系统工具，适合需要复杂依赖的场景。

#### `ol-<version>`
基于Oracle Linux 10，适合Oracle生态环境，支持Ksplice（零停机内核更新）、DTrace等企业级特性。


## 6. 支持的Docker版本
官方支持Docker 1.12.0及以上版本，1.6-1.11版本提供有限支持。建议通过[Docker官方文档](https://docs.docker.com/installation/)升级Docker引擎。


## 7. 已知问题与限制
- **Alpine版本Jabber通知支持**：Alpine镜像不支持Jabber通知，因`iksemel`包仅在Alpine测试仓库中可用。
- **rootless模式ICMP检查**：rootless模式下需添加`--cap-add=net_raw`权限，并调整sysctl（`net.ipv4.ping_group_range=0 1995`）以支持`fping`。


## 8. 用户反馈与支持

### 8.1 文档
镜像详细文档存储于[GitHub仓库](https://github.com/zabbix/zabbix-docker/tree/trunk/Dockerfiles/server-pgsql)。

### 8.2 问题反馈
如有问题，可通过[GitHub Issues](https://github.com/zabbix/zabbix-docker/issues)提交。

### 8.3 贡献
欢迎通过Pull Request贡献代码，建议先通过GitHub Issues讨论重大功能变更。

### 8.4 许可
- Zabbix 7.0及以上版本：GNU Affero General Public License v3 (AGPLv3)
- Zabbix 6.4及以下版本：GNU General Public License v2 (GPLv2)

详细许可条款见[FSF官方文档](http://www.fsf.org/licenses/)。
