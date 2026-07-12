---
image: linuxserver/kdenlive
description: "LinuxServer提供的Kdenlive Docker镜像，用于通过容器化方式运行开源视频编辑软件，支持多轨道编辑、特效及转场功能，便于便捷部署和跨平台使用。"
source: https://xuanyuan.cloud/zh/r/linuxserver/kdenlive
canonical: https://xuanyuan.cloud/zh/r/linuxserver/kdenlive
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/kdenlive" title="linuxserver/kdenlive Docker 镜像中文简介、标签列表与拉取命令">linuxserver/kdenlive 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/kdenlive

## 镜像概述和主要用途

[Kdenlive](https://kdenlive.org/) 是由KDE社区开发的强大免费开源跨平台视频编辑软件，功能丰富且适合专业制作。LinuxServer.io团队提供的此Docker镜像将Kdenlive封装为容器化应用，便于快速部署和管理，支持通过Web浏览器访问图形界面，适用于需要在容器环境中进行视频编辑的场景。


## 核心功能和特性

- **定期应用更新**：确保软件及时获取功能改进和安全补丁
- **灵活的用户映射**：通过PUID和PGID参数轻松配置容器内用户权限
- **自定义基础镜像**：基于s6 overlay的专用基础镜像，提供可靠的进程管理
- **高效的基础镜像更新**：每周更新基础操作系统，通过共享层减少存储空间占用、 downtime和带宽消耗
- **持续安全更新**：定期应用安全补丁，增强容器运行安全性
- **多架构支持**：兼容x86-64和arm64v8架构
- **Web访问支持**：通过HTTPS协议从浏览器访问Kdenlive图形界面
- **GPU加速**：支持DRI3和Nvidia GPU加速（通过Zink），提升视频编辑性能


## 使用场景和适用范围

- **个人视频编辑**：家庭用户在容器环境中进行视频剪辑和制作
- **开发/测试环境**：安全隔离的视频编辑工具测试环境
- **教学场景**：课堂环境中快速部署统一的视频编辑软件
- **低资源设备**：在资源受限的设备上通过容器化方式运行Kdenlive
- **局域网协作**：在可信局域网内共享视频编辑工具（需配合适当认证）

> [!WARNING]
> 本容器提供对主机系统的特权访问，请勿暴露到互联网环境，除非已采取严格的安全措施。


## 详细使用方法和配置说明

### 支持的架构

| 架构 | 支持情况 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

只需拉取 `lscr.io/linuxserver/kdenlive:latest` 即可自动获取适合当前架构的镜像，也可通过上述标签指定特定架构。


### 应用访问

容器启动后，可通过以下地址访问应用：
- https://你的主机IP:3001/


### 基础部署示例

#### Docker Compose（推荐）

```yaml
---
services:
  kdenlive:
    image: docker.xuanyuan.run/linuxserver/kdenlive:latest
    container_name: kdenlive
    environment:
      - PUID=1000               # 用户ID
      - PGID=1000               # 组ID
      - TZ=Etc/UTC              # 时区
      # - CUSTOM_USER=username   # 可选：HTTP基础认证用户名
      # - PASSWORD=password      # 可选：HTTP基础认证密码
    volumes:
      - /path/to/kdenlive/config:/config  # 配置文件存储路径
    ports:
      - 3000:3000               # HTTP端口（需反向代理）
      - 3001:3001               # HTTPS端口
    shm_size: "1gb"             # 可选：增加共享内存，防止崩溃
    restart: unless-stopped
```

#### Docker Run

```bash
docker run -d \
  --name=kdenlive \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  # -e CUSTOM_USER=username \
  # -e PASSWORD=password \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/kdenlive/config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/kdenlive:latest
```


### 参数说明

| 参数 | 功能 |
| :----: | --- |
| `-p 3000:3000` | Kdenlive桌面GUI的HTTP端口（建议仅用于反向代理） |
| `-p 3001:3001` | Kdenlive桌面GUI的HTTPS端口（直接访问使用） |
| `-e PUID=1000` | 用户ID，用于权限映射（使用`id your_user`命令获取） |
| `-e PGID=1000` | 组ID，用于权限映射（使用`id your_user`命令获取） |
| `-e TZ=Etc/UTC` | 时区设置，例如`Asia/Shanghai` |
| `-e CUSTOM_USER=username` | 可选：HTTP基础认证用户名 |
| `-e PASSWORD=password` | 可选：HTTP基础认证密码 |
| `-v /config` | 容器内用户主目录，存储配置文件和数据 |
| `--shm-size=` | 共享内存大小，建议设置为`1gb`防止应用崩溃 |


### 环境变量配置

#### 基础环境变量

| 变量 | 描述 |
| :----: | --- |
| `PUID` | 容器内运行应用的用户ID |
| `PGID` | 容器内运行应用的组ID |
| `TZ` | 时区，格式如`Asia/Shanghai` |

#### Selkies基础镜像扩展环境变量

| 变量 | 描述 |
| :----: | --- |
| `CUSTOM_PORT` | 内部HTTP端口，默认`3000` |
| `CUSTOM_HTTPS_PORT` | 内部HTTPS端口，默认`3001` |
| `CUSTOM_WS_PORT` | WebSocket端口，默认`8082` |
| `CUSTOM_USER` | HTTP基础认证用户名，默认`abc` |
| `PASSWORD` | HTTP基础认证密码，未设置则禁用认证 |
| `SUBFOLDER` | 反向代理子路径，需包含前后斜杠，如`/kdenlive/` |
| `TITLE` | 浏览器页面标题，默认`Selkies` |
| `START_DOCKER` | 设置为`false`禁用Docker-in-Docker环境 |
| `DISABLE_IPV6` | 设置为`true`禁用IPv6支持 |
| `LC_ALL` | 容器区域设置，用于国际化支持 |
| `DRINODE` | 指定DRI设备节点，如`/dev/dri/renderD128` |
| `NO_DECOR` | 设置后应用无窗口边框，适合PWA使用 |
| `NO_FULL` | 设置后应用不自动全屏 |
| `DISABLE_ZINK` | 设置后禁用Zink相关环境变量配置 |
| `WATERMARK_PNG` | 水印图片路径，如`/usr/share/selkies/www/icon.png` |
| `WATERMARK_LOCATION` | 水印位置：1(左上)、2(右上)、3(左下)、4(右下)、5(居中)、6(动画) |


### 安全配置

#### 反向代理设置

默认情况下，镜像使用自签名证书，访问协议为`https`。若使用验证证书的反向代理，需[禁用对容器的证书检查](https://docs.linuxserver.io/faq#strict-proxy)。

#### 重要安全注意事项

- **HTTPS必要性**：现代浏览器功能（如WebCodecs视频编解码）仅在HTTPS下可用，HTTP连接将导致功能受限
- **认证机制**：默认无认证，`CUSTOM_USER`和`PASSWORD`仅提供基础HTTP认证，适合可信局域网。互联网暴露需配合反向代理（如[SWAG](https://github.com/linuxserver/docker-swag)）实现强认证
- **容器特权**：Web界面包含带无密码sudo权限的终端，任何访问者可在容器内获取root权限，需严格控制访问范围
- **Seccomp配置**：老旧内核或libseccomp环境可能需要添加`--security-opt seccomp=unconfined`参数以允许必要系统调用（降低安全性，谨慎使用）


### 高级配置

#### 国际化支持

通过`LC_ALL`环境变量设置界面语言：

| 语言 | 环境变量值 |
| :----: | --- |
| 中文 | `LC_ALL=zh_CN.UTF-8` |
| 日语 | `LC_ALL=ja_JP.UTF-8` |
| 韩语 | `LC_ALL=ko_KR.UTF-8` |
| 阿拉伯语 | `LC_ALL=ar_AE.UTF-8` |
| 俄语 | `LC_ALL=ru_RU.UTF-8` |
| 西班牙语（拉美） | `LC_ALL=es_MX.UTF-8` |
| 德语 | `LC_ALL=de_DE.UTF-8` |
| 法语 | `LC_ALL=fr_FR.UTF-8` |


#### GPU加速配置

##### DRI3 GPU加速（开源驱动）

支持Intel、AMD开源驱动及Nouveau（NVIDIA开源驱动），通过以下参数启用：

```bash
--device /dev/dri:/dev/dri
```

可配合`DRINODE`环境变量指定GPU设备节点，如`-e DRINODE=/dev/dri/renderD128`。

##### NVIDIA GPU支持

需使用Zink实现OpenGL支持，支持硬件加速视频编码，通过以下参数启用：

```bash
--gpus all --runtime nvidia
```

Docker Compose配置（需先设置Nvidia运行时为默认）：

```yaml
services:
  kdenlive:
    image: docker.xuanyuan.run/linuxserver/kdenlive:latest
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [compute,video,graphics,utility]
```


#### 应用管理

##### PRoot Apps（持久化安装）

通过`proot-apps`命令安装持久化应用（存储在`/config`目录，容器重建后保留）：

```bash
proot-apps install filezilla  # 安装FileZilla示例
```

[支持的应用列表](https://github.com/linuxserver/proot-apps?tab=readme-ov-file#supported-apps)

##### 原生应用（非持久化）

通过Docker Mods安装系统原生包（容器重建后丢失）：

```yaml
environment:
  - DOCKER_MODS=linuxserver/mods:universal-package-install
  - INSTALL_PACKAGES=libfuse2|git|gdb  # 需安装的包列表，竖线分隔
```


## 用户/组ID配置

容器使用PUID和PGID映射主机用户权限，避免卷挂载时的权限问题。通过以下命令获取当前用户的ID：

```bash
id your_user
```

示例输出：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

将输出的uid和gid分别设置为`PUID`和`PGID`。


## Docker Mods

可通过Docker Mods扩展容器功能：

- [专用Mods](https://mods.linuxserver.io/?mod=kdenlive) - 针对kdenlive的特定扩展
- [通用Mods](https://mods.linuxserver.io/?mod=universal) - 适用于所有LinuxServer.io容器的通用扩展


## 支持与更新

### 容器管理命令

- **进入容器shell**：
  ```bash
  docker exec -it kdenlive /bin/bash
  ```

- **查看实时日志**：
  ```bash
  docker logs -f kdenlive
  ```

- **获取容器版本**：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' kdenlive
  ```

- **获取镜像版本**：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/kdenlive:latest
  ```


### 更新方法

#### Docker Compose

```bash
# 更新镜像
docker-compose pull kdenlive

# 重启容器
docker-compose up -d kdenlive

# 清理旧镜像
docker image prune
```

#### Docker Run

```bash
# 拉取新镜像
docker pull docker.xuanyuan.run/linuxserver/kdenlive:latest

# 停止并删除旧容器
docker stop kdenlive && docker rm kdenlive

# 用原参数启动新容器（配置通过卷保留）
docker run [原参数] lscr.io/linuxserver/kdenlive:latest

# 清理旧镜像
docker image prune
```


## 本地构建

```bash
git clone https://github.com/linuxserver/docker-kdenlive.git
cd docker-kdenlive
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/kdenlive:latest .
```

ARM架构构建（需先注册qemu-static）：
```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/kdenlive:latest .
```


## 版本历史

- **22.09.25:** - 基于Arch latest重新构建，修复AppImage在Debian发行版上的兼容性问题，恢复arm64支持
- **06.08.25:** - 修复CPU bug，默认禁用游戏手柄支持
- **12.07.25:** - 基于Selkies重建，使用官方AppImage，强制要求HTTPS，移除arm64支持
- **19.08.24:** - 基于Noble重建，使用pypi和lsio wheels
- **10.02.24:** - 更新README，添加新环境变量说明，修复PWA图标
- **24.04.23:** - 确保应用全屏启动
- **18.03.23:** - 基于KasmVNC基础镜像重建
- **16.09.22:** - 迁移至s6v3
- **09.03.22:** - 更新seccomp说明
- **07.03.22:** - 初始发布
