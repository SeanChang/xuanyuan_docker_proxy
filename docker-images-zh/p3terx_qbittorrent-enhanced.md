---
image: p3terx/qbittorrent-enhanced
description: "qBittorrent增强版Docker镜像，专注于BT协议下载，提供WebUI管理界面，支持自定义配置、持久化存储和用户权限控制，适用于个人BT下载服务部署。"
source: https://xuanyuan.cloud/zh/r/p3terx/qbittorrent-enhanced
canonical: https://xuanyuan.cloud/zh/r/p3terx/qbittorrent-enhanced
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/p3terx/qbittorrent-enhanced" title="p3terx/qbittorrent-enhanced Docker 镜像中文简介、标签列表与拉取命令">p3terx/qbittorrent-enhanced 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## qBittorrent 增强版 (仅BT协议)

### 镜像概述
qBittorrent 增强版Docker镜像是基于qBittorrent的优化版本，专注于BT协议下载功能，提供Web用户界面(WebUI)用于管理下载任务，支持自定义配置、持久化存储和用户权限控制，适用于快速部署个人BT下载服务。

### 核心功能与特性
- **专注BT协议**：优化BT下载性能，专注于BT协议的稳定运行
- **WebUI管理**：通过Web界面便捷管理下载任务、种子文件和下载设置
- **持久化存储**：支持配置文件和下载文件的持久化，容器重启后数据不丢失
- **用户权限控制**：通过PUID/PGID设置运行用户，避免权限问题
- **灵活配置**：支持自定义WebUI端口、时区、文件权限掩码(UMASK)等参数
- **自动重启**：可配置容器自动重启策略，确保服务持续可用

### 使用场景
- 个人BT下载服务部署
- 家庭网络环境中的BT资源下载管理
- 需要持久化配置和下载文件的BT客户端需求

### 使用方法

#### 基本部署命令
通过以下`docker run`命令快速部署qBittorrent增强版容器：

```bash
docker run -d \
    --name qbittorrent-enhanced \
    --restart unless-stopped \
    --network host \
    -e PUID=$UID \
    -e PGID=$GID \
    -e UMASK_SET=022 \
    -e TZ=Asia/Shanghai \
    -e QBT_WEBUI_PORT=28080 \
    -v ~/qbte-profile:/qBittorrent \
    -v ~/qbte-downloads:/downloads \
    docker.xuanyuan.run/p3terx/qbittorrent-enhanced
```

#### 参数说明

##### 容器参数
- `--name qbittorrent-enhanced`：指定容器名称为qbittorrent-enhanced
- `--restart unless-stopped`：设置容器重启策略为除非手动停止，否则自动重启
- `--network host`：使用主机网络模式，容器直接使用主机的网络栈

##### 环境变量
- `PUID=$UID`：设置运行容器的用户ID，默认使用当前用户ID，避免权限问题
- `PGID=$GID`：设置运行容器的组ID，默认使用当前用户组ID
- `UMASK_SET=022`：设置文件权限掩码，控制新建文件的权限，默认022
- `TZ=Asia/Shanghai`：设置时区，如"Asia/Shanghai"表示中国上海时区
- `QBT_WEBUI_PORT=28080`：设置WebUI访问端口，可根据需求自定义

##### 数据卷挂载
- `-v ~/qbte-profile:/qBittorrent`：挂载配置文件目录，保存qBittorrent的设置、种子列表等
- `-v ~/qbte-downloads:/downloads`：挂载下载目录，BT下载的文件将保存在此目录

#### 访问WebUI
部署完成后，通过浏览器访问 `http://<主机IP>:<QBT_WEBUI_PORT>` 即可打开qBittorrent WebUI，例如配置了`QBT_WEBUI_PORT=28080`时，访问 `http://localhost:28080`。

### 注意事项
- 确保主机网络模式下，指定的WebUI端口未被其他服务占用
- 挂载的本地目录需具有适当权限，避免容器无法读写数据
- 首次登录WebUI时，默认用户名通常为`admin`，密码为`adminadmin`，建议登录后立即修改密码
