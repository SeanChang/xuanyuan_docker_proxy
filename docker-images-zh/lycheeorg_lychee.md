---
image: lycheeorg/lychee
description: "Lychee照片管理系统Docker镜像，集成nginx和PHP-FPM，遵循官方推荐配置，支持amd64、arm64、armv6、armv7等多种架构，可快速部署个人或家庭照片库，支持SQLite、MySQL、PostgreSQL等数据库。"
source: https://xuanyuan.cloud/zh/r/lycheeorg/lychee
canonical: https://xuanyuan.cloud/zh/r/lycheeorg/lychee
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/lycheeorg/lychee" title="lycheeorg/lychee Docker 镜像中文简介、标签列表与拉取命令">lycheeorg/lychee 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Lychee Docker镜像文档

## 镜像概述

本镜像包含Lychee照片管理系统、nginx和PHP-FPM，其配置（PHP、nginx等）遵循Lychee官方推荐标准。支持amd64、arm64/aarch64、armv6、armv7多种架构，适用于快速搭建个人或家庭照片库，支持多种数据库后端。

## 镜像内容

### 可用标签

* `latest`：最新Lychee发布版
* `v[NUMBER]`：Lychee稳定版本标签（如v4.7.0）
* `nightly`（别名`dev`）：当前主分支标签（Lychee主分支保持稳定，通常可安全使用）
* `devtools`：包含开发依赖的主分支版本
* `testing`：用于测试新分支和拉取请求的标签，主要供LycheeOrg内部使用
* `alpha`：当前alpha分支标签（包含未经过同行评审的前沿变更）
* `alpha-devtools`：包含开发依赖的alpha分支版本

## 部署指南

### 快速启动

若使用内置SQLite支持，无需外部依赖。最简单的启动命令：
```bash
docker run -p 80 docker.xuanyuan.run/lycheeorg/lychee:dev
```
容器将在本地随机端口启动Lychee服务。更多运行选项见下文。

### 前提条件

若使用MySQL、MariaDB或PostgreSQL，需提前准备外部数据库服务（可通过Docker容器部署，例如在`docker-compose.yml`中定义）：
1. 创建数据库、用户名及密码
2. 通过以下方式配置环境变量（数据库凭据、语言等）：
   * 在`docker run`或`docker-compose`中传递环境变量
   * 创建`.env`文件并挂载至容器`/conf/.env`路径
   * 在启动命令中传递`-e DB_CONNECTION=`，首次访问时通过浏览器完成安装向导

### 使用Docker运行

**确保已连接至数据库容器所在网络！**

以下示例使用`--net`连接数据库所在网络，`--link`关联数据库容器：

```bash
docker run -d \
--name=lychee \
-v /宿主机路径/lychee/conf:/conf \
-v /宿主机路径/lychee/uploads:/uploads \
-v /宿主机路径/lychee/sym:/sym \
-e PUID=1000 \
-e PGID=1000 \
-e PHP_TZ=Asia/Shanghai \
-e TIMEZONE=Asia/Shanghai \
-e DB_CONNECTION=mysql \
-e DB_HOST=mariadb \
-e DB_PORT=3306 \
-e DB_DATABASE=lychee \
-e DB_USERNAME=user \
-e DB_PASSWORD=password \
-p 90:80 \
--net network_name \
--link db_name \
docker.xuanyuan.run/lycheeorg/lychee
```

**注意**：若使用MySQL数据库，需确保启用`mysql_native_password`认证插件。可在启动MySQL时添加`--default-authentication-plugin=mysql_native_password`选项，或执行以下SQL命令：
```sql
alter user 'lychee' identified with mysql_native_password by '<你的密码>';
```

### 使用Docker Compose运行

修改[示例配置文件](https://github.com/LycheeOrg/Lychee-Docker/blob/master/docker-compose.yml)中的环境变量以匹配数据库凭据。

为避免明文存储凭据，可创建`db_secrets.env`文件，并通过`env_file`指令引用（详见[Docker Compose文档](https://docs.docker.com/compose/environment-variables/#the-env_file-configuration-option)）。

## 首次运行创建管理员账户

若设置`ADMIN_USER`和`ADMIN_PASSWORD`（或`ADMIN_PASSWORD_FILE`）环境变量，首次运行时将自动创建管理员账户。未设置时，首次加载Lychee会在浏览器中提示创建管理员。

## Docker密钥支持

除通过环境变量传递敏感信息外，可在部分环境变量后添加`_FILE`后缀，使初始化脚本从容器内文件加载值（适用于Docker Secrets，文件路径通常为`/run/secrets/<secret_name>`）。若同时设置原变量和`_FILE`变量（如`DB_PASSWORD`和`DB_PASSWORD_FILE`），将优先使用原变量。

支持的`_FILE`变量：
* `DB_PASSWORD_FILE`
* `REDIS_PASSWORD_FILE`
* `MAIL_PASSWORD_FILE`
* `ADMIN_PASSWORD_FILE`

## 可用环境变量及默认值

若未提供环境变量或`.env`文件，将使用[示例.env文件](https://github.com/LycheeOrg/Lychee/blob/master/.env.example)，其中部分Docker特定变量默认值如下：

| 变量名          | 默认值   | 说明                     |
|-----------------|----------|--------------------------|
| `PUID`          | 1000     | 运行容器的用户ID         |
| `PGID`          | 1000     | 运行容器的用户组ID       |
| `USER`          | `lychee` | 容器内运行用户名称       |
| `PHP_TZ`        | `UTC`    | PHP时区                  |
| `STARTUP_DELAY` | 0        | 启动延迟时间（秒）       |

## 高级配置

### PHP与nginx自定义

默认配置中，nginx支持最大100MB文件上传（`client_max_body_size 100M`），PHP参数已按[Lychee FAQ推荐](https://lycheeorg.github.io/docs/faq.html#i-cant-upload-large-photos)优化。如需进一步自定义：

#### 方法1：挂载自定义`php.ini`
将自定义`php.ini`挂载至`/etc/php/8.2/fpm/php.ini`，但此方式会覆盖所有PHP参数，且PHP版本更新时需重新适配。

#### 方法2：通过nginx配置自定义PHP参数（推荐）
1. 以[默认配置文件](https://github.com/LycheeOrg/Lychee-Docker/blob/master/default.conf)为基础
2. 找到以`fastcgi_param PHP_VALUE [...]`开头的行
3. 添加新行设置参数（如`upload_max_filesize = 200M`）
4. 调整其他参数（如`client_max_body_size`）
5. 将自定义配置挂载至容器`/etc/nginx/nginx.conf`

如需添加（非修改）nginx指令，可将文件挂载至`/etc/nginx/conf.d/`，这些文件会在`http`上下文中被自动包含。
