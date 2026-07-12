---
image: linuxserver/nzbget
description: "LinuxServer.io提供的Nzbget容器，是一款用于从Usenet下载文件的工具，支持nzb文件，可高效下载和管理Usenet内容。"
source: https://xuanyuan.cloud/zh/r/linuxserver/nzbget
canonical: https://xuanyuan.cloud/zh/r/linuxserver/nzbget
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/nzbget" title="linuxserver/nzbget Docker 镜像中文简介、标签列表与拉取命令">linuxserver/nzbget 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/nzbget Docker镜像文档

## 镜像概述和主要用途

[linuxserver/nzbget](https://github.com/linuxserver/docker-nzbget) 是由LinuxServer.io团队开发的Docker镜像，用于运行[Nzbget](http://nzbget.com/)——一款用C++编写的Usenet下载器。该工具专为性能优化设计，旨在以极低的系统资源占用实现最大下载速度，是Usenet用户高效获取内容的理想选择。

LinuxServer.io团队的镜像具有以下特点：
- 定期及时的应用更新
- 简化的用户权限映射（PGID、PUID）
- 基于s6 overlay的自定义基础镜像
- 每周基础操作系统更新，通过跨生态系统的通用层减少空间占用、 downtime和带宽消耗
- 定期安全更新

## 核心功能和特性

### 应用核心功能
- 高性能Usenet下载，资源占用低
- Web管理界面，便于配置和监控下载任务
- 支持下载任务调度和优先级管理
- 集成解压缩功能，可自动处理下载后的文件
- 多平台架构支持，适应不同硬件环境

### 镜像特有特性
- **多架构支持**：兼容x86-64和arm64v8架构
- **灵活权限管理**：通过PUID/PGID实现容器内外用户权限映射
- **持久化配置**：独立的配置目录，确保设置不丢失
- **只读文件系统支持**：可配置为只读模式运行，增强安全性
- **非root用户运行**：支持以非root用户身份启动容器，降低安全风险
- **时区自定义**：可通过环境变量设置容器时区

## 支持的架构

该镜像利用Docker manifest实现多平台支持，拉取`lscr.io/linuxserver/nzbget:latest`即可自动获取适合当前架构的镜像，也可通过标签指定特定架构：

| 架构 | 支持情况 | 标签格式 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-<版本标签> |
| arm64 | ✅ | arm64v8-<版本标签> |

## 版本标签

镜像提供多种版本标签，使用时请仔细阅读说明，谨慎选择不稳定或开发版本：

| 标签 | 支持情况 | 描述 |
| :----: | :----: |--- |
| latest | ✅ | Nzbget稳定版本 |
| testing | ✅ | Nzbget预发布版本 |

## 使用场景和适用范围

- **个人媒体服务器**：作为Usenet下载组件，与媒体管理工具（如Sonarr、Radarr）配合，构建自动化媒体获取流程
- **家庭网络存储**：在NAS设备上部署，集中管理Usenet下载任务
- **多用户环境**：通过权限映射，确保不同用户安全访问下载内容
- **资源受限设备**：低资源占用特性使其适用于树莓派等嵌入式设备

## 应用配置

### 初始访问

Web管理界面地址：`<你的IP>:6789`  
默认登录凭证（建议立即修改）：
- 用户名：`nzbget`
- 密码：`tegbzn6789`

### 时间校正设置

为启用任务调度功能，需在Web界面的「设置/日志」中配置时间校正值。

### 中间解压目录配置

如需自定义中间解压目录，可添加以下挂载：
```bash
-v /path/to/nzbget/intermediate:/intermediate
```
并在Web界面「路径」设置中将`InterDir`修改为`/intermediate`。

### 媒体文件夹说明

镜像默认将`/downloads`设为可选路径，便于快速启动。但该设置可能影响硬链接（同一文件在同一文件系统中多位置存在但仅占用一份空间）和原子移动（即时文件移动而非复制+删除）功能。如需要这些高级特性，建议参考[servarr.com的路径规划指南](https://wiki.servarr.com/docker-guide#consistent-and-well-planned-paths)进行配置。

## 只读模式运行

本镜像支持以只读容器文件系统运行，详情请参阅[LinuxServer.io只读模式文档](https://docs.linuxserver.io/misc/read-only/)。

## 非Root用户运行

本镜像支持以非root用户身份运行，详情请参阅[LinuxServer.io非Root用户文档](https://docs.linuxserver.io/misc/non-root/)。

## 使用方法

### Docker Compose（推荐）

```yaml
---
services:
  nzbget:
    image: docker.xuanyuan.run/linuxserver/nzbget:latest
    container_name: nzbget
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - NZBGET_USER=nzbget # 可选
      - NZBGET_PASS=tegbzn6789 # 可选
    volumes:
      - /path/to/nzbget/data:/config
      - /path/to/downloads:/downloads # 可选
    ports:
      - 6789:6789
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=nzbget \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e NZBGET_USER=nzbget `# 可选` \
  -e NZBGET_PASS=tegbzn6789 `# 可选` \
  -p 6789:6789 \
  -v /path/to/nzbget/data:/config \
  -v /path/to/downloads:/downloads `# 可选` \
  --restart unless-stopped \
  lscr.io/linuxserver/nzbget:latest
```

## 参数说明

容器通过运行时参数进行配置，格式为`<外部>:<内部>`。以下是支持的参数说明：

| 参数 | 功能 |
| :----: | --- |
| `-p 6789:6789` | Web管理界面端口映射 |
| `-e PUID=1000` | 用户ID，用于权限映射（详见下方说明） |
| `-e PGID=1000` | 组ID，用于权限映射（详见下方说明） |
| `-e TZ=Etc/UTC` | 时区设置，参考[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e NZBGET_USER=nzbget` | Web界面认证用户名 |
| `-e NZBGET_PASS=tegbzn6789` | Web界面认证密码 |
| `-v /config` | 配置文件持久化目录 |
| `-v /downloads` | 下载文件存储目录 |
| `--read-only=true` | 以只读文件系统运行容器 |
| `--user=1000:1000` | 指定容器运行的用户和组 |

## 文件环境变量（Docker Secrets）

可通过`FILE__`前缀从文件加载环境变量，例如：
```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```
将从`/run/secrets/mysecretvariable`文件内容设置`MYVAR`环境变量。

## 应用程序Umask设置

所有LinuxServer.io镜像支持通过`-e UMASK=022`覆盖默认umask设置。注意umask是权限掩码（减去权限而非添加），详情请参考[umask说明](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷挂载时，主机与容器间可能出现权限问题。通过指定`PUID`（用户ID）和`PGID`（组ID）可避免此问题。确保主机卷目录所有者与指定的ID一致。

通过以下命令获取当前用户的PUID和PGID：
```bash
id your_user
```
输出示例：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=nzbget&query=%24.mods%5B%27nzbget%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=nzbget) [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal)

LinuxServer.io提供多种[Docker Mods](https://github.com/linuxserver/docker-mods)以扩展容器功能。上方徽章链接包含适用于本镜像的Mods及通用Mods列表。

## 支持信息

### 容器内Shell访问
```bash
docker exec -it nzbget /bin/bash
```

### 实时日志监控
```bash
docker logs -f nzbget
```

### 容器版本查询
```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' nzbget
```

### 镜像版本查询
```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/nzbget:latest
```

## 更新说明

大多数LinuxServer.io镜像是静态版本化的，需更新镜像并重建容器以更新应用。除非应用文档特别说明，否则不建议在容器内更新应用。

### 使用Docker Compose更新
- 更新镜像：
  - 所有镜像：`docker-compose pull`
  - 单个镜像：`docker-compose pull nzbget`
- 更新容器：
  - 所有容器：`docker-compose up -d`
  - 单个容器：`docker-compose up -d nzbget`
- 清理旧镜像：`docker image prune`

### 使用Docker Run更新
- 更新镜像：`docker pull docker.xuanyuan.run/linuxserver/nzbget:latest`
- 停止容器：`docker stop nzbget`
- 删除容器：`docker rm nzbget`
- 使用原参数重建容器（配置存储在`/config`卷中，将被保留）
- 清理旧镜像：`docker image prune`

### 镜像更新通知 - Diun
推荐使用[Diun](https://crazymax.dev/diun/)接收更新通知，不建议使用自动更新容器的工具。

## 本地构建

如需修改镜像进行开发或自定义：
```bash
git clone https://github.com/linuxserver/docker-nzbget.git
cd docker-nzbget
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/nzbget:latest .
```

可使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体：
```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```
注册后使用`-f Dockerfile.aarch64`指定架构Dockerfile。

## 版本历史

- **01.09.25:** 添加boost filesystem依赖
- **05.07.25:** 基于Alpine 3.22重新构建
- **24.12.24:** 基于Alpine 3.21重新构建，将MainDir移至/config，默认DestDir/InterDir保留为/downloads
- **31.05.24:** 基于Alpine 3.20重新构建
- **09.05.24:** 基于nzbgetcom/nzbget分支恢复镜像构建
