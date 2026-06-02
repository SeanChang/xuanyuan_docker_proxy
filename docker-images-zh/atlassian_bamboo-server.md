---
image: atlassian/bamboo-server
description: "Atlassian Bamboo Server Docker镜像提供企业级持续集成与持续部署（CI/CD）服务，用于自动化软件构建、测试和部署流程，支持团队协作与多环境管理，助力高效交付软件项目。"
source: https://xuanyuan.cloud/zh/r/atlassian/bamboo-server
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[atlassian/bamboo-server](https://xuanyuan.cloud/zh/r/atlassian/bamboo-server)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Atlassian Bamboo Docker 镜像文档

![Atlassian Bamboo](https://wac-cdn.atlassian.com/dam/jcr:560a991e-c0e3-4014-bd7d-2e65d4e4c84a/bamboo-icon-gradient-blue.svg?cdnVersion=814)

## 镜像概述和主要用途

Bamboo 是一款持续集成和部署工具，可将自动化构建、测试和发布流程整合到单一工作流中。本 Docker 容器旨在简化 Bamboo 实例的部署和运行过程。

该 Docker 镜像同时以 `atlassian/bamboo` 和 `atlassian/bamboo-server` 名称发布，两者完全相同。`-server` 版本已弃用，仅为保持向后兼容性而保留；新安装建议使用较短名称 `atlassian/bamboo`。

> **注意**：请使用 Docker 版本 >= 20.10.10

了解更多关于 Bamboo 的信息：[https://www.atlassian.com/software/bamboo](https://www.atlassian.com/software/bamboo)


## 核心功能和特性

- **简化部署**：通过 Docker 容器快速启动 Bamboo 实例，无需复杂的环境配置
- **数据持久化**：支持通过数据卷或命名卷存储 Bamboo 数据，确保数据不丢失
- **灵活配置**：通过环境变量自定义 JVM 参数、Tomcat 配置、数据库连接等
- **反向代理支持**：可配置与反向代理服务器集成，支持 HTTPS 和自定义域名
- **数据库集成**：支持 H2、MySQL、PostgreSQL、SQL Server、Oracle 等多种数据库
- **自动配置**：支持通过环境变量预填充安装向导配置，跳过手动设置流程
- **故障诊断工具**：内置线程转储、堆转储等诊断脚本，便于问题排查


## 使用场景和适用范围

- **开发团队**：用于自动化构建、测试和部署流程，提升开发效率
- **评估环境**：快速搭建 Bamboo 评估实例，体验核心功能
- **生产环境**：通过外部数据库和共享存储配置，支持企业级部署
- **Data Center 模式**：支持多节点集群部署，需配合共享文件系统


## 详细的使用方法和配置说明

### 快速开始

`BAMBOO_HOME` 目录用于存储仓库数据及其他文件，建议通过**数据卷**或**命名卷**挂载主机目录。在 Data Center 模式下，必须挂载共享文件系统。

以下示例使用命名卷：

```bash
# 创建命名卷
$> docker volume create --name bambooVolume

# 启动 Bamboo 容器
$> docker run -v bambooVolume:/var/atlassian/application-data/bamboo \
              --name="bamboo" \
              -d \
              -p 8085:8085 \
              -p 54663:54663 \
              atlassian/bamboo
```

**成功启动**后，Bamboo 可通过 [http://localhost:8085](http://localhost:8085) 访问。

> **资源建议**：建议为容器分配至少 2GiB 内存，具体要求参见 [系统要求](https://confluence.atlassian.com/display/BAMBOO/Bamboo+Best+Practice+-+System+Requirements)。
> 
> **注意**：若在 Mac OS X 上使用 `docker-machine`，请通过 `open http://$(docker-machine ip default):8085` 访问。


### Docker Compose 部署示例

创建 `docker-compose.yml` 文件：

```yaml
version: '3'
services:
  bamboo:
    image: atlassian/bamboo
    container_name: bamboo
    ports:
      - "8085:8085"
      - "54663:54663"
    volumes:
      - bambooVolume:/var/atlassian/application-data/bamboo
    environment:
      - JVM_MINIMUM_MEMORY=1g
      - JVM_MAXIMUM_MEMORY=2g
      - ATL_PROXY_NAME=ci.example.com
      - ATL_PROXY_PORT=443
      - ATL_TOMCAT_SCHEME=https
      - ATL_TOMCAT_SECURE=true
    restart: unless-stopped

volumes:
  bambooVolume:
```

启动服务：

```bash
$> docker-compose up -d
```


### 配置参数说明

#### 内存/堆大小配置

通过以下环境变量调整 JVM 内存分配：

- `JVM_MINIMUM_MEMORY`：JVM 最小堆大小，默认 `512m`
- `JVM_MAXIMUM_MEMORY`：JVM 最大堆大小，默认 `1024m`


#### Tomcat 和反向代理设置

当 Bamboo 部署在反向代理后时，需配置以下环境变量：

| 环境变量                     | 默认值       | 说明                                                                 |
|------------------------------|--------------|----------------------------------------------------------------------|
| `ATL_PROXY_NAME`             | NONE         | 反向代理的完全限定域名（兼容 `CATALINA_CONNECTOR_PROXYNAME`）        |
| `ATL_PROXY_PORT`             | NONE         | 反向代理端口（兼容 `CATALINA_CONNECTOR_PROXYPORT`）                  |
| `ATL_TOMCAT_PORT`            | 8085         | Tomcat/Bamboo 监听端口                                               |
| `ATL_TOMCAT_SCHEME`          | http         | 访问协议（http/https，兼容 `CATALINA_CONNECTOR_SCHEME`）             |
| `ATL_TOMCAT_SECURE`          | false        | 若 `ATL_TOMCAT_SCHEME` 为 https，设为 true（兼容 `CATALINA_CONNECTOR_SECURE`） |
| `ATL_TOMCAT_CONTEXTPATH`     | NONE         | 应用上下文路径（兼容 `CATALINA_CONTEXT_PATH`）                       |

**Tomcat 连接器高级配置**：

- `ATL_TOMCAT_MGMT_PORT`：管理端口，默认 `8007`
- `ATL_TOMCAT_MAXTHREADS`：最大线程数，默认 `150`
- `ATL_TOMCAT_MINSPARETHREADS`：最小空闲线程数，默认 `25`
- `ATL_TOMCAT_CONNECTIONTIMEOUT`：连接超时时间（毫秒），默认 `20000`
- `ATL_TOMCAT_COMPRESSION`：是否启用压缩（off/on/force/数值），默认关闭
- `ATL_TOMCAT_COMPRESSIBLEMIMETYPE`：可压缩 MIME 类型，默认 `text/html,text/xml,...`


#### 访问日志配置

- `ATL_TOMCAT_ACCESS_LOGS_MAXDAYS`：访问日志保留天数，默认 `-1`（永不删除）


#### JVM 高级配置

通过 `JVM_SUPPORT_RECOMMENDED_ARGS` 传递额外 JVM 参数（如自定义信任库）：

```bash
$> docker run -e JVM_SUPPORT_RECOMMENDED_ARGS=-Djavax.net.ssl.trustStore=/var/atlassian/application-data/bamboo/cacerts \
              -v bambooVolume:/var/atlassian/application-data/bamboo \
              --name="bamboo" \
              -d \
              -p 8085:8085 \
              -p 54663:54663 \
              atlassian/bamboo
```


#### Bamboo 特定设置

| 环境变量                     | 默认值                  | 说明                                                                 |
|------------------------------|-------------------------|----------------------------------------------------------------------|
| `ATL_AUTOLOGIN_COOKIE_AGE`   | 1209600（2周，秒）      | "记住我"功能的最大登录时长                                           |
| `BAMBOO_HOME`                | /var/atlassian/application-data/bamboo | Bamboo 主目录，需确保 `bamboo` 用户可写                              |
| `ATL_BROKER_URI`             | nio://0.0.0.0:54663     | ActiveMQ 代理监听地址（用于远程代理通信）                            |
| `ATL_BROKER_CLIENT_URI`      | -                       | 远程代理连接 ActiveMQ 的 URI                                         |
| `ATL_BAMBOO_SKIP_CONFIG`     | false                   | 是否跳过生成 `bamboo.cfg.xml`（仅 Bamboo >=8.1 支持）                |


##### 自动配置（Bamboo >=8.1）

可通过环境变量跳过安装向导，需提供以下参数：

| 环境变量                     | 说明                                                                 |
|------------------------------|----------------------------------------------------------------------|
| `SECURITY_TOKEN`             | 服务器/代理认证的安全令牌                                            |
| `ATL_BAMBOO_DISABLE_AGENT_AUTH` | 是否禁用代理认证，默认 false                                        |
| `ATL_LICENSE`                | 许可证密钥（可从 https://my.atlassian.com/ 获取）                    |
| `ATL_BASE_URL`               | Bamboo 实例基础 URL                                                 |
| `ATL_ADMIN_USERNAME`         | 管理员用户名                                                         |
| `ATL_ADMIN_PASSWORD`         | 管理员密码                                                           |
| `ATL_ADMIN_FULLNAME`         | 管理员全名                                                           |
| `ATL_ADMIN_EMAIL`            | 管理员邮箱                                                           |
| `ATL_IMPORT_OPTION`          | 导入选项：`clean`（默认，全新安装）或 `import`（从备份导入）         |
| `ATL_IMPORT_PATH`            | 备份文件路径（当 `ATL_IMPORT_OPTION=import` 时必填）                 |


### 数据库配置

可通过环境变量预配置数据库（安装向导将自动填充），需提供以下所有参数：

| 环境变量             | 说明                                                                 |
|----------------------|----------------------------------------------------------------------|
| `ATL_JDBC_URL`       | 数据库 URL（数据库特定格式）                                          |
| `ATL_JDBC_USER`      | 数据库用户名                                                         |
| `ATL_JDBC_PASSWORD`  | 数据库密码                                                           |
| `ATL_DB_TYPE`        | 数据库类型：`h2`（仅评估）、`mssql`、`mysql`、`oracle12c`、`postgresql` |

**示例（PostgreSQL）**：

```bash
$> docker run -e ATL_DB_TYPE=postgresql \
              -e ATL_JDBC_URL=jdbc:postgresql://postgres:5432/bamboo \
              -e ATL_JDBC_USER=bamboouser \
              -e ATL_JDBC_PASSWORD=bamboopassword \
              ...（其他参数）...
              atlassian/bamboo
```

> **注意**：由于许可证限制，Bamboo 7.0+ 不包含 MySQL/Oracle JDBC 驱动。需手动复制驱动到容器：
> ```bash
> # 复制 MySQL 驱动到容器
> $> docker cp mysql-connector-java.x.y.z.jar bamboo:/opt/atlassian/bamboo/lib
> 
> # 重启容器
> $> docker restart bamboo
> ```

**数据库连接池配置（可选）**：

| 环境变量               | 默认值  | 说明                     |
|------------------------|---------|--------------------------|
| `ATL_DB_POOLMINSIZE`   | 3       | 最小连接数               |
| `ATL_DB_POOLMAXSIZE`   | 170     | 最大连接数               |
| `ATL_DB_TIMEOUT`       | 120000  | 超时时间（毫秒）         |
| `ATL_DB_CONNECTIONTIMEOUT` | 30000 | 连接超时时间（毫秒）     |
| `ATL_DB_LEAKDETECTION` | 0       | 泄漏检测阈值（毫秒，0为禁用） |


### 容器配置

| 环境变量                     | 默认值       | 说明                                                                 |
|------------------------------|--------------|----------------------------------------------------------------------|
| `ATL_FORCE_CFG_UPDATE`       | false        | 是否强制更新配置文件（适用于 Kubernetes 等环境）                     |
| `ATL_ALLOWLIST_SENSITIVE_ENV_VARS` | -        | 敏感环境变量白名单（逗号分隔，如 "PATH_TO_SECRET_FILE"）             |
| `SET_PERMISSIONS`            | true         | 是否在启动时设置主目录权限                                           |


### 文件系统权限和用户 ID

Bamboo 默认以 `bamboo` 用户（UID/GID=2005）运行，需确保 `BAMBOO_HOME` 目录对该 UID 可写。如需使用其他 UID，可通过以下方式：
- 重新构建 Docker 镜像，修改 UID
- 在 Linux 上通过 [用户命名空间重映射](https://docs.docker.com/engine/security/userns-remap/) 调整 UID


## 升级

升级步骤：

1. 停止当前容器：
   ```bash
   $> docker stop bamboo
   ```

2. 删除容器（**保留数据卷**）：
   ```bash
   $> docker rm bamboo
   ```

3. 使用新版本镜像启动：
   ```bash
   $> docker run ...（使用与初始启动相同的参数）... atlassian/bamboo:8.x.x
   ```

> **警告**：不要使用 `-v` 选项删除容器，以免丢失数据卷。


## 备份

- **评估环境**（使用内置 H2 数据库）：直接备份数据卷即可。
- **生产环境**（外部数据库）：
  - 配置 Bamboo 自动夜间备份（备份数据库和主目录到数据卷）
  - 或单独备份数据库，同时备份数据卷中的 Bamboo 主目录

备份详情参见 [数据和备份](https://confluence.atlassian.com/display/BAMBOO/Data+and+backups)。


## 关闭

Bamboo 可能需要时间完成活跃操作，建议通过 `docker stop` 时预留足够时间：

```bash
# 允许 30 秒关闭时间
$> docker stop -t 30 bamboo
```

或使用内置脚本优雅关闭：
```bash
$> docker exec bamboo /shutdown-wait.sh
```


## 版本控制

- `atlassian/bamboo:latest`：最新稳定版
- 特定版本：`atlassian/bamboo:8`（主版本）、`atlassian/bamboo:8.0`（次版本）、`atlassian/bamboo:8.0.1`（补丁版本）

> 注：仅 8.0+ 版本持续更新，旧版本镜像仍可使用但不再维护。


## 支持的 JDK 版本

- Bamboo Docker 镜像基于 [Eclipse Temurin OpenJDK](https://hub.docker.com/_/eclipse-temurin) 构建
- Bamboo 9.4+ 提供 JDK 17 版本镜像，之前版本使用 JDK 11


## 构建自定义镜像

1. 克隆仓库：
   ```bash
   $> git clone https://bitbucket.org/atlassian-docker/docker-bamboo-server/
   ```

2. 修改 `config` 目录下的 Jinja 模板（`.j2` 扩展名）

3. 构建镜像：
   ```bash
   $> docker build --tag my-bamboo-image --build-arg BAMBOO_VERSION=8.x.x .
   ```


## 故障排除

### 线程转储

通过内置脚本收集线程转储：
```bash
# 默认：10次转储，间隔5秒
$> docker exec my_container /opt/atlassian/support/thread-dumps.sh

# 自定义：20次转储，间隔3秒
$> docker exec my_container /opt/atlassian/support/thread-dumps.sh --count 20 --interval 3
```
转储文件保存至 `$APP_HOME/thread_dumps/<date>`。


### 堆转储

生成堆转储：
```bash
# 生成堆转储
$> docker exec my_container /opt/atlassian/support/heap-dump.sh

# 覆盖现有文件
$> docker exec my_container /opt/atlassian/support/heap-dump.sh --force
```
堆转储文件保存至 `$APP_HOME/heap.bin`。


### 手动诊断

通过 `jcmd` 工具诊断：
```bash
$> docker exec -it my_container /bin/bash
$> jcmd  # 查看进程ID
$> jcmd <pid> <command>  # 执行诊断命令
```


## 支持

- 产品支持：[support.atlassian.com](https://support.atlassian.com/)
- 社区论坛：[Atlassian Data Center on Kubernetes](https://community.atlassian.com/t5/Atlassian-Data-Center-on/gh-p/DC_Kubernetes)


## 变更日志

镜像配置变更详情参见 [Git 提交历史](https://bitbucket.org/atlassian-docker/docker-bamboo-server/commits/)。


## 许可证

Copyright © 2020 Atlassian Corporation Pty Ltd.  
基于 Apache License 2.0 许可。
