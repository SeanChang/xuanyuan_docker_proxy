---
image: linuxserver/kasm
description: "Kasm Workspaces 是一个容器流式传输平台，通过基于浏览器的方式提供对桌面、应用程序和 Web 服务的访问，采用容器化桌面基础设施 (CDI) 创建按需、一次性的 Docker 容器，适用于远程浏览器隔离、数据防泄漏、桌面即服务等场景。"
source: https://xuanyuan.cloud/zh/r/linuxserver/kasm
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[linuxserver/kasm](https://xuanyuan.cloud/zh/r/linuxserver/kasm)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/kasm

## 概述

[Kasm](https://www.kasmweb.com/?utm_campaign=LinuxServer&utm_source=listing) Workspaces 是一个 Docker 容器流式传输平台，用于提供基于浏览器的桌面、应用程序和 Web 服务访问。Kasm 利用 DevOps 支持的容器化桌面基础设施 (CDI) 创建按需、一次性的 Docker 容器，可通过 Web 浏览器访问。典型用例包括远程浏览器隔离 (RBI)、数据防泄漏 (DLP)、桌面即服务 (DaaS)、安全远程访问服务 (RAS) 和开源情报 (OSINT) 收集。

图形化容器的渲染由开源项目 [KasmVNC](https://www.kasmweb.com/kasmvnc.html?utm_campaign=LinuxServer&utm_source=kasmvnc) 提供支持。

## 支持的架构

该镜像利用 Docker 清单实现多平台支持。只需拉取 `lscr.io/linuxserver/kasm:latest` 即可获取适合您架构的正确镜像，也可通过标签拉取特定架构的镜像。

支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 应用设置

此容器使用 [Docker in Docker](https://www.docker.com/blog/docker-can-now-run-within-docker/)，需要以 `privileged`（特权）模式运行。容器初始设置需通过 3000 端口进行。

**与其他容器不同，Web 界面端口（默认 443）需要通过环境变量 `KASM_PORT` 设置，且内部和外部端口需保持一致，例如使用 4443 端口时，需设置 `KASM_PORT=4443` 并映射 `-p 4443:4443`**

**Unraid 用户注意：由于 DinD 存储层限制，`/opt/` 应直接挂载到磁盘（如 `/mnt/disk1/appdata/path`），或最优选择挂载到缓存磁盘（如 `/mnt/cache/appdata/path`）**

通过 https://`您的 IP`:3000 访问安装向导并按照说明操作。设置完成后，通过 https://`您的 IP`:443 访问，使用设置过程中输入的凭据登录。默认用户如下：
* admin@kasm.local
* user@kasm.local

目前不支持群晖系统，因为其内核阻止 CPU 调度。

### 更新 KASM

要更新 Kasm，首先确保使用最新的 Docker 镜像，然后在管理面板中执行应用内更新。仅更新 Docker 镜像和重新创建容器不会更新 Kasm。

### GPU 支持

安装过程中会提供一个选项，强制所有工作区容器挂载并使用特定 GPU。如果使用 NVIDIA GPU，需传递 `-e NVIDIA_VISIBLE_DEVICES=all` 或 `--gpus all`，并在主机上安装 [NVIDIA Container Runtime](https://github.com/NVIDIA/nvidia-container-runtime)。此外，Kasm Workspaces 对 NVIDIA 有[原生支持](https://www.kasmweb.com/docs/latest/how_to/gpu.html)，您也可选择使用该原生支持而非安装时的手动覆盖。

### 游戏手柄支持

要正确创建虚拟游戏手柄，需从主机挂载 `/dev/input` 和 `/run/udev/data`。有关启用游戏手柄支持的说明，请参见[此处](https://www.kasmweb.com/docs/develop/guide/gamepad_passthrough.html)。

### 持久化配置文件

要在工作区中使用持久化配置文件，需从主机挂载一个文件夹到 `/profiles`。配置工作区时，可将“持久化配置文件路径”设置为例如 `/profiles/ubuntu-focal/{username}/`，更多信息见[此处](https://www.kasmweb.com/docs/latest/how_to/persistent_profiles.html)。

### 反向代理

[SWAG](https://github.com/linuxserver/docker-swag) 的示例配置可在[此处](https://raw.githubusercontent.com/linuxserver/reverse-proxy-confs/master/kasm.subdomain.conf.sample)找到。安装后，需按照[此处](https://www.kasmweb.com/docs/latest/how_to/reverse_proxy.html#update-zones)所述，将默认区域下的“代理端口”设置修改为 0，以启动工作区会话。

### 严格反向代理

此镜像默认使用自签名证书，因此协议为 `https`。如果使用验证证书的反向代理，需[禁用对容器的证书检查](https://docs.linuxserver.io/faq#strict-proxy)。

## 使用方法

以下提供 docker-compose 和 docker cli 两种方式帮助您创建容器。

>[!NOTE]
>除非参数标记为“可选”，否则均为必填项，必须提供值。

### docker-compose（推荐，[点击查看更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
services:
  kasm:
    image: lscr.io/linuxserver/kasm:latest
    container_name: kasm
    privileged: true
    security_opt:
      - apparmor:rootlesskit #可选
    environment:
      - KASM_PORT=443
      - DOCKER_HUB_USERNAME=USER #可选
      - DOCKER_HUB_PASSWORD=PASS #可选
      - DOCKER_MTU=1500 #可选
    volumes:
      - /path/to/kasm/data:/opt
      - /path/to/kasm/profiles:/profiles #可选
      - /dev/input:/dev/input #可选
      - /run/udev/data:/run/udev/data #可选
    ports:
      - 3000:3000
      - 443:443
    restart: unless-stopped
```

### docker cli（[点击查看更多信息](https://docs.docker.com/engine/reference/commandline/cli/)）

```bash
docker run -d \
  --name=kasm \
  --privileged \
  --security-opt apparmor=rootlesskit `#可选` \
  -e KASM_PORT=443 \
  -e DOCKER_HUB_USERNAME=USER `#可选` \
  -e DOCKER_HUB_PASSWORD=PASS `#可选` \
  -e DOCKER_MTU=1500 `#可选` \
  -p 3000:3000 \
  -p 443:443 \
  -v /path/to/kasm/data:/opt \
  -v /path/to/kasm/profiles:/profiles `#可选` \
  -v /dev/input:/dev/input `#可选` \
  -v /run/udev/data:/run/udev/data `#可选` \
  --restart unless-stopped \
  lscr.io/linuxserver/kasm:latest
```

## 参数说明

容器通过运行时传递的参数进行配置，格式为 `<外部>:<内部>`。例如，`-p 8080:80` 表示将容器内的 80 端口映射到主机的 8080 端口。

| 参数 | 功能 |
| :----: | --- |
| `-p 3000:3000` | Kasm 安装向导端口（https）。 |
| `-p 443:443` | Kasm Workspaces 界面端口（https）。 |
| `-e KASM_PORT=443` | 指定 Kasm Workspaces 绑定到外部的端口。 |
| `-e DOCKER_HUB_USERNAME=USER` | 可选，指定用于拉取私有镜像的 DockerHub 用户名。 |
| `-e DOCKER_HUB_PASSWORD=PASS` | 可选，指定用于拉取私有镜像的 DockerHub 密码。 |
| `-e DOCKER_MTU=1500` | 可选，指定传递给 dockerd 的 mtu 选项。 |
| `-v /opt` | Docker 和安装存储路径。 |
| `-v /profiles` | 可选，指定持久化配置文件存储路径。 |
| `-v /dev/input` | 可选，用于游戏手柄支持。 |
| `-v /run/udev/data` | 可选，用于游戏手柄支持。 |
| `--security-opt apparmor=rootlesskit` | 部分主机需要此选项，以确保 DinD 层内的命名空间正常工作。 |

## 来自文件的环境变量（Docker secrets）

您可以通过特殊前缀 `FILE__` 从文件设置任何环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这会根据 `/run/secrets/mysecretvariable` 文件的内容设置环境变量 `MYVAR`。

## 应用程序的 Umask 设置

我们的所有镜像都支持使用可选的 `-e UMASK=022` 设置来覆盖容器内服务的默认 umask。请注意，umask 不是 chmod，它基于其值减去权限而非添加。请在请求支持前阅读[此处](https://en.wikipedia.org/wiki/Umask)了解更多信息。

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=kasm&query=%24.mods%5B%27kasm%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=kasm "查看此容器的可用 Mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用 Mods")

我们发布了各种 [Docker Mods](https://github.com/linuxserver/docker-mods) 以启用容器内的附加功能。上述动态徽章可访问此镜像的可用 Mods 列表（如有）以及可应用于任何 LinuxServer 镜像的通用 Mods。

## 支持信息

* 容器运行时的 Shell 访问：

    ```bash
    docker exec -it kasm /bin/bash
    ```

* 实时监控容器日志：

    ```bash
    docker logs -f kasm
    ```

* 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' kasm
    ```

* 镜像版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/kasm:latest
    ```

## 更新信息

我们的大多数镜像都是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部应用。除了相关 readme.md 中注明的例外情况，我们不建议或支持在容器内更新应用。请参阅上面的[应用设置](#application-setup)部分，了解是否推荐对此镜像进行应用更新。

以下是更新容器的说明：

### 通过 Docker Compose

* 更新镜像：
    * 所有镜像：

        ```bash
        docker-compose pull
        ```

    * 单个镜像：

        ```bash
        docker-compose pull kasm
        ```

* 更新容器：
    * 所有容器：

        ```bash
        docker-compose up -d
        ```

    * 单个容器：

        ```bash
        docker-compose up -d kasm
        ```

* 还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过 Docker Run

* 更新镜像：

    ```bash
    docker pull lscr.io/linuxserver/kasm:latest
    ```

* 停止运行中的容器：

    ```bash
    docker stop kasm
    ```

* 删除容器：

    ```bash
    docker rm kasm
    ```

* 使用上述相同的 docker run 参数重新创建新容器（如果正确映射到主机文件夹，您的 `/config` 文件夹和设置将被保留）
* 还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun（Docker 镜像更新通知器）

>[!TIP]
>我们推荐使用 [Diun](https://crazymax.dev/diun/) 获取更新通知。不建议或支持使用其他自动无人值守更新容器的工具。

## 本地构建

如果您想为开发目的对这些镜像进行本地修改或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-kasm.git
cd docker-kasm
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/kasm:latest .
```

可以使用 `lscr.io/linuxserver/qemu-static` 在 x86_64 硬件上构建 ARM 变体，反之亦然：

```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```

注册后，可以使用 `-f Dockerfile.aarch64` 指定要使用的 dockerfile。

## 版本历史

* **08.06.25:** - 弃用 develop 分支。
* **03.06.25:** - 基于 Ubuntu Noble 重新构建，支持 1.17.0 版本。
* **09.11.24:** - 更新基础镜像以支持 1.16.1 版本。
* **24.09.24:** - 在 Docker 构建逻辑中添加基础用户，以在容器升级时保留。
* **17.09.24:** - 更新基础镜像以支持 1.16.0 版本，并修复 Nvidia 支持。
* **16.02.24:** - 更新基础镜像以支持 1.15.0 版本。
* **22.08.23:** - 更新基础镜像以支持 1.14.0 版本。
* **07.04.23:** - 添加 mod 层以引入 LSIO 镜像，支持 1.13.0 版本。
* **28.03.23:** - 将 compose 固定到 2.5.0，与上游要求同步。
* **05.11.22:** - 基于 Jammy 重新构建，添加 GPU 支持和游戏手柄支持。
* **23.09.22:** - 迁移到 s6v3。
* **02.07.22:** - 初始发布。
