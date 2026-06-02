---
image: lsiodev/radarr
description: "Radarr是一款用于电影收藏管理的工具，可自动搜索、下载和整理电影文件，帮助用户维护有序的电影库。"
source: https://xuanyuan.cloud/zh/r/lsiodev/radarr
canonical: https://xuanyuan.cloud/zh/r/lsiodev/radarr
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [lsiodev/radarr — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/lsiodev/radarr)

含镜像标签、拉取命令、部署文档与相关推荐。

[lsiodev/radarr Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/lsiodev/radarr)

# linuxserver/radarr 镜像文档


## 镜像概述和主要用途

[Radarr](https://github.com/Radarr/Radarr) 是 Sonarr 的一个分支，专门用于电影管理，功能类似 Couchpotato。本镜像由 [LinuxServer.io](https://linuxserver.io) 团队维护，提供了稳定、易用的 Radarr 容器化部署方案，适用于个人电影库的自动化管理，包括电影搜索、下载、整理和元数据管理等。


## 核心功能和特性

### Radarr 应用功能
- 电影库自动化管理，支持搜索、下载、分类和元数据获取
- 与主流下载客户端（如 qBittorrent、Deluge 等）集成
- 支持自定义质量配置、文件重命名和目录结构整理
- 自动监控和更新电影元数据（海报、简介、评分等）

### LinuxServer.io 镜像特性
- 定期、及时的应用更新
- 简单的用户权限映射（通过 PUID、PGID）
- 基于 s6 overlay 的自定义基础镜像
- 每周基础 OS 更新，跨生态系统共享通用层以减少空间占用、 downtime 和带宽消耗
- 定期安全更新


## 支持的架构

该镜像通过 Docker manifest 实现多平台支持，拉取 `lscr.io/linuxserver/radarr:latest` 即可自动匹配对应架构。也可通过标签指定特定架构：

| 架构       | 支持状态 | 标签格式               |
|------------|----------|------------------------|
| x86-64     | ✅        | amd64-\<version tag\>  |
| arm64      | ✅        | arm64v8-\<version tag\> |
| armhf      | ✅        | arm32v7-\<version tag\> |


## 版本标签

| 标签       | 支持状态 | 描述                     |
|------------|----------|--------------------------|
| latest     | ✅        | Radarr 稳定版发布        |
| develop    | ✅        | Radarr develop 分支版本  |
| nightly    | ✅        | Radarr nightly 分支版本  |


## 应用设置

1. 启动容器后，通过 `<你的IP>:7878` 访问 Web 界面
2. 首次使用需完成初始配置向导，包括设置下载客户端、电影库路径等
3. **媒体文件夹注意事项**：
   - 镜像默认提供 `/movies` 和 `/downloads` 作为可选路径，便于快速上手
   - 若需支持硬链接（同一文件在多位置引用但仅占用一份空间）或原子移动（即时文件移动而非复制+删除），建议参考 [Servarr 文档](https://wiki.servarr.com/docker-guide#consistent-and-well-planned-paths) 规划路径结构


## 使用方法和配置说明

### Docker Compose（推荐）

```yaml
---
version: "2.1"
services:
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=1000        # 用户ID，详见下方说明
      - PGID=1000        # 组ID，详见下方说明
      - TZ=Etc/UTC       # 时区，如 Asia/Shanghai
    volumes:
      - /path/to/data:/config                     # 配置文件存储路径
      - /path/to/movies:/movies                   # 电影库路径（可选）
      - /path/to/downloads:/downloads             # 下载客户端输出路径（可选）
    ports:
      - 7878:7878        # Web界面端口
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=radarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 7878:7878 \
  -v /path/to/data:/config \
  -v /path/to/movies:/movies `# 可选` \
  -v /path/to/downloads:/downloads `# 可选` \
  --restart unless-stopped \
  lscr.io/linuxserver/radarr:latest
```


## 参数说明

| 参数                | 功能描述                                                                 |
|---------------------|--------------------------------------------------------------------------|
| `-p 7878`           | Radarr Web 界面访问端口                                                 |
| `-e PUID=1000`      | 容器内运行用户的 ID，用于解决权限问题（详见下方用户/组 ID 说明）         |
| `-e PGID=1000`      | 容器内运行用户组的 ID，用于解决权限问题（详见下方用户/组 ID 说明）       |
| `-e TZ=Etc/UTC`     | 时区设置，格式参考 [时区数据库列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-v /config`        | 存储 Radarr 配置文件和数据库的路径                                       |
| `-v /movies`        | 电影库路径（可选，建议映射以实现文件管理）                               |
| `-v /downloads`     | 下载客户端输出目录（可选，用于 Radarr 识别和整理下载的电影文件）         |


## 环境变量与配置

### 从文件加载环境变量（Docker Secrets）

可通过 `FILE__` 前缀从文件加载环境变量，例如：
```bash
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```
上述命令会将 `/run/secrets/mysecretpassword` 文件内容作为 `PASSWORD` 环境变量的值。

### Umask 设置

可通过 `-e UMASK=022` 覆盖容器内应用的默认 umask 设置。注意 umask 是权限掩码（减法操作），而非直接设置权限，详情参考 [umask 说明](https://en.wikipedia.org/wiki/Umask)。


## 用户/组 ID 说明

使用卷挂载（`-v` 参数）时，主机与容器可能出现权限冲突。通过指定 `PUID`（用户 ID）和 `PGID`（组 ID），可确保容器内用户与主机用户权限一致，避免权限问题。

获取当前用户的 UID 和 GID：
```bash
id username
# 输出示例：uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```
将输出的 `uid` 和 `gid` 分别作为 `PUID` 和 `PGID` 的值。


## Docker Mods

可通过 Docker Mods 扩展容器功能，相关 mods 可增强 Radarr 的功能或集成其他工具。

- 查看 Radarr 专用 mods：[https://mods.linuxserver.io/?mod=radarr](https://mods.linuxserver.io/?mod=radarr)
- 查看通用 mods（适用于所有 LinuxServer.io 镜像）：[https://mods.linuxserver.io/?mod=universal](https://mods.linuxserver.io/?mod=universal)


## 支持信息

### 容器管理命令
- 访问容器 Shell：`docker exec -it radarr /bin/bash`
- 实时查看日志：`docker logs -f radarr`
- 查看容器版本：`docker inspect -f '{{ index .Config.Labels "build_version" }}' radarr`
- 查看镜像版本：`docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/radarr:latest`


## 更新说明

LinuxServer.io 镜像为静态版本，需通过更新镜像并重建容器来升级应用（部分例外如 nextcloud、plex 除外）。

### 通过 Docker Compose 更新
```bash
# 更新所有镜像（或指定镜像）
docker-compose pull radarr
# 重建并启动容器
docker-compose up -d radarr
# 清理旧镜像
docker image prune
```

### 通过 Docker Run 更新
```bash
# 拉取最新镜像
docker pull lscr.io/linuxserver/radarr:latest
# 停止并删除旧容器
docker stop radarr && docker rm radarr
# 用相同参数重建容器（/config 卷会保留配置）
docker run -d [原参数] lscr.io/linuxserver/radarr:latest
# 清理旧镜像
docker image prune
```

### 通过 Watchtower 自动更新（仅推荐临时使用）
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once radarr
```
> **注意**：不建议长期使用 Watchtower 自动更新，推荐使用 Docker Compose 进行版本管理。


## 本地构建

如需自定义镜像，可通过以下步骤本地构建：

```bash
# 克隆仓库
git clone https://github.com/linuxserver/docker-radarr.git
cd docker-radarr
# 构建镜像
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/radarr:latest .
```

### 构建 ARM 架构镜像（需在 x86_64 主机上）
```bash
# 注册 qemu-user-static
docker run --rm --privileged multiarch/qemu-user-static:register --reset
# 构建特定架构（如 arm64v8）
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/radarr:arm64v8-latest .
```


## 版本历史

- **17.01.23**：主分支基于 Alpine 3.17 重建，迁移至 s6v3
- **06.06.22**：主分支基于 Alpine 3.15 重建
- **20.02.22**：develop 分支基于 Alpine 重建
- **04.02.22**：nightly 分支基于 Alpine 重建，废弃 nightly-alpine 分支
- **27.12.21**：添加 nightly-alpine 分支
- **17.10.21**：移除 `UMASK_SET` 参数
- **08.05.21**：优化路径说明
- **17.01.21**：用 baseimage 中的 UMASK 参数替代 `UMASK_SET`
- **11.30.20**：发布 `develop` 标签
- **11.28.20**：切换到 .NET Core v3 构建（不再依赖 mono，`5.14` 标签废弃），基于 Ubuntu Focal 重建
- **05.04.20**：应用路径迁移至 /app
- **01.08.19**：基于 Linuxserver LTS mono 版本重建
- **13.06.19**：添加 umask 环境变量
- **10.05.19**：基于 Ubuntu Bionic 重建
- **23.03.19**：切换到新基础镜像，使用 arm32v7 标签
- **09.09.18**：添加流水线构建流程
- **24.02.18**：添加 nightly 分支
- **06.02.18**：更新 Radarr 仓库所有者
- **15.12.17**：修复续行符
- **17.04.17**：切换到内部 mono 基础镜像，添加 python 依赖
- **13.04.17**：切换到官方 mono 仓库
- **10.01.17**：初始发布
