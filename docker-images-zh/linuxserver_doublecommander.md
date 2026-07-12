---
image: linuxserver/doublecommander
description: "LinuxServer提供的Double Commander容器镜像，实现双窗口文件管理器的容器化部署，支持高效文件管理操作，适用于容器环境中的文件管理需求。"
source: https://xuanyuan.cloud/zh/r/linuxserver/doublecommander
canonical: https://xuanyuan.cloud/zh/r/linuxserver/doublecommander
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/doublecommander" title="linuxserver/doublecommander Docker 镜像中文简介、标签列表与拉取命令">linuxserver/doublecommander 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/doublecommander

## 镜像概述和主要用途

[Double Commander](https://doublecmd.sourceforge.io/) 是一款免费的跨平台开源文件管理器，采用双面板并排布局。它受 Total Commander 启发，并融入了一些新功能理念。本镜像由 LinuxServer.io 团队构建，提供了便捷的容器化部署方式，适用于需要通过 Web 界面管理文件的场景。

LinuxServer.io 团队的容器特点：
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 基于 s6 overlay 的自定义基础镜像
- 每周基础 OS 更新，通过通用层减少空间占用、 downtime 和带宽消耗
- 定期安全更新

## 核心功能和特性

- 双面板文件管理界面，支持本地和远程文件系统
- 跨平台兼容性，支持 x86-64 和 arm64 架构
- Web 访问方式，无需本地安装客户端
- 支持多种归档格式（rar、7zip、ace、arj 等）
- 可选的 HTTP 基本认证保护
- GPU 加速支持（DRI3 和 Nvidia）
- 多语言支持，可通过环境变量配置界面语言
- 支持 Docker-in-Docker (DinD) 环境和主机 Docker 套接字挂载

## 支持的架构

该镜像利用 Docker 清单实现多平台支持。直接拉取 `lscr.io/linuxserver/doublecommander:latest` 即可获取适合您架构的正确镜像，也可通过标签拉取特定架构镜像。

| 架构 | 支持情况 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 使用场景和适用范围

- 家庭服务器文件管理：通过 Web 界面管理家庭网络中的文件
- 远程服务器维护：无需 SSH 即可通过图形界面操作文件
- 开发环境文件操作：在容器化环境中便捷地管理项目文件
- 多平台文件同步：利用双面板对比和同步不同位置的文件
- 低资源设备部署：适合在 NAS、树莓派等设备上运行

## 应用设置

### 访问方式

应用可通过以下地址访问：
- https://你的主机IP:3001/

### 严格反向代理配置

本镜像默认使用自签名证书，因此协议为 `https`。如果您使用验证证书的反向代理，需要[禁用对容器的证书检查](https://docs.linuxserver.io/faq#strict-proxy)。

> [!WARNING]
> 现代 GUI 桌面应用可能与最新的 Docker 系统调用限制存在兼容性问题。在具有较旧内核或 libseccomp 版本的主机上，可使用 `--security-opt seccomp=unconfined` 参数运行 Docker 以允许这些系统调用。

### 安全注意事项

> [!WARNING]
> 此容器提供对主机系统的特权访问。除非已正确配置安全措施，否则不要将其暴露到互联网。

- **HTTPS 是完整功能的必要条件**：WebCodecs 等现代浏览器功能（用于视频和音频）不会在不安全的 HTTP 连接上运行。
- 默认情况下，容器没有身份验证。可选的 `CUSTOM_USER` 和 `PASSWORD` 环境变量可启用 HTTP 基本认证，仅适用于在可信本地网络中保护容器。
- Web 界面包含具有无密码 `sudo` 访问权限的终端。任何有权访问 GUI 的用户都可以在容器内获得 root 控制权，安装任意软件，并探测本地网络。
- 某些 legacy 环境（如旧硬件或过时 Linux 发行版）可能需要停用标准 seccomp 配置文件才能运行容器化桌面软件，可使用 `--security-opt seccomp=unconfined` 参数。仅在绝对必要时使用此选项，因为它会禁用 Docker 的关键安全层。

### 通用 Selkies 基础 GUI 容器选项

本容器基于 [Docker Baseimage Selkies](https://github.com/linuxserver/docker-baseimage-selkies)，提供以下环境变量和运行配置来自定义功能：

#### 可选环境变量

| 变量 | 描述 |
| :----: | --- |
| `CUSTOM_PORT` | 内部 HTTP 端口，默认 `3000` |
| `CUSTOM_HTTPS_PORT` | 内部 HTTPS 端口，默认 `3001` |
| `CUSTOM_WS_PORT` | 容器监听 WebSocket 的内部端口，默认 `8082` |
| `CUSTOM_USER` | HTTP 基本认证的用户名，默认 `abc` |
| `PASSWORD` | HTTP 基本认证的密码，未设置则禁用认证 |
| `SUBFOLDER` | 反向代理配置的应用子目录，必须包含前导和尾随斜杠，如 `/subfolder/` |
| `TITLE` | Web 浏览器中显示的页面标题，默认 "Selkies" |
| `START_DOCKER` | 设置为 `false` 时，不自动启动特权 Docker-in-Docker 环境 |
| `DISABLE_IPV6` | 设置为 `true` 禁用容器内 IPv6 支持 |
| `LC_ALL` | 设置容器区域设置，如 `fr_FR.UTF-8` |
| `DRINODE` | 挂载 `/dev/dri` 时指定使用的设备，如 `/dev/dri/renderD128` |
| `NO_DECOR` | 设置后，应用将无窗口边框运行，适合 PWA 使用 |
| `NO_FULL` | 设置后，应用不会自动全屏显示 |
| `DISABLE_ZINK` | 设置后，检测到显卡时不配置 Zink 相关环境变量 |
| `WATERMARK_PNG` | 容器内水印 PNG 文件的完整路径，如 `/usr/share/selkies/www/icon.png` |
| `WATERMARK_LOCATION` | 水印位置整数：`1`（左上）、`2`（右上）、`3`（左下）、`4`（右下）、`5`（居中）、`6`（动画） |

#### 可选运行配置参数

| 参数 | 描述 |
| :----: | --- |
| `--privileged` | 启动 Docker-in-Docker (DinD) 环境。为获得更好性能，可从主机挂载 Docker 数据目录，如 `-v /path/to/docker-data:/var/lib/docker` |
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载主机 Docker 套接字，以便在容器内管理主机容器 |
| `--device /dev/dri:/dev/dri` | 将 GPU 挂载到容器中，可与 `DRINODE` 环境变量结合使用，利用主机显卡实现 GPU 加速应用。仅支持**开源**驱动（Intel、AMDGPU、Radeon、ATI、Nouveau） |

### 语言支持 - 国际化

要以其他语言启动桌面会话，设置 `LC_ALL` 环境变量。例如：

- `-e LC_ALL=zh_CN.UTF-8` - 中文
- `-e LC_ALL=ja_JP.UTF-8` - 日语
- `-e LC_ALL=ko_KR.UTF-8` - 韩语
- `-e LC_ALL=ar_AE.UTF-8` - 阿拉伯语
- `-e LC_ALL=ru_RU.UTF-8` - 俄语
- `-e LC_ALL=es_MX.UTF-8` - 西班牙语（拉丁美洲）
- `-e LC_ALL=de_DE.UTF-8` - 德语
- `-e LC_ALL=fr_FR.UTF-8` - 法语
- `-e LC_ALL=nl_NL.UTF-8` - 荷兰语
- `-e LC_ALL=it_IT.UTF-8` - 意大利语

### DRI3 GPU 加速

对于需要加速的应用或游戏，可将渲染设备挂载到容器中，应用通过以下方式利用：

```bash
--device /dev/dri:/dev/dri
```

此功能仅支持**开源** GPU 驱动：

| 驱动 | 描述 |
| :----: | --- |
| Intel | Intel iGPU 芯片组的 i965 和 i915 驱动 |
| AMD | AMD 独立显卡或 APU 芯片组的 AMDGPU、Radeon 和 ATI 驱动 |
| NVIDIA | 仅 nouveau2 驱动，闭源 NVIDIA 驱动缺乏 DRI3 支持 |

`DRINODE` 环境变量可用于指向特定 GPU。DRI3 在 aarch64 架构上，若容器内安装了适合芯片组的驱动，也可工作。

### Nvidia GPU 支持

> **注意：基于 Alpine 的镜像不支持 Nvidia。**

通过 Zink 可实现 Nvidia GPU 对 OpenGL 的支持。当兼容的 Nvidia GPU 被传递时，还将**自动用于硬件加速视频流编码**（使用 `x264enc` 全帧配置文件），显著降低 CPU 负载。

通过以下运行时标志启用 Nvidia 支持：

| 标志 | 描述 |
| :----: | --- |
| `--gpus all` | 将所有可用的主机 GPU 传递给容器，可过滤特定 GPU |
| `--runtime nvidia` | 指定 Nvidia 运行时，提供来自主机的必要驱动和工具 |

对于 Docker Compose，需先在主机上配置 Nvidia 运行时为默认：

```bash
sudo nvidia-ctk runtime configure --runtime=docker --set-as-default
sudo systemctl restart docker
```

然后在 `compose.yaml` 中为服务分配 GPU：

```yaml
services:
  doublecommander:
    image: docker.xuanyuan.run/linuxserver/doublecommander:latest
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

通过 `apt-get install` 等方式原生安装的软件包在容器重建后不会保留。要跨容器更新保留应用及其设置，推荐使用 [proot-apps](https://github.com/linuxserver/proot-apps)，这些是安装到用户持久 `$HOME` 目录的便携式应用。

要安装应用，在容器内使用命令行：

```bash
proot-apps install filezilla
```

支持的应用列表见 [此处](https://github.com/linuxserver/proot-apps?tab=readme-ov-file#supported-apps)。

#### 原生应用（非持久化）

可使用 [universal-package-install](https://github.com/linuxserver/docker-mods/tree/universal-package-install) mod 从系统原生仓库安装软件包。此方法会增加容器启动时间，且不持久。在 `compose.yaml` 中添加：

```yaml
environment:
  - DOCKER_MODS=linuxserver/mods:universal-package-install
  - INSTALL_PACKAGES=libfuse2|git|gdb
```

## 使用方法和配置说明

### Docker Compose（推荐）

```yaml
---
services:
  doublecommander:
    image: docker.xuanyuan.run/linuxserver/doublecommander:latest
    container_name: doublecommander
    environment:
      - PUID=1000               # 用户ID，详见下方说明
      - PGID=1000               # 组ID，详见下方说明
      - TZ=Etc/UTC              # 时区，如 Asia/Shanghai
      # - CUSTOM_USER=admin      # 可选，HTTP认证用户名
      # - PASSWORD=password      # 可选，HTTP认证密码
      # - LC_ALL=zh_CN.UTF-8     # 可选，设置中文界面
    volumes:
      - /path/to/config:/config  # 配置目录，存储程序设置
      - /path/to/data:/data      # 数据目录，可挂载多个
    ports:
      - 3000:3000               # HTTP端口（建议反向代理时使用）
      - 3001:3001               # HTTPS端口（直接访问使用）
    shm_size: "1gb"             # 共享内存大小，桌面应用推荐
    # --privileged              # 可选，启用DinD环境
    # --device /dev/dri:/dev/dri # 可选，挂载GPU设备
    restart: unless-stopped
```

### Docker Run

```bash
docker run -d \
  --name=doublecommander \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  # -e CUSTOM_USER=admin \
  # -e PASSWORD=password \
  # -e LC_ALL=zh_CN.UTF-8 \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  -v /path/to/data:/data \
  --shm-size="1gb" \
  # --privileged \
  # --device /dev/dri:/dev/dri \
  --restart unless-stopped \
  lscr.io/linuxserver/doublecommander:latest
```

## 参数说明

容器通过运行时参数配置（如上所示）。参数格式为 `<外部>:<内部>`，例如 `-p 8080:80` 表示将容器内 80 端口映射到主机 8080 端口。

### 端口参数

| 参数 | 功能 |
| :----: | --- |
| `-p 3000:3000` | Double Commander 桌面 GUI 的 HTTP 端口，需反向代理 |
| `-p 3001:3001` | Double Commander 桌面 GUI 的 HTTPS 端口 |

### 环境变量

| 参数 | 功能 |
| :----: | --- |
| `-e PUID=1000` | 用户ID - 详见下方说明 |
| `-e PGID=1000` | 组ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 指定时区，参考 [时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e CUSTOM_USER=abc` | HTTP 基本认证的用户名（可选） |
| `-e PASSWORD=` | HTTP 基本认证的密码（可选，未设置则禁用认证） |
| `-e LC_ALL=zh_CN.UTF-8` | 设置容器区域设置，控制界面语言（可选） |

### 卷参数

| 参数 | 功能 |
| :----: | --- |
| `-v /config` | 容器内用户主目录，存储程序设置 |
| `-v /data` | 主机数据目录，可根据需要挂载多个 |

### 其他参数

| 参数 | 功能 |
| :----: | --- |
| `--shm-size=` | 共享内存大小，所有桌面镜像推荐设置 |
| `--privileged` | 启动 Docker-in-Docker 环境 |
| `--device /dev/dri:/dev/dri` | 挂载 GPU 设备，用于硬件加速 |

## 从文件加载环境变量（Docker secrets）

可通过特殊前缀 `FILE__` 从文件设置任何环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这会根据 `/run/secrets/mysecretvariable` 文件内容设置环境变量 `MYVAR`。

## 应用运行的 Umask 设置

所有镜像都支持通过可选的 `-e UMASK=022` 设置覆盖容器内服务的默认 umask。注意 umask 不是 chmod，它基于其值减去权限，而非添加。详情请参考 [umask 说明](https://en.wikipedia.org/wiki/Umask)。

## 用户/组 ID

使用卷（`-v` 标志）时，主机 OS 和容器之间可能出现权限问题。通过指定用户 `PUID` 和组 `PGID` 可避免此问题。

确保主机上的卷目录由您指定的用户拥有，权限问题将迎刃而解。此处 `PUID=1000` 和 `PGID=1000`，可通过 `id your_user` 命令查找您的 PUID 和 PGID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=doublecommander&query=%24.mods%5B%27doublecommander%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=doublecommander "查看此容器的可用 mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看适用于所有容器的通用 mods")

我们提供多种
