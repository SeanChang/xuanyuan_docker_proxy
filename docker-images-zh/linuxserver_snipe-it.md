---
image: linuxserver/snipe-it
description: "此镜像已弃用，不再提供支持和更新。Snipe-it是一款简单易用的资产管理系统，注重用户体验设计，提供简洁界面和批量操作功能，帮助用户高效管理IT资产。推荐迁移至官方镜像。"
source: https://xuanyuan.cloud/zh/r/linuxserver/snipe-it
canonical: https://xuanyuan.cloud/zh/r/linuxserver/snipe-it
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/snipe-it" title="linuxserver/snipe-it Docker 镜像中文简介、标签列表与拉取命令">linuxserver/snipe-it 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像弃用通知
此镜像已被弃用。我们将不再为此镜像提供支持，也不会进行更新。

建议迁移至Grokability提供的官方Docker镜像：https://snipe-it.readme.io/docs/docker

# linuxserver/snipe-it

[Snipe-it](https://github.com/grokability/snipe-it) 是一款简单易用的资产管理系统。由解决实际IT和资产管理问题的人员开发，注重用户体验设计。简洁的界面和批量操作功能提高工作效率。

## 支持的架构
该镜像利用Docker manifest实现多平台支持。拉取 `lscr.io/linuxserver/snipe-it:latest` 即可获取适合您架构的正确镜像，也可通过标签拉取特定架构的镜像。

| 架构 | 支持情况 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-<version tag> |
| arm64 | ✅ | arm64v8-<version tag> |
| armhf | ❌ | |

## 应用设置
通过 `<your-ip>:8080` 访问Web界面，更多信息请查看[Snipe-it](https://github.com/grokability/snipe-it)。

**此容器需要连接MySQL或MariaDB服务器，推荐使用[我们提供的MariaDB镜像](https://github.com/linuxserver/docker-mariadb)**

## 使用方法
以下提供docker-compose和docker cli两种使用方式帮助您创建容器。

>[!NOTE]
>除非参数标记为'可选'，否则均为必填项，必须提供值。

### docker-compose（推荐）
```yaml
---
services:
  snipe-it:
    image: docker.xuanyuan.run/linuxserver/snipe-it:latest
    container_name: snipe-it
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - APP_KEY=
      - APP_URL=http://localhost:8080
      - MYSQL_PORT_3306_TCP_ADDR=
      - MYSQL_PORT_3306_TCP_PORT=
      - MYSQL_DATABASE=
      - MYSQL_USER=
      - MYSQL_PASSWORD=
      - APP_DEBUG=false #可选
      - APP_ENV=production #可选
      - APP_FORCE_TLS=false #可选
      - APP_LOCALE= #可选
      - MAIL_PORT_587_TCP_ADDR= #可选
      - MAIL_PORT_587_TCP_PORT= #可选
      - MAIL_ENV_FROM_ADDR= #可选
      - MAIL_ENV_FROM_NAME= #可选
      - MAIL_ENV_ENCRYPTION= #可选
      - MAIL_ENV_USERNAME= #可选
      - MAIL_ENV_PASSWORD= #可选
    volumes:
      - /path/to/snipe-it/data:/config
    ports:
      - 8080:80
    restart: unless-stopped
```

### docker cli
```bash
docker run -d \
  --name=snipe-it \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e APP_KEY= \
  -e APP_URL=http://localhost:8080 \
  -e MYSQL_PORT_3306_TCP_ADDR= \
  -e MYSQL_PORT_3306_TCP_PORT= \
  -e MYSQL_DATABASE= \
  -e MYSQL_USER= \
  -e MYSQL_PASSWORD= \
  -e APP_DEBUG=false `#optional` \
  -e APP_ENV=production `#optional` \
  -e APP_FORCE_TLS=false `#optional` \
  -e APP_LOCALE= `#optional` \
  -e MAIL_PORT_587_TCP_ADDR= `#optional` \
  -e MAIL_PORT_587_TCP_PORT= `#optional` \
  -e MAIL_ENV_FROM_ADDR= `#optional` \
  -e MAIL_ENV_FROM_NAME= `#optional` \
  -e MAIL_ENV_ENCRYPTION= `#optional` \
  -e MAIL_ENV_USERNAME= `#optional` \
  -e MAIL_ENV_PASSWORD= `#optional` \
  -p 8080:80 \
  -v /path/to/snipe-it/data:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/snipe-it:latest
```

## 参数
容器通过运行时传递的参数进行配置，格式为`<外部>:<内部>`。例如，`-p 8080:80`将容器内的80端口映射到主机的8080端口。

| 参数 | 功能 |
| :----: | --- |
| `-p 8080:80` | Snipe-IT Web界面端口 |
| `-e PUID=1000` | 用户ID - 详见下方说明 |
| `-e PGID=1000` | 组ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e APP_KEY=` | 用于加密存储数据的应用密钥，可通过`docker exec snipe-it php /app/www/artisan key:generate --show`生成 |
| `-e APP_URL=http://localhost:8080` | 主机名或IP地址，需指定http/https |
| `-e MYSQL_PORT_3306_TCP_ADDR=` | MySQL主机名或IP地址 |
| `-e MYSQL_PORT_3306_TCP_PORT=` | MySQL端口 |
| `-e MYSQL_DATABASE=` | MySQL数据库名 |
| `-e MYSQL_USER=` | MySQL用户名 |
| `-e MYSQL_PASSWORD=` | MySQL密码 |
| `-e APP_DEBUG=false` | 设置为`true`可在Web界面显示调试信息（可选） |
| `-e APP_ENV=production` | 环境类型，默认为`production`，也可使用`testing`或`develop`（可选） |
| `-e APP_FORCE_TLS=false` | 设置为`true`可在反向代理后强制使用TLS（可选） |
| `-e APP_LOCALE=` | 默认语言为`en-US`，可设置为[语言列表](https://snipe-it.readme.io/docs/configuration#section-setting-a-language)中的值（可选） |
| `-e MAIL_PORT_587_TCP_ADDR=` | SMTP邮件服务器IP或主机名（可选） |
| `-e MAIL_PORT_587_TCP_PORT=` | SMTP邮件服务器端口（可选） |
| `-e MAIL_ENV_FROM_ADDR=` | 邮件回复地址（可选） |
| `-e MAIL_ENV_FROM_NAME=` | 系统默认账户发送邮件时显示的名称（可选） |
| `-e MAIL_ENV_ENCRYPTION=` | 邮件加密方式，例如`tls`（可选） |
| `-e MAIL_ENV_USERNAME=` | SMTP服务器登录用户名（可选） |
| `-e MAIL_ENV_PASSWORD=` | SMTP服务器登录密码（可选） |
| `-v /config` | 包含Snipe-IT的配置文件和数据存储 |

## 环境变量文件（Docker secrets）
可以通过特殊前缀`FILE__`从文件中设置任何环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据`/run/secrets/mysecretvariable`文件的内容设置环境变量`MYVAR`。

## 应用程序Umask设置
所有镜像都支持通过可选的`-e UMASK=022`参数覆盖容器内服务的默认umask设置。请注意，umask是从权限中减去，而不是添加。

## 用户/组标识符
使用卷（`-v`标志）时，主机OS和容器之间可能出现权限问题。通过指定用户`PUID`和组`PGID`可以避免此问题。

确保主机上的任何卷目录都归您指定的用户所有，权限问题将会解决。

使用`id your_user`命令可查看您的PUID和PGID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods
我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)以启用容器内的附加功能。可通过上方动态徽章访问此镜像可用的Mods列表以及可应用于任何LinuxServer.io镜像的通用Mods。

## 支持信息
* 容器运行时的Shell访问：

  ```bash
docker exec -it snipe-it /bin/bash
```

* 实时监控容器日志：

  ```bash
docker logs -f snipe-it
```

* 容器版本号：

  ```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' snipe-it
```

* 镜像版本号：

  ```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/snipe-it:latest
```

## 更新信息
大多数镜像都是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部应用程序。除特殊情况外，不建议或支持在容器内更新应用程序。

### 通过Docker Compose更新
* 更新镜像：
  * 所有镜像：
    ```bash
docker-compose pull
    ```
  * 单个镜像：
    ```bash
docker-compose pull snipe-it
    ```

* 更新容器：
  * 所有容器：
    ```bash
docker-compose up -d
    ```
  * 单个容器：
    ```bash
docker-compose up -d snipe-it
    ```

* 清理旧镜像：
  ```bash
docker image prune
  ```

### 通过Docker Run更新
* 更新镜像：
  ```bash
docker pull docker.xuanyuan.run/linuxserver/snipe-it:latest
  ```

* 停止运行中的容器：
  ```bash
docker stop snipe-it
  ```

* 删除容器：
  ```bash
docker rm snipe-it
  ```

* 使用上述相同的docker run参数重新创建容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）

* 清理旧镜像：
  ```bash
docker image prune
  ```

## 本地构建
如需为开发目的或自定义逻辑对镜像进行本地修改：

```bash
git clone https://github.com/linuxserver/docker-snipe-it.git
cd docker-snipe-it
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/snipe-it:latest .
```

可以使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，可使用`-f Dockerfile.aarch64`指定要使用的dockerfile。

## 版本历史
* **16.01.25:** - 基于Alpine 3.21重建
* **17.06.24:** - 基于Alpine 3.20重建，现有用户应更新nginx配置以避免http2弃用警告
* **06.03.24:** - 现有用户应更新site-confs/default.conf - 清理默认站点配置
* **17.02.24:** - 添加php81-exif
* **03.07.23:** - 弃用armhf架构
* **13.04.23:** - 将ssl.conf包含移动到default.conf
* **13.04.23:** - 添加php81-pecl-redis以支持Redis
* **28.12.22:** - 基于Alpine 3.17重建，迁移到s6v3
* **20.08.22:** - 基于Alpine 3.15和php8重建，重构nginx配置
* **14.05.22:** - 为v6添加php7-sodium
* **12.04.22:** - 不构建开发元素
* **02.03.22:** - 重新设计初始化逻辑
* **29.06.21:** - 基于Alpine 3.14重建
* **30.04.21:** - 基于Alpine 3.13重建，启动时添加artisan migrate
* **01.06.20:** - 基于Alpine 3.12重建
* **19.12.19:** - 基于Alpine 3.11重建
* **28.06.19:** - 基于Alpine 3.10重建
* **10.04.19:** - 添加V4.7.0所需的php依赖
* **10.04.19:** - 修复新引导缓存目录的权限
* **23.03.19:** - 切换到新的基础镜像
* **22.02.19:** - 基于Alpine 3.9重建
* **31.10.18:** - 基于Alpine 3.8重建
* **05.08.18:** - 迁移到实时构建服务器
* **13.06.18:** - 初始发布
