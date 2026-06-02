---
image: linuxserver/plex
description: "这是由LinuxServer.io为您提供的Plex Media Server容器，它是一款集成了Plex媒体服务器软件的轻量级、可移植Docker容器，能够帮助用户高效组织电影、音乐、照片等各类媒体文件，并支持跨设备流式传输与访问，适用于搭建个人或家庭媒体中心；LinuxServer.io作为专注开源容器开发的组织，致力于提供高质量、易于部署的容器镜像，此Plex Media Server容器便是其优质作品，为媒体管理与分享带来便捷体验。"
source: https://xuanyuan.cloud/zh/r/linuxserver/plex
canonical: https://xuanyuan.cloud/zh/r/linuxserver/plex
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/plex" title="linuxserver/plex Docker 镜像中文简介、标签列表与拉取命令">linuxserver/plex 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LinuxServer.io Plex 容器介绍


## LinuxServer.io 团队简介  
[LinuxServer.io]([]) 团队专注于提供高质量容器化应用，其容器具有以下特点：  
- 定期、及时的应用更新  
- 简单的用户权限映射（通过 PGID、PUID）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周更新基础操作系统，通过共享通用层减少存储空间占用、 downtime 和带宽消耗  
- 常规安全更新  


## 社区与支持  
如需了解更多或寻求帮助，可通过以下渠道联系我们：  
- [博客]([])：包含容器使用指南、教程和观点文章  
- []()：实时社区聊天与技术支持  
- [Discourse]([])：社区论坛，可发布问题和讨论  
- [GitHub]([])：查看所有仓库源码  
- [Open Collective]([])：支持我们的开发工作（捐赠或贡献预算）  


# linuxserver/plex 容器  

[Plex]([]) 是一款媒体服务器软件，可整理个人媒体库（视频、音乐、照片）并流式传输到智能电视、机顶盒和移动设备。本容器为独立的 Plex Media Server 打包版本，设计简洁，支持批量操作，提升使用效率。  


## 支持的架构  
容器通过 Docker manifest 实现多平台支持，拉取 `lscr.io/linuxserver/plex:latest` 即可自动匹配对应架构。也可通过标签指定具体架构：  

| 架构       | 支持状态 | 标签格式               |  
| :--------- | :------- | :--------------------- |  
| x86-64     | ✅        | amd64-\<version tag\>   |  
| arm64      | ✅        | arm64v8-\<version tag\> |  


## 应用设置  
Web 管理界面地址：`<你的IP>:32400/web`  

### 版本更新说明  
- **注意**：若未设置 `VERSION` 变量，容器不会自动更新 Plex。  
- **注意**：新用户首次运行容器时不会触发更新（因缺少偏好文件中的令牌），需通过 Web 界面登录后重启容器以应用更新。  

`VERSION` 变量的有效值：  
- **`docker`**：由 Docker 管理版本（默认，保持与 Dockerhub 镜像同步）  
- **`latest`**：更新至当前账号有权访问的最新版本  
- **`public`**：PlexPass 用户可更新至最新公开版本（避免测试版）  
- **`<specific-version>`**：指定具体版本（如 `0.9.12.4.1192-9a47d21`），需注意：非 PlexPass 账号无法访问测试版  


### 硬件加速  
#### Intel/ATI/AMD  
需将显卡设备挂载到容器内：  
```bash  
--device=/dev/dri:/dev/dri  
```  
容器会自动配置 `abc` 用户对设备的访问权限。  

#### Nvidia  
需先在主机安装 [nvidia-container-toolkit]([])，然后启动容器时添加：  
```bash  
--runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=all  
```  
（`NVIDIA_VISIBLE_DEVICES` 可指定 GPU 的 UUID，通过 `nvidia-smi --query-gpu=gpu_name,gpu_uuid --format=csv` 获取）  

#### Arm 设备  
大多数 Arm 设备（如树莓派 4）需在 `/boot/usercfg.txt` 中启用 `dtoverlay=vc4-fkms-v3d`，容器会自动识别 `/dev/dri` 设备。  


## 只读模式运行  
容器支持只读文件系统，详情参考 [官方文档]([])。  

**限制**：  
- 不支持运行时更新 Plex（含 PlexPass 测试版）  
- 需将转码目录挂载到主机路径或 tmpfs  


## 非 root 用户运行  
容器支持非 root 用户运行，详情参考 [官方文档]([])。  

**限制**：  
- 不支持运行时更新 Plex（含 PlexPass 测试版）  
- 需将转码目录挂载到主机路径或 tmpfs  


## 使用方法  
### docker-compose（推荐）  
```yaml  
---  
services:  
  plex:  
    image: lscr.io/linuxserver/plex:latest  
    container_name: plex  
    network_mode: host  
    environment:  
      - PUID=1000          # 用户ID（必填）  
      - PGID=1000          # 组ID（必填）  
      - TZ=Etc/UTC         # 时区（必填，如 Asia/Shanghai）  
      - VERSION=docker     # 版本控制（必填，参考上文说明）  
      - PLEX_CLAIM=        # 可选，Plex 服务器认领令牌（从 [] 获取，4分钟内有效）  
    volumes:  
      - /path/to/plex/library:/config  # Plex 配置目录（必填，建议预留50GB以上空间）  
      - /path/to/tvseries:/tv          # 电视剧目录（可选，可添加多个）  
      - /path/to/movies:/movies        # 电影目录（可选，可添加多个）  
    restart: unless-stopped  
```  

### docker cli  
```bash  
docker run -d \  
  --name=plex \  
  --net=host \  
  -e PUID=1000 \  
  -e PGID=1000 \  
  -e TZ=Etc/UTC \  
  -e VERSION=docker \  
  -e PLEX_CLAIM= `#可选` \  
  -v /path/to/plex/library:/config \  
  -v /path/to/tvseries:/tv \  
  -v /path/to/movies:/movies \  
  --restart unless-stopped \  
  lscr.io/linuxserver/plex:latest  
```  


## 参数说明  

| 参数                  | 作用                                                                 |  
| :-------------------- | :------------------------------------------------------------------- |  
| `--net=host`          | 使用主机网络模式（推荐）                                               |  
| `-e PUID=1000`        | 用户ID，用于权限映射（通过 `id 你的用户名` 查看）                       |  
| `-e PGID=1000`        | 组ID，同上                                                           |  
| `-e TZ=Etc/UTC`       | 时区，如 `Asia/Shanghai`                                             |  
| `-e VERSION=docker`   | 版本控制（见“应用设置”部分）                                          |  
| `-e PLEX_CLAIM=`      | Plex 认领令牌（可选，有效期4分钟）                                     |  
| `-v /config`          | Plex 配置目录（存储媒体库信息，需大容量空间）                          |  
| `-v /tv`              | 媒体目录（可添加多个，如 `/movies`、`/photos`）                        |  
| `--read-only=true`    | 只读模式运行（需配合文档配置）                                        |  
| `--user=1000:1000`    | 非 root 用户运行（指定 UID:GID）                                      |  


## 环境变量与文件（Docker Secrets）  
可通过 `FILE__` 前缀从文件加载环境变量，例如：  
```bash  
-e FILE__MYVAR=/run/secrets/mysecretvariable  
```  
容器会将 `/run/secrets/mysecretvariable` 文件内容作为 `MYVAR` 的值。  


## Umask 设置  
通过 `-e UMASK=022` 自定义服务的文件权限掩码（参考 [umask 说明]()）。  


## 可选参数  
### 桥接网络模式（不推荐）  
若需使用桥接模式（非 host 网络），需映射端口（[官方端口说明]([])）：  
```bash  
-p 32400:32400 \         # 必选  
-p 1900:1900/udp \       # 可选  
-p 5353:5353/udp \       # 可选  
-p 8324:8324 \           # 可选  
-p 32410:32410/udp \     # 可选  
-p 32412:32412/udp \     # 可选  
-p 32413:32413/udp \     # 可选  
-p 32414:32414/udp \     # 可选  
-p 32469:32469           # 可选  
```  
首次设置需通过 `PLEX_CLAIM` 认领服务器。  

### 设备挂载  
- 硬件加速：`--device=/dev/dri:/dev/dri`（Intel/AMD）  
- DVB 调谐器：`--device=/dev/dvb:/dev/dvb`  


## 用户/组标识符  
使用 `-v` 挂载卷时，需确保主机目录所有者与容器内 `PUID/PGID` 一致，避免权限问题。通过以下命令查看当前用户的 UID/GID：  
```bash  
id 你的用户名  
```  
示例输出：  
```text  
uid=1000(你的用户名) gid=1000(你的用户名) groups=1000(你的用户名)  
```  


## Docker Mods  
可通过 [Docker Mods]([]) 扩展容器功能，查看可用模块：  
- [Plex 专用 Mods]([])  
- [通用 Mods]([])  


## 支持信息  
- 进入运行中的容器：  
  ```bash  
  docker exec -it plex /bin/bash  
  ```  
- 实时查看日志：  
  ```bash  
  docker logs -f plex  
  ```  
- 查看容器版本：  
  ```bash  
  docker inspect -f '{{ index .Config.Labels "build_version" }}' plex  
  ```  
- 查看镜像版本：  
  ```bash  
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/plex:latest  
  ```  


## 更新说明  
### 通过 docker-compose  
- 更新镜像：  
  ```bash  
  docker-compose pull  # 更新所有镜像  
  # 或  
  docker-compose pull plex  # 仅更新 plex  
  ```  
- 重启容器：  
  ```bash  
  docker-compose up -d  # 重启所有容器  
  # 或  
  docker-compose up -d plex  # 仅重启 plex  
  ```  
- 清理旧镜像：  
  ```bash  
  docker image prune  
  ```  

### 通过 docker cli  
- 更新镜像：  
  ```bash  
  docker pull lscr.io/linuxserver/plex:latest  
  ```  
- 重启容器：  
  ```bash  
  docker stop plex && docker rm plex  
  # 重新运行 docker run 命令（配置会保留在 /config 卷中）  
  ```  


## 本地构建  
如需自定义镜像，可本地构建：  
```bash  
git clone []  
cd docker-plex  
docker build \  
  --no-cache \  
  --pull \  
  -t lscr.io/linuxserver/plex:latest .  
```  
跨架构构建（如 x86_64 构建 arm64）：  
```bash  
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset  
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/plex:latest .  
```  


## 版本历史  
- **04.11.24**：添加 H.265 所需的 Nvidia 功能  
- **18.07.24**：基于 Ubuntu Noble 重构  
- **12.02.24**：统一硬件加速说明文档  
- **09.01.24**：修复转码目录权限问题  
- **16.08.23**：从 LinuxServer 仓库安装 unrar  
- **03.07.23**：停止支持 armhf 架构  
- **16.10.22**：基于 Ubuntu Jammy 重构，升级 s6v3，移除独立 OpenCL 包（Plex 已内置）  
- **25.12.21**：从官方仓库安装 Intel 驱动  
- **20.01.21**：使用 baseimage 内置的 UMASK 变量，替代 `UMASK_SET`  
- **10.12.20**：添加 Intel 最新 Compute 包以支持新一代核显 OpenCL  
- **23.11.20**：添加 Bionic 分支，默认使用 Focal  
- **03.05.20**：更新桥接模式端口说明  
- **23.03.20**：移除 udev 兼容补丁，优化首次启动日志  
- **04.12.19**：添加 `PLEX_CLAIM` 变量，移除 `/transcode` 卷（Plex 已默认使用 `/config` 下目录）  
- **06.08.19**：添加 UMASK 变量支持  
- **10.07.19**：修复 DVB 调谐器权限  
- **20.05.19**：修复 Intel QuickSync 权限配置  
- **23.03.19**：切换至新基础镜像，使用 arm32v7 标签  
- **22.03.19**：修复 `VERSION=public` 更新逻辑  
- **14.03.19**：更新 API 端点，支持 armhf/aarch64 的 PlexPass 测试版更新  
- **15.02.19**：优化 Plex 进程清理逻辑  
- **11.02.19**：修复 Nvidia 变量，添加设备挂载说明  
- **16.01.19**：添加多架构支持和硬件转码配置，移除 avahi 服务  
- **07.09.18**：基于 Ubuntu Bionic 重构，添加 udev 包  
- **28.05.17**：添加 unrar 包（支持 Subzero 插件）  
- **11.01.17**：使用 Plex 官方环境变量，优化用户目录权限  
- **03.01.17**：优化版本变量匹配逻辑  
- **17.10.16**：支持大写版本变量  
- **01.10.16**：补充时区设置说明  
- **09.09.16**：添加镜像层信息标签  
- **22.08.16**：基于 Ubuntu Xenial 和 s6 overlay 重构  
- **07.04.16**：移除 `/transcode` 卷支持，优化 PlexPass 下载逻辑  
- **24.09.15**：添加转码卷支持，修复文档 typo  
- **17.09.15**：优化权限配置逻辑  
- **19.09.15**：更新 Plex 下载链接为 HTTPS  
- **28.08.15**：重构版本控制逻辑  
- **18.07.15**：迁移自动更新服务至 LinuxServer.io，修复 bug  
- **09.07.15**：支持指定具体版本号  
- **08.07.15**：添加自动更新功能  
- **03.07.15**：修复用户权限问题（使用 abc 用户而非 plex）
