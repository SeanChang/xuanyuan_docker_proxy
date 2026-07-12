---
image: lsiodev/webtop
description: "提供基于Web的桌面环境，允许用户通过浏览器远程访问和使用图形界面应用程序的Docker镜像。"
source: https://xuanyuan.cloud/zh/r/lsiodev/webtop
canonical: https://xuanyuan.cloud/zh/r/lsiodev/webtop
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/lsiodev/webtop" title="lsiodev/webtop Docker 镜像中文简介、标签列表与拉取命令">lsiodev/webtop 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/webtop 中文技术文档


## 镜像概述和主要用途

[Webtop](https://github.com/linuxserver/docker-webtop) 是由 LinuxServer.io 团队开发的 Docker 镜像，提供基于 Alpine、Ubuntu、Fedora 和 Arch 等操作系统的完整桌面环境，支持多种桌面环境（如 XFCE、KDE、MATE 等），可通过任何现代 Web 浏览器访问。该镜像旨在为用户提供便捷的远程桌面体验，适用于需要通过浏览器快速访问图形化桌面环境的场景。


## 核心功能和特性

- **多平台支持**：提供多种操作系统（Alpine、Ubuntu、Fedora、Arch、Debian）和桌面环境（XFCE、KDE、MATE、i3、Openbox、IceWM）的组合选择。
- **定期更新**：包括应用程序、基础操作系统和安全补丁的定期更新。
- **用户权限映射**：支持通过 PUID/PGID 轻松配置用户权限，避免权限问题。
- **自定义基础镜像**：基于 s6 overlay 构建，提供稳定的进程管理。
- **Web 访问**：通过 HTTP（3000 端口）或 HTTPS（3001 端口）访问桌面环境，无需额外客户端。
- **GPU 加速支持**：可挂载主机 GPU 设备实现图形加速（仅支持开源驱动）。
- **Docker 集成**：支持 Docker-in-Docker（DinD）或挂载主机 Docker 套接字，便于在容器内使用 Docker。
- **国际化支持**：通过 Docker Mods 实现多语言支持。


## 使用场景和适用范围

- **远程桌面访问**：无需安装 VNC 客户端，通过浏览器即可访问完整桌面环境。
- **开发环境**：快速部署包含图形化工具的临时开发环境。
- **演示环境**：为用户提供图形化应用的在线演示。
- **低资源设备**：在服务器或嵌入式设备上提供轻量级图形化界面。
- **多环境测试**：在不同操作系统（如 Alpine、Ubuntu）和桌面环境组合中测试应用兼容性。


## 支持的架构

该镜像通过 Docker Manifest 支持多平台，直接拉取 `lscr.io/linuxserver/webtop:latest` 即可获取对应架构的镜像，也可通过标签指定具体架构：

| 架构       | 支持状态 | 标签格式               |
| :--------- | :------- | :--------------------- |
| x86-64     | ✅        | amd64-\<version tag\>  |
| arm64      | ✅        | arm64v8-\<version tag\> |
| armhf      | ❌        | -                      |


## 版本标签

镜像提供多种版本标签，对应不同操作系统和桌面环境组合：

| 标签                | 支持状态 | 描述                |
| :------------------ | :------- | :------------------ |
| latest              | ✅        | XFCE (Alpine)       |
| ubuntu-xfce         | ✅        | XFCE (Ubuntu)       |
| fedora-xfce         | ✅        | XFCE (Fedora)       |
| arch-xfce           | ✅        | XFCE (Arch)         |
| debian-xfce         | ✅        | XFCE (Debian)       |
| alpine-kde          | ✅        | KDE (Alpine)        |
| ubuntu-kde          | ✅        | KDE (Ubuntu)        |
| fedora-kde          | ✅        | KDE (Fedora)        |
| arch-kde            | ✅        | KDE (Arch)          |
| debian-kde          | ✅        | KDE (Debian)        |
| alpine-mate         | ✅        | MATE (Alpine)       |
| ubuntu-mate         | ✅        | MATE (Ubuntu)       |
| fedora-mate         | ✅        | MATE (Fedora)       |
| arch-mate           | ✅        | MATE (Arch)         |
| debian-mate         | ✅        | MATE (Debian)       |
| alpine-i3           | ✅        | i3 (Alpine)         |
| ubuntu-i3           | ✅        | i3 (Ubuntu)         |
| fedora-i3           | ✅        | i3 (Fedora)         |
| arch-i3             | ✅        | i3 (Arch)           |
| debian-i3           | ✅        | i3 (Debian)         |
| alpine-openbox      | ✅        | Openbox (Alpine)    |
| ubuntu-openbox      | ✅        | Openbox (Ubuntu)    |
| fedora-openbox      | ✅        | Openbox (Fedora)    |
| arch-openbox        | ✅        | Openbox (Arch)      |
| debian-openbox      | ✅        | Openbox (Debian)    |
| alpine-icewm        | ✅        | IceWM (Alpine)      |
| ubuntu-icewm        | ✅        | IceWM (Ubuntu)      |
| fedora-icewm        | ✅        | IceWM (Fedora)      |
| arch-icewm          | ✅        | IceWM (Arch)        |
| debian-icewm        | ✅        | IceWM (Debian)      |


## 应用设置

### 访问方式
Webtop 桌面环境可通过以下地址访问：
- HTTP: `http://你的主机IP:3000/`
- HTTPS: `https://你的主机IP:3001/`


### 安全配置
现代 GUI 桌面应用（包括部分终端）可能与 Docker 默认的 syscall 限制存在兼容性问题，需添加以下参数以允许必要的系统调用：
```bash
--security-opt seccomp=unconfined
```


### 容器升级说明
与其他容器不同，Webtop 桌面环境不支持通过 Docker 直接升级。升级容器时，用户主目录（`/config`）的内容会保留，但系统级安装的应用将丢失。如需保持系统级应用，建议通过操作系统自带的包管理器（如 `apt`、`apk`、`dnf`、`pacman`）定期更新。


### KasmVNC 高级配置
该镜像基于 Docker Baseimage KasmVNC 构建，支持以下可选配置：

#### 可选环境变量
| 变量名          | 描述                                                                 |
| :-------------- | :------------------------------------------------------------------- |
| CUSTOM_PORT     | HTTP 监听端口（默认 3000）                                            |
| CUSTOM_HTTPS_PORT | HTTPS 监听端口（默认 3001）                                          |
| CUSTOM_USER     | HTTP 基本认证用户名（默认 `abc`）                                      |
| PASSWORD        | HTTP 基本认证密码（默认 `abc`，不设置则禁用认证）                       |
| SUBFOLDER       | 反向代理子路径（需包含前后斜杠，如 `/webtop/`）                        |
| TITLE           | 浏览器页面标题（默认 "KasmVNC Client"）                                |
| FM_HOME         | 文件管理器默认目录（默认 `/config`）                                   |
| START_DOCKER    | 设为 `false` 时，特权模式下不自动启动 DinD（Docker-in-Docker）          |
| DRINODE         | 指定 DRI3 GPU 加速设备（如 `/dev/dri/renderD128`）                     |

#### 可选运行参数
| 参数                                  | 描述                                                                 |
| :------------------------------------ | :------------------------------------------------------------------- |
| `--privileged`                        | 启用 DinD 环境，可配合 `-v /home/user/docker-data:/var/lib/docker` 提升性能 |
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载主机 Docker 套接字，允许容器内操作主机 Docker                     |
| `--device /dev/dri:/dev/dri`          | 挂载主机 GPU 设备（仅支持开源驱动，如 Intel、AMDGPU、Nouveau）         |


### 多语言支持
通过 `universal-internationalization` Docker Mod 实现非英语语言支持，需指定 ISO 639 语言代码（如中文 `zh_CN.UTF-8`、德语 `de_DE.UTF-8`）。完整语言代码列表见 [LinuxServer Mods 文档](https://github.com/linuxserver/docker-mods/tree/universal-internationalization#other-languages)。

配置示例（中文支持）：
```bash
-e DOCKER_MODS=linuxserver/mods:universal-internationalization
-e LC_ALL=zh_CN.UTF-8
```

启用后，在 Web 界面的 "设置" 中开启 "IME Input Mode"，即可使用非英文输入法。


### 无损传输模式
通过将 "Stream Quality" 预设改为 "Lossless"，可实现浏览器中的无损图像传输（高帧率）。非本地访问时需使用 HTTPS（3001 端口），或通过反向代理转发 HTTP 端口时添加以下 headers：
```
Proxy-Connection: keep-alive
Connection: keep-alive
```


## 使用方法

### Docker Compose（推荐）
```yaml
---
version: "2.1"
services:
  webtop:
    image: docker.xuanyuan.run/linuxserver/webtop:latest  # 可替换为特定标签，如 ubuntu-xfce
    container_name: webtop
    security_opt:
      - seccomp:unconfined  # 解决 GUI 应用 syscall 兼容性问题
    environment:
      - PUID=1000           # 用户 ID（通过 `id your_user` 获取）
      - PGID=1000           # 组 ID（通过 `id your_user` 获取）
      - TZ=Asia/Shanghai    # 时区（如 Asia/Shanghai）
      - SUBFOLDER=/         # 反向代理子路径（如无需则保持默认）
      - TITLE=Webtop桌面     # 浏览器页面标题
    volumes:
      - /path/to/data:/config  # 持久化用户数据（替换为实际路径）
      - /var/run/docker.sock:/var/run/docker.sock  # 可选，挂载 Docker 套接字
    ports:
      - 3000:3000           # HTTP 端口
      - 3001:3001           # HTTPS 端口
    devices:
      - /dev/dri:/dev/dri   # 可选，挂载 GPU 设备（Linux 主机）
    shm_size: "1gb"         # 防止现代浏览器崩溃（建议至少 1GB）
    restart: unless-stopped
```


### Docker CLI
```bash
docker run -d \
  --name=webtop \
  --security-opt seccomp=unconfined \  # 解决 GUI 应用 syscall 兼容性问题
  -e PUID=1000 \                       # 用户 ID
  -e PGID=1000 \                       # 组 ID
  -e TZ=Asia/Shanghai \                # 时区
  -e SUBFOLDER=/ \                     # 反向代理子路径
  -e TITLE=Webtop桌面 \                 # 浏览器页面标题
  -p 3000:3000 \                       # HTTP 端口映射
  -p 3001:3001 \                       # HTTPS 端口映射
  -v /path/to/data:/config \           # 用户数据持久化
  -v /var/run/docker.sock:/var/run/docker.sock \  # 可选，挂载 Docker 套接字
  --device /dev/dri:/dev/dri \         # 可选，挂载 GPU 设备
  --shm-size="1gb" \                   # 共享内存大小
  --restart unless-stopped \
  lscr.io/linuxserver/webtop:latest    # 镜像标签
```


## 参数说明

| 参数                          | 功能描述                                                                 |
| :---------------------------- | :----------------------------------------------------------------------- |
| `-p 3000`                     | Web 桌面 HTTP 端口                                                       |
| `-p 3001`                     | Web 桌面 HTTPS 端口                                                      |
| `-e PUID=1000`                | 用户 ID，用于权限映射（通过 `id your_user` 获取）                         |
| `-e PGID=1000`                | 组 ID，用于权限映射（通过 `id your_user` 获取）                           |
| `-e TZ=Asia/Shanghai`         | 时区设置（完整列表见 [时区数据库](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)） |
| `-e SUBFOLDER=/`              | 反向代理子路径（需包含前后斜杠，如 `/webtop/`）                          |
| `-e TITLE=Webtop`             | 浏览器页面标题                                                           |
| `-v /config`                  | 用户主目录（存放配置和数据）                                             |
| `-v /var/run/docker.sock`     | 挂载主机 Docker 套接字，允许容器内使用 Docker                            |
| `--device /dev/dri`           | 挂载 GPU 设备以支持图形加速（仅 Linux 主机，需开源驱动）                   |
| `--shm-size=1gb`              | 共享内存大小，建议至少 1GB 以避免浏览器崩溃                              |
| `--security-opt seccomp=unconfined` | 禁用 seccomp 限制，解决 GUI 应用兼容性问题                               |


## 环境变量从文件加载（Docker Secrets）

通过 `FILE__` 前缀可从文件加载环境变量，例如：
```bash
-e FILE__PASSWORD=/run/secrets/webtop_password
```
上述命令会将 `/run/secrets/webtop_password` 文件内容作为 `PASSWORD` 环境变量的值。


## Umask 设置

通过 `-e UMASK=022` 可覆盖容器内服务的默认 umask 设置。注意 umask 是权限掩码（减法运算），而非直接设置权限，详细说明见 [umask 维基百科](https://en.wikipedia.org/wiki/Umask)。


## 用户/组标识符

使用 `-v` 挂载卷时，需确保主机目录权限与容器内 PUID/PGID 匹配，避免权限问题。通过以下命令获取当前用户的 UID/GID：
```bash
id your_user
```
示例输出：
```
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```


## Docker Mods

该镜像支持 LinuxServer.io 提供的 Docker Mods，以扩展功能：
- **专用 Mods**：[webtop 专用 Mods](https://mods.linuxserver.io/?mod=webtop)
- **通用 Mods**：[通用 Mods](https://mods.linuxserver.io/?mod=universal)（如国际化支持、时区调整等）

使用方法：通过 `-e DOCKER_MODS=mod1,mod2` 指定 Mods，例如启用国际化支持：
```bash
-e DOCKER_MODS=linuxserver/mods:universal-internationalization
```


## 支持信息

### 容器内命令
- 进入容器 shell：
  ```bash
  docker exec -it webtop /bin/bash
  ```

- 实时查看日志：
  ```bash
  docker logs -f webtop
  ```

- 查看容器版本：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' webtop
  ```

- 查看镜像版本：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/webtop:latest
  ```


## 更新说明

Webtop 镜像为静态版本，需通过更新镜像并重建容器来升级应用。


### 通过 Docker Compose 更新
- 更新镜像：
  ```bash
  docker-compose pull webtop  # 更新单个镜像
  # 或
  docker-compose pull         # 更新所有镜像
  ```

- 重建容器：
  ```bash
  docker-compose up -d webtop  # 重建单个容器
  # 或
  docker-compose up -d         # 重建所有容器
  ```

- 清理旧镜像：
  ```bash
  docker image prune
  ```


### 通过 Docker CLI 更新
- 更新镜像：
  ```bash
  docker pull docker.xuanyuan.run/linuxserver/webtop:latest
  ```

- 停止并删除旧容器：
  ```bash
  docker stop webtop
  docker rm webtop
  ```

- 用原参数重建容器（`/config` 目录会保留数据）


### 通过 Watchtower 自动更新（不推荐）
仅用于忘记原始运行参数时的一次性更新：
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker.xuanyuan.run/containrrr/watchtower \
  --run-once webtop
```


## 本地构建

如需自定义镜像，可通过以下步骤本地构建：
```bash
git clone https://github.com/linuxserver/docker-webtop.git
cd docker-webtop
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/webtop:latest .
```

**ARM 架构构建**：在 x86_64 主机上需先注册 QEMU 模拟器：
```bash
docker run --rm --privileged docker.xuanyuan.run/multiarch/qemu-user-static:register --reset
```
然后使用对应架构的 Dockerfile（如 `-f Dockerfile.aarch64`）。


## 版本历史

- **07.11.23**：Fedora 基础镜像升级至 39。
- **14.
