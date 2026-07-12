---
image: linuxserver/lidarr
description: "LinuxServer提供的Lidarr Docker镜像，用于自动化管理音乐收藏，支持艺术家和专辑跟踪、音乐搜索下载及元数据整理。"
source: https://xuanyuan.cloud/zh/r/linuxserver/lidarr
canonical: https://xuanyuan.cloud/zh/r/linuxserver/lidarr
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/lidarr" title="linuxserver/lidarr Docker 镜像中文简介、标签列表与拉取命令">linuxserver/lidarr 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/lidarr

## 镜像概述和主要用途

[Lidarr](https://github.com/lidarr/Lidarr) 是一款面向Usenet和BitTorrent用户的音乐收藏管理器。它可以监控多个RSS源以获取您喜爱艺术家的新曲目，并会抓取、分类和重命名这些文件。还可以配置为当有更高质量的格式可用时，自动升级已下载文件的质量。

LinuxServer.io团队提供的此容器具有以下特点：
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 带有s6覆盖层的自定义基础镜像
- 每周基础操作系统更新，在整个LinuxServer.io生态系统中共享通用层，以最小化空间使用、停机时间和带宽
- 定期安全更新

![lidarr](https://github.com/lidarr/Lidarr/raw/develop/Logo/400.png)

## 核心功能和特性

- 监控多个RSS源以获取新音乐
- 自动抓取、分类和重命名音乐文件
- 支持质量升级，当更高质量版本可用时自动替换
- 多平台支持
- 简单的用户权限映射
- 可配置的存储路径
- 支持只读文件系统运行
- 支持非root用户运行

## 使用场景和适用范围

Lidarr适用于以下场景：
- 音乐爱好者希望自动化管理和维护个人音乐收藏
- 需要从Usenet或BitTorrent自动下载音乐的用户
- 希望保持音乐文件组织有序和高质量的用户
- 构建家庭媒体服务器的一部分
- 需要在多平台环境中部署音乐管理解决方案

## 详细的使用方法和配置说明

### 支持的架构

该镜像利用docker manifest实现多平台支持。只需拉取`lscr.io/linuxserver/lidarr:latest`即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

### 版本标签

此镜像提供多种版本，可通过标签获取。使用不稳定或开发标签时请谨慎。

| 标签 | 可用 | 描述 |
| :----: | :----: |--- |
| latest | ✅ | Lidarr稳定版发布。 |
| develop | ✅ | Lidarr开发版发布。 |
| nightly | ✅ | Lidarr夜间版发布。 |

### 应用设置

通过`<your-ip>:8686`访问Web界面，更多信息请查看[Lidarr](https://github.com/lidarr/Lidarr)。

#### 媒体文件夹

我们将`/music`和`/downloads`设置为可选路径，这是最容易上手的方式。虽然使用简单，但也有一些缺点，主要是失去了硬链接（一种让文件在同一文件系统的多个位置存在但只占用一个文件空间的方法）或原子移动（即时文件移动，而不是复制+删除）处理内容的能力。

如果您不了解或不需要硬链接/原子移动，请使用可选路径。

> [!TIP]
> servarr.com的工作人员撰写了一篇关于如何开始使用此功能的良好[文章](https://wiki.servarr.com/docker-guide#consistent-and-well-planned-paths)。

### 只读操作

此镜像可以在只读容器文件系统下运行。有关详细信息，请[阅读文档](https://docs.linuxserver.io/misc/read-only/)。

### 非Root操作

此镜像可以使用非root用户运行。有关详细信息，请[阅读文档](https://docs.linuxserver.io/misc/non-root/)。

### 部署方案示例

#### Docker Compose (推荐)

```yaml
---
services:
  lidarr:
    image: docker.xuanyuan.run/linuxserver/lidarr:latest
    container_name: lidarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/lidarr/config:/config
      - /path/to/music:/music #可选
      - /path/to/downloads:/downloads #可选
    ports:
      - 8686:8686
    restart: unless-stopped
```

#### Docker CLI

```bash
docker run -d \
  --name=lidarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 8686:8686 \
  -v /path/to/lidarr/config:/config \
  -v /path/to/music:/music `#可选` \
  -v /path/to/downloads:/downloads `#可选` \
  --restart unless-stopped \
  lscr.io/linuxserver/lidarr:latest
```

### 参数说明

容器通过运行时传递的参数进行配置。这些参数用冒号分隔，表示`<外部>:<内部>`。例如，`-p 8080:80`会将容器内的端口`80`暴露出来，可通过主机IP的`8080`端口访问。

| 参数 | 功能 |
| :----: | --- |
| `-p 8686:8686` | 应用Web界面端口 |
| `-e PUID=1000` | 用户ID - 详见下方说明 |
| `-e PGID=1000` | 组ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见此[列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)。 |
| `-v /config` | Lidarr的配置文件目录。 |
| `-v /music` | 音乐文件目录（参见应用设置中的说明）。 |
| `-v /downloads` | 音乐下载文件夹路径（参见应用设置中的说明）。 |
| `--read-only=true` | 以只读文件系统运行容器。请[阅读文档](https://docs.linuxserver.io/misc/read-only/)。 |
| `--user=1000:1000` | 以非root用户运行容器。请[阅读文档](https://docs.linuxserver.io/misc/non-root/)。 |

### 来自文件的环境变量（Docker secrets）

您可以通过使用特殊的前缀`FILE__`从文件中设置任何环境变量。

例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

将根据`/run/secrets/mysecretvariable`文件的内容设置环境变量`MYVAR`。

### 应用运行的Umask

对于我们所有的镜像，我们提供了使用可选的`-e UMASK=022`设置来覆盖容器内启动的服务的默认umask设置的能力。请记住，umask不是chmod，它基于其值减去权限，而不是添加。在请求支持之前，请先[阅读](https://en.wikipedia.org/wiki/Umask)相关内容。

### 用户/组标识符

使用卷（`-v`标志）时，主机操作系统和容器之间可能会出现权限问题，我们通过允许您指定用户`PUID`和组`PGID`来避免此问题。

确保主机上的任何卷目录都归您指定的同一用户所有，任何权限问题都将迎刃而解。

在这个例子中`PUID=1000`和`PGID=1000`，要找到您的PUID和PGID，请使用`id your_user`：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

### Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=lidarr&query=%24.mods%5B%27lidarr%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=lidarr "view available mods for this container.") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "view available universal mods.")

我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)，以在容器内启用额外功能。可用于此镜像的Mod列表（如果有）以及可应用于我们任何镜像的通用Mod可通过上方的动态徽章访问。

## 支持信息

* 容器运行时的Shell访问：

    ```bash
    docker exec -it lidarr /bin/bash
    ```

* 实时监控容器日志：

    ```bash
    docker logs -f lidarr
    ```

* 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lidarr
    ```

* 镜像版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/lidarr:latest
    ```

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部的应用程序。除了一些例外情况（在相关的readme.md中注明），我们不建议或支持在容器内更新应用程序。请查阅上方的[应用设置](#应用设置)部分，了解是否推荐对该镜像进行更新。

以下是更新容器的说明：

### 通过Docker Compose

* 更新镜像：
    * 所有镜像：

        ```bash
        docker-compose pull
        ```

    * 单个镜像：

        ```bash
        docker-compose pull lidarr
        ```

* 更新容器：
    * 所有容器：

        ```bash
        docker-compose up -d
        ```

    * 单个容器：

        ```bash
        docker-compose up -d lidarr
        ```

* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过Docker Run

* 更新镜像：

    ```bash
    docker pull docker.xuanyuan.run/linuxserver/lidarr:latest
    ```

* 停止运行中的容器：

    ```bash
    docker stop lidarr
    ```

* 删除容器：

    ```bash
    docker rm lidarr
    ```

* 使用上述指示的相同docker run参数重新创建新容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）
* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun（Docker镜像更新通知器）

> [!TIP]
> 我们推荐使用[Diun](https://crazymax.dev/diun/)进行更新通知。不推荐或支持其他自动无人值守更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或只是为了自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-lidarr.git
cd docker-lidarr
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/lidarr:latest .
```

可以使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体，反之亦然

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，您可以使用`-f Dockerfile.aarch64`定义要使用的dockerfile。

## 版本历史

* **05.07.25:** - 重新基于Alpine 3.22构建。
* **23.12.24:** - 重新基于Alpine 3.21构建。
* **31.05.24:** - 重新基于Alpine 3.20构建。
* **20.03.24:** - 重新基于Alpine 3.19构建。
* **06.06.23:** - 将主分支重新基于Alpine 3.18，弃用armhf，详见[https://www.linuxserver.io/armhf](https://www.linuxserver.io/armhf)。
* **17.01.23:** - 将主分支重新基于Alpine 3.17，迁移到s6v3。
* **06.06.22:** - 将主分支重新基于Alpine 3.15。
* **06.05.22:** - 将主分支重新基于Focal。
* **06.05.22:** - 将开发分支重新基于Alpine。
* **04.02.22:** - 将夜间分支重新基于Alpine，弃用nightly-alpine分支。
* **30.12.21:** - 添加nightly-alpine分支。
* **01.08.21:** - 添加libchromaprint-tools。
* **11.07.21:** - 为用户澄清路径。
* **18.04.21:** - 将`latest`标签切换到net core版本。
* **25.01.21:** - 发布`develop`标签。
* **20.01.21:** - 用baseimage中的UMASK替代UMASK_SET，详见上文。
* **18.04.20:** - 从Dockerfiles中移除/downloads和/music卷。
* **05.04.20:** - 将应用移至/app。
* **01.08.19:** - 重新基于Linuxserver LTS mono版本。
* **13.06.19:** - 添加用于设置umask的环境变量。
* **23.03.19:** - 切换到新的基础镜像，迁移到arm32v7标签。
* **08.03.19:** - 重新基于Bionic，使用libchromaprint的提议端点。
* **26.01.19:** - 添加流水线逻辑和多架构支持。
* **22.04.18:** - 切换到beta构建。
* **17.03.18:** - 在Dockerfile中添加ENV XDG_CONFIG_HOME="/config/xdg"以修复signalr问题。
* **27.02.18:** - 使用json查询新版本。
* **23.02.18:** - 初始发布。
