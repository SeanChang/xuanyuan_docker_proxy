---
image: linuxserver/booksonic
description: "LinuxServer.io提供的Booksonic容器，用于将有声书流式传输到PC或Android手机。注意：此镜像已弃用，不再提供支持和更新，请迁移至linuxserver/docker-booksonic-air。"
source: https://xuanyuan.cloud/zh/r/linuxserver/booksonic
canonical: https://xuanyuan.cloud/zh/r/linuxserver/booksonic
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/booksonic" title="linuxserver/booksonic Docker 镜像中文简介、标签列表与拉取命令">linuxserver/booksonic 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# DEPRECATION NOTICE（弃用通知）

此镜像已弃用。我们将不再为此镜像提供支持，也不会对其进行更新。请迁移至 <https://github.com/linuxserver/docker-booksonic-air>

# [linuxserver/booksonic](https://github.com/linuxserver/docker-booksonic)

[Booksonic](http://booksonic.org) 是一个服务器和应用程序，用于将您的有声书流式传输到任何PC或Android手机。大多数功能也可在其他支持Subsonic应用的平台上使用。

![booksonic](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/booksonic.png)

## 支持的架构

我们的镜像支持多种架构，如 `x86-64`、`arm64` 和 `armhf`。我们利用docker manifest实现多平台识别。更多信息可参考docker [文档](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list) 和我们的公告 [文章](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/)。

只需拉取 `lscr.io/linuxserver/booksonic` 即可获取适合您架构的正确镜像，您也可以通过标签拉取特定架构的镜像。

此镜像支持的架构如下：

| 架构 | 标签 |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v7-latest |

## 版本标签

此镜像提供多种版本，可通过标签获取。`latest` 标签通常提供最新稳定版本，其他标签视为开发版本，使用时需谨慎。

| 标签 | 描述 |
| :----: | --- |
| latest | Booksonic 稳定版本 |
| prerelease | Booksonic 预发布版本 |

## 应用设置

默认用户/密码为 admin/admin。

## 用法

以下是帮助您开始创建容器的示例代码片段。

### docker-compose（推荐，[点击此处了解更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
version: "2.1"
services:
  booksonic:
    image: docker.xuanyuan.run/linuxserver/booksonic
    container_name: booksonic
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - CONTEXT_PATH=url-base
    volumes:
      - </path/to/appdata/config>:/config
      - </path/to/audiobooks>:/audiobooks
      - </path/to/podcasts>:/podcasts
      - </path/to/othermedia>:/othermedia
    ports:
      - 4040:4040
    restart: unless-stopped
```

### docker cli（[点击此处了解更多信息](https://docs.docker.com/engine/reference/commandline/cli/)）

```bash
docker run -d \
  --name=booksonic \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e CONTEXT_PATH=url-base \
  -p 4040:4040 \
  -v </path/to/appdata/config>:/config \
  -v </path/to/audiobooks>:/audiobooks \
  -v </path/to/podcasts>:/podcasts \
  -v </path/to/othermedia>:/othermedia \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/booksonic
```

## 参数

容器镜像通过运行时传递的参数进行配置（如上所示）。这些参数以冒号分隔，表示 `<外部>:<内部>`。例如，`-p 8080:80` 会将容器内的端口 `80` 暴露到主机IP的 `8080` 端口。

| 参数 | 功能 |
| :----: | --- |
| `-p 4040` | 应用WebUI端口 |
| `-e PUID=1000` | 用户ID - 详见下文说明 |
| `-e PGID=1000` | 组ID - 详见下文说明 |
| `-e TZ=Europe/London` | 指定时区，例如 Europe/London |
| `-e CONTEXT_PATH=url-base` | 用于反向代理等的基础URL |
| `-v /config` | 配置文件目录 |
| `-v /audiobooks` | 有声书目录 |
| `-v /podcasts` | 播客目录 |
| `-v /othermedia` | 其他媒体目录 |

## 环境变量从文件（Docker secrets）

您可以通过使用特殊前缀 `FILE__` 从文件设置任何环境变量。

例如：

```bash
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

这将根据 `/run/secrets/mysecretpassword` 文件的内容设置 `PASSWORD` 环境变量。

## 应用程序运行的Umask设置

对于我们所有的镜像，您可以使用可选的 `-e UMASK=022` 设置来覆盖容器内启动的服务的默认umask设置。请注意，umask不是chmod，它基于其值减去权限，而不是添加权限。请在寻求支持前阅读[此处](https://en.wikipedia.org/wiki/Umask)了解更多信息。

## 用户/组标识符

使用卷（`-v` 标志）时，主机OS和容器之间可能会出现权限问题。我们通过允许您指定用户 `PUID` 和组 `PGID` 来避免此问题。

确保主机上的任何卷目录都由您指定的相同用户拥有，所有权限问题将迎刃而解。

在本例中 `PUID=1000` 和 `PGID=1000`，您可以使用 `id user` 命令查找您的ID：

```bash
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=booksonic&query=%24.mods%5B%27booksonic%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=booksonic "查看此容器的可用mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用mods")

我们发布了各种 [Docker Mods](https://github.com/linuxserver/docker-mods)，以启用容器内的附加功能。上述动态徽章可访问此镜像可用的Mods列表（如有）以及可应用于我们任何镜像的通用Mods。

## 支持信息

* 容器运行时的Shell访问：`docker exec -it booksonic /bin/bash`
* 实时监控容器日志：`docker logs -f booksonic`
* 容器版本号：`docker inspect -f '{{ index .Config.Labels "build_version" }}' booksonic`
* 镜像版本号：`docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/booksonic`

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部应用。除某些例外（如nextcloud、plex），我们不建议或支持在容器内更新应用。请参阅上面的[应用设置](#应用设置)部分，了解是否推荐对此镜像进行应用更新。

以下是更新容器的说明：

### 通过Docker Compose

* 更新所有镜像：`docker-compose pull`
  * 或更新单个镜像：`docker-compose pull booksonic`
* 让compose按需更新所有容器：`docker-compose up -d`
  * 或更新单个容器：`docker-compose up -d booksonic`
* 您还可以删除旧的悬空镜像：`docker image prune`

### 通过Docker Run

* 更新镜像：`docker pull docker.xuanyuan.run/linuxserver/booksonic`
* 停止运行中的容器：`docker stop booksonic`
* 删除容器：`docker rm booksonic`
* 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）
* 您还可以删除旧的悬空镜像：`docker image prune`

### 通过Watchtower自动更新器（仅在您不记得原始参数时使用）

* 拉取其标签的最新镜像并在一次运行中使用相同的环境变量替换它：

  ```bash
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker.xuanyuan.run/containrrr/watchtower \
  --run-once booksonic
  ```

* 您还可以删除旧的悬空镜像：`docker image prune`

**注意：** 我们不认可使用Watchtower作为现有Docker容器自动更新的解决方案。事实上，我们通常不鼓励自动更新。但是，对于您忘记原始参数的容器，这是一个有用的一次性手动更新工具。从长远来看，我们强烈建议使用[Docker Compose](https://docs.linuxserver.io/general/docker-compose)。

### 镜像更新通知 - Diun（Docker镜像更新通知器）

* 我们推荐使用[Diun](https://crazymax.dev/diun/)进行更新通知。不推荐或支持其他自动更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-booksonic.git
cd docker-booksonic
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/booksonic:latest .
```

ARM变体可以使用`multiarch/qemu-user-static`在x86_64硬件上构建：

```bash
docker run --rm --privileged docker.xuanyuan.run/multiarch/qemu-user-static:register --reset
```

注册后，您可以使用`-f Dockerfile.aarch64`指定要使用的dockerfile。

## 版本历史

* **06.05.21:** - 此镜像现已弃用。请迁移至https://github.com/linuxserver/docker-booksonic-air
* **11.08.20:** - 更改上游GitHub仓库位置
* **22.12.19:** - 恢复拉取外部war包，升级jetty
* **30.04.19:** - 切换到从源代码构建war包，使用稳定的Booksonic版本
* **24.03.19:** - 切换到新的基础镜像，迁移到arm32v7标签
* **16.01.19:** - 添加流水线逻辑和多架构支持
* **05.01.19:** - 修复代码规范问题
* **27.08.18:** - 基于Ubuntu Bionic重建
* **06.12.17:** - 基于Alpine 3.7重建
* **11.07.17:** - 基于Alpine 3.6重建
* **07.02.17:** - 基于Alpine 3.5重建
* **13.12.16:** - 初始发布
