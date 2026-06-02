---
image: linuxserver/obsidian
description: "LinuxServer的Docker镜像，容器化Obsidian笔记应用，支持快速部署与跨平台使用，适用于本地知识库管理及Markdown笔记编辑。"
source: https://xuanyuan.cloud/zh/r/linuxserver/obsidian
canonical: https://xuanyuan.cloud/zh/r/linuxserver/obsidian
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/obsidian" title="linuxserver/obsidian Docker 镜像中文简介、标签列表与拉取命令">linuxserver/obsidian — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/linuxserver/obsidian" title="linuxserver/obsidian Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/obsidian</a>

# linuxserver/obsidian Docker镜像文档

## 镜像概述和主要用途

[linuxserver/obsidian](https://github.com/linuxserver/docker-obsidian) 是由LinuxServer.io团队开发的Docker镜像，用于运行[Obsidian](https://obsidian.md)笔记应用。Obsidian是一款本地优先的笔记应用，支持创建、链接和组织笔记，并提供数百种插件和主题来自定义工作流。用户可离线访问笔记、通过端到端加密安全同步，还能将笔记发布到线上。

LinuxServer.io团队提供的该镜像具有以下特点：
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 基于s6 overlay的自定义基础镜像
- 每周基础操作系统更新，跨生态共享通用层以减少空间占用、 downtime和带宽消耗
- 定期安全更新

## 核心功能和特性

### 容器核心特性
- **多架构支持**：适配x86-64和arm64v8架构
- **用户权限管理**：通过PUID/PGID轻松映射主机用户权限，避免权限问题
- **安全增强**：内置安全更新机制，支持HTTPS加密访问
- **灵活配置**：丰富的环境变量和运行参数，支持自定义端口、认证、界面标题等
- **GPU加速**：支持DRI3和Nvidia GPU加速，提升图形渲染性能
- **多语言支持**：通过环境变量配置支持多种语言界面

### Obsidian应用特性
- 本地优先的笔记管理，数据存储在用户设备上
- 双向链接功能，构建知识图谱
- 支持Markdown格式，丰富的编辑功能
- 可扩展的插件系统和主题市场
- 离线访问能力，无需依赖云端
- 端到端加密同步

## 使用场景和适用范围

### 适用场景
- **个人知识管理**：用于创建和组织个人笔记、研究资料、学习笔记
- **团队协作**：在可信局域网内共享知识库（需配合安全措施）
- **离线工作环境**：需要在无网络环境下访问和编辑笔记
- **自定义工作流**：通过插件和主题定制个性化笔记体验

### 适用范围
- 家庭或小型办公环境的本地服务器部署
- 需在多设备间同步但重视数据隐私的用户
- 技术文档撰写者、研究人员、学生等需要高效组织信息的人群

### 不适用场景
- 直接暴露在公网环境（需配合反向代理和强认证）
- 对实时多人协作有强需求的场景
- 资源受限的设备（如低配置嵌入式设备）

## 详细使用方法和配置说明

### 支持的架构

| 架构 | 支持情况 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

拉取镜像时，直接使用 `lscr.io/linuxserver/obsidian:latest` 即可自动匹配对应架构，也可通过标签指定特定架构。

### 应用访问

应用部署后可通过以下地址访问：
- https://你的主机IP:3001/

### 严格反向代理配置

该镜像默认使用自签名证书，因此访问协议为 `https`。若使用验证证书的反向代理，需[禁用对容器的证书检查](https://docs.linuxserver.io/faq#strict-proxy)。

> **注意**：现代GUI桌面应用可能与最新Docker系统调用限制存在兼容性问题。在使用旧内核或libseccomp版本的主机上，可添加 `--security-opt seccomp=unconfined` 参数允许这些系统调用。

### 安全注意事项

> [!WARNING]
> 本容器提供对主机系统的特权访问。除非已正确配置安全措施，否则不要将其暴露到互联网。

- **HTTPS要求**：完整功能需要HTTPS支持。现代浏览器特性（如WebCodecs视频音频处理）不会在不安全的HTTP连接下工作。
- **默认认证**：容器默认无认证。可选的 `CUSTOM_USER` 和 `PASSWORD` 环境变量可启用基本HTTP认证，仅适用于可信局域网环境。
- **互联网暴露**：若需暴露到互联网，强烈建议将容器置于反向代理（如[SWAG](https://github.com/linuxserver/docker-swag)）之后，并配置强健的认证机制。
- **终端访问**：Web界面包含具有无密码sudo权限的终端。任何有权访问GUI的用户都可在容器内获取root权限、安装任意软件并探测本地网络。
- **seccomp配置**：某些旧环境可能需要禁用标准seccomp配置文件才能运行容器化桌面软件，可通过 `--security-opt seccomp=unconfined` 参数实现。仅在绝对必要时使用此选项，因为它会禁用Docker的关键安全层。

### 环境变量配置

基于Selkies的GUI容器提供以下可选环境变量：

| 变量 | 描述 |
| :----: | --- |
| `CUSTOM_PORT` | 内部HTTP端口，默认3000 |
| `CUSTOM_HTTPS_PORT` | 内部HTTPS端口，默认3001 |
| `CUSTOM_WS_PORT` | 容器监听websocket的内部端口，默认8082 |
| `CUSTOM_USER` | HTTP基本认证用户名，默认abc |
| `PASSWORD` | HTTP基本认证密码，未设置则禁用认证 |
| `SUBFOLDER` | 反向代理配置的应用子目录，需包含前后斜杠，如`/subfolder/` |
| `TITLE` | 浏览器页面标题，默认"Selkies" |
| `START_DOCKER` | 设置为`false`时，禁用Docker-in-Docker自动启动 |
| `DISABLE_IPV6` | 设置为`true`时，禁用容器内IPv6支持 |
| `LC_ALL` | 容器区域设置，用于语言支持，如`fr_FR.UTF-8` |
| `DRINODE` | 指定DRI设备节点，如`/dev/dri/renderD128` |
| `NO_DECOR` | 设置后，应用将无窗口边框运行，适合PWA使用 |
| `NO_FULL` | 设置后，应用不会自动全屏显示 |
| `DISABLE_ZINK` | 设置后，检测到显卡时不会配置Zink相关环境变量 |
| `WATERMARK_PNG` | 水印图片在容器内的完整路径，如`/usr/share/selkies/www/icon.png` |
| `WATERMARK_LOCATION` | 水印位置：1(左上)、2(右上)、3(左下)、4(右下)、5(居中)、6(动画) |

### 运行参数配置

| 参数 | 描述 |
| :----: | --- |
| `--privileged` | 启动Docker-in-Docker环境。为提高性能，建议从主机挂载Docker数据目录，如`-v /path/to/docker-data:/var/lib/docker` |
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载主机Docker套接字，以便在容器内管理主机容器 |
| `--device /dev/dri:/dev/dri` | 将GPU设备挂载到容器，可配合`DRINODE`环境变量使用主机显卡实现GPU加速。仅支持开源驱动（Intel、AMDGPU、Radeon、ATI、Nouveau） |

### 多语言支持

通过设置`LC_ALL`环境变量可启动不同语言的桌面会话，例如：

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

### GPU加速配置

#### DRI3 GPU加速

对于需要加速的应用或游戏，可将渲染设备挂载到容器中：

```bash
--device /dev/dri:/dev/dri
```

该特性仅支持开源GPU驱动：

| 驱动 | 描述 |
| :----: | --- |
| Intel | Intel iGPU芯片组的i965和i915驱动 |
| AMD | AMD独立显卡或APU芯片组的AMDGPU、Radeon和ATI驱动 |
| NVIDIA | 仅nouveau驱动，闭源NVIDIA驱动不支持DRI3 |

可通过`DRINODE`环境变量指定特定GPU。DRI3在aarch64架构上也可工作，前提是容器内安装了适用于芯片组的正确驱动。

#### Nvidia GPU支持

> **注意**：基于Alpine的镜像不支持Nvidia GPU。

Nvidia GPU支持通过Zink实现OpenGL。当兼容的Nvidia GPU被传递到容器时，它还将**自动用于硬件加速视频流编码**（使用`x264enc`全帧配置文件），显著降低CPU负载。

通过以下运行时标志启用Nvidia支持：

| 标志 | 描述 |
| :----: | --- |
| `--gpus all` | 将主机所有可用GPU传递到容器，也可筛选特定GPU |
| `--runtime nvidia` | 指定Nvidia运行时，提供来自主机的必要驱动和工具 |

对于Docker Compose，需先在主机上配置Nvidia运行时为默认：

```bash
sudo nvidia-ctk runtime configure --runtime=docker --set-as-default
sudo systemctl restart docker
```

然后在`compose.yaml`中为服务分配GPU：

```yaml
services:
  obsidian:
    image: lscr.io/linuxserver/obsidian:latest
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [compute,video,graphics,utility]
```

### 应用管理

容器内安装应用有两种方法：PRoot Apps（推荐用于持久化）和原生应用。

#### PRoot Apps（持久化）

通过`apt-get install`等方式原生安装的软件包在容器重建后不会保留。为在容器更新后保留应用及其设置，建议使用[proot-apps](https://github.com/linuxserver/proot-apps)，这些是安装到用户持久`$HOME`目录的便携式应用。

在容器内通过命令行安装应用：

```bash
proot-apps install filezilla
```

支持的应用列表见[此处](https://github.com/linuxserver/proot-apps?tab=readme-ov-file#supported-apps)。

#### 原生应用（非持久化）

可使用[universal-package-install](https://github.com/linuxserver/docker-mods/tree/universal-package-install)模块从系统原生仓库安装软件包。此方法会增加容器启动时间，且不持久。在`compose.yaml`中添加：

```yaml
environment:
  - DOCKER_MODS=linuxserver/mods:universal-package-install
  - INSTALL_PACKAGES=libfuse2|git|gdb
```

## Docker部署方案示例

### Docker Compose配置

推荐使用Docker Compose进行部署，创建`compose.yaml`文件：

```yaml
---
services:
  obsidian:
    image: lscr.io/linuxserver/obsidian:latest
    container_name: obsidian
    environment:
      - PUID=1000               # 用户ID，通过id命令获取
      - PGID=1000               # 组ID，通过id命令获取
      - TZ=Etc/UTC              # 时区，如Asia/Shanghai
      - CUSTOM_USER=admin       # 可选，HTTP认证用户名
      - PASSWORD=yourpassword   # 可选，HTTP认证密码
      - LC_ALL=zh_CN.UTF-8      # 可选，设置为中文界面
    volumes:
      - /path/to/config:/config # 配置目录，替换为实际路径
    ports:
      - 3000:3000               # HTTP端口
      - 3001:3001               # HTTPS端口
    shm_size: "1gb"             # electron应用所需的共享内存大小
    # 可选：GPU加速配置
    # devices:
    #   - /dev/dri:/dev/dri
    restart: unless-stopped
```

启动容器：

```bash
docker-compose up -d
```

### Docker Run命令

使用Docker命令直接部署：

```bash
docker run -d \
  --name=obsidian \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e CUSTOM_USER=admin \
  -e PASSWORD=yourpassword \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --shm-size="1gb" \
  # 可选：GPU加速
  # --device /dev/dri:/dev/dri \
  --restart unless-stopped \
  lscr.io/linuxserver/obsidian:latest
```

## 参数说明

容器运行时通过参数进行配置，格式为`<外部>:<内部>`。

| 参数 | 功能 |
| :----: | --- |
| `-p 3000:3000` | Obsidian桌面GUI的HTTP端口，需反向代理 |
| `-p 3001:3001` | Obsidian桌面GUI的HTTPS端口 |
| `-e PUID=1000` | 用户ID - 详见下方说明 |
| `-e PGID=1000` | 组ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 指定时区，列表见[时区数据库](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-v /config` | 容器内用户主目录，存储程序设置和文件 |
| `--shm-size=` | electron应用正常运行所需的共享内存大小 |

## 来自文件的环境变量（Docker secrets）

可通过特殊前缀`FILE__`从文件设置任何环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据`/run/secrets/mysecretvariable`文件的内容设置环境变量`MYVAR`。

## 应用运行的Umask设置

所有镜像都支持通过可选的`-e UMASK=022`设置覆盖容器内服务的默认umask。请注意，umask不是chmod，它基于其值减去权限而非添加。详情请参考[umask说明](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v`标志）时，主机OS和容器之间可能出现权限问题。通过指定用户`PUID`和组`PGID`可避免此问题。

确保主机上的任何卷目录都由您指定的相同用户拥有，权限问题将迎刃而解。

此处`PUID=1000`和`PGID=1000`，可通过以下命令获取您的用户ID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=obsidian&query=%24.mods%5B%27obsidian%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=obsidian "查看此容器的可用mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用mods")

我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)以启用容器内的附加功能。上述动态徽章可访问此镜像可用的Mods列表以及可应用于任何LinuxServer.io镜像的通用Mods。

## 支持信息

- 容器运行时的Shell访问：

  ```bash
  docker exec -it obsidian /bin/bash
  ```

- 实时监控容器日志：

  ```bash
  docker logs -f obsidian
  ```

- 容器版本号：

  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' obsidian
  ```

- 镜像版本号：

  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/obsidian:latest
  ```

## 更新信息

大多数镜像都是
