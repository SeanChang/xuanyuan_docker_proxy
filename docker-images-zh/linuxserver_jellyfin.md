---
image: linuxserver/jellyfin
description: "LinuxServer.io 提供的 Jellyfin 容器，是一款自由软件媒体系统，支持媒体管理与流式传输，具备跨平台特性、定期更新和用户权限映射功能。"
source: https://xuanyuan.cloud/zh/r/linuxserver/jellyfin
canonical: https://xuanyuan.cloud/zh/r/linuxserver/jellyfin
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [linuxserver/jellyfin — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/linuxserver/jellyfin)

含镜像标签、拉取命令、部署文档与相关推荐。

[linuxserver/jellyfin Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/linuxserver/jellyfin)

# LinuxServer.io Jellyfin 容器

LinuxServer.io 团队提供的此容器具有以下特点：
* 定期及时的应用更新
* 简单的用户映射（PGID、PUID）
* 带有 s6 overlay 的自定义基础镜像
* 每周基础操作系统更新，通过整个 LinuxServer.io 生态系统的通用层减少空间占用、停机时间和带宽消耗
* 定期安全更新

## 关于 Jellyfin

[Jellyfin](https://github.com/jellyfin/jellyfin) 是一款自由软件媒体系统，让您能够掌控媒体的管理和流式传输。作为专有软件 Emby 和 Plex 的替代方案，它可通过多个应用程序从专用服务器向终端用户设备提供媒体服务。Jellyfin 源自 Emby 3.5.2 版本，已移植到 .NET Core 框架以实现全面的跨平台支持。它无附加条件、无高级功能限制、无隐藏目的，由团队协作开发以打造更优质的产品。

## 支持的架构

利用 docker manifest 实现多平台支持，拉取 `lscr.io/linuxserver/jellyfin:latest` 即可获取适合您架构的镜像，也可通过标签指定特定架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-<version tag> |
| arm64 | ✅ | arm64v8-<version tag> |

## 版本标签

| 标签 | 可用 | 描述 |
| :----: | :----: |--- |
| latest | ✅ | Jellyfin 稳定版本 |
| nightly | ✅ | Jellyfin 夜间构建版本 |

## 应用设置

Web 界面地址：`http://<您的IP>:8096`，更多信息参见[官方文档](https://jellyfin.org/docs/general/quick-start.html)。

### 硬件加速配置

#### Intel
启用基于 OpenCL 的色调映射需参考 [OpenCL-Intel 模块](https://mods.linuxserver.io/?mod=jellyfin) 并遵循 [Intel 硬件加速指南](https://jellyfin.org/docs/general/administration/hardware-acceleration/intel/#configure-and-verify-lp-mode-on-linux)。

#### 树莓派
- **OpenMAX (MMAL)**：需挂载设备和库
  ```
  --device=/dev/vcsm:/dev/vcsm
  --device=/dev/vchiq:/dev/vchiq
  -v /opt/vc/lib:/opt/vc/lib
  ```
- **V4L2**：需挂载视频设备
  ```
  --device=/dev/video10:/dev/video10
  --device=/dev/video11:/dev/video11
  --device=/dev/video12:/dev/video12
  ```

#### Intel/AMD/NVIDIA
- **Intel/AMD**：挂载 `/dev/dri` 设备
  ```
  --device=/dev/dri:/dev/dri
  ```
- **NVIDIA**：需安装 [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-container-toolkit)，运行时添加 `--runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=all`。

## 部署示例

### Docker Compose
```yaml
---
services:
  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - JELLYFIN_PublishedServerUrl=http://192.168.0.5 #可选
    volumes:
      - /path/to/jellyfin/library:/config
      - /path/to/tvseries:/data/tvshows
      - /path/to/movies:/data/movies
    ports:
      - 8096:8096
      - 8920:8920 #可选
      - 7359:7359/udp #可选
      - 1900:1900/udp #可选
    restart: unless-stopped
```

### Docker CLI
```bash
docker run -d \
  --name=jellyfin \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e JELLYFIN_PublishedServerUrl=http://192.168.0.5 `#optional` \
  -p 8096:8096 \
  -p 8920:8920 `#optional` \
  -p 7359:7359/udp `#optional` \
  -p 1900:1900/udp `#optional` \
  -v /path/to/jellyfin/library:/config \
  -v /path/to/tvseries:/data/tvshows \
  -v /path/to/movies:/data/movies \
  --restart unless-stopped \
  lscr.io/linuxserver/jellyfin:latest
```

## 参数说明

| 参数 | 功能 |
| :----: | --- |
| `-p 8096:8096` | HTTP  web 界面 |
| `-p 8920` | HTTPS  web 界面（需自备证书） |
| `-e PUID=1000` | 用户 ID（通过 `id your_user` 获取） |
| `-e PGID=1000` | 组 ID |
| `-e TZ=Etc/UTC` | 时区（如 `Asia/Shanghai`） |
| `-v /config` | 配置文件存储路径 |
| `-v /data/...` | 媒体文件路径（可添加多个） |

## 维护与更新

### 更新容器
```bash
# Docker Compose
docker-compose pull jellyfin && docker-compose up -d
# Docker CLI
docker pull lscr.io/linuxserver/jellyfin:latest && docker stop jellyfin && docker rm jellyfin && docker run ...（使用原参数）
```

### 查看日志
```bash
docker logs -f jellyfin
```

### 版本信息
```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' jellyfin
```

## 版本历史

* **06.10.24:** 修复 fontconfig 缓存路径
* **13.08.24:** 基于 Ubuntu Noble 重建
* **04.07.23:** 弃用 armhf 架构
* **07.12.22:** 迁移到 s6v3 基础镜像
