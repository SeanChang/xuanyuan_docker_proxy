---
image: ds1080/jellyfin
description: "Jellyfin Server是一款开源媒体服务器，用于管理、组织和流式传输音视频内容，支持多设备访问，提供个性化媒体库管理与播放体验。"
source: https://xuanyuan.cloud/zh/r/ds1080/jellyfin
canonical: https://xuanyuan.cloud/zh/r/ds1080/jellyfin
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ds1080/jellyfin" title="ds1080/jellyfin Docker 镜像中文简介、标签列表与拉取命令">ds1080/jellyfin 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Jellyfin Server 镜像文档

## 概述
Jellyfin Server 是一款开源免费的媒体服务器软件，旨在帮助用户集中管理、组织和流式传输个人媒体内容（如电影、电视节目、音乐、照片等）。作为开源解决方案，它提供了无广告、无订阅的媒体服务，支持多平台客户端访问，是构建个人或家庭媒体中心的理想选择。

## 核心功能

### 媒体库管理
- 自动扫描并组织媒体文件，支持电影、电视剧、音乐、照片等多种类型
- 自动获取媒体元数据（海报、封面、剧情简介、演员信息等）
- 支持自定义媒体分类和标签管理

### 多设备支持
- 兼容Web浏览器、移动设备（iOS/Android）、智能电视、流媒体设备（如Fire TV、Roku）等
- 提供统一的媒体访问体验，支持断点续播

### 媒体转码
- 内置实时转码功能，可根据设备性能和网络状况自动调整媒体质量
- 支持硬件加速转码（如Intel Quick Sync、NVIDIA NVENC），降低CPU占用

### 用户与权限管理
- 多用户账户支持，可创建独立的媒体库访问权限
- 家长控制功能，可限制儿童访问内容

## 使用场景

### 家庭媒体中心
集中存储和管理家庭媒体文件，家庭成员可通过各自设备访问，无需重复存储

### 个人媒体服务器
随时随地通过互联网访问个人媒体库，支持远程访问配置

### 小型团队/社区媒体分享
安全共享指定媒体内容，控制访问权限和范围

## 使用方法

### 基本部署（Docker Run）
```bash
docker run -d \
  --name jellyfin \
  -p 8096:8096 \  # Web管理界面及HTTP流媒体端口
  -p 8920:8920 \  # HTTPS流媒体端口（可选）
  -v /path/to/config:/config \  # 配置文件存储目录
  -v /path/to/media:/media \    # 媒体文件存储目录
  -v /path/to/cache:/cache \    # 转码缓存目录
  --restart unless-stopped \    # 容器退出时自动重启
  jellyfin/jellyfin
```

### Docker Compose 配置
```yaml
version: '3.8'
services:
  jellyfin:
    image: docker.xuanyuan.run/jellyfin/jellyfin
    container_name: jellyfin
    ports:
      - "8096:8096"
      - "8920:8920"
    volumes:
      - /path/to/config:/config
      - /path/to/media:/media
      - /path/to/cache:/cache
      - /path/to/transcode:/transcode  # 可选，指定独立转码目录
    environment:
      - PUID=1000          # 运行容器的用户ID（避免权限问题）
      - PGID=1000          # 运行容器的用户组ID
      - TZ=Asia/Shanghai   # 设置时区
    restart: unless-stopped
```

### 初始配置
1. 容器启动后，通过 `http://<服务器IP>:8096` 访问Web管理界面
2. 按照向导完成初始设置：创建管理员账户、添加媒体库、配置网络访问等
3. 在媒体库设置中指定 `/media` 目录下的媒体文件夹，系统将自动扫描并组织内容

### 关键配置说明

#### 数据卷挂载
- `/config`: 存储服务器配置、用户数据、元数据等，必须持久化
- `/media`: 媒体文件存储目录，需确保容器对该目录有读取权限
- `/cache`: 转码缓存目录，建议使用SSD以提升转码性能

#### 环境变量
- `PUID`/`PGID`: 指定运行容器的用户ID和组ID，避免权限问题
- `TZ`: 设置时区（如Asia/Shanghai），确保时间显示正确
- `JELLYFIN_OPTS`: 额外启动参数（如 `--ffmpeg-path /usr/local/ffmpeg/bin/ffmpeg` 指定自定义FFmpeg路径）

## 注意事项
- **媒体文件权限**：确保挂载的 `/media` 目录及文件对容器内用户有读取权限
- **硬件转码**：如需启用硬件转码，需添加设备映射（如 `--device /dev/dri:/dev/dri` 用于Intel核显）
- **性能优化**：转码对CPU/显卡资源消耗较大，建议根据硬件配置调整转码质量和并发数
- **安全配置**：公网访问时建议启用HTTPS并配置访问控制（如IP白名单、密码策略）
