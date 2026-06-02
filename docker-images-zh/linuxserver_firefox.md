<!-- xuanyuan-docker-images-zh
image: linuxserver/firefox
source: https://xuanyuan.cloud/zh/r/linuxserver/firefox
canonical: https://xuanyuan.cloud/zh/r/linuxserver/firefox
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/firefox" title="linuxserver/firefox Docker 镜像中文简介、标签列表与拉取命令">linuxserver/firefox — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/linuxserver/firefox" title="linuxserver/firefox Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/firefox</a></p>

# LinuxServer.io Firefox 容器介绍


## LinuxServer.io 容器特点  
LinuxServer.io 团队提供的容器具有以下特性：  
- 定期及时的应用更新  
- 简单的用户权限映射（通过 PGID、PUID 配置）  
- 基于 s6 叠加层的自定义基础镜像  
- 每周基础系统更新，通过统一层设计减少存储空间占用、 downtime 和带宽消耗  
- 定期安全更新  


## 社区与支持渠道  
- [博客]([])：容器使用指南、教程及技术观点  
- []()：实时社区支持与团队交流  
- [论坛]([])：社区讨论与问题反馈  
- [GitHub]([])：源码仓库  
- [Open Collective]([])：支持我们的开发与维护  


# linuxserver/firefox 容器  

[Firefox]([]) 是由 Mozilla 基金会开发的免费开源网页浏览器，使用 Gecko 渲染引擎，支持当前及未来的网页标准。LinuxServer.io 提供的该容器将 Firefox 封装为可快速部署的 Docker 镜像。  


## 支持的架构  
通过 Docker 清单实现多平台支持，拉取 `lscr.io/linuxserver/firefox:latest` 即可自动匹配对应架构，也可通过标签指定：  

| 架构       | 支持状态 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅ 支持   | amd64-\<version tag\>   |  
| arm64      | ✅ 支持   | arm64v8-\<version tag\> |  


## 版本标签  
| 标签    | 支持状态 | 说明                     |  
|---------|----------|--------------------------|  
| latest  | ✅ 支持   | 基于 Selkies 基础镜像的最新版本 |  
| kasm    | ✅ 支持   | 基于 KasmVNC 基础镜像的最新版本 |  


## 应用部署与配置  


### 访问地址  
部署后可通过以下地址访问 Firefox：  
`[]  


### 反向代理注意事项  
容器默认使用自签名证书，通信协议为 HTTPS。若使用严格验证证书的反向代理，需[关闭对容器的证书校验]([])。  

> **注意**：部分现代 GUI 应用可能与 Docker 系统调用限制冲突，可通过 `--security-opt seccomp=unconfined` 参数允许相关调用（仅建议旧内核或 libseccomp 版本环境使用）。  


### 安全提示  
> [!WARNING]  
> 该容器具有主机系统的特权访问权限，**切勿直接暴露到公网**，需确保已做好安全防护。  

- **HTTPS 必需**：WebCodecs 等现代浏览器功能依赖 HTTPS，HTTP 连接下无法正常使用。  
- **默认无认证**：可通过 `CUSTOM_USER` 和 `PASSWORD` 环境变量启用基础 HTTP 认证（仅适用于可信局域网）；公网暴露需搭配反向代理（如 [SWAG]([])）实现强认证。  
- **容器内权限**：Web 界面包含带无密码 sudo 的终端，任何访问者可获取容器内 root 权限，需严格控制访问范围。  


### Selkies 基础镜像配置项  
容器基于 [Docker Baseimage Selkies]([]) 构建，支持以下自定义配置：  


#### 可选环境变量  

| 变量名              | 说明                                                                 |  
|---------------------|----------------------------------------------------------------------|  
| `CUSTOM_PORT`       | 内部 HTTP 端口，默认 `3000`                                          |  
| `CUSTOM_HTTPS_PORT` | 内部 HTTPS 端口，默认 `3001`                                         |  
| `CUSTOM_WS_PORT`    | WebSocket 监听端口，默认 `8082`                                      |  
| `CUSTOM_USER`       | HTTP 基础认证用户名，默认 `abc`                                       |  
| `PASSWORD`          | HTTP 基础认证密码，未设置则禁用认证                                   |  
| `SUBFOLDER`         | 反向代理子路径（需包含首尾斜杠，如 `/firefox/`）                     |  
| `TITLE`             | 网页标题，默认 "Selkies"                                             |  
| `LC_ALL`            | 容器 locale（如 `zh_CN.UTF-8` 对应中文）                              |  
| `DRINODE`           | 指定 DRI 设备节点（如 `/dev/dri/renderD128`，用于 GPU 加速）         |  


#### 可选运行参数  

| 参数                          | 说明                                                                 |  
|-------------------------------|----------------------------------------------------------------------|  
| `--privileged`                | 启用 Docker-in-Docker 环境（建议挂载主机 `/var/lib/docker` 目录提升性能） |  
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载主机 Docker 套接字，实现容器内管理主机容器                         |  
| `--device /dev/dri:/dev/dri`  | 挂载主机 GPU 设备（支持 Intel/AMD 开源驱动，用于硬件加速）            |  


### 多语言支持  
通过 `LC_ALL` 环境变量设置界面语言，例如：  
- 中文：`-e LC_ALL=zh_CN.UTF-8`  
- 日文：`-e LC_ALL=ja_JP.UTF-8`  
- 韩文：`-e LC_ALL=ko_KR.UTF-8`  


### GPU 加速配置  


#### DRI3 加速（开源驱动）  
适用于 Intel（i965/i915）、AMD（AMDGPU/Radeon/ATI）或 NVIDIA（nouveau）开源驱动，需挂载 GPU 设备：  
```bash  
--device /dev/dri:/dev/dri  
```  
可配合 `DRINODE` 变量指定具体 GPU 节点（如 `/dev/dri/renderD128`）。  


#### NVIDIA 加速（闭源驱动）  
需使用 Zink 实现 OpenGL 支持，并通过以下参数传递 GPU：  
```bash  
--gpus all --runtime nvidia  
```  
Docker Compose 配置示例：  
```yaml  
services:  
  firefox:  
    image: lscr.io/linuxserver/firefox:latest  
    deploy:  
      resources:  
        reservations:  
          devices:  
            - driver: nvidia  
              count: 1  
              capabilities: [compute,video,graphics,utility]  
```  


### 应用安装方法  


#### PRoot Apps（持久化，推荐）  
通过 `proot-apps` 安装的应用保存在用户 `$HOME` 目录，容器重建后仍可保留：  
```bash  
# 示例：安装 FileZilla  
proot-apps install filezilla  
```  
[支持的应用列表]([])  


#### 原生应用（非持久化）  
通过 `universal-package-install` 模块安装系统原生包（容器重建后需重新安装）：  
```yaml  
environment:  
  - DOCKER_MODS=linuxserver/mods:universal-package-install  
  - INSTALL_PACKAGES=libfuse2|git|gdb  # 需安装的包，用 | 分隔  
```  


## 部署步骤  


### Docker Compose（推荐）  
创建 `compose.yaml` 文件：  
```yaml  
services:  
  firefox:  
    image: lscr.io/linuxserver/firefox:latest  
    container_name: firefox  
    environment:  
      - PUID=1000           # 用户 ID（通过 `id 用户名` 查看）  
      - PGID=1000           # 组 ID  
      - TZ=Asia/Shanghai    # 时区（如 Asia/Shanghai）  
      - FIREFOX_CLI=[]  # Firefox 启动参数（可选）  
    volumes:  
      - /path/to/本地配置目录:/config  # 映射配置目录（需替换为实际路径）  
    ports:  
      - 3000:3000           # HTTP 端口（建议仅用于反向代理）  
      - 3001:3001           # HTTPS 端口（直接访问用）  
    shm_size: "1gb"         # 共享内存大小（现代网页必需）  
    restart: unless-stopped  
```  
启动容器：  
```bash  
docker-compose up -d  
```  


### Docker Run 命令  
```bash  
docker run -d \  
  --name=firefox \  
  -e PUID=1000 \  
  -e PGID=1000 \  
  -e TZ=Asia/Shanghai \  
  -e FIREFOX_CLI=[] \  # 可选  
  -p 3000:3000 \  
  -p 3001:3001 \  
  -v /path/to/本地配置目录:/config \  
  --shm-size="1gb" \  
  --restart unless-stopped \  
  lscr.io/linuxserver/firefox:latest  
```  


## 参数说明  

| 参数                | 作用说明                                                                 |  
|---------------------|--------------------------------------------------------------------------|  
| `-p 3000:3000`      | HTTP 端口映射（建议仅用于反向代理）                                      |  
| `-p 3001:3001`      | HTTPS 端口映射（直接访问容器用）                                        |  
| `-e PUID/PGID`      | 容器内用户/组 ID，避免权限冲突（需与宿主机目录所有者一致）               |  
| `-e TZ`             | 时区设置（如 `Asia/Shanghai`）                                           |  
| `-e FIREFOX_CLI`    | Firefox 启动参数（如指定默认打开页面）                                   |  
| `-v /config`        | 配置目录挂载（保存用户数据、设置等）                                     |  
| `--shm-size`        | 共享内存大小（建议至少 1GB，用于视频播放等场景）                         |  


## 环境变量文件（Docker Secrets）  
通过 `FILE__` 前缀从文件加载环境变量：  
```bash  
-e FILE__PASSWORD=/run/secrets/my_password  # 从文件 /run/secrets/my_password 读取 PASSWORD 变量  
```  


## 用户/组 ID 配置  
通过 `id 用户名` 命令获取宿主机用户的 UID 和 GID，例如：  
```bash  
id your_user  
# 输出示例：uid=1000(your_user) gid=1000(your_user)  
```  
将 `PUID=1000` 和 `PGID=1000` 填入环境变量，避免挂载目录权限问题。  


## 容器管理  


### 查看日志  
```bash  
docker logs -f firefox  
```  


### 进入容器终端  
```bash  
docker exec -it firefox /bin/bash  
```  


### 版本信息  
- 容器版本：`docker inspect -f '{{ index .Config.Labels "build_version" }}' firefox`  
- 镜像版本：`docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/firefox:latest`  


## 更新容器  


### Docker Compose  
```bash  
# 拉取最新镜像  
docker-compose pull firefox  
# 重启容器  
docker-compose up -d firefox  
# 清理旧镜像  
docker image prune  
```  


### Docker Run  
```bash  
# 拉取最新镜像  
docker pull lscr.io/linuxserver/firefox:latest  
# 停止并删除旧容器  
docker stop firefox && docker rm firefox  
# 用原参数启动新容器（配置目录挂载正确则数据保留）  
docker run [原参数] lscr.io/linuxserver/firefox:latest  
```  


## 本地构建镜像  
```bash  
git clone []  
cd docker-firefox  
docker build --no-cache --pull -t lscr.io/linuxserver/firefox:latest .  
```  
ARM 架构构建需先注册 qemu-static：  
```bash  
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset  
# 构建 arm64 镜像  
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/firefox:arm64v8-latest .  
```  


## 版本历史  
- **26.08.25**：抑制沙箱安全警告（容器内提示易误导）  
- **01.07.25**：新增 Kasm 分支  
- **23.06.25**：基于 Selkies 重构，强制启用 HTTPS  
- **18.03.23**：迁移至 KasmVNC 基础镜像  
- **19.04.21**：初始发布  


## 相关链接  
- [容器源码]([])  
- [Docker Mods（扩展功能）]([])  
- [LinuxServer.io 官网]([])

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/firefox" title="linuxserver/firefox Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/firefox</a></p>
