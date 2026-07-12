---
image: linuxserver/tester
description: "LinuxServer的docker-tester镜像，用于在Docker环境中执行测试任务，支持自动化测试流程，简化开发部署中的质量验证。"
source: https://xuanyuan.cloud/zh/r/linuxserver/tester
canonical: https://xuanyuan.cloud/zh/r/linuxserver/tester
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/tester" title="linuxserver/tester Docker 镜像中文简介、标签列表与拉取命令">linuxserver/tester 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/tester

## 镜像概述和主要用途

`linuxserver/tester` 是一个内部工具，用作CI流程中的桌面沙箱，用于获取功能端点的截图。该镜像由LinuxServer.io团队维护，提供了一个轻量级的测试环境，用于验证应用程序端点的可用性和显示效果。

**注意：该镜像已被弃用。我们将不再为该镜像提供支持，也不会进行更新。**

## 核心功能和特性

- 定期及时的应用程序更新
- 简单的用户映射 (PGID, PUID)
- 带有s6覆盖层的自定义基础镜像
- 每周基础操作系统更新，在整个LinuxServer.io生态系统中共享通用层，以最小化空间使用、停机时间和带宽
- 定期安全更新
- 多平台支持

## 支持的架构

该镜像利用docker manifest实现多平台支持。只需拉取 `lscr.io/linuxserver/tester:latest` 即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

支持的架构:

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ❌ | |
| armhf | ❌ | |

## 使用场景和适用范围

该镜像主要用于LinuxServer.io团队内部的CI/CD流程，作为桌面环境沙箱来测试Web应用程序端点并捕获截图。它可用于：

- 自动化UI测试流程
- 验证Web应用程序在不同环境中的显示效果
- CI/CD管道中的端点功能验证
- 生成应用程序界面截图用于文档

## 使用方法和配置说明

### Docker Compose (推荐)

```yaml
---
version: "2.1"
services:
  tester:
    image: docker.xuanyuan.run/linuxserver/tester:latest
    container_name: tester
    environment:
      - URL=http://google.com
    ports:
      - 3000:3000
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=tester \
  -e URL=http://google.com \
  -p 3000:3000 \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/tester:latest
```

## 参数说明

容器镜像通过运行时传递的参数进行配置。这些参数用冒号分隔，表示 `<外部>:<内部>`。例如，`-p 8080:80` 会将容器内的端口 `80` 暴露到主机IP的端口 `8080` 上。

| 参数 | 功能 |
| :----: | --- |
| `-p 3000` | Web界面端口 |
| `-e URL=http://google.com` | 指定端点，容器将自动确定正确的协议和使用的程序 |

## 环境变量

### 从文件设置环境变量 (Docker secrets)

您可以使用特殊的前缀 `FILE__` 从文件中设置任何环境变量。

例如：

```bash
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

这将根据 `/run/secrets/mysecretpassword` 文件的内容设置环境变量 `PASSWORD`。

### 运行应用程序的Umask设置

对于我们所有的镜像，您可以使用可选的 `-e UMASK=022` 设置来覆盖容器内启动的服务的默认umask设置。请注意，umask不是chmod，它基于其值减去权限，而不是添加权限。

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=tester&query=%24.mods%5B%27tester%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=tester "查看此容器可用的mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用mods")

我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)，以在容器内启用额外功能。可通过上方的动态徽章访问此镜像可用的Mods列表（如有）以及可应用于我们任何镜像的通用Mods。

## 支持信息

- 容器运行时的Shell访问：`docker exec -it tester /bin/bash`
- 实时监控容器日志：`docker logs -f tester`
- 容器版本号
  - `docker inspect -f '{{ index .Config.Labels "build_version" }}' tester`
- 镜像版本号
  - `docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/tester:latest`

## 更新信息

大多数镜像都是静态的、版本化的，需要更新镜像并重新创建容器来更新内部的应用程序。除了一些例外（如nextcloud、plex），我们不建议或支持在容器内更新应用程序。

### 通过Docker Compose更新

- 更新所有镜像：`docker-compose pull`
  - 或更新单个镜像：`docker-compose pull tester`
- 让compose根据需要更新所有容器：`docker-compose up -d`
  - 或更新单个容器：`docker-compose up -d tester`
- 您还可以删除旧的悬空镜像：`docker image prune`

### 通过Docker Run更新

- 更新镜像：`docker pull docker.xuanyuan.run/linuxserver/tester:latest`
- 停止运行中的容器：`docker stop tester`
- 删除容器：`docker rm tester`
- 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）
- 您还可以删除旧的悬空镜像：`docker image prune`

### 通过Watchtower自动更新器更新（仅在您不记得原始参数时使用）

- 拉取最新标签的镜像并使用相同的环境变量替换它：

  ```bash
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker.xuanyuan.run/containrrr/watchtower \
  --run-once tester
  ```

- 您还可以删除旧的悬空镜像：`docker image prune`

**注意：我们不认可使用Watchtower作为现有Docker容器自动更新的解决方案。事实上，我们通常不鼓励自动更新。但是，对于您忘记原始参数的容器，这是一个有用的一次性手动更新工具。从长远来看，我们强烈建议使用[Docker Compose](https://docs.linuxserver.io/general/docker-compose)。**

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-tester.git
cd docker-tester
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/tester:latest .
```

可以使用`multiarch/qemu-user-static`在x86_64硬件上构建ARM变体：

```bash
docker run --rm --privileged docker.xuanyuan.run/multiarch/qemu-user-static:register --reset
```

注册后，您可以使用`-f Dockerfile.aarch64`指定要使用的dockerfile。

## 版本历史

- **25.04.23:** - 弃用通知。
- **16.04.23:** - 使用Chromium镜像作为基础。
- **16.11.22:** - 恢复rdesktop基础镜像的sesman更改，该更改引入了延迟。
- **24.10.22:** - 重新基于Alpine 3.16，迁移到s6v3。
- **18.04.20:** - 初始发布。
