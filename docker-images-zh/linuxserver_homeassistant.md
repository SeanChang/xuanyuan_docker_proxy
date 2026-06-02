---
image: linuxserver/homeassistant
description: "LinuxServer提供的Home Assistant Docker镜像，是一款功能强大的家庭自动化平台，可集中管理智能家居设备，支持数百种设备协议与品牌，通过可视化界面与自动化规则实现场景联动。该镜像基于轻量级架构构建，集成完善的社区插件生态，支持数据持久化与安全更新，帮助用户轻松搭建个性化智能家庭系统，简化部署流程并降低维护成本，打造高效、智能的现代生活体验。"
source: https://xuanyuan.cloud/zh/r/linuxserver/homeassistant
canonical: https://xuanyuan.cloud/zh/r/linuxserver/homeassistant
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [linuxserver/homeassistant — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/linuxserver/homeassistant)

含镜像标签、拉取命令、部署文档与相关推荐。

[linuxserver/homeassistant Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/linuxserver/homeassistant)

# LinuxServer.io Docker Home Assistant 容器介绍


## LinuxServer.io 团队简介

[LinuxServer.io]([]) 团队致力于提供高质量 Docker 容器，其发布的容器具有以下特点：  
- 应用定期及时更新  
- 简单的用户权限映射（通过 PGID、PUID 配置）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周更新基础操作系统，通过跨生态共享通用层减少存储空间占用、 downtime 和带宽消耗  
- 定期安全更新  


### 社区与支持渠道  
- [博客]([])：容器使用指南、教程及技术观点  
- []()：实时社区支持与团队交流  
- [Discourse]([])：社区论坛，可发布问题与讨论  
- [GitHub]([])：所有仓库源代码  
- [Open Collective]([])：支持我们的捐赠或预算贡献平台  


## LinuxServer/HomeAssistant 容器

该容器基于 [Home Assistant Core]([]) 构建。Home Assistant 是一款开源家庭自动化工具，强调本地控制与隐私保护，适合运行在树莓派或本地服务器上，由全球爱好者社区支持。


### 支持的架构  

容器通过 Docker manifest 实现多平台支持，拉取 `lscr.io/linuxserver/homeassistant:latest` 即可自动匹配对应架构。也可通过标签指定特定架构：  

| 架构       | 支持状态 | 标签格式               |  
| :--------- | :------- | :--------------------- |  
| x86-64     | ✅        | amd64-\<version tag\>  |  
| arm64      | ✅        | arm64v8-\<version tag\> |  


## 应用设置  

容器基于 Home Assistant Core 构建，Web 界面地址为 `[]  


### 网络模式：Host 与 Bridge  

Home Assistant 依赖 zeroconf/mDNS 和 UPnP 协议自动发现网络设备，**需使用 `--net=host` 模式**才能确保设备发现功能正常。  


### 蓝牙设备访问  

若需让 Home Assistant 访问主机蓝牙设备，需：  
1. 在主机安装 BlueZ；  
2. 为容器添加 `NET_ADMIN` 和 `NET_RAW` 权限；  
3. 映射 dbus 卷。  

示例配置：  
- **Docker CLI**：  
  ```bash
  --cap-add=NET_ADMIN --cap-add=NET_RAW -v /run/dbus:/run/dbus:ro
  ```  
- **Docker Compose**：  
  ```yaml
  cap_add:
    - NET_ADMIN
    - NET_RAW
  volumes:
    - /run/dbus:/run/dbus:ro
  ```  
若主机 dbus 路径不同（如 `/var/run/dbus`），可映射为 `-v /var/run/dbus:/run/dbus:ro`。  


### Ping 集成  

使用 [Ping 集成]([]) 需为容器添加 `NET_RAW` 权限（配置同上）。  


## 使用方法  

可通过 Docker Compose（推荐）或 Docker CLI 启动容器。**除标记为“可选”的参数外，其余均为必填项**。  


### Docker Compose  

```yaml
---
services:
  homeassistant:
    image: lscr.io/linuxserver/homeassistant:latest
    container_name: homeassistant
    network_mode: host  # 设备发现需用 host 模式
    environment:
      - PUID=1000        # 用户 ID，通过 `id 用户名` 查看
      - PGID=1000        # 组 ID，同上
      - TZ=Etc/UTC       # 时区，如 Asia/Shanghai
    volumes:
      - /path/to/homeassistant/data:/config  # 本地配置目录映射
    ports:
      - 8123:8123  # 可选，非 host 模式下需手动映射端口
    devices:
      - /path/to/device:/path/to/device  # 可选，映射 USB/串口设备
    restart: unless-stopped
```  


### Docker CLI  

```bash
docker run -d \
  --name=homeassistant \
  --net=host \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 8123:8123 `# 可选，非 host 模式使用` \
  -v /path/to/homeassistant/data:/config \
  --device /path/to/device:/path/to/device `# 可选，映射设备` \
  --restart unless-stopped \
  lscr.io/linuxserver/homeassistant:latest
```  


## 参数说明  

| 参数                  | 作用说明                                                                 |  
| :-------------------- | :----------------------------------------------------------------------- |  
| `--net=host`          | 共享主机网络，设备发现必需                                                 |  
| `-p 8123`             | Web 界面端口，仅非 host 模式使用                                           |  
| `-e PUID=1000`        | 用户 ID，避免权限问题（通过 `id 用户名` 获取）                              |  
| `-e PGID=1000`        | 组 ID，同上                                                               |  
| `-e TZ=Etc/UTC`       | 时区，参考 [时区列表]() |  
| `-v /config`          | Home Assistant 配置文件存储路径                                            |  
| `--device /path/to/device` | 映射 USB、串口或 GPIO 设备（可选）                                         |  


## 环境变量与文件（Docker Secrets）  

可通过 `FILE__` 前缀从文件加载环境变量，例如：  
```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable  # 从文件 /run/secrets/mysecretvariable 加载 MYVAR
```  


## Umask 设置  

通过 `-e UMASK=022` 可覆盖容器内服务的默认 umask（权限掩码）。umask 用于限制新文件权限，具体规则参考 [umask 说明]()。  


## 用户/组 ID  

使用卷（`-v`）时，需确保主机目录所有者与容器内 `PUID`/`PGID` 一致，避免权限问题。通过 `id 用户名` 可查看当前用户的 UID/GID：  
```bash
id 用户名  # 示例输出：uid=1000(用户) gid=1000(用户) 组=1000(用户)
```  


## Docker Mods  

可通过 [Docker Mods]([]) 扩展容器功能。访问以下链接查看可用 Mods：  
- [Home Assistant 专用 Mods]([])  
- [通用 Mods]([])  


## 支持信息  

- **容器内 shell 访问**：  
  ```bash
  docker exec -it homeassistant /bin/bash
  ```  

- **实时查看日志**：  
  ```bash
  docker logs -f homeassistant
  ```  

- **查看容器版本**：  
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' homeassistant
  ```  

- **查看镜像版本**：  
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/homeassistant:latest
  ```  


## 更新方法  

容器需通过更新镜像并重建来升级应用。  


### Docker Compose 更新  

- **更新镜像**：  
  ```bash
  docker-compose pull  # 更新所有镜像
  # 或仅更新当前容器：docker-compose pull homeassistant
  ```  

- **重启容器**：  
  ```bash
  docker-compose up -d  # 重启所有容器
  # 或仅重启当前容器：docker-compose up -d homeassistant
  ```  

- **清理旧镜像**：  
  ```bash
  docker image prune
  ```  


### Docker CLI 更新  

- **拉取新镜像**：  
  ```bash
  docker pull lscr.io/linuxserver/homeassistant:latest
  ```  

- **停止并删除旧容器**：  
  ```bash
  docker stop homeassistant && docker rm homeassistant
  ```  

- **用原参数重建容器**（配置文件在 `/config` 中，不会丢失）：  
  ```bash
  # 重新执行 docker run 命令（同上“Docker CLI”部分）
  ```  

- **清理旧镜像**：  
  ```bash
  docker image prune
  ```  


### 镜像更新通知  

推荐使用 [Diun]([]) 接收更新通知，不建议使用自动更新工具。  


## 本地构建  

如需自定义容器，可本地构建：  

```bash
git clone [] docker-homeassistant
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/homeassistant:latest .
```  

**跨架构构建**：需先注册 qemu-static：  
```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```  
然后指定架构 Dockerfile，例如 `-f Dockerfile.aarch64`。  


## 版本历史  

- **02.10.25**：基于 Alpine 3.22 重建，依赖基础镜像服务修复 USB 设备权限。  
- **19.09.25**：添加必要权限，允许非特权用户访问蓝牙栈。  
- **03.01.25**：基于 Alpine 3.21 重建。  
- **07.11.24**：添加 go2rtc 二进制文件。  
- **07.10.24**：使用 `uv` 替代 `pip` 管理 Python 包。  
- **13.02.24**：基于 Alpine 3.19 重建，升级 Python 3.12，调整 Python 包结构。  
- **05.07.23**：不再支持 armhf 架构。  
- **30.01.21**：初始发布。
