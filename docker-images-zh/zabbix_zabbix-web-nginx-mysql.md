---
image: zabbix/zabbix-web-nginx-mysql
description: "Zabbix前端是一款用于网络、服务器、应用程序等IT资源监控的界面，它基于Nginx Web服务器构建，并支持MySQL数据库作为数据存储后端，能够为用户提供直观的监控数据展示、配置管理及告警信息查看等功能，是Zabbix监控系统中实现用户与系统交互的核心组件。"
source: https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-mysql
canonical: https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-mysql
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-mysql" title="zabbix/zabbix-web-nginx-mysql Docker 镜像中文简介、标签列表与拉取命令">zabbix/zabbix-web-nginx-mysql — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-mysql" title="zabbix/zabbix-web-nginx-mysql Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-mysql</a>

![logo]()

# Zabbix 简介

Zabbix 是一款企业级开源分布式监控解决方案，可对网络参数、服务器健康状态及完整性进行全面监控。它支持灵活的通知机制，允许用户为各类事件配置邮件告警，以便快速响应服务器问题。同时，Zabbix 基于存储数据提供出色的报表和数据可视化功能，适用于容量规划场景。

更多 Zabbix 组件信息及相关下载，可访问：[] 和  Zabbix Web 界面

Zabbix Web 界面是 Zabbix 软件的组成部分，用于管理被监控资源和查看监控统计数据。


# Zabbix Web 界面 Docker 镜像

以下是官方发布的 Zabbix Web 界面 Docker 镜像，基于 Alpine Linux v3.22、Ubuntu 24.04（noble）、CentOS Stream 10 和 Oracle Linux 10 构建。支持的 Zabbix Web 界面版本及对应标签如下：

- Zabbix Web 界面 6.0（标签：alpine-6.0-latest、ubuntu-6.0-latest、ol-6.0-latest）  
- Zabbix Web 界面 6.0.*（标签：alpine-6.0.*、ubuntu-6.0.*、ol-6.0.*）  
- Zabbix Web 界面 7.0（标签：alpine-7.0-latest、ubuntu-7.0-latest、ol-7.0-latest）  
- Zabbix Web 界面 7.0.*（标签：alpine-7.0.*、ubuntu-7.0.*、ol-7.0.*）  
- Zabbix Web 界面 7.2（标签：alpine-7.2-latest、ubuntu-7.2-latest、ol-7.2-latest）  
- Zabbix Web 界面 7.2.*（标签：alpine-7.2.*、ubuntu-7.2.*、ol-7.2.*）  
- Zabbix Web 界面 7.4（标签：alpine-7.4-latest、ubuntu-7.4-latest、ol-7.4-latest、alpine-latest、ubuntu-latest、ol-latest、latest）  
- Zabbix Web 界面 7.4.*（标签：alpine-7.4.*、ubuntu-7.4.*、ol-7.4.*）  
- Zabbix Web 界面 8.0（标签：alpine-trunk、ubuntu-trunk、ol-trunk）  

镜像会随新版本发布同步更新，其中 `latest` 标签默认基于 Alpine Linux。


## 镜像版本说明

Zabbix Web 界面提供四种版本，分别对应不同的 Web 服务器和数据库组合：  
- 基于 Apache2 Web 服务器，支持 MySQL 数据库  
- 基于 Apache2 Web 服务器，支持 PostgreSQL 数据库  
- 基于 Nginx Web 服务器，支持 MySQL 数据库  
- 基于 Nginx Web 服务器，支持 PostgreSQL 数据库  

本文档主要介绍 **基于 Nginx + MySQL 的 Zabbix Web 界面镜像**。


# 如何使用镜像

## 启动 `zabbix-web-nginx-mysql` 容器

通过以下命令启动 Zabbix Web 界面容器：  

```console
docker run --name some-zabbix-web-nginx-mysql \
  -e DB_SERVER_HOST="some-mysql-server" \
  -e MYSQL_USER="some-user" \
  -e MYSQL_PASSWORD="some-password" \
  -e ZBX_SERVER_HOST="some-zabbix-server" \
  -e PHP_TZ="some-timezone" \
  -d zabbix/zabbix-web-nginx-mysql:tag
```

参数说明：  
- `some-zabbix-web-nginx-mysql`：自定义容器名称  
- `some-mysql-server`：MySQL 服务器的 IP 或 DNS 名称  
- `some-user`：连接 MySQL 数据库的用户名  
- `some-password`：MySQL 用户密码  
- `some-zabbix-server`：Zabbix 服务器/代理的 IP 或 DNS 名称  
- `some-timezone`：PHP 时区（如 `Asia/Shanghai`）  
- `tag`：指定镜像版本标签（参考上文“支持的版本及标签”）  

完整标签列表可查看 [Docker Hub]([])。


## 关联 Zabbix Server 容器

如需将 Web 界面容器与 Zabbix Server 关联，可使用 `--link` 参数：  

```console
docker run --name some-zabbix-web-nginx-mysql \
  --link some-zabbix-server:zabbix-server \
  -e DB_SERVER_HOST="some-mysql-server" \
  -e MYSQL_USER="some-user" \
  -e MYSQL_PASSWORD="some-password" \
  -e ZBX_SERVER_HOST="some-zabbix-server" \
  -e PHP_TZ="some-timezone" \
  -d zabbix/zabbix-web-nginx-mysql:tag
```


## 关联 MySQL 数据库容器

如需关联 MySQL 容器，同样使用 `--link` 参数：  

```console
docker run --name some-zabbix-web-nginx-mysql \
  --link some-mysql-server:mysql \
  -e DB_SERVER_HOST="some-mysql-server" \
  -e MYSQL_USER="some-user" \
  -e MYSQL_PASSWORD="some-password" \
  -e ZBX_SERVER_HOST="some-zabbix-server" \
  -e PHP_TZ="some-timezone" \
  -d zabbix/zabbix-web-nginx-mysql:tag
```


## 容器操作与日志查看

### 进入容器终端

使用 `docker exec` 命令进入容器内部：  

```console
docker exec -ti some-zabbix-web-nginx-mysql /bin/bash
```

### 查看 Web 界面日志

通过 Docker 容器日志命令查看 Zabbix Web 界面运行日志：  

```console
docker logs some-zabbix-web-nginx-mysql
```


# 环境变量配置

启动容器时，可通过 `-e` 参数设置环境变量调整 Zabbix Web 界面配置。以下为常用变量说明：


## 核心连接参数

| 变量名               | 说明                                  | 默认值                |
|----------------------|---------------------------------------|-----------------------|
| `ZBX_SERVER_HOST`    | Zabbix 服务器/代理的 IP 或 DNS 名称   | `zabbix-server`       |
| `ZBX_SERVER_PORT`    | Zabbix 服务器监听端口                 | `10051`               |
| `DB_SERVER_HOST`     | MySQL 服务器的 IP 或 DNS 名称         | `mysql-server`        |
| `DB_SERVER_PORT`     | MySQL 服务器端口                      | `3306`                |
| `MYSQL_USER`         | MySQL 数据库用户名                    | `zabbix`              |
| `MYSQL_PASSWORD`     | MySQL 用户密码                        | `zabbix`              |
| `MYSQL_DATABASE`     | Zabbix 数据库名称                     | `zabbix`              |
| `PHP_TZ`             | PHP 时区（如 `Asia/Shanghai`）        | `Europe/Riga`         |


## 安全凭证文件（推荐生产环境使用）

为避免明文传递密码，可通过文件方式注入 MySQL 用户名/密码（适用于 Docker Swarm/Kubernetes 等场景）：  

- `MYSQL_USER_FILE`：指向存储用户名的文件路径  
- `MYSQL_PASSWORD_FILE`：指向存储密码的文件路径  

**示例（本地文件挂载）**：  
```console
docker run --name some-zabbix-web-nginx-mysql \
  -e DB_SERVER_HOST="some-mysql-server" \
  -v ./.MYSQL_USER:/run/secrets/MYSQL_USER \
  -e MYSQL_USER_FILE=/run/secrets/MYSQL_USER \
  -v ./.MYSQL_PASSWORD:/run/secrets/MYSQL_PASSWORD \
  -e MYSQL_PASSWORD_FILE=/run/secrets/MYSQL_PASSWORD \
  -e PHP_TZ="Asia/Shanghai" \
  -d zabbix/zabbix-web-nginx-mysql:tag
```

**示例（Docker Swarm 密钥）**：  
```console
# 创建密钥
printf "zabbix" | docker secret create MYSQL_USER -
printf "zabbix" | docker secret create MYSQL_PASSWORD -

# 使用密钥启动容器
docker run --name some-zabbix-web-nginx-mysql \
  -e DB_SERVER_HOST="some-mysql-server" \
  -e MYSQL_USER_FILE=/run/secrets/MYSQL_USER \
  -e MYSQL_PASSWORD_FILE=/run/secrets/MYSQL_PASSWORD \
  -e ZBX_SERVER_HOST="some-zabbix-server" \
  -e PHP_TZ="Asia/Shanghai" \
  -d zabbix/zabbix-web-nginx-mysql:tag
```


## 高级配置参数

| 变量名                  | 说明                                                                 |
|-------------------------|----------------------------------------------------------------------|
| `ZBX_HISTORYSTORAGEURL` | Elasticsearch 历史存储服务的 HTTP(S) URL（3.4.5+ 支持）              |
| `ZBX_HISTORYSTORAGETYPES` | 需存储到 Elasticsearch 的值类型（如 `['uint', 'dbl']`）             |
| `ZBX_SERVER_NAME`       | Web 界面顶部显示的 Zabbix 实例名称                                   |
| `DB_DOUBLE_IEEE754`     | 是否启用 64 位浮点型历史数据的 IEEE754 兼容模式（5.0.0+，默认启用）  |
| `ZBX_DB_ENCRYPTION`     | 是否启用数据库连接加密（5.0.0+，默认禁用，设为 `true` 启用）         |


## 其他参数

还支持 PHP-FPM 配置（如 `PHP_FPM_PM_MAX_CHILDREN`）、Nginx 配置（如 `WEB_REAL_IP_FROM`）、TLS 加密（如 `ZBX_DB_CA_FILE`）、SAML 认证（如 `ZBX_SSO_SP_KEY`）等，详细说明可参考 [官方文档]([])。


# 容器卷挂载

可通过 `-v` 参数挂载宿主机目录到容器，实现自定义配置或持久化数据：


## `/etc/ssl/nginx`  
用于启用 HTTPS，需挂载包含以下文件的目录：  
- `ssl.crt`：SSL 证书文件  
- `ssl.key`：SSL 私钥文件  
- `dhparam.pem`：DH 参数文件  

配置方法参考 [Nginx 官方文档]([])。


## `/etc/zabbix/web/certs`  
用于 SAML 认证，需挂载包含以下文件的目录（5.0.0+ 支持）：  
- `sp.key`：服务提供商（SP）私钥  
- `sp.crt`：服务提供商（SP）证书  
- `idp.crt`：身份提供商（IDP）证书  


## `/var/lib/zabbix/enc`  
用于存储 TLS 相关文件（7.4.0+ 支持），需与 `ZBX_SERVER_TLS_CAFILE`（CA 文件路径）、`ZBX_SERVER_TLS_KEYFILE`（私钥路径）等变量配合使用。


# 镜像变体说明

Zabbix Web 界面镜像提供多种基础系统版本，适用于不同场景：


## `alpine-<version>`  
基于 Alpine Linux，镜像体积极小（约 5MB 基础镜像），适合对资源敏感的场景。需注意其使用 musl libc，部分依赖 glibc 的软件可能存在兼容性问题。


## `ubuntu-<version>`  
基于 Ubuntu 24.04，为默认推荐版本，兼容性好，适合大多数通用场景。


## `ol-<version>`  
基于 Oracle Linux 10，针对 Oracle 工作负载优化，支持 Ksplice、DTrace 等企业级特性。


# 支持的 Docker 版本

官方推荐 Docker 1.12.0 及以上版本，旧版本（低至 1.6）可尝试使用，但不保证完全兼容。  
升级 Docker 方法参考 [Docker 官方文档]([])。


# 用户反馈与支持

## 文档  
镜像详细文档位于 [GitHub 仓库]([]) 的 `web-nginx-mysql/` 目录。


## 问题反馈  
如遇使用问题，可通过 [GitHub Issues]([]) 提交。


## 贡献代码  
欢迎提交功能改进、bug 修复或更新，建议先通过 GitHub Issues 讨论计划，再提交 Pull Request。


## 许可证  
- Zabbix 7.0 及以上版本：采用 GNU Affero General Public License v3（AGPLv3）  
- Zabbix 6.4 及以下版本：采用 GNU General Public License v2（GPLv2）  

商业用户可通过购买技术支持获取额外服务。
