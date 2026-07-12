---
image: dothebetter/aria2
description: "aria2:1.37.0-20250722，集成Aria2、AriaNg和FileBrowser的下载镜像，基于Alpine，支持amd64、arm64v8和arm32v7架构，提供一站式下载管理解决方案。"
source: https://xuanyuan.cloud/zh/r/dothebetter/aria2
canonical: https://xuanyuan.cloud/zh/r/dothebetter/aria2
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dothebetter/aria2" title="dothebetter/aria2 Docker 镜像中文简介、标签列表与拉取命令">dothebetter/aria2 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 简介

<p align="center">
<a target="_blank" href="https://github.com/DoTheBetter/docker/tree/master/aria2"><img alt="Static Badge" src="https://img.shields.io/badge/Github-DoTheBetter%2Fdocker-brightgreen"></a>
<img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/DoTheBetter/docker?label=GitHub%20repo%20size">
<img alt="GitHub Actions Workflow Status" src="https://img.shields.io/github/actions/workflow/status/DoTheBetter/docker/DockerBuild_aria2.yml?label=GitHub%20Actions%20Workflow%20Status">
<br>
<a target="_blank" href="https://github.com/DoTheBetter/docker/pkgs/container/aria2"><img alt="Static Badge" src="https://img.shields.io/badge/ghcr.io-dothebetter%2Faria2-brightgreen"></a>
<a target="_blank" href="https://hub.docker.com/r/dothebetter/aria2"><img alt="Static Badge" src="https://img.shields.io/badge/docker.io-dothebetter%2Faria2-brightgreen"></a>
<img alt="Docker Image Version" src="https://img.shields.io/docker/v/dothebetter/aria2?label=Image%20Version">
<img alt="Docker Image Size" src="https://img.shields.io/docker/image-size/dothebetter/aria2?label=Image%20Size">
<img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/dothebetter/aria2?label=Docker%20Pulls">
</p>

自用Aria2+AriaNg+FileBrowser下载镜像，基于Alpine，支持amd64、arm64v8和arm32v7架构。

+ 使用基于 [myfreeer/aria2-build-msys2](https://github.com/myfreeer/aria2-build-msys2) 补丁构建的全静态多架构 [aria2c](https://github.com/DoTheBetter/aria2_build) 二进制文件
+ 采用 [P3TERX/aria2.conf](https://github.com/P3TERX/aria2.conf) 配置方案，包含配置文件、附加功能脚本等，用于增强和扩展Aria2功能
+ 定时更新aria2格式的Tracker列表，配置文件更新后自动重启aria2c
+ AriaNg访问地址：http://ip:8080
+ FileBrowser访问地址：http://ip:8081，默认使用admin/admin登录

项目地址：https://github.com/DoTheBetter/docker/tree/master/aria2

#### 官网地址

- https://github.com/aria2/aria2
- https://github.com/mayswind/AriaNg
- https://github.com/filebrowser/filebrowser

## 相关参数

### 环境变量

以下是可用于自定义配置的环境变量列表：

| 变量名 | 是否必须 | 默认值 | 说明 |
| :----: | :------: | :----: | :--- |
| `TZ` | 可选 | `Asia/Shanghai` | 设置时区 |
| `UID` | 可选 | `1000` | 设置aria2c运行用户ID |
| `GID` | 可选 | `1000` | 设置aria2c运行用户组ID |
| `UMASK` | 可选 | `022` | 设置新建文件的权限掩码，022表示文件默认权限为644，目录为755 |
| `ARIA2_RPC_SECRET` | 可选 | `无` | aria2的RPC密钥，用于AriaNg等客户端连接验证 |
| `ARIA2_RPC_LISTEN_PORT` | 可选 | `6800` | aria2的RPC服务监听端口 |
| `ARIA2_BT_LISTEN_PORT` | 可选 | `6881` | aria2的BT下载使用的端口，建议开启路由器的UPnP/NAT-PMP协议 |
| `CUSTOM_TRACKER_URL` | 可选 | `无` | 自定义BT tracker服务器列表地址，更新脚本内置 https://github.com/XIU2/TrackersListCollection 提供的列表 |
| `UPDATE_TRACKER` | 可选 | `1` | 自动更新BT tracker列表（天）。`不设置`或值为`0`时，禁用自动更新 |
| `ENABLE_IPV6` | 可选 | `false` | 启用IPv6支持，`true`：启用，`false`：禁用。开启时建议使用docker镜像的网络host模式 |
| `ENABLE_ARIANG` | 可选 | `true` | 启用AriaNg管理界面，`true`：启用，`false`：禁用 |
| `ENABLE_FILEBROWSER` | 可选 | `true` | 启用FileBrowser文件管理器，`true`：启用，`false`：禁用 |
| `HTTP_PORT` | 可选 | `8080` | AriaNg Web界面访问端口 |
| `FILEBROWSER_PORT` | 可选 | `8081` | FileBrowser文件管理器访问端口 |

### 开放的端口

| 范围 | 描述 |
| :---: | :---: |
| `6800` | aria2的RPC服务端口，用于AriaNg等客户端连接 |
| `6881` | aria2的BT/DHT监听端口，用于BT下载 |
| `6881/udp` | aria2的BT/DHT监听udp端口，用于BT下载 |
| `8080` | AriaNg Web界面访问端口 |
| `8081` | FileBrowser文件管理器访问端口 |

### 数据卷

以下目录可映射为持久存储，用于配置和数据保存：

| 文件或目录 | 描述 |
| :--------: | :---: |
| `/aria2/config` | 用于存储aria2和FileBrowser的配置文件 |
| `/aria2/download` | 用于存储aria2下载的文件 |

## 部署方法

> 本镜像在docker hub、ghcr.io及aliyuncs同步推送，docker hub无法使用时可选择其他仓库

### Docker Run

```bash
docker run -d \
    --name aria2 \
    --restart always \
    -e TZ=Asia/Shanghai \
    -e UID=1000 \
    -e GID=1000 \
    -e UMASK=022 \
    -e ARIA2_RPC_SECRET=123456 \
    -e ARIA2_RPC_LISTEN_PORT=6800 \
    -e ARIA2_BT_LISTEN_PORT=6881 \
    -e UPDATE_TRACKER=1 \
    -e ENABLE_IPV6=false \
    -e ENABLE_ARIANG=true \
    -e ENABLE_FILEBROWSER=true \
    -e HTTP_PORT=8080 \
    -e FILEBROWSER_PORT=8081 \
    -p 6800:6800 \
    -p 6881:6881 \
    -p 6881:6881/udp \
    -p 8080:8080 \
    -p 8081:8081 \
    -v /docker/aria2/config:/aria2/config \
    -v /docker/aria2/download:/aria2/download \
    docker.xuanyuan.run/dothebetter/aria2:latest
    #ghcr.io/dothebetter/aria2:latest
    #registry.cn-hangzhou.aliyuncs.com/dothebetter/aria2:latest

#host模式，开启ipv6
docker run -d \
    --name aria2 \
    --restart always \
    --network host \
    -e TZ=Asia/Shanghai \
    -e ARIA2_RPC_LISTEN_PORT=6800 \
    -e ARIA2_BT_LISTEN_PORT=6881 \
    -e ENABLE_IPV6=true \
    -e ENABLE_ARIANG=true \
    -e ENABLE_FILEBROWSER=true \
    -e HTTP_PORT=8080 \
    -e FILEBROWSER_PORT=8081 \
    -v /docker/aria2/config:/aria2/config \
    -v /docker/aria2/download:/aria2/download \
    docker.xuanyuan.run/dothebetter/aria2:latest
```

### docker-compose.yml

```yaml
services:
    aria2:
        image: docker.xuanyuan.run/dothebetter/aria2:latest
        #ghcr.io/dothebetter/aria2:latest
        #registry.cn-hangzhou.aliyuncs.com/dothebetter/aria2:latest
        container_name: aria2
        restart: always
        environment:
            - TZ=Asia/Shanghai
            - UID=1000
            - GID=1000
            - UMASK=022
            - ARIA2_RPC_SECRET=123456
            - ARIA2_RPC_LISTEN_PORT=6800
            - ARIA2_BT_LISTEN_PORT=6881
            - UPDATE_TRACKER=1
            - ENABLE_IPV6=false
            - ENABLE_ARIANG=true
            - ENABLE_FILEBROWSER=true
            - HTTP_PORT=8080
            - FILEBROWSER_PORT=8081
        ports:
            - 6800:6800
            - 6881:6881
            - 6881:6881/udp
            - 8080:8080
            - 8081:8081
        volumes:
            - /docker/aria2/config:/aria2/config
            - /docker/aria2/download:/aria2/download
```

## 更新日志

详见 **[CHANGELOG.md](https://github.com/DoTheBetter/docker/blob/master/./CHANGELOG.md)**
