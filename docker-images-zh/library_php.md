---
image: library/php
description: "PHP脚本语言虽最初为Web开发设计，却兼具通用目的用途，作为一种广泛应用的服务器端脚本语言，它能高效处理动态网页生成、数据库交互等Web开发核心任务，同时也可用于编写命令行脚本、开发桌面应用及进行系统管理等非Web领域，凭借其简洁语法与跨平台特性，成为众多开发者在不同场景下的实用工具。"
source: https://xuanyuan.cloud/zh/r/library/php
canonical: https://xuanyuan.cloud/zh/r/library/php
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/php" title="library/php Docker 镜像中文简介、标签列表与拉取命令">library/php — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/php" title="library/php Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/php</a>

# PHP Docker 镜像使用指南


## 快速参考

### 维护与支持
- **维护方**：[Docker 社区]([])  
- **获取帮助**：[Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])  


### 标签与架构
- **支持的标签**：由于 Hub 描述长度限制（25000 字符），完整标签列表请见 [GitHub 文档]([])。  
- **提交问题**：[php 仓库 Issues]([])  
- **支持的架构**：`amd64`、`arm32v5`、`arm32v6`、`arm32v7`、`arm64v8`、`i386`、`mips64le`、`ppc64le`、`riscv64`、`s390x`（[架构说明]([])）  


### 镜像信息
- **镜像详情**：包含元数据、传输大小等，见 [repo-info 仓库的 php 目录]([])（[历史记录]([])）。  
- **更新记录**：[official-images 仓库的 php 标签]([]) 或 [php 文件历史]([])。  
- **文档来源**：[docs 仓库的 php 目录]([])（[历史记录]([])）。  


## 什么是 PHP？
PHP 是一种服务器端脚本语言，主要用于 Web 开发，也可作为通用编程语言。它可嵌入 HTML，或与模板引擎、Web 框架配合使用。PHP 代码通常由解释器处理，解释器可作为 Web 服务器的原生模块或 CGI 程序运行。  

> 更多信息：[维基百科 PHP 条目]()  

![PHP 标志]([])  


## 如何使用本镜像

### 方法一：创建 Dockerfile
在 PHP 项目中编写 `Dockerfile`：  
```dockerfile
FROM php:8.2-cli
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
CMD ["php", "./your-script.php"]
```

构建并运行镜像：  
```console
$ docker build -t my-php-app .
$ docker run -it --rm --name my-running-app my-php-app
```


### 方法二：直接运行单文件脚本
简单项目可直接通过镜像运行 PHP 脚本，无需完整 `Dockerfile`：  
```console
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp php:8.2-cli php your-script.php
```


## 安装 PHP 扩展

### 基础说明
部分扩展已预编译到镜像中，可先通过 `php -m` 或 `php -i` 检查已安装扩展，避免重复编译。镜像提供 `docker-php-ext-configure`、`docker-php-ext-install`、`docker-php-ext-enable` 工具简化扩展安装，以及 `docker-php-source` 用于临时提取 PHP 源码（建议用完即删，减小镜像体积）：  
```dockerfile
FROM php:8.2-cli
RUN docker-php-source extract \
    # 执行编译操作 \
    && docker-php-source delete
```


### 核心扩展安装示例（如 GD）
以安装 GD 扩展为例（需先安装依赖库）：  
```dockerfile
FROM php:8.2-fpm
RUN apt-get update && apt-get install -y \
        libfreetype-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
```

> 依赖库需手动安装。若不确定依赖，可参考 [install-php-extensions 项目]([])（社区工具，自动处理依赖）。


### PECL 扩展安装（如 Redis、Xdebug）
通过 PECL 安装非核心扩展，需配合 `docker-php-ext-enable` 启用：  
```dockerfile
FROM php:8.2-cli
RUN pecl install redis-5.3.7 \
    && pecl install xdebug-3.2.1 \
    && docker-php-ext-enable redis xdebug
```

> 安装 PECL 扩展时建议指定版本号，避免兼容性问题；多个扩展需分步骤安装（如 `pecl install A && pecl install B`），确保错误可追踪。


### 自定义扩展安装
非核心/PECL 扩展可通过源码编译安装，示例：  
```dockerfile
FROM php:8.2-cli
RUN curl -fsSL "[扩展源码URL]" -o module-name.tar.gz \
    && mkdir -p /tmp/module-name \
    && tar -xf module-name.tar.gz -C /tmp/module-name --strip-components=1 \
    && rm module-name.tar.gz \
    && docker-php-ext-configure /tmp/module-name --enable-module-name \
    && docker-php-ext-install /tmp/module-name \
    && rm -r /tmp/module-name
```


## 配置 PHP

### 切换配置文件
镜像包含 `php.ini-development`（开发环境）和 `php.ini-production`（生产环境），建议生产环境使用后者：  
```dockerfile
FROM php:8.2-fpm-alpine
# 启用生产环境配置
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
```


### 自定义配置
通过挂载或复制文件到 `$PHP_INI_DIR/conf.d/` 目录添加自定义配置：  
```dockerfile
FROM php:8.2-fpm
COPY my-config.ini $PHP_INI_DIR/conf.d/
```


## 常见问题解决

### 报错 "E: Package 'php-XXX' has no installation candidate"
该错误因镜像默认屏蔽 Debian 的 PHP 包（避免冲突）。正确解决方式：  
- 如需 Debian 官方 PHP 包，直接基于 `debian` 镜像构建；  
- 如需扩展，使用 `docker-php-ext-install` 或 PECL 安装。  

临时 workaround（不推荐，可能导致 PHP 多版本冲突）：  
```dockerfile
RUN rm /etc/apt/preferences.d/no-debian-php
```


## 镜像变体说明

### `php:<version>-cli`
包含 PHP CLI 工具，适用于命令行脚本，无 Web 服务器。


### `php:<version>-apache`
基于 Apache 服务器（搭配 `mod_php` 和 `mpm_prefork`），直接提供 Web 服务。示例 Dockerfile：  
```dockerfile
FROM php:7.2-apache
COPY src/ /var/www/html/
```


### `php:<version>-fpm`
包含 PHP-FPM（FastCGI 进程管理器），需配合反向代理（如 Nginx、Apache）使用。


### `php:<version>-alpine`
基于 Alpine Linux，体积更小（约 5MB 基础镜像），但使用 musl libc，部分依赖可能需要额外适配。适合对镜像大小敏感的场景。


## 许可证
PHP 软件许可证见 [官方说明]([])。镜像可能包含其他软件（如 Bash），其许可证信息可参考 [repo-info 仓库]([])。使用前请确保合规。
