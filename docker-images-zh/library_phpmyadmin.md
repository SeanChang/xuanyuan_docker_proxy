---
image: library/phpmyadmin
description: "phpMyAdmin是一款广泛应用的开源Web界面工具，专为MySQL和MariaDB关系型数据库管理系统设计，支持用户通过Web浏览器便捷执行数据库及数据表的创建、查询、修改、删除等基础操作，同时提供用户权限配置、数据导入导出、SQL语句执行与优化、数据库备份恢复等进阶功能，帮助开发者与数据库管理员无需依赖命令行环境即可高效管理数据库，有效简化数据库日常维护与操作流程。"
source: https://xuanyuan.cloud/zh/r/library/phpmyadmin
canonical: https://xuanyuan.cloud/zh/r/library/phpmyadmin
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/phpmyadmin" title="library/phpmyadmin Docker 镜像中文简介、标签列表与拉取命令">library/phpmyadmin — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/phpmyadmin" title="library/phpmyadmin Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/phpmyadmin</a>

# phpMyAdmin Docker 镜像使用指南


## 概述

phpMyAdmin 是一款免费的 PHP 软件工具，用于通过 Web 界面管理 MySQL 和 MariaDB 数据库。它支持数据库、表、列、关系、索引、用户权限等常见操作，同时也允许直接执行 SQL 语句。本 Docker 镜像提供了基于 Alpine、Apache 和 PHP FPM 的运行环境。


## 快速参考

### 维护方
[phpMyAdmin]([])

### 帮助支持
可通过以下渠道获取帮助：  
[Docker Community Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])

### 问题反馈
提交问题至：[[]]([])

### 支持的架构
（更多信息见 [官方说明]([])）  
`amd64`、`arm32v5`、`arm32v6`、`arm32v7`、`arm64v8`、`i386`、`ppc64le`、`riscv64`、`s390x`  
（各架构镜像地址可通过链接查看，例如 [amd64]([])）

### 镜像信息
- 镜像元数据、传输大小等详情：[repo-info 仓库的 `repos/phpmyadmin/` 目录]([])（含 [历史记录]([])）
- 镜像更新：[official-images 仓库的 `library/phpmyadmin` 标签]([]) 及 [文件]([])（含 [历史记录]([])）
- 本文档来源：[docs 仓库的 `phpmyadmin/` 目录]([])（含 [历史记录]([])）


## 支持的标签及对应 Dockerfile

| 标签 | Dockerfile 链接 |
|------|----------------|
| `5.2.3-apache`, `5.2-apache`, `5-apache`, `apache`, `5.2.3`, `5.2`, `5`, `latest` | [apache/Dockerfile]([]) |
| `5.2.3-fpm`, `5.2-fpm`, `5-fpm`, `fpm` | [fpm/Dockerfile]([]) |
| `5.2.3-fpm-alpine`, `5.2-fpm-alpine`, `5-fpm-alpine`, `fpm-alpine` | [fpm-alpine/Dockerfile]([]) |


## 如何使用本镜像

所有示例均会在 `[] 启动 phpMyAdmin，用于管理 MySQL 或 MariaDB。


### 镜像变体

本镜像提供三种变体，适用于不同场景：
- **apache**：包含完整的 Apache 服务器和 PHP，开箱即用。指定版本号时默认使用此变体。
- **fpm**：仅启动 PHP FPM 容器，需配合独立的 Web 服务器使用。包含更多工具，镜像体积比 `fpm-alpine` 大。
- **fpm-alpine**：基于 Alpine Linux，体积极小，仅启动 PHP FPM 进程。需配合独立 Web 服务器，适合对镜像大小敏感的场景；若需 Alpine 不支持的工具，建议使用 `fpm` 变体。


### 数据库凭证

phpMyAdmin 通过 MySQL 服务器的凭证连接，需参考数据库镜像的默认用户名/密码配置，或自定义凭证。官方 MySQL/MariaDB 镜像通常使用以下环境变量：
- `MYSQL_ROOT_PASSWORD`：必填，设置 root 用户密码。
- `MYSQL_USER`、`MYSQL_PASSWORD`：可选，用于创建自定义用户及密码。


### 使用示例

#### 1. 与已链接的数据库服务器配合使用
先运行 MySQL/MariaDB 容器，再链接 phpMyAdmin 容器：
```sh
docker run --name phpmyadmin -d --link mysql_db_server:db -p 8080:80 phpmyadmin
```
（`mysql_db_server` 为数据库容器名称，`db` 为链接别名）


#### 2. 连接外部数据库服务器
通过 `PMA_HOST` 指定外部数据库地址，`PMA_PORT` 指定端口（非默认时）：
```sh
docker run --name phpmyadmin -d -e PMA_HOST=dbhost -p 8080:80 phpmyadmin
```
（`dbhost` 为外部数据库的 IP 或域名）


#### 3. 支持任意数据库服务器连接
设置 `PMA_ARBITRARY=1`，允许在登录页输入任意 MySQL/MariaDB 服务器信息：
```sh
docker run --name phpmyadmin -d -e PMA_ARBITRARY=1 -p 8080:80 phpmyadmin
```


#### 4. 使用 Docker Compose
以下示例通过 `docker compose` 启动 phpMyAdmin 和 MariaDB，并启用任意服务器连接：
```yaml
# compose.yaml
services:
  db:
    image: mariadb:10.11
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: notSecureChangeMe  # 替换为实际密码

  phpmyadmin:
    image: phpmyadmin
    restart: always
    ports:
      - 8080:80
    environment:
      - PMA_ARBITRARY=1
```
启动命令：`docker compose up -d`


### 自定义配置

#### 方法 1：通过 `config.user.inc.php`
创建 `config.user.inc.php` 文件（首行需为 `<?php`），添加自定义配置（如启用高级功能），并挂载到容器：
```sh
docker run --name phpmyadmin -d --link mysql_db_server:db -p 8080:80 \
  -v /本地路径/config.user.inc.php:/etc/phpmyadmin/config.user.inc.php \
  phpmyadmin
```
示例配置（启用 phpinfo 链接）：
```php
<?php
$cfg['ShowPhpInfo'] = true;  // 在首页添加 phpinfo() 链接
```
配置详情参考：[phpMyAdmin 文档]([])、[安装指南]([])


#### 方法 2：通过 `/etc/phpmyadmin/conf.d` 目录
将多个配置文件（如 `server-1.php`、`server-2.php`）放入宿主机目录，挂载到容器的 `/etc/phpmyadmin/conf.d`：
```sh
docker run --name phpmyadmin -d --link mysql_db_server:db -p 8080:80 \
  -v /本地路径/conf.d:/etc/phpmyadmin/conf.d:ro \
  phpmyadmin
```
（`:ro` 表示只读挂载）


### 反向代理场景
若通过反向代理访问 phpMyAdmin，需设置 `PMA_ABSOLUTE_URI` 为完整访问路径（如 `[] 会话持久化
为避免容器重启后会话丢失，需挂载 `/sessions` 目录：
```sh
docker run --name phpmyadmin -d --link mysql_db_server:db -p 8080:80 \
  -v /本地路径/sessions:/sessions:rw \
  phpmyadmin
```


### 通过 SSL 连接数据库
设置 `PMA_SSL=1` 启用 SSL 连接；多服务器时，用 `PMA_SSLS` 指定各服务器是否启用（逗号分隔的 `0`/`1`）：
```sh
# 单服务器
docker run --name phpmyadmin -d -e PMA_HOST=sslhost -e PMA_SSL=1 -p 8080:80 phpmyadmin

# 多服务器（第一个启用 SSL，第二个不启用）
docker run --name phpmyadmin -d -e PMA_HOSTS='sslhost,nosslhost' -e PMA_SSLS='1,0' -p 8080:80 phpmyadmin
```


### 环境变量汇总

| 变量名 | 说明 |
|--------|------|
| `PMA_ARBITRARY` | 设为 `1` 允许连接任意服务器 |
| `PMA_HOST`/`PMA_HOSTS` | 单个/多个数据库地址（逗号分隔） |
| `PMA_PORT`/`PMA_PORTS` | 单个/多个数据库端口（逗号分隔） |
| `PMA_SSL`/`PMA_SSLS` | 单个/多个数据库是否启用 SSL（`0`/`1`，逗号分隔） |
| `PMA_ABSOLUTE_URI` | 反向代理场景下的完整访问路径 |
| `PMA_USER`/`PMA_PASSWORD` | 配置认证方式的用户名/密码（支持 `_FILE` 后缀读取文件，如 `PMA_PASSWORD_FILE=/run/secrets/pass.txt`） |
| `MAX_EXECUTION_TIME` | 覆盖 PHP 最大执行时间（秒，默认 600） |
| `MEMORY_LIMIT` | 覆盖 PHP 内存限制（默认 512M，格式如 `1G`） |
| `UPLOAD_LIMIT` | 覆盖上传限制（默认 2048K，格式如 `10M`） |

更多变量及详细说明见 [官方文档]([])。


## 镜像变体详情

### `phpmyadmin:<version>-alpine`
基于 Alpine Linux，镜像体积极小（约 5MB 基础镜像），适合对大小敏感的场景。但需注意：Alpine 使用 musl libc，部分依赖 glibc 的软件可能存在兼容性问题。如需额外工具（如 `git`、`bash`），需在 Dockerfile 中自行安装。


## 许可证

镜像中软件的许可信息见 [phpmyadmin/docker 仓库 LICENSE]([])。  
Docker 镜像可能包含其他软件（如基础系统的 Bash 等），其许可证需用户自行确认合规性。  
自动检测的许可信息可参考 [repo-info 仓库的 `phpmyadmin/` 目录]([])。
