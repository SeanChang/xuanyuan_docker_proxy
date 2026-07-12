---
image: zsource/siyuan
description: "思源笔记 Docker 镜像，适用于极空间 Z4 / Z4S / Z2S 设备，提供在极空间 Docker 环境中部署思源笔记的解决方案。"
source: https://xuanyuan.cloud/zh/r/zsource/siyuan
canonical: https://xuanyuan.cloud/zh/r/zsource/siyuan
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zsource/siyuan" title="zsource/siyuan Docker 镜像中文简介、标签列表与拉取命令">zsource/siyuan 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 极空间专用思源笔记 Docker 镜像

## 镜像概述

本镜像为极空间（Z4 / Z4S / Z2S）设备提供思源笔记的 Docker 部署支持，方便用户在极空间环境中快速搭建和使用思源笔记。

- **镜像名称**：`zsource/siyuan`

## 核心功能与特性

- 专为极空间设备优化，适配其 Docker 环境
- 支持工作空间目录持久化存储，确保笔记数据不丢失
- 可通过环境变量灵活配置访问授权码及用户权限
- 标准端口暴露，便于在极空间局域网内访问

## 使用场景

适用于极空间 Z4 / Z4S / Z2S 设备用户，需要在个人私有存储设备上部署思源笔记，实现笔记的本地存储与管理。

## 详细使用方法

### 目录挂载

在极空间中创建本地目录（如 `/volume1/docker/siyuan/workspace`），并映射至容器的 `/siyuan/workspace/` 目录，作为思源笔记的工作空间（workspace）目录，实现数据持久化：

```bash
-v /极空间本地目录路径:/siyuan/workspace/
```

### 环境配置

创建容器时可通过以下环境变量进行配置：

| 环境变量 | 说明 | 默认值 |
|----------|------|--------|
| `WORKSPACE` | 思源笔记工作空间目录配置 | `/siyuan/workspace/` |
| `ACCESSAUTHCODE` | 思源笔记访问授权码（用于限制访问） | 空（不设置授权码） |
| `PUID` | 运行容器的用户ID | `0` |
| `PGID` | 运行容器的用户组ID | `0` |

### 访问端口

容器内部使用 **6806** 端口提供服务，部署时需映射此端口至主机，通过 `极空间设备IP:6806` 访问思源笔记。

### 部署示例

#### Docker Run 命令

```bash
docker run -d \
  --name siyuan-note \
  -p 6806:6806 \
  -v /volume1/docker/siyuan/workspace:/siyuan/workspace/ \
  -e ACCESSAUTHCODE=your_auth_code \
  -e PUID=0 \
  -e PGID=0 \
  docker.xuanyuan.run/zsource/siyuan
```

#### 参数说明

- `-d`：后台运行容器
- `--name siyuan-note`：指定容器名称为 `siyuan-note`
- `-p 6806:6806`：映射主机6806端口至容器6806端口
- `-v /volume1/docker/siyuan/workspace:/siyuan/workspace/`：挂载极空间本地目录作为工作空间
- `-e ACCESSAUTHCODE=your_auth_code`：设置访问授权码（替换为实际授权码）
- `zsource/siyuan`：使用的镜像名称
