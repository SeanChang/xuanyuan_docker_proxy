---
image: autoscalix/bookstack
description: "一个基于Debian的稳定可靠的BookStack文档平台Docker镜像。"
source: https://xuanyuan.cloud/zh/r/autoscalix/bookstack
canonical: https://xuanyuan.cloud/zh/r/autoscalix/bookstack
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/autoscalix/bookstack" title="autoscalix/bookstack Docker 镜像中文简介、标签列表与拉取命令">autoscalix/bookstack 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ![Autoscalix logo](https://gitlab.com/es-six/autoscalix-docker-bookstack/-/raw/master/assets/autoscalix.png) Autoscalix 的 Docker BookStack

**警告**：此项目即将结束：
- Docker镜像将继续托管在Docker Hub
- 仓库将切换为只读模式

通用标签：
[
![Docker Pulls](https://img.shields.io/docker/pulls/autoscalix/bookstack)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/autoscalix/bookstack/latest)
![Docker Image Version (latest by date)](https://img.shields.io/docker/v/autoscalix/bookstack)
![Unmaintained](https://img.shields.io/badge/maintained-no-red)
![Automated builds status](https://img.shields.io/badge/automated%20builds-disabled-red)
](https://gitlab.com/es-six/autoscalix-docker-bookstack)

依赖相关标签：
[
![基于Debian](https://img.shields.io/badge/image%20based%20on-debian%20bullseye%20(v11)-brightgreen)
![wkhtmltopdf版本](https://img.shields.io/badge/wkhtmltopdf-v0.12.6-brightgreen)
![PHP版本](https://img.shields.io/badge/PHP-v8.0-brightgreen)
](https://gitlab.com/es-six/autoscalix-docker-bookstack)

许可证：[
![许可证类型](https://img.shields.io/badge/license-MIT-black)
](https://gitlab.com/es-six/autoscalix-docker-bookstack/-/blob/master/LICENSE)

## 🚀 描述

BookStack文档平台的稳定可靠Docker镜像，由Autoscalix免费提供。

![bookstack logo](https://gitlab.com/es-six/autoscalix-docker-bookstack/-/raw/master/assets/bookstack.png)

## ⚙️ 支持的标签
- `latest`、`amd64-latest`、`arm64-latest`、`armhf-latest`
- `[BookStack发布版本]`、`amd64-[BookStack发布版本]`、`arm64-[BookStack发布版本]`、`armhf-[BookStack发布版本]`（例如：`v21.05.2`、`amd64-v21.05.2`、`arm64-v21.05.2`、`armhf-v21.05.2`）

有关BookStack发布的更多信息：[https://github.com/BookStackApp/BookStack/releases](https://github.com/BookStackApp/BookStack/releases)

## ⚙️ 支持的架构

我们的镜像支持最常见的架构，如`x86-64`、`arm64`和`armhf`。
我们使用Docker清单实现多平台支持。
有关此功能的更多信息，请参见Docker文档[此处](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list)。

只需拉取`autoscalix/bookstack`即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

此镜像支持的架构：

| 架构 | 标签 |
| :----: | --- |
| x86-64（INTEL/AMD 64位） | amd64-latest |
| arm64（arm64v8） | arm64-latest |
| armhf（arm32v7） | armhf-latest |

如有需要，可以使用这些标签拉取特定架构的镜像。

例如：`autoscalix/bookstack:amd64-latest`、`autoscalix/bookstack:arm64-latest` 或 `autoscalix/bookstack:armhf-latest`

## 🚀 使用示例

#### docker-compose（推荐）

```yaml
version: "3.2"
services:
  bookstack:
    image: docker.xuanyuan.run/autoscalix/bookstack
    container_name: bookstack
    environment:
      - APP_URL=https://your-sub.domain.tld
      - DB_HOST=<yourdbhost>
      - DB_USERNAME=<yourdbusername>
      - DB_PASSWORD=<yourdbpass>
      - DB_DATABASE=<yourdbname>
      - DB_PORT=<yourdbport>
      - WAIT_DB_INIT=1
    volumes:
      - /host/data/path/bookstack:/config
    ports:
      - 8000:80
    restart: unless-stopped
    depends_on:
      - bookstack_db
  bookstack_db:
    image: docker.xuanyuan.run/mysql
    container_name: bookstack_db
    ports:
      - <yourdbport>:3306
    environment:
      - TZ=Europe/Paris
      - MYSQL_ROOT_PASSWORD=<yourdbpass>
      - MYSQL_DATABASE=<yourdbname>
      - MYSQL_USER=<yourdbusername>
      - MYSQL_PASSWORD=<yourdbpass>
    command: mysqld --default-authentication-plugin=mysql_native_password
    volumes:
      - /host/data/path/mysql:/var/lib/mysql
    restart: unless-stopped
```

#### docker cli

```bash
docker run -d \
  --name=bookstack \
  -e APP_URL=https://your-sub.domain.tld \
  -e DB_HOST=<yourdbhost> \
  -e DB_USERNAME=<yourdbuser> \
  -e DB_PASSWORD=<yourdbpass> \
  -e DB_DATABASE=<yourdbname> \
  -p 8000:80 \
  -v /path/to/data/on/host:/config \
  --restart unless-stopped \
  docker.xuanyuan.run/autoscalix/bookstack
```

## 📖 基本参数

Autoscalix Docker镜像配置为可在运行时传递BookStack的.env参数（如上所示）。

| 参数 | 功能 |
| :----: | --- |
| `-p 8000:80` | 将容器的80端口映射到主机的8000端口 |
| `-e APP_URL=` | 指定访问BookStack实例的IP:端口或URL（例如：`http://192.168.1.123:8000` 或 `https://bookstack.mydomain.tld`） |
| `-e DB_HOST=<yourdbhost>` | 指定数据库主机 |
| `-e DB_USERNAME=<yourdbuser>` | 指定数据库用户 |
| `-e DB_PASSWORD=<yourdbpass>` | 指定数据库密码 |
| `-e DB_DATABASE=<yourdbname>` | 指定要使用的数据库 |
| `-e APP_KEY=<yourSecretAppKeyHere>` | （可选）BookStack用于加密目的（CSRF和会话cookie）的密钥，如未指定，将自动生成。APP_KEY需为16或32个字符 |
| `-e WAIT_DB_INIT=1` | （可选）使容器等待数据库可用，将等待环境变量DB_HOST和DB_PORT中指定的主机和端口上的数据库启动并运行（在docker-compose文件中使用mysql数据库和BookStack时有用）。如果使用外部数据库（BookStack容器启动时已运行），不要指定此变量以加快容器启动速度 |
| `-v </path/to/data/on/host>:/config` | （如果使用BookStack的对象存储如S3则可选）将上传的数据存储在Docker主机上（对于生产环境，建议使用S3对象存储，有关将BookStack上传文件存储到对象存储的更多信息，请参见BookStack文档[此处](https://www.bookstackapp.com/docs/admin/upload-config/#s3)） |

## 🛠️ 平台设置

BookStack的默认凭据：
- 用户名：admin@admin.com
- 密码：password

#### 高级用法

如果需要使用BookStack的额外功能（电子邮件、Memcache、LDAP等），可能需要在Docker容器环境中传递其他变量（或创建自己的.env文件）。

可以通过docker run传递BookStack的任何.env.example.complete变量作为额外的容器环境变量（例如：`-e VARIABLE=value`）。

查看BookStack可用的.env变量[此处](https://github.com/BookStackApp/BookStack/blob/master/.env.example.complete)。

可以查看BookStack文档获取有关.env文件的更多信息。

创建容器时，镜像将使用路径`/config/www/.env`中的.env文件。

#### PDF渲染

此镜像中提供了稳定版本的[wkhtmltopdf](https://wkhtmltopdf.org/)（带补丁的QT），可按照BookStack文档[此处](https://www.bookstackapp.com/docs/admin/pdf-rendering/)所述用作替代PDF渲染生成器。

此wkhtmltopdf二进制文件已测试可成功渲染大量BookStack页面（超过100页），包含各种内容且不会崩溃（当然需要足够的可用RAM）。

此镜像中wkhtmltopdf二进制文件的路径（需包含在.env文件中）为`/usr/local/bin/wkhtmltopdf`。

例如：要启用wkhtmltopdf渲染，使用`WKHTMLTOPDF=/usr/local/bin/wkhtmltopdf`作为环境变量。

#### 集群中托管BookStack的提示

此镜像还兼容常见的Docker云托管技术（如：kubernetes、ECS等），如果需要在容错和可扩展的基础设施上托管BookStack。

如果要在负载均衡器后面托管BookStack，需要使用基于cookie的粘性会话，以确保CSRF和登录正常工作。

建议基于XSRF-TOKEN cookie设置粘性会话，因为这允许每个请求（带有唯一CSRF令牌）在需要时在不同服务器上运行，而不是在整个会话期间固定到一个服务器。

## 🌐 关于更新

自v21.04以来，每个新的BookStack版本都会通过计划的GitLab管道自动测试Autoscalix Docker镜像的新版本，然后推送到Docker Hub。

每天检查BookStack更新。

以下是此Docker镜像中嵌入的依赖项及其当前版本列表：
- wkhtmltopdf：0.12.6-1版本
- debian基础镜像：bullseye-slim:latest（debian v11）
- PHP：8.0.x版本

以下是根据Docker中运行BookStack的方式（docker-compose或docker run）更新docker-bookstack安装的示例。

数据库迁移在容器启动期间完成。

#### docker-compose

```bash
# 更新镜像，然后更新容器
docker-compose pull
docker-compose up -d

# （可选）删除旧的悬空镜像
docker image prune
```

#### docker cli

```bash
# 更新autoscalix/bookstack镜像
docker pull docker.xuanyuan.run/autoscalix/bookstack

# 然后停止容器
docker stop bookstack

# 删除旧容器
docker rm bookstack

# 然后使用上面的docker run示例从Docker镜像重新创建容器（参见“使用示例 - docker cli”）
...

# 最后删除旧的悬空镜像
docker image prune
```

## 🧰 本地构建

如果需要为开发或其他目的对此镜像进行高级修改，请使用以下命令在本地构建此镜像：

```bash
git clone https://gitlab.com/es-six/autoscalix-docker-bookstack.git autoscalix-docker-bookstack
cd autoscalix-docker-bookstack
git clone https://github.com/BookStackApp/BookStack.git --branch release --single-branch bookstack
docker build --no-cache -t autoscalix/bookstack .
```

可以使用[docker buildx](https://docs.docker.com/buildx/working-with-buildx/)在x86_64硬件上构建`arm64`镜像：

```bash
# 获取Docker的qemu
docker run --rm --privileged docker.xuanyuan.run/multiarch/qemu-user-static --reset -p yes
# 创建docker buildx构建器
docker buildx create --name multiarch-builder
docker buildx use multiarch-builder
docker buildx inspect --bootstrap multiarch-builder
# 运行构建
docker buildx build --load --no-cache --platform linux/arm64 -t bookstack-arm64 .
```

可以使用[docker buildx](https://docs.docker.com/buildx/working-with-buildx/)在x86_64硬件上构建`armhf`镜像：

```bash
# 获取Docker的qemu
docker run --rm --privileged docker.xuanyuan.run/multiarch/qemu-user-static --reset -p yes
# 创建docker buildx构建器
docker buildx create --name multiarch-builder
docker buildx use multiarch-builder
docker buildx inspect --bootstrap multiarch-builder
# 运行构建
docker buildx build --load --no-cache --platform linux/arm/v7 -t bookstack-armhf .
```

使用默认Dockerfile，可用于构建x86_64、arm64或armhf版本。

## 🤖 在Windows WSL上使用

如果要在Windows WSL上使用此镜像，需要执行两项额外操作：
- 使用host.docker.internal作为数据库主机。
- 将Docker卷存储在WSL内部，而不是Windows NTFS文件系统上，因为NTFS没有Linux上EXT4相同的权限管理系统，否则在访问卷中的文件时会出错。

建议：使用上面的docker-compose示例，并指定DB_HOST=host.docker.internal

## 🔨 故障排除

如果需要显示BookStack中发生的错误以排查安装问题，传递环境变量APP_DEBUG=1，以便在加载页面时发生错误时显示错误详细信息。

## 📚 源代码

GitLab仓库地址：[https://gitlab.com/es-six/autoscalix-docker-bookstack](https://gitlab.com/es-six/autoscalix-docker-bookstack)

## 新闻

- 2021年9月7日：升级到debian 11（bullseye）

## 📚 许可证

[MIT](https://gitlab.com/es-six/autoscalix-docker-bookstack/-/blob/master/LICENSE)，查看GitLab仓库：[此处](https://gitlab.com/es-six/autoscalix-docker-bookstack/-/blob/master/LICENSE)
