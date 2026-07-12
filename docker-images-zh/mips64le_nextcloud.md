---
image: mips64le/nextcloud
description: "Nextcloud社区维护的Docker镜像，适用于专家用户手动部署，提供安全的数据存储、文件访问与共享功能，支持多种架构，需配合外部数据库和持久化存储使用。"
source: https://xuanyuan.cloud/zh/r/mips64le/nextcloud
canonical: https://xuanyuan.cloud/zh/r/mips64le/nextcloud
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mips64le/nextcloud" title="mips64le/nextcloud Docker 镜像中文简介、标签列表与拉取命令">mips64le/nextcloud 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 重要提示
⚠️⚠️⚠️ 此镜像由社区志愿者维护，适用于专家使用。如需快速轻松部署并支持全套Nextcloud Hub功能，请使用Nextcloud GmbH维护的[Nextcloud All-in-One Docker容器](https://github.com/nextcloud/all-in-one#nextcloud-all-in-one)。

# 快速参考
- **维护者**：  
  [Nextcloud社区](https://github.com/nextcloud/docker)

- **获取帮助**：  
  [Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

# 支持的标签及对应的`Dockerfile`链接
**警告**：此镜像在`mips64le`架构上**不受支持**

# 快速参考（续）
- **问题反馈地址**：  
  [https://github.com/nextcloud/docker/issues](https://github.com/nextcloud/docker/issues?q=)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  [`amd64`](https://hub.docker.com/r/amd64/nextcloud/)、[`arm32v5`](https://hub.docker.com/r/arm32v5/nextcloud/)、[`arm32v6`](https://hub.docker.com/r/arm32v6/nextcloud/)、[`arm32v7`](https://hub.docker.com/r/arm32v7/nextcloud/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/nextcloud/)、[`i386`](https://hub.docker.com/r/i386/nextcloud/)、[`ppc64le`](https://hub.docker.com/r/ppc64le/nextcloud/)、[`riscv64`](https://hub.docker.com/r/riscv64/nextcloud/)、[`s390x`](https://hub.docker.com/r/s390x/nextcloud/)

- **镜像 artifact 详情**：  
  [repo-info仓库的`repos/nextcloud/`目录](https://github.com/docker-library/repo-info/blob/master/repos/nextcloud) ([历史记录](https://github.com/docker-library/repo-info/commits/master/repos/nextcloud))  
 （镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images仓库的`library/nextcloud`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fnextcloud)  
  [official-images仓库的`library/nextcloud`文件](https://github.com/docker-library/official-images/blob/master/library/nextcloud) ([历史记录](https://github.com/docker-library/official-images/commits/master/library/nextcloud))

- **此描述的来源**：  
  [docs仓库的`nextcloud/`目录](https://github.com/docker-library/docs/tree/master/nextcloud) ([历史记录](https://github.com/docker-library/docs/commits/master/nextcloud))

# 什么是Nextcloud？
Nextcloud是一个安全的数据家园，可从任何设备访问和共享文件、日历、联系人、邮件等数据，完全由你掌控。

> [Nextcloud.com](https://nextcloud.com/)

此Docker微服务镜像由Nextcloud社区开发和维护。Nextcloud GmbH不为此Docker镜像提供支持。如需专业支持，可成为[企业客户](https://nextcloud.com/enterprise/)或使用[All-in-One](https://github.com/nextcloud/all-in-one#nextcloud-all-in-one)。

# 如何使用此镜像
此镜像设计用于微服务环境，提供两种版本供选择：

`apache`标签包含完整的Nextcloud安装，包括Apache Web服务器，易于使用，可快速启动。这也是`latest`标签和未指定版本标签的默认版本。

第二种选择是`fpm`容器，基于[php-fpm](https://hub.docker.com/_/php/)镜像，运行FastCGI进程来提供Nextcloud页面。使用此镜像需配合可将HTTP请求代理到容器FastCGI端口的Web服务器。

## 使用apache镜像
apache镜像包含Web服务器，暴露80端口。启动容器命令：

```console
$ docker run -d -p 8080:80 mips64le/nextcloud
```

现在可通过主机系统的http://localhost:8080/访问Nextcloud。

## 使用fpm镜像
使用fpm镜像需额外的Web服务器（如[nginx](https://docs.nextcloud.com/server/latest/admin_manual/installation/nginx.html)），将HTTP请求代理到容器的fpm端口。fpm容器暴露9000端口。通常无需将fpm端口映射到主机，而是通过Docker网络与Web服务器容器通信。

```console
$ docker run -d mips64le/nextcloud:fpm
```

由于FastCGI进程无法提供静态文件（样式表、图片等）Web服务器需访问这些文件，可通过`volumes-from`选项实现，详见Docker Compose部分。

## 使用外部数据库
默认情况下，容器使用SQLite存储数据，但Nextcloud设置向导（首次运行时出现）允许连接到现有MySQL/MariaDB或PostgreSQL数据库。也可链接数据库容器（如`--link my-mysql:mysql`），然后在设置时使用`mysql`作为数据库主机。更多信息见Docker Compose部分。

## 持久化数据
Nextcloud安装和所有数据库之外的数据（文件上传等）存储在未命名Docker卷`/var/www/html`中。Docker守护进程将数据存储在`/var/lib/docker/volumes/...`目录，即使容器崩溃、停止或删除，数据仍保留。

升级和备份时应使用命名卷或挂载主机目录。需为数据库容器和Nextcloud分别设置卷：

Nextcloud：
- `/var/www/html/`：所有Nextcloud数据所在目录

```console
$ docker run -d \
-v nextcloud:/var/www/html \
mips64le/nextcloud
```

数据库：
- `/var/lib/mysql`：MySQL/MariaDB数据
- `/var/lib/postgresql/data`：PostgreSQL数据

```console
$ docker run -d \
-v db:/var/lib/mysql \
mariadb:10.6
```

### 额外卷
如需精细控制文件访问，可挂载数据、配置、主题和自定义应用的额外卷。`data`、`config`存储在`/var/www/html/`的子目录中，应用分为核心`apps`（随Nextcloud提供）和`custom_apps`（自定义应用），主题存储在`themes`子目录。

可挂载的目录：
- `/var/www/html`：主目录，升级必需
- `/var/www/html/custom_apps`：已安装/修改的应用
- `/var/www/html/config`：本地配置
- `/var/www/html/data`：用户文件数据
- `/var/www/html/themes/<YOUR_CUSTOM_THEME>`：自定义主题

使用命名卷挂载所有这些目录的示例：

```console
$ docker run -d \
-v nextcloud:/var/www/html \
-v apps:/var/www/html/custom_apps \
-v config:/var/www/html/config \
-v data:/var/www/html/data \
-v theme:/var/www/html/themes/<YOUR_CUSTOM_THEME> \
mips64le/nextcloud
```

### 自定义卷
在`/var/www/html`下挂载额外卷时，需注意：
- 确认[upgrade.exclude](https://github.com/nextcloud/docker/blob/master/upgrade.exclude)包含安装和升级期间需保留的文件和文件夹；或
- 将存储卷挂载到`/var/www/html`之外的位置。

> 注意：`/var/www/html`目录中的数据在安装和升级期间可能被覆盖/删除，除非在[upgrade.exclude](https://github.com/nextcloud/docker/blob/master/upgrade.exclude)中列出。官方支持的额外卷已在列表中，自定义卷需自行添加。建议将自定义存储卷挂载到`/var/www/html`之外，且尽可能设为只读，避免调整。如必须在`/var/www/html`下挂载，需构建包含修改后`/upgrade.exclude`文件的自定义镜像。

## 使用Nextcloud命令行界面
使用[Nextcloud命令行界面](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/occ_command.html)（即`occ`命令）：

```console
$ docker exec --user www-data 容器ID php occ
```

或使用`docker compose`：

```console
$ docker compose exec --user www-data app php occ
```

## 通过环境变量自动配置
Nextcloud镜像支持通过环境变量自动配置，可预配置首次运行时安装页面的所有选项。需通过以下环境变量指定数据库连接，必须为所选数据库类型指定所有环境变量，否则默认使用SQLITE。**仅使用一种数据库类型！**

### 数据库配置
**SQLite**：
- `SQLITE_DATABASE`：使用SQLite的数据库名称

**MYSQL/MariaDB**：
- `MYSQL_DATABASE`：数据库名称
- `MYSQL_USER`：数据库用户名
- `MYSQL_PASSWORD`：数据库用户密码
- `MYSQL_HOST`：数据库服务器主机名

**PostgreSQL**：
- `POSTGRES_DB`：数据库名称
- `POSTGRES_USER`：数据库用户名
- `POSTGRES_PASSWORD`：数据库用户密码
- `POSTGRES_HOST`：数据库服务器主机名

> 作为通过环境变量传递敏感信息的替代方式，可在上述环境变量后附加`_FILE`，使初始化脚本从容器内的文件加载值。

### 管理员与基础配置
- `NEXTCLOUD_ADMIN_USER`：管理员用户名（需与密码同时设置）
- `NEXTCLOUD_ADMIN_PASSWORD`：管理员密码（需与用户名同时设置）
- `NEXTCLOUD_DATA_DIR`（默认：`/var/www/html/data`）：用户文件存储目录
- `NEXTCLOUD_TRUSTED_DOMAINS`（默认未设置）：空格分隔的受信任域名列表
- `NEXTCLOUD_UPDATE`（默认：`0`）：使用自定义命令时设为1启用安装/更新
- `NEXTCLOUD_INIT_HTACCESS`（默认未设置）：设为`true`启用初始化时更新htaccess

### 缓存与性能
- `REDIS_HOST`（默认未设置）：Redis容器名称
- `REDIS_HOST_PORT`（默认：`6379`）：Redis端口（仅用于非标准端口外部服务器）
- `REDIS_HOST_PASSWORD`（默认未设置）：Redis密码（推荐使用Redis防止文件锁定）

### 邮件配置
- `SMTP_HOST`：SMTP服务器主机名
- `SMTP_SECURE`（默认空）：`ssl`（SSL）或`tls`（STARTTLS）
- `SMTP_PORT`（默认：SSL为`465`，非安全为`25`）：SMTP端口（STARTTLS推荐`587`）
- `SMTP_AUTHTYPE`（默认：`LOGIN`）：认证方法（无需认证时用`PLAIN`）
- `SMTP_NAME`：认证用户名
- `SMTP_PASSWORD`：认证密码
- `MAIL_FROM_ADDRESS`：发件人本地部分
- `MAIL_DOMAIN`：发件人域名  
 （至少需设置`SMTP_HOST`、`MAIL_FROM_ADDRESS`和`MAIL_DOMAIN`）

### 对象存储配置
**S3兼容存储**：
- `OBJECTSTORE_S3_BUCKET`：存储桶名称
- `OBJECTSTORE_S3_REGION`：区域
- `OBJECTSTORE_S3_HOST`：服务器主机名
- `OBJECTSTORE_S3_PORT`：服务器端口
- `OBJECTSTORE_S3_KEY`/`OBJECTSTORE_S3_SECRET`：访问密钥/密钥
- `OBJECTSTORE_S3_STORAGE_CLASS`：存储类别
- `OBJECTSTORE_S3_SSL`（默认：`true`）：是否使用SSL
- 其他参数：`USEPATH_STYLE`、`LEGACYAUTH`、`OBJECT_PREFIX`、`AUTOCREATE`、`SSE_C_KEY`

**OpenStack Swift存储**：
- `OBJECTSTORE_SWIFT_URL`：身份端点
- `OBJECTSTORE_SWIFT_USER_NAME`/`PASSWORD`：用户名/密码
- `OBJECTSTORE_SWIFT_PROJECT_NAME`：项目名称
- `OBJECTSTORE_SWIFT_REGION`：区域
- `OBJECTSTORE_SWIFT_CONTAINER_NAME`：容器名称
- 其他参数：`AUTOCREATE`、`USER_DOMAIN`、`PROJECT_DOMAIN`、`SERVICE_NAME`

### PHP与Apache配置
- `PHP_MEMORY_LIMIT`（默认`512M`）：脚本最大内存限制
- `PHP_UPLOAD_LIMIT`（默认`512M`）：上传文件大小限制
- `APACHE_BODY_LIMIT`（默认`1073741824` [1GiB]）：Apache请求体大小限制（字节，`0`为无限制）

## 通过hook文件夹自动配置
提供5个钩子文件夹，存放`.sh`可执行脚本（仅根目录文件执行）：
- `pre-installation`：安装前
- `post-installation`：安装后
- `pre-upgrade`：升级前
- `post-upgrade`：升级后
- `before-starting`：启动前

**示例**：通过卷挂载主机脚本：

```yaml
...
  app:
    image: docker.xuanyuan.run/mips64le/nextcloud:stable
    volumes:
      - ./app-hooks/pre-installation:/docker-entrypoint-hooks.d/pre-installation
      - ./app-hooks/post-installation:/docker-entrypoint-hooks.d/post-installation
      - ./app-hooks/pre-upgrade:/docker-entrypoint-hooks.d/pre-upgrade
      - ./app-hooks/post-upgrade:/docker-entrypoint-hooks.d/post-upgrade
      - ./app-hooks/before-starting:/docker-entrypoint-hooks.d/before-starting
...
```

## 反向代理配置
apache镜像默认从`10.0.0.0/8`、`172.16.0.0/12`或`192.168.0.0/16`网段代理请求中获取`X-Real-IP`。如需从受信任代理获取主机/协议/客户端IP：

- `APACHE_DISABLE_REWRITE_IP=1`：禁用IP重写
- `TRUSTED_PROXIES="代理IP/CIDR 列表"`：设置受信任代理

或使用固定覆盖参数：
- `OVERWRITEHOST`：代理主机名（可带端口）
- `OVERWRITEPROTOCOL`：协议（`http`/`https`）
- `OVERWRITECLIURL`：CLI访问URL（如`https://example.com`）
- `OVERWRITEWEBROOT`：绝对路径
- `OVERWRITECONDADDR`：基于远程地址的覆盖正则表达式

# 使用Docker Compose运行此镜像
## 基础版本 - apache
使用apache镜像和MariaDB，卷持久化数据，**无SSL加密**（适用于代理后）。运行前设置`MYSQL_ROOT_PASSWORD`和`MYSQL_PASSWORD`。

```yaml
volumes:
  nextcloud:
  db:

services:
  db:
    image: docker.xuanyuan.run/mariadb:10.6
    restart: always
    command: --transaction-isolation=READ-COMMITTED --log-bin=binlog --binlog-format=ROW
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=
      - MYSQL_PASSWORD=
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud

  app:
    image: docker.xuanyuan.run/mips64le/nextcloud
    restart: always
    ports:
      - 8080:80
    links:
      - db
    volumes:
      - nextcloud:/var/www/html
    environment:
      - MYSQL_PASSWORD=
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=db
```

运行`docker compose up -d`后通过http://localhost:8080/访问。

## 基础版本 - FPM
需配合nginx（静态文件访问通过`volumes_from`），**无加密**，运行前设置数据库密码。

```yaml
volumes:
  nextcloud:
  db:

services:
  db:
    image: mariadb:10.6
    restart: always
    command: --transaction-isolation=READ-COMMITTED --log-bin=binlog --binlog-format=ROW
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=
      - MYSQL_PASSWORD=
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud

  app:
    image: mips64le/nextcloud:fpm
    restart: always
    links:
      - db
    volumes:
      - nextcloud:/var/www/html
    environment:
      - MYSQL_PASSWORD=
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=db

  web:
    image: nginx
    restart: always
    ports:
      - 8080:80
    links:
      - app
