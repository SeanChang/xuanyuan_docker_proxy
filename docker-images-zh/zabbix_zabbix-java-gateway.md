<!-- xuanyuan-docker-images-zh
image: zabbix/zabbix-java-gateway
source: https://xuanyuan.cloud/zh/r/zabbix/zabbix-java-gateway
canonical: https://xuanyuan.cloud/zh/r/zabbix/zabbix-java-gateway
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/zabbix/zabbix-java-gateway" title="zabbix/zabbix-java-gateway Docker 镜像中文简介、标签列表与拉取命令">zabbix/zabbix-java-gateway — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/zabbix/zabbix-java-gateway" title="zabbix/zabbix-java-gateway Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/zabbix/zabbix-java-gateway</a></p>

# Zabbix Java Gateway

## 镜像概述和主要用途

### Zabbix简介
Zabbix是企业级开源分布式监控解决方案，可监控网络参数、服务器健康状态与完整性。它提供灵活的通知机制，允许用户为几乎任何事件配置基于电子邮件的告警，以便快速响应服务器问题。同时，Zabbix基于存储数据提供优秀的报告和数据可视化功能，适用于容量规划。

### Zabbix Java Gateway用途
Zabbix Java Gateway是Zabbix的组件，提供对JMX（Java Management Extensions）应用的原生监控支持。它接受来自Zabbix server或Zabbix proxy的传入连接，仅用作"被动代理"（passive proxy），即由Zabbix server/proxy主动发起请求以获取JMX指标。

## 核心功能和特性

- **原生JMX监控支持**：专为采集Java应用程序的JMX指标设计，支持监控各类Java应用服务器及自定义Java应用。
- **被动代理模式**：仅响应Zabbix server或proxy的请求，不主动发起连接，降低网络复杂性。
- **多基础镜像支持**：基于Alpine Linux v3.22、Ubuntu 24.04（noble）、CentOS Stream 10和Oracle Linux 10构建，满足不同环境需求。
- **版本迭代更新**：镜像随Zabbix官方版本发布自动更新，确保功能同步。
- **灵活配置**：通过环境变量调整轮询器数量、超时时间、日志级别等核心参数，支持自定义配置。

## 使用场景和适用范围

Zabbix Java Gateway适用于需要监控JMX兼容应用程序的场景，包括但不限于：

- 监控Java应用服务器（如Tomcat、JBoss、WebLogic、GlassFish）的性能指标（线程数、内存使用、连接池状态等）。
- 采集自定义Java应用程序的业务指标和运行状态。
- 监控任何暴露JMX接口的Java进程（如Spring Boot应用、微服务等）。
- 构建企业级Java应用监控架构，通过Zabbix集中管理JMX指标。

## 详细的使用方法和配置说明

### 启动Zabbix Java Gateway容器

使用`docker run`命令启动容器：

```console
docker run --name some-zabbix-java-gateway -d zabbix/zabbix-java-gateway:tag
```

**参数说明**：
- `--name some-zabbix-java-gateway`：自定义容器名称
- `-d`：后台运行容器
- `zabbix/zabbix-java-gateway:tag`：镜像名称及版本标签（`tag`需替换为具体版本，如`alpine-7.4-latest`）

### 链接到Zabbix Server或Proxy

通过`--link`参数将Java Gateway与Zabbix Server/Proxy关联：

```console
docker run --name some-zabbix-java-gateway --link some-zabbix-server:zabbix-server -d zabbix/zabbix-java-gateway:tag
```

**说明**：`--link some-zabbix-server:zabbix-server`建立容器间连接，使Java Gateway可通过`zabbix-server`别名访问Zabbix Server容器。

### Docker Compose部署示例

以下是包含Zabbix Server、Java Gateway和MySQL的完整部署示例：

```yaml
version: '3.8'
services:
  zabbix-server:
    image: zabbix/zabbix-server-mysql:latest
    depends_on:
      - mysql
    environment:
      - DB_SERVER_HOST=mysql
      - MYSQL_DATABASE=zabbix
      - MYSQL_USER=zabbix
      - MYSQL_PASSWORD=zabbix_password
      - MYSQL_ROOT_PASSWORD=root_password
      - ZBX_JAVAGATEWAY=zabbix-java-gateway  # 配置Java Gateway地址
      - ZBX_JAVAGATEWAYPORT=10052             # Java Gateway默认端口
    ports:
      - "10051:10051"
    restart: always

  zabbix-java-gateway:
    image: zabbix/zabbix-java-gateway:latest
    environment:
      - ZBX_START_POLLERS=10  # 调整轮询器数量
      - ZBX_TIMEOUT=5         # 设置超时时间
    ports:
      - "10052:10052"         # Java Gateway默认端口
    restart: always

  mysql:
    image: mysql:8.0
    environment:
      - MYSQL_DATABASE=zabbix
      - MYSQL_USER=zabbix
      - MYSQL_PASSWORD=zabbix_password
      - MYSQL_ROOT_PASSWORD=root_password
      - MYSQL_ALLOW_EMPTY_PASSWORD=no
    volumes:
      - mysql-data:/var/lib/mysql
    restart: always

volumes:
  mysql-data:
```

### 容器Shell访问与日志查看

#### 进入容器Shell
通过`docker exec`命令获取容器内bash终端：

```console
docker exec -ti some-zabbix-java-gateway /bin/bash
```

#### 查看运行日志
通过Docker日志功能查看Java Gateway日志：

```console
docker logs some-zabbix-java-gateway
```

### 环境变量配置

启动容器时可通过环境变量调整配置，支持的参数如下：

| 环境变量               | 描述                                                                 | 默认值   |
|------------------------|----------------------------------------------------------------------|----------|
| `ZBX_START_POLLERS`    | 轮询器数量（同时处理的JMX请求数）                                     | `5`      |
| `ZBX_TIMEOUT`          | 连接超时时间（秒）                                                   | `3`      |
| `ZBX_DEBUGLEVEL`       | 日志级别，支持值：`trace`、`debug`、`info`、`want`、`error`、`all`、`off` | `info`   |
| `ZBX_PROPERTIES_FILE`  | 属性文件名，用于通过键值对设置额外配置（避免命令行可见）               | 未设置   |
| `ZABBIX_OPTIONS`       | 额外启动参数，用于启用扩展库或功能                                   | 未设置   |

**示例**：调整轮询器数量和日志级别
```console
docker run --name some-zabbix-java-gateway -e ZBX_START_POLLERS=20 -e ZBX_DEBUGLEVEL=debug -d zabbix/zabbix-java-gateway:latest
```

### 允许的卷挂载

容器支持挂载以下目录以扩展功能：

- `/usr/sbin/zabbix_java/ext_lib`：用于添加额外JAR文件，扩展支持的协议或功能（如自定义JMX客户端库）。

**示例**：挂载本地JAR文件目录
```console
docker run --name some-zabbix-java-gateway -v /local/ext_lib:/usr/sbin/zabbix_java/ext_lib -d zabbix/zabbix-java-gateway:latest
```

## 镜像版本标签

Zabbix Java Gateway提供多种版本标签，基于不同基础操作系统和Zabbix版本：

### 主要版本系列

| Zabbix版本 | 标签示例（Alpine/Ubuntu/Oracle Linux）                | 说明                     |
|------------|-------------------------------------------------------|--------------------------|
| 6.0        | `alpine-6.0-latest`、`ubuntu-6.0-latest`、`ol-6.0-latest` | 长期支持版本             |
| 7.0        | `alpine-7.0-latest`、`ubuntu-7.0-latest`、`ol-7.0-latest` | 标准版本                 |
| 7.2        | `alpine-7.2-latest`、`ubuntu-7.2-latest`、`ol-7.2-latest` | 标准版本                 |
| 7.4        | `alpine-7.4-latest`、`ubuntu-latest`、`ol-latest`、`latest` | 最新稳定版（`latest`基于Alpine） |
| 8.0（开发中） | `alpine-trunk`、`ubuntu-trunk`、`ol-trunk`             | 开发版本                 |

### 基础镜像类型

- **Alpine Linux**：标签格式`alpine-<version>`，轻量级基础镜像（约5MB），使用musl libc，适合对镜像大小敏感的场景。
- **Ubuntu**：标签格式`ubuntu-<version>`，默认推荐镜像，基于Ubuntu 24.04，兼容性好，包含常用系统工具。
- **Oracle Linux**：标签格式`ol-<version>`，基于Oracle Linux 10，适合Oracle工作负载，支持Ksplice等特性。

## 支持的Docker版本

官方支持Docker 1.12.0及以上版本，对1.6及以上旧版本提供尽力支持。建议参考[Docker安装文档](https://docs.docker.com/installation/)升级Docker引擎。

## 用户反馈

### 文档
镜像文档存储在[`zabbix/zabbix-docker` GitHub仓库](https://github.com/zabbix/zabbix-docker/)的[`java-gateway/`目录](https://github.com/zabbix/zabbix-docker/tree/trunk/Dockerfiles/java-gateway)。提交PR前请先阅读仓库[`README.md`](https://github.com/zabbix/zabbix-docker/blob/trunk/README.md)。

### 问题反馈
如遇镜像相关问题，请通过[GitHub Issue](https://github.com/zabbix/zabbix-docker/issues)提交。

### 贡献
欢迎贡献新功能、修复或更新。建议通过[GitHub Issue](https://github.com/zabbix/zabbix-docker/issues)提前讨论计划，确保与项目方向一致。

### 许可
- Zabbix 7.0及后续版本采用GNU Affero General Public License v3（AGPLv3）许可。
- Zabbix 6.4及之前版本采用GNU General Public License v2（GPLv2）许可。
详细条款参见[Free Software Foundation](http://www.fsf.org/licenses/)。商业使用时，建议通过购买技术支持支持Zabbix开发。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/zabbix/zabbix-java-gateway" title="zabbix/zabbix-java-gateway Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/zabbix/zabbix-java-gateway</a></p>
