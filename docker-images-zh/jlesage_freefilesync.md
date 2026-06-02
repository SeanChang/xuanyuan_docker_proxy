---
image: jlesage/freefilesync
description: "Docker容器化的FreeFileSync，提供便捷的跨平台文件同步功能，支持本地与网络位置间的文件备份及一致性维护。"
source: https://xuanyuan.cloud/zh/r/jlesage/freefilesync
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[jlesage/freefilesync](https://xuanyuan.cloud/zh/r/jlesage/freefilesync)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# FreeFileSync Docker 镜像

[![Release](https://img.shields.io/github/release/jlesage/docker-freefilesync.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-freefilesync/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/freefilesync/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/freefilesync/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/freefilesync?label=拉取次数&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/freefilesync)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/freefilesync?label=星级&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/freefilesync)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-freefilesync/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-freefilesync/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-freefilesync)

## 镜像概述和主要用途

这是 [FreeFileSync](https://freefilesync.org) 的 Docker 容器。该应用程序的图形用户界面 (GUI) 可通过现代 Web 浏览器访问，无需在客户端进行任何安装或配置。

FreeFileSync 是一款文件夹比较和同步软件，用于创建和管理所有重要文件的备份副本。它不会每次都复制所有文件，而是确定源文件夹和目标文件夹之间的差异，并仅传输所需的最小数据量。

## 核心功能和特性

- 通过 Web 浏览器访问的图形用户界面，无需客户端安装
- 文件夹比较和同步功能
- 智能同步算法，仅传输差异数据
- 创建和管理文件备份副本
- 支持多种同步模式和选项
- 可配置的比较规则和过滤器
- 详细的同步报告和日志

## 使用场景和适用范围

- 个人文件备份和同步
- 服务器间文件同步
- 多设备文件同步管理
- 定期自动备份任务
- 需要通过Web界面管理文件同步的场景
- 开发环境与生产环境文件同步

## 详细的使用方法和配置说明

### 快速开始

**注意**：
    本快速入门中提供的 Docker 命令仅为示例，应根据实际需求调整参数。

使用以下命令启动 FreeFileSync Docker 容器：

```shell
docker run -d \
    --name=freefilesync \
    -p 5800:5800 \
    -v /docker/appdata/freefilesync:/config:rw \
    -v /home/user:/storage:rw \
    jlesage/freefilesync
```

其中：

  - `/docker/appdata/freefilesync`: 存储应用程序的配置、状态、日志和任何需要持久化的文件。
  - `/home/user`: 包含需要供应用程序访问的主机文件。

通过访问 `http://你的主机IP:5800` 来打开 FreeFileSync 的 GUI 界面。主机文件在容器中显示为 `/storage` 文件夹。

### Docker Compose 配置示例

```yaml
version: '3'
services:
  freefilesync:
    image: jlesage/freefilesync
    container_name: freefilesync
    restart: always
    ports:
      - "5800:5800"
    volumes:
      - /docker/appdata/freefilesync:/config:rw
      - /home/user:/storage:rw
      - /data/documents:/documents:rw
      - /data/photos:/photos:rw
    environment:
      - USER_ID=1000
      - GROUP_ID=1000
      - TZ=Asia/Shanghai
```

### 配置参数说明

#### 端口映射

| 端口 | 说明 |
|------|------|
| 5800 | Web 界面访问端口 |

#### 卷映射

| 卷路径 | 说明 |
|--------|------|
| `/config` | 应用程序配置和状态文件 |
| `/storage` | 主机文件访问点（可自定义多个） |

#### 环境变量

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `USER_ID` | 运行应用程序的用户ID | 1000 |
| `GROUP_ID` | 运行应用程序的组ID | 1000 |
| `TZ` | 设置时区 | UTC |
| `KEEP_APP_RUNNING` | 当应用程序退出时自动重启 | `0` (禁用) |
| `DISPLAY_WIDTH` | Web 界面宽度 | 1280 |
| `DISPLAY_HEIGHT` | Web 界面高度 | 768 |
| `SECURE_CONNECTION` | 启用HTTPS | `0` (禁用) |
| `VNC_PASSWORD` | VNC访问密码（需要启用安全连接） | 无 |

### 高级配置

可以通过添加多个卷映射来提供对主机上不同目录的访问：

```shell
docker run -d \
    --name=freefilesync \
    -p 5800:5800 \
    -v /docker/appdata/freefilesync:/config:rw \
    -v /home/user/documents:/documents:rw \
    -v /home/user/photos:/photos:rw \
    -v /home/user/music:/music:rw \
    -e TZ=Asia/Shanghai \
    jlesage/freefilesync
```

## 文档和支持

完整文档可在 https://github.com/jlesage/docker-freefilesync 获取。

遇到容器问题或有疑问？请 [创建新issue](https://github.com/jlesage/docker-freefilesync/issues)。

其他 Docker 化应用，请访问 https://jlesage.github.io/docker-apps。
