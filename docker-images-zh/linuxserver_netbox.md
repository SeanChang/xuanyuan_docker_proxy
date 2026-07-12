---
image: linuxserver/netbox
description: "LinuxServer提供的NetBox镜像，用于IP地址管理（IPAM）和数据中心基础设施管理（DCIM），支持网络与数据中心基础设施的高效管理。"
source: https://xuanyuan.cloud/zh/r/linuxserver/netbox
canonical: https://xuanyuan.cloud/zh/r/linuxserver/netbox
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/netbox" title="linuxserver/netbox Docker 镜像中文简介、标签列表与拉取命令">linuxserver/netbox 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/netbox Docker 镜像文档

## 镜像概述和主要用途

[Netbox](https://github.com/netbox-community/netbox) 是一款 IP 地址管理 (IPAM) 和数据中心基础设施管理 (DCIM) 工具。最初由 DigitalOcean 网络工程团队设计，专门用于满足网络和基础设施工程师的需求，旨在作为网络运营的特定领域事实来源。

LinuxServer.io 团队提供的该容器镜像具有以下特点：
- 定期及时的应用更新
- 简便的用户映射 (PGID, PUID)
- 基于 s6 覆盖层的自定义基础镜像
- 每周基础操作系统更新，通过整个 LinuxServer.io 生态系统的通用层减少空间占用、停机时间和带宽
- 定期安全更新


## 核心功能和特性

### Netbox 核心功能
- IP 地址管理 (IPAM)：IPv4/IPv6 地址空间管理、子网分配、VLAN 跟踪
- 数据中心基础设施管理 (DCIM)：设备机架、机房布局、供电系统管理
- 网络设备管理：路由器、交换机、防火墙等网络设备的配置和状态跟踪
- 线缆管理：物理和逻辑连接的可视化管理
- 自定义字段和标签：支持扩展属性以满足特定组织需求

### 容器镜像特性
- 多架构支持：兼容 x86-64 和 arm64 架构
- 灵活的权限管理：通过 PUID/PGID 避免权限冲突
- 环境变量配置：支持通过环境变量自定义 Netbox 配置
- 持久化存储：配置文件通过卷挂载持久化
- 远程认证集成：支持外部认证系统集成


## 适用场景和范围

- 企业网络基础设施管理
- 数据中心资源规划与跟踪
- 网络运维团队的 IP 地址规划
- 云基础设施与物理设备的统一管理
- 需要集中化网络资产记录的组织


## 支持的架构

该镜像利用 Docker manifest 实现多平台支持。直接拉取 `lscr.io/linuxserver/netbox:latest` 即可获取对应架构的正确镜像，也可通过标签指定特定架构：

| 架构 | 支持情况 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |


## 应用部署准备

Netbox 运行依赖 PostgreSQL 数据库和 Redis 实例，需提前部署并配置。部署完成后，通过 `<你的IP>:8000` 访问 Web 界面。


## 使用方法

### Docker Compose (推荐)

```yaml
---
services:
  netbox:
    image: docker.xuanyuan.run/linuxserver/netbox:latest
    container_name: netbox
    environment:
      - PUID=1000               # 用户ID，详见下方用户/组标识符说明
      - PGID=1000               # 组ID，详见下方用户/组标识符说明
      - TZ=Etc/UTC              # 时区，例如 Asia/Shanghai
      - SUPERUSER_EMAIL=        # 管理员账户邮箱 (必填)
      - SUPERUSER_PASSWORD=     # 管理员账户密码 (必填)
      - ALLOWED_HOST=           # 访问域名，例如 netbox.example.com (必填)
      - DB_NAME=                # 数据库名称 (必填，默认: netbox)
      - DB_USER=                # 数据库用户 (必填)
      - DB_PASSWORD=            # 数据库密码 (必填)
      - DB_HOST=                # 数据库主机地址 (必填)
      - DB_PORT=                # 数据库端口 (必填，默认: 5432)
      - REDIS_HOST=             # Redis 主机地址 (必填)
      - REDIS_PORT=             # Redis 端口 (必填，默认: 6379)
      - REDIS_PASSWORD=         # Redis 密码 (必填，默认: 无)
      - REDIS_DB_TASK=          # Redis 任务数据库ID (必填，默认: 0)
      - REDIS_DB_CACHE=         # Redis 缓存数据库ID (必填，默认: 1)
      - BASE_PATH=              # 访问路径前缀 (可选，例如 /netbox)
      - REMOTE_AUTH_ENABLED=    # 启用远程认证 (可选，默认: False)
      - REMOTE_AUTH_BACKEND=    # 远程认证后端 (可选，默认: netbox.authentication.RemoteUserBackend)
      - REMOTE_AUTH_HEADER=     # 远程用户标识HTTP头 (可选，默认: HTTP_REMOTE_USER)
      - REMOTE_AUTH_AUTO_CREATE_USER=  # 自动创建远程认证用户 (可选，默认: False)
      - REMOTE_AUTH_DEFAULT_GROUPS=    # 远程用户默认组 (可选，默认: [])
      - REMOTE_AUTH_DEFAULT_PERMISSIONS=  # 远程用户默认权限 (可选，默认: {})
    volumes:
      - /path/to/netbox/config:/config  # 配置文件持久化路径
    ports:
      - 8000:8000               # Web访问端口映射
    restart: unless-stopped     # 重启策略
```

### Docker CLI

```bash
docker run -d \
  --name=netbox \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e SUPERUSER_EMAIL= \
  -e SUPERUSER_PASSWORD= \
  -e ALLOWED_HOST= \
  -e DB_NAME= \
  -e DB_USER= \
  -e DB_PASSWORD= \
  -e DB_HOST= \
  -e DB_PORT= \
  -e REDIS_HOST= \
  -e REDIS_PORT= \
  -e REDIS_PASSWORD= \
  -e REDIS_DB_TASK= \
  -e REDIS_DB_CACHE= \
  -e BASE_PATH= `#可选` \
  -e REMOTE_AUTH_ENABLED= `#可选` \
  -e REMOTE_AUTH_BACKEND= `#可选` \
  -e REMOTE_AUTH_HEADER= `#可选` \
  -e REMOTE_AUTH_AUTO_CREATE_USER= `#可选` \
  -e REMOTE_AUTH_DEFAULT_GROUPS= `#可选` \
  -e REMOTE_AUTH_DEFAULT_PERMISSIONS= `#可选` \
  -p 8000:8000 \
  -v /path/to/netbox/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/netbox:latest
```


## 参数说明

容器通过运行时参数进行配置，格式为 `<外部>:<内部>`。

### 端口映射

| 参数 | 功能 |
| :----: | --- |
| `-p 8000:8000` | 将容器内 8000 端口映射到主机 8000 端口，用于 Web 访问 |

### 环境变量

| 参数 | 类型 | 描述 |
| :----: | :----: | --- |
| `-e PUID=1000` | 必选 | 用户 ID，用于文件权限控制，通过 `id your_user` 命令获取 |
| `-e PGID=1000` | 必选 | 组 ID，用于文件权限控制，通过 `id your_user` 命令获取 |
| `-e TZ=Etc/UTC` | 必选 | 时区设置，例如 `Asia/Shanghai` |
| `-e SUPERUSER_EMAIL=` | 必选 | 管理员账户邮箱 |
| `-e SUPERUSER_PASSWORD=` | 必选 | 管理员账户密码 |
| `-e ALLOWED_HOST=` | 必选 | 允许访问的主机名/域名，例如 `netbox.example.com` |
| `-e DB_NAME=` | 必选 | 数据库名称，默认 `netbox` |
| `-e DB_USER=` | 必选 | 数据库访问用户 |
| `-e DB_PASSWORD=` | 必选 | 数据库访问密码 |
| `-e DB_HOST=` | 必选 | 数据库主机地址 |
| `-e DB_PORT=` | 必选 | 数据库端口，默认 `5432` |
| `-e REDIS_HOST=` | 必选 | Redis 主机地址 |
| `-e REDIS_PORT=` | 必选 | Redis 端口，默认 `6379` |
| `-e REDIS_PASSWORD=` | 必选 | Redis 访问密码，无密码则留空 |
| `-e REDIS_DB_TASK=` | 必选 | Redis 任务数据库 ID，默认 `0` |
| `-e REDIS_DB_CACHE=` | 必选 | Redis 缓存数据库 ID，默认 `1` |
| `-e BASE_PATH=` | 可选 | 访问路径前缀，例如 `/netbox`，默认无 |
| `-e REMOTE_AUTH_ENABLED=` | 可选 | 是否启用远程认证，默认 `False` |
| `-e REMOTE_AUTH_BACKEND=` | 可选 | 远程认证后端，默认 `netbox.authentication.RemoteUserBackend` |
| `-e REMOTE_AUTH_HEADER=` | 可选 | 远程用户标识 HTTP 头，默认 `HTTP_REMOTE_USER` |
| `-e REMOTE_AUTH_AUTO_CREATE_USER=` | 可选 | 是否自动创建远程认证用户，默认 `False` |
| `-e REMOTE_AUTH_DEFAULT_GROUPS=` | 可选 | 远程用户默认组，默认 `[]` |
| `-e REMOTE_AUTH_DEFAULT_PERMISSIONS=` | 可选 | 远程用户默认权限，默认 `{}` |

### 卷挂载

| 参数 | 功能 |
| :----: | --- |
| `-v /path/to/netbox/config:/config` | 将主机目录挂载到容器内 `/config`，用于持久化配置文件 |


## 从文件加载环境变量 (Docker Secrets)

可通过特殊前缀 `FILE__` 从文件加载环境变量：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

上述命令会将 `/run/secrets/mysecretvariable` 文件内容作为环境变量 `MYVAR` 的值。


## 应用 umask 设置

所有镜像支持通过可选参数 `-e UMASK=022` 覆盖默认 umask 设置。注意 umask 是权限掩码，通过减法而非加法调整权限，详情请参考 [umask 文档](https://en.wikipedia.org/wiki/Umask)。


## 用户/组标识符

使用卷挂载时，主机与容器可能出现权限问题。通过指定 `PUID` 和 `PGID` 可避免此问题。确保主机卷目录归属于指定的用户/组，权限问题将自动解决。

通过以下命令获取当前用户的 PUID 和 PGID：

```bash
id your_user
```

示例输出：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```


## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=netbox&query=%24.mods%5B%27netbox%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=netbox) [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal)

LinuxServer.io 提供多种 [Docker Mods](https://github.com/linuxserver/docker-mods) 以扩展容器功能。上述徽章链接包含适用于此镜像的特定 Mods 和通用 Mods。


## 支持信息

### 容器内命令行访问

```bash
docker exec -it netbox /bin/bash
```

### 实时查看日志

```bash
docker logs -f netbox
```

### 查看容器版本

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' netbox
```

### 查看镜像版本

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/netbox:latest
```


## 更新说明

大多数镜像为静态版本化，需更新镜像并重建容器以更新应用。不建议在容器内直接更新应用。

### 通过 Docker Compose 更新

#### 更新镜像
- 更新所有镜像：
  ```bash
  docker-compose pull
  ```
- 更新单个镜像：
  ```bash
  docker-compose pull netbox
  ```

#### 更新容器
- 更新所有容器：
  ```bash
  docker-compose up -d
  ```
- 更新单个容器：
  ```bash
  docker-compose up -d netbox
  ```

#### 清理旧镜像
```bash
docker image prune
```

### 通过 Docker Run 更新

#### 更新镜像
```bash
docker pull docker.xuanyuan.run/linuxserver/netbox:latest
```

#### 停止并删除旧容器
```bash
docker stop netbox
docker rm netbox
```

#### 重建容器
使用上述 [Docker CLI](#docker-cli) 命令重建容器（若卷映射正确，配置将被保留）

#### 清理旧镜像
```bash
docker image prune
```

### 镜像更新通知 - Diun

推荐使用 [Diun](https://crazymax.dev/diun/) 接收更新通知，不建议使用自动更新容器的工具。


## 本地构建

如需本地修改或开发：

```bash
git clone https://github.com/linuxserver/docker-netbox.git
cd docker-netbox
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/netbox:latest .
```

可使用 `lscr.io/linuxserver/qemu-static` 在 x86_64 硬件上构建 ARM 变体：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后可通过 `-f Dockerfile.aarch64` 指定架构 Dockerfile。


## 版本历史

- **26.08.24:** 重构初始化流程以支持插件作为 mods
- **16.07.24:** 添加 LDAP 支持所需包
- **01.06.24:** 基于 Alpine 3.20 重建
- **23.12.23:** 基于 Alpine 3.19 重建
- **11.06.23:** 基于 Alpine 3.18 重建，弃用 armhf 架构
- **14.05.23:** 首次运行时构建本地文档
- **05.03.23:** 基于 Alpine 3.17 重建
- **02.11.22:** 基于 Alpine 3.16 重建，迁移至 s6v3
- **01.08.22:** 移除 py3-pillow，添加 tiff 修复依赖
- **26.07.22:** 在 arm 架构上重新添加 py3-pillow 修复构建问题
- **10.12.21:** 移除 py3-pillow 修复 3.2.0 版本依赖问题
- **10.12.21:** 基于 Alpine 3.15 重建
- **26.04.21:** 添加 Redis 数据库环境变量
- **03.02.21:** 添加远程认证环境变量
- **02.01.21:** 添加 BASE_PATH 环境变量
- **23.08.20:** 初始发布
