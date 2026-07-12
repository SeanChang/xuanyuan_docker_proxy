---
image: linuxserver/faster-whisper
description: "LinuxServer.io提供的Faster Whisper语音识别模型Docker镜像，用于高效部署和运行语音转文本服务。"
source: https://xuanyuan.cloud/zh/r/linuxserver/faster-whisper
canonical: https://xuanyuan.cloud/zh/r/linuxserver/faster-whisper
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/faster-whisper" title="linuxserver/faster-whisper Docker 镜像中文简介、标签列表与拉取命令">linuxserver/faster-whisper 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/faster-whisper 镜像文档

## 镜像概述和主要用途

[linuxserver/faster-whisper](https://github.com/linuxserver/docker-faster-whisper) 是基于 [Faster-whisper](https://github.com/SYSTRAN/faster-whisper) 的Docker镜像。Faster-whisper是OpenAI Whisper模型的重新实现，使用CTranslate2作为Transformer模型的快速推理引擎。本容器提供了一个基于Wyoming协议的faster-whisper服务器，主要用于语音转文本(STT)任务。

LinuxServer.io团队提供的该容器具有以下特点：
- 定期及时的应用更新
- 简单的用户映射(PGID, PUID)
- 带有s6覆盖层的自定义基础镜像
- 每周基础操作系统更新，在整个LinuxServer.io生态系统中共享通用层，以最小化空间使用、停机时间和带宽
- 定期安全更新

## 核心功能和特性

- 高性能语音识别：基于CTranslate2优化的Whisper模型，提供比原始Whisper更快的推理速度
- Wyoming协议支持：可与Home Assistant等支持Wyoming协议的语音助手集成
- 多架构支持：x86-64和arm64架构
- GPU加速：提供支持Nvidia GPU的镜像版本
- 灵活的模型选择：支持多种Whisper模型和-int8压缩变体
- 可配置的转录参数：支持设置语言、beam数量等参数
- 本地模型支持：可使用本地提供的模型，无需从HuggingFace下载

## 支持的架构

该镜像利用docker manifest实现多平台支持。只需拉取 `lscr.io/linuxserver/faster-whisper:latest` 即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 版本标签

| 标签 | 可用 | 描述 |
| :----: | :----: |--- |
| latest | ✅ | 稳定版本 |
| gpu | ✅ | 带Nvidia GPU支持的版本 (仅amd64) |
| gpu-legacy | ✅ | 为Turing之前的显卡提供Nvidia GPU支持的旧版本 (仅amd64) |

## 使用场景和适用范围

- Home Assistant语音助手集成：作为本地语音转文本服务
- 语音内容转录：将音频文件或实时音频转录为文本
- 语音命令识别：用于构建本地语音控制应用
- 多语言语音识别：支持多种语言的语音识别需求
- 资源受限环境：通过-int8模型变体在低资源设备上运行

## 应用设置

### Home Assistant集成
要与Home Assistant [Assist](https://www.home-assistant.io/voice_control/voice_remote_local_assistant/) 一起使用，添加Wyoming集成并提供Whisper运行的主机名/IP和端口。

### GPU支持设置
使用带有Nvidia GPU的`gpu`标签时，确保将容器设置为使用`nvidia`运行时，并且在主机上安装了[Nvidia Container Toolkit](https://github.com/NVIDIA/nvidia-container-toolkit)，并使用正确的GPU暴露设置运行容器。有关更多详细信息，请参阅[Nvidia Container Toolkit文档](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/sample-workload.html)。

### 只读操作
此镜像可以在只读容器文件系统下运行。有关详细信息，请[阅读文档](https://docs.linuxserver.io/misc/read-only/)。

## 详细的使用方法和配置说明

### Docker Compose (推荐)

```yaml
---
services:
  faster-whisper:
    image: docker.xuanyuan.run/linuxserver/faster-whisper:latest
    container_name: faster-whisper
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - WHISPER_MODEL=tiny-int8
      - LOCAL_ONLY= #可选
      - WHISPER_BEAM=1 #可选
      - WHISPER_LANG=en #可选
    volumes:
      - /path/to/faster-whisper/data:/config
    ports:
      - 10300:10300
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=faster-whisper \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e WHISPER_MODEL=tiny-int8 \
  -e LOCAL_ONLY= `#可选` \
  -e WHISPER_BEAM=1 `#可选` \
  -e WHISPER_LANG=en `#可选` \
  -p 10300:10300 \
  -v /path/to/faster-whisper/data:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/faster-whisper:latest
```

### GPU支持的Docker Run示例

```bash
docker run -d \
  --name=faster-whisper \
  --runtime=nvidia \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e WHISPER_MODEL=base-int8 \
  -p 10300:10300 \
  -v /path/to/faster-whisper/data:/config \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/faster-whisper:gpu
```

## 参数说明

容器通过运行时传递的参数进行配置。这些参数用冒号分隔，表示`<外部>:<内部>`。例如，`-p 8080:80`会将容器内的80端口暴露到主机的8080端口。

### 网络参数

| 参数 | 功能 |
| :----: | --- |
| `-p 10300:10300` | Wyoming协议连接端口 |

### 环境变量

| 参数 | 功能 |
| :----: | --- |
| `-e PUID=1000` | 用户ID - 详见下方说明 |
| `-e PGID=1000` | 组ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e WHISPER_MODEL=tiny-int8` | 用于转录的Whisper模型。来自[这里](https://github.com/SYSTRAN/faster-whisper/blob/master/faster_whisper/utils.py#L12-L31)，所有模型都有-int8压缩变体 |
| `-e LOCAL_ONLY=` | 如果设置为`true`或任何其他值，容器将不会尝试从HuggingFace下载模型，只使用本地提供的模型 |
| `-e WHISPER_BEAM=1` | 转录期间同时考虑的候选数 |
| `-e WHISPER_LANG=en` | 语音输入的语言 |
| `-e UMASK=022` | 覆盖容器内服务的默认umask设置 |

### 卷参数

| 参数 | 功能 |
| :----: | --- |
| `-v /config` | Whisper配置文件和模型的本地路径 |

### 其他参数

| 参数 | 功能 |
| :----: | --- |
| `--read-only=true` | 以只读文件系统运行容器。请[阅读文档](https://docs.linuxserver.io/misc/read-only/) |
| `--runtime=nvidia` | 使用Nvidia运行时(仅GPU版本需要) |
| `-e NVIDIA_VISIBLE_DEVICES=all` | 暴露所有GPU(仅GPU版本需要) |

## 环境变量从文件读取 (Docker secrets)

可以通过使用特殊的前缀`FILE__`从文件设置任何环境变量。

例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据`/run/secrets/mysecretvariable`文件的内容设置环境变量`MYVAR`。

## 用户/组标识符

使用卷(`-v`标志)时，主机操作系统和容器之间可能会出现权限问题。通过指定用户`PUID`和组`PGID`，可以避免此问题。

确保主机上的任何卷目录都由您指定的相同用户拥有，权限问题就会迎刃而解。

在此示例中`PUID=1000`和`PGID=1000`，可以使用`id your_user`命令查找您的用户ID和组ID：

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

- 容器运行时的Shell访问：

    ```bash
    docker exec -it faster-whisper /bin/bash
    ```

- 实时监控容器日志：

    ```bash
    docker logs -f faster-whisper
    ```

- 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' faster-whisper
    ```

- 镜像版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/faster-whisper:latest
    ```

## 更新信息

大多数镜像都是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部的应用程序。除了某些例外情况(在相关的readme.md中注明)，我们不建议或支持在容器内更新应用程序。请查阅上方的[应用设置](#应用设置)部分，了解是否推荐对镜像进行更新。

### 使用Docker Compose更新

- 更新镜像：
  - 所有镜像：

    ```bash
    docker-compose pull
    ```

  - 单个镜像：

    ```bash
    docker-compose pull faster-whisper
    ```

- 更新容器：
  - 所有容器：

    ```bash
    docker-compose up -d
    ```

  - 单个容器：

    ```bash
    docker-compose up -d faster-whisper
    ```

- 也可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 使用Docker Run更新

- 更新镜像：

    ```bash
    docker pull docker.xuanyuan.run/linuxserver/faster-whisper:latest
    ```

- 停止运行中的容器：

    ```bash
    docker stop faster-whisper
    ```

- 删除容器：

    ```bash
    docker rm faster-whisper
    ```

- 使用上述相同的docker run参数重新创建新容器(如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留)

- 也可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun (Docker Image Update Notifier)

> [!TIP]
> 我们推荐使用[Diun](https://crazymax.dev/diun/)进行更新通知。不推荐或支持其他自动更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-faster-whisper.git
cd docker-faster-whisper
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/faster-whisper:latest .
```

可以使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，可以使用`-f Dockerfile.aarch64`指定要使用的dockerfile。

## 版本历史

- **20.08.25:** - 添加gpu-legacy分支，支持Turing之前的显卡
- **10.08.25:** - 添加本地模式支持
- **30.12.24:** - 为非GPU构建添加arm64支持
- **05.12.24:** - 从Github发布版构建，而非Pypi
- **18.07.24:** - 基于Ubuntu Noble重建
- **19.05.24:** - 在GPU分支上将CUDA升级到12
- **08.01.24:** - 添加GPU分支
- **25.11.23:** - 初始发布
