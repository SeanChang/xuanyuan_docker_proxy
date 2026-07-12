---
image: linuxserver/inkscape
description: "LinuxServer.io提供的Inkscape Docker镜像，将专业矢量图形编辑软件通过Web界面呈现，支持x86-64和arm64架构，包含安全访问控制、GPU加速选项及多语言支持，适用于本地网络中的图形设计工作流。"
source: https://xuanyuan.cloud/zh/r/linuxserver/inkscape
canonical: https://xuanyuan.cloud/zh/r/linuxserver/inkscape
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/inkscape" title="linuxserver/inkscape Docker 镜像中文简介、标签列表与拉取命令">linuxserver/inkscape 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# [linuxserver/inkscape](https://github.com/linuxserver/docker-inkscape)

[Inkscape](https://inkscape.org/) 是一款专业级矢量图形编辑软件，支持Linux、macOS和Windows系统。本Docker镜像由LinuxServer.io团队提供，将Inkscape通过Web界面呈现，便于在容器环境中部署和使用。

## 支持的架构

该镜像利用Docker manifest实现多平台支持，拉取 `lscr.io/linuxserver/inkscape:latest` 即可自动获取适合当前架构的镜像，也可通过标签指定具体架构。

| 架构 | 支持情况 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 应用设置

应用可通过以下地址访问：
* https://yourhost:3001/

### 严格反向代理

本镜像默认使用自签名证书，因此访问协议为 `https`。若使用验证证书的反向代理，需[禁用对容器的证书检查](https://docs.linuxserver.io/faq#strict-proxy)。

> **注意**：现代GUI桌面应用可能与最新Docker系统调用限制存在兼容性问题。对于内核或libseccomp版本较旧的主机，可使用 `--security-opt seccomp=unconfined` 选项允许这些系统调用。

### 安全说明

>[!WARNING]
> 本容器提供对主机系统的特权访问。除非已正确配置安全措施，否则不要将其暴露到互联网。

**HTTPS是完整功能的必要条件**：WebCodecs等现代浏览器特性（用于视频和音频处理）不支持不安全的HTTP连接。

默认情况下，容器未启用认证。可选的 `CUSTOM_USER` 和 `PASSWORD` 环境变量可启用基本HTTP认证，仅适用于可信本地网络。若需暴露到互联网，强烈建议将容器置于反向代理（如[SWAG](https://github.com/linuxserver/docker-swag)）之后，并配置 robust 认证机制。

Web界面包含带无密码`sudo`权限的终端。任何有权访问GUI的用户均可在容器内获取root权限、安装任意软件并探测本地网络。

某些 legacy 环境（如老旧硬件或过时Linux发行版）可能需要禁用标准seccomp配置文件以运行容器化桌面软件，可通过 `--security-opt seccomp=unconfined` 参数实现。仅在绝对必要时使用此选项，因其会禁用Docker的关键安全层。

## 核心功能与特性

### 可选环境变量

| 变量 | 描述 |
| :----: | --- |
| `CUSTOM_PORT` | 内部HTTP端口，默认3000 |
| `CUSTOM_HTTPS_PORT` | 内部HTTPS端口，默认3001 |
| `CUSTOM_WS_PORT` | 内部WebSocket端口，默认8082 |
| `CUSTOM_USER` | HTTP基本认证用户名，默认abc |
| `PASSWORD` | HTTP基本认证密码，未设置则禁用认证 |
| `SUBFOLDER` | 反向代理子路径，需包含首尾斜杠（如`/subfolder/`） |
| `TITLE` | 浏览器页面标题，默认"Selkies" |
| `START_DOCKER` | 设置为`false`时禁用Docker-in-Docker自动启动 |
| `DISABLE_IPV6` | 设置为`true`禁用容器IPv6支持 |
| `LC_ALL` | 容器区域设置（如`fr_FR.UTF-8`） |
| `DRINODE` | 指定DRI3 GPU设备（如`/dev/dri/renderD128`） |
| `NO_DECOR` | 设置后应用无窗口边框（适合PWA使用） |
| `NO_FULL` | 设置后应用不自动全屏 |
| `DISABLE_ZINK` | 设置后检测到显卡时不配置Zink相关环境变量 |
| `WATERMARK_PNG` | 水印图片路径（如`/usr/share/selkies/www/icon.png`） |
| `WATERMARK_LOCATION` | 水印位置：1(左上)、2(右上)、3(左下)、4(右下)、5(居中)、6(动画) |

### 可选运行配置

| 参数 | 描述 |
| :----: | --- |
| `--privileged` | 启动Docker-in-Docker环境，建议挂载主机Docker数据目录（如`-v /path/to/docker-data:/var/lib/docker`）提升性能 |
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载主机Docker套接字，以便在容器内管理主机容器 |
| `--device /dev/dri:/dev/dri` | 挂载GPU设备，可配合`DRINODE`环境变量使用，仅支持开源驱动（Intel、AMDGPU、Radeon、ATI、Nouveau） |

## 使用场景与适用范围

适用于需要在容器化环境中进行矢量图形设计的场景，如：
- 本地网络中的图形设计工作流
- 团队共享的图形编辑工作站
- 集成到CI/CD管道中的图形处理任务
- 资源受限设备上的轻量级图形设计环境

## 详细使用方法

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

### DRI3 GPU加速

为实现应用或游戏加速，可将渲染设备挂载到容器中：
```bash
--device /dev/dri:/dev/dri
```

支持的开源GPU驱动：
| 驱动 | 描述 |
| :----: | --- |
| Intel | i965和i915驱动（适用于Intel核显芯片组） |
| AMD | AMDGPU、Radeon和ATI驱动（适用于AMD独立显卡或APU芯片组） |
| NVIDIA | 仅nouveau2驱动，闭源NVIDIA驱动缺乏DRI3支持 |

`DRINODE`环境变量可指定特定GPU设备。DRI3在aarch64架构上需容器内安装对应芯片组的驱动。

### 应用管理

容器内安装应用有两种方法：PRoot Apps（推荐，持久化）和原生应用（非持久化）。

#### PRoot Apps（持久化）

通过`apt-get install`等方式安装的原生包在容器重建后不会保留。为跨容器更新保留应用和设置，建议使用[proot-apps](https://github.com/linuxserver/proot-apps)（安装到用户持久化`$HOME`目录的便携应用）。

在容器内通过命令行安装应用：
```bash
proot-apps install filezilla
```

[支持的应用列表](https://github.com/linuxserver/proot-apps?tab=readme-ov-file#supported-apps)

#### 原生应用（非持久化）

可通过[universal-package-install](https://github.com/linuxserver/docker-mods/tree/universal-package-install) mod安装系统原生仓库包。此方法会增加容器启动时间且非持久化。在`compose.yaml`中添加：
```yaml
environment:
  - DOCKER_MODS=linuxserver/mods:universal-package-install
  - INSTALL_PACKAGES=libfuse2|git|gdb
```

### Docker部署示例

#### docker-compose（推荐）

```yaml
---
services:
  inkscape:
    image: docker.xuanyuan.run/linuxserver/inkscape:latest
    container_name: inkscape
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/config:/config
    ports:
      - 3000:3000
      - 3001:3001
    shm_size: "1gb"
    restart: unless-stopped
```

#### docker cli

```bash
docker run -d \
  --name=inkscape \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/inkscape:latest
```

## 参数说明

容器运行时参数格式为`<外部>:<内部>`，以下是详细说明：

| 参数 | 功能 |
| :----: | --- |
| `-p 3000:3000` | Inkscape桌面GUI的HTTP端口（需反向代理） |
| `-p 3001:3001` | Inkscape桌面GUI的HTTPS端口 |
| `-e PUID=1000` | 用户ID（详见下方说明） |
| `-e PGID=1000` | 组ID（详见下方说明） |
| `-e TZ=Etc/UTC` | 时区设置，参考[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-v /config` | 容器内用户主目录，存储本地文件和设置 |
| `--shm-size=` | 所有桌面镜像推荐设置共享内存大小 |

## 高级配置

### 从文件设置环境变量（Docker secrets）

可通过特殊前缀`FILE__`从文件设置环境变量：
```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```
此命令会将`MYVAR`环境变量设置为`/run/secrets/mysecretvariable`文件的内容。

### 应用运行的Umask设置

所有镜像支持通过`-e UMASK=022`覆盖默认umask设置。注意umask是权限减法而非加法，详情参考[umask说明](https://en.wikipedia.org/wiki/Umask)。

### 用户/组ID

使用卷（`-v`参数）时，主机与容器可能出现权限问题。通过指定`PUID`（用户ID）和`PGID`（组ID）可避免此问题。确保主机卷目录归属于指定的用户ID。

通过以下命令获取当前用户的PUID和PGID：
```bash
id your_user
```
示例输出：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=inkscape&query=%24.mods%5B%27inkscape%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=inkscape "查看此容器的可用mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看通用mods")

我们提供多种[Docker Mods](https://github.com/linuxserver/docker-mods)以扩展容器功能。上述徽章链接可访问此镜像的专用mods和适用于所有镜像的通用mods。

## 支持信息

* 容器运行时的Shell访问：
  ```bash
  docker exec -it inkscape /bin/bash
  ```

* 实时监控容器日志：
  ```bash
  docker logs -f inkscape
  ```

* 容器版本号：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' inkscape
  ```

* 镜像版本号：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/inkscape:latest
  ```

## 更新方法

大多数镜像为静态、版本化，需更新镜像并重建容器以更新应用（部分镜像除外，详见对应README）。不建议或支持在容器内更新应用。

### 通过Docker Compose更新

* 更新镜像：
  * 所有镜像：
    ```bash
    docker-compose pull
    ```
  * 单个镜像：
    ```bash
    docker-compose pull inkscape
    ```

* 更新容器：
  * 所有容器：
    ```bash
    docker-compose up -d
    ```
  * 单个容器：
    ```bash
    docker-compose up -d inkscape
    ```

* 清理旧镜像：
  ```bash
  docker image prune
  ```

### 通过Docker Run更新

* 更新镜像：
  ```bash
  docker pull docker.xuanyuan.run/linuxserver/inkscape:latest
  ```

* 停止运行中的容器：
  ```bash
  docker stop inkscape
  ```

* 删除容器：
  ```bash
  docker rm inkscape
  ```

* 使用相同参数重建容器（若卷映射正确，`/config`目录和设置将保留）

* 清理旧镜像：
  ```bash
  docker image prune
  ```

### 镜像更新通知 - Diun（Docker镜像更新通知器）

>[!TIP]
>推荐使用[Diun](https://crazymax.dev/diun/)接收更新通知。不建议或支持使用自动更新容器的工具。

## 本地构建

如需修改镜像进行开发或自定义：
```bash
git clone https://github.com/linuxserver/docker-inkscape.git
cd docker-inkscape
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/inkscape:latest .
```

可使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体（反之亦然）：
```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，可使用`-f Dockerfile.aarch64`指定架构对应的Dockerfile。

## 版本历史

* **12.07.25:** - 基于Selkies和Alpine 3.22重建，HTTPS现已成为必要条件。
* **06.12.24:** - 基于Alpine 3.21重建。
* **23.05.24:** - 基于Alpine 3.20重建。
* **10.02.24:** - 更新README，添加新环境变量并引入正确的PWA图标。
* **07.12.23:** - 初始发布。
