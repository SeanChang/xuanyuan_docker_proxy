---
image: linuxserver/duplicati
description: "LinuxServer.io提供的Duplicati容器，用于数据备份与同步，支持加密和压缩功能。"
source: https://xuanyuan.cloud/zh/r/linuxserver/duplicati
canonical: https://xuanyuan.cloud/zh/r/linuxserver/duplicati
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/duplicati" title="linuxserver/duplicati Docker 镜像中文简介、标签列表与拉取命令">linuxserver/duplicati 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/duplicati 镜像文档

## 镜像概述和主要用途

[Duplicati](https://www.duplicati.com/) 是一款备份客户端，可将加密、增量、压缩的备份安全地存储在本地存储、云存储服务和远程文件服务器上。它支持标准协议如 FTP、SSH、WebDAV，以及流行的云服务如 Microsoft OneDrive、Amazon S3、Google Drive、box.com、Mega、B2 等。

LinuxServer.io 团队提供的此容器镜像具有以下特点：
- 定期及时的应用更新
- 简单的用户映射 (PGID, PUID)
- 带有 s6 覆盖层的自定义基础镜像
- 每周基础操作系统更新，在整个 LinuxServer.io 生态系统中共享通用层，以最小化空间使用、停机时间和带宽
- 定期安全更新

![duplicati](https://github.com/linuxserver/docker-templates/raw/master/linuxserver.io/img/duplicati-icon.png)

## 核心功能和特性

- 加密备份：支持 AES-256 加密保护备份数据
- 增量备份：仅备份更改的部分，减少存储空间和传输量
- 压缩备份：自动压缩备份数据以节省空间
- 多平台支持：可备份到各种存储服务和协议
- 计划备份：支持自定义备份计划
- 备份验证：可验证备份的完整性
- 网页界面：通过 Web UI 轻松管理备份任务
- 跨平台兼容：支持多种架构

## 使用场景和适用范围

- 个人用户数据备份
- 家庭服务器数据保护
- 小型企业备份解决方案
- 云存储备份管理
- 定期自动备份任务
- 跨设备数据同步
- 远程服务器备份

## 支持的架构

该镜像利用 docker manifest 实现多平台支持。只需拉取 `lscr.io/linuxserver/duplicati:latest` 即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 版本标签

| 标签 | 可用 | 描述 |
| :----: | :----: |--- |
| latest | ✅ | Duplicati 的稳定版本 |
| development | ✅ | Duplicati 的测试版本 |

## 应用设置

Web 界面位于 `<您的 IP>:8200`。

对于本地备份，选择 `/backups` 作为目标位置。更多信息请参见 [Duplicati 官方网站](https://www.duplicati.com/)。

## 使用方法

以下是创建容器的两种方法：使用 docker-compose 或 docker cli。

> [!NOTE]
> 除非参数标记为“可选”，否则它是*必填*项，必须提供值。

### docker-compose (推荐)

```yaml
---
services:
  duplicati:
    image: lscr.io/linuxserver/duplicati:latest
    container_name: duplicati
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - SETTINGS_ENCRYPTION_KEY=
      - CLI_ARGS= #可选
      - DUPLICATI__WEBSERVICE_PASSWORD= #可选
    volumes:
      - /path/to/duplicati/config:/config
      - /path/to/backups:/backups
      - /path/to/source:/source
    ports:
      - 8200:8200
    restart: unless-stopped
```

### docker cli

```bash
docker run -d \
  --name=duplicati \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e SETTINGS_ENCRYPTION_KEY= \
  -e CLI_ARGS= `#可选` \
  -e DUPLICATI__WEBSERVICE_PASSWORD= `#可选` \
  -p 8200:8200 \
  -v /path/to/duplicati/config:/config \
  -v /path/to/backups:/backups \
  -v /path/to/source:/source \
  --restart unless-stopped \
  lscr.io/linuxserver/duplicati:latest
```

## 参数说明

容器通过运行时传递的参数进行配置。这些参数用冒号分隔，表示 `<外部>:<内部>`。例如，`-p 8080:80` 会将容器内的端口 80 暴露到主机的 8080 端口。

### 端口参数

| 参数 | 功能 |
| :----: | --- |
| `-p 8200:8200` | HTTP 管理界面 |

### 环境变量

| 参数 | 功能 |
| :----: | --- |
| `-e PUID=1000` | 用户 ID - 详见下文说明 |
| `-e PGID=1000` | 组 ID - 详见下文说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见 [时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e SETTINGS_ENCRYPTION_KEY=` | 设置数据库的加密密钥，至少 8 个字符，字母数字 |
| `-e CLI_ARGS=` | 可选，指定要启动应用程序的任何 [CLI 变量](https://duplicati.readthedocs.io/en/latest/07-other-command-line-utilities/) |
| `-e DUPLICATI__WEBSERVICE_PASSWORD=` | Web 界面密码，如果未设置，默认值为 `changeme`，可从 Web 界面设置中更改 |

### 卷参数

| 参数 | 功能 |
| :----: | --- |
| `-v /config` | 包含所有相关配置文件 |
| `-v /backups` | 存储本地备份的路径 |
| `-v /source` | 要备份的文件源路径 |

## 环境变量从文件读取 (Docker secrets)

您可以通过使用特殊前缀 `FILE__` 从文件设置任何环境变量。

例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据 `/run/secrets/mysecretvariable` 文件的内容设置环境变量 `MYVAR`。

## 应用程序的Umask设置

对于我们所有的镜像，您可以使用可选的 `-e UMASK=022` 设置来覆盖容器内启动的服务的默认 umask 设置。请记住，umask 不是 chmod，它根据其值减去权限，而不是添加。在请求支持之前，请先[了解 umask](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷 (`-v` 标志) 时，主机操作系统和容器之间可能会出现权限问题。我们通过允许您指定用户 `PUID` 和组 `PGID` 来避免此问题。

确保主机上的任何卷目录都由您指定的相同用户拥有，这样任何权限问题都会像魔术一样消失。

在此示例中 `PUID=1000` 和 `PGID=1000`，要找到您的 PUID 和 PGID，请使用 `id your_user` 命令：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=duplicati&query=%24.mods%5B%27duplicati%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=duplicati "查看此容器的可用 mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用 mods")

我们提供了各种 [Docker Mods](https://github.com/linuxserver/docker-mods)，以启用容器内的附加功能。可通过上方的动态徽章访问此镜像可用的 Mods 列表（如有）以及可应用于我们任何镜像的通用 Mods。

## 支持信息

### 访问运行中容器的 Shell

```bash
docker exec -it duplicati /bin/bash
```

### 实时监控容器日志

```bash
docker logs -f duplicati
```

### 容器版本号

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' duplicati
```

### 镜像版本号

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/duplicati:latest
```

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器来更新内部的应用程序。除了某些例外情况（在相关的 readme.md 中注明），我们不建议或支持在容器内更新应用程序。请查阅上面的[应用设置](#应用设置)部分，了解是否推荐对该镜像进行应用内更新。

以下是更新容器的说明：

### 通过 Docker Compose 更新

#### 更新镜像：
- 所有镜像：

  ```bash
  docker-compose pull
  ```

- 单个镜像：

  ```bash
  docker-compose pull duplicati
  ```

#### 更新容器：
- 所有容器：

  ```bash
  docker-compose up -d
  ```

- 单个容器：

  ```bash
  docker-compose up -d duplicati
  ```

- 您还可以删除旧的悬空镜像：

  ```bash
  docker image prune
  ```

### 通过 Docker Run 更新

- 更新镜像：

  ```bash
  docker pull lscr.io/linuxserver/duplicati:latest
  ```

- 停止运行中的容器：

  ```bash
  docker stop duplicati
  ```

- 删除容器：

  ```bash
  docker rm duplicati
  ```

- 使用上述相同的 docker run 参数重新创建新容器（如果正确映射到主机文件夹，您的 `/config` 文件夹和设置将被保留）

- 您还可以删除旧的悬空镜像：

  ```bash
  docker image prune
  ```

### 镜像更新通知 - Diun (Docker Image Update Notifier)

> [!TIP]
> 我们推荐使用 [Diun](https://crazymax.dev/diun/) 进行更新通知。不推荐或支持其他自动无人值守更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-duplicati.git
cd docker-duplicati
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/duplicati:latest .
```

可以使用 `lscr.io/linuxserver/qemu-static` 在 x86_64 硬件上构建 ARM 变体，反之亦然：

```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```

注册后，您可以使用 `-f Dockerfile.aarch64` 指定要使用的 dockerfile。

## 版本历史

- **31.01.25:** - 将 `latest` 设为稳定版本，测试版本移至 `development`。
- **28.01.25:** - 添加 xz-utils。
- **03.12.24:** - 添加 mscorefonts 以支持验证码。
- **29.11.24:** - 重新基于 Noble 构建，添加对设置数据库加密的支持。
- **15.02.23:** - 重新基于 Jammy 构建。
- **03.08.22:** - 弃用 armhf。
- **25.04.22:** - 重新基于 mono:focal 构建。
- **01.08.19:** - 重新基于 Linuxserver LTS mono 版本构建。
- **16.07.19:** - 允许在环境变量中使用其他命令行参数。
- **28.06.19:** - 重新基于 bionic 构建。
- **23.03.19:** - 切换到新的基础镜像，迁移到 arm32v7 标签。
- **28.02.19:** - 允许从所有主机名访问，澄清镜像标签信息。
- **13.01.19:** - 在 dockerfiles 中使用 jq 代替 awk。
- **11.01.19:** - 多架构镜像。
- **09.12.17:** - 修复续行。
- **31.08.17:** - 仅构建测试版或发布版（感谢 deasmi）。
- **24.04.17:** - 初始发布。
