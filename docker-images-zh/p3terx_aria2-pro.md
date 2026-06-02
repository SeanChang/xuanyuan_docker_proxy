---
image: p3terx/aria2-pro
description: "Aria2 Pro Docker镜像是一个功能完善的Aria2容器化解决方案，开箱即用，支持多平台，集成自动BT追踪器获取、下载文件管理等功能，提供高速下载体验，无需复杂配置即可高效进行文件下载。"
source: https://xuanyuan.cloud/zh/r/p3terx/aria2-pro
canonical: https://xuanyuan.cloud/zh/r/p3terx/aria2-pro
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/p3terx/aria2-pro" title="p3terx/aria2-pro Docker 镜像中文简介、标签列表与拉取命令">p3terx/aria2-pro 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Aria2 Pro Docker

[![LICENSE](https://img.shields.io/github/license/P3TERX/Aria2-Pro-Docker?style=flat-square&label=LICENSE)](https://github.com/P3TERX/Aria2-Pro-Docker/blob/master/LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/P3TERX/Aria2-Pro-Docker.svg?style=flat-square&label=Stars&logo=github)](https://github.com/P3TERX/Aria2-Pro-Docker/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/P3TERX/Aria2-Pro-Docker.svg?style=flat-square&label=Forks&logo=github)](https://github.com/P3TERX/Aria2-Pro-Docker/fork)
[![Docker Stars](https://img.shields.io/docker/stars/p3terx/aria2-pro.svg?style=flat-square&label=Stars&logo=docker)](https://hub.docker.com/r/p3terx/aria2-pro)
[![Docker Pulls](https://img.shields.io/docker/pulls/p3terx/aria2-pro.svg?style=flat-square&label=Pulls&logo=docker&color=orange)](https://hub.docker.com/r/p3terx/aria2-pro)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/P3TERX/Aria2-Pro-Docker/docker-build-test.yml?label=Actions&logo=github&style=flat-square)

Aria2 Pro Docker镜像是一个完美的Aria2容器化解决方案，开箱即用，只需添加下载任务，无需考虑其他复杂配置。

## 核心功能与特性

* 支持多平台：`amd64`、`i386`、`arm64`、`arm/v7`、`arm/v6`
* 完整功能：异步DNS、BitTorrent、Firefox3 Cookie、GZip、HTTPS、消息摘要、Metalink、XML-RPC、SFTP
* `max-connection-per-server`（每服务器最大连接数）无限制
* 支持低速（`lowest-speed-limit`）和连接关闭时重试
* 高BT下载率和速度
* 自动获取BitTorrent追踪器
* 下载错误时自动删除文件
* 取消下载时自动删除文件
* 自动清理 `.aria2` 后缀文件
* 自动清理 `.torrent` 后缀文件
* 无任务进度丢失，无重复下载
* 更多强大功能

## 使用场景与适用范围

适用于需要高效进行文件下载的用户，包括HTTP/HTTPS下载、BT下载、磁力链接下载等场景。特别适合希望简化Aria2配置、需要跨平台部署（如服务器、NAS、开发板等）以及追求高下载效率的用户。

## 使用方法

### Docker CLI

- 无论使用何种架构平台，只需使用以下命令启动容器（需替换 `<TOKEN>` 字段）：
```bash
docker run -d \
    --name aria2-pro \
    --restart unless-stopped \
    --log-opt max-size=1m \
    -e PUID=$UID \
    -e PGID=$GID \
    -e UMASK_SET=022 \
    -e RPC_SECRET=<TOKEN> \
    -e RPC_PORT=6800 \
    -p 6800:6800 \
    -e LISTEN_PORT=6888 \
    -p 6888:6888 \
    -p 6888:6888/udp \
    -v $PWD/aria2-config:/config \
    -v $PWD/aria2-downloads:/downloads \
    p3terx/aria2-pro
```

- 之后需要WebUI进行控制，例如 [AriaNg](https://github.com/mayswind/AriaNg)。开发者提供了可直接使用的链接：[http://ariang.mayswind.net/latest](http://ariang.mayswind.net/latest)。也可通过Docker自行部署：
```bash
docker run -d \
    --name ariang \
    --log-opt max-size=1m \
    --restart unless-stopped \
    -p 6880:6880 \
    p3terx/ariang
```

> **提示：** 防火墙开放相关端口非常重要。

### Docker Compose

- 下载Compose文件
```bash
wget git.io/aria2-pro.yml
```

- 编辑Compose文件
```bash
vim aria2-pro.yml
```

- 启动服务
```bash
docker-compose -f aria2-pro.yml up -d
```

### 其他部署方式

- [UNRAID Docker模板](https://github.com/P3TERX/unraid-docker-templates)
- [群晖DSM Docker教程（中文）](https://p3terx.com/archives/synology-nas-docker-advanced-tutorial-deploy-aria2-pro.html)

## 配置参数

| 参数 | 功能描述 |
|------|----------|
| `-e PUID=$UID`<br>`-e PGID=$GID` | 将容器绑定到指定的UID和GID，意味着可以使用非root用户管理下载文件。 |
| `-e UMASK_SET=022` | Aria2的umask设置，可选，未设置时默认值为`022`。 |
| `-e RPC_SECRET=<TOKEN>` | 设置RPC秘密授权令牌。默认值：`P3TERX`。 |
| `-e RPC_PORT=6800` | 设置RPC监听端口。 |
| `-p 6800:6800` | 绑定RPC监听端口。 |
| `-e LISTEN_PORT=6888` | 设置BitTorrent/DHT监听的TCP/UDP端口号。 |
| `-p 6888:6888` | 绑定BT监听端口（TCP）。 |
| `-p 6888:6888/udp` | 绑定DHT监听端口（UDP）。 |
| `-v <PATH>:/config` | 包含所有相关配置文件的目录。 |
| `-v <PATH>:/downloads` | 下载文件在磁盘上的存储位置。 |
| `-e DISK_CACHE=<SIZE>` | 设置磁盘缓存。SIZE可包含`K`或`M`（1K=1024，1M=1024K），例如`64M`。 |
| `-e IPV6_MODE=<BOOLEAN>` | 是否启用Aria2的IPv6支持。可选值：`true`或`false`。启用时会在配置文件（aria2.conf）中设置`disable-ipv6=false`和`enable-dht6=true`。 |
| `-e UPDATE_TRACKERS=<BOOLEAN>` | 是否自动更新BT追踪器列表。可选值：`true`或`false`，未设置时默认值为`true`。 |
| `-e CUSTOM_TRACKER_URL=<URL>` | 自定义BT追踪器列表URL。未设置时，将从https://trackerslist.com/all_aria2.txt获取。 |
| `-e TZ=Asia/Shanghai` | 指定时区，例如`Asia/Shanghai`。 |

## 高级配置

作者正在完善英文文档，高级配置部分的详细说明将后续补充。若您能阅读中文，可参考[原作者博客](https://p3terx.com/archives/docker-aria2-pro.html)获取更多信息。

## 相关项目

* [aria2](https://github.com/aria2/aria2)
* [P3TERX/aria2.conf](https://github.com/P3TERX/aria2.conf)
* [P3TERX/Aria2-Pro-Core](https://github.com/P3TERX/Aria2-Pro-Core)
* [just-containers/s6-overlay](https://github.com/just-containers/s6-overlay)
* [XIU2/TrackersListCollection](https://github.com/XIU2/TrackersListCollection)

## 许可协议

[MIT](https://github.com/P3TERX/Aria2-Pro-Docker/blob/master/LICENSE) © P3TERX
