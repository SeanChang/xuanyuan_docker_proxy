---
image: tangramor/nginx-php8-fpm
description: "包含Nginx 1.2x.x、PHP 8.4/8.3/8.2/8.1/8.0-fpm及Node.js多版本的容器镜像，特别集成Node.js以满足众多PHP框架需求，支持amqp、brotli、imagick等多种PHP扩展模块。"
source: https://xuanyuan.cloud/zh/r/tangramor/nginx-php8-fpm
canonical: https://xuanyuan.cloud/zh/r/tangramor/nginx-php8-fpm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tangramor/nginx-php8-fpm" title="tangramor/nginx-php8-fpm Docker 镜像中文简介、标签列表与拉取命令">tangramor/nginx-php8-fpm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Nginx + php-fpm (v8) + nodejs

基于php:8.4.12-fpm-alpine3.22、node:24.9.0-alpine3.22（Node.js是许多PHP框架所需但其他多数nginx-php镜像未包含的组件）构建，并整合了nginx:alpine和richarvey/nginx-php-fpm的Docker脚本。

* 自`php8.4.1_node23.3.0`版本起，添加了PHP `brotli`模块，移除了`swoole`模块（目前不支持PHP 8.4）。
* 自`php8.3.6_node22.1.0`版本起，添加了PHP `imagick`模块。
* 自`php8.2.8_node20.5.0`版本起，添加了PHP `mongodb`模块，并启用了GD模块的JPEG和FreeType支持。
* 自`php8.1.8_node18.4.0`版本起，添加了PHP `amqp`模块。
* 自`php8.1.10_node18.8.0`版本起，添加了PHP `swoole`模块。
* 自`php8.1.12`版本起，提供`_withoutNodejs`构建版本，适用于Lumen等纯PHP API框架。

## 标签信息

* latest, php8.4.12_node24.9.0, php8.4.12_withoutNodejs (2025-10-10 alpine3.22)
* php8.4.12_node24.7.0, php8.4.12_withoutNodejs (2025-09-02 alpine3.22)
* php8.4.11_node24.5.0, php8.4.11_withoutNodejs (2025-08-18 alpine3.22)
* php8.4.10_node24.3.0, php8.4.10_withoutNodejs (2025-07-07 alpine3.22)
* php8.4.7_node24.1.0, php8.4.7_withoutNodejs (2025-06-03 alpine3.21)
* php8.4.6_node23.11.0, php8.4.6_withoutNodejs (2025-05-06 alpine3.21)
* php8.4.5_node23.11.0, php8.4.5_withoutNodejs (2025-04-03 alpine3.21)
* php8.4.4_node23.9.0, php8.4.4_withoutNodejs (2025-03-03 alpine3.21)
* php8.4.3_node23.7.0, php8.4.3_withoutNodejs (2025-02-05 alpine3.21)
* php8.4.2_node23.5.0, php8.4.2_withoutNodejs (2025-01-02 alpine3.20)
* php8.4.1_node23.3.0, php8.4.1_withoutNodejs (2024-12-02 alpine3.20) **注意：现在PHP版本为8.4！**
* php8.3.13_node22.11.0, php8.3.13_withoutNodejs (2024-11-04 alpine3.20)
* php8.3.12_node22.9.0, php8.3.12_withoutNodejs (2024-10-08 alpine3.20)
* php8.3.11_node22.7.0, php8.3.11_withoutNodejs (2024-09-03 alpine3.20)
* php8.3.10_node22.5.1, php8.3.10_withoutNodejs (2024-08-05 alpine3.20)
* php8.3.8_node22.4.0, php8.3.8_withoutNodejs (2024-07-04 alpine3.20)
* php8.3.7_node22.2.0, php8.3.7_withoutNodejs (2024-06-03 alpine3.19)
* php8.3.6_node22.1.0, php8.3.6_withoutNodejs (2024-05-06 alpine3.19)
* php8.3.4_node21.7.2, php8.3.4_withoutNodejs (2024-04-07 alpine3.19)
* php8.3.3_node21.6.2, php8.3.3_withoutNodejs (2024-03-04 alpine3.19)
* php8.3.2_node21.6.1, php8.3.2_withoutNodejs (2024-02-10 alpine3.19)
* php8.3.1_node21.5.0, php8.3.1_withoutNodejs (2024-01-03 alpine3.18)
* php8.3.0_node21.3.0, php8.3.0_withoutNodejs (2023-12-04 alpine3.18) **注意：现在PHP版本为8.3！**
* php8.2.12_node21.1.0, php8.2.12_withoutNodejs (2023-11-03 alpine3.18)
* php8.2.11_node20.8.0, php8.2.11_withoutNodejs (2023-10-09 alpine3.18)
* php8.2.10_node20.6.0, php8.2.10_withoutNodejs (2023-09-08 alpine3.18)
* php8.2.8_node20.5.0, php8.2.8_withoutNodejs (2023-08-03 alpine3.17)
* php8.2.7_node20.3.1, php8.2.7_withoutNodejs (2023-07-03 alpine3.17)
* php8.2.6_node20.2.0, php8.2.6_withoutNodejs (2023-06-07 alpine3.17)
* php8.2.5_node20.1.0, php8.2.5_withoutNodejs (2023-05-08 alpine3.17)
* php8.2.4_node19.8.1, php8.2.4_withoutNodejs (2023-04-10 alpine3.17)
* php8.2.3_node19.7.0, php8.2.3_withoutNodejs (2023-03-06 alpine3.17)
* php8.2.2_node19.6.0, php8.2.2_withoutNodejs (2023-02-06 alpine3.17)
* php8.2.0_node19.3.0, php8.2.0_withoutNodejs (2023-01-05 alpine3.17) **注意：现在PHP版本为8.2！**
* php8.1.13_node19.2.0, php8.1.13_withoutNodejs (2022-12-06 alpine3.16)
* php8.1.12_node19.0.0, php8.1.12_withoutNodejs (2022-11-07 alpine3.16)
* php8.1.11_node18.10.0 (2022-10-13 alpine3.16)
* php8.1.10_node18.8.0 (2022-09-06 alpine3.16)
* php8.1.9_node18.7.0 (2022-08-11 alpine3.16)
* php8.1.8_node18.4.0 (2022-07-08 alpine3.16)
* php8.1.6_node18.2.0 (2022-06-06 alpine3.15)
* php8.1.5_node18.1.0 (2022-05-07)
* php8.1.4_node17.8 (2022-04-10)
* php8.1.3_node17 (2022-03-07)
* php8.0.13_node17 (2022-03-07)
* php8_node15 (2022-03-07)

**注意** 如果从PHP **8.0升级到8.1**、**8.1升级到8.2**、**8.2升级到8.3**或**8.3升级到8.4**，可能需要运行`composer update`来升级PHP包，因为某些8.0/8.1/8.2/8.3版本下的包可能不支持8.1/8.2/8.3/8.4版本。

```
# php -v
PHP 8.4.12 (cli) (built: Aug 28 2025 18:19:24) (NTS)
Copyright (c) The PHP Group
Built by https://github.com/docker-library/php
Zend Engine v4.4.12, Copyright (c) Zend Technologies
    with Zend OPcache v8.4.12, Copyright (c), by Zend Technologies

# node -v
v24.9.0

# nginx -v
nginx version: nginx/1.29.2
```

## PHP模块

此镜像包含以下PHP模块：

```
[PHP Modules]
amqp
bcmath
brotli
Core
ctype
curl
date
dom
exif
fileinfo
filter
gd
gettext
hash
iconv
igbinary
imagick
imap
intl
json
ldap
libxml
mbstring
memcached
mongodb
msgpack
mysqli
mysqlnd
openssl
pcre
PDO
pdo_mysql
pdo_pgsql
pdo_sqlite
pgsql
Phar
posix
random
readline
redis
Reflection
session
SimpleXML
soap
sockets
sodium
SPL
sqlite3
standard
tokenizer
xml
xmlreader
xmlwriter
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache

# php -r "echo sprintf(\"GD SUPPORT %s\n\", json_encode(gd_info()));"
GD SUPPORT {"GD Version":"bundled (2.1.0 compatible)","FreeType Support":true,"FreeType Linkage":"with freetype","GIF Read Support":true,"GIF Create Support":true,"JPEG Support":true,"PNG Support":true,"WBMP Support":true,"XPM Support":false,"XBM Support":true,"WebP Support":true,"BMP Support":true,"AVIF Support":false,"TGA Read Support":true,"JIS-mapped Japanese Font Support":false}
```

## 使用方法

### 部署Laravel 11项目示例

使用此Docker镜像部署**Laravel 11**项目的示例：

Dockerfile:

```dockerfile
FROM docker.xuanyuan.run/tangramor/nginx-php8-fpm

# 复制源代码
COPY . /var/www/html

# 如果/var/www/html下存在conf文件夹，start.sh会：
# 复制conf/nginx.conf到/etc/nginx/nginx.conf
# 复制conf/nginx-site.conf到/etc/nginx/conf.d/default.conf
# 复制conf/nginx-site-ssl.conf到/etc/nginx/conf.d/default-ssl.conf

# 复制SSL证书文件
COPY conf/ssl /etc/nginx/ssl

# 中国Alpine镜像：mirrors.ustc.edu.cn
ARG APKMIRROR=""

# start.sh会通过$TZ设置所需时区
ENV TZ="Asia/Shanghai"

# 中国PHP Composer镜像：https://mirrors.cloud.tencent.com/composer/
ENV COMPOSERMIRROR=""
# 中国npm镜像：https://registry.npmmirror.com
ENV NPMMIRROR=""

# start.sh会将默认网站根目录从/var/www/html替换为$WEBROOT
ENV WEBROOT="/var/www/html/public"

# start.sh会使用Docker容器名$PHP_REDIS_SESSION_HOST作为Redis会话存储
ENV PHP_REDIS_SESSION_HOST=redis

# 如果$CREATE_LARAVEL_STORAGE=1，start.sh会创建Laravel存储文件夹结构
ENV CREATE_LARAVEL_STORAGE="1"

# 下载所需的node/php包，
# 部分node模块需要gcc/g++编译
RUN if [[ "$APKMIRROR" != "" ]]; then sed -i "s/dl-cdn.alpinelinux.org/${APKMIRROR}/g" /etc/apk/repositories ; fi\
    && apk add --no-cache --virtual .build-deps gcc g++ libc-dev make \
    # 设置首选npm镜像
    && cd /usr/local \
    && if [[ "$NPMMIRROR" != "" ]]; then npm config set registry ${NPMMIRROR}; fi \
    && npm config set registry $NPMMIRROR \
    && cd /var/www/html \
    # 安装node模块
    && npm install \
    # 安装PHP Composer包
    && if [[ "$COMPOSERMIRROR" != "" ]]; then composer config -g repos.packagist composer ${COMPOSERMIRROR}; fi \
    && composer install \
    # 清理
    && apk del .build-deps \
    # 构建js/css
    && npm run dev \
    # 设置.env
    && cp .env.test .env \
    # 修改/var/www/html的用户/组权限
    && chown -Rf nginx.nginx /var/www/html
```

有关start.sh的更多功能，请查看[start.sh](https://github.com/tangramor/nginx-php8-fpm/blob/master/start.sh)。

### 使用镜像进行开发

以下是使用此镜像开发**Laravel 11**项目的示例，修改项目的`docker-compose.yml`文件。此处仅修改了`services -> laravel.test`下的`image`和`environment`字段。确保设置正确的环境参数：

```yaml
# 更多信息：https://laravel.com/docs/sail
services:
    laravel.test:
        image: tangramor/nginx-php8-fpm
        extra_hosts:
            - 'host.docker.internal:host-gateway'
        ports:
            - '${APP_PORT:-80}:80'
            - '${VITE_PORT:-5173}:${VITE_PORT:-5173}'
        environment:
            TZ: 'Asia/Shanghai'
            WEBROOT: '/var/www/html/public'
            PHP_REDIS_SESSION_HOST: 'redis'
            CREATE_LARAVEL_STORAGE: '1'
            COMPOSERMIRROR: 'https://mirrors.cloud.tencent.com/composer/'
            NPMMIRROR: 'https://registry.npm.taobao.org'
        volumes:
            - '.:/var/www/html'
        networks:
            - sail
        depends_on:
            - mysql
            - redis
            - meilisearch
            - mailpit
            - selenium
    mysql:
        image: 'mysql/mysql-server:8.0'
        ports:
            - '${FORWARD_DB_PORT:-3306}:3306'
        environment:
            MYSQL_ROOT_PASSWORD: '${DB_PASSWORD}'
            MYSQL_ROOT_HOST: '%'
            MYSQL_DATABASE: '${DB_DATABASE}'
            MYSQL_USER: '${DB_USERNAME}'
            MYSQL_PASSWORD: '${DB_PASSWORD}'
            MYSQL_ALLOW_EMPTY_PASSWORD: 1
        volumes:
            - 'sail-mysql:/var/lib/mysql'
            - './vendor/laravel/sail/database/mysql/create-testing-database.sh:/docker-entrypoint-initdb.d/10-create-testing-database.sh'
        networks:
            - sail
        healthcheck:
            test:
                - CMD
                - mysqladmin
                - ping
                - '-p${DB_PASSWORD}'
            retries: 3
