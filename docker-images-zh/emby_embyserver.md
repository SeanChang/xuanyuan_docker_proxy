<!-- xuanyuan-docker-images-zh
image: emby/embyserver
source: https://xuanyuan.cloud/zh/r/emby/embyserver
canonical: https://xuanyuan.cloud/zh/r/emby/embyserver
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/emby/embyserver" title="emby/embyserver Docker 镜像中文简介、标签列表与拉取命令">emby/embyserver — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/emby/embyserver" title="emby/embyserver Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/emby/embyserver</a></p>

# Emby Media Server


## 一、简介

Emby Media Server 是一款家庭媒体服务器，基于 Service Stack、jQuery、jQuery mobile、.NET Core 等主流开源技术构建。它提供基于 REST 的 API 并内置文档，方便客户端开发，同时还配有 API 客户端库以加速开发流程。


### 支持的架构

Emby 支持以下架构，每种架构对应独立的仓库：
- amd64：emby/embyserver
- arm32v7：emby/embyserver_arm32v7
- arm64v8：emby/embyserver_arm64v8

以下说明均以 amd64 仓库为例，实际使用时请根据架构替换 `emby/embyserver` 为对应仓库名。


### 支持的标签

- latest：最新稳定版
- beta：最新测试版


### 问题反馈

反馈问题前，请先尝试更新 Docker 至最新版本（参考 [Docker 安装指南]([])），看是否解决问题。SELinux 用户可尝试执行 `setenforce 0` 命令关闭 SELinux 测试。

若问题仍存在，请 [提交 issue]([]) 并附上以下信息：
- `docker version` 和 `docker info` 命令的输出结果
- 启动容器时使用的 `docker run` 命令或 `docker-compose.yml` 文件（敏感信息需脱敏）
- 说明是否使用 Boot2Docker、VirtualBox 等工具


## 二、快速上手

### 安装

推荐直接从 [Docker Hub]([]) 安装：

```sh
docker pull emby/embyserver:latest
```

新版 .NET Core 版本完全通过命令行配置，不再需要启动脚本、配置文件及本地更新功能，更新时直接拉取最新镜像即可。


#### 使用 Docker Compose 启动

创建 `docker-compose.yml` 文件：

```yaml
version: "2.3"
services:
  emby:
    image: emby/embyserver
    container_name: embyserver
    runtime: nvidia  # 暴露 NVIDIA GPU（如需）
    network_mode: host  # 启用 DLNA 和网络唤醒
    environment:
      - UID=1000  # 运行 emby 的用户 ID（默认：2）
      - GID=100   # 运行 emby 的用户组 ID（默认：2）
      - GIDLIST=100  # 额外用户组 ID 列表（逗号分隔，默认：2）
    volumes:
      - /path/to/programdata:/config  # 配置文件目录
      - /path/to/tvshows:/mnt/share1  # 媒体文件目录 1
      - /path/to/movies:/mnt/share2   # 媒体文件目录 2
    ports:
      - 8096:8096  # HTTP 端口
      - 8920:8920  # HTTPS 端口
    devices:
      - /dev/dri:/dev/dri  # VAAPI/NVDEC/NVENC 渲染节点
      - /dev/vchiq:/dev/vchiq  # 树莓派 MMAL/OMX 支持
    restart: on-failure
```


#### 使用命令行启动

```sh
docker run -d \
    --name embyserver \
    --volume /path/to/programdata:/config \  # 配置文件目录
    --volume /path/to/share1:/mnt/share1 \  # 媒体文件目录 1
    --volume /path/to/share2:/mnt/share2 \  # 媒体文件目录 2
    --net=host \  # 启用 DLNA 和网络唤醒
    --device /dev/dri:/dev/dri \  # VAAPI/NVDEC/NVENC 渲染节点
    --device /dev/vchiq:/dev/vchiq \  # 树莓派 MMAL/OMX 支持
    --gpus all \  # 暴露所有 NVIDIA GPU（如需）
    --publish 8096:8096 \  # HTTP 端口
    --publish 8920:8920 \  # HTTPS 端口
    --env UID=1000 \  # 运行 emby 的用户 ID（默认：2）
    --env GID=100 \   # 运行 emby 的用户组 ID（默认：2）
    --env GIDLIST=100 \  # 额外用户组 ID 列表（逗号分隔，默认：2）
    --restart on-failure \  # 启动失败时自动重启
    emby/embyserver:latest
```

**说明**：  
- UID、GID、GIDLIST 需根据媒体文件所有者调整（默认值为 2），建议保持默认以降低权限，通过 GIDLIST 添加所需权限。  
- 可通过 `ls -l <目录路径>` 查看媒体目录的用户/组信息，通过 `getent passwd <用户名> | cut -d: -f3` 和 `getent group <组名> | cut -d: -f3` 获取 UID 和 GID。  

容器启动后，通过 `http://<Docker 主机 IP>:8096` 或 `https://<Docker 主机 IP>:8920` 访问 Web 界面。


### 更新

更新命令与安装相同，拉取最新镜像即可：

```sh
docker pull emby/embyserver:latest
```


## 三、DLNA 与网络唤醒（WoL）

若需 DLNA 和网络唤醒功能正常工作，最简单的方式是使用 `host` 网络模式。桥接模式下可能需要复杂配置才能生效。


## 四、VAAPI 支持

**仅适用于 amd64 架构**  

Intel 高清显卡平台的 Emby 已内置支持 VAAPI 的 ffmpeg。VAAPI 需访问渲染节点（通常为 `/dev/dri/renderD128`），该节点在多数现代系统中属于 `video` 组，部分属于 `render` 组。只需挂载渲染节点，并将 `video` 或 `render` 组的 GID 添加到 GIDLIST 环境变量即可。

获取组 GID 的命令：
```sh
getent group video | cut -d: -f3  # 获取 video 组 GID
getent group render | cut -d: -f3  # 获取 render 组 GID
```


## 五、NVDEC/NVENC 支持

**仅适用于 amd64 架构**  

Emby 可通过 NVIDIA 容器运行时利用 NVIDIA GPU，需先根据系统安装 `nvidia-container-runtime` 或旧版 `nvidia-docker2` 包，然后重启 Docker 服务。

同样需将 `video` 或 `render` 组的 GID 添加到 GIDLIST，获取 GID 的命令同上：
```sh
getent group video | cut -d: -f3
getent group render | cut -d: -f3
```


## 六、unRAID 系统安装

在 unRAID Web 界面的 Docker 设置中，添加以下仓库链接：  
```
[] unRAID 模板添加的更多信息，可参考 [unRAID 论坛]([])。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/emby/embyserver" title="emby/embyserver Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/emby/embyserver</a></p>
