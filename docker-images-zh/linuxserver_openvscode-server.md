---
image: linuxserver/openvscode-server
description: "LinuxServer.io提供的OpenVSCode Server Docker镜像，支持通过浏览器访问远程服务器进行代码编辑与开发，具备轻量部署、跨平台兼容特性。"
source: https://xuanyuan.cloud/zh/r/linuxserver/openvscode-server
canonical: https://xuanyuan.cloud/zh/r/linuxserver/openvscode-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/openvscode-server" title="linuxserver/openvscode-server Docker 镜像中文简介、标签列表与拉取命令">linuxserver/openvscode-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/openvscode-server

## 镜像概述和主要用途

[Openvscode-server](https://github.com/gitpod-io/openvscode-server) 提供了一个 VS Code 版本，它在远程机器上运行服务器，并允许通过现代 Web 浏览器进行访问。该 Docker 镜像由 LinuxServer.io 团队维护，确保应用的定期更新、安全加固和跨平台支持。

## 核心功能和特性

- **定期应用更新**：及时获取最新版本的 OpenVSCode Server
- **灵活的用户映射**：通过 PUID/PGID 轻松配置容器内用户权限
- **自定义基础镜像**：集成 s6 叠加层，提供可靠的服务管理
- **每周系统更新**：基础操作系统定期更新，共享通用层以减少存储空间占用、 downtime 和带宽消耗
- **常规安全更新**：持续加固镜像安全性
- **多架构支持**：兼容 x86-64 和 arm64 架构
- **安全访问控制**：支持通过令牌或密钥文件保护 Web UI 访问
- **sudo 权限配置**：可选择性启用终端 sudo 访问及密码配置

## 使用场景和适用范围

- **远程开发环境**：在服务器上部署开发环境，通过浏览器随时随地访问
- **团队协作平台**：为团队提供统一的开发环境，确保环境一致性
- **低配置设备开发**：在高性能服务器上运行 VS Code，通过低配置设备的浏览器访问
- **临时开发环境**：快速部署隔离的开发环境，用完即弃
- **教学/演示环境**：为学生或演示者提供即时可用的 VS Code 环境
- **CI/CD 集成**：作为自动化流程中的代码编辑和审查节点

## 支持的架构

该镜像利用 Docker 清单实现多平台支持。直接拉取 `lscr.io/linuxserver/openvscode-server:latest` 即可获取对应架构的正确镜像，也可通过标签指定特定架构。

| 架构   | 支持情况 | 标签格式               |
| :----- | :------- | :--------------------- |
| x86-64 | ✅        | amd64-\<version tag\>  |
| arm64  | ✅        | arm64v8-\<version tag\> |

## 版本标签

| 标签      | 支持情况 | 描述                 |
| :-------- | :------- | :------------------- |
| latest    | ✅        | 稳定版本             |
| insiders  | ✅        | 内测版本（开发版）   |

## 应用设置

### 基本访问

- 若设置了 `CONNECTION_TOKEN` 或 `CONNECTION_SECRET` 环境变量，可通过 `http://<您的IP>:3000/?tkn=supersecrettoken` 访问 Web UI（将 `supersecrettoken` 替换为实际设置的值）
- 若未设置安全令牌，可直接通过 `http://<您的IP>:3000` 访问 Web UI

### GitHub 集成

1. 将 SSH 密钥放入 `/config/.ssh` 目录
2. 从顶部菜单打开终端，执行以下命令配置 GitHub 用户名和邮箱：

```bash
git config --global user.name "用户名"
git config --global user.email "邮箱地址"
```

### 反向代理配置（SWAG）

当通过 SWAG 反向代理时，OpenVSCode Server 内特定端口运行的自定义服务可通过 `https://PORT.openvscode-server.domain.com` 访问。需创建通配符 CNAME `*.openvscode-server.domain.com` 并确保 SWAG 证书覆盖这些子域。

## 使用方法

以下提供 docker-compose 和 docker cli 两种部署方式。

> [!NOTE]
> 除非标记为“可选”，否则所有参数均为必填项，必须提供值。

### Docker Compose（推荐）

```yaml
---
services:
  openvscode-server:
    image: docker.xuanyuan.run/linuxserver/openvscode-server:latest
    container_name: openvscode-server
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - CONNECTION_TOKEN= #可选
      - CONNECTION_SECRET= #可选
      - SUDO_PASSWORD=password #可选
      - SUDO_PASSWORD_HASH= #可选
    volumes:
      - /path/to/openvscode-server/config:/config
    ports:
      - 3000:3000
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=openvscode-server \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e CONNECTION_TOKEN= `#可选` \
  -e CONNECTION_SECRET= `#可选` \
  -e SUDO_PASSWORD=password `#可选` \
  -e SUDO_PASSWORD_HASH= `#可选` \
  -p 3000:3000 \
  -v /path/to/openvscode-server/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/openvscode-server:latest
```

## 参数说明

容器通过运行时参数进行配置，格式为 `<外部>:<内部>`。例如 `-p 8080:80` 表示将容器内 80 端口映射到主机 8080 端口。

| 参数                  | 功能说明                                                                 |
| :-------------------- | :----------------------------------------------------------------------- |
| `-p 3000:3000`        | Web UI 端口                                                              |
| `-e PUID=1000`        | 用户ID - 详见下文说明                                                     |
| `-e PGID=1000`        | 组ID - 详见下文说明                                                       |
| `-e TZ=Etc/UTC`       | 指定时区，详见[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e CONNECTION_TOKEN=` | 可选，Web UI 访问安全令牌（如 `supersecrettoken`）                          |
| `-e CONNECTION_SECRET=` | 可选，容器内包含安全令牌的文件路径（如 `/path/to/file`），优先级高于 `CONNECTION_TOKEN` |
| `-e SUDO_PASSWORD=password` | 可选，设置后用户在终端中拥有 sudo 权限，密码为此处指定值                     |
| `-e SUDO_PASSWORD_HASH=` | 可选，通过哈希值设置 sudo 密码（优先级高于 `SUDO_PASSWORD`），格式为 `$类型$盐值$哈希值` |
| `-v /config`          | 包含所有相关配置文件                                                       |

## 来自文件的环境变量（Docker 密钥）

可通过特殊前缀 `FILE__` 从文件设置任何环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据 `/run/secrets/mysecretvariable` 文件内容设置环境变量 `MYVAR`。

## 运行应用的 Umask 设置

所有镜像均支持通过可选参数 `-e UMASK=022` 覆盖容器内服务的默认 umask 设置。请注意，umask 是通过减法调整权限，而非直接设置权限。详情请参考[umask 说明](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v` 参数）时，主机与容器间可能出现权限问题。通过指定用户 `PUID` 和组 `PGID` 可避免此问题。确保主机上的卷目录归指定用户所有，权限问题将迎刃而解。

使用 `id your_user` 命令可获取当前用户的 PUID 和 PGID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=openvscode-server&query=%24.mods%5B%27openvscode-server%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=openvscode-server "查看此容器可用的模块") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看通用模块")

我们提供多种 [Docker Mods](https://github.com/linuxserver/docker-mods) 以扩展容器功能。上方徽章链接可访问此镜像专用模块及适用于所有 LinuxServer.io 镜像的通用模块列表。

## 支持信息

### 容器运行时 Shell 访问

```bash
docker exec -it openvscode-server /bin/bash
```

### 实时监控容器日志

```bash
docker logs -f openvscode-server
```

### 容器版本号

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' openvscode-server
```

### 镜像版本号

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/openvscode-server:latest
```

## 更新信息

大多数镜像为静态版本，需通过更新镜像并重建容器来更新应用。以下是更新容器的说明：

### 通过 Docker Compose 更新

#### 更新镜像
- 所有镜像：
  ```bash
  docker-compose pull
  ```
- 单个镜像：
  ```bash
  docker-compose pull openvscode-server
  ```

#### 更新容器
- 所有容器：
  ```bash
  docker-compose up -d
  ```
- 单个容器：
  ```bash
  docker-compose up -d openvscode-server
  ```

#### 清理旧镜像
```bash
docker image prune
```

### 通过 Docker Run 更新

#### 更新镜像
```bash
docker pull docker.xuanyuan.run/linuxserver/openvscode-server:latest
```

#### 停止运行中的容器
```bash
docker stop openvscode-server
```

#### 删除容器
```bash
docker rm openvscode-server
```

#### 用相同参数重建容器
（若正确映射主机目录，`/config` 文件夹及设置将被保留）

#### 清理旧镜像
```bash
docker image prune
```

> [!TIP]
> 推荐使用 [Diun](https://crazymax.dev/diun/) 接收更新通知。不建议使用自动更新容器的工具。

## 本地构建

如需修改镜像进行开发或自定义，可按以下步骤本地构建：

```bash
git clone https://github.com/linuxserver/docker-openvscode-server.git
cd docker-openvscode-server
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/openvscode-server:latest .
```

可使用 `lscr.io/linuxserver/qemu-static` 在 x86_64 硬件上构建 ARM 变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，可使用 `-f Dockerfile.aarch64` 指定架构对应的 Dockerfile。

## 版本历史

- **19.08.24:** - 基于 Ubuntu Noble 重新构建
- **01.07.23:** - 移除 armhf 架构支持（详见[公告](https://www.linuxserver.io/blog/a-farewell-to-arm-hf)）
- **29.09.22:** - 基于 Jammy 重新构建，切换到 s6v3，修复 chown 逻辑以跳过 `/config/workspace` 内容
- **12.02.22:** - 更新 `install-extension` 工具以适配上游变更
- **04.02.22:** - 更新 1.64.0+ 版本二进制文件，支持未设置令牌访问，添加 libsecret 以支持 keytar
- **29.12.21:** - 添加 `install-extension` 工具供模块安装扩展
- **10.12.21:** - 更新已弃用的 connectionToken 参数
- **30.11.21:** - 修复应用文件夹权限，添加可选 sudo 密码变量
- **29.11.21:** - 为用户创建 `.profile` 和 `.bashrc`
- **29.11.21:** - 发布 `insiders` 标签
- **28.11.21:** - 初始发布
