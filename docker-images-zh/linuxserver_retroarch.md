---
image: linuxserver/retroarch
description: "RetroArch是一个模拟器、游戏引擎和媒体播放器的前端Docker容器，支持x86-64和arm64架构，提供Web图形界面，可在多种设备上运行经典游戏，包含定期更新、GPU加速支持及安全配置选项。"
source: https://xuanyuan.cloud/zh/r/linuxserver/retroarch
canonical: https://xuanyuan.cloud/zh/r/linuxserver/retroarch
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/retroarch" title="linuxserver/retroarch Docker 镜像中文简介、标签列表与拉取命令">linuxserver/retroarch 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/retroarch

[RetroArch](https://retroarch.com/) 是一个模拟器、游戏引擎和媒体播放器的前端，通过Docker容器化部署，可在多种计算机和游戏机上运行经典游戏，提供流畅的图形界面。LinuxServer.io团队维护的此镜像包含定期应用更新、用户映射支持、自定义基础镜像及每周安全更新。

## 支持的架构

该镜像利用Docker清单实现多平台支持，拉取 `lscr.io/linuxserver/retroarch:latest` 会自动获取对应架构的镜像，也可通过标签指定特定架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 应用设置

应用可通过以下地址访问：
* https://yourhost:3001/

### 注意事项
- **纯CPU模式**：RetroArch会使用LLVMPipe进行菜单渲染，可在设置中配置菜单刷新率或挂载Nvidia GPU。首次使用Nvidia GPU时，需右键桌面并重新启动RetroArch。
- **严格反向代理**：默认使用自签名证书（https协议），若反向代理验证证书，需[禁用容器证书检查](https://docs.linuxserver.io/faq#strict-proxy)。
- **系统调用限制**：现代GUI桌面应用可能受Docker系统调用限制影响，旧内核或libseccomp版本主机可使用 `--security-opt seccomp=unconfined` 允许相关系统调用。

### 安全警告
>[!WARNING]
>此容器提供对主机系统的特权访问，请勿暴露在互联网中，除非已正确配置安全措施。

- **HTTPS要求**：完整功能需HTTPS，现代浏览器功能（如WebCodecs）不支持不安全的HTTP连接。
- **认证配置**：默认无认证，可选 `CUSTOM_USER` 和 `PASSWORD` 环境变量启用基本HTTP认证（仅适用于可信局域网）。互联网暴露时，强烈建议使用反向代理（如[SWAG](https://github.com/linuxserver/docker-swag)）增强认证。
- **终端访问**：Web界面包含无密码sudo权限的终端，任何访问GUI的用户可获取容器内root权限，需谨慎配置访问控制。

### Selkies基础镜像通用选项
基于[Docker Baseimage Selkies](https://github.com/linuxserver/docker-baseimage-selkies)，支持以下环境变量和运行配置：

#### 可选环境变量

| 变量 | 描述 |
| :----: | --- |
| `CUSTOM_PORT` | 内部HTTP端口，默认`3000` |
| `CUSTOM_HTTPS_PORT` | 内部HTTPS端口，默认`3001` |
| `CUSTOM_WS_PORT` | 内部WebSocket端口，默认`8082` |
| `CUSTOM_USER` | HTTP基本认证用户名，默认`abc` |
| `PASSWORD` | HTTP基本认证密码，未设置则禁用认证 |
| `SUBFOLDER` | 反向代理子路径，需包含首尾斜杠（如`/subfolder/`） |
| `TITLE` | 网页标题，默认"Selkies" |
| `START_DOCKER` | 设为`false`禁用Docker-in-Docker自动启动 |
| `DISABLE_IPV6` | 设为`true`禁用容器IPv6支持 |
| `LC_ALL` | 容器区域设置（如`zh_CN.UTF-8`） |
| `DRINODE` | DRI3加速指定设备（如`/dev/dri/renderD128`） |
| `NO_DECOR` | 设为true禁用窗口边框（适合PWA） |
| `NO_FULL` | 设为true禁用自动全屏 |
| `DISABLE_ZINK` | 设为true禁用Zink环境变量配置 |
| `WATERMARK_PNG` | 水印图片路径（如`/usr/share/selkies/www/icon.png`） |
| `WATERMARK_LOCATION` | 水印位置：1(左上)、2(右上)、3(左下)、4(右下)、5(居中)、6(动画) |

#### 可选运行配置

| 参数 | 描述 |
| :----: | --- |
| `--privileged` | 启动Docker-in-Docker环境，建议挂载主机Docker数据目录（如`-v /path/to/docker-data:/var/lib/docker`）提升性能 |
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载主机Docker socket，用于管理主机容器 |
| `--device /dev/dri:/dev/dri` | 挂载GPU设备，结合`DRINODE`环境变量使用，仅支持开源驱动（Intel、AMDGPU、Radeon、ATI、Nouveau） |

### 语言支持 - 国际化

通过`LC_ALL`环境变量设置桌面会话语言，例如：
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

挂载渲染设备实现应用/游戏加速，命令：
`--device /dev/dri:/dev/dri`

支持的开源GPU驱动：
| 驱动 | 描述 |
| :----: | --- |
| Intel | i965和i915驱动（Intel iGPU芯片组） |
| AMD | AMDGPU、Radeon和ATI驱动（AMD独立显卡或APU芯片组） |
| NVIDIA | 仅nouveau2驱动，闭源NVIDIA驱动不支持DRI3 |

`DRINODE`环境变量可指定特定GPU，aarch64架构需容器内安装对应芯片组驱动。

### Nvidia GPU支持

>**注意：Alpine基础镜像不支持Nvidia。**

通过Zink实现OpenGL支持，兼容Nvidia GPU时自动用于硬件加速视频编码（x264enc全帧配置文件），降低CPU负载。

启用Nvidia支持的运行时标志：
| 标志 | 描述 |
| :----: | --- |
| `--gpus all` | 传递主机所有GPU（可指定特定GPU） |
| `--runtime nvidia` | 指定Nvidia运行时，提供主机驱动和工具 |

Docker Compose配置需先设置Nvidia为默认运行时：
```bash
sudo nvidia-ctk runtime configure --runtime=docker --set-as-default
sudo systemctl restart docker
```

`compose.yaml`中配置GPU：
```yaml
services:
  retroarch:
    image: docker.xuanyuan.run/linuxserver/retroarch:latest
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [compute,video,graphics,utility]
```

### 应用管理

#### PRoot Apps（持久化，推荐）

原生安装包（如`apt-get install`）在容器重建后不持久，推荐使用[proot-apps](https://github.com/linuxserver/proot-apps)安装到用户持久`$HOME`目录：
```bash
proot-apps install filezilla
```
支持的应用列表见[此处](https://github.com/linuxserver/proot-apps?tab=readme-ov-file#supported-apps)。

#### Native Apps（非持久化）

通过[universal-package-install](https://github.com/linuxserver/docker-mods/tree/universal-package-install) mod安装系统原生包（增加启动时间，不持久），`compose.yaml`配置：
```yaml
environment:
  - DOCKER_MODS=linuxserver/mods:universal-package-install
  - INSTALL_PACKAGES=libfuse2|git|gdb
```

## 使用方法

### docker-compose（推荐）

```yaml
---
services:
  retroarch:
    image: docker.xuanyuan.run/linuxserver/retroarch:latest
    container_name: retroarch
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

### docker cli

```bash
docker run -d \
  --name=retroarch \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/retroarch:latest
```

## 参数说明

| 参数 | 功能 |
| :----: | --- |
| `-p 3000:3000` | RetroArch桌面GUI HTTP端口（需代理） |
| `-p 3001:3001` | RetroArch桌面GUI HTTPS端口 |
| `-e PUID=1000` | 用户ID（见下方说明） |
| `-e PGID=1000` | 组ID（见下方说明） |
| `-e TZ=Etc/UTC` | 时区，列表见[此处](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-v /config` | 容器内用户主目录，存储本地文件和设置 |
| `--shm-size=` | RetroArch运行必需的共享内存大小 |

## 环境变量文件（Docker secrets）

使用`FILE__`前缀从文件设置环境变量：
```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```
`MYVAR`值将设为`/run/secrets/mysecretvariable`文件内容。

## 应用运行的Umask设置

通过`-e UMASK=022`覆盖默认umask，详情见[umask说明](https://en.wikipedia.org/wiki/Umask)。

## 用户/组ID

卷挂载时，权限问题可通过指定`PUID`（用户ID）和`PGID`（组ID）解决，确保主机卷目录所有者与指定ID一致。使用`id your_user`查看：
```bash
id your_user
```
输出示例：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=retroarch&query=%24.mods%5B%27retroarch%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=retroarch "查看此容器可用mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看通用mods")

## 支持信息

- 容器运行时Shell访问：
  ```bash
  docker exec -it retroarch /bin/bash
  ```

- 实时监控容器日志：
  ```bash
  docker logs -f retroarch
  ```

- 容器版本号：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' retroarch
  ```

- 镜像版本号：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/retroarch:latest
  ```

## 更新方法

### 通过Docker Compose

- 更新镜像：
  - 所有镜像：
    ```bash
    docker-compose pull
    ```
  - 单个镜像：
    ```bash
    docker-compose pull retroarch
    ```

- 更新容器：
  - 所有容器：
    ```bash
    docker-compose up -d
    ```
  - 单个容器：
    ```bash
    docker-compose up -d retroarch
    ```

- 清理旧镜像：
  ```bash
  docker image prune
  ```

### 通过Docker Run

- 更新镜像：
  ```bash
  docker pull docker.xuanyuan.run/linuxserver/retroarch:latest
  ```

- 停止运行中的容器：
  ```bash
  docker stop retroarch
  ```

- 删除容器：
  ```bash
  docker rm retroarch
  ```

- 使用相同参数重新创建容器（`/config`目录映射正确则设置保留）

- 清理旧镜像：
  ```bash
  docker image prune
  ```

### 镜像更新通知 - Diun

>[!TIP]
>推荐使用[Diun](https://crazymax.dev/diun/)获取更新通知，不建议使用自动更新容器的工具。

## 本地构建

```bash
git clone https://github.com/linuxserver/docker-retroarch.git
cd docker-retroarch
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/retroarch:latest .
```

跨架构构建（如x86_64构建ARM）：
```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```
然后使用 `-f Dockerfile.aarch64` 指定架构Dockerfile。

## 版本历史

- **25.05.25:** - 初始版本。
