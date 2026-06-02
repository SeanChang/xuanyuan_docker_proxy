---
image: linuxserver/rustdesk
description: "linuxserver/rustdesk是一款基于Rust语言开发的开源远程桌面工具Docker镜像，提供便捷的远程控制、文件传输和屏幕共享功能。得益于Docker容器化部署，具有安装简单、配置灵活的特点，同时支持自建服务器，确保数据传输安全与隐私保护。该镜像继承了RustDesk原生的高性能与低延迟特性，兼容Windows、macOS、Linux等多平台系统，适用于个人远程办公、家庭设备管理及企业IT运维等场景，是一款轻量高效且安全可靠的远程桌面解决方案。"
source: https://xuanyuan.cloud/zh/r/linuxserver/rustdesk
canonical: https://xuanyuan.cloud/zh/r/linuxserver/rustdesk
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/rustdesk" title="linuxserver/rustdesk Docker 镜像中文简介、标签列表与拉取命令">linuxserver/rustdesk — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/linuxserver/rustdesk" title="linuxserver/rustdesk Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/rustdesk</a>

# LinuxServer.io rustdesk 容器介绍


## LinuxServer.io 团队简介  
LinuxServer.io 团队专注于提供高质量容器解决方案，其容器产品具有以下核心优势：  
- **定期及时的应用更新**，确保功能与安全同步；  
- **便捷的用户权限映射**（通过 PGID、PUID 配置）；  
- **基于 s6 overlay 的自定义基础镜像**，优化运行稳定性；  
- **每周系统层更新**，通过统一基础层减少存储空间占用、 downtime 及带宽消耗；  
- **常态化安全更新**，降低潜在风险。  


## rustdesk 容器概述  
[rustdesk]([]) 是一款全功能开源远程控制工具，支持自托管部署，安全性高且配置简单，可作为商业远程控制软件的替代方案。  


## 支持架构  
容器通过 Docker manifest 实现多架构适配，拉取 `lscr.io/linuxserver/rustdesk:latest` 即可自动匹配当前架构。也可通过标签指定架构：  

| 架构       | 支持状态 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅        | amd64-\<version tag\>   |  
| arm64      | ✅        | arm64v8-\<version tag\> |  


## 应用配置  

### 访问方式  
部署后可通过以下地址访问应用：  
`[]  


### 反向代理注意事项  
容器默认使用自签名证书，通信协议为 `https`。若使用验证证书的反向代理，需[禁用对容器的证书校验]([])。  

> **注意**：部分现代 GUI 桌面应用可能与 Docker 最新的系统调用限制存在兼容性问题。若主机内核或 libseccomp 版本较旧，可添加 `--security-opt seccomp=unconfined` 参数允许相关系统调用。  


### 安全提示  
> [!WARNING]  
> 此容器提供对主机系统的特权访问。除非已正确配置安全措施，否则不要将其暴露到互联网。  

- **HTTPS 必需**：WebCodecs 等现代浏览器功能依赖 HTTPS，HTTP 连接会导致音视频功能失效。  
- **默认无认证**：可通过 `CUSTOM_USER` 和 `PASSWORD` 环境变量启用基础 HTTP 认证（仅建议在可信局域网使用）。若需暴露到公网，**强烈推荐搭配反向代理**（如 [SWAG]([])）并配置强认证机制。  
- **权限风险**：Web 界面包含带无密码 `sudo` 权限的终端，任何访问者可在容器内获取 root 权限、安装软件或探测局域网。  


### 环境变量配置  
容器基于 [Docker Baseimage Selkies]([]) 构建，支持以下可选环境变量：  

| 变量名               | 说明                                                                 |  
|----------------------|----------------------------------------------------------------------|  
| `CUSTOM_PORT`        | 内部 HTTP 端口，默认 `3000`                                          |  
| `CUSTOM_HTTPS_PORT`  | 内部 HTTPS 端口，默认 `3001`                                         |  
| `CUSTOM_WS_PORT`     | WebSocket 内部端口，默认 `8082`                                      |  
| `CUSTOM_USER`        | HTTP 基础认证用户名，默认 `abc`                                      |  
| `PASSWORD`           | HTTP 基础认证密码，未设置则禁用认证                                  |  
| `SUBFOLDER`          | 反向代理子路径（需包含首尾斜杠，如 `/subfolder/`）                   |  
| `TITLE`              | 网页标题，默认 "Selkies"                                             |  
| `START_DOCKER`       | 设为 `false` 可禁用 Docker-in-Docker 自动启动                         |  
| `DISABLE_IPV6`       | 设为 `true` 禁用 IPv6                                                |  
| `LC_ALL`             | 系统 locale（如 `zh_CN.UTF-8` 对应中文）                              |  
| `DRINODE`            | 指定 DRI 设备节点（如 `/dev/dri/renderD128`）                        |  
| `NO_DECOR`           | 设为 true 禁用窗口边框（适合 PWA 使用）                               |  
| `NO_FULL`            | 设为 true 禁用自动全屏                                                |  
| `DISABLE_ZINK`       | 设为 true 禁用 Zink 环境变量配置                                      |  
| `WATERMARK_PNG`      | 水印图片路径（如 `/usr/share/selkies/www/icon.png`）                  |  
| `WATERMARK_LOCATION` | 水印位置（1-左上，2-右上，3-左下，4-右下，5-居中，6-动画）           |  


### 运行参数配置  
| 参数                          | 说明                                                                 |  
|-------------------------------|----------------------------------------------------------------------|  
| `--privileged`                | 启动 Docker-in-Docker 环境，建议挂载主机 Docker 数据目录（如 `-v /path/to/docker-data:/var/lib/docker`）提升性能 |  
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载主机 Docker 套接字，允许容器管理主机容器                         |  
| `--device /dev/dri:/dev/dri`  | 挂载 GPU 设备，配合 `DRINODE` 可实现 DRI3 加速                        |  


### 语言支持  
通过 `LC_ALL` 环境变量设置界面语言，例如：  
- 中文：`-e LC_ALL=zh_CN.UTF-8`  
- 日文：`-e LC_ALL=ja_JP.UTF-8`  
- 韩文：`-e LC_ALL=ko_KR.UTF-8`  
- 其他语言：`ar_AE.UTF-8`（阿拉伯语）、`ru_RU.UTF-8`（俄语）等。  


### GPU 加速配置  
#### DRI3 加速（开源驱动）  
挂载 GPU 设备可提升应用/游戏性能：  
```bash  
--device /dev/dri:/dev/dri  
```  
支持的开源驱动：  
- **Intel**：i965/i915（集成显卡）  
- **AMD**：AMDGPU/Radeon/ATI（独立显卡或 APU）  
- **NVIDIA**：仅 nouveau2 驱动（闭源驱动不支持 DRI3）  

#### NVIDIA 加速（Zink 方案）  
> **注意**：Alpine 基础镜像不支持 NVIDIA 加速。  

通过 Zink 实现 OpenGL 加速，支持硬件编码（x264enc 全帧模式）以降低 CPU 负载。需添加以下运行参数：  
- `--gpus all`：传递所有主机 GPU（可指定具体 GPU）  
- `--runtime nvidia`：使用 NVIDIA 运行时  

Docker Compose 配置示例（需先将 NVIDIA 运行时设为默认）：  
```yaml  
services:  
  rustdesk:  
    image: lscr.io/linuxserver/rustdesk:latest  
    deploy:  
      resources:  
        reservations:  
          devices:  
            - driver: nvidia  
              count: 1  
              capabilities: [compute,video,graphics,utility]  
```  


### 应用安装方法  
#### PRoot Apps（推荐，持久化）  
通过 `proot-apps` 安装的应用会保存在用户 `$HOME` 目录，容器重建后仍可保留：  
```bash  
# 示例：安装 filezilla  
proot-apps install filezilla  
```  
[支持的应用列表]([])  

#### 原生应用（非持久化）  
通过 `universal-package-install` mod 安装系统原生包（容器重建后需重新安装）：  
```yaml  
environment:  
  - DOCKER_MODS=linuxserver/mods:universal-package-install  
  - INSTALL_PACKAGES=libfuse2|git|gdb  # 需安装的包，用 | 分隔  
```  


## 使用方法  

### Docker Compose（推荐）  
```yaml  
---  
services:  
  rustdesk:  
    image: lscr.io/linuxserver/rustdesk:latest  
    container_name: rustdesk  
    environment:  
      - PUID=1000        # 用户ID（通过 `id your_user` 获取）  
      - PGID=1000        # 组ID（同上）  
      - TZ=Etc/UTC       # 时区（如 Asia/Shanghai）  
    volumes:  
      - /path/to/config:/config  # 配置文件存储路径（需替换为实际路径）  
    ports:  
      - 3000:3000        # HTTP端口（建议反向代理时使用）  
      - 3001:3001        # HTTPS端口（直接访问用）  
    shm_size: "1gb"      # 桌面应用推荐配置  
    restart: unless-stopped  
```  


### Docker CLI  
```bash  
docker run -d \  
  --name=rustdesk \  
  -e PUID=1000 \  
  -e PGID=1000 \  
  -e TZ=Etc/UTC \  
  -p 3000:3000 \  
  -p 3001:3001 \  
  -v /path/to/config:/config \  
  --shm-size="1gb" \  
  --restart unless-stopped \  
  lscr.io/linuxserver/rustdesk:latest  
```  


## 参数说明  

| 参数                | 作用                                                                 |  
|---------------------|----------------------------------------------------------------------|  
| `-p 3000:3000`      | HTTP 桌面界面端口（需反向代理）                                      |  
| `-p 3001:3001`      | HTTPS 桌面界面端口（直接访问）                                      |  
| `-e PUID=1000`      | 用户ID，避免权限问题（通过 `id your_user` 获取）                     |  
| `-e PGID=1000`      | 组ID，同上                                                           |  
| `-e TZ=Etc/UTC`     | 时区设置，如 `Asia/Shanghai`                                         |  
| `-v /config`        | 容器内用户主目录，存储配置和本地文件                                 |  
| `--shm-size=`       | 共享内存大小，桌面应用建议设为 `1gb`                                 |  


## 用户/组 ID 配置  
卷挂载时需确保主机目录所有者与容器内用户 ID 一致，避免权限问题。通过以下命令获取当前用户的 UID/GID：  
```bash  
id your_user  
```  
输出示例：  
```text  
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)  
```  


## Docker Mods  
可通过 Mods 扩展功能：  
- [rustdesk 专用 Mods]([])  
- [通用 Mods]([])  


## 支持与更新  

### 常用操作  
- 进入容器终端：  
  ```bash  
  docker exec -it rustdesk /bin/bash  
  ```  
- 实时查看日志：  
  ```bash  
  docker logs -f rustdesk  
  ```  
- 查看容器版本：  
  ```bash  
  docker inspect -f '{{ index .Config.Labels "build_version" }}' rustdesk  
  ```  


### 更新方法  
#### Docker Compose  
```bash  
# 更新镜像  
docker-compose pull rustdesk  
# 重启容器  
docker-compose up -d rustdesk  
# 清理旧镜像  
docker image prune  
```  

#### Docker CLI  
```bash  
# 拉取新镜像  
docker pull lscr.io/linuxserver/rustdesk:latest  
# 停止并删除旧容器  
docker stop rustdesk && docker rm rustdesk  
# 用原参数启动新容器（/config 目录会保留配置）  
docker run [原参数] lscr.io/linuxserver/rustdesk:latest  
```  


### 版本历史  
- **22.09.25**：基于 Debian Trixie 重构。  
- **12.07.25**：迁移至 Selkies 基础镜像，**HTTPS 成为必需**。  
- **25.07.24**：初始发布。
