---
image: linuxserver/sabnzbd
description: "LinuxServer.io提供的Sabnzbd容器，是一款用于从Usenet下载文件的新闻组下载工具，支持自动解压缩与文件管理。"
source: https://xuanyuan.cloud/zh/r/linuxserver/sabnzbd
canonical: https://xuanyuan.cloud/zh/r/linuxserver/sabnzbd
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/sabnzbd" title="linuxserver/sabnzbd Docker 镜像中文简介、标签列表与拉取命令">linuxserver/sabnzbd 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/sabnzbd

## 镜像概述和主要用途

[Sabnzbd](http://sabnzbd.org/) 是一款 Usenet 下载工具，通过自动化尽可能多的流程，使 Usenet 使用变得简单高效。用户只需添加 .nzb 文件，Sabnzbd 将自动完成下载、验证、修复、解压和文件整理等一系列操作，全程无需人工干预。

LinuxServer.io 团队提供的该容器镜像具有以下特点：
- 定期及时的应用更新
- 便捷的用户映射（PGID、PUID）
- 基于 s6 overlay 的自定义基础镜像
- 每周基础操作系统更新，通过跨整个 LinuxServer.io 生态系统的通用层减少空间占用、停机时间和带宽消耗
- 定期安全更新

## 核心功能和特性

### Sabnzbd 应用功能
- 自动化 NZB 文件处理：自动下载、验证、修复、解压
- 支持 NZB 索引器集成
- 多服务器支持和连接优化
- 自定义文件分类和整理规则
- Web 界面管理和远程控制
- 内置通知系统（支持 Apprise）

### 容器镜像特性
- 多架构支持（x86-64、arm64v8）
- 非 root 用户运行支持
- 只读文件系统运行支持
- Docker Mods 扩展功能
- 灵活的存储路径配置
- 时区自定义

## 支持的架构

该镜像利用 Docker manifest 实现多平台支持。拉取 `lscr.io/linuxserver/sabnzbd:latest` 即可自动获取适合您架构的镜像，也可通过标签指定特定架构：

| 架构 | 支持情况 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 版本标签

| 标签 | 支持情况 | 描述 |
| :----: | :----: |--- |
| latest | ✅ | Sabnzbd 稳定版本 |
| unstable | ✅ | 开发分支的预发布版本 |
| nightly | ✅ | 开发分支的最新提交 |

## 使用场景和适用范围

- 家庭媒体服务器：自动下载和整理 Usenet 媒体内容
- 个人文件获取：高效管理 Usenet 资源下载
- 媒体中心集成：与 Kodi、Plex 等媒体中心配合使用
- 自动化工作流：作为数据获取环节集成到自动化流程中

## 应用设置

初始设置通过 `http://<您的IP>:8080` 访问 Web 界面完成。更多信息请参考 [SABnzbd 官方 wiki](https://sabnzbd.org/wiki/)。

### 媒体文件夹说明

镜像默认设置了 `/incomplete-downloads`（未完成下载）和 `/downloads`（已完成下载）作为可选路径，这是最简便的入门方式。但这种方式的缺点是无法使用硬链接（同一文件系统中多位置存在但仅占用一份空间）和原子移动（即时文件移动而非复制+删除）功能。

如果不需要硬链接或原子移动功能，可以直接使用这些可选路径。

> [!TIP]
> servarr.com 团队提供了关于此主题的详细 [指南](https://wiki.servarr.com/docker-guide#consistent-and-well-planned-paths)。

## 使用方法

### Docker Compose（推荐）

```yaml
---
services:
  sabnzbd:
    image: docker.xuanyuan.run/linuxserver/sabnzbd:latest
    container_name: sabnzbd
    environment:
      - PUID=1000        # 用户ID，详见下文说明
      - PGID=1000        # 组ID，详见下文说明
      - TZ=Etc/UTC       # 时区，例如 Asia/Shanghai
    volumes:
      - /path/to/sabnzbd/config:/config                  # 配置文件存储路径
      - /path/to/incomplete/downloads:/incomplete-downloads  # 未完成下载路径（可选）
      - /path/to/downloads:/downloads                    # 已完成下载路径（可选）
    ports:
      - 8080:8080        # Web界面端口
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=sabnzbd \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 8080:8080 \
  -v /path/to/sabnzbd/config:/config \
  -v /path/to/incomplete/downloads:/incomplete-downloads `#可选` \
  -v /path/to/downloads:/downloads `#可选` \
  --restart unless-stopped \
  lscr.io/linuxserver/sabnzbd:latest
```

## 参数说明

容器通过运行时参数进行配置，格式为 `<外部>:<内部>`。

| 参数 | 功能 |
| :----: | --- |
| `-p 8080:8080` | Web 界面 HTTP 端口 |
| `-e PUID=1000` | 用户 ID，用于解决权限问题 |
| `-e PGID=1000` | 组 ID，用于解决权限问题 |
| `-e TZ=Etc/UTC` | 时区设置，参考 [时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-v /config` | 配置文件持久化存储路径 |
| `-v /incomplete-downloads` | 未完成下载文件存储路径（可选） |
| `-v /downloads` | 已完成下载文件存储路径（可选） |
| `--read-only=true` | 以只读文件系统运行容器（需参考 [文档](https://docs.linuxserver.io/misc/read-only/)） |
| `--user=1000:1000` | 以非 root 用户运行容器（需参考 [文档](https://docs.linuxserver.io/misc/non-root/)） |

## 环境变量文件（Docker Secrets）

可通过 `FILE__` 前缀从文件中设置环境变量，例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据 `/run/secrets/mysecretvariable` 文件内容设置 `MYVAR` 环境变量。

## 应用 umask 设置

所有镜像支持通过 `-e UMASK=022` 覆盖默认 umask 设置。请注意，umask 是通过减法调整权限，而非直接设置权限。详情请参考 [umask 说明](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v` 参数）时，主机和容器之间可能出现权限问题。通过指定 `PUID`（用户 ID）和 `PGID`（组 ID）可避免此问题。确保主机上的卷目录归指定用户所有，权限问题将迎刃而解。

使用 `id your_user` 命令获取您的 PUID 和 PGID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=sabnzbd&query=%24.mods%5B%27sabnzbd%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=sabnzbd "查看此容器可用的 Mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看通用 Mods")

LinuxServer.io 发布了多种 [Docker Mods](https://github.com/linuxserver/docker-mods) 以扩展容器功能。上述动态徽章链接可查看此镜像可用的 Mods 及通用 Mods。

## 支持信息

### 容器运行时 Shell 访问

```bash
docker exec -it sabnzbd /bin/bash
```

### 实时监控容器日志

```bash
docker logs -f sabnzbd
```

### 容器版本号

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' sabnzbd
```

### 镜像版本号

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/sabnzbd:latest
```

## 更新信息

大多数镜像为静态版本，需要更新镜像并重新创建容器以更新应用。以下是更新容器的说明：

### 通过 Docker Compose 更新

#### 更新镜像：
- 所有镜像：
  ```bash
  docker-compose pull
  ```
- 单个镜像：
  ```bash
  docker-compose pull sabnzbd
  ```

#### 更新容器：
- 所有容器：
  ```bash
  docker-compose up -d
  ```
- 单个容器：
  ```bash
  docker-compose up -d sabnzbd
  ```

#### 清理旧镜像：
```bash
docker image prune
```

### 通过 Docker Run 更新

#### 更新镜像：
```bash
docker pull docker.xuanyuan.run/linuxserver/sabnzbd:latest
```

#### 停止运行中的容器：
```bash
docker stop sabnzbd
```

#### 删除容器：
```bash
docker rm sabnzbd
```

#### 使用相同参数重新创建容器（若卷映射正确，`/config` 文件夹和设置将保留）

#### 清理旧镜像：
```bash
docker image prune
```

### 镜像更新通知 - Diun (Docker Image Update Notifier)

> [!TIP]
> 推荐使用 [Diun](https://crazymax.dev/diun/) 获取更新通知。不建议或支持使用其他自动更新容器的工具。

## 本地构建

如需本地修改镜像进行开发或自定义：

```bash
git clone https://github.com/linuxserver/docker-sabnzbd.git
cd docker-sabnzbd
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/sabnzbd:latest .
```

可使用 `lscr.io/linuxserver/qemu-static` 在 x86_64 硬件上构建 ARM 变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，可使用 `-f Dockerfile.aarch64` 指定要使用的 dockerfile。

## 版本历史

- **05.07.25:** - 基于 Alpine 3.22 重新构建
- **23.12.24:** - 基于 Alpine 3.21 重新构建
- **31.05.24:** - 基于 Alpine 3.20 重新构建，移除 nzbnotify（SABnzbd 现已包含 apprise）
- **23.12.23:** - 基于 Alpine 3.19 重新构建
- **23.11.23:** - 构建翻译文件
- **13.09.23:** - 使用 par2cmdline-turbo 替代 par2cmdline
- **16.08.23:** - 从 [linuxserver 仓库](https://github.com/linuxserver/docker-unrar) 安装 unrar
- **10.08.23:** - 将 unrar 升级至 6.2.10
- **16.05.23:** - 将稳定版基于 Alpine 3.18 重新构建，弃用 armhf
- **15.03.23:** - 从 p7zip 切换到 7zip，将 unrar 升级至 6.2.6
- **05.03.23:** - 将主分支基于 Alpine 3.17 重新构建
- **03.10.22:** - 将主分支基于 Alpine 3.16 重新构建，迁移至 s6v3
- **12.08.22:** - 将 unrar 升级至 6.1.7
- **31.07.22:** - 添加 nightly 标签
- **10.03.22:** - 添加 nzb-notify
- **22.02.22:** - 将主分支基于 Alpine 重新构建，从源代码构建 unrar，弃用 Alpine 分支
- **25.01.22:** - 将 Unstable 分支基于 Alpine 重新构建
- **13.01.22:** - 添加 alpine 分支
- **08.08.21:** - 升级至 focal，不强制绑定到 ipv4 端口 8080
- **24.07.21:** - 添加 python3-setuptools
- **14.05.21:** - 使用 linuxserver.io wheel 索引获取 pip 包
- **12.02.21:** - 清理 rust/cargo 和 pip 缓存
- **17.08.20:** - 使用 python3 从源代码运行，完全移除 python2，将 `python` 符号链接到 `python3`
- **02.01.20:** - 在过渡期间在镜像中添加 python3（基于 python2）
- **23.03.19:** - 切换到新的基础镜像，迁移至 arm32v7 标签
- **25.02.19:** - 基于 Bionic 重新构建，添加脚本所需的 python 依赖
- **26.01.19:** - 添加流水线逻辑和多架构支持
- **13.12.17:** - 修复续行符
- **12.07.17:** - 添加检查命令到 README，迁移至 jenkins 构建和推送
- **10.04.17:** - 升级至 2.0 发布版
- **25.02.17:** - 将 master/latest 分支切换到 nobetas 仓库，添加 unstable 分支
- **08.02.17:** - 添加 pythonioenconding=utf8 环境变量
- **15.09.16:** - 根据最新的 sabnzbd git [readme](https://github.com/sabnzbd/sabnzbd#resolving-dependencies) 编译 par2 多核版本
- **11.09.16:** - 升级至 1.10 发布版
- **09.09.16:** - 重新基于 xenial 构建（alpine 版本的 python 与 sab 的 1.10 分支存在问题）
- **28.08.16:** - 基于 alpine 重新构建，使用 sab 的 git 版本
- **17.03.16:** - 启动时安装 1.0 正式版
- **14.03.16:** - 刷新镜像以获取最新 RC 版本
- **23.01.15:** - 刷新镜像
- **14.12.15:** - 刷新镜像以获取最新测试版
- **21.08.15:** - 初始发布
