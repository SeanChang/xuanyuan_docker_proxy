---
image: linuxserver/emby
description: "LinuxServer维护的Emby媒体服务器Docker镜像，提供专业的家庭媒体中心解决方案，可集中管理电影、剧集、音乐、照片等多媒体资源，并通过网页或客户端向多设备（如智能电视、手机、平板）流式传输内容。支持自动转码、字幕匹配、元数据搜刮，配备直观的Web管理界面，支持用户权限管理、播放历史同步及个性化推荐。容器化部署确保环境隔离与快速更新，适合家庭或小型团队搭建私有媒体服务。"
source: https://xuanyuan.cloud/zh/r/linuxserver/emby
canonical: https://xuanyuan.cloud/zh/r/linuxserver/emby
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/emby" title="linuxserver/emby Docker 镜像中文简介、标签列表与拉取命令">linuxserver/emby 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LinuxServer.io emby 容器介绍


## 关于 LinuxServer.io 团队  
LinuxServer.io 团队专注于提供高质量容器化应用，其容器具有以下特点：  
- 定期、及时的应用更新  
- 简单的用户权限映射（通过 PUID、PGID）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周更新基础系统，通过通用层减少存储空间、 downtime 和带宽占用  
- 常规安全更新  


## 容器概述  
[emby]([]) 是一款媒体服务器软件，可整理个人媒体库（视频、音乐、直播电视、照片等），并流式传输到智能电视、机顶盒和移动设备。本容器为独立的 emby 媒体服务器打包版本。  


## 支持的架构  
通过 Docker manifest 实现多平台支持，拉取 `lscr.io/linuxserver/emby:latest` 即可自动匹配对应架构，也可通过标签指定具体架构：  

| 架构       | 支持状态 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅        | amd64-\<version tag\>  |  
| arm64      | ✅        | arm64v8-\<version tag\>|  


## 版本标签  
提供以下标签，选择时注意稳定性：  

| 标签    | 支持状态 | 说明                 |  
|---------|----------|----------------------|  
| latest  | ✅        | emby 稳定版发布      |  
| beta    | ✅        | emby 测试版发布      |  


## 应用设置  
- Web 管理界面地址：`http://<你的IP>:8096`  
- 详细官方文档：[emby 文档]([])  


### 硬件加速配置  
根据硬件类型，需额外配置设备挂载以启用硬件加速：  

#### 树莓派 OpenMAX  
需挂载视频设备和系统 OpenMax 库，运行/创建容器时添加参数：  
```  
--device=/dev/vcsm:/dev/vcsm  
--device=/dev/vchiq:/dev/vchiq  
-v /opt/vc/lib:/opt/vc/lib  
```  

#### 树莓派 V4L2  
需挂载视频设备，添加参数：  
```  
--device=/dev/video10:/dev/video10  
--device=/dev/video11:/dev/video11  
--device=/dev/video12:/dev/video12  
```  

#### Intel/AMD 显卡  
挂载 GPU 设备以启用硬件加速，添加参数：  
```  
--device=/dev/dri:/dev/dri  
```  

#### Nvidia 显卡  
1. 先在主机安装 [nvidia-container-toolkit]([])  
2. 创建容器时添加运行时和环境变量：  
```  
--runtime=nvidia  
-e NVIDIA_VISIBLE_DEVICES=all  # 或指定 GPU 的 UUID（通过 `nvidia-smi --query-gpu=gpu_name,gpu_uuid --format=csv` 获取）  
```  

#### Arm 设备  
若主机存在 `/dev/dri`，通常可直接使用。树莓派 4 需在 `usercfg.txt` 中启用 `dtoverlay=vc4-fkms-v3d`。  


## 使用方法  
可通过 docker-compose（推荐）或 docker cli 部署容器。  


### docker-compose 配置  
创建 `docker-compose.yml` 文件，内容如下：  

```yaml  
---  
services:  
  emby:  
    image: lscr.io/linuxserver/emby:latest  
    container_name: emby  
    environment:  
      - PUID=1000        # 用户ID，需替换为实际值  
      - PGID=1000        # 组ID，需替换为实际值  
      - TZ=Etc/UTC       # 时区，如 Asia/Shanghai  
    volumes:  
      - /path/to/emby/library:/config   # emby 配置存储路径（必选）  
      - /path/to/tvshows:/data/tvshows  # 媒体文件路径（可添加多个）  
      - /path/to/movies:/data/movies    # 媒体文件路径（可添加多个）  
      - /opt/vc/lib:/opt/vc/lib         # 树莓派 OpenMAX 库（可选）  
    ports:  
      - 8096:8096       # Web UI 端口（必选）  
      - 8920:8920       # HTTPS 端口（需自行配置证书，可选）  
    devices:  
      - /dev/dri:/dev/dri               # Intel/AMD 硬件加速（可选）  
      - /dev/vchiq:/dev/vchiq           # 树莓派 OpenMAX（可选）  
      - /dev/video10:/dev/video10       # 树莓派 V4L2（可选）  
      - /dev/video11:/dev/video11       # 树莓派 V4L2（可选）  
      - /dev/video12:/dev/video12       # 树莓派 V4L2（可选）  
    restart: unless-stopped  
```  


### docker cli 命令  
直接运行以下命令（替换路径和参数）：  

```bash  
docker run -d \  
  --name=emby \  
  -e PUID=1000 \  
  -e PGID=1000 \  
  -e TZ=Etc/UTC \  
  -p 8096:8096 \  
  -p 8920:8920 `# 可选` \  
  -v /path/to/emby/library:/config \  
  -v /path/to/tvshows:/data/tvshows \  
  -v /path/to/movies:/data/movies \  
  -v /opt/vc/lib:/opt/vc/lib `# 可选` \  
  --device /dev/dri:/dev/dri `# 可选` \  
  --device /dev/vchiq:/dev/vchiq `# 可选` \  
  --device /dev/video10:/dev/video10 `# 可选` \  
  --device /dev/video11:/dev/video11 `# 可选` \  
  --device /dev/video12:/dev/video12 `# 可选` \  
  --restart unless-stopped \  
  lscr.io/linuxserver/emby:latest  
```  


## 参数说明  
| 参数                  | 功能说明                                                                 |  
|-----------------------|--------------------------------------------------------------------------|  
| `-p 8096:8096`        | HTTP Web UI 端口（必选）                                                |  
| `-p 8920`             | HTTPS Web UI 端口（需自行配置证书，可选）                                |  
| `-e PUID=1000`        | 用户 ID，通过 `id your_user` 命令获取（必选）                            |  
| `-e PGID=1000`        | 组 ID，通过 `id your_user` 命令获取（必选）                              |  
| `-e TZ=Etc/UTC`       | 时区，如 `Asia/Shanghai`（必选）                                         |  
| `-v /config`          | emby 配置存储路径（必选，建议分配 50GB+ 空间）                           |  
| `-v /data/tvshows`    | 媒体文件路径（可添加多个，如 `/data/movies`、`/data/music` 等）          |  
| `-v /opt/vc/lib`      | 树莓派 OpenMAX 库路径（可选）                                            |  
| `--device /dev/dri`   | Intel/AMD 硬件加速设备（可选）                                           |  
| `--device /dev/vchiq` | 树莓派 OpenMAX 设备（可选）                                              |  
| `--device /dev/video*`| 树莓派 V4L2 设备（可选）                                                 |  


## 用户/组 ID 设置  
为避免权限问题，需确保容器内用户 ID（PUID）和组 ID（PGID）与主机媒体文件所有者一致。通过以下命令获取当前用户的 PUID 和 PGID：  
```bash  
id your_user  
```  
示例输出：`uid=1000(your_user) gid=1000(your_user)`，则 PUID=1000、PGID=1000。  


## 容器管理  

### 查看日志  
```bash  
docker logs -f emby  
```  

### 进入容器终端  
```bash  
docker exec -it emby /bin/bash  
```  

### 检查容器版本  
```bash  
docker inspect -f '{{ index .Config.Labels "build_version" }}' emby  
```  


## 更新容器  

### 通过 docker-compose  
```bash  
# 拉取最新镜像  
docker-compose pull emby  

# 更新容器  
docker-compose up -d emby  

# 清理旧镜像  
docker image prune  
```  

### 通过 docker run  
```bash  
# 拉取最新镜像  
docker pull lscr.io/linuxserver/emby:latest  

# 停止并删除旧容器  
docker stop emby && docker rm emby  

# 用原参数重新创建容器（配置会保留在 /config 目录）  
docker run -d [原参数] lscr.io/linuxserver/emby:latest  
```  


## 版本历史（部分）  
- **2024.08.13**：基于 Ubuntu Noble 重构  
- **2023.07.06**：移除 armhf 架构支持  
- **2022.09.18**：迁移至 s6v3，基于 Ubuntu Jammy 重构  
- **2020.07.03**：支持 AMD VAAPI 硬件转码  
- **2020.02.26**：添加树莓派 OpenMAX 支持  
- **2019.05.30**：初始发布  


## 支持与资源  
- 官方文档：[emby 文档]([])  
- 社区支持：[LinuxServer.io ]()、[论坛]([])  
- 代码仓库：[GitHub]([])
