---
image: linuxserver/openshot
description: "LinuxServer.io提供的OpenShot视频编辑器Docker镜像，用于便捷部署和运行开源视频编辑软件，支持在容器化环境中进行视频编辑工作。"
source: https://xuanyuan.cloud/zh/r/linuxserver/openshot
canonical: https://xuanyuan.cloud/zh/r/linuxserver/openshot
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/openshot" title="linuxserver/openshot Docker 镜像中文简介、标签列表与拉取命令">linuxserver/openshot 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/openshot

## 镜像概述和主要用途

[OpenShot](https://openshot.org/) Video Editor 是一款屡获殊荣的免费开源视频编辑器，适用于Linux、Mac和Windows系统，致力于为全球用户提供高质量的视频编辑和动画解决方案。本镜像由LinuxServer.io团队提供，将OpenShot视频编辑器容器化，便于在Docker环境中快速部署和使用。

LinuxServer.io团队提供的容器具有以下特点：
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 带有s6覆盖层的自定义基础镜像
- 每周基础操作系统更新，在整个LinuxServer.io生态系统中共享通用层，以最小化空间使用、停机时间和带宽
- 定期安全更新

## 核心功能和特性

- 完整的OpenShot视频编辑功能，包括视频剪辑、过渡效果、标题动画等
- 通过Web界面访问的图形化视频编辑环境
- 支持多种视频、音频格式的导入和导出
- 多平台架构支持（x86-64）
- 可配置的用户权限和访问控制
- 可选的GPU加速支持，提升视频处理性能
- 支持多语言界面
- 持久化配置和项目文件存储

## 支持的架构

该镜像利用Docker manifest实现多平台支持。只需拉取`lscr.io/linuxserver/openshot:latest`即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ❌ | |

## 使用场景和适用范围

- 个人视频编辑工作流
- 教育机构的视频制作教学
- 小型工作室的视频内容创作
- 需要在服务器环境中进行视频处理的场景
- 开发和测试视频编辑自动化脚本
- 作为轻量级视频编辑工具集成到更大的媒体工作流中

## 详细的使用方法和配置说明

### 应用访问

应用可通过以下地址访问：
- https://yourhost:3001/

### 严格反向代理设置

此镜像默认使用自签名证书，因此协议为`https`。如果您使用验证证书的反向代理，需要[为容器禁用此检查](https://docs.linuxserver.io/faq#strict-proxy)。

**现代GUI桌面应用可能与最新的Docker系统调用限制存在兼容性问题。您可以使用`--security-opt seccomp=unconfined`设置运行Docker，以允许旧内核或libseccomp版本的主机上的这些系统调用。**

### 安全性

>[!WARNING]
>此容器提供对主机系统的特权访问。除非已正确配置安全措施，否则不要将其暴露到互联网。

**完整功能需要HTTPS。** WebCodecs等现代浏览器功能（用于视频和音频）不会在不安全的HTTP连接上运行。

默认情况下，此容器没有身份验证。可选的`CUSTOM_USER`和`PASSWORD`环境变量启用基本HTTP身份验证，这仅适用于在受信任的本地网络上保护容器。对于互联网暴露，强烈建议将容器放在反向代理（如[SWAG](https://github.com/linuxserver/docker-swag)）后面，并使用强大的身份验证机制。

Web界面包含具有无密码`sudo`访问权限的终端。任何有权访问GUI的用户都可以在容器内获得root控制权，安装任意软件，并探测本地网络。

虽然通常不推荐，但某些特定的遗留环境（特别是那些使用较旧硬件或过时Linux发行版的环境）可能需要停用标准seccomp配置文件才能运行容器化桌面软件。这可以通过使用`--security-opt seccomp=unconfined`参数实现。仅在绝对必要时使用此选项，因为它会禁用Docker的关键安全层，增加容器逃逸漏洞的可能性。

### Selkies-based GUI容器的通用选项

此容器基于[Docker Baseimage Selkies](https://github.com/linuxserver/docker-baseimage-selkies)构建，提供以下环境变量和运行配置以自定义其功能。

#### 可选环境变量

| 变量 | 描述 |
| :----: | --- |
| `CUSTOM_PORT` | 内部HTTP端口，默认为`3000` |
| `CUSTOM_HTTPS_PORT` | 内部HTTPS端口，默认为`3001` |
| `CUSTOM_WS_PORT` | 容器监听WebSocket的内部端口，默认8082 |
| `CUSTOM_USER` | HTTP基本身份验证的用户名，默认为`abc` |
| `PASSWORD` | HTTP基本身份验证的密码，如果未设置，则禁用身份验证 |
| `SUBFOLDER` | 反向代理配置的应用子文件夹，必须包含前导和尾随斜杠，例如`/subfolder/` |
| `TITLE` | Web浏览器中显示的页面标题，默认为"Selkies" |
| `START_DOCKER` | 如果设置为`false`，则不会自动启动特权Docker-in-Docker设置 |
| `DISABLE_IPV6` | 设置为`true`以禁用容器中的IPv6支持 |
| `LC_ALL` | 设置容器的区域设置，例如`fr_FR.UTF-8` |
| `DRINODE` | 挂载/dev/dri用于DRI3 GPU加速时，指定要使用的设备，例如`/dev/dri/renderD128` |
| `NO_DECOR` | 如果设置，应用程序将无窗口边框运行，适合PWA使用 |
| `NO_FULL` | 如果设置，应用程序将不会自动全屏显示 |
| `DISABLE_ZINK` | 如果设置，检测到视频卡时不会配置Zink相关环境变量 |
| `WATERMARK_PNG` | 容器内水印PNG文件的完整路径，例如`/usr/share/selkies/www/icon.png` |
| `WATERMARK_LOCATION` | 指定水印位置的整数：`1`（左上角）、`2`（右上角）、`3`（左下角）、`4`（右下角）、`5`（居中）、`6`（动画） |

#### 可选运行配置

| 参数 | 描述 |
| :----: | --- |
| `--privileged` | 启动Docker-in-Docker (DinD)环境。为获得更好的性能，从主机挂载Docker数据目录，例如`-v /path/to/docker-data:/var/lib/docker` |
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载主机的Docker套接字，以便从容器内管理主机容器 |
| `--device /dev/dri:/dev/dri` | 将GPU挂载到容器中，可与`DRINODE`环境变量结合使用，以利用主机视频卡进行GPU加速应用。仅支持**开源**驱动程序，如（Intel、AMDGPU、Radeon、ATI、Nouveau） |

### 语言支持 - 国际化

要以不同语言启动桌面会话，请设置`LC_ALL`环境变量。例如：

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

对于加速的应用程序或游戏，可以将渲染设备挂载到容器中，并通过以下方式供应用程序使用：

`--device /dev/dri:/dev/dri`

此功能仅支持**开源**GPU驱动程序：

| 驱动程序 | 描述 |
| :----: | --- |
| Intel | 适用于Intel iGPU芯片组的i965和i915驱动程序 |
| AMD | 适用于AMD专用或APU芯片组的AMDGPU、Radeon和ATI驱动程序 |
| NVIDIA | 仅nouveau2驱动程序，闭源NVIDIA驱动程序缺乏DRI3支持 |

`DRINODE`环境变量可用于指向特定的GPU。

如果容器内安装了适用于您芯片组的正确驱动程序，DRI3将在aarch64上工作。

### Nvidia GPU支持

**注意：基于Alpine的镜像不支持Nvidia。**

通过利用Zink for OpenGL，可以支持Nvidia GPU。当兼容的Nvidia GPU被传递时，它也将**自动用于硬件加速视频流编码**（使用`x264enc`全帧配置文件），显著减少CPU负载。

使用以下运行时标志启用Nvidia支持：

| 标志 | 描述 |
| :----: | --- |
| `--gpus all` | 将所有可用的主机GPU传递到容器。可以过滤到特定的GPU。 |
| `--runtime nvidia` | 指定Nvidia运行时，提供来自主机的必要驱动程序和工具 |

对于Docker Compose，必须首先在主机上将Nvidia运行时配置为默认值：

```
sudo nvidia-ctk runtime configure --runtime=docker --set-as-default
sudo systemctl restart docker
```

然后，在`compose.yaml`中为服务分配GPU：

```yaml
services:
  openshot:
    image: docker.xuanyuan.run/linuxserver/openshot:latest
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [compute,video,graphics,utility]
```

### 应用程序管理

有两种方法可以在容器内安装应用程序：PRoot Apps（推荐用于持久性）和Native Apps。

#### PRoot Apps（持久）

如果重新创建容器，原生安装的软件包（例如通过`apt-get install`）将不会持久存在。为了在容器更新之间保留应用程序及其设置，建议使用[proot-apps](https://github.com/linuxserver/proot-apps)。这些是安装到用户的持久`$HOME`目录的便携式应用程序。

要安装应用程序，请使用容器内的命令行：

```
proot-apps install filezilla
```

支持的应用程序列表可在[此处](https://github.com/linuxserver/proot-apps?tab=readme-ov-file#supported-apps)找到。

#### Native Apps（非持久）

您可以使用[universal-package-install](https://github.com/linuxserver/docker-mods/tree/universal-package-install) mod从系统的原生存储库安装软件包。此方法将增加容器的启动时间，并且不具有持久性。在`compose.yaml`中添加以下内容：

```yaml
  environment:
    - DOCKER_MODS=linuxserver/mods:universal-package-install
    - INSTALL_PACKAGES=libfuse2|git|gdb
```

## Docker部署方案示例

### Docker Compose（推荐）

```yaml
---
services:
  openshot:
    image: docker.xuanyuan.run/linuxserver/openshot:latest
    container_name: openshot
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      # 可选环境变量
      # - CUSTOM_USER=username
      # - PASSWORD=password
      # - LC_ALL=zh_CN.UTF-8
    volumes:
      - /path/to/openshot/config:/config
      - /path/to/your/videos:/videos  # 可选，挂载视频文件目录
    ports:
      - 3000:3000
      - 3001:3001
    shm_size: "1gb"
    # 如需GPU加速，取消以下注释
    # devices:
    #   - /dev/dri:/dev/dri
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=openshot \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  # 可选环境变量
  # -e CUSTOM_USER=username \
  # -e PASSWORD=password \
  # -e LC_ALL=zh_CN.UTF-8 \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/openshot/config:/config \
  -v /path/to/your/videos:/videos \  # 可选，挂载视频文件目录
  --shm-size="1gb" \
  # 如需GPU加速，取消以下注释
  # --device /dev/dri:/dev/dri \
  --restart unless-stopped \
  lscr.io/linuxserver/openshot:latest
```

## 参数说明

容器使用运行时传递的参数进行配置（如上所示）。这些参数用冒号分隔，表示`<外部>:<内部>`。例如，`-p 8080:80`会将容器内的端口`80`暴露到主机IP的端口`8080`上。

| 参数 | 功能 |
| :----: | --- |
| `-p 3000:3000` | OpenShot桌面GUI（仅用于反向代理） |
| `-p 3001:3001` | OpenShot桌面GUI HTTPS |
| `-e PUID=1000` | 用户ID - 详见下文说明 |
| `-e PGID=1000` | 组ID - 详见下文说明 |
| `-e TZ=Etc/UTC` | 指定要使用的时区，参见此[列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-v /config` | 容器内用户的主目录，存储程序设置和文件 |
| `--shm-size=` | 所有桌面镜像推荐使用 |

## 来自文件的环境变量（Docker secrets）

您可以使用特殊的前缀`FILE__`从文件设置任何环境变量。

例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

将根据`/run/secrets/mysecretvariable`文件的内容设置环境变量`MYVAR`。

## 运行应用程序的Umask

对于我们所有的镜像，您可以使用可选的`-e UMASK=022`设置覆盖容器内启动的服务的默认umask设置。请记住，umask不是chmod，它基于其值减去权限，而不是添加。在请求支持之前，请[阅读](https://en.wikipedia.org/wiki/Umask)相关内容。

## 用户/组标识符

使用卷（`-v`标志）时，主机操作系统和容器之间可能会出现权限问题，我们通过允许您指定用户`PUID`和组`PGID`来避免此问题。

确保主机上的任何卷目录都由您指定的相同用户拥有，任何权限问题都将迎刃而解。

在这个例子中`PUID=1000`和`PGID=1000`，要找到您的ID，请使用`id your_user`：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

我们发布各种[Docker Mods](https://github.com/linuxserver/docker-mods)以启用容器内的附加功能。可用于此镜像的Mod列表（如果有）以及可应用于我们任何镜像的通用Mod可以通过上方的动态徽章访问。

## 支持信息

* 容器运行时的Shell访问：

    ```bash
    docker exec -it openshot /bin/bash
    ```

* 实时监控容器日志：

    ```bash
    docker logs -f openshot
    ```

* 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' openshot
    ```

* 镜像版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/openshot:latest
    ```

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像和重新创建容器来更新内部的应用程序。除了一些例外情况（在相关的readme.md中注明），我们不建议或支持在容器内更新应用程序。请查阅上面的[应用程序设置](#应用访问)部分，了解是否推荐用于该镜像。

以下是更新容器的说明：

### 通过Docker Compose

* 更新镜像：
    * 所有镜像：

        ```bash
        docker-compose pull
        ```

    * 单个镜像：

        ```bash
        docker-compose pull openshot
        ```

* 更新容器：
    * 所有容器：

        ```bash
        docker-compose up -d
        ```

    * 单个容器：

        ```bash
        docker-compose up -d openshot
        ```

* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过Docker Run

* 更新镜像：

    ```bash
    docker pull docker.xuanyuan.run/linuxserver/openshot:latest
    ```

* 停止运行中的容器：

    ```bash
    docker stop openshot
    ```

* 删除容器：

    ```bash
    docker rm openshot
    ```

* 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将
