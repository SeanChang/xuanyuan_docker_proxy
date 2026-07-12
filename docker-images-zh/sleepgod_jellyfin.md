---
image: sleepgod/jellyfin
description: "推荐使用nyanmisaka/jellyfin（由Jellyfin开发组成员构建的镜像）"
source: https://xuanyuan.cloud/zh/r/sleepgod/jellyfin
canonical: https://xuanyuan.cloud/zh/r/sleepgod/jellyfin
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sleepgod/jellyfin" title="sleepgod/jellyfin Docker 镜像中文简介、标签列表与拉取命令">sleepgod/jellyfin 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 使用方法

以下是帮助您开始创建容器的示例代码片段。

### docker-compose（[推荐](https://docs.linuxserver.io/general/docker-compose)）

兼容docker-compose v2架构。

```yaml
---
version: "2.1"
services:
  jellyfin:
    image: docker.xuanyuan.run/linuxserver/jellyfin
    container_name: jellyfin
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - UMASK_SET=<022> #可选
    volumes:
      - /path/to/library:/config
      - path/to/tvseries:/data/tvshows
      - /path/to/movies:/data/movies
      - /opt/vc/lib:/opt/vc/lib #可选
    ports:
      - 8096:8096
      - 8920:8920 #可选
    devices:
      - /dev/dri:/dev/dri #可选
      - /dev/vc-mem:/dev/vc-mem #可选
      - /dev/vchiq:/dev/vchiq #可选
      - /dev/video10:/dev/video10 #可选
      - /dev/video11:/dev/video11 #可选
      - /dev/video12:/dev/video12 #可选
    restart: unless-stopped
```

### docker cli

```
docker run -d \
  --name=jellyfin \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e UMASK_SET=<022> `#可选` \
  -p 8096:8096 \
  -p 8920:8920 `#可选` \
  -v /path/to/library:/config \
  -v path/to/tvseries:/data/tvshows \
  -v /path/to/movies:/data/movies \
  -v /opt/vc/lib:/opt/vc/lib `#可选` \
  --device /dev/dri:/dev/dri `#可选` \
  --device /dev/vc-mem:/dev/vc-mem `#可选` \
  --device /dev/vchiq:/dev/vchiq `#可选` \
  --device /dev/video10:/dev/video10 `#可选` \
  --device /dev/video11:/dev/video11 `#可选` \
  --device /dev/video12:/dev/video12 `#可选` \
  --restart unless-stopped \
  linuxserver/jellyfin
```

## 参数说明

容器镜像通过运行时传递的参数进行配置（如上所示）。这些参数用冒号分隔，表示`<外部>:<内部>`。例如，`-p 8080:80`会将容器内的`80`端口暴露出来，可通过主机IP的`8080`端口访问。

| 参数 | 功能 |
| :----: | --- |
| `-p 8096` | HTTP Web界面。 |
| `-p 8920` | HTTPS Web界面（需自行配置证书）。 |
| `-e PUID=1000` | 用户ID（详见下文说明） |
| `-e PGID=1000` | 组ID（详见下文说明） |
| `-e TZ=Europe/London` | 指定时区，例如Europe/London |
| `-e UMASK_SET=<022>` | Emby的权限掩码设置，默认不设置为022。 |
| `-v /config` | Jellyfin数据存储位置。*对于大型媒体库，此目录可能会非常大，50GB以上很常见。* |
| `-v /data/tvshows` | 媒体文件存放位置。可根据需要添加多个，例如`/data/movies`、`/data/tv`等。 |
| `-v /data/movies` | 媒体文件存放位置。可根据需要添加多个，例如`/data/movies`、`/data/tv`等。 |
| `-v /opt/vc/lib` | 树莓派OpenMAX库路径（*可选*）。 |
| `--device /dev/dri` | 仅当需要使用Intel GPU进行硬件加速视频编码（vaapi）时需要。 |
| `--device /dev/vc-mem` | 仅当需要使用树莓派MMAL视频解码（在GUI设置中启用为OpenMax H264解码）时需要。 |
| `--device /dev/vchiq` | 仅当需要使用树莓派OpenMax视频编码（Bellagio）时需要。 |
| `--device /dev/video10` | 仅当需要使用树莓派V4L2视频编码时需要。 |
| `--device /dev/video11` | 仅当需要使用树莓派V4L2视频编码时需要。 |
| `--device /dev/video12` | 仅当需要使用树莓派V4L2视频编码时需要。 |

## 来自文件的环境变量（Docker secrets）

您可以通过使用特殊前缀`FILE__`从文件中设置任何环境变量。

例如：

```
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

这会根据`/run/secrets/mysecretpassword`文件的内容设置环境变量`PASSWORD`。

## 运行应用的权限掩码

对于我们所有的镜像，您可以使用可选的`-e UMASK=022`设置来覆盖容器内启动的服务的默认权限掩码。请注意，权限掩码（umask）不是chmod，它基于其值减去权限，而不是添加权限。在寻求支持之前，请先[了解更多](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v`标志）时，主机操作系统和容器之间可能会出现权限问题，我们通过允许您指定用户`PUID`和组`PGID`来避免此问题。

确保主机上的任何卷目录都由您指定的相同用户拥有，这样任何权限问题都会神奇地消失。

在本例中`PUID=1000`和`PGID=1000`，要查找您的PUID和PGID，请使用`id user`命令：

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

&nbsp;
## 应用设置

Web界面可通过`http://<您的IP>:8096`访问。

更多信息可在其官方文档[此处](https://jellyfin.org/docs/general/quick-start.html)找到。

## 硬件加速

### Intel

使用Intel Quicksync进行硬件加速的用户需要通过在运行或创建容器时传递以下命令，将`/dev/dri`视频设备挂载到容器内：

```--device=/dev/dri:/dev/dri```

我们会自动确保容器内的abc用户具有访问此设备的适当权限。

### Nvidia

使用Nvidia进行硬件加速的用户需要在主机上安装Nvidia提供的容器运行时，说明可在此处找到：

https://github.com/NVIDIA/nvidia-docker

我们会自动添加必要的环境变量，以利用主机GPU上可用的所有功能。在主机上安装nvidia-docker后，您需要使用nvidia容器运行时`--runtime=nvidia`重新创建docker容器，并添加环境变量`-e NVIDIA_VISIBLE_DEVICES=all`（也可以设置为特定GPU的UUID，可通过运行`nvidia-smi --query-gpu=gpu_name,gpu_uuid --format=csv`发现）。Nvidia会自动将GPU和驱动程序从主机挂载到jellyfin docker容器中。

### MMAL/OpenMAX（树莓派）

使用树莓派MMAL/OpenMAX进行硬件加速的用户需要将`/dev/vc-mem`和`/dev/vchiq`视频设备以及系统OpenMax库挂载到容器内，方法是在运行或创建容器时传递以下选项：

```
--device=/dev/vc-mem:/dev/vc-mem
--device=/dev/vchiq:/dev/vchiq
-v /opt/vc/lib:/opt/vc/lib
```

### V4L2（树莓派）

使用树莓派V4L2进行硬件加速的用户需要将`/dev/video1X`设备挂载到容器内，方法是在运行或创建容器时传递以下选项：
```
--device=/dev/video10:/dev/video10
--device=/dev/video11:/dev/video11
--device=/dev/video12:/dev/video12
```

## Docker Mods
[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=jellyfin&query=%24.mods%5B%27jellyfin%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=jellyfin "查看此容器可用的mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用mods")

我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)，以启用容器内的其他功能。此镜像可用的Mods列表（如有）以及可应用于我们任何镜像的通用Mods可通过上方的动态徽章访问。

## 支持信息

* 容器运行时的Shell访问：`docker exec -it jellyfin /bin/bash`
* 实时监控容器日志：`docker logs -f jellyfin`
* 容器版本号
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' jellyfin`
* 镜像版本号
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/jellyfin`

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部的应用。除了一些例外（如nextcloud、plex），我们不建议或支持在容器内更新应用。请参考上方的[应用设置](#应用设置)部分，查看是否推荐对此镜像进行应用更新。

以下是更新容器的说明：

### 通过Docker Compose
* 更新所有镜像：`docker-compose pull`
  * 或更新单个镜像：`docker-compose pull jellyfin`
* 让compose根据需要更新所有容器：`docker-compose up -d`
  * 或更新单个容器：`docker-compose up -d jellyfin`
* 您还可以删除旧的悬空镜像：`docker image prune`

### 通过Docker Run
* 更新镜像：`docker pull docker.xuanyuan.run/linuxserver/jellyfin`
* 停止运行中的容器：`docker stop jellyfin`
* 删除容器：`docker rm jellyfin`
* 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）
* 您还可以删除旧的悬空镜像：`docker image prune`

### 通过Watchtower自动更新器（仅在不记得原始参数时使用）
* 拉取最新标签的镜像并使用相同的环境变量替换：
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once jellyfin
  ```
* 您还可以删除旧的悬空镜像：`docker image prune`

**注意：** 我们不认可将Watchtower用作现有Docker容器自动更新的解决方案。事实上，我们通常不鼓励自动更新。但是，对于您忘记原始参数的容器，这是一个有用的一次性手动更新工具。从长远来看，我们强烈建议使用[Docker Compose](https://docs.linuxserver.io/general/docker-compose)。

### 镜像更新通知 - Diun（Docker镜像更新通知器）
* 我们推荐使用[Diun](https://crazymax.dev/diun/)进行更新通知。不建议或支持其他自动更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：
```
git clone https://github.com/linuxserver/docker-jellyfin.git
cd docker-jellyfin
docker build \
  --no-cache \
  --pull \
  -t linuxserver/jellyfin:latest .
```

ARM变体可以使用`multiarch/qemu-user-static`在x86_64硬件上构建：
```
docker run --rm --privileged docker.xuanyuan.run/multiarch/qemu-user-static:register --reset
```

注册后，您可以使用`-f Dockerfile.aarch64`指定要使用的dockerfile。

## 版本历史

* **2020年7月22日：** - 从unstable安装nightly版本。
* **2020年5月27日：** - 设置web目录路径。
* **2020年4月11日：** - 在树莓派上启用硬件解码（mmal），更新README说明，添加捐赠信息，创建缺失的默认转码文件夹。
* **2020年3月11日：** - 在树莓派上添加v4l2支持；删除可选的转码映射（位置在GUI中选择，默认为`/config`下的路径）。
* **2020年1月30日：** - 添加nightly标签。
* **2020年1月9日：** - 添加Pi OpenMax支持。
* **2019年10月2日：** - 改进render和dvb设备的权限修复。
* **2019年7月31日：** - 添加AMD驱动以支持x86上的vaapi。
* **2019年6月13日：** - 添加Intel驱动以支持x86上的vaapi。
* **2019年6月7日：** - 初始发布。
