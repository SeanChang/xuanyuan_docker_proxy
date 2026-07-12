---
image: zabbix/zabbix-web-apache-mysql
description: "基于Apache Web服务器的Zabbix前端，支持MySQL数据库，用于Zabbix监控系统的Web界面访问。"
source: https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-apache-mysql
canonical: https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-apache-mysql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-apache-mysql" title="zabbix/zabbix-web-apache-mysql Docker 镜像中文简介、标签列表与拉取命令">zabbix/zabbix-web-apache-mysql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Zabbix Web界面（Apache+MySQL）Docker镜像文档

![logo](https://assets.zabbix.com/img/logo/zabbix_logo_500x131.png)

## 镜像概述和主要用途

### Zabbix简介
Zabbix是企业级开源分布式监控解决方案，可监控网络参数、服务器健康状态及完整性。其具备灵活的通知机制，支持基于事件配置邮件告警，便于快速响应服务器问题；同时提供强大的报表和数据可视化功能，适用于容量规划。

### Zabbix Web界面
Zabbix Web界面是Zabbix软件的核心组件，用于管理被监控资源和查看监控统计数据，是用户与Zabbix系统交互的主要入口。

### 镜像用途
本镜像为官方Zabbix Web界面Docker镜像，基于Apache2 Web服务器，支持MySQL数据库，提供便捷的Web界面部署方式，适用于构建Zabbix监控系统的前端服务。


## 核心功能和特性

### 基础环境支持
- **操作系统**：基于Alpine Linux v3.22、Ubuntu 24.04（noble）、CentOS Stream 10、Oracle Linux 10
- **Web服务器**：Apache2
- **数据库**：MySQL/MariaDB

### 版本支持
提供多版本标签，涵盖稳定版和开发版：
- 6.0系列：`alpine-6.0-latest`、`ubuntu-6.0-latest`、`ol-6.0-latest`等
- 7.0系列：`alpine-7.0-latest`、`ubuntu-7.0-latest`等
- 7.2系列：`alpine-7.2-latest`等
- 7.4系列（最新稳定版）：`alpine-7.4-latest`、`latest`（默认基于Alpine）等
- 8.0开发版：`alpine-trunk`等

### 核心功能
- **灵活配置**：通过环境变量自定义数据库连接、Zabbix Server地址、PHP时区等
- **安全特性**：支持数据库TLS加密连接、SAML SSO认证、HTTPS部署
- **PHP优化**：可配置内存限制、最大执行时间等PHP参数
- **日志管理**：支持访问日志输出，便于问题排查
- **扩展性**：支持Elasticsearch历史存储集成（通过`ZBX_HISTORYSTORAGEURL`等参数）


## 使用场景和适用范围

### 适用场景
- 企业级分布式监控系统的Web管理界面部署
- 与Zabbix Server/Proxy、MySQL数据库集成的监控架构
- 容器化部署环境（Docker、Kubernetes、Docker Swarm）
- 需快速搭建或迁移Zabbix Web界面的场景

### 适用规模
- 小型环境：单节点Zabbix Server+MySQL+Web界面
- 中型环境：Zabbix Server+Proxy分布式架构，Web界面独立扩展
- 大型企业：多Web界面实例负载均衡，结合数据库集群


## 使用方法和配置说明

### 快速启动

通过`docker run`启动Zabbix Web界面容器：

```bash
docker run --name zabbix-web -d \
  -e DB_SERVER_HOST="mysql-server" \
  -e MYSQL_USER="zabbix" \
  -e MYSQL_PASSWORD="zabbix" \
  -e ZBX_SERVER_HOST="zabbix-server" \
  -e PHP_TZ="Asia/Shanghai" \
  -p 8080:80 \
  docker.xuanyuan.run/zabbix/zabbix-web-apache-mysql:latest
```

参数说明：
- `--name zabbix-web`：容器名称
- `-e`：环境变量（详见下文）
- `-p 8080:80`：映射容器80端口到主机8080端口
- `zabbix/zabbix-web-apache-mysql:latest`：镜像名称及标签


### 容器链接

#### 链接MySQL容器
```bash
docker run --name zabbix-web -d \
  --link mysql:mysql \  # 链接MySQL容器（别名mysql）
  -e DB_SERVER_HOST="mysql" \  # 使用链接别名访问MySQL
  -e MYSQL_USER="zabbix" \
  -e MYSQL_PASSWORD="zabbix" \
  -e ZBX_SERVER_HOST="zabbix-server" \
  -e PHP_TZ="Asia/Shanghai" \
  zabbix/zabbix-web-apache-mysql:latest
```

#### 链接Zabbix Server容器
```bash
docker run --name zabbix-web -d \
  --link zabbix-server:zabbix-server \  # 链接Zabbix Server容器
  -e DB_SERVER_HOST="mysql-server" \
  -e MYSQL_USER="zabbix" \
  -e MYSQL_PASSWORD="zabbix" \
  -e ZBX_SERVER_HOST="zabbix-server" \  # 使用链接别名访问Server
  -e PHP_TZ="Asia/Shanghai" \
  zabbix/zabbix-web-apache-mysql:latest
```


### 容器管理

#### 查看日志
```bash
docker logs zabbix-web
```

#### 进入容器
```bash
docker exec -ti zabbix-web /bin/bash
```


### 环境变量配置

#### 1. 数据库连接配置
| 变量名                | 说明                                                                 | 默认值          |
|-----------------------|----------------------------------------------------------------------|-----------------|
| `DB_SERVER_HOST`      | MySQL服务器IP或域名                                                 | `mysql-server`  |
| `DB_SERVER_PORT`      | MySQL端口                                                           | `3306`          |
| `MYSQL_USER`          | 数据库用户名（与`MYSQL_USER_FILE`二选一）                            | `zabbix`        |
| `MYSQL_USER_FILE`     | 存储用户名的文件路径（适用于Docker Secrets）                         | -               |
| `MYSQL_PASSWORD`      | 数据库密码（与`MYSQL_PASSWORD_FILE`二选一）                          | `zabbix`        |
| `MYSQL_PASSWORD_FILE` | 存储密码的文件路径（适用于Docker Secrets）                           | -               |
| `MYSQL_DATABASE`      | Zabbix数据库名称                                                     | `zabbix`        |

**示例（Docker Secrets）**：
```bash
# 创建Secrets（Docker Swarm/K8s）
printf "zabbix" | docker secret create MYSQL_USER -
printf "secure-pass" | docker secret create MYSQL_PASSWORD -

# 启动容器
docker run --name zabbix-web -d \
  --secret docker.xuanyuan.run/MYSQL_USER \
  --secret MYSQL_PASSWORD \
  -e DB_SERVER_HOST="mysql" \
  -e MYSQL_USER_FILE="/run/secrets/MYSQL_USER" \
  -e MYSQL_PASSWORD_FILE="/run/secrets/MYSQL_PASSWORD" \
  zabbix/zabbix-web-apache-mysql:latest
```

#### 2. Zabbix Server/Proxy配置
| 变量名              | 说明                          | 默认值          |
|---------------------|-------------------------------|-----------------|
| `ZBX_SERVER_HOST`   | Zabbix Server/Proxy的IP或域名 | `zabbix-server` |
| `ZBX_SERVER_PORT`   | Zabbix Server端口             | `10051`         |

#### 3. PHP配置
| 变量名                | 说明                          | 默认值          |
|-----------------------|-------------------------------|-----------------|
| `PHP_TZ`              | PHP时区（如`Asia/Shanghai`）  | `Europe/Riga`   |
| `ZBX_MEMORYLIMIT`     | PHP内存限制                   | `128M`          |
| `ZBX_MAXEXECUTIONTIME`| PHP最大执行时间（秒）         | `300`           |
| `ZBX_POSTMAXSIZE`     | POST数据最大尺寸              | `16M`           |
| `ZBX_UPLOADMAXFILESIZE`| 文件上传最大尺寸             | `2M`            |

#### 4. 安全配置
| 变量名                  | 说明                                                                 | 默认值          |
|-------------------------|----------------------------------------------------------------------|-----------------|
| `ZBX_DB_ENCRYPTION`     | 启用数据库TLS加密连接（`true`/`false`）                              | `false`         |
| `ZBX_DB_CA_FILE`        | 数据库CA证书路径                                                     | -               |
| `ZBX_DB_KEY_FILE`       | 客户端TLS密钥路径                                                    | -               |
| `ZBX_DB_CERT_FILE`      | 客户端TLS证书路径                                                    | -               |
| `ZBX_SSO_SP_KEY`        | SAML Service Provider私钥路径                                        | -               |
| `ZBX_SSO_SP_CERT`       | SAML SP证书路径                                                      | -               |
| `ZBX_SSO_IDP_CERT`      | SAML Identity Provider证书路径                                       | -               |
| `ZBX_SSO_SETTINGS`      | SSO配置（JSON格式，如`{"baseurl":"https://zabbix.example.com"}`）    | -               |

#### 5. 其他常用配置
| 变量名                  | 说明                                                                 | 默认值          |
|-------------------------|----------------------------------------------------------------------|-----------------|
| `ZBX_SERVER_NAME`       | Web界面顶部显示的Zabbix实例名称                                      | -               |
| `ZBX_HISTORYSTORAGEURL` | Elasticsearch历史存储URL（如`http://es:9200`）                       | -               |
| `ZBX_HISTORYSTORAGETYPES` | 发送到ES的指标类型（如`['uint','dbl']`）                           | -               |
| `ENABLE_WEB_ACCESS_LOG` | 启用Apache访问日志（`true`/`false`）                                 | `true`          |


### 卷挂载

#### 1. HTTPS证书（`/etc/ssl/apache2`）
用于部署HTTPS，需挂载包含`ssl.crt`（证书）和`ssl.key`（私钥）的目录：
```bash
docker run --name zabbix-web -d \
  -v /path/to/ssl:/etc/ssl/apache2 \  # 包含ssl.crt和ssl.key
  -p 443:443 \
  zabbix/zabbix-web-apache-mysql:latest
```

#### 2. SAML证书（`/etc/zabbix/web/certs`）
用于SAML SSO，需挂载包含`sp.key`（SP私钥）、`sp.crt`（SP证书）、`idp.crt`（IDP证书）的目录。

#### 3. TLS文件（`/var/lib/zabbix/enc`）
用于Zabbix Server TLS连接（7.4+版本），存放`ZBX_SERVER_TLS_CAFILE`/`KEYFILE`/`CERTFILE`指定的文件。


## 镜像变体

### `alpine-<version>`
- **基础**：Alpine Linux（体积小，~5MB）
- **特点**：镜像尺寸最小，适合资源受限环境；使用musl libc（部分依赖glibc的场景可能不兼容）
- **适用**：追求最小镜像体积的场景

### `ubuntu-<version>`
- **基础**：Ubuntu 24.04
- **特点**：兼容性好，使用glibc，包含更多系统工具
- **适用**：通用场景，尤其依赖glibc的环境

### `ol-<version>`
- **基础**：Oracle Linux 10
- **特点**：优化Oracle产品兼容性，支持Ksplice零停机内核更新
- **适用**：Oracle数据库或Oracle workloads环境


## 部署示例（docker-compose）

以下为Zabbix完整架构的docker-compose示例（包含MySQL、Zabbix Server、Web界面）：

```yaml
version: '3.8'

services:
  mysql:
    image: docker.xuanyuan.run/mysql:8.0
    container_name: zabbix-mysql
    environment:
      MYSQL_ROOT_PASSWORD: "root-pass"
      MYSQL_DATABASE: "zabbix"
      MYSQL_USER: "zabbix"
      MYSQL_PASSWORD: "zabbix-pass"
    volumes:
      - mysql-data:/var/lib/mysql
    restart: always
    networks:
      - zabbix-net

  zabbix-server:
    image: docker.xuanyuan.run/zabbix/zabbix-server-mysql:latest
    container_name: zabbix-server
    environment:
      DB_SERVER_HOST: "mysql"
      MYSQL_DATABASE: "zabbix"
      MYSQL_USER: "zabbix"
      MYSQL_PASSWORD: "zabbix-pass"
      ZBX_LISTENPORT: "10051"
    depends_on:
      - mysql
    restart: always
    networks:
      - zabbix-net

  zabbix-web:
    image: docker.xuanyuan.run/zabbix/zabbix-web-apache-mysql:latest
    container_name: zabbix-web
    environment:
      DB_SERVER_HOST: "mysql"
      MYSQL_USER: "zabbix"
      MYSQL_PASSWORD: "zabbix-pass"
      ZBX_SERVER_HOST: "zabbix-server"
      PHP_TZ: "Asia/Shanghai"
      ZBX_SERVER_NAME: "My Zabbix Monitor"
    ports:
      - "8080:80"
    depends_on:
      - mysql
      - zabbix-server
    restart: always
    networks:
      - zabbix-net

networks:
  zabbix-net:
    driver: bridge

volumes:
  mysql-data:
```

启动命令：
```bash
docker-compose up -d
```

访问Web界面：`http://localhost:8080`（默认账号：Admin，密码：zabbix）


## 支持与许可

### 支持的Docker版本
官方支持Docker 1.12.0及以上，旧版本（1.6+）尽力支持。

### 文档与反馈
- **文档**：镜像详细文档见[Zabbix Docker GitHub repo](https://github.com/zabbix/zabbix-docker/tree/trunk/Dockerfiles/web-apache-mysql)
- **问题反馈**：通过[GitHub Issues](https://github.com/zabbix/zabbix-docker/issues)提交
- **贡献**：欢迎通过Pull Request贡献代码或修复

### 许可
- Zabbix 7.0及以上版本：GNU Affero General Public License v3 (AGPLv3)
- Zabbix 6.4及以下版本：GNU General Public License v2 (GPLv2)
- 商业支持：建议商业用户购买Zabbix技术支持，详见[Zabbix官网](https://zabbix.com)


**注**：实际部署时需根据环境调整参数（如密码、时区、端口映射等），并遵循安全最佳实践（如使用Secrets管理敏感信息）。
