---
image: linuxserver/msedge
description: "Docker镜像linuxserver/msedge是基于Linux环境的Microsoft Edge无头浏览器容器，专为服务器端网页自动化场景设计。支持无界面运行，适用于自动化测试、网页渲染、Selenium集成及CI/CD流程，可高效处理网页截图、JS执行等任务。集成LinuxServer优化配置，轻量易部署，提供稳定的浏览器运行环境，满足开发者在服务器端进行网页自动化操作的需求，无需图形界面即可高效完成浏览器相关工作。"
source: https://xuanyuan.cloud/zh/r/linuxserver/msedge
canonical: https://xuanyuan.cloud/zh/r/linuxserver/msedge
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/msedge" title="linuxserver/msedge Docker 镜像中文简介、标签列表与拉取命令">linuxserver/msedge 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LinuxServer.io 容器：msedge

LinuxServer.io 团队推出的 [msedge]([]) 容器，基于 Chromium 内核的 Microsoft Edge 浏览器，提供跨平台网页浏览能力。以下是该容器的详细介绍与使用指南。


## 容器核心特性

LinuxServer.io 容器一贯具备以下优势：  
- **应用更新及时**：定期同步官方应用版本，确保功能最新。  
- **用户权限映射简单**：通过 PUID/PGID 轻松配置容器内用户与宿主机权限对应。  
- **定制基础镜像**：集成 s6 覆盖层，优化容器进程管理。  
- **系统层高效维护**：每周统一更新基础操作系统层，减少存储空间占用、 downtime 及带宽消耗。  
- **安全更新常态化**：定期修复安全漏洞，保障运行环境可靠。  


## 支持的架构

容器通过 Docker 清单实现多平台适配，拉取 `lscr.io/linuxserver/msedge:latest` 即可自动匹配宿主机架构。也可通过标签指定具体架构：  

| 架构       | 支持状态 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅ 支持  | amd64-\<版本标签\>     |  
| arm64      | ❌ 不支持| -                      |  


## 应用部署与配置

### 访问地址  
容器启动后，可通过以下地址访问 Edge 浏览器界面：  
- HTTP: `[]  
- HTTPS: `[]  


### 关键配置说明  

#### 反向代理注意事项  
容器默认使用自签名证书，通信协议为 HTTPS。若反向代理启用证书验证，需[关闭对该容器的验证检查]([])。  

#### 系统兼容性  
部分现代 GUI 桌面应用可能受 Docker 系统调用限制影响。若宿主机内核或 libseccomp 版本较旧，可添加 `--security-opt seccomp=unconfined` 参数运行容器，以允许必要的系统调用（注：此参数会降低安全性，仅在必要时使用）。  


### 安全警告  

> [!WARNING]  
> 该容器拥有宿主机系统的特权访问权限。除非已做好严格安全配置，否则切勿暴露在公网环境中。  

- **HTTPS 强制要求**：WebCodecs 等现代浏览器功能（用于音视频处理）仅支持 HTTPS 连接，HTTP 环境下无法正常工作。  
- **默认无认证**：容器默认不启用身份验证。可通过 `CUSTOM_USER` 和 `PASSWORD` 环境变量开启基础 HTTP 认证，但仅建议在可信局域网内使用。若需公网访问，强烈建议搭配反向代理（如 [SWAG]([])）并启用强认证机制。  
- **终端权限风险**：Web 界面包含带无密码 sudo 权限的终端，任何能访问 GUI 的用户均可在容器内获取 root 权限，安装软件或探测局域网。  


### 自定义配置项  

该容器基于 [Docker Baseimage Selkies]([]) 构建，支持通过环境变量和运行参数自定义功能。  

#### 可选环境变量  

| 变量名              | 说明                                                                 |  
|---------------------|----------------------------------------------------------------------|  
| `CUSTOM_PORT`       | 内部 HTTP 端口，默认 `3000`                                          |  
| `CUSTOM_HTTPS_PORT` | 内部 HTTPS 端口，默认 `3001`                                         |  
| `CUSTOM_USER`       | HTTP 基础认证用户名，默认 `abc`                                      |  
| `PASSWORD`          | HTTP 基础认证密码，未设置则禁用认证                                  |  
| `SUBFOLDER`         | 反向代理子路径（需包含首尾斜杠，如 `/subfolder/`）                   |  
| `TITLE`             | 浏览器标签页标题，默认 "Selkies"                                     |  
| `LC_ALL`            | 容器 locale 设置（如 `zh_CN.UTF-8` 对应中文）                        |  
| `DRINODE`           | 指定 DRI3 渲染设备节点（如 `/dev/dri/renderD128`）                   |  
| `NO_DECOR`          | 设置后应用窗口无边框（适合 PWA 使用）                                 |  


#### 可选运行参数  

| 参数                          | 说明                                                                 |  
|-------------------------------|----------------------------------------------------------------------|  
| `--privileged`                | 启用 Docker-in-Docker 环境，建议挂载宿主机 Docker 数据目录（如 `-v /path/to/docker-data:/var/lib/docker`）提升性能。 |  
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载宿主机 Docker 套接字，允许容器管理宿主机容器。               |  
| `--device /dev/dri:/dev/dri`  | 挂载 GPU 设备，配合 `DRINODE` 可实现 DRI3 硬件加速（仅支持开源驱动）。 |  


### 高级配置  

#### 多语言支持  
通过 `LC_ALL` 环境变量设置界面语言，例如：  
- `zh_CN.UTF-8`（中文）、`ja_JP.UTF-8`（日语）、`fr_FR.UTF-8`（法语）等。  

#### GPU 加速  

##### DRI3 开源驱动支持  
适用于 Intel (i965/i915)、AMD (AMDGPU/Radeon/ATI) 或 NVIDIA (nouveau2) 开源驱动。挂载 GPU 设备后，容器内应用可调用硬件加速：  
```bash  
docker run ... --device /dev/dri:/dev/dri -e DRINODE=/dev/dri/renderD128 ...  
```  

##### NVIDIA 闭源驱动支持  
需通过 Zink 实现 OpenGL 支持，且仅支持非 Alpine 基础镜像。启用方式：  
- 运行时添加 `--gpus all --runtime nvidia`（Docker）；  
- Docker Compose 需配置 NVIDIA 运行时为默认，并在 `compose.yaml` 中声明 GPU 资源：  
  ```yaml  
  services:  
    msedge:  
      deploy:  
        resources:  
          reservations:  
            devices:  
              - driver: nvidia  
                count: 1  
                capabilities: [compute,video,graphics,utility]  
  ```  


#### 应用安装与管理  

- **PRoot Apps（推荐，持久化）**：通过 `proot-apps install <应用名>` 安装到用户目录（如 `proot-apps install filezilla`），支持跨容器保留。[支持列表]([])。  
- **原生应用（非持久化）**：通过 `universal-package-install` 模块安装系统包，需在环境变量中指定：  
  ```yaml  
  environment:  
    - DOCKER_MODS=linuxserver/mods:universal-package-install  
    - INSTALL_PACKAGES=libfuse2|git|gdb  
  ```  


## 容器使用方法  

### Docker Compose（推荐）  
创建 `compose.yaml` 文件：  
```yaml  
services:  
  msedge:  
    image: lscr.io/linuxserver/msedge:latest  
    container_name: msedge  
    environment:  
      - PUID=1000          # 宿主机用户 ID（通过 `id 用户名` 查看）  
      - PGID=1000          # 宿主机用户组 ID  
      - TZ=Asia/Shanghai   # 时区（如 Asia/Shanghai）  
      - EDGE_CLI=[]  # 可选，Chromium CLI 参数  
    volumes:  
      - /path/to/config:/config  # 配置文件持久化目录  
    ports:  
      - 3000:3000          # HTTP 端口映射  
      - 3001:3001          # HTTPS 端口映射  
    shm_size: "1gb"        # 必须配置，Edge 运行所需  
    restart: unless-stopped  
```  
启动容器：`docker-compose up -d`  


### Docker 命令行  
```bash  
docker run -d \  
  --name=msedge \  
  -e PUID=1000 \  
  -e PGID=1000 \  
  -e TZ=Asia/Shanghai \  
  -e EDGE_CLI=[] `# 可选` \  
  -p 3000:3000 \  
  -p 3001:3001 \  
  -v /path/to/config:/config \  
  --shm-size="1gb" \  
  --restart unless-stopped \  
  lscr.io/linuxserver/msedge:latest  
```  


## 参数说明  

| 参数                | 作用                                                                 |  
|---------------------|----------------------------------------------------------------------|  
| `-p 3000:3000`      | HTTP 访问端口映射（宿主机:容器）                                     |  
| `-p 3001:3001`      | HTTPS 访问端口映射（宿主机:容器）                                    |  
| `-e PUID=1000`      | 容器内用户 ID，需与宿主机目录权限匹配（通过 `id 用户名` 获取）       |  
| `-e PGID=1000`      | 容器内用户组 ID，同上                                                |  
| `-e TZ=时区`        | 指定时区（如 `Asia/Shanghai`）                                       |  
| `-e EDGE_CLI=参数`  | 传递 Chromium CLI 标志（如启动时打开指定网址）                       |  
| `-v /config`        | 配置文件目录，存储浏览器数据和设置                                   |  
| `--shm-size=1gb`    | 共享内存大小，Edge 运行必需                                          |  


## 维护与更新  

### 容器日志与管理  
- 进入容器终端：`docker exec -it msedge /bin/bash`  
- 实时查看日志：`docker logs -f msedge`  
- 查看容器版本：`docker inspect -f '{{ index .Config.Labels "build_version" }}' msedge`  


### 更新容器  

#### 通过 Docker Compose  
```bash  
# 拉取最新镜像  
docker-compose pull msedge  
# 重启容器（保留配置）  
docker-compose up -d msedge  
# 清理旧镜像  
docker image prune  
```  

#### 通过 Docker 命令行  
```bash  
# 拉取最新镜像  
docker pull lscr.io/linuxserver/msedge:latest  
# 停止并删除旧容器  
docker stop msedge && docker rm msedge  
# 用原参数启动新容器（配置通过 /config 目录持久化）  
docker run -d ... lscr.io/linuxserver/msedge:latest  
```  


## 版本历史  
- **2025年9月22日**：基于 Debian Trixie 重构基础镜像。  
- **2025年7月12日**：迁移至 Selkies 基础镜像，强制启用 HTTPS。  
- **2025年2月4日**：优化容器关闭时的进程清理逻辑。  
- **2024年4月25日**：首次发布。  


## 支持与社区  

获取帮助或参与讨论：  
- [博客]([])：容器使用教程与技巧。  
- []()：实时社区支持。  
- [论坛]([])：问题反馈与经验分享。  
- [GitHub]([])：源码与贡献指南。
