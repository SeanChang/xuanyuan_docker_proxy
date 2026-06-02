---
image: linuxserver/calibre
description: "linuxserver/calibre Docker镜像是一款集电子书库管理、格式转换与阅读于一体的开源工具，提供强大的一站式数字阅读解决方案。通过容器化技术实现跨平台快速部署，无需繁琐配置即可运行。该镜像经LinuxServer优化，内置Web界面与阅读器，支持多设备访问、数据持久化及主流格式转换，轻量高效且安全可靠，适合个人及小型团队构建私有的数字图书资源中心。"
source: https://xuanyuan.cloud/zh/r/linuxserver/calibre
canonical: https://xuanyuan.cloud/zh/r/linuxserver/calibre
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/calibre" title="linuxserver/calibre Docker 镜像中文简介、标签列表与拉取命令">linuxserver/calibre — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/linuxserver/calibre" title="linuxserver/calibre Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/calibre</a>

# LinuxServer.io Calibre Docker 镜像介绍


## LinuxServer.io 简介  
LinuxServer.io 团队致力于提供高质量 Docker 容器，其发布的镜像具有以下特点：  
- 应用更新及时规律  
- 支持简单的用户权限映射（通过 PGID、PUID）  
- 基于自定义基础镜像，集成 s6 叠加层  
- 每周更新基础系统，通过共享层减少存储空间占用、 downtime 和带宽消耗  
- 定期进行安全更新  

如需了解更多，可通过以下渠道联系：  
- [博客]([])：包含容器使用指南、教程及观点文章  
- []()：实时社区支持与团队交流  
- [Discourse]([])：社区论坛  
- [GitHub]([])：所有代码仓库  
- [Open Collective]([])：支持我们的开发与维护  


## linuxserver/calibre 镜像  

### 关于 Calibre  
[Calibre]([]) 是一款功能强大且易用的电子书管理工具，支持电子书格式转换、管理、编辑等多种功能，完全免费开源，适合普通用户和技术爱好者使用。


### 支持的架构  
该镜像通过 Docker 清单实现多平台支持，拉取 `lscr.io/linuxserver/calibre:latest` 即可自动匹配对应架构。也可通过标签指定具体架构：  

| 架构       | 支持情况 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅        | amd64-\<版本标签\>     |  
| arm64      | ✅        | arm64v8-\<版本标签\>   |  


### 版本标签  
镜像提供以下版本标签，选择时需注意稳定性：  

| 标签    | 支持情况 | 说明                     |  
|---------|----------|--------------------------|  
| latest  | ✅        | Calibre 最新稳定版       |  
| v4      | ✅        | Calibre v4 版本（仅 x86-64） |  


## 应用配置  

### 访问地址  
容器启动后，通过以下地址访问 Calibre 界面：  
`[]  


### 基础设置  
- **库路径选择**：首次使用向导中，需将默认库路径设为 `/config/Calibre Library`，其他路径可能导致不支持问题。  
- **内置 Web 服务器启用**：默认未启用，需在 Calibre 偏好设置的「网络共享」中开启，端口保持 `8081` 并勾选「自动启动」。  


### 反向代理与安全注意事项  
- **自签名证书**：镜像默认使用自签名证书，访问协议为 `https`。若反向代理需验证证书，需[关闭容器证书检查]([])。  
- **现代桌面应用兼容性**：部分 GUI 应用可能受 Docker 系统调用限制影响，可添加 `--security-opt seccomp=unconfined` 参数解决（适用于旧内核或 libseccomp 版本）。  

> ⚠️ **安全警告**：  
> 该容器具有主机系统的特权访问权限，请勿直接暴露到公网。HTTPS 是功能完整的必要条件（如 WebCodecs 需 HTTPS 支持）。默认无身份验证，可通过 `CUSTOM_USER` 和 `PASSWORD` 环境变量启用基础 HTTP 认证（仅适用于可信局域网）；公网暴露建议搭配反向代理（如 [SWAG]([])）并使用强认证机制。Web 界面包含带无密码 sudo 权限的终端，任何访问者可获取容器内 root 权限，需谨慎管理访问权限。  


### Selkies 基础镜像功能（可选配置）  
该容器基于 Selkies 桌面基础镜像，支持以下自定义项：  

#### 环境变量  
| 变量名              | 说明                                                                 |  
|---------------------|----------------------------------------------------------------------|  
| `CUSTOM_PORT`       | 内部 HTTP 端口，默认 `8080`                                          |  
| `CUSTOM_HTTPS_PORT` | 内部 HTTPS 端口，默认 `8181`                                         |  
| `CUSTOM_USER`       | HTTP 基础认证用户名，默认 `abc`                                       |  
| `PASSWORD`          | HTTP 基础认证密码，未设置则禁用认证                                   |  
| `SUBFOLDER`         | 反向代理子路径（需包含前后斜杠，如 `/calibre/`）                      |  
| `LC_ALL`            | 容器 locale（如 `zh_CN.UTF-8` 对应中文）                              |  


#### 运行参数  
| 参数                          | 说明                                                                 |  
|-------------------------------|----------------------------------------------------------------------|  
| `--privileged`                | 启用 Docker-in-Docker 环境，建议挂载主机 Docker 数据目录（如 `-v /path/docker-data:/var/lib/docker`） |  
| `--device /dev/dri:/dev/dri`  | 挂载 GPU 设备以支持硬件加速（仅支持开源驱动，如 Intel、AMDGPU）         |  


### 多语言支持  
通过 `LC_ALL` 环境变量设置界面语言，例如：  
- 中文：`-e LC_ALL=zh_CN.UTF-8`  
- 日文：`-e LC_ALL=ja_JP.UTF-8`  
- 韩文：`-e LC_ALL=ko_KR.UTF-8`  


### GPU 硬件加速（DRI3）  
如需图形加速，可挂载 GPU 设备：  
`--device /dev/dri:/dev/dri`  
支持的开源驱动：Intel (i965/i915)、AMD (AMDGPU/Radeon)、NVIDIA (nouveau)。可通过 `DRINODE` 变量指定具体 GPU 节点。  


### 应用安装  
容器内安装应用有两种方式：  

#### PRoot Apps（推荐，持久化）  
通过 `proot-apps` 命令安装到用户目录（容器重建后保留）：  
```bash  
proot-apps install filezilla  # 示例：安装 FileZilla  
```  
[支持的应用列表]([])  


#### 原生应用（非持久化）  
通过 `universal-package-install` mod 安装系统包（容器重建后丢失），需在 `compose.yaml` 中添加：  
```yaml  
environment:  
  - DOCKER_MODS=linuxserver/mods:universal-package-install  
  - INSTALL_PACKAGES=libfuse2|git|gdb  # 需安装的包，用 | 分隔  
```  


## 使用方法  

### Docker Compose（推荐）  
创建 `docker-compose.yaml` 文件，填入以下内容（替换路径和参数）：  

```yaml  
---  
services:  
  calibre:  
    image: lscr.io/linuxserver/calibre:latest  
    container_name: calibre  
    security_opt:  
      - seccomp:unconfined  # 可选，解决部分 GUI 兼容性问题  
    environment:  
      - PUID=1000           # 用户 ID，通过 `id 用户名` 获取  
      - PGID=1000           # 组 ID，同上  
      - TZ=Etc/UTC          # 时区，如 Asia/Shanghai  
      - PASSWORD=yourpass   # 可选，Web 界面密码  
      - CLI_ARGS=           # 可选，Calibre 启动参数  
    volumes:  
      - /path/to/calibre/config:/config  # 主机配置目录，需替换  
    ports:  
      - 8080:8080           # HTTP 端口（反向代理用）  
      - 8181:8181           # HTTPS 端口（直接访问用）  
      - 8081:8081           # Calibre 内置 Web 服务器端口  
    restart: unless-stopped  
```  

启动容器：  
```bash  
docker-compose up -d  
```  


### Docker CLI  
直接运行命令（替换路径和参数）：  

```bash  
docker run -d \  
  --name=calibre \  
  --security-opt seccomp=unconfined `# 可选` \  
  -e PUID=1000 \  
  -e PGID=1000 \  
  -e TZ=Asia/Shanghai \  
  -e PASSWORD=yourpass `# 可选` \  
  -p 8080:8080 \  
  -p 8181:8181 \  
  -p 8081:8081 \  
  -v /path/to/calibre/config:/config \  
  --restart unless-stopped \  
  lscr.io/linuxserver/calibre:latest  
```  


## 参数说明  

| 参数形式                | 作用说明                                                                 |  
|-------------------------|--------------------------------------------------------------------------|  
| `-p 8080:8080`          | HTTP 端口，用于反向代理访问 GUI                                          |  
| `-p 8181:8181`          | HTTPS 端口，用于直接访问 GUI                                            |  
| `-p 8081:8081`          | Calibre 内置 Web 服务器端口（需在应用内启用）                             |  
| `-e PUID=1000`          | 用户 ID，确保容器内权限与主机一致                                        |  
| `-e PGID=1000`          | 组 ID，同上                                                              |  
| `-e TZ=Asia/Shanghai`   | 时区设置                                                                 |  
| `-e PASSWORD=xxx`       | Web 界面密码（可选）                                                     |  
| `-e CLI_ARGS=xxx`       | Calibre 启动参数（可选，如 `--disable-auto-update`）                     |  
| `-v /config`            | 容器配置目录，存放 Calibre 库和设置                                      |  


## 高级配置  

### 环境变量文件（Docker Secrets）  
通过文件传递敏感环境变量，格式为 `FILE__变量名=文件路径`，例如：  
```bash  
-e FILE__PASSWORD=/run/secrets/calibre_pass  
```  
容器会从 `/run/secrets/calibre_pass` 文件中读取密码。  


### Umask 设置  
通过 `-e UMASK=022` 调整容器内文件权限掩码（默认值通常无需修改）。  


### 用户/组 ID  
挂载主机目录时，需确保目录所有者的 UID/GID 与容器内 `PUID/PGID` 一致，避免权限问题。通过 `id 用户名` 命令查看主机用户的 UID/GID。  


## Docker Mods  
通过 Docker Mods 扩展容器功能，支持的 Mods 可通过以下链接查看：  
- [Calibre 专用 Mods]([])  
- [通用 Mods]([])  


## 支持与维护  

### 容器管理命令  
- **进入容器终端**：  
  ```bash  
  docker exec -it calibre /bin/bash  
  ```  
- **查看实时日志**：  
  ```bash  
  docker logs -f calibre  
  ```  
- **查看容器版本**：  
  ```bash  
  docker inspect -f '{{ index .Config.Labels "build_version" }}' calibre  
  ```  


### 更新容器  
#### 通过 Docker Compose  
```bash  
# 拉取最新镜像  
docker-compose pull calibre  
# 重启容器  
docker-compose up -d calibre  
# 清理旧镜像  
docker image prune  
```  

#### 通过 Docker Run  
```bash  
# 拉取最新镜像  
docker pull lscr.io/linuxserver/calibre:latest  
# 停止并删除旧容器  
docker stop calibre && docker rm calibre  
# 用原参数重建容器（配置会保留）  
docker run [原参数] lscr.io/linuxserver/calibre:latest  
```  


### 本地构建镜像  
如需自定义镜像，可克隆仓库并构建：  
```bash  
git clone []  
cd docker-calibre  
docker build --no-cache --pull -t lscr.io/linuxserver/calibre:latest .  
```  


## 版本历史  
- **2025.07.26**：基于 Selkies 重构，强制使用 HTTPS（需通过 8181 端口访问）。  
- **2024.08.19**：基础系统更新为 Ubuntu Noble。  
- **2023.11.17**：安装 libxcb-cursor0 以支持 Calibre v7。  
- **2023.03.18**：基于 KasmVNC 基础镜像重构。  
- **2022.09.16**：基础系统更新为 Ubuntu Jammy。  
- **2021.04.15**：基于 rdesktop-web 基础镜像重构，简化认证配置。  
- **2020.09.25**：切换至 Python3，支持 Calibre 5.0。  
- **2019.04.29**：首次发布。
