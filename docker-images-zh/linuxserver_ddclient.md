---
image: linuxserver/ddclient
description: "LinuxServer.io提供的ddclient容器，是一款动态DNS客户端工具，用于自动更新域名解析记录。"
source: https://xuanyuan.cloud/zh/r/linuxserver/ddclient
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[linuxserver/ddclient](https://xuanyuan.cloud/zh/r/linuxserver/ddclient)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/ddclient

## 镜像概述和主要用途

[Ddclient](https://github.com/ddclient/ddclient) 是一个Perl客户端，用于为动态DNS网络服务提供商的账户更新动态DNS条目。它最初由Paul Burry编写，现在主要由wimpunk维护。它不仅能够更新dyndns，还能通过多种方式获取WAN IP地址。

LinuxServer.io团队提供的该容器具有以下特点：
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 带有s6覆盖层的自定义基础镜像
- 每周基础操作系统更新，在整个LinuxServer.io生态系统中共享公共层，以最小化空间使用、停机时间和带宽
- 定期安全更新

![ddclient](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/ddclient-logo.png)

## 核心功能和特性

- 支持多种动态DNS服务提供商
- 多种WAN IP地址检测方式
- 配置文件自动重载
- 支持从Fritz.Box获取动态IP
- 可在只读文件系统中运行
- 支持非root用户运行
- 多架构支持

## 支持的架构

该镜像利用docker manifest实现多平台支持。只需拉取 `lscr.io/linuxserver/ddclient:latest` 即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

支持的架构:

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 使用场景和适用范围

适用于需要动态更新DNS记录的场景，包括：
- 家庭网络服务器，拥有动态公网IP
- 需要从互联网访问的家庭自动化系统
- 远程访问家庭设备
- 任何需要保持域名与动态IP关联的应用

## 应用设置

编辑 `/config` 卷中的 `ddclient.conf` 文件（另请参见官方[ddclient文档](https://ddclient.net)）。此配置文件包含许多提供商选项，您只需取消注释您的提供商并在要求的位置添加用户名/密码即可。修改ddclient.conf后，ddclient将自动重启并读取配置。

### 从Fritz.Box获取动态IP

如果ddclient需要从Fritz.Box (AVM) 获取动态（公共）IP地址，请将以下行添加到 `/config/ddclient.conf`：
```
use=cmd, cmd=/etc/ddclient/get-ip-from-fritzbox
```

## 只读操作

此镜像可以在只读容器文件系统中运行。有关详细信息，请[阅读文档](https://docs.linuxserver.io/misc/read-only/)。

### 注意事项

运行此镜像时，`/tmp` 也必须挂载为tmpfs。

## 非Root操作

此镜像可以使用非root用户运行。有关详细信息，请[阅读文档](https://docs.linuxserver.io/misc/non-root/)。

## 使用方法和配置说明

以下是帮助您从此镜像创建容器的方法，您可以使用docker-compose或docker命令行。

> [!NOTE]
> 除非参数被标记为"可选"，否则它是*必填*项，必须提供值。

### docker-compose (推荐)

```yaml
---
services:
  ddclient:
    image: lscr.io/linuxserver/ddclient:latest
    container_name: ddclient
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/ddclient/config:/config
    restart: unless-stopped
```

### docker cli

```bash
docker run -d \
  --name=ddclient \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -v /path/to/ddclient/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/ddclient:latest
```

## 参数说明

容器使用运行时传递的参数进行配置（如上所示）。这些参数用冒号分隔，表示 `<外部>:<内部>`。例如，`-p 8080:80` 会将容器内的端口80暴露到主机IP的8080端口。

| 参数 | 功能 |
| :----: | --- |
| `-e PUID=1000` | 用户ID - 详见下文说明 |
| `-e PGID=1000` | 组ID - 详见下文说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)。 |
| `-v /config` | 持久化配置文件 |
| `--read-only=true` | 以只读文件系统运行容器。请[阅读文档](https://docs.linuxserver.io/misc/read-only/)。 |
| `--user=1000:1000` | 以非root用户运行容器。请[阅读文档](https://docs.linuxserver.io/misc/non-root/)。 |

## 环境变量从文件读取（Docker secrets）

您可以使用特殊的前缀 `FILE__` 从文件中设置任何环境变量。

例如：
```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据 `/run/secrets/mysecretvariable` 文件的内容设置环境变量 `MYVAR`。

## 运行应用的Umask

对于我们所有的镜像，我们提供了使用可选的 `-e UMASK=022` 设置来覆盖容器内启动的服务的默认umask设置。请记住，umask不是chmod，它基于其值减去权限，而不是添加权限。在请求支持之前，请先[了解umask](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v` 标志）时，主机操作系统和容器之间可能会出现权限问题。我们通过允许您指定用户 `PUID` 和组 `PGID` 来避免此问题。

确保主机上的任何卷目录都归您指定的相同用户所有，这样任何权限问题都会像魔术一样消失。

在这个例子中 `PUID=1000` 和 `PGID=1000`，要找到您的PUID和PGID，请使用 `id your_user` 命令：

```bash
id your_user
```

示例输出：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=ddclient&query=%24.mods%5B%27ddclient%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=ddclient "查看此容器可用的mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用mods")

我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)，以启用容器内的附加功能。可用于此镜像的Mods列表（如果有）以及可应用于我们任何镜像的通用Mods可以通过上面的动态徽章访问。

## 支持信息

* 容器运行时的Shell访问：

    ```bash
    docker exec -it ddclient /bin/bash
    ```

* 实时监控容器日志：

    ```bash
    docker logs -f ddclient
    ```

* 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' ddclient
    ```

* 镜像版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/ddclient:latest
    ```

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器来更新内部的应用程序。除了某些例外情况（在相关的readme.md中注明），我们不建议或支持在容器内更新应用程序。请查阅上面的[应用设置](#应用设置)部分，了解是否推荐对该镜像进行应用更新。

以下是更新容器的说明：

### 通过Docker Compose

* 更新镜像：
    * 所有镜像：

        ```bash
        docker-compose pull
        ```

    * 单个镜像：

        ```bash
        docker-compose pull ddclient
        ```

* 更新容器：
    * 所有容器：

        ```bash
        docker-compose up -d
        ```

    * 单个容器：

        ```bash
        docker-compose up -d ddclient
        ```

* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过Docker Run

* 更新镜像：

    ```bash
    docker pull lscr.io/linuxserver/ddclient:latest
    ```

* 停止运行中的容器：

    ```bash
    docker stop ddclient
    ```

* 删除容器：

    ```bash
    docker rm ddclient
    ```

* 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）
* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun（Docker镜像更新通知器）

> [!TIP]
> 我们推荐使用[Diun](https://crazymax.dev/diun/)进行更新通知。不推荐或支持其他自动无人值守更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-ddclient.git
cd docker-ddclient
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/ddclient:latest .
```

可以使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```

注册后，您可以使用`-f Dockerfile.aarch64`指定要使用的dockerfile。

## 版本历史

* **10.07.25:** - 重新基于Alpine 3.22构建。
* **08.07.24:** - 修复缓存问题。
* **08.07.24:** - 不再在运行时将配置从`/config/ddclient.conf`复制到`/ddclient.conf`。
* **27.06.24:** - 重新基于Alpine 3.20构建。
* **23.12.23:** - 重新基于Alpine 3.19构建。
* **25.08.23:** - 重新基于Alpine 3.18构建。
* **04.07.23:** - 弃用armhf架构。如[此处](https://www.linuxserver.io/blog/a-farewell-to-arm-hf)所宣布。
* **13.02.23:** - 重新基于Alpine 3.17构建，迁移到s6v3。
* **20.10.22:** - 更新3.10.0的构建说明。更新默认`ddclient.conf`。
* **15.01.22:** - 重新基于Alpine 3.15构建。
* **15.05.21:** - 从ddclient仓库分发脚本'sample-get-ip-from-fritzbox'。
* **08.03.21:** - 添加bind-tools以提供nsupdate。
* **01.06.20:** - 重新基于Alpine 3.12构建。
* **08.02.20:** - 从Github获取代码。
* **06.02.19:** - 修复权限。
* **19.12.19:** - 重新基于Alpine 3.11构建。
* **28.06.19:** - 重新基于Alpine 3.10构建。
* **23.03.19:** - 切换到新的基础镜像，迁移到arm32v7标签。
* **10.03.19:** - 添加perl-io-socket-inet6以支持ipv6。
* **22.02.19:** - 重新基于Alpine 3.9构建。
* **11.02.19:** - 添加流水线逻辑和多架构支持。
* **22.08.18:** - 重新基于Alpine 3.8构建。
* **10.08.18:** - 更新到ddclient v3.9.0。对于Cloudflare用户，请确保从`ddclient.conf`中删除`server=www.cloudflare.com`行。
* **07.12.17:** - 重新基于Alpine 3.7构建。
* **28.05.17:** - 重新基于Alpine 3.6构建。
* **10.02.17:** - 重新基于Alpine 3.5构建。
* **26.11.16:** - 更新README为新标准，并添加图标和其他小细节。
* **29.08.16:** - 初始发布。
