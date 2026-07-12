---
image: linuxserver/piper
description: "LinuxServer提供的Piper镜像，封装轻量级文本转语音（TTS）引擎，用于容器化部署文本转语音服务。"
source: https://xuanyuan.cloud/zh/r/linuxserver/piper
canonical: https://xuanyuan.cloud/zh/r/linuxserver/piper
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/piper" title="linuxserver/piper Docker 镜像中文简介、标签列表与拉取命令">linuxserver/piper 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/piper 镜像文档

## 镜像概述和主要用途

[Piper](https://github.com/rhasspy/piper/) 是一个快速、本地神经文本转语音系统，音质出色且针对Raspberry Pi 4进行了优化。本容器提供了Piper的Wyoming协议服务器。

LinuxServer.io团队提供的此容器具有以下特点：
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 带有s6覆盖层的自定义基础镜像
- 每周基础操作系统更新，在整个LinuxServer.io生态系统中共享通用层，以最小化空间占用、停机时间和带宽
- 定期安全更新

## 核心功能和特性

- 高性能本地文本转语音转换
- 支持Wyoming协议，可与Home Assistant等系统集成
- 可自定义语音、语速、噪音等参数
- 支持多扬声器语音模型
- 可选的音频流支持
- 多架构支持（x86-64、arm64）
- 可配置的并发处理进程数
- 支持只读容器文件系统运行

## 使用场景和适用范围

- Home Assistant语音助手（Assist）的本地TTS引擎
- 智能家居系统语音通知
- 需要本地文本转语音功能的应用集成
- 低延迟语音合成需求场景
- 对隐私敏感，需要本地处理语音合成的环境

## 支持的架构

该镜像支持以下架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

只需拉取 `lscr.io/linuxserver/piper:latest` 即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

## 应用设置

要与Home Assistant [Assist](https://www.home-assistant.io/voice_control/voice_remote_local_assistant/) 配合使用，添加Wyoming集成并提供piper运行的主机名/IP和端口。

有关更多信息，请参阅 [piper文档](https://github.com/rhasspy/piper/)。

## 只读操作

此镜像可以在只读容器文件系统下运行。有关详细信息，请 [阅读文档](https://docs.linuxserver.io/misc/read-only/)。

## 使用方法和配置说明

### docker-compose (推荐)

```yaml
---
services:
  piper:
    image: docker.xuanyuan.run/linuxserver/piper:latest
    container_name: piper
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - PIPER_VOICE=en_US-lessac-medium
      - LOCAL_ONLY= #可选
      - PIPER_LENGTH=1.0 #可选
      - PIPER_NOISE=0.667 #可选
      - PIPER_NOISEW=0.333 #可选
      - PIPER_SPEAKER=0 #可选
      - PIPER_PROCS=1 #可选
      - STREAMING= #可选
    volumes:
      - /path/to/piper/data:/config
    ports:
      - 10200:10200
    restart: unless-stopped
```

### docker cli

```bash
docker run -d \
  --name=piper \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e PIPER_VOICE=en_US-lessac-medium \
  -e LOCAL_ONLY= `#可选` \
  -e PIPER_LENGTH=1.0 `#可选` \
  -e PIPER_NOISE=0.667 `#可选` \
  -e PIPER_NOISEW=0.333 `#可选` \
  -e PIPER_SPEAKER=0 `#可选` \
  -e PIPER_PROCS=1 `#可选` \
  -e STREAMING= `#可选` \
  -p 10200:10200 \
  -v /path/to/piper/data:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/piper:latest
```

## 参数说明

| 参数 | 功能 |
| :----: | --- |
| `-p 10200:10200` | Wyoming连接端口 |
| `-e PUID=1000` | 用户ID - 详见下文说明 |
| `-e PGID=1000` | 组ID - 详见下文说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e PIPER_VOICE=en_US-lessac-medium` | 使用的[Piper语音](https://huggingface.co/rhasspy/piper-voices/tree/main)，格式为`<语言>-<名称>-<质量>` |
| `-e LOCAL_ONLY=` | 如果设置为`true`或任何值，容器将不会尝试从HuggingFace下载模型，仅使用本地提供的模型 |
| `-e PIPER_LENGTH=1.0` | 语音语速，1.0为默认值，<1.0更快，>1.0更慢 |
| `-e PIPER_NOISE=0.667` | 通过添加噪音控制语音的可变性，值超过1会开始降低音频质量 |
| `-e PIPER_NOISEW=0.333` | 控制说话节奏的可变性，值超过1会产生极端的口吃和停顿 |
| `-e PIPER_SPEAKER=0` | 如果语音支持多个扬声器，使用的扬声器编号 |
| `-e PIPER_PROCS=1` | 同时运行的Piper进程数 |
| `-e STREAMING=` | 设置为`true`或任何值将启用句子边界的音频流支持 |
| `-v /config` | Piper配置文件的本地路径 |
| `--read-only=true` | 以只读文件系统运行容器，请[阅读文档](https://docs.linuxserver.io/misc/read-only/) |

## 环境变量与文件（Docker secrets）

您可以通过使用特殊前缀`FILE__`从文件设置任何环境变量。

例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

将根据`/run/secrets/mysecretvariable`文件的内容设置环境变量`MYVAR`。

## 应用运行的Umask设置

对于我们所有的镜像，您可以使用可选的`-e UMASK=022`设置来覆盖容器内启动的服务的默认umask设置。

请记住，umask不是chmod，它根据其值减去权限而不是添加权限。在请求支持之前，请先[了解umask](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v`标志）时，主机操作系统和容器之间可能会出现权限问题。我们通过允许您指定用户`PUID`和组`PGID`来避免此问题。

确保主机上的任何卷目录都归您指定的同一用户所有，任何权限问题都会像魔术一样消失。

在这个例子中`PUID=1000`和`PGID=1000`，要找到您的PUID和PGID，请使用`id your_user`命令：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=piper&query=%24.mods%5B%27piper%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=piper "查看此容器可用的mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用mods")

我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)，以在容器内启用额外功能。可通过上方的动态徽章访问此镜像可用的Mods列表（如有）以及可应用于我们任何镜像的通用Mods。

## 支持信息

- 容器运行时的Shell访问：

    ```bash
    docker exec -it piper /bin/bash
    ```

- 实时监控容器日志：

    ```bash
    docker logs -f piper
    ```

- 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' piper
    ```

- 镜像版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/piper:latest
    ```

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像和重新创建容器来更新内部的应用程序。除了一些例外情况（在相关的readme.md中注明），我们不建议或支持在容器内更新应用程序。请查阅上面的[应用设置](#应用设置)部分，了解是否推荐对该镜像执行此操作。

以下是更新容器的说明：

### 通过Docker Compose

- 更新镜像：
  - 所有镜像：

    ```bash
    docker-compose pull
    ```

  - 单个镜像：

    ```bash
    docker-compose pull piper
    ```

- 更新容器：
  - 所有容器：

    ```bash
    docker-compose up -d
    ```

  - 单个容器：

    ```bash
    docker-compose up -d piper
    ```

- 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过Docker Run

- 更新镜像：

    ```bash
    docker pull docker.xuanyuan.run/linuxserver/piper:latest
    ```

- 停止运行中的容器：

    ```bash
    docker stop piper
    ```

- 删除容器：

    ```bash
    docker rm piper
    ```

- 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）
- 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun (Docker Image Update Notifier)

> [!TIP]
> 我们推荐使用[Diun](https://crazymax.dev/diun/)进行更新通知。不推荐或支持其他自动无人值守更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-piper.git
cd docker-piper
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/piper:latest .
```

可以使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，您可以使用`-f Dockerfile.aarch64`定义要使用的dockerfile。

## 版本历史

- **29.08.25:** - 添加对本地仅模式的支持
- **10.08.25:** - 添加流支持
- **18.07.24:** - 重新基于Ubuntu Noble构建
- **25.11.23:** - 初始发布

## 支持与社区

- [Blog](https://blog.linuxserver.io) - 关于如何使用我们的容器的所有内容，包括操作指南、观点等
- [Discord](https://linuxserver.io/discord) - 实时支持/与社区和团队聊天
- [Discourse](https://discourse.linuxserver.io) - 在我们的社区论坛上发帖
- [GitHub](https://github.com/linuxserver) - 查看我们所有仓库的源代码
- [Open Collective](https://opencollective.com/linuxserver) - 请考虑通过捐赠或为我们的预算做出贡献来帮助我们
