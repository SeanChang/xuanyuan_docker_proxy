---
image: linuxserver/freecad
description: "LinuxServer.io提供的FreeCAD容器镜像，支持多架构，提供通用参数化3D CAD建模、建筑信息模型（BIM）和有限元方法（FEM）功能，通过Web界面（https://yourhost:3001）访问，支持GPU加速和安全配置，适合本地网络中的3D设计工作流。"
source: https://xuanyuan.cloud/zh/r/linuxserver/freecad
canonical: https://xuanyuan.cloud/zh/r/linuxserver/freecad
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/freecad" title="linuxserver/freecad Docker 镜像中文简介、标签列表与拉取命令">linuxserver/freecad 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/freecad

[FreeCAD](https://www.freecad.org/) 是一款通用参数化3D计算机辅助设计（CAD）建模工具，同时也是支持有限元方法（FEM）的建筑信息模型（BIM）软件。

[![freecad](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/freecad-logo.png)](https://www.freecad.org/)

## 支持的架构

我们利用Docker清单实现多平台支持。有关详细信息，请参阅Docker的[文档](https://distribution.github.io/distribution/spec/manifest-v2-2/#manifest-list)和我们的[公告](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/)。

直接拉取 `lscr.io/linuxserver/freecad:latest` 即可获取适合您架构的正确镜像，也可通过标签拉取特定架构的镜像。

此镜像支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<版本标签\> |
| arm64 | ✅ | arm64v8-\<版本标签\> |

## 应用设置

应用可通过以下地址访问：

* https://yourhost:3001/

### 严格反向代理

此镜像默认使用自签名证书，因此协议为 `https`。如果您使用验证证书的反向代理，需[为容器禁用此检查](https://docs.linuxserver.io/faq#strict-proxy)。

**现代GUI桌面应用可能与最新Docker系统调用限制存在兼容性问题。在使用旧内核或libseccomp版本的主机上，可使用 `--security-opt seccomp=unconfined` 选项允许这些系统调用。**

### 安全

>[!WARNING]
>此容器提供对主机系统的特权访问。除非已正确配置安全措施，否则不要将其暴露到互联网。

**完整功能需要HTTPS。** 现代浏览器功能（如用于视频和音频的WebCodecs）不会在不安全的HTTP连接上运行。

默认情况下，此容器无身份验证。可选的 `CUSTOM_USER` 和 `PASSWORD` 环境变量可启用基本HTTP认证，仅适用于在可信本地网络中保护容器。对于互联网暴露，强烈建议将容器置于反向代理（如[SWAG](https://github.com/linuxserver/docker-swag)）之后，并使用可靠的认证机制。

Web界面包含具有无密码`sudo`访问权限的终端。任何有权访问GUI的用户都可在容器内获得root权限、安装任意软件并探测本地网络。

虽然通常不推荐，但某些 legacy 环境（特别是具有较旧硬件或过时Linux发行版的环境）可能需要停用标准seccomp配置文件才能运行容器化桌面软件。可通过 `--security-opt seccomp=unconfined` 参数实现。仅在绝对必要时使用此选项，因为它会禁用Docker的关键安全层，增加容器逃逸漏洞风险。

### 基于Selkies的GUI容器通用选项

此容器基于[Docker Baseimage Selkies](https://github.com/linuxserver/docker-baseimage-selkies)构建，提供以下环境变量和运行配置以自定义功能。

#### 可选环境变量

| 变量 | 描述 |
| :----: | --- |
| `CUSTOM_PORT` | 内部HTTP端口，默认 `3000`。 |
| `CUSTOM_HTTPS_PORT` | 内部HTTPS端口，默认 `3001`。 |
| `CUSTOM_WS_PORT` | 容器监听WebSocket的内部端口，默认 `8082`。 |
| `CUSTOM_USER` | HTTP基本认证用户名，默认 `abc`。 |
| `PASSWORD` | HTTP基本认证密码，未设置则禁用认证。 |
| `SUBFOLDER` | 反向代理配置的应用子目录，需包含首尾斜杠，如 `/subfolder/`。 |
| `TITLE` | Web浏览器中显示的页面标题，默认 "Selkies"。 |
| `START_DOCKER` | 设为 `false` 时，不会自动启动特权Docker-in-Docker环境。 |
| `DISABLE_IPV6` | 设为 `true` 禁用容器内IPv6支持。 |
| `LC_ALL` | 设置容器区域设置，如 `fr_FR.UTF-8`。 |
| `DRINODE` | 挂载 `/dev/dri` 用于DRI3 GPU加速时，指定设备路径，如 `/dev/dri/renderD128`。 |
| `NO_DECOR` | 若设置，应用将无窗口边框运行，适合PWA使用。 |
| `NO_FULL` | 若设置，应用不会自动全屏。 |
| `DISABLE_ZINK` | 若设置，检测到显卡时不会配置Zink相关环境变量。 |
| `WATERMARK_PNG` | 容器内水印PNG文件的完整路径，如 `/usr/share/selkies/www/icon.png`。 |
| `WATERMARK_LOCATION` | 水印位置整数：`1`（左上）、`2`（右上）、`3`（左下）、`4`（右下）、`5`（居中）、`6`（动画）。 |

#### 可选运行配置

| 参数 | 描述 |
| :----: | --- |
| `--privileged` | 启动Docker-in-Docker（DinD）环境。为提高性能，可从主机挂载Docker数据目录，如 `-v /path/to/docker-data:/var/lib/docker`。 |
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载主机Docker套接字，用于从容器内管理主机容器。 |
| `--device /dev/dri:/dev/dri` | 将GPU挂载到容器中，可结合 `DRINODE` 环境变量利用主机显卡实现GPU加速应用。仅支持**开源**驱动（Intel、AMDGPU、Radeon、ATI、Nouveau）。 |

### 语言支持 - 国际化

要以其他语言启动桌面会话，设置 `LC_ALL` 环境变量。例如：

* `-e LC_ALL=zh_CN.UTF-8` - 中文
* `-e LC_ALL=ja_JP.UTF-8` - 日语
* `-e LC_ALL=ko_KR.UTF-8` - 韩语
* `-e LC_ALL=ar_AE.UTF-8` - 阿拉伯语
* `-e LC_ALL=ru_RU.UTF-8` - 俄语
* `-e LC_ALL=es_MX.UTF-8` - 西班牙语（拉丁美洲）
* `-e LC_ALL=de_DE.UTF-8` - 德语
* `-e LC_ALL=fr_FR.UTF-8` - 法语
* `-e LC_ALL=nl_NL.UTF-8` - 荷兰语
* `-e LC_ALL=it_IT.UTF-8` - 意大利语

### DRI3 GPU加速

对于加速应用或游戏，可将渲染设备挂载到容器中，应用通过以下方式利用：

`--device /dev/dri:/dev/dri`

此功能仅支持**开源**GPU驱动：

| 驱动 | 描述 |
| :----: | --- |
| Intel | Intel iGPU芯片组的i965和i915驱动 |
| AMD | AMD独立显卡或APU芯片组的AMDGPU、Radeon和ATI驱动 |
| NVIDIA | 仅nouveau2驱动，闭源NVIDIA驱动缺乏DRI3支持 |

`DRINODE` 环境变量可用于指向特定GPU。

在aarch64架构上，若容器内安装了适用于芯片组的正确驱动，DRI3也可工作。

### Nvidia GPU支持

**注意：基于Alpine的镜像不支持Nvidia。**

可通过Zink实现OpenGL以支持Nvidia GPU。当兼容Nvidia GPU被传递时，它还会**自动用于硬件加速视频流编码**（使用 `x264enc` 全帧配置文件），显著降低CPU负载。

通过以下运行时标志启用Nvidia支持：

| 标志 | 描述 |
| :----: | --- |
| `--gpus all` | 将所有可用主机GPU传递到容器，可筛选特定GPU。 |
| `--runtime nvidia` | 指定Nvidia运行时，提供来自主机的必要驱动和工具。 |

对于Docker Compose，需先在主机上将Nvidia运行时配置为默认：

```
sudo nvidia-ctk runtime configure --runtime=docker --set-as-default
sudo systemctl restart docker
```

然后在 `compose.yaml` 中为服务分配GPU：

```yaml
services:
  freecad:
    image: docker.xuanyuan.run/linuxserver/freecad:latest
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [compute,video,graphics,utility]
```

### 应用管理

容器内安装应用有两种方法：PRoot Apps（推荐用于持久性）和原生应用。

#### PRoot Apps（持久化）

通过 `apt-get install` 等方式原生安装的软件包在容器重建后不会保留。要跨容器更新保留应用及其设置，建议使用[proot-apps](https://github.com/linuxserver/proot-apps)。这些是安装到用户持久 `$HOME` 目录的便携式应用。

要安装应用，在容器内使用命令行：

```
proot-apps install filezilla
```

支持的应用列表见[此处](https://github.com/linuxserver/proot-apps?tab=readme-ov-file#supported-apps)。

#### 原生应用（非持久化）

可使用[universal-package-install](https://github.com/linuxserver/docker-mods/tree/universal-package-install)模块从系统原生仓库安装软件包。此方法会增加容器启动时间且不持久。在 `compose.yaml` 中添加：

```yaml
  environment:
    - DOCKER_MODS=linuxserver/mods:universal-package-install
    - INSTALL_PACKAGES=libfuse2|git|gdb
```

## 使用方法

以下提供docker-compose和docker cli两种方式启动容器。

>[!NOTE]
>除非标记为“可选”，否则所有参数均为必填项，必须提供值。

### docker-compose（推荐，[点击查看更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
services:
  freecad:
    image: docker.xuanyuan.run/linuxserver/freecad:latest
    container_name: freecad
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/config:/config
    ports:
      - 3000:3000
      - 3001:3001
    shm_size: "1gb"  # 推荐用于所有桌面镜像
    restart: unless-stopped
```

### docker cli（[点击查看更多信息](https://docs.docker.com/engine/reference/commandline/cli/)）

```bash
docker run -d \
  --name=freecad \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --shm-size="1gb" \  # 推荐用于所有桌面镜像
  --restart unless-stopped \
  lscr.io/linuxserver/freecad:latest
```

## 参数

容器通过运行时参数配置（如上所示）。参数格式为 `<外部>:<内部>`。例如，`-p 8080:80` 表示将容器内80端口暴露到主机IP的8080端口。

| 参数 | 功能 |
| :----: | --- |
| `-p 3000:3000` | FreeCAD桌面GUI的HTTP端口，需反向代理。 |
| `-p 3001:3001` | FreeCAD桌面GUI的HTTPS端口。 |
| `-e PUID=1000` | 用户ID - 详见下文说明 |
| `-e PGID=1000` | 组ID - 详见下文说明 |
| `-e TZ=Etc/UTC` | 指定时区，列表见[此处](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)。 |
| `-v /config` | 容器内用户主目录，存储程序设置和文件。 |
| `--shm-size=` | 所有桌面镜像推荐设置。 |

## 来自文件的环境变量（Docker secrets）

可通过特殊前缀 `FILE__` 从文件设置任何环境变量。

例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

将根据 `/run/secrets/mysecretvariable` 文件内容设置环境变量 `MYVAR`。

## 应用运行的Umask

所有镜像均支持通过可选 `-e UMASK=022` 设置覆盖容器内服务的默认umask。注意umask不是chmod，它基于其值减去权限而非添加。请在请求支持前阅读[此处](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v` 标志）时，主机OS和容器之间可能出现权限问题。通过指定用户 `PUID` 和组 `PGID` 可避免此问题。

确保主机上的卷目录由指定用户拥有，权限问题将迎刃而解。

此处 `PUID=1000` 和 `PGID=1000`，通过 `id your_user` 命令获取您的ID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker模块

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=freecad&query=%24.mods%5B%27freecad%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=freecad "查看此容器的可用模块") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看通用模块")

我们发布了各种[Docker模块](https://github.com/linuxserver/docker-mods)以启用容器内的附加功能。可通过上方动态徽章访问此镜像的可用模块（如有）以及可应用于任何镜像的通用模块。

## 支持信息

* 容器运行时的Shell访问：

    ```bash
    docker exec -it freecad /bin/bash
    ```

* 实时监控容器日志：

    ```bash
    docker logs -f freecad
    ```

* 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' freecad
    ```

* 镜像版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/freecad:latest
    ```

## 更新信息

我们的大多数镜像是静态、版本化的，需要更新镜像并重建容器以更新内部应用。除相关readme.md中注明的例外情况，不建议或支持在容器内更新应用。请参阅上文[应用设置](#application-setup)部分了解是否推荐针对此镜像进行更新。

以下是更新容器的说明：

### 通过Docker Compose

* 更新镜像：
    * 所有镜像：

        ```bash
        docker-compose pull
        ```

    * 单个镜像：

        ```bash
        docker-compose pull freecad
        ```

* 更新容器：
    * 所有容器：

        ```bash
        docker-compose up -d
        ```

    * 单个容器：

        ```bash
        docker-compose up -d freecad
        ```

* 可删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过Docker Run

* 更新镜像：

    ```bash
    docker pull docker.xuanyuan.run/linuxserver/freecad:latest
    ```

* 停止运行中的容器：

    ```bash
    docker stop freecad
    ```

* 删除容器：

    ```bash
    docker rm freecad
    ```

* 使用上述相同的docker run参数重建新容器（若正确映射到主机文件夹，`/config` 文件夹和设置将保留）
* 可删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun（Docker镜像更新通知器）

>[!TIP]
>推荐使用[Diun](
