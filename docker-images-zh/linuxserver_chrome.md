<!-- xuanyuan-docker-images-zh
image: linuxserver/chrome
source: https://xuanyuan.cloud/zh/r/linuxserver/chrome
canonical: https://xuanyuan.cloud/zh/r/linuxserver/chrome
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/chrome" title="linuxserver/chrome Docker 镜像中文简介、标签列表与拉取命令">linuxserver/chrome — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/linuxserver/chrome" title="linuxserver/chrome Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/chrome</a></p>

# linuxserver/chrome 镜像文档

## 镜像概述和主要用途

[linuxserver/chrome](https://github.com/linuxserver/docker-chrome) 是由LinuxServer.io团队开发的Docker镜像，基于Google官方网页浏览器Chrome构建。该镜像提供了一个可通过Web界面访问的Chrome浏览器实例，旨在实现快速、安全和可定制的网页浏览体验。

## 核心功能和特性

- **定期应用更新**：确保浏览器功能始终保持最新
- **简单的用户映射**：通过PGID和PUID轻松配置用户权限
- **自定义基础镜像**：集成s6 overlay系统
- **每周基础操作系统更新**：跨LinuxServer.io生态系统的通用层，减少空间占用、停机时间和带宽使用
- **定期安全更新**：保障浏览器使用安全
- **多架构支持**：适配不同硬件平台
- **Web访问界面**：通过浏览器即可远程访问Chrome实例
- **GPU加速支持**：可利用主机GPU提升性能
- **国际化支持**：支持多种语言环境

## 支持的架构

| 架构 | 支持情况 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ❌ | |

## 使用场景和适用范围

- **远程浏览器访问**：在无头服务器上运行Chrome并通过Web界面访问
- **自动化测试环境**：为Web应用测试提供标准化的Chrome环境
- **受限网络环境**：在隔离环境中安全浏览网页
- **多用户共享**：为多个用户提供独立的浏览器实例
- **开发调试**：网页开发和调试的沙箱环境

## 详细的使用方法和配置说明

### 应用访问

应用可通过以下地址访问：
- https://yourhost:3001/

### 安全注意事项

> [!WARNING]
> 此容器提供对主机系统的特权访问。除非已正确配置安全措施，否则不要将其暴露到互联网。

- **HTTPS要求**：完整功能需要HTTPS支持。现代浏览器功能（如WebCodecs）不会在不安全的HTTP连接上运行。
- **默认无认证**：容器默认没有身份验证。可通过`CUSTOM_USER`和`PASSWORD`环境变量启用基本HTTP认证，仅适用于可信局域网环境。
- **互联网暴露建议**：若需暴露到互联网，强烈建议将容器放置在反向代理（如SWAG）后面，并使用强大的认证机制。
- **终端访问权限**：Web界面包含具有无密码sudo访问权限的终端，任何有权访问GUI的用户都可以在容器内获得root控制权。

### 环境变量配置

#### 基础环境变量

| 变量 | 描述 |
| :----: | --- |
| `PUID=1000` | 用户ID，详见用户/组标识符部分 |
| `PGID=1000` | 组ID，详见用户/组标识符部分 |
| `TZ=Etc/UTC` | 指定时区，详见[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `CHROME_CLI=https://www.linuxserver.io/` | 指定一个或多个Chrome CLI标志，此字符串将完整传递给应用程序 |

#### Selkies-based GUI容器通用环境变量

| 变量 | 描述 |
| :----: | --- |
| `CUSTOM_PORT` | 内部HTTP端口，默认为`3000` |
| `CUSTOM_HTTPS_PORT` | 内部HTTPS端口，默认为`3001` |
| `CUSTOM_WS_PORT` | 容器监听WebSocket的内部端口，默认为8082 |
| `CUSTOM_USER` | HTTP基本认证的用户名，默认为`abc` |
| `PASSWORD` | HTTP基本认证的密码，未设置则禁用认证 |
| `SUBFOLDER` | 反向代理配置的应用子文件夹，必须包含前导和尾随斜杠，例如`/subfolder/` |
| `TITLE` | Web浏览器中显示的页面标题，默认为"Selkies" |
| `START_DOCKER` | 如果设置为`false`，特权Docker-in-Docker设置将不会自动启动 |
| `DISABLE_IPV6` | 设置为`true`可禁用容器中的IPv6支持 |
| `LC_ALL` | 设置容器的区域设置，例如`fr_FR.UTF-8` |
| `DRINODE` | 挂载/dev/dri进行DRI3 GPU加速时，可指定要使用的设备，例如`/dev/dri/renderD128` |
| `NO_DECOR` | 如果设置，应用程序将无窗口边框运行，适合PWA使用 |
| `NO_FULL` | 如果设置，应用程序将不会自动全屏 |
| `DISABLE_ZINK` | 如果设置，检测到显卡时不会配置Zink相关环境变量 |
| `WATERMARK_PNG` | 容器内水印PNG文件的完整路径，例如`/usr/share/selkies/www/icon.png` |
| `WATERMARK_LOCATION` | 指定水印位置的整数：`1`(左上角)，`2`(右上角)，`3`(左下角)，`4`(右下角)，`5`(居中)，`6`(动画) |

### 运行配置选项

| 参数 | 描述 |
| :----: | --- |
| `--privileged` | 启动Docker-in-Docker (DinD)环境。为获得更好的性能，可从主机挂载Docker数据目录，例如`-v /path/to/docker-data:/var/lib/docker` |
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载主机的Docker套接字，以便从容器内部管理主机容器 |
| `--device /dev/dri:/dev/dri` | 将GPU挂载到容器中，可与`DRINODE`环境变量结合使用，利用主机显卡实现GPU加速应用。仅支持**开源**驱动，如Intel、AMDGPU、Radeon、ATI、Nouveau |

### 语言支持 - 国际化

要以不同语言启动桌面会话，请设置`LC_ALL`环境变量。例如：

- `-e LC_ALL=zh_CN.UTF-8` - 中文
- `-e LC_ALL=ja_JP.UTF-8` - 日语
- `-e LC_ALL=ko_KR.UTF-8` - 韩语
- `-e LC_ALL=ar_AE.UTF-8` - 阿拉伯语
- `-e LC_ALL=ru_RU.UTF-8` - 俄语
- `-e LC_ALL=es_MX.UTF-8` - 西班牙语(拉丁美洲)
- `-e LC_ALL=de_DE.UTF-8` - 德语
- `-e LC_ALL=fr_FR.UTF-8` - 法语
- `-e LC_ALL=nl_NL.UTF-8` - 荷兰语
- `-e LC_ALL=it_IT.UTF-8` - 意大利语

### GPU加速配置

#### DRI3 GPU加速

对于加速应用或游戏，可将渲染设备挂载到容器中：

```bash
--device /dev/dri:/dev/dri
```

此功能仅支持**开源**GPU驱动：

| 驱动 | 描述 |
| :----: | --- |
| Intel | i965和i915驱动，适用于Intel iGPU芯片组 |
| AMD | AMDGPU、Radeon和ATI驱动，适用于AMD专用或APU芯片组 |
| NVIDIA | 仅nouveau2驱动，闭源NVIDIA驱动缺乏DRI3支持 |

可使用`DRINODE`环境变量指向特定GPU。

#### Nvidia GPU支持

> **注意：基于Alpine的镜像不支持Nvidia。**

通过Zink实现OpenGL的Nvidia GPU支持。启用Nvidia支持需使用以下运行时标志：

| 标志 | 描述 |
| :----: | --- |
| `--gpus all` | 将所有可用的主机GPU传递给容器，可筛选特定GPU |
| `--runtime nvidia` | 指定Nvidia运行时，提供来自主机的必要驱动程序和工具 |

Docker Compose配置：

首先在主机上配置Nvidia运行时为默认：

```bash
sudo nvidia-ctk runtime configure --runtime=docker --set-as-default
sudo systemctl restart docker
```

然后在`compose.yaml`中为服务分配GPU：

```yaml
services:
  chrome:
    image: lscr.io/linuxserver/chrome:latest
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [compute,video,graphics,utility]
```

### Docker部署方案示例

#### Docker Compose (推荐)

```yaml
---
services:
  chrome:
    image: lscr.io/linuxserver/chrome:latest
    container_name: chrome
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - CHROME_CLI=https://www.linuxserver.io/ #可选
      - CUSTOM_USER=myuser #可选，设置后启用认证
      - PASSWORD=mypassword #可选，与CUSTOM_USER一起使用
    volumes:
      - /path/to/config:/config
    ports:
      - 3000:3000
      - 3001:3001
    shm_size: "1gb"
    restart: unless-stopped
```

#### Docker Run

```bash
docker run -d \
  --name=chrome \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e CHROME_CLI=https://www.linuxserver.io/ `#可选` \
  -e CUSTOM_USER=myuser `#可选，设置后启用认证` \
  -e PASSWORD=mypassword `#可选，与CUSTOM_USER一起使用` \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/chrome:latest
```

### 参数说明

| 参数 | 功能 |
| :----: | --- |
| `-p 3000:3000` | HTTP Chrome桌面GUI端口，需代理 |
| `-p 3001:3001` | HTTPS Chrome桌面GUI端口 |
| `-e PUID=1000` | 用户ID - 详见下文说明 |
| `-e PGID=1000` | 组ID - 详见下文说明 |
| `-e TZ=Etc/UTC` | 指定时区，参见[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e CHROME_CLI=https://www.linuxserver.io/` | 指定一个或多个Chrome CLI标志，此字符串将完整传递给应用程序 |
| `-v /config` | 容器中的用户主目录，存储本地文件和设置 |
| `--shm-size=` | 现代网站（如YouTube）运行所需的共享内存大小 |

### 环境变量文件 (Docker secrets)

可使用特殊前缀`FILE__`从文件设置任何环境变量：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据`/run/secrets/mysecretvariable`文件的内容设置环境变量`MYVAR`。

### 运行应用的Umask设置

所有镜像都提供了使用可选`-e UMASK=022`设置覆盖容器内启动的服务的默认umask设置的能力。请注意，umask不是chmod，它根据其值减去权限，而不是添加。

### 用户/组标识符

使用卷(`-v`标志)时，主机操作系统和容器之间可能会出现权限问题。通过指定用户`PUID`和组`PGID`可以避免此问题。

确保主机上的任何卷目录都由您指定的相同用户拥有，任何权限问题都会像魔术一样消失。

在此示例中`PUID=1000`和`PGID=1000`，可使用以下命令查找您的PUID和PGID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

### 应用管理

容器内安装应用有两种方法：PRoot Apps（推荐用于持久性）和Native Apps。

#### PRoot Apps (持久化)

如果重新创建容器，原生安装的软件包（例如通过`apt-get install`）将不会持久保存。为了在容器更新之间保留应用程序及其设置，建议使用[proot-apps](https://github.com/linuxserver/proot-apps)。这些是安装到用户持久`$HOME`目录的便携式应用程序。

要安装应用程序，请在容器内使用命令行：

```bash
proot-apps install filezilla
```

支持的应用程序列表可在[此处](https://github.com/linuxserver/proot-apps?tab=readme-ov-file#supported-apps)找到。

#### Native Apps (非持久化)

可使用[universal-package-install](https://github.com/linuxserver/docker-mods/tree/universal-package-install) mod从系统的原生仓库安装软件包。此方法会增加容器的启动时间，且不持久。在`compose.yaml`中添加：

```yaml
environment:
  - DOCKER_MODS=linuxserver/mods:universal-package-install
  - INSTALL_PACKAGES=libfuse2|git|gdb
```

### Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=chrome&query=%24.mods%5B%27chrome%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=chrome "查看此容器可用的mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用mods")

我们发布各种[Docker Mods](https://github.com/linuxserver/docker-mods)以启用容器内的附加功能。可通过上方动态徽章访问此镜像可用的Mods列表（如有）以及可应用于任何LinuxServer.io镜像的通用Mods。

## 支持信息

- 容器运行时的Shell访问：

    ```bash
    docker exec -it chrome /bin/bash
    ```

- 实时监控容器日志：

    ```bash
    docker logs -f chrome
    ```

- 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' chrome
    ```

- 镜像版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/chrome:latest
    ```

## 更新信息

大多数镜像都是静态的、版本化的，需要更新镜像和重新创建容器来更新内部应用。除了某些例外（在相关readme.md中注明），我们不建议或支持更新容器内的应用。请查阅上面的[应用设置](#应用设置)部分，了解是否推荐对镜像执行此操作。

### 通过Docker Compose更新

- 更新镜像：
  - 所有镜像：

    ```bash
    docker-compose pull
    ```

  - 单个镜像：

    ```bash
    docker-compose pull chrome
    ```

- 更新容器：
  - 所有容器：

    ```bash
    docker-compose up -d
    ```

  - 单个容器：

    ```bash
    docker-compose up -d chrome
    ```

- 还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过Docker Run更新

- 更新镜像：

    ```bash
    docker pull lscr.io/linuxserver/chrome:latest
    ```

- 停止运行中的容器：

    ```bash
    docker stop chrome
    ```

- 删除容器：

    ```bash
    docker rm chrome
    ```

- 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，`/config`文件夹和设置将被保留）
- 还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun (Docker Image Update Notifier)

> [!TIP]
> 我们推荐使用[Diun](https://crazymax.dev/diun/)进行更新通知。不推荐或支持其他自动更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-chrome.git
cd docker-chrome
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/chrome:latest .
```

可使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/chrome" title="linuxserver/chrome Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/chrome</a></p>
