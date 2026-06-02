---
image: linuxserver/webtop
description: "LinuxServer/webtop是轻量级Docker镜像，提供基于网页的Linux桌面环境，支持XFCE、KDE等多种桌面环境，内置浏览器、LibreOffice办公套件及基础工具。可通过HTTP/HTTPS协议远程访问并支持密码保护，适合开发者远程调试、家庭服务器管理或低配置设备临时办公。由LinuxServer团队维护，确保安全更新与稳定运行。"
source: https://xuanyuan.cloud/zh/r/linuxserver/webtop
canonical: https://xuanyuan.cloud/zh/r/linuxserver/webtop
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/webtop" title="linuxserver/webtop Docker 镜像中文简介、标签列表与拉取命令">linuxserver/webtop 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LinuxServer.io Webtop 容器介绍


## LinuxServer.io 团队简介  
[LinuxServer.io]([]) 团队专注于提供高质量容器解决方案，其容器产品具有以下特点：  
- 定期及时的应用更新  
- 简单的用户权限映射（PGID、PUID）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周基础系统更新，通过跨生态通用层减少存储空间占用、 downtime 和带宽消耗  
- 常规安全更新  

您可以通过以下渠道了解更多或获取支持：  
- [博客]([])：容器使用指南、教程及观点分享  
- []()：实时社区交流与技术支持  
- [Discourse]([])：社区论坛  
- [GitHub]([])：代码仓库  
- [Open Collective]([])：支持我们的开发与维护  


## Webtop 容器概述  
[Webtop]([]) 是基于 Alpine、Ubuntu、Fedora 及 Arch 系统的容器，内置完整桌面环境（如 XFCE、i3、KDE 等），可通过任何现代浏览器访问。  


## 支持的架构  
容器通过 Docker Manifest 实现多平台支持。直接拉取 `lscr.io/linuxserver/webtop:latest` 即可自动匹配对应架构，也可通过标签指定具体架构：  

| 架构       | 支持情况 | 标签格式               |  
| :--------- | :------- | :--------------------- |  
| x86-64     | ✅        | amd64-\<version tag\>  |  
| arm64      | ✅        | arm64v8-\<version tag\> |  


## 版本标签  
不同标签对应不同系统基础和桌面环境，选择时需注意稳定性（避免使用开发版标签）：  

| 标签           | 支持情况 | 描述                     |  
| :------------- | :------- | :----------------------- |  
| latest         | ✅        | Alpine 系统 + XFCE 桌面  |  
| alpine-i3      | ✅        | Alpine 系统 + i3 桌面    |  
| alpine-mate    | ✅        | Alpine 系统 + MATE 桌面  |  
| arch-i3        | ✅        | Arch 系统 + i3 桌面      |  
| arch-kde       | ✅        | Arch 系统 + KDE 桌面     |  
| arch-mate      | ✅        | Arch 系统 + MATE 桌面    |  
| arch-xfce      | ✅        | Arch 系统 + XFCE 桌面    |  
| debian-i3      | ✅        | Debian 系统 + i3 桌面    |  
| debian-kde     | ✅        | Debian 系统 + KDE 桌面   |  
| debian-mate    | ✅        | Debian 系统 + MATE 桌面  |  
| debian-xfce    | ✅        | Debian 系统 + XFCE 桌面  |  
| el-i3          | ✅        | Enterprise Linux + i3    |  
| el-mate        | ✅        | Enterprise Linux + MATE  |  
| el-xfce        | ✅        | Enterprise Linux + XFCE  |  
| fedora-i3      | ✅        | Fedora 系统 + i3 桌面    |  
| fedora-kde     | ✅        | Fedora 系统 + KDE 桌面   |  
| fedora-mate    | ✅        | Fedora 系统 + MATE 桌面  |  
| fedora-xfce    | ✅        | Fedora 系统 + XFCE 桌面  |  
| ubuntu-i3      | ✅        | Ubuntu 系统 + i3 桌面    |  
| ubuntu-kde     | ✅        | Ubuntu 系统 + KDE 桌面   |  
| ubuntu-mate    | ✅        | Ubuntu 系统 + MATE 桌面  |  
| ubuntu-xfce    | ✅        | Ubuntu 系统 + XFCE 桌面  |  


## 应用部署  

### 访问地址  
部署后可通过以下 URL 访问桌面环境：  
`[]  


### 反向代理配置  
容器默认使用自签名证书，因此需通过 HTTPS 访问。若反向代理验证证书，需[关闭对容器的证书检查]([])。  

> **注意**：现代 GUI 应用可能与 Docker 的系统调用限制冲突。若主机内核或 libseccomp 版本较旧，可添加 `--security-opt seccomp=unconfined` 参数启动容器。  


### 安全注意事项  
⚠️ **警告**：本容器具有主机系统的特权访问权限，请勿暴露在公网环境中，除非已做好严格安全防护。  

- **HTTPS 必需**：WebCodecs 等现代浏览器功能仅支持 HTTPS，HTTP 连接会导致音视频功能失效。  
- **认证机制**：默认无认证。可通过 `CUSTOM_USER` 和 `PASSWORD` 环境变量启用基础 HTTP 认证（仅适合可信局域网）。公网暴露时，建议搭配 [SWAG]([]) 等反向代理实现强认证。  
- **终端权限**：Web 界面包含带无密码 sudo 权限的终端，任何访问者可在容器内获取 root 权限，安装软件或探测局域网。  
- **seccomp 配置**：老旧硬件或系统可能需关闭 seccomp 限制（`--security-opt seccomp=unconfined`），但这会降低 Docker 安全性，仅在必要时使用。  


### 环境变量与运行参数  
容器基于 [Docker Baseimage Selkies]([])，支持以下自定义配置：  

#### 可选环境变量  
| 变量名               | 描述                                  |  
| :------------------- | :------------------------------------ |  
| `CUSTOM_PORT`        | 内部 HTTP 端口，默认 `3000`           |  
| `CUSTOM_HTTPS_PORT`  | 内部 HTTPS 端口，默认 `3001`          |  
| `CUSTOM_USER`        | HTTP 认证用户名，默认 `abc`           |  
| `PASSWORD`           | HTTP 认证密码，未设置则关闭认证       |  
| `SUBFOLDER`          | 反向代理子路径（需包含首尾斜杠，如 `/webtop/`） |  
| `TITLE`              | 浏览器标签页标题，默认 "Selkies"      |  
| `LC_ALL`             | 系统 locale（如 `zh_CN.UTF-8` 中文）  |  
| `DRINODE`            | 指定 DRI 设备节点（如 `/dev/dri/renderD128`） |  


#### 可选运行参数  
| 参数                                  | 描述                                  |  
| :------------------------------------ | :------------------------------------ |  
| `--privileged`                        | 启用 Docker-in-Docker 环境            |  
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载主机 Docker 套接字，管理主机容器  |  
| `--device /dev/dri:/dev/dri`          | 挂载 GPU 设备，用于硬件加速           |  


### 多语言支持  
通过 `LC_ALL` 环境变量设置系统语言，例如：  
- 中文：`-e LC_ALL=zh_CN.UTF-8`  
- 日文：`-e LC_ALL=ja_JP.UTF-8`  
- 韩文：`-e LC_ALL=ko_KR.UTF-8`  


### GPU 加速  
#### DRI3（开源驱动）  
支持 Intel、AMD（AMDGPU/Radeon/ATI）及 NVIDIA（nouveau）开源驱动，通过以下命令挂载 GPU：  
`--device /dev/dri:/dev/dri`  

#### NVIDIA 显卡支持  
⚠️ 注意：Alpine 镜像不支持 NVIDIA。  

通过 Zink 实现 OpenGL 支持，并自动用于视频编码以降低 CPU 负载。需添加以下参数：  
- `--gpus all`：传递所有 GPU 到容器  
- `--runtime nvidia`：使用 NVIDIA 运行时  

Docker Compose 配置示例：  
```yaml
services:
  webtop:
    image: lscr.io/linuxserver/webtop:latest
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [compute,video,graphics,utility]
```  


### 应用安装  
#### PRoot Apps（持久化，推荐）  
原生包（如 `apt-get install`）在容器重建后丢失。推荐使用 [proot-apps]([]) 将应用安装到持久化 `$HOME` 目录：  
```bash
proot-apps install filezilla  # 安装 FileZilla，支持列表见链接
```  

#### 原生应用（非持久化）  
通过 [universal-package-install]([]) 模块安装系统原生包（容器重建后需重新安装）：  
```yaml
environment:
  - DOCKER_MODS=linuxserver/mods:universal-package-install
  - INSTALL_PACKAGES=libfuse2|git|gdb  # 需安装的包，用 | 分隔
```  


## 使用方法  

### Docker Compose（推荐）  
创建 `compose.yaml` 文件：  
```yaml
services:
  webtop:
    image: lscr.io/linuxserver/webtop:latest  # 可替换为特定标签，如 ubuntu-xfce
    container_name: webtop
    environment:
      - PUID=1000          # 替换为您的用户 ID（通过 id 命令查看）
      - PGID=1000          # 替换为您的组 ID
      - TZ=Asia/Shanghai   # 时区，如 Asia/Shanghai
      - PASSWORD=yourpass  # 可选，设置访问密码
    volumes:
      - /path/to/data:/config  # 持久化数据目录，替换 /path/to/data 为实际路径
    ports:
      - 3001:3001          # HTTPS 端口映射
    shm_size: "1gb"        # 桌面应用建议设置共享内存大小
    restart: unless-stopped
    # 如需 GPU 加速，添加以下行（开源驱动）：
    # devices:
    #   - /dev/dri:/dev/dri
```  

启动容器：  
```bash
docker-compose up -d
```  


### Docker CLI  
```bash
docker run -d \
  --name=webtop \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e PASSWORD=yourpass \
  -p 3001:3001 \
  -v /path/to/data:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/webtop:latest
```  


## 参数说明  
| 参数                | 作用                                  |  
| :------------------ | :------------------------------------ |  
| `-p 3001:3001`      | 映射 HTTPS 端口到主机                 |  
| `-e PUID/PGID`      | 解决卷权限问题，需与主机用户 ID 一致   |  
| `-e TZ`             | 设置时区（如 `Asia/Shanghai`）        |  
| `-v /config`        | 用户主目录，存储配置和数据            |  
| `--shm-size`        | 共享内存大小，桌面应用建议至少 1GB    |  


## 进阶配置  

### Docker Secrets  
通过 `FILE__` 前缀从文件加载环境变量，例如：  
```bash
-e FILE__PASSWORD=/run/secrets/webtop_pass  # 从文件读取密码
```  


### Umask 设置  
通过 `-e UMASK=022` 调整文件权限掩码（默认 022）。  


### 用户/组 ID  
通过 `id your_user` 命令查看当前用户的 UID/GID，确保卷目录所有者与 `PUID/PGID` 一致，避免权限问题。  


## 容器更新  

### Docker Compose  
```bash
docker-compose pull webtop  # 拉取最新镜像
docker-compose up -d webtop  # 重启容器
docker image prune  # 清理旧镜像
```  


### Docker CLI  
```bash
docker pull lscr.io/linuxserver/webtop:latest
docker stop webtop
docker rm webtop
# 重新运行 docker run 命令（配置会保留在 /config 目录）
```  


## 支持与维护  
- **进入容器终端**：`docker exec -it webtop /bin/bash`  
- **查看日志**：`docker logs -f webtop`  
- **版本信息**：  
  - 容器版本：`docker inspect -f '{{ index .Config.Labels "build_version" }}' webtop`  
  - 镜像版本：`docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/webtop:latest`  


## 版本历史  
- **2024.07.25**：Debian 镜像基于 Trixie 重建  
- **2024.06.17**：基于 Selkies 重构，支持 Alpine 3.22、Fedora 42  
- **2024.03.23**：添加 PRoot Apps 文档  
- **2023.03.23**：基于 KasmVNC 基础镜像重构  
- **2021.04.20**：初始发布  


通过以上步骤，您可以快速部署一个功能完整的 Web 桌面环境，根据需求选择不同的系统基础和桌面环境，并通过浏览器随时随地访问。
