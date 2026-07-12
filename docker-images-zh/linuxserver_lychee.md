---
image: linuxserver/lychee
description: "LinuxServer.io提供的Lychee容器，用于照片的存储、组织与分享管理。"
source: https://xuanyuan.cloud/zh/r/linuxserver/lychee
canonical: https://xuanyuan.cloud/zh/r/linuxserver/lychee
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/lychee" title="linuxserver/lychee Docker 镜像中文简介、标签列表与拉取命令">linuxserver/lychee 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/lychee

## 镜像概述和主要用途

[Lychee](https://lycheeorg.github.io/) 是一款免费的照片管理工具，可运行在您的服务器或网络空间上。安装过程简单快捷，能像原生应用一样上传、管理和分享照片。Lychee 提供所需的全部功能，并且您的所有照片都能得到安全存储。

LinuxServer.io 团队提供的此容器具有以下特点：
- 定期且及时的应用更新
- 简单的用户映射 (PGID, PUID)
- 带有 s6 覆盖层的自定义基础镜像
- 每周基础 OS 更新，在整个 LinuxServer.io 生态系统中共享通用层，以最小化空间使用、停机时间和带宽
- 定期安全更新

## 核心功能和特性

- 简单直观的照片管理界面
- 支持多种数据库后端（SQLite、MySQL、PostgreSQL）
- 安全的照片存储和访问控制
- 照片上传、分类和标签功能
- 自定义相册和分享选项
- 多平台支持（x86-64、arm64）
- 可自定义上传文件大小限制
- 支持反向代理配置

## 使用场景和适用范围

- 个人照片库管理
- 家庭照片共享系统
- 小型团队的图片资源库
- 个人网站或博客的照片存储解决方案
- 需要安全存储和管理图片的任何场景

## 支持的架构

该镜像利用 Docker manifest 实现多平台支持。只需拉取 `lscr.io/linuxserver/lychee:latest` 即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 应用设置

**此镜像不能与预填充的 `/pictures` 挂载一起使用，Lychee 需要对该文件夹拥有完全控制权**

通过 Web UI 设置账户，可在 http://SERVERIP:PORT 访问。

更多信息请访问 [Lychee 官方网站](https://lycheeorg.github.io/)。

### 自定义配置

在某些情况下，您可能需要更改 Lychee 的默认设置。例如，如果您在上传大文件时遇到限制，可以增加此限制。

#### 增加上传限制

上传限制在配置目录 (`/config`) 中的 `user.ini` 文件中定义。您可以通过修改以下值来增加此限制：

```ini
post_max_size = 500M
upload_max_filesize = 500M
```

修改后，需要重新启动 Docker 容器使更改生效。

**请注意，根据服务器的可用资源，这些更改可能会对服务器性能产生影响。因此，建议谨慎修改这些设置。**

## 详细的使用方法和配置说明

### Docker Compose (推荐)

```yaml
---
services:
  lychee:
    image: docker.xuanyuan.run/linuxserver/lychee:latest
    container_name: lychee
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - DB_CONNECTION=
      - DB_HOST=
      - DB_PORT=
      - DB_USERNAME=
      - DB_PASSWORD=
      - DB_DATABASE=
      - APP_NAME=Lychee # 可选
      - APP_URL= # 可选
      - TRUSTED_PROXIES= # 可选
    volumes:
      - /path/to/lychee/config:/config
      - /path/to/pictures:/pictures
    ports:
      - 80:80
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=lychee \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e DB_CONNECTION= \
  -e DB_HOST= \
  -e DB_PORT= \
  -e DB_USERNAME= \
  -e DB_PASSWORD= \
  -e DB_DATABASE= \
  -e APP_NAME=Lychee `# 可选` \
  -e APP_URL= `# 可选` \
  -e TRUSTED_PROXIES= `# 可选` \
  -p 80:80 \
  -v /path/to/lychee/config:/config \
  -v /path/to/pictures:/pictures \
  --restart unless-stopped \
  lscr.io/linuxserver/lychee:latest
```

## 参数说明

容器通过运行时传递的参数进行配置。这些参数以冒号分隔，表示 `<外部>:<内部>`。例如，`-p 8080:80` 会将容器内的端口 `80` 暴露出来，可通过主机 IP 的 `8080` 端口访问。

| 参数 | 功能 |
| :----: | --- |
| `-p 80:80` | HTTP 界面端口 |
| `-e PUID=1000` | 用户 ID - 详见下方说明 |
| `-e PGID=1000` | 组 ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见 [时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e DB_CONNECTION=` | 数据库类型，可选值：`sqlite`、`mysql`、`pqsql` |
| `-e DB_HOST=` | 数据库服务器主机名，仅 `mysql` 和 `pgsql` 需要 |
| `-e DB_PORT=` | 数据库服务器端口，仅 `mysql` 和 `pgsql` 需要 |
| `-e DB_USERNAME=` | 数据库用户名，仅 `mysql` 和 `pgsql` 需要 |
| `-e DB_PASSWORD=` | 数据库密码，仅 `mysql` 和 `pgsql` 需要 |
| `-e DB_DATABASE=` | SQLite 数据库文件路径，或 MySQL/PostgreSQL 数据库名称 |
| `-e APP_NAME=Lychee` | 画廊名称 |
| `-e APP_URL=` | 访问 Lychee 的 URL，包括协议和端口（如适用） |
| `-e TRUSTED_PROXIES=` | 设置反向代理的 IP 或子网掩码，如果运行在反向代理后面。设置为 `*` 可信任所有 IP（**如果暴露在互联网上，请勿使用 `*`**） |
| `-v /config` | 持久化配置文件目录 |
| `-v /pictures` | Lychee 存储上传图片的位置 |

## 环境变量从文件获取（Docker secrets）

您可以通过使用特殊前缀 `FILE__` 从文件中设置任何环境变量。

例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据 `/run/secrets/mysecretvariable` 文件的内容设置环境变量 `MYVAR`。

## 运行应用的 Umask

对于我们所有的镜像，您可以使用可选的 `-e UMASK=022` 设置来覆盖容器内启动的服务的默认 umask 设置。请注意，umask 不是 chmod，它根据其值减去权限，而不是添加权限。在请求支持之前，请先[了解 umask](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v` 标志）时，主机操作系统和容器之间可能会出现权限问题。我们通过允许您指定用户 `PUID` 和组 `PGID` 来避免此问题。

确保主机上的任何卷目录都归您指定的同一用户所有，这样任何权限问题都会像魔术一样消失。

在此示例中 `PUID=1000` 和 `PGID=1000`，要查找您的 PUID 和 PGID，请使用 `id your_user`：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=lychee&query=%24.mods%5B%27lychee%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=lychee "查看此容器的可用 mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用 mods")

我们发布了各种 [Docker Mods](https://github.com/linuxserver/docker-mods)，以启用容器内的额外功能。可通过上方的动态徽章访问此镜像可用的 Mods 列表（如有）以及可应用于我们任何镜像的通用 Mods。

## 支持信息

### 容器运行时的 Shell 访问

```bash
docker exec -it lychee /bin/bash
```

### 实时监控容器日志

```bash
docker logs -f lychee
```

### 容器版本号

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lychee
```

### 镜像版本号

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/lychee:latest
```

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部的应用程序。除了一些例外情况（在相关的 readme.md 中注明），我们不建议或支持在容器内更新应用程序。请参考上面的[应用设置](#应用设置)部分，查看是否推荐对此镜像进行更新。

以下是更新容器的说明：

### 通过 Docker Compose

#### 更新镜像：
- 所有镜像：

  ```bash
  docker-compose pull
  ```

- 单个镜像：

  ```bash
  docker-compose pull lychee
  ```

#### 更新容器：
- 所有容器：

  ```bash
  docker-compose up -d
  ```

- 单个容器：

  ```bash
  docker-compose up -d lychee
  ```

- 您还可以删除旧的悬空镜像：

  ```bash
  docker image prune
  ```

### 通过 Docker Run

- 更新镜像：

  ```bash
  docker pull docker.xuanyuan.run/linuxserver/lychee:latest
  ```

- 停止运行中的容器：

  ```bash
  docker stop lychee
  ```

- 删除容器：

  ```bash
  docker rm lychee
  ```

- 使用上述相同的 docker run 参数重新创建新容器（如果正确映射到主机文件夹，您的 `/config` 文件夹和设置将被保留）

- 您还可以删除旧的悬空镜像：

  ```bash
  docker image prune
  ```

### 镜像更新通知 - Diun (Docker Image Update Notifier)

> **提示**：我们推荐使用 [Diun](https://crazymax.dev/diun/) 进行更新通知。不建议或支持使用其他自动更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-lychee.git
cd docker-lychee
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/lychee:latest .
```

可以使用 `lscr.io/linuxserver/qemu-static` 在 x86_64 硬件上构建 ARM 变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，您可以使用 `-f Dockerfile.aarch64` 指定要使用的 dockerfile。

## 版本历史

- **09.07.25:** - 重新基于 Alpine 3.20 构建。
- **03.12.24:** - 使用 cosign 验证构建工件。
- **27.05.24:** - 重新基于 Alpine 3.20 构建。现有用户应更新其 nginx 配置以避免 http2 弃用警告。
- **18.01.24:** - 添加 php-sodium。
- **13.01.24:** - 重新基于 Alpine 3.19 构建，使用 php 8.3。
- **27.12.23:** - 更新镜像以支持 v5。
- **25.12.23:** - 现有用户应更新：site-confs/default.conf - 清理默认站点配置。将 npm 依赖项构建到镜像中。
- **25.05.23:** - 重新基于 Alpine 3.18 构建，弃用 armhf。
- **13.04.23:** - 将 ssl.conf 包含移动到 default.conf。
- **11.01.23:** - 重新基于 Alpine 3.17 构建，使用 php8.1。重构 nginx 配置（[参见变更公告](https://info.linuxserver.io/issues/2022-08-20-nginx-base)）。切换到 git clone，因为使用发布工件构建失败。
- **13.05.21:** - 使 readme 更清晰。
- **18.04.21:** - 为 v4.3 添加 php-intl。
- **31.01.21:** - 添加 jpegoptim。
- **15.01.21:** - 重新基于 Alpine 3.13 构建，添加 php7-ctype。
- **10.07.20:** - 升级到 Lychee v4 并重新基于 Alpine 3.12 构建。
- **19.12.19:** - 重新基于 Alpine 3.11 构建。
- **23.10.19:** - 增加 fastcgi 超时（现有用户需要手动更新）。
- **19.09.19:** - 更新项目网站 URL。
- **28.06.19:** - 重新基于 Alpine 3.10 构建。
- **05.05.19:** - 重新基于 Alpine 3.9 构建，使用新的 armv7 镜像格式。
- **21.01.18:** - 添加 ffmpeg 用于视频缩略图创建，切换到安装 zip 发布版而不是源 tarball，创建小缩略图文件夹，切换到动态 readme。
- **14.01.19:** - 添加流水线逻辑和多架构支持。
- **04.09.18:** - 重新基于 Alpine 3.8 构建，切换到 LycheeOrg 仓库。
- **08.01.18:** - 重新基于 Alpine 3.7 构建。
- **25.05.17:** - 重新基于 Alpine 3.6 构建。
- **03.05.17:** - 使用仓库固定以更好地解决依赖关系，使用 php7-imagick 的仓库版本。
- **12.02.17:** - 初始发布。
