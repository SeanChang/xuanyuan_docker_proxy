---
image: zabbix/zabbix-web-nginx-pgsql
description: "基于Nginx并支持PostgreSQL数据库的Zabbix前端界面，用于管理被监控资源和查看监控统计数据，是官方Zabbix Web界面Docker镜像之一。"
source: https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-pgsql
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[zabbix/zabbix-web-nginx-pgsql](https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-nginx-pgsql)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Zabbix Web界面（Nginx+PostgreSQL）Docker镜像

![logo](https://assets.zabbix.com/img/logo/zabbix_logo_500x131.png)

## 镜像概述和主要用途

### 什么是Zabbix？
Zabbix是企业级开源分布式监控解决方案，可监控网络的众多参数以及服务器的健康状态和完整性。它采用灵活的通知机制，允许用户为几乎任何事件配置基于电子邮件的警报，以便快速响应服务器问题。Zabbix还提供基于存储数据的出色报告和数据可视化功能，非常适合容量规划。

更多信息及Zabbix组件的相关下载，请访问https://hub.docker.com/u/zabbix/ 和 https://zabbix.com。

### 什么是Zabbix Web界面？
Zabbix Web界面是Zabbix软件的一部分，用于管理被监控资源和查看监控统计数据。

### Zabbix Web界面镜像
这些是唯一的官方Zabbix Web界面Docker镜像，基于Alpine Linux v3.23、Ubuntu 24.04（noble）、CentOS Stream 10和Oracle Linux 10构建。可用的Zabbix Web界面版本包括：

- Zabbix Web界面6.0（标签：alpine-6.0-latest、ubuntu-6.0-latest、ol-6.0-latest）
- Zabbix Web界面6.0.*（标签：alpine-6.0.*、ubuntu-6.0.*、ol-6.0.*）
- Zabbix Web界面7.0（标签：alpine-7.0-latest、ubuntu-7.0-latest、ol-7.0-latest）
- Zabbix Web界面7.0.*（标签：alpine-7.0.*、ubuntu-7.0.*、ol-7.0.*）
- Zabbix Web界面7.2（标签：alpine-7.2-latest、ubuntu-7.2-latest、ol-7.2-latest）
- Zabbix Web界面7.2.*（标签：alpine-7.2.*、ubuntu-7.2.*、ol-7.2.*）
- Zabbix Web界面7.4（标签：alpine-7.4-latest、ubuntu-7.4-latest、ol-7.4-latest、alpine-latest、ubuntu-latest、ol-latest、latest）
- Zabbix Web界面7.4.*（标签：alpine-7.4.*、ubuntu-7.4.*、ol-7.4.*）
- Zabbix Web界面8.0（标签：alpine-trunk、ubuntu-trunk、ol-trunk）

镜像会在新版本发布时更新，带有`latest`标签的镜像基于Alpine Linux。

Zabbix Web界面提供四种版本：
- 基于Apache2 Web服务器、支持MySQL数据库的Zabbix Web界面
- 基于Apache2 Web服务器、支持PostgreSQL数据库的Zabbix Web界面
- 基于Nginx Web服务器、支持MySQL数据库的Zabbix Web界面
- 基于Nginx Web服务器、支持PostgreSQL数据库的Zabbix Web界面

本镜像属于基于Nginx Web服务器并支持PostgreSQL数据库的版本。

## 核心功能和特性

- **多基础镜像支持**：基于Alpine Linux v3.23、Ubuntu 24.04、CentOS Stream 10和Oracle Linux 10构建，满足不同环境需求
- **版本灵活性**：提供6.0、7.0、7.2、7.4、8.0等多个版本，通过标签精确指定版本
- **安全配置**：支持通过环境变量或文件配置数据库认证信息，兼容Docker Swarm和Kubernetes Secrets
- **PHP和Web服务器优化**：可自定义PHP参数（如max_execution_time、memory_limit）和Nginx配置（如访问日志、服务器信息隐藏）
- **扩展功能**：支持TLS加密数据库连接、SAML认证、Elasticsearch历史存储、Vault集成等高级特性
- **卷挂载支持**：可挂载SSL证书、SAML认证证书和TLS相关文件，实现HTTPS和安全认证

## 使用场景和适用范围

适用于需要通过Web界面管理Zabbix监控系统的场景，包括：
- 管理被监控主机、模板、触发器和告警规则
- 查看实时监控数据、历史趋势和报表
- 配置用户权限和审计日志
- 集成第三方系统（如Elasticsearch、Vault）扩展监控能力

适合企业IT运维团队、DevOps工程师和监控系统管理员使用，尤其适用于容器化部署的Zabbix监控环境。

## 使用方法和配置说明

### 启动`zabbix-web-nginx-pgsql`容器

启动Zabbix Web界面容器的命令如下：

```console
docker run --name some-zabbix-web-nginx-pgsql \
  -e DB_SERVER_HOST="some-postgres-server" \
  -e POSTGRES_USER="some-user" \
  -e POSTGRES_PASSWORD="some-password" \
  -e ZBX_SERVER_HOST="some-zabbix-server" \
  -e PHP_TZ="some-timezone" \
  -d zabbix/zabbix-web-nginx-pgsql:tag
```

其中：
- `some-zabbix-web-nginx-pgsql`：容器名称
- `some-postgres-server`：PostgreSQL服务器的IP或DNS名称
- `some-user`：连接PostgreSQL数据库的用户名
- `some-password`：连接PostgreSQL数据库的密码
- `some-zabbix-server`：Zabbix服务器或代理的IP或DNS名称
- `some-timezone`：PHP时区名称（如"Asia/Shanghai"）
- `tag`：指定版本的标签（参见版本列表或[完整标签列表](https://hub.docker.com/r/zabbix/zabbix-web-nginx-pgsql/tags/)）

### 链接容器到Zabbix服务器

```console
docker run --name some-zabbix-web-nginx-pgsql \
  --link some-zabbix-server:zabbix-server \
  -e DB_SERVER_HOST="some-postgres-server" \
  -e POSTGRES_USER="some-user" \
  -e POSTGRES_PASSWORD="some-password" \
  -e ZBX_SERVER_HOST="some-zabbix-server" \
  -e PHP_TZ="some-timezone" \
  -d zabbix/zabbix-web-nginx-pgsql:tag
```

### 链接容器到PostgreSQL数据库

```console
docker run --name some-zabbix-web-nginx-pgsql \
  --link some-postgres-server:postgres \
  -e DB_SERVER_HOST="some-postgres-server" \
  -e POSTGRES_USER="some-user" \
  -e POSTGRES_PASSWORD="some-password" \
  -e ZBX_SERVER_HOST="some-zabbix-server" \
  -e PHP_TZ="some-timezone" \
  -d zabbix/zabbix-web-nginx-pgsql:tag
```

### 容器Shell访问和日志查看

使用`docker exec`命令可在容器内执行命令，获取bash shell：

```console
docker exec -ti some-zabbix-web-nginx-pgsql /bin/bash
```

Zabbix Web界面日志可通过Docker容器日志查看：

```console
docker logs some-zabbix-web-nginx-pgsql
```

### 环境变量

启动容器时，可通过环境变量调整Zabbix Web界面配置，主要变量如下：

#### `ZBX_SERVER_HOST`
Zabbix服务器的IP或DNS名称，默认值为`zabbix-server`。

#### `ZBX_SERVER_PORT`
Zabbix服务器监听端口，默认值为`10051`。

#### `DB_SERVER_HOST`
PostgreSQL服务器的IP或DNS名称，默认值为`postgres-server`。

#### `DB_SERVER_PORT`
PostgreSQL服务器端口，默认值为`5432`。

#### `POSTGRES_USER`、`POSTGRES_PASSWORD`、`POSTGRES_USER_FILE`、`POSTGRES_PASSWORD_FILE`
用于连接PostgreSQL数据库的用户名和密码。`_FILE`变量可指定包含用户名/密码的文件路径（适用于Docker Swarm/Kubernetes Secrets）。两种类型变量互斥，只能使用其中一种。

**非Swarm/Kubernetes环境示例**：
```console
docker run --name some-zabbix-web-nginx-pgsql \
  -e DB_SERVER_HOST="some-postgres-server" \
  -v ./.POSTGRES_USER:/run/secrets/POSTGRES_USER -e POSTGRES_USER_FILE=/run/secrets/POSTGRES_USER \
  -v ./.POSTGRES_PASSWORD:/run/secrets/POSTGRES_PASSWORD -e POSTGRES_PASSWORD_FILE=/var/run/secrets/POSTGRES_PASSWORD \
  -e ZBX_SERVER_HOST="some-zabbix-server" \
  -e PHP_TZ="some-timezone" \
  -d zabbix/zabbix-web-nginx-pgsql:tag
```

**Docker Swarm环境示例**：
```console
printf "zabbix" | docker secret create POSTGRES_USER -
printf "zabbix" | docker secret create POSTGRES_PASSWORD -
docker run --name some-zabbix-web-nginx-pgsql \
  -e DB_SERVER_HOST="some-postgres-server" \
  -e POSTGRES_USER_FILE=/run/secrets/POSTGRES_USER \
  -e POSTGRES_PASSWORD_FILE=/run/secrets/POSTGRES_PASSWORD \
  -e ZBX_SERVER_HOST="some-zabbix-server" \
  -e PHP_TZ="some-timezone" \
  -d zabbix/zabbix-web-nginx-pgsql:tag
```

默认值：`POSTGRES_USER=zabbix`，`POSTGRES_PASSWORD=zabbix`。

#### `POSTGRES_DB`
Zabbix数据库名称，默认值为`zabbix`。

#### `POSTGRES_USE_IMPLICIT_SEARCH_PATH`
某些环境（如PgBouncer）中，通过连接参数设置`search_path`可能失败。设置为`"true"`时，镜像将跳过设置`search_path`，依赖PostgreSQL用户的默认`search_path`配置。

#### `ZBX_HISTORYSTORAGEURL`
Elasticsearch历史存储的HTTP[S] URL，用于将历史数据存储到Elasticsearch，3.4.5版本起可用。

#### `ZBX_HISTORYSTORAGETYPES`
要发送到历史存储的数值类型数组，例如`['uint', 'dbl']`，3.4.5版本起可用。

#### `PHP_TZ`
PHP时区名称（如"Asia/Shanghai"），完整时区列表见[php.net](http://php.net/manual/en/timezones.php)。Zabbix 5.2.0及以上版本默认使用系统时区，旧版本默认值为'Europe/Riga'。

#### `ZBX_SERVER_NAME`
Web界面右上角显示的Zabbix安装名称。

#### `DB_DOUBLE_IEEE754`
为64位数值（浮点）历史值使用IEEE754兼容的值范围，5.0.0版本起可用，默认启用。

#### `ENABLE_WEB_ACCESS_LOG`
设置Web服务器的访问日志指令，默认输出到标准输出。

#### `HTTP_INDEX_FILE`
默认索引页面，默认值为`index.php`。

#### `EXPOSE_WEB_SERVER_INFO`
是否显示Web服务器和PHP版本，默认值为`on`（显示）。

#### `ZBX_MAXEXECUTIONTIME`
PHP `max_execution_time`选项，默认值为`300`（秒）。

#### `ZBX_MEMORYLIMIT`
PHP `memory_limit`选项，默认值为`128M`。

#### `ZBX_POSTMAXSIZE`
PHP `post_max_size`选项，默认值为`16M`。

#### `ZBX_UPLOADMAXFILESIZE`
PHP `upload_max_filesize`选项，默认值为`2M`。

#### `ZBX_MAXINPUTTIME`
PHP `max_input_time`选项，默认值为`300`（秒）。

#### `ZBX_SESSION_NAME`
Zabbix前端会话Cookie名称，默认值为`zbx_sessionid`。

#### `ZBX_DENY_GUI_ACCESS`
启用Web界面维护模式，设置为`true`时启用。

#### `ZBX_GUI_ACCESS_IP_RANGE`
维护期间允许访问Web界面的IP地址数组。

#### `ZBX_GUI_WARNING_MSG`
Web界面维护期间显示的提示信息。

#### `ZBX_DB_ENCRYPTION`
启用数据库连接加密，设置为`true`时即使未指定其他TLS参数，连接也会使用TLS加密，5.0.0版本起可用，默认禁用。

#### `ZBX_DB_KEY_FILE`、`ZBX_DB_CERT_FILE`、`ZBX_DB_CA_FILE`
TLS密钥文件、证书文件和CA文件的完整路径，5.0.0版本起可用。

#### `ZBX_DB_VERIFY_HOST`
启用主机验证，5.0.0版本起可用。

#### `ZBX_SSO_SP_KEY`、`ZBX_SSO_SP_CERT`、`ZBX_SSO_IDP_CERT`
SAML认证相关证书路径：服务提供者（SP）私钥文件、SP证书文件、身份提供者（IDP）证书文件。

#### `ZBX_SSO_SETTINGS`
JSON格式的自定义SSO设置，5.0.0版本起可用。示例：

```yaml
environment:
  ZBX_SSO_SETTINGS: "{'baseurl': 'https://zabbix-docker.mydomain.com', 'use_proxy_headers': true, 'strict': false}"
```

#### `ZBX_ALLOW_HTTP_AUTH`
是否禁用用户HTTP认证。

#### 其他变量

还支持以下环境变量：

```
ZBX_VAULTDBPATH= # 5.2.0版本起可用
ZBX_VAULTURL=https://127.0.0.1:8200 # 5.2.0版本起可用
VAULT_TOKEN= # 5.2.0版本起可用

ZBX_SERVER_TLS_ACTIVE=false # 7.4.0版本起可用
ZBX_SERVER_TLS_CAFILE= # 7.4.0版本起可用
ZBX_SERVER_TLS_CA= # 7.4.0版本起可用
ZBX_SERVER_TLS_KEYFILE= # 7.4.0版本起可用
ZBX_SERVER_TLS_KEY= # 7.4.0版本起可用
ZBX_SERVER_TLS_CERTFILE= # 7.4.0版本起可用
ZBX_SERVER_TLS_CERT= # 7.4.0版本起可用
ZBX_SERVER_TLS_CERT_ISSUER= # 7.4.0版本起可用
ZBX_SERVER_TLS_CERT_SUBJECT= # 7.4.0版本起可用

# PHP-FPM配置选项
PHP_FPM_PM=dynamic
PHP_FPM_PM_MAX_CHILDREN=50
PHP_FPM_PM_START_SERVERS=5
PHP_FPM_PM_MIN_SPARE_SERVERS=5
PHP_FPM_PM_MAX_SPARE_SERVERS=35
PHP_FPM_PM_MAX_REQUESTS=0

# Nginx配置选项
WEB_REAL_IP_FROM=
WEB_REAL_IP_HEADER=
```

### 允许挂载的卷

#### `/etc/ssl/nginx`
用于启用Web界面HTTPS，需包含三个文件：`ssl.crt`（SSL证书）、`ssl.key`（SSL密钥）和`dhparam.pem`（Diffie-Hellman参数）。详细配置参见Nginx官方[HTTPS服务器文档](http://nginx.org/en/docs/http/configuring_https_servers.html)。

#### `/etc/zabbix/web/certs`
用于SAML认证的自定义证书，需包含三个文件：`sp.key`（SP私钥）、`sp.crt`（SP证书）和`idp.crt`（IDP证书），5.0.0版本起可用。

#### `/var/lib/zabbix/enc`
存储TLS相关文件，文件路径通过`ZBX_SERVER_TLS_CAFILE`、`ZBX_SERVER_TLS_KEYFILE`、`ZBX_SERVER_TLS_CERTFILE`指定。也可通过`ZBX_SERVER_TLS_CA`、`ZBX_SERVER_TLS_KEY`、`ZBX_SERVER_TLS_CERT`环境变量提供明文内容，7.4.0版本起可用。

## 镜像变体

`zabbix-web-nginx-pgsql`镜像提供多种变体，适用于不同场景：

### `zabbix-web-nginx-pgsql:alpine-<version>`
基于Alpine Linux构建，体积极小（约5MB基础镜像），适合对镜像大小有严格要求的场景。使用musl libc而非glibc，部分依赖glibc的软件可能存在兼容性问题，但大多数软件可正常运行。如需额外工具（如`git`、`bash`），需在Dockerfile中自行安装。

### `zabbix-web-nginx-pgsql:ubuntu-<version>`
默认推荐镜像，基于Ubuntu 24.04，兼容性好，包含常用工具，适合大多数场景，既可作为临时容器使用，也可作为基础镜像构建其他镜像。

### `zabbix-web-nginx-pgsql:ol-<version>`
基于Oracle Linux构建，适合Oracle工作负载，包含Ksplice（零停机内核补丁）、DTrace（实时诊断）、Btrfs文件系统等Oracle特有功能，经过严格的实际工作负载测试。

## 支持的Docker版本

官方支持Docker 1.12.0版本，对旧版本（低至1.6）提供尽力支持。升级Docker引擎请参考[Docker安装文档](
