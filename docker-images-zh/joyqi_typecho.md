<!-- xuanyuan-docker-images-zh
image: joyqi/typecho
source: https://xuanyuan.cloud/zh/r/joyqi/typecho
canonical: https://xuanyuan.cloud/zh/r/joyqi/typecho
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/joyqi/typecho" title="joyqi/typecho Docker 镜像中文简介、标签列表与拉取命令">joyqi/typecho — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/joyqi/typecho" title="joyqi/typecho Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/joyqi/typecho</a></p>

**快速参考**

- 维护者：[Typecho开发团队](https://github.com/typecho)
- 获取帮助：[Typecho Docker GitHub issues](https://github.com/typecho/Dockerfile/issues)

**支持的标签及对应的`Dockerfile`链接**

- [nightly-php7.3, nightly-php7.3-cli, nightly-php7.3-fpm, nightly-php7.3-apache, nightly-php7.4, nightly-php7.4-cli, nightly-php7.4-fpm, nightly-php7.4-apache, nightly-php8.0, nightly-php8.0-cli, nightly-php8.0-fpm, nightly-php8.0-apache, nightly-php7.3-alpine, nightly-php7.3-cli-alpine, nightly-php7.3-fpm-alpine, nightly-php7.4-alpine, nightly-php7.4-cli-alpine, nightly-php7.4-fpm-alpine, nightly-php8.0-alpine, nightly-php8.0-cli-alpine, nightly-php8.0-fpm-alpine](https://github.com/typecho/Dockerfile)

**如何使用此镜像**

## 启动Typecho实例

```bash
$ docker run --name typecho-server -e TYPECHO_SITE_URL=https://your-domain.com -d joyqi/typecho:nightly-php7.4-apache
```

**如何扩展此镜像**

## 环境变量

### `TIMEZONE`

默认值：`UTC`

服务器时区，例如：`Asia/Shanghai`

### `MEMORY_LIMIT`

PHP内存限制，例如：`100M`

### `MAX_POST_BODY`

例如：`50M`

### `TYPECHO_INSTALL`

默认值：`0`

设为`1`可自动运行安装脚本。

### `TYPECHO_DB_ADAPTER`

默认值：`Pdo_Mysql`

Typecho数据库驱动，可选值：`Pdo_Mysql`、`Pdo_SQLite`、`Pdo_Pgsql`、`Mysqli`、`SQLite`、`Pgsql`。

### `TYPECHO_DB_HOST`

默认值：`localhost`

数据库服务器主机，仅适用于mysql和pgsql驱动。

### `TYPECHO_DB_PORT`

默认值：`3306`（mysql）或`5432`（pgsql）

数据库服务器端口，仅适用于mysql和pgsql驱动。

### `TYPECHO_DB_USER`

*（必填，适用于mysql和pgsql驱动）*

数据库用户名，仅适用于mysql和pgsql驱动。

### `TYPECHO_DB_PASSWORD`

*（必填，适用于mysql和pgsql驱动）*

数据库密码，仅适用于mysql和pgsql驱动。

### `TYPECHO_DB_FILE`

*（必填，适用于sqlite驱动）*

数据库文件存储路径，仅适用于sqlite驱动。

### `TYPECHO_DB_DATABASE`

*（必填，适用于mysql和pgsql驱动）*

Typecho数据库名称，仅适用于mysql和pgsql驱动。

### `TYPECHO_DB_PREFIX`

默认值：`typecho_`

所有数据表的前缀。

### `TYPECHO_DB_ENGINE`

默认值：`InnoDB`

Mysql数据库引擎，仅适用于mysql驱动。

### `TYPECHO_DB_CHARSET`

默认值：`utf8`（pgsql）或`utf8mb4`（mysql）

数据库字符集，仅适用于mysql和pgsql驱动。

### `TYPECHO_DB_NEXT`

默认值：`none`

数据库中已存在应用表时的操作：

* `none`：不操作，直接退出
* `keep`：保留表，跳过初始化
* `force`：删除表，重新初始化

### `TYPECHO_SITE_URL`

*（必填）*

网站URL，例如：`https://your-domain.com`

### `TYPECHO_USER_NAME`

默认值：`typecho`

管理员用户名。

### `TYPECHO_USER_PASSWORD`

默认值：随机8字符字符串

管理员密码。

### `TYPECHO_USER_MAIL`

默认值：`admin@localhost.local`

管理员邮箱。

## 端口

### FPM镜像

后缀为`*-fpm`的镜像可暴露fastcgi端口`9000`：

```bash
$ docker run --name typecho-server -p 9000:9000 -e TYPECHO_SITE_URL=https://your-domain.com -d joyqi/typecho:nightly-php7.4-fpm
```

### Apache镜像

后缀为`*-apache`的镜像可暴露HTTP端口`80`：

```bash
$ docker run --name typecho-server -p 8080:80 -e TYPECHO_SITE_URL=https://your-domain.com -d joyqi/typecho:nightly-php7.4-apache
```

## 卷

```bash
$ docker run --name typecho-server -v /var/typecho:/app/usr -e TYPECHO_SITE_URL=https://your-domain.com -d joyqi/typecho:nightly-php7.4
```

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/joyqi/typecho" title="joyqi/typecho Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/joyqi/typecho</a></p>
