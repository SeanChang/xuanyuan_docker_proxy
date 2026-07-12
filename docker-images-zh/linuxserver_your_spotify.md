---
image: linuxserver/your_spotify
description: "linuxserver/your_spotify是一个自托管应用Docker镜像，用于跟踪Spotify收听记录并提供统计仪表板，包含Web服务器和客户端组件，支持多架构，需配合MongoDB 5+数据库使用。"
source: https://xuanyuan.cloud/zh/r/linuxserver/your_spotify
canonical: https://xuanyuan.cloud/zh/r/linuxserver/your_spotify
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/your_spotify" title="linuxserver/your_spotify Docker 镜像中文简介、标签列表与拉取命令">linuxserver/your_spotify 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/your_spotify

[Your_spotify](https://github.com/Yooooomi/your_spotify) 是一个自托管应用，用于跟踪您的Spotify收听记录并提供统计仪表板！它由定期轮询Spotify API的Web服务器和用于浏览统计数据的Web应用组成。

![your_spotify](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/your_spotify-logo.png)

## 支持的架构

该镜像利用Docker manifest实现多平台支持。只需拉取 `lscr.io/linuxserver/your_spotify:latest` 即可获取适合您架构的正确镜像，也可通过标签拉取特定架构镜像。

支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 应用设置

您需要通过Spotify [开发者仪表板](https://developer.spotify.com/dashboard/applications) 创建应用以获取Client ID和Secret。设置重定向URI需匹配您的APP_URL地址，并在域名后添加 `/api/oauth/spotify/callback`（例如：`http://localhost/api/oauth/spotify/callback`）。

应用需要外部[mongodb数据库](https://hub.docker.com/_/mongo/)，支持版本5+。

此为包含服务器和客户端组件的一体化容器。如需分离部署，请使用[your_spotify官方仓库](https://github.com/Yooooomi/your_spotify)的发行版。

## 使用方法

以下提供docker-compose和docker cli两种方式帮助您创建容器。

> [!NOTE]
> 除非参数标记为“可选”，否则均为必填项，必须提供值。

### docker-compose（推荐，[点击查看更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
services:
  your_spotify:
    image: docker.xuanyuan.run/linuxserver/your_spotify:latest
    container_name: your_spotify
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - APP_URL=http://localhost
      - SPOTIFY_PUBLIC=
      - SPOTIFY_SECRET=
      - CORS=http://localhost:80,https://localhost:443
      - MONGO_ENDPOINT=mongodb://mongo:27017/your_spotify
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped
```

### docker cli（[点击查看更多信息](https://docs.docker.com/engine/reference/commandline/cli/)）

```bash
docker run -d \
  --name=your_spotify \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e APP_URL=http://localhost \
  -e SPOTIFY_PUBLIC= \
  -e SPOTIFY_SECRET= \
  -e CORS=http://localhost:80,https://localhost:443 \
  -e MONGO_ENDPOINT=mongodb://mongo:27017/your_spotify \
  -p 80:80 \
  -p 443:443 \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/your_spotify:latest
```

## 参数说明

容器通过运行时参数配置，格式为`<外部>:<内部>`。例如 `-p 8080:80` 表示将容器内80端口映射到主机8080端口。

| 参数 | 功能 |
| :----: | --- |
| `-p 80:80` | your_spotify HTTP Web界面 |
| `-p 443:443` | your_spotify HTTPS Web界面 |
| `-e PUID=1000` | 用户ID - 详见下方说明 |
| `-e PGID=1000` | 组ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 指定时区，参考[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e APP_URL=http://localhost` | 应用访问的协议和主机名 |
| `-e SPOTIFY_PUBLIC=` | Spotify应用的Client ID |
| `-e SPOTIFY_SECRET=` | Spotify应用的Secret |
| `-e CORS=http://localhost:80,https://localhost:443` | 允许的CORS源，设为`all`允许所有源 |
| `-e MONGO_ENDPOINT=mongodb://mongo:27017/your_spotify` | MongoDB端点地址/端口 |

## 来自文件的环境变量（Docker secrets）

可通过特殊前缀`FILE__`从文件设置任何环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据`/run/secrets/mysecretvariable`文件内容设置环境变量`MYVAR`。

## 应用运行的Umask设置

所有镜像均支持通过可选参数`-e UMASK=022`覆盖容器内服务的默认umask设置。请注意，umask是权限掩码，基于其值减去权限而非添加。详情请参考[umask说明](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v`参数）时，主机OS和容器之间可能出现权限问题。通过指定用户`PUID`和组`PGID`可避免此问题。

确保主机上的卷目录由您指定的用户拥有，权限问题将迎刃而解。

此处`PUID=1000`和`PGID=1000`，可通过`id your_user`命令获取您的ID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=your_spotify&query=%24.mods%5B%27your_spotify%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=your_spotify "查看此容器可用的mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看通用mods")

我们提供多种[Docker Mods](https://github.com/linuxserver/docker-mods)以增强容器功能。上述动态徽章链接可查看此镜像可用的mods及适用于所有镜像的通用mods。

## 支持信息

* 容器运行时的Shell访问：

    ```bash
    docker exec -it your_spotify /bin/bash
    ```

* 实时监控容器日志：

    ```bash
    docker logs -f your_spotify
    ```

* 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' your_spotify
    ```

* 镜像版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/your_spotify:latest
    ```

## 更新信息

大多数镜像为静态、版本化，需更新镜像并重建容器以更新内部应用。除特殊说明外，不建议或支持在容器内更新应用。请参考[应用设置](#应用设置)部分确认是否适用于此镜像。

以下是更新容器的说明：

### 通过Docker Compose

* 更新镜像：
    * 所有镜像：

        ```bash
        docker-compose pull
        ```

    * 单个镜像：

        ```bash
        docker-compose pull your_spotify
        ```

* 更新容器：
    * 所有容器：

        ```bash
        docker-compose up -d
        ```

    * 单个容器：

        ```bash
        docker-compose up -d your_spotify
        ```

* 可删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过Docker Run

* 更新镜像：

    ```bash
    docker pull docker.xuanyuan.run/linuxserver/your_spotify:latest
    ```

* 停止运行中的容器：

    ```bash
    docker stop your_spotify
    ```

* 删除容器：

    ```bash
    docker rm your_spotify
    ```

* 使用上述docker run参数重建容器（若正确映射主机文件夹，`/config`文件夹和设置将保留）
* 可删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun（Docker Image Update Notifier）

> [!TIP]
> 推荐使用[Diun](https://crazymax.dev/diun/)获取更新通知。不建议或支持使用其他自动更新容器的工具。

## 本地构建

如需为开发或自定义逻辑修改镜像：

```bash
git clone https://github.com/linuxserver/docker-your_spotify.git
cd docker-your_spotify
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/your_spotify:latest .
```

可使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，可使用`-f Dockerfile.aarch64`指定Dockerfile。

## 版本历史

* **09.07.25：** - 基于Alpine 3.22重新构建。
* **20.12.24：** - 基于Alpine 3.21重新构建。
* **27.05.24：** - 现有用户应更新nginx配置以避免http2弃用警告。
* **24.05.24：** - 基于Alpine 3.20重新构建。
* **02.03.24：** - 针对1.8.0版本变化进行更新。初始数据库迁移可能需要几分钟。
* **24.01.24：** - 现有用户应更新：site-confs/default.conf - 清理默认站点配置。
* **23.12.23：** - 基于Alpine 3.19和php 8.3重新构建。
* **23.01.23：** - 基于Alpine 3.18重新构建，标准化nginx默认站点配置。
* **23.01.23：** - 初始发布。
