---
image: linuxserver/bazarr
description: "Bazarr Docker镜像，用于自动下载、管理媒体文件字幕，支持多语言，可与媒体服务器集成，简化字幕获取与维护流程。"
source: https://xuanyuan.cloud/zh/r/linuxserver/bazarr
canonical: https://xuanyuan.cloud/zh/r/linuxserver/bazarr
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/bazarr" title="linuxserver/bazarr Docker 镜像中文简介、标签列表与拉取命令">linuxserver/bazarr 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/bazarr

## 镜像概述和主要用途

[Bazarr](https://www.bazarr.media/) 是 Sonarr 和 Radarr 的配套应用程序，可根据用户需求管理和下载字幕。用户可以按电视剧或电影定义偏好设置，Bazarr 将自动处理所有字幕相关事宜。

LinuxServer.io 团队提供的此容器镜像具有以下特点：
- 定期及时的应用程序更新
- 简单的用户映射（PGID、PUID）
- 带有 s6 覆盖层的自定义基础镜像
- 每周基础操作系统更新，跨整个 LinuxServer.io 生态系统共享通用层，以最小化空间占用、停机时间和带宽
- 定期安全更新

## 核心功能和特性

- 与 Sonarr 和 Radarr 无缝集成，自动管理影视字幕
- 支持多语言字幕搜索和下载
- 可按电视剧或电影设置字幕偏好
- 定期自动更新字幕
- 支持多架构部署（x86-64、arm64）
- 支持只读容器文件系统运行
- 支持非 root 用户运行
- 灵活的用户权限管理（PUID/PGID）

## 支持的架构

该镜像利用 Docker 清单实现多平台支持。只需拉取 `lscr.io/linuxserver/bazarr:latest` 即可获取适合您架构的正确镜像，也可通过标签拉取特定架构的镜像。

支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 版本标签

该镜像提供多种版本，可通过标签获取。使用不稳定或开发标签时请谨慎。

| 标签 | 可用 | 描述 |
| :----: | :----: |--- |
| latest | ✅ | Bazarr 的稳定版本 |
| development | ✅ | Bazarr 的预发布版本 |

## 使用场景和适用范围

适用于需要自动管理影视字幕的媒体服务器环境，特别适合已部署 Sonarr（电视剧管理）和 Radarr（电影管理）的用户。通过集中化的字幕管理，可确保媒体库中的内容始终配有符合用户偏好的字幕。

## 应用设置

- 容器运行后，可通过 `http://<主机IP>:6767` 访问 Web 界面
- 必须在 Web 界面中完成所有设置参数后才能保存配置

## 只读运行

该镜像可在只读容器文件系统下运行，详情请参阅 [文档](https://docs.linuxserver.io/misc/read-only/)。

## 非 Root 运行

该镜像可使用非 root 用户运行，详情请参阅 [文档](https://docs.linuxserver.io/misc/non-root/)。

## 使用方法和配置说明

### Docker Compose（推荐）

```yaml
---
services:
  bazarr:
    image: docker.xuanyuan.run/linuxserver/bazarr:latest
    container_name: bazarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/bazarr/config:/config
      - /path/to/movies:/movies #可选
      - /path/to/tv:/tv #可选
    ports:
      - 6767:6767
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=bazarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 6767:6767 \
  -v /path/to/bazarr/config:/config \
  -v /path/to/movies:/movies `#可选` \
  -v /path/to/tv:/tv `#可选` \
  --restart unless-stopped \
  lscr.io/linuxserver/bazarr:latest
```

> [!NOTE]
> 除非参数标记为“可选”，否则均为必填项，必须提供值。

## 参数说明

容器通过运行时传递的参数进行配置，格式为 `<外部>:<内部>`。例如，`-p 8080:80` 表示将容器内的 80 端口映射到主机的 8080 端口。

| 参数 | 功能 |
| :----: | --- |
| `-p 6767:6767` | 允许通过 HTTP 访问内部 Web 服务器 |
| `-e PUID=1000` | 用户 ID - 详见下文说明 |
| `-e PGID=1000` | 组 ID - 详见下文说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见 [时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-v /config` | 持久化配置文件存储路径 |
| `-v /movies` | 电影文件存储路径（可选） |
| `-v /tv` | 电视剧文件存储路径（可选） |
| `--read-only=true` | 以只读文件系统运行容器，详见 [文档](https://docs.linuxserver.io/misc/read-only/) |
| `--user=1000:1000` | 以非 root 用户运行容器，详见 [文档](https://docs.linuxserver.io/misc/non-root/) |

## 来自文件的环境变量（Docker 密钥）

可使用特殊前缀 `FILE__` 从文件设置任何环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据 `/run/secrets/mysecretvariable` 文件的内容设置环境变量 `MYVAR`。

## 应用程序的文件权限掩码（Umask）

所有镜像均支持通过可选参数 `-e UMASK=022` 覆盖容器内服务的默认 umask 设置。请注意，umask 不是 chmod，它基于其值减去权限而非添加。详情请参阅 [umask 说明](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v` 标志）时，主机 OS 与容器之间可能出现权限问题。通过指定用户 `PUID` 和组 `PGID` 可避免此问题。确保主机上的卷目录归您指定的用户所有，权限问题将迎刃而解。

此处 `PUID=1000` 和 `PGID=1000`，可通过 `id your_user` 命令获取您的用户 ID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=bazarr&query=%24.mods%5B%27bazarr%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=bazarr "查看此容器可用的 Mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用 Mods")

我们发布了各种 [Docker Mods](https://github.com/linuxserver/docker-mods) 以启用容器内的附加功能。上述动态徽章可访问此镜像可用的 Mods 列表以及可应用于任何 LinuxServer.io 镜像的通用 Mods。

## 支持信息

### 容器运行时的 Shell 访问

```bash
docker exec -it bazarr /bin/bash
```

### 实时监控容器日志

```bash
docker logs -f bazarr
```

### 容器版本号

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' bazarr
```

### 镜像版本号

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/bazarr:latest
```

## 更新信息

大多数镜像为静态、版本化的，需要更新镜像并重新创建容器以更新内部应用程序。除特殊说明外，不建议或支持在容器内更新应用程序。

### 通过 Docker Compose 更新

#### 更新镜像：
- 所有镜像：

  ```bash
  docker-compose pull
  ```

- 单个镜像：

  ```bash
  docker-compose pull bazarr
  ```

#### 更新容器：
- 所有容器：

  ```bash
  docker-compose up -d
  ```

- 单个容器：

  ```bash
  docker-compose up -d bazarr
  ```

#### 清理旧镜像：

```bash
docker image prune
```

### 通过 Docker Run 更新

#### 更新镜像：

```bash
docker pull docker.xuanyuan.run/linuxserver/bazarr:latest
```

#### 停止运行中的容器：

```bash
docker stop bazarr
```

#### 删除容器：

```bash
docker rm bazarr
```

#### 使用上述相同的 docker run 参数重新创建容器（如果正确映射到主机文件夹，`/config` 文件夹和设置将被保留）

#### 清理旧镜像：

```bash
docker image prune
```

### 镜像更新通知 - Diun（Docker 镜像更新通知器）

> [!TIP]
> 推荐使用 [Diun](https://crazymax.dev/diun/) 进行更新通知。不推荐或支持使用其他自动更新容器的工具。

## 本地构建

如需为开发目的或自定义逻辑对这些镜像进行本地修改：

```bash
git clone https://github.com/linuxserver/docker-bazarr.git
cd docker-bazarr
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/bazarr:latest .
```

可使用 `lscr.io/linuxserver/qemu-static` 在 x86_64 硬件上构建 ARM 变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，可使用 `-f Dockerfile.aarch64` 指定要使用的 Dockerfile。

## 版本历史

- **05.07.25:** - 重新基于 Alpine 3.22 构建
- **24.12.24:** - 重新基于 Alpine 3.21 构建
- **24.06.24:** - 重新基于 Alpine 3.20 构建
- **23.12.23:** - 重新基于 Alpine 3.19 构建
- **19.09.23:** - 从 [linuxserver 仓库](https://github.com/linuxserver/docker-unrar) 安装 unrar
- **11.08.23:** - 重新基于 Alpine 3.18 构建
- **10.08.23:** - 将 unrar 升级至 6.2.10
- **04.07.23:** - 弃用 armhf 架构
- **26.02.23:** - 添加 postgres 支持依赖项，添加 mediainfo
- **23.01.23:** - 将主分支重新基于 Alpine 3.17 构建
- **11.10.22:** - 将主分支重新基于 Alpine 3.16 构建，迁移至 s6v3
- **15.15.21:** - 临时修复 lxml，从头编译以避免官方 wheel 损坏
- **25.10.21:** - 重新基于 Alpine 3.14 构建，修复 numpy wheel
- **22.10.21:** - 添加 openblas 包以防止 numpy 错误
- **16.05.21:** - 使用 wheel 索引
- **19.04.21:** - 从发布 zip 安装
- **07.04.21:** - 将应用移至 /app/bazarr/bin，添加 `package_info`
- **23.01.21:** - 重新基于 Alpine 3.13 构建
- **23.01.21:** - 弃用 `UMASK_SET`，改用基础镜像中的 UMASK
- **01.06.20:** - 重新基于 Alpine 3.12 构建
- **13.05.20:** - 为 Bazarr 添加捐赠链接到 Github 赞助商按钮和容器日志
- **08.04.20:** - 从 Dockerfiles 中移除 /movies 和 /tv 卷
- **28.12.19:** - 升级至 Python 3
- **19.12.19:** - 重新基于 Alpine 3.11 构建
- **28.06.19:** - 重新基于 Alpine 3.10 构建
- **13.06.19:** - 添加用于设置 umask 的环境变量
- **12.06.19:** - 使用维护者的 requirements.txt 安装依赖项，添加 ffmpeg 用于 ffprobe
- **17.04.19:** - 如果用户未设置，则添加默认 UTC 时区
- **23.03.19:** - 切换到新的基础镜像，迁移至 arm32v7 标签
- **22.02.19:** - 重新基于 Alpine 3.9 构建
- **11.09.18:** - 初始发布
