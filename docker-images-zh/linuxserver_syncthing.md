<!-- xuanyuan-docker-images-zh
image: linuxserver/syncthing
source: https://xuanyuan.cloud/zh/r/linuxserver/syncthing
canonical: https://xuanyuan.cloud/zh/r/linuxserver/syncthing
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [linuxserver/syncthing — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/linuxserver/syncthing "linuxserver/syncthing Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/linuxserver/syncthing

# linuxserver/syncthing 镜像文档

## 镜像概述和主要用途

[Syncthing](https://syncthing.net) 是一款开源的文件同步工具，可替代专有同步和云服务，提供开放、可信和去中心化的文件同步解决方案。您的数据完全由您掌控，可自主选择存储位置、是否与第三方共享以及如何通过互联网传输。

LinuxServer.io 团队提供的此容器镜像具有以下特点：
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 带有 s6 overlay 的自定义基础镜像
- 每周基础 OS 更新，在整个 LinuxServer.io 生态系统中共享通用层，以最小化空间占用、停机时间和带宽
- 定期安全更新

## 核心功能和特性

- 去中心化文件同步：无需中心服务器即可在多设备间直接同步文件
- 安全传输：使用 TLS 加密保护所有数据传输
- 版本控制：保留文件历史版本，支持文件恢复
- Web 管理界面：通过直观的 Web UI 管理同步配置和监控状态
- 跨平台支持：可与 Windows、macOS、Linux、Android 等多种平台设备同步
- 增量同步：仅传输文件更改部分，节省带宽
- 冲突解决：智能处理文件冲突，保留双方更改

## 使用场景和适用范围

- 个人文件备份与同步：在个人多台设备间同步文档、照片和其他重要文件
- 团队协作：小型团队内部共享工作文件，无需依赖第三方云服务
- 家庭媒体共享：在家庭网络中的多台设备间同步媒体文件
- 服务器备份：在不同位置的服务器之间同步备份数据
- 开发环境同步：保持多台开发设备环境配置一致

## 支持的架构

该镜像利用 Docker manifest 实现多平台支持。只需拉取 `lscr.io/linuxserver/syncthing:latest` 即可获取适合您架构的正确镜像，也可通过标签拉取特定架构的镜像。

支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 应用设置

**注意：** Syncthing 开发团队强烈建议为此容器设置密码，因为它监听 0.0.0.0 地址。设置方法：进入 `操作 -> 设置 -> 设置用户/密码` 配置 Web UI 访问密码。

## 使用方法和配置说明

### Docker Compose (推荐)

```yaml
---
services:
  syncthing:
    image: lscr.io/linuxserver/syncthing:latest
    container_name: syncthing
    hostname: syncthing # 可选
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/syncthing/config:/config
      - /path/to/data1:/data1
      - /path/to/data2:/data2
    ports:
      - 8384:8384
      - 22000:22000/tcp
      - 22000:22000/udp
      - 21027:21027/udp
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=syncthing \
  --hostname=syncthing `# 可选` \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 8384:8384 \
  -p 22000:22000/tcp \
  -p 22000:22000/udp \
  -p 21027:21027/udp \
  -v /path/to/syncthing/config:/config \
  -v /path/to/data1:/data1 \
  -v /path/to/data2:/data2 \
  --restart unless-stopped \
  lscr.io/linuxserver/syncthing:latest
```

## 参数说明

容器通过运行时传递的参数进行配置，格式为 `<外部>:<内部>`。

### 网络参数

| 参数 | 功能 |
| :----: | --- |
| `--hostname=` | 可选，定义主机名 |
| `-p 8384:8384` | Web UI 访问端口 |
| `-p 22000:22000/tcp` | 同步监听端口 (TCP) |
| `-p 22000:22000/udp` | 同步监听端口 (UDP) |
| `-p 21027:21027/udp` | 协议发现端口 |

### 环境变量

| 参数 | 功能 |
| :----: | --- |
| `-e PUID=1000` | 用户 ID - 详见下方说明 |
| `-e PGID=1000` | 组 ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 时区设置，参考 [时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e UMASK=022` | 可选，覆盖容器内服务的默认 umask 设置 |

### 卷映射

| 参数 | 功能 |
| :----: | --- |
| `-v /config` | 配置文件存储路径 |
| `-v /data1` | 数据卷 1 |
| `-v /data2` | 数据卷 2（可根据需要添加更多） |

## 环境变量从文件加载（Docker secrets）

可以通过特殊前缀 `FILE__` 从文件设置任何环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据 `/run/secrets/mysecretvariable` 文件的内容设置环境变量 `MYVAR`。

## 用户/组标识符

使用卷映射 (`-v` 标志) 时，主机 OS 和容器之间可能出现权限问题。通过指定用户 `PUID` 和组 `PGID` 可以避免此问题。

确保主机上的任何卷目录都由您指定的相同用户拥有，权限问题将迎刃而解。

此处示例中 `PUID=1000` 和 `PGID=1000`，可通过以下命令查找您的用户 ID 和组 ID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

我们发布了各种 [Docker Mods](https://github.com/linuxserver/docker-mods)，以启用容器内的其他功能。可通过相关渠道获取适用于此镜像的 Mods 列表以及可应用于任何 LinuxServer.io 镜像的通用 Mods。

## 支持信息

### 容器运行时 Shell 访问：

```bash
docker exec -it syncthing /bin/bash
```

### 实时监控容器日志：

```bash
docker logs -f syncthing
```

### 容器版本号：

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' syncthing
```

### 镜像版本号：

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/syncthing:latest
```

## 更新说明

大多数镜像都是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部应用。除特殊说明外，不建议或支持在容器内更新应用。

### 使用 Docker Compose 更新

#### 更新镜像：
- 所有镜像：
  ```bash
  docker-compose pull
  ```
- 单个镜像：
  ```bash
  docker-compose pull syncthing
  ```

#### 更新容器：
- 所有容器：
  ```bash
  docker-compose up -d
  ```
- 单个容器：
  ```bash
  docker-compose up -d syncthing
  ```

#### 清理旧镜像：
```bash
docker image prune
```

### 使用 Docker Run 更新

#### 更新镜像：
```bash
docker pull lscr.io/linuxserver/syncthing:latest
```

#### 停止运行中的容器：
```bash
docker stop syncthing
```

#### 删除容器：
```bash
docker rm syncthing
```

#### 使用相同参数重新创建容器（如果正确映射到主机文件夹，`/config` 文件夹和设置将被保留）

#### 清理旧镜像：
```bash
docker image prune
```

### 镜像更新通知 - Diun (Docker Image Update Notifier)

推荐使用 [Diun](https://crazymax.dev/diun/) 获取更新通知。不建议或支持使用其他自动更新容器的工具。

## 本地构建

如需为开发目的或自定义逻辑对这些镜像进行本地修改：

```bash
git clone https://github.com/linuxserver/docker-syncthing.git
cd docker-syncthing
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/syncthing:latest .
```

可使用 `lscr.io/linuxserver/qemu-static` 在 x86_64 硬件上构建 ARM 变体，反之亦然：

```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```

注册后，可使用 `-f Dockerfile.aarch64` 指定要使用的 dockerfile。

## 版本历史

- **16.08.25:** - 重新基于 Alpine 3.22 构建
- **13.08.25:** - 为 syncthing v2.0.0 使用双破折号长选项
- **03.12.24:** - 重新基于 Alpine 3.21 构建
- **06.06.24:** - 重新基于 Alpine 3.20 构建
- **05.03.24:** - 重新基于 Alpine 3.19 构建
- **05.09.23:** - 重新基于 Alpine 3.18 构建
- **01.07.23:** - 弃用 armhf 架构
- **13.02.23:** - 重新基于 Alpine 3.17 构建，迁移到 s6v3
- **17.08.22:** - 基于 Alpine 3.16 构建（使用 go 1.18）
- **03.05.22:** - 重新基于 Alpine 3.15 构建
- **05.10.21:** - 重新基于 Alpine 3.14 构建
- **12.05.21:** - 再次移除 sysctl 参数
- **03.05.21:** - 提高最大 UDP 缓冲区大小
- **03.05.21:** - 添加 22000/udp 端口映射
- **29.01.21:** - 弃用 `UMASK_SET`，改用基础镜像中的 UMASK
- **23.01.21:** - 重新基于 Alpine 3.13 构建
- **15.09.20:** - 使用 Alpine edge 仓库中的 go 进行编译，移除重复的 UMASK 环境变量，添加主机名设置
- **01.06.20:** - 重新基于 Alpine 3.12 构建
- **19.12.19:** - 重新基于 Alpine 3.11 构建
- **28.06.19:** - 重新基于 Alpine 3.10 构建
- **23.03.19:** - 切换到新的基础镜像，迁移到 arm32v7 标签
- **05.03.19:** - 更新 v1.1.0 版本的构建过程
- **22.02.19:** - 重新基于 Alpine 3.9 构建
- **16.01.19:** - 添加流水线逻辑和多架构支持
- **30.07.18:** - 重新基于 Alpine 3.8 构建并使用构建阶段
- **13.12.17:** - 重新基于 Alpine 3.7 构建
- **25.10.17:** - 添加手动设置 umask 的环境变量
- **29.07.17:** - 简化构建结构
- **28.05.17:** - 重新基于 Alpine 3.6 构建
- **08.02.17:** - 重新基于 Alpine 3.5 构建
- **01.11.16:** - 切换到从 git 源码编译最新版本
- **14.10.16:** - 添加版本层信息
- **30.09.16:** - 修复 umask
- **09.09.16:** - 为 README 添加层徽章
- **28.08.16:** - 为 README 添加徽章
- **11.08.16:** - 重新基于 Alpine Linux 构建
- **18.12.15:** - 初始测试/发布 (IronicBadger)
- **24.09.15:** - 初始开发完成 (Lonix)
