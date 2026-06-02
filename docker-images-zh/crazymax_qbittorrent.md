<!-- xuanyuan-docker-images-zh
image: crazymax/qbittorrent
source: https://xuanyuan.cloud/zh/r/crazymax/qbittorrent
canonical: https://xuanyuan.cloud/zh/r/crazymax/qbittorrent
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/crazymax/qbittorrent" title="crazymax/qbittorrent Docker 镜像中文简介、标签列表与拉取命令">crazymax/qbittorrent — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/crazymax/qbittorrent" title="crazymax/qbittorrent Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/crazymax/qbittorrent</a></p>

# qBittorrent Docker镜像（基于Alpine Linux）

## 镜像概述

本镜像为基于Alpine Linux的qBittorrent Docker实现。qBittorrent是一款开源、跨平台的BitTorrent客户端，集成了BitTorrent协议支持、Web UI管理界面及种子文件管理功能。依托Alpine Linux的轻量级特性，该镜像具有资源占用低、启动速度快、安全性高等优势，适合快速部署高效的BT下载服务。

完整文档请参考[GitHub仓库](https://github.com/crazy-max/docker-qbittorrent)。

## 核心功能和特性

### qBittorrent核心功能
- 支持BitTorrent协议标准下载，包括磁力链接、种子文件解析
- 内置Web UI管理界面，支持远程监控和操作
- 种子文件管理（添加、删除、暂停、恢复等）
- 带宽控制、下载/上传速度限制
- 支持DHT、PEX、Magnet链接等BT网络功能

### 镜像特性
- 基于Alpine Linux，镜像体积小（通常<100MB），资源占用低
- 采用Docker容器化部署，环境隔离，依赖管理简单
- 支持数据持久化存储，配置和下载文件可通过卷挂载保存
- 兼容多种架构（如x86_64、ARM等，具体取决于镜像构建支持）

## 使用场景和适用范围

- **个人用户本地部署**：家庭环境中搭建BT下载服务，用于媒体文件、开源软件等合法内容下载
- **家庭服务器**：作为家庭媒体中心的下载组件，配合Plex、Emby等媒体服务器实现自动化媒体获取
- **资源受限环境**：在树莓派、NAS等低配置设备上部署，利用轻量级特性降低资源占用
- **开发/测试环境**：快速搭建临时BT下载服务用于文件共享测试

## 使用方法和配置说明

### 基本部署（docker run）

```bash
docker run -d \
  --name=qbittorrent \
  -p 8080:8080 \  # Web UI端口
  -p 6881:6881 \  # BT监听端口(TCP)
  -p 6881:6881/udp \  # BT监听端口(UDP)
  -v /path/to/config:/config \  # 配置文件持久化
  -v /path/to/downloads:/downloads \  # 下载文件存储目录
  --restart unless-stopped \
  crazymax/qbittorrent:latest
```

### Docker Compose配置

```yaml
version: '3.8'

services:
  qbittorrent:
    image: crazymax/qbittorrent:latest
    container_name: qbittorrent
    ports:
      - "8080:8080"   # Web UI端口
      - "6881:6881"   # BT监听端口(TCP)
      - "6881:6881/udp"  # BT监听端口(UDP)
    volumes:
      - /path/to/config:/config  # 配置文件目录
      - /path/to/downloads:/downloads  # 下载文件目录
    restart: unless-stopped
```

### 环境变量配置（可选）

通过`-e`参数或docker-compose的`environment`字段设置环境变量，常见配置如下：

| 环境变量 | 描述 | 默认值 |
|----------|------|--------|
| `WEBUI_PORT` | Web UI访问端口 | `8080` |
| `QBT_EULA` | 是否接受用户协议（设置为`accept`表示接受） | 无（需手动接受） |
| `QBT_WEBUI_USERNAME` | Web UI登录用户名 | `admin` |
| `QBT_WEBUI_PASSWORD` | Web UI登录密码 | `adminadmin` |
| `QBT_CONFIG_PATH` | 配置文件存储路径 | `/config` |
| `QBT_DOWNLOAD_PATH` | 默认下载目录 | `/downloads` |

### 访问与使用

1. 部署完成后，通过浏览器访问 `http://<宿主机IP>:8080` 打开Web UI
2. 使用默认用户名/密码（或自定义环境变量设置的凭据）登录
3. 在Web UI中添加种子文件或磁力链接，配置下载参数即可开始使用

### 持久化配置

为确保配置和下载文件不丢失，需通过`-v`参数挂载以下目录：
- `/config`：存储qBittorrent配置文件、种子列表等数据
- `/downloads`：存储下载完成的文件

建议使用宿主机绝对路径挂载，例如`-v /home/user/qbittorrent/config:/config`。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/crazymax/qbittorrent" title="crazymax/qbittorrent Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/crazymax/qbittorrent</a></p>
