---
image: lsiodev/jellyfin
description: "LinuxServer.io的Jellyfin镜像为开源媒体服务器，用于管理、转码和流式传输音视频文件，支持多设备访问，配置优化且易于部署。"
source: https://xuanyuan.cloud/zh/r/lsiodev/jellyfin
canonical: https://xuanyuan.cloud/zh/r/lsiodev/jellyfin
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/lsiodev/jellyfin" title="lsiodev/jellyfin Docker 镜像中文简介、标签列表与拉取命令">lsiodev/jellyfin 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LinuxServer.io Jellyfin Docker镜像文档

## 镜像概述和主要用途

[Jellyfin](https://github.com/jellyfin/jellyfin) 是一个自由软件媒体系统，让您能够控制媒体的管理和流式传输。它是专有软件Emby和Plex的替代方案，可通过多个应用程序从专用服务器向终端用户设备提供媒体服务。Jellyfin源自Emby 3.5.2版本，移植到.NET Core框架以实现全跨平台支持。无附加条件、无高级许可或功能限制，也无隐藏议程：由团队协作构建更优质的媒体解决方案。

LinuxServer.io团队提供的此镜像具有以下特点：
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 基于s6 overlay的自定义基础镜像
- 每周基础操作系统更新，跨LinuxServer.io生态系统共享通用层，以最小化空间占用、 downtime和带宽
- 定期安全更新


## 核心功能和特性

- **多平台媒体管理**：支持管理电影、电视节目、音乐、照片等多种媒体类型
- **流式传输能力**：向多种终端设备（手机、平板、智能电视、电脑等）提供媒体流服务
- **硬件加速**：支持Intel Quicksync、Nvidia GPU、Raspberry Pi MMAL/OpenMAX等硬件加速方案，提升 transcoding性能
- **用户权限管理**：可创建多用户并设置不同媒体访问权限
- **自动媒体元数据获取**：自动下载电影海报、剧情简介、演员信息等元数据
- **多架构支持**：兼容x86-64、arm64v8架构
- **灵活配置**：通过环境变量和卷映射实现个性化部署


## 使用场景和适用范围

- **家庭媒体服务器**：集中管理家庭媒体库，支持多设备访问
- **个人媒体中心**：整理个人收藏的电影、音乐和照片，随时随地访问
- **小型团队共享**：在小团队内部共享培训视频、演示材料等媒体内容
- **替代商业媒体服务**：无需订阅Plex/Emby等商业服务，自建免费媒体系统


## 支持的架构

该镜像利用Docker manifest实现多平台支持，拉取`lscr.io/linuxserver/jellyfin:latest`即可自动获取适合您架构的镜像，也可通过标签指定特定架构。

| 架构 | 支持情况 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |
| armhf | ❌ | |


## 版本标签

| 标签 | 支持情况 | 描述 |
| :----: | :----: |--- |
| latest | ✅ | Jellyfin稳定版本 |
| nightly | ✅ | Jellyfin夜间构建版本 |


## 应用设置

Web界面可通过 `http://<您的IP>:8096` 访问。

更多信息请参考官方文档：[Jellyfin快速入门](https://jellyfin.org/docs/general/quick-start.html)


## 硬件加速

### Intel (Quicksync)

Intel Quicksync硬件加速用户需将`/dev/dri`视频设备挂载到容器中，运行或创建容器时添加以下参数：

```bash
--device=/dev/dri:/dev/dri
```

容器会自动确保内部abc用户具有访问该设备的适当权限。

如需启用基于OpenCL的DV、HDR10和HLG色调映射，请参考：[OpenCL-Intel mod](https://mods.linuxserver.io/?mod=jellyfin)


### Nvidia

Nvidia硬件加速用户需在主机上安装Nvidia提供的容器运行时，安装说明：[nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

容器会自动添加必要的环境变量以利用主机GPU的所有功能。安装nvidia-docker后，需使用nvidia容器运行时重新创建容器：

```bash
--runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=all
```

（`NVIDIA_VISIBLE_DEVICES`也可设置为特定GPU的UUID，可通过`nvidia-smi --query-gpu=gpu_name,gpu_uuid --format=csv`命令获取）


### Raspberry Pi (OpenMAX/MMAL)

Raspberry Pi MMAL/OpenMAX硬件加速用户需挂载`/dev/vcsm`和`/dev/vchiq`视频设备及系统OpenMax库，运行或创建容器时添加以下参数：

```bash
--device=/dev/vcsm:/dev/vcsm
--device=/dev/vchiq:/dev/vchiq
-v /opt/vc/lib:/opt/vc/lib
```


### Raspberry Pi (V4L2)

Raspberry Pi V4L2硬件加速用户需挂载`/dev/video1X`设备，运行或创建容器时添加以下参数：

```bash
--device=/dev/video10:/dev/video10
--device=/dev/video11:/dev/video11
--device=/dev/video12:/dev/video12
```


## 部署方法

### Docker Compose (推荐)

```yaml
---
version: "2.1"
services:
  jellyfin:
    image: docker.xuanyuan.run/linuxserver/jellyfin:latest
    container_name: jellyfin
    environment:
      - PUID=1000               # 用户ID
      - PGID=1000               # 组ID
      - TZ=Etc/UTC              # 时区
      - JELLYFIN_PublishedServerUrl=192.168.0.5  # 可选，自动发现响应的域名或IP
    volumes:
      - /path/to/library:/config  # Jellyfin数据存储位置
      - /path/to/tvseries:/data/tvshows  # 电视节目媒体目录
      - /path/to/movies:/data/movies      # 电影媒体目录
    ports:
      - 8096:8096               # HTTP WebUI
      - 8920:8920               # 可选，HTTPS WebUI（需自行配置证书）
      - 7359:7359/udp           # 可选，本地网络客户端发现
      - 1900:1900/udp           # 可选，DNLA和客户端使用的服务发现
    restart: unless-stopped
```


### Docker Run

```bash
docker run -d \
  --name=jellyfin \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e JELLYFIN_PublishedServerUrl=192.168.0.5 `# 可选` \
  -p 8096:8096 \
  -p 8920:8920 `# 可选` \
  -p 7359:7359/udp `# 可选` \
  -p 1900:1900/udp `# 可选` \
  -v /path/to/library:/config \
  -v /path/to/tvseries:/data/tvshows \
  -v /path/to/movies:/data/movies \
  --restart unless-stopped \
  lscr.io/linuxserver/jellyfin:latest
```


## 参数说明

容器通过运行时参数配置，格式为`<外部>:<内部>`。

### 端口参数

| 参数 | 功能 |
| :----: | --- |
| `-p 8096` | HTTP WebUI访问端口 |
| `-p 8920` | 可选，HTTPS WebUI访问端口（需自行配置证书） |
| `-p 7359/udp` | 可选，允许客户端在本地网络发现Jellyfin |
| `-p 1900/udp` | 可选，DNLA和客户端使用的服务发现端口 |


### 环境变量参数

| 参数 | 功能 |
| :----: | --- |
| `-e PUID=1000` | 用户ID，详见下方用户/组ID说明 |
| `-e PGID=1000` | 组ID，详见下方用户/组ID说明 |
| `-e TZ=Etc/UTC` | 指定时区，参考[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e JELLYFIN_PublishedServerUrl=192.168.0.5` | 设置自动发现响应的域名或IP地址 |


### 卷参数

| 参数 | 功能 |
| :----: | --- |
| `-v /config` | Jellyfin数据存储位置，*大型媒体库可能需要50GB以上空间* |
| `-v /data/tvshows` | 媒体文件目录，可添加多个，如`/data/movies`、`/data/music`等 |
| `-v /data/movies` | 媒体文件目录，可添加多个，如`/data/movies`、`/data/tv`等 |


## 高级配置

### 从文件加载环境变量（Docker Secrets）

可通过`FILE__`前缀从文件加载环境变量：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

上述命令会将`MYVAR`环境变量设置为`/run/secrets/mysecretvariable`文件的内容。


### 应用Umask设置

可通过`-e UMASK=022`覆盖容器内服务的默认umask设置。注意umask是权限减法而非加法，详情参考[umask说明](https://en.wikipedia.org/wiki/Umask)。


### 可选参数

官方文档中提到的其他端口可用于自动发现：
- 服务发现（`1900/udp`）：客户端自动发现和DNLA功能所需，需在本地子网
- 客户端发现（`7359/udp`）：客户端发送"Who is Jellyfin Server?"广播获取服务器信息

更多环境变量配置参考[官方文档](https://jellyfin.org/docs/general/administration/configuration.html)。


## 用户/组ID

使用卷映射（`-v`）时，主机与容器可能出现权限问题。通过指定`PUID`和`PGID`可避免此问题，确保主机卷目录所有者与指定的用户/组ID一致。

通过以下命令获取当前用户的PUID和PGID：

```bash
id your_user
```

示例输出：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```


## Docker Mods

可通过Docker Mods扩展容器功能：
- [Jellyfin专用Mods](https://mods.linuxserver.io/?mod=jellyfin)
- [通用Mods](https://mods.linuxserver.io/?mod=universal)


## 支持与维护

### 容器管理命令

- 容器内shell访问：
  ```bash
  docker exec -it jellyfin /bin/bash
  ```

- 实时查看容器日志：
  ```bash
  docker logs -f jellyfin
  ```

- 查看容器版本号：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' jellyfin
  ```

- 查看镜像版本号：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/jellyfin:latest
  ```


### 更新方法

大部分镜像为静态版本，需更新镜像并重建容器以更新应用。

#### 通过Docker Compose更新

- 更新镜像：
  ```bash
  # 更新所有镜像
  docker-compose pull
  # 仅更新jellyfin镜像
  docker-compose pull jellyfin
  ```

- 更新容器：
  ```bash
  # 更新所有容器
  docker-compose up -d
  # 仅更新jellyfin容器
  docker-compose up -d jellyfin
  ```

- 清理旧镜像：
  ```bash
  docker image prune
  ```


#### 通过Docker Run更新

- 更新镜像：
  ```bash
  docker pull docker.xuanyuan.run/linuxserver/jellyfin:latest
  ```

- 停止并删除当前容器：
  ```bash
  docker stop jellyfin
  docker rm jellyfin
  ```

- 使用相同参数重建容器（配置存储在`/config`卷中，会保留设置）


#### 通过Watchtower自动更新（不推荐）

仅在忘记原始参数时使用：
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker.xuanyuan.run/containrrr/watchtower \
  --run-once jellyfin
```


## 本地构建

如需本地修改或开发：
```bash
git clone https://github.com/linuxserver/docker-jellyfin.git
cd docker-jellyfin
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/jellyfin:latest .
```

在x86_64硬件上构建ARM变体：
```bash
docker run --rm --privileged docker.xuanyuan.run/multiarch/qemu-user-static:register --reset
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/jellyfin:arm64v8-latest .
```


## 版本历史

- **12.09.23:** - 修复插件目录所有权
- **04.07.23:** - 弃用armhf架构，详见[公告](https://www.linuxserver.io/blog/a-farewell-to-arm-hf)
- **07.12.22:** - 基于Jammy重建，迁移至s6v3
- **11.06.22:** - 切换到上游仓库的ffmpeg5构建
- **05.01.22:** - 指定Intel iHD驱动版本，避免libva版本不匹配错误
- **25.12.21:** - 修复视频设备组权限错误消息
- **10.12.21:** - 重构README，禁用模板同步
- **22.09.21:** - 仅拉取服务器、Web和ffmpeg包，而非包装器
- **23.06.21:** - 添加设备权限错误日志消息，固定Jellyfin依赖版本，弃用`bionic`标签
- **21.05.21:** - 添加nvidia.icd文件，修复Nvidia硬件加速的色调映射问题
- **20.01.21:** - 添加Jellyfin二进制环境变量，弃用`UMASK_SET`，改用baseimage的UMASK
- **23.11.20:** - 基于Focal重建，从Bionic分支
- **22.07.20:** - 从Jellyfin仓库获取发布版本
- **28.04.20:** - 将MMAL/OMX依赖设备从`/dev/vc-mem`替换为`/dev/vcsm`
- **11.04.20:** - 启用Raspberry Pi的硬件解码（mmal），更新README说明，添加捐赠信息，创建默认转码文件夹
- **11.03.20:** - 添加Pi V4L2支持，移除可选转码映射（路径在GUI中选择，默认位于`/config`下）
- **30.01.20:** - 添加nightly标签
- **09.01.20:** - 添加Pi OpenMax支持
- **02.10.19:** - 改进render和dvb设备的权限修复
- **31.07.19:** - 添加AMD驱动以支持x86上的vaapi
- **13.06.19:** - 添加Intel驱动以支持x86上的vaapi
- **07.06.19:** - 初始发布
