---
image: lsiodev/emby
description: "LinuxServer.io提供的Emby媒体服务器Docker镜像，用于组织视频、音乐、直播电视和照片等个人媒体库，并流式传输到智能电视、流媒体设备和移动设备，支持硬件加速和多平台架构。"
source: https://xuanyuan.cloud/zh/r/lsiodev/emby
canonical: https://xuanyuan.cloud/zh/r/lsiodev/emby
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/lsiodev/emby" title="lsiodev/emby Docker 镜像中文简介、标签列表与拉取命令">lsiodev/emby 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/emby

Emby组织个人媒体库中的视频、音乐、直播电视和照片，并将它们流式传输到智能电视、流媒体设备和移动设备。此容器打包为独立的Emby媒体服务器。

![emby](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/emby-logo.png)

## 支持的架构

我们利用Docker manifest实现多平台支持。只需拉取`lscr.io/linuxserver/emby:latest`即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

此镜像支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-<version tag> |
| arm64 | ✅ | arm64v8-<version tag> |
| armhf | ❌ | |

## 版本标签

此镜像提供多种版本，可通过标签获取。使用不稳定或开发标签时请谨慎。

| 标签 | 可用 | 描述 |
| :----: | :----: |--- |
| latest | ✅ | 稳定的Emby版本 |
| beta | ✅ | Beta版Emby版本 |

## 应用设置

Web界面可通过 `http://<your-ip>:8096` 访问

Emby有非常完整和详细的文档，位于[这里](https://github.com/MediaBrowser/Wiki/wiki)。

Intel Quicksync和AMD VAAPI硬件加速用户需要通过在运行或创建容器时传递以下命令，将/dev/dri视频设备挂载到容器内：

```--device=/dev/dri:/dev/dri```

我们会自动确保容器内的abc用户具有访问此设备的适当权限。

Nvidia硬件加速用户需要在主机上安装Nvidia提供的容器运行时，说明可在此处找到：

https://github.com/NVIDIA/nvidia-docker

我们自动添加必要的环境变量，以利用主机GPU上可用的所有功能。在主机上安装nvidia-docker后，您需要使用nvidia容器运行时重新创建Docker容器`--runtime=nvidia`，并添加环境变量`-e NVIDIA_VISIBLE_DEVICES=all`（也可以设置为特定GPU的UUID，可通过运行`nvidia-smi --query-gpu=gpu_name,gpu_uuid --format=csv`发现）。NVIDIA会自动将GPU和驱动程序从主机挂载到Emby容器中。

### OpenMAX（树莓派）

树莓派OpenMAX硬件加速用户需要将/dev/vchiq视频设备和系统OpenMax库挂载到容器内，方法是在运行或创建容器时传递以下选项：
```
--device=/dev/vchiq:/dev/vchiq
-v /opt/vc/lib:/opt/vc/lib
```

### V4L2（树莓派）

树莓派V4L2硬件加速用户需要将/dev/video1X设备挂载到容器内，方法是在运行或创建容器时传递以下选项：
```
--device=/dev/video10:/dev/video10
--device=/dev/video11:/dev/video11
--device=/dev/video12:/dev/video12
```

## 使用方法

以下是一些示例代码片段，帮助您开始创建容器。

### docker-compose（推荐，[点击此处了解更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
version: "2.1"
services:
  emby:
    image: lscr.io/linuxserver/emby:latest
    container_name: emby
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/library:/config
      - /path/to/tvshows:/data/tvshows
      - /path/to/movies:/data/movies
      - /opt/vc/lib:/opt/vc/lib #可选
    ports:
      - 8096:8096
      - 8920:8920 #可选
    devices:
      - /dev/dri:/dev/dri #可选
      - /dev/vchiq:/dev/vchiq #可选
      - /dev/video10:/dev/video10 #可选
      - /dev/video11:/dev/video11 #可选
      - /dev/video12:/dev/video12 #可选
    restart: unless-stopped
```

### docker cli（[点击此处了解更多信息](https://docs.docker.com/engine/reference/commandline/cli/)）

```bash
docker run -d \
  --name=emby \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 8096:8096 \
  -p 8920:8920 `#可选` \
  -v /path/to/library:/config \
  -v /path/to/tvshows:/data/tvshows \
  -v /path/to/movies:/data/movies \
  -v /opt/vc/lib:/opt/vc/lib `#可选` \
  --device /dev/dri:/dev/dri `#可选` \
  --device /dev/vchiq:/dev/vchiq `#可选` \
  --device /dev/video10:/dev/video10 `#可选` \
  --device /dev/video11:/dev/video11 `#可选` \
  --device /dev/video12:/dev/video12 `#可选` \
  --restart unless-stopped \
  lscr.io/linuxserver/emby:latest
```

## 参数

容器镜像通过运行时传递的参数进行配置（如上所示）。这些参数用冒号分隔，表示`<外部>:<内部>`。例如，`-p 8080:80`会将容器内的端口`80`暴露出来，可通过主机IP的`8080`端口访问。

| 参数 | 功能 |
| :----: | --- |
| `-p 8096` | Http web界面。 |
| `-p 8920` | Https web界面（需要自行设置证书）。 |
| `-e PUID=1000` | 用户ID - 详见下方说明 |
| `-e PGID=1000` | 组ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见此[列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)。 |
| `-v /config` | Emby数据存储位置。*这可能会变得非常大，大型媒体库可能需要50GB以上。* |
| `-v /data/tvshows` | 媒体文件存放位置。根据需要添加多个，例如`/data/movies`、`/data/tv`等。 |
| `-v /data/movies` | 媒体文件存放位置。根据需要添加多个，例如`/data/movies`、`/data/tv`等。 |
| `-v /opt/vc/lib` | 树莓派OpenMAX库路径 *可选*。 |
| `--device /dev/dri` | 仅在需要使用Intel或AMD GPU进行硬件加速视频编码(vaapi)时需要。 |
| `--device /dev/vchiq` | 仅在需要使用树莓派OpenMax视频编码(Bellagio)时需要。 |
| `--device /dev/video10` | 仅在需要使用树莓派V4L2视频编码时需要。 |
| `--device /dev/video11` | 仅在需要使用树莓派V4L2视频编码时需要。 |
| `--device /dev/video12` | 仅在需要使用树莓派V4L2视频编码时需要。 |

## 来自文件的环境变量（Docker secrets）

您可以通过使用特殊的前缀`FILE__`从文件中设置任何环境变量。

例如：

```bash
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

这会根据`/run/secrets/mysecretpassword`文件的内容设置环境变量`PASSWORD`。

## 运行应用程序的Umask

对于我们所有的镜像，您可以使用可选的`-e UMASK=022`设置来覆盖容器内启动的服务的默认umask设置。
请记住，umask不是chmod，它根据其值减去权限，而不是添加权限。在请求支持之前，请先[阅读](https://en.wikipedia.org/wiki/Umask)相关内容。

## 用户/组标识符

使用卷（`-v`标志）时，主机操作系统和容器之间可能会出现权限问题，我们通过允许您指定用户`PUID`和组`PGID`来避免此问题。

确保主机上的任何卷目录都由您指定的相同用户拥有，任何权限问题都会像魔术一样消失。

在这个例子中`PUID=1000`和`PGID=1000`，要找到您的ID，请使用`id user`：

```bash
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=emby&query=%24.mods%5B%27emby%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=emby "查看此容器的可用mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用mods")

我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)，以在容器内启用额外功能。可通过上方的动态徽章访问此镜像可用的Mods列表（如果有）以及可应用于我们任何镜像的通用Mods。

## 支持信息

* 容器运行时的Shell访问：`docker exec -it emby /bin/bash`
* 实时监控容器日志：`docker logs -f emby`
* 容器版本号
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' emby`
* 镜像版本号
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/emby:latest`

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部的应用程序。除了一些例外（如nextcloud、plex），我们不建议或支持在容器内更新应用程序。请查阅上面的[应用程序设置](#应用设置)部分，了解是否推荐对此镜像进行更新。

以下是更新容器的说明：

### 通过Docker Compose

* 更新所有镜像：`docker-compose pull`
  * 或更新单个镜像：`docker-compose pull emby`
* 让compose根据需要更新所有容器：`docker-compose up -d`
  * 或更新单个容器：`docker-compose up -d emby`
* 您还可以删除旧的悬空镜像：`docker image prune`

### 通过Docker Run

* 更新镜像：`docker pull docker.xuanyuan.run/linuxserver/emby:latest`
* 停止运行中的容器：`docker stop emby`
* 删除容器：`docker rm emby`
* 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）
* 您还可以删除旧的悬空镜像：`docker image prune`

### 通过Watchtower自动更新器（仅在不记得原始参数时使用）

* 拉取其标签的最新镜像，并在一次运行中用相同的环境变量替换它：

  ```bash
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once emby
  ```

* 您还可以删除旧的悬空镜像：`docker image prune`

**注意：** 我们不认可使用Watchtower作为自动更新现有Docker容器的解决方案。事实上，我们通常不鼓励自动更新。但是，对于您忘记原始参数的容器，这是一个有用的一次性手动更新工具。从长远来看，我们强烈建议使用[Docker Compose](https://docs.linuxserver.io/general/docker-compose)。

### 镜像更新通知 - Diun（Docker镜像更新通知器）

* 我们推荐[Diun](https://crazymax.dev/diun/)用于更新通知。不建议或支持其他自动更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-emby.git
cd docker-emby
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/emby:latest .
```

可以使用`multiarch/qemu-user-static`在x86_64硬件上构建ARM变体

```bash
docker run --rm --privileged docker.xuanyuan.run/multiarch/qemu-user-static:register --reset
```

注册后，您可以使用`-f Dockerfile.aarch64`定义要使用的dockerfile。

## 版本历史

* **06.07.23:** - 弃用armhf架构。如[此处](https://www.linuxserver.io/blog/a-farewell-to-arm-hf)所宣布
* **08.06.23:** - 修复包提取，使其不会更改/tmp权限。
* **31.05.23:** - 使用上游deb包而非rpm。
* **26.09.22:** - 更新chown行为。
* **18.09.22:** - 迁移到s6v3，基于Ubuntu Jammy重建。
* **19.05.21:** - 上游结构变更。
* **17.01.21:** - 弃用`UMASK_SET`，改用基础镜像中的UMASK，详见上文。移除不再使用的/transcode映射。
* **21.12.20:** - 基于Focal重建，有关armhf故障排除，请参见[此处](https://docs.linuxserver.io/faq#my-host-is-incompatible-with-images-based-on-ubuntu-focal)
* **03.11.20:** - 修复缺少samba文件夹的问题。
* **13.11.20:** - 修复samba和ffmpeg的问题。
* **03.07.20:** - 添加对amd vaapi硬件转码的支持。
* **29.02.20:** - 添加树莓派上的v4l2支持。
* **26.02.20:** - 添加树莓派上的openmax支持。
* **15.02.20:** - 允许从gui重启emby（也允许插件更新后自动重启）。
* **02.10.19:** - 改进render和dvb设备的权限修复。
* **13.08.19:** - 添加umask环境变量。
* **24.06.19:** - 修复readme中的拼写错误。
* **30.05.19:** - 初始发布。
