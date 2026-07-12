---
image: shinsenter/php
description: "简化的PHP Docker镜像，便于轻松定制和扩展设置。"
source: https://xuanyuan.cloud/zh/r/shinsenter/php
canonical: https://xuanyuan.cloud/zh/r/shinsenter/php
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/shinsenter/php" title="shinsenter/php Docker 镜像中文简介、标签列表与拉取命令">shinsenter/php 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PHP Docker镜像文档

📦 简化的PHP Docker镜像，支持轻松定制和扩展设置。


## 镜像概述和主要用途

本PHP Docker镜像基于[官方PHP Docker镜像](https://hub.docker.com/_/php)构建，支持PHP 5.6至8.5（beta）版本，提供CLI、ZTS、FPM、FPM/Apache2、FPM/Nginx、RoadRunner和FrankenPHP等多种变体，同时提供Debian和Alpine两种基础版本。

核心优势包括：
- 通过环境变量轻松调整PHP和PHP-FPM配置，无需重建镜像
- 预安装最新版Composer及Apache2、Nginx、RoadRunner、FrankenPHP等Web服务器
- 相比官方基础镜像显著减小体积，优化下载速度和资源占用
- 支持自定义应用目录、用户权限、钩子脚本、定时任务等高级功能

**适用场景**：快速搭建PHP开发环境、生产环境部署、多版本PHP项目兼容、需要灵活配置PHP参数的场景。


## 核心功能和特性

### 多版本与变体支持
- 覆盖PHP 5.6至8.5（beta）版本
- 提供多种运行模式：`cli`、`zts`、`fpm`、`fpm-nginx`、`fpm-apache`、`roadrunner`（PHP ≥8.0）、`frankenphp`（PHP ≥8.2，beta）
- 支持Debian和Alpine两种基础镜像，满足不同体积和依赖需求

### 灵活配置
- 通过`PHP_*`环境变量直接自定义php.ini和php-fpm.conf参数（如`PHP_DISPLAY_ERRORS=1`）
- 支持运行时动态调整PHP配置（需设置`ALLOW_RUNTIME_PHP_ENVVARS=1`）
- 自定义应用目录（`APP_PATH`）和文档根目录（`DOCUMENT_ROOT`）

### 扩展管理
- 预安装常用PHP扩展（apcu、bcmath、gd、redis等）
- 通过`phpaddmod`命令一键安装额外扩展（如`phpaddmod imagick xdebug`），自动处理依赖和配置

### 高级功能
- **钩子机制**：支持`onboot`、`first-run`、`migration`等多种钩子脚本，定制容器生命周期行为
- **自动运行脚本**：`/startup/`目录下的脚本会按文件名顺序自动执行
- **定时任务**：通过`ENABLE_CRONTAB=1`启用crontab服务，支持环境变量定义任务
- **邮件发送**：集成msmtp，通过环境变量配置SMTP服务器实现邮件发送
- **用户权限定制**：通过`APP_USER`、`APP_UID`等环境变量自定义容器内用户和组


## 使用场景和适用范围

| 场景                     | 推荐变体                  | 核心优势                                  |
|--------------------------|---------------------------|-------------------------------------------|
| PHP命令行工具开发        | `cli`、`zts`              | 轻量、支持多PHP版本                       |
| 生产环境Web服务          | `fpm-nginx`、`fpm-apache` | 稳定、预配置Web服务器、支持动态PHP配置     |
| 高性能API服务            | `roadrunner`、`frankenphp`| 基于Go的高性能服务器，适合长连接场景      |
| 多版本PHP项目兼容测试    | 全变体                    | 覆盖5.6至8.5版本，满足 legacy 项目需求    |
| 需要自定义PHP扩展的项目  | 全变体                    | `phpaddmod`工具简化扩展安装               |
| 开发环境快速搭建         | `fpm-nginx`、`fpm-apache` | 预安装Composer和Web服务器，开箱即用       |


## 详细的使用方法和配置说明

### 镜像变体与标签

镜像标签格式为`shinsenter/php:[PHP版本]-[变体]`，支持以下变体：

| 变体           | 说明                                                                 | PHP版本要求       |
|----------------|----------------------------------------------------------------------|-------------------|
| `cli`          | 命令行模式                                                           | 5.6+              |
| `zts`          | 线程安全模式                                                         | 5.6+              |
| `fpm`          | PHP-FPM模式                                                          | 5.6+              |
| `fpm-apache`   | PHP-FPM + Apache2服务器                                              | 5.6+              |
| `fpm-nginx`    | PHP-FPM + Nginx服务器                                                | 5.6+              |
| `roadrunner`   | 集成RoadRunner服务器（基于Go的高性能应用服务器）                     | 8.0+              |
| `frankenphp`   | 集成FrankenPHP服务器（基于Caddy的PHP运行时，beta版）                  | 8.2+              |

**示例标签**：
- `shinsenter/php:7.4-cli`（PHP 7.4，CLI模式）
- `shinsenter/php:8.1-fpm-nginx`（PHP 8.1，FPM+Nginx）
- `shinsenter/php:8.3-roadrunner`（PHP 8.3，RoadRunner）
- `shinsenter/php:8.4-frankenphp`（PHP 8.4，FrankenPHP）

> 所有标签可在[Docker Hub](https://hub.docker.com/r/shinsenter/php/tags)查看。


### 快速启动示例

#### 1. CLI模式

```shell
# 非交互式运行（查看PHP模块）
docker run --rm docker.xuanyuan.run/shinsenter/php:8.4-cli php -m

# 交互式运行（挂载本地项目）
docker run -it -v ./myproject:/var/www/html docker.xuanyuan.run/shinsenter/php:8.4-cli
```

#### 2. PHP-FPM模式

```shell
docker run -v ./myproject:/var/www/html -p 9000:9000 docker.xuanyuan.run/shinsenter/php:8.4-fpm
```

#### 3. FPM+Nginx/Apache

```shell
# FPM+Nginx（映射80/443端口）
docker run -v ./myproject:/var/www/html -p 80:80 -p 443:443 docker.xuanyuan.run/shinsenter/php:8.4-fpm-nginx

# FPM+Apache
docker run -v ./myproject:/var/www/html -p 80:80 -p 443:443 docker.xuanyuan.run/shinsenter/php:8.4-fpm-apache
```

#### 4. 使用docker-compose

```yaml
version: '3'
services:
  web:
    image: docker.xuanyuan.run/shinsenter/php:8.4-fpm-nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./myproject:/var/www/html
    environment:
      PHP_DISPLAY_ERRORS: "1"          # 显示错误信息
      PHP_POST_MAX_SIZE: "100M"        # 最大POST大小
      PHP_UPLOAD_MAX_FILESIZE: "100M"  # 最大上传文件大小
      APP_PATH: "/var/www/html"        # 应用目录（默认）
      DOCUMENT_ROOT: "public"          # 文档根目录（相对于APP_PATH）
```


### 自定义PHP配置（环境变量）

通过`PHP_*`环境变量自定义php.ini或php-fpm.conf参数，命名规则为：`PHP_` + 配置项的常量名（原配置项中的点/横杠替换为下划线，大写）。

#### 常用环境变量示例

| 环境变量                  | 说明                                  | 对应PHP配置项                  |
|---------------------------|---------------------------------------|--------------------------------|
| `PHP_DISPLAY_ERRORS=1`    | 开发环境显示错误                      | `display_errors = 1`           |
| `PHP_POST_MAX_SIZE=100M`  | 最大POST数据大小                      | `post_max_size = 100M`         |
| `PHP_UPLOAD_MAX_FILESIZE=100M` | 最大上传文件大小                | `upload_max_filesize = 100M`   |
| `PHP_SESSION_COOKIE_HTTPONLY=1` | 会话Cookie启用HttpOnly标志     | `session.cookie_httponly = 1`  |
| `PHP_MEMORY_LIMIT=512M`   | PHP内存限制                          | `memory_limit = 512M`          |

#### 使用示例

**命令行**：
```shell
docker run \
  -v ./myproject:/var/www/html \
  -e PHP_DISPLAY_ERRORS='1' \
  -e PHP_POST_MAX_SIZE='100M' \
  docker.xuanyuan.run/shinsenter/php:8.4-fpm-nginx
```

**运行时动态调整配置**：
默认`PHP_*`变量仅在容器启动时生效，若需在容器内运行命令时动态调整，需设置`ALLOW_RUNTIME_PHP_ENVVARS=1`：
```shell
docker run -e ALLOW_RUNTIME_PHP_ENVVARS=1 docker.xuanyuan.run/shinsenter/php:8.4-cli
# 容器内执行：PHP_DISPLAY_ERRORS=1 php -i | grep display_errors
```


### 应用目录与文档根目录

- **默认应用目录**：`/var/www/html`，可通过`APP_PATH`环境变量自定义。
- **文档根目录**：相对于`APP_PATH`的子目录（默认空，即`APP_PATH`本身），可通过`DOCUMENT_ROOT`自定义。

**示例**：
```shell
# 将应用目录设置为/app，文档根目录为/app/public
docker run \
  -v ./myproject:/app \
  -e APP_PATH=/app \
  -e DOCUMENT_ROOT=public \
  -p 80:80 \
  docker.xuanyuan.run/shinsenter/php:8.4-fpm-nginx
```


### 添加PHP扩展

使用`phpaddmod`命令一键安装PHP扩展，自动处理依赖、编译和配置。该命令是`mlocati/docker-php-extension-installer`的封装，支持大部分主流扩展。

#### Dockerfile示例

```dockerfile
FROM docker.xuanyuan.run/shinsenter/php:8.4-fpm-nginx

# 安装imagick、swoole、xdebug扩展
RUN phpaddmod imagick swoole xdebug

# 复制项目代码（指定用户权限）
ADD --chown=$APP_USER:$APP_GROUP ./myproject/ /var/www/html/
```

> 支持的扩展列表参考：[mlocati/docker-php-extension-installer文档](https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions)


### 自定义容器用户与组

通过环境变量自定义容器内运行应用的用户和组，避免权限问题。

| 环境变量       | 说明                  | 默认值       |
|----------------|-----------------------|--------------|
| `APP_USER`     | 用户名                | `www-data`   |
| `APP_GROUP`    | 组名                  | `www-data`   |
| `APP_UID`      | 用户UID               | 容器内默认UID |
| `APP_GID`      | 组GID                 | 容器内默认GID |

**示例**：
```yaml
# docker-compose.yml
services:
  web:
    image: docker.xuanyuan.run/shinsenter/php:8.4-fpm-nginx
    environment:
      APP_USER: "myapp"    # 自定义用户名
      APP_UID: "5000"      # 自定义UID（与宿主机用户匹配可避免权限问题）
```


### 钩子（Hooks）

钩子脚本用于在容器生命周期的特定阶段执行自定义逻辑，支持以下钩子：

| 钩子名称       | 触发时机                                  | 典型用途                  |
|----------------|-------------------------------------------|---------------------------|
| `onboot`       | 容器启动或重启时                          | 发送启动通知              |
| `first-run`    | 容器首次启动时（仅一次）                  | 初始化数据库              |
| `rebooted`     | 容器重启时                                | 检查崩溃日志              |
| `migration`    | 应用启动前                                | 执行数据库迁移            |
| `onready`      | `migration`后，应用准备就绪时             | 预热缓存                  |
| `onlive`       | Web服务器启动后（若包含Web服务器）        | 触发外部webhook           |

#### 使用方法

在`APP_PATH`目录下创建`hooks`文件夹，添加与钩子名称同名的可执行脚本（或子目录中的脚本）：
```
/var/www/html/
└── hooks/
    ├── first-run        # 首次启动执行
    ├── migration        # 迁移脚本
    └── onlive/          # onlive钩子的多个脚本
        ├── 01-webhook
        └── 02-notify
```

> 提示：设置`DEBUG=1`可查看钩子执行日志。


### 自动运行脚本（Autorun Scripts）

`/startup/`目录下的shell脚本会在容器启动时按文件名顺序自动执行，用于初始化项目（如数据库迁移、依赖安装等）。

#### 使用示例

**Dockerfile中添加脚本**：
```dockerfile
FROM docker.xuanyuan.run/shinsenter/php:8.4-cli

# 添加自动运行脚本（确保可执行权限）
ADD ./scripts/00-migration /startup/00-migration
RUN chmod +x /startup/00-migration
```

**禁用自动运行**：
设置环境变量`DISABLE_AUTORUN_SCRIPTS=1`。


### 定时任务（Cron Jobs）

启用crontab服务需设置`ENABLE_CRONTAB=1`，任务定义可通过以下方式添加：
1. 挂载或复制任务文件到`CRONTAB_DIR`（默认`/etc/crontab.d`）
2. 通过`CRONTAB_SETTINGS`环境变量直接定义（适合docker-compose）

#### 环境变量配置

| 环境变量          | 说明                                  | 默认值              |
|-------------------|---------------------------------------|---------------------|
| `ENABLE_CRONTAB=1` | 启用crontab服务                       | 未设置（禁用）      |
| `CRONTAB_DIR`      | 任务文件目录                          | `/etc/crontab.d`    |
| `CRONTAB_HOME`     | 任务执行的HOME目录                    | `$APP_PATH`         |
| `CRONTAB_SETTINGS` | 直接定义任务（换行分隔多个任务）       | 未设置              |
| `CRONTAB_TZ`       | 任务时区                              | `$TZ`（默认UTC）    |

#### 使用示例

**docker-compose.yml**：
```yaml
services:
  web:
    image: docker.xuanyuan.run/shinsenter/php:8.4-fpm-nginx
    environment:
      ENABLE_CRONTAB: "1"
      CRONTAB_TZ: "Asia/Shanghai"
      CRONTAB_SETTINGS: |
        * * * * * echo "每分钟执行" >> /var/log/cron.log
        0 0 * * * php /var/www/html/artisan backup  # 每日凌晨执行备份
```


### 自定义Supervisor命令

通过`SUPERVISOR_PHP_COMMAND`环境变量自定义容器启动命令，替代默认Web服务器或FPM进程。

**示例**：
```shell
# 使用PHP内置Web服务器运行项目
docker run \
  -e SUPERVISOR_PHP_COMMAND='php -S 0.0.0.0:80 index.php' \
  docker.xuanyuan.run/shinsenter/php:8.4
```


### 邮件发送配置

镜像使用`msmtp`替代`sendmail`，支持通过SMTP发送邮件。若使用PHP `mail()`函数，需配置以下环境变量：

| 环境变量          | 说明                          | 示例值           |
|-------------------|-------------------------------|------------------|
| `SMTP_HOST`       | SMTP服务器地址                | `smtp.gmail.com` |
| `SMTP_PORT`       | SMTP端口                      | `587`            |
| `SMTP_USER`       | SMTP认证用户名                | `user@gmail.com` |
| `SMTP_PASSWORD`   | SMTP认证密码                  | `password`       |
| `SMTP_FROM`       | 发件人邮箱                    | `admin@example.com` |
| `SMTP_AUTH=on`    | 启用SMTP认证                  | `on`             |
| `SMTP_TLS=on`     | 启用TLS加密                   | `on`             |

**开发环境示例**（使用Mailpit容器作为SMTP服务器）：
```yaml
version: '3'
services:
  web:
    image: docker.xuanyuan.run/shinsenter/php:8.4-fpm-nginx
    environment:
      SMTP_HOST: mailpit
      SMTP_PORT: 1025
  mailpit:
    image: docker.xuanyuan.run/axllent/mailpit
    ports:
      - "8025:8025"  # Web管理界面
```


### 调试模式

设置`DEBUG=1`启用详细日志输出，便于排查配置或启动问题：
```shell
docker run -e DEBUG=1 docker.xuanyuan.run/shinsenter/php:8.4-fpm-nginx
```


### 其他系统设置

| 环境变量                          | 默认值              | 说明                                                                 |
|-----------------------------------|---------------------|----------------------------------------------------------------------|
| `TZ`                              | `UTC`               | 容器时区（如`Asia/Shanghai`）                                         |
| `INITIAL_PROJECT`                 | 未设置              | 若应用目录为空，自动创建Composer项目（如`laravel/laravel`）或拉取Git仓库 |
| `COMPOSER_OPTIMIZE_AUTOLOADER=1`  | 未设置              | Composer安装时启用`--optimize-autoloader`，优化生产环境性能           |
