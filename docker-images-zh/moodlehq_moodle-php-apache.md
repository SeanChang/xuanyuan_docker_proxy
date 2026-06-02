---
image: moodlehq/moodle-php-apache
description: "为Moodle配置的Apache/PHP环境，包含所有支持的数据库驱动"
source: https://xuanyuan.cloud/zh/r/moodlehq/moodle-php-apache
canonical: https://xuanyuan.cloud/zh/r/moodlehq/moodle-php-apache
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [moodlehq/moodle-php-apache — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/moodlehq/moodle-php-apache)

含镜像标签、拉取命令、部署文档与相关推荐。

[moodlehq/moodle-php-apache Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/moodlehq/moodle-php-apache)

# moodle-php-apache: Moodle PHP环境

基于[官方PHP镜像](https://hub.docker.com/_/php/)配置的Moodle开发PHP环境。

## 版本

| PHP版本 | 变体 | 标签 | 状态 | 说明 |
|---------|------|------|------|------|
| PHP 8.4 | Bookworm | dev | [![Test and publish 8.4](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=main)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | |
| PHP 8.4 | Bookworm | 8.4, 8.4-bookworm | [![Test and publish 8.4](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=8.4-bookworm)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | |
| PHP 8.3 | Bookworm | 8.3, 8.3-bookworm | [![Test and publish 8.3](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=8.3-bookworm)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | |
| PHP 8.2 | Bookworm | 8.2, 8.2-bookworm | [![Test and publish 8.2](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=8.2-bookworm)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | |
| PHP 8.1 | Bookworm | 8.1, 8.1-bookworm | [![Test and publish 8.1](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=8.1-bookworm)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | |
| PHP 8.4 | Bullseye | 8.4-bullseye | [![Test and publish 8.4](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=8.4-bullseye)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | |
| PHP 8.3 | Bullseye | 8.3-bullseye | [![Test and publish 8.3](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=8.3-bullseye)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | |
| PHP 8.2 | Bullseye | 8.2-bullseye | [![Test and publish 8.2](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=8.2-bullseye)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | |
| PHP 8.1 | Bullseye | 8.1-bullseye | [![Test and publish 8.1](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=8.1-bullseye)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | |
| PHP 8.0 | Bullseye | 8.0, 8.0-bullseye | [![Test and publish 8.0](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=8.0-bullseye)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | PHP 8.0 已停止支持 |
| PHP 7.4 | Bullseye | 7.4, 7.4-bullseye | [![Test and publish 7.4](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=7.4-bullseye)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | PHP 7.4 已停止支持 |
| PHP 8.2 | Buster | 8.2-buster | [![Test and publish 8.2](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=8.2-buster)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | Buster 已停止支持。自2023年6月8.2.7版本后不再更新 |
| PHP 8.1 | Buster | 8.1-buster | [![Test and publish 8.1](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=8.1-buster)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | Buster 已停止支持。自2023年6月8.1.20版本后不再更新 |
| PHP 8.0 | Buster | 8.0-buster | [![Test and publish 8.0](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=8.0-buster)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | Buster 和 PHP 8.0 已停止支持 |
| PHP 7.4 | Buster | 7.4-buster | [![Test and publish 7.4](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=7.4-buster)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | Buster 和 PHP 7.4 已停止支持 |
| PHP 7.3 | Buster | 7.3, 7.3-buster | [![Test and publish 7.3](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml/badge.svg?branch=7.3-buster)](https://github.com/moodlehq/moodle-php-apache/actions/workflows/test_buildx_and_publish.yml) | Buster 和 PHP 7.3 已停止支持 |
| PHP 7.2 | Buster | 7.2, 7.2-buster | [![Build Status](https://travis-ci.com/moodlehq/moodle-php-apache.svg?branch=7.2-buster)](https://travis-ci.com/moodlehq/moodle-php-apache) | Buster 和 PHP 7.2 已停止支持 |
| PHP 7.1 | Buster | 7.1, 7.1-buster | [![Build Status](https://travis-ci.com/moodlehq/moodle-php-apache.svg?branch=7.1-buster)](https://travis-ci.com/moodlehq/moodle-php-apache) | Buster 和 PHP 7.1 已停止支持 |
| PHP 7.3 | Stretch | 7.3-stretch | [![Build Status](https://travis-ci.com/moodlehq/moodle-php-apache.svg?branch=7.3-stretch)](https://travis-ci.com/moodlehq/moodle-php-apache) | Stretch 和 PHP 7.3 已停止支持 |
| PHP 7.2 | Stretch | 7.2-stretch | [![Build Status](https://travis-ci.com/moodlehq/moodle-php-apache.svg?branch=7.2-stretch)](https://travis-ci.com/moodlehq/moodle-php-apache) | Stretch 和 PHP 7.2 已停止支持 |
| PHP 7.1 | Stretch | 7.1-stretch | [![Build Status](https://travis-ci.com/moodlehq/moodle-php-apache.svg?branch=7.1-stretch)](https://travis-ci.com/moodlehq/moodle-php-apache) | Stretch 和 PHP 7.1 已停止支持 |
| PHP 7.0 | Stretch | 7.0, 7.0-stretch | [![Build Status](https://travis-ci.com/moodlehq/moodle-php-apache.svg?branch=7.0-stretch)](https://travis-ci.com/moodlehq/moodle-php-apache) | Stretch 和 PHP 7.0 已停止支持 |
| PHP 5.6 | Stretch | 5.6, 5.6-stretch | [![Build Status](https://travis-ci.com/moodlehq/moodle-php-apache.svg?branch=5.6-stretch)](https://travis-ci.com/moodlehq/moodle-php-apache) | Stretch 和 PHP 5.6 已停止支持 |
| PHP 7.1 | Jessie | 7.1-jessie | [![Build Status](https://travis-ci.com/moodlehq/moodle-php-apache.svg?branch=7.1-jessie)](https://travis-ci.com/moodlehq/moodle-php-apache) | Jessie 和 PHP 7.1 已停止支持 |
| PHP 7.0 | Jessie | 7.0-jessie | [![Build Status](https://travis-ci.com/moodlehq/moodle-php-apache.svg?branch=7.0-jessie)](https://travis-ci.com/moodlehq/moodle-php-apache) | Jessie 和 PHP 7.0 已停止支持 |
| PHP 5.6 | Jessie | 5.6-jessie | [![Build Status](https://travis-ci.com/moodlehq/moodle-php-apache.svg?branch=5.6-jessie)](https://travis-ci.com/moodlehq/moodle-php-apache) | Jessie 和 PHP 5.6 已停止支持 |

## 使用示例

以下命令将在8080端口暴露当前工作目录：
```bash
$ docker run --name web0 -p 8080:80 -v $PWD:/var/www/html moodlehq/moodle-php-apache:8.3
```

## 特性

* 预配置Moodle开发所需的所有PHP扩展和数据库驱动
* 默认从`/var/www/html`或`/var/www/html/public`（Moodle 5.1及以上）提供内容
* 可覆盖文档根目录
* 对于PHP 7.3及以上版本，提供`linux/amd64`和`linux/arm64`镜像。注意`linux/arm64`暂不支持sqlsrv和oci扩展。除此之外，两种架构功能完全相同
* 通过[自动化测试](https://travis-ci.com/moodlehq/moodle-php-apache)验证
* 基于GHA自动构建
* 支持入口点脚本和PHP配置
* 包含许多常用扩展
* 注意：PHP 8.4镜像不包含oci扩展，因为Moodle 5.0及以上版本不再支持这些扩展

## 配置

### Apache配置

此镜像使用Apache HTTPD服务器提供所有内容，需要最少的手动配置。

可以使用`APACHE_DOCUMENT_ROOT`环境变量配置Apache的`DocumentRoot`指令，例如：

```bash
docker run \
    --name web0 \
    -p 8080:80 \
    -v $PWD/moodle:/srv/moodle
    -e APACHE_DOCUMENT_ROOT=/srv/moodle \
    moodle-php-apache:latest
```

注意：指定`DocumentRoot`将覆盖默认根目录，并会阻止镜像自动配置任何Moodle特定配置。

### PHP配置

作为完整PHP配置文件的轻量级替代方案，您可以在启动容器时指定一组带前缀的环境变量，这些变量将转换为ini格式配置。

任何名称以`PHP_INI-`为前缀的环境变量将被移除前缀，并在主命令启动前添加到新的ini文件中。

```bash
docker run \
    --name web0 \
    -p 8080:80 \
    -v $PWD/moodle:/var/www/html
    -e PHP_INI-upload_max_filesize=200M \
    -e PHP_INI-post_max_size=210M \
    moodle-php-apache:latest
```

## 目录

为方便测试和轻松设置，默认创建以下目录并归www-data所有：

* `/var/www/moodledata`
* `/var/www/phpunitdata`
* `/var/www/behatdata`
* `/var/www/behatfaildumps`

## 初始化脚本

此镜像支持使用`docker-entrypoint.d`目录的自定义初始化脚本。这些脚本可以是以下格式：

* 非可执行的`.sh`脚本，将被_源代码化_并改变当前上下文
* 可执行的`.sh`脚本，将在当前上下文中_执行_
* `.ini`文件，将被复制到PHP配置目录（`/usr/local/etc/php/conf.d`）

标准包含以下脚本：

* `10-wwwroot.sh` - 非可执行脚本，用于在未提供`APACHE_DOCUMENT_ROOT`时猜测该值

这些脚本无法删除，但可以通过在您自己的`docker-entrypoint.d`位置创建具有匹配文件名的文件来禁用它们。

还可以提供其他脚本，例如，要配置PHP以支持更高的`upload_max_filesize`选项，您可以将以下内容添加到`config/10-uploads.ini`文件中：

```
; 指定上传的最大文件大小为200M
upload_max_filesize = 200M
post_max_size = 210M
```

启动容器时，可以传入配置目录：

```
docker run \
    --name web0 \
    -p 8080:80 \
    -v $PWD/moodle:/var/www/html
    -v $PWD/config:/docker-entrypoint.d \
    moodle-php-apache:latest
```

这些初始化文件将按照当前区域设置定义的排序名称顺序执行，默认为en_US.utf8。

## 扩展

标准包含以下扩展：

* apcu
* exif
* gd
* igbinary
* intl
* ldap
* memcached
* mysqli
* oci8
* opcache
* pcov
* pgsql
* redis
* soap
* solr
* sqlsrv
* timezonedb
* uuid
* xdebug
* xhprof
* xsl
* zip

以上所有扩展默认启用，除了：

* pcov
* xdebug
* xhprof

### 启用可选扩展

已安装但未启用的几个扩展可以轻松启用。

### xdebug

启动容器时指定以下环境变量可启用`xdebug`扩展：

```bash
PHP_EXTENSION_xdebug=1
```

### xhprof

启动容器时指定以下环境变量可启用`xhprof`扩展：

```bash
PHP_EXTENSION_xhprof=1
```

#### pcov

`pcov`扩展通常不用于Web UI，但广泛用于单元测试中的代码覆盖率生成。

启动容器时指定以下环境变量可启用它：

```bash
PHP_INI-pcov.enabled=1
```

## 参见

此容器是Moodle开发容器集的一部分，另请参见：

* [moodle-docker](https://github.com/moodlehq/moodle-docker) - 基于docker-composer的工具集，可零配置运行Moodle开发环境
* [moodle-db-mssql](https://github.com/moodlehq/moodle-db-mssql) - 为Moodle开发配置的Linux版Microsoft SQL Server
* [moodle-db-oracle](https://github.com/moodlehq/moodle-db-oracle) - 为Moodle开发配置的Oracle XE
