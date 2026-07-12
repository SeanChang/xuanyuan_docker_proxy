---
image: linuxserver/minetest
description: "由LinuxServer.io提供的Minetest服务器容器，这是一款近乎无限世界的方块沙盒游戏和游戏引擎，支持多平台部署，便于用户映射和配置。请注意：该镜像已弃用，建议迁移至docker-luanti。"
source: https://xuanyuan.cloud/zh/r/linuxserver/minetest
canonical: https://xuanyuan.cloud/zh/r/linuxserver/minetest
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/minetest" title="linuxserver/minetest Docker 镜像中文简介、标签列表与拉取命令">linuxserver/minetest 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# [linuxserver/minetest](https://github.com/linuxserver/docker-minetest)

## 弃用通知
该镜像已弃用。我们将不再为该镜像提供支持，也不会对其进行更新。请迁移至 [https://github.com/linuxserver/docker-luanti](https://github.com/linuxserver/docker-luanti)

## 镜像概述

[LinuxServer.io](https://linuxserver.io) 团队为您带来这款容器，具有以下特点：
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 带有s6覆盖层的自定义基础镜像
- 每周基础操作系统更新，在整个LinuxServer.io生态系统中共享通用层，以最小化空间占用、停机时间和带宽
- 定期安全更新

[Minetest](http://www.minetest.net/)（服务器）是一款近乎无限世界的方块沙盒游戏和游戏引擎，灵感来源于InfiniMiner、Minecraft等作品。

## 支持的架构

我们利用docker manifest实现多平台支持。只需拉取 `lscr.io/linuxserver/minetest:latest` 即可获取适合您架构的正确镜像，也可通过标签拉取特定架构的镜像。

该镜像支持的架构如下：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |
| armhf | ❌ | |

## 应用设置

世界地图、mods文件夹和配置文件位于 `/config/.minetest`。

如果需要覆盖公告端口，确保在CLI_ARGS中添加 `--port` 并确保内部端口反映更改，例如：若使用 `--port 40000` 将公告端口设置为40000，则端口声明应为 `40000:40000/udp`。

客户端和服务器必须使用相同版本，请通过以下链接浏览标签以拉取适合您服务器的版本：[https://hub.docker.com/r/linuxserver/minetest/tags](https://hub.docker.com/r/linuxserver/minetest/tags)

### 捆绑游戏

根据[上游要求](https://github.com/minetest/minetest/releases/tag/5.8.0)，此镜像不再包含[minetest_game](https://github.com/minetest/minetest_game)，如需使用，您需要通过ContentDB安装或从其仓库下载并复制到 `/config/.minetest/games/minetest`。

## 使用方法

以下提供docker-compose和docker cli两种方式帮助您创建容器。

>[!NOTE]
>除非参数标记为“可选”，否则均为必填项，必须提供值。

### docker-compose（推荐，[点击查看更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
services:
  minetest:
    image: docker.xuanyuan.run/linuxserver/minetest:latest
    container_name: minetest
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - "CLI_ARGS=--gameid devtest" #可选
    volumes:
      - /path/to/minetest/data:/config/.minetest
    ports:
      - 30000:30000/udp
    restart: unless-stopped
```

### docker cli ([点击查看更多信息](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=minetest \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e CLI_ARGS="--gameid devtest" `#可选` \
  -p 30000:30000/udp \
  -v /path/to/minetest/data:/config/.minetest \
  --restart unless-stopped \
  lscr.io/linuxserver/minetest:latest
```

## 参数

容器通过运行时传递的参数进行配置，格式为 `<外部>:<内部>`。例如，`-p 8080:80` 表示将容器内的80端口映射到主机的8080端口。

| 参数 | 功能 |
| :----: | --- |
| `-p 30000:30000/udp` | Minetest监听的端口（UDP）。 |
| `-e PUID=1000` | 用户ID - 详见下文说明 |
| `-e PGID=1000` | 组ID - 详见下文说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见[列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)。 |
| `-e CLI_ARGS=--gameid devtest` | 可选，指定任何[CLI变量](https://wiki.minetest.net/Command_line) |
| `-v /config/.minetest` | Minetest存储配置文件和地图等数据的位置。 |

## 环境变量从文件（Docker secrets）

您可以通过特殊前缀 `FILE__` 从文件设置任何环境变量。

例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据 `/run/secrets/mysecretvariable` 文件的内容设置环境变量 `MYVAR`。

## 应用运行的Umask

我们的所有镜像都支持使用可选的 `-e UMASK=022` 设置来覆盖容器内服务的默认umask。请注意，umask不是chmod，它基于其值减去权限而非添加。请在寻求支持前阅读[此处](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v` 标志）时，主机OS和容器之间可能出现权限问题。我们通过允许您指定用户 `PUID` 和组 `PGID` 来避免此问题。

确保主机上的任何卷目录都归您指定的用户所有，权限问题将迎刃而解。

此处 `PUID=1000` 和 `PGID=1000`，可通过 `id your_user` 命令查找您的ID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=minetest&query=%24.mods%5B%27minetest%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=minetest "查看此容器可用的mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可应用于任何镜像的通用mods")

我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)以启用容器内的附加功能。上述动态徽章可访问此镜像可用的mods列表以及可应用于任何LinuxServer.io镜像的通用mods。

## 支持信息

* 容器运行时的Shell访问：

    ```bash
    docker exec -it minetest /bin/bash
    ```

* 实时监控容器日志：

    ```bash
    docker logs -f minetest
    ```

* 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' minetest
    ```

* 镜像版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/minetest:latest
    ```

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器以更新内部应用。除相关readme.md中注明的例外情况，我们不建议或支持在容器内更新应用。请参考上述[应用设置](#应用设置)部分，了解是否推荐对此镜像进行应用更新。

以下是更新容器的说明：

### 通过Docker Compose

* 更新镜像：
    * 所有镜像：

        ```bash
        docker-compose pull
        ```

    * 单个镜像：

        ```bash
        docker-compose pull minetest
        ```

* 更新容器：
    * 所有容器：

        ```bash
        docker-compose up -d
        ```

    * 单个容器：

        ```bash
        docker-compose up -d minetest
        ```

* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过Docker Run

* 更新镜像：

    ```bash
    docker pull docker.xuanyuan.run/linuxserver/minetest:latest
    ```

* 停止运行中的容器：

    ```bash
    docker stop minetest
    ```

* 删除容器：

    ```bash
    docker rm minetest
    ```

* 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）
* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun（Docker镜像更新通知器）

>[!TIP]
>我们推荐[Diun](https://crazymax.dev/diun/)用于更新通知。不推荐或支持其他自动无人值守更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-minetest.git
cd docker-minetest
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/minetest:latest .
```

可以使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，您可以使用`-f Dockerfile.aarch64`指定要使用的dockerfile。

## 版本历史

* **30.01.25:** - 因项目重命名为[luanti](https://github.com/linuxserver/docker-luanti)而弃用。
* **25.11.24:** - 添加Prometheus指标支持。
* **01.06.24:** - 基于Alpine 3.20重建。
* **12.05.24:** - 取消固定irrlicht，在默认配置中启用IPv6支持。
* **10.05.24:** - 启用PostgreSQL后端并修复libspatialindex分支名称。
* **26.01.24:** - 暂时固定irrlicht以继续构建，等待错误修复版本。
* **23.12.23:** - 基于Alpine 3.19重建。
* **12.07.23:** - 基于Alpine 3.18重建，移除minetest_game。
* **06.07.23:** - 弃用armhf。如[此处](https://www.linuxserver.io/blog/a-farewell-to-arm-hf)所宣布。
* **09.04.23:** - 构建逻辑更改，将devtest复制到默认游戏。
* **17.03.23:** - 修复readme中的CLI_ARGS示例。
* **23.02.23:** - 基于Alpine 3.17重建，迁移到s6v3。
* **06.08.22:** - 更新irrlicht依赖。
* **02.05.22:** - 允许指定公告端口。
* **17.03.22:** - 安装分叉的irrlicht，添加zstd。
* **19.01.22:** - 基于Alpine 3.15重建。
* **02.06.20:** - 基于Alpine 3.12重建。
* **19.12.19:** - 基于Alpine 3.11重建。
* **12.07.19:** - 修复支持多个CLI变量的错误。
* **28.06.19:** - 基于Alpine 3.10重建。
* **03.06.19:** - 添加自定义cli变量到选项。
* **23.03.19:** - 切换到新的基础镜像，迁移到arm32v7标签。
* **04.03.19:** - 基于Alpine 3.9重建，使用新构建参数编译5.0.0版minetest。
* **14.01.19:** - 添加流水线逻辑和多架构支持。
* **08.08.18:** - 基于Alpine 3.8重建，从最新发布标签而非master构建。
* **03.01.18:** - 弃用cpu_core例程，因缺乏扩展性。
* **08.12.17:** - 基于Alpine 3.7重建。
* **30.11.17:** - 使用cpu核心计数例程加快构建时间。
* **26.05.17:** - 基于Alpine 3.6重建。
* **14.02.17:** - 基于Alpine 3.5重建。
* **25.11.16:** - 基于Alpine Linux重建，移至主仓库。
* **27.02.16:** - 升级到最新版本。
* **19.02.16:** - 将端口更改为UDP，感谢slashopt指出。
* **15.02.16:** - 将minetest应用设为服务。
* **01.02.16:** - 添加lua-socket依赖。
* **06.11.15:** - 初始发布。
