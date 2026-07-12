---
image: webhippie/minecraft-forge
description: "运行Minecraft Forge的Docker镜像，基于香草版Minecraft镜像构建，用于部署和运行支持Mod的Forge服务器。"
source: https://xuanyuan.cloud/zh/r/webhippie/minecraft-forge
canonical: https://xuanyuan.cloud/zh/r/webhippie/minecraft-forge
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/webhippie/minecraft-forge" title="webhippie/minecraft-forge Docker 镜像中文简介、标签列表与拉取命令">webhippie/minecraft-forge 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# minecraft-forge

## 镜像概述和主要用途
本镜像为Minecraft Forge的Docker镜像，基于[香草版Minecraft镜像](https://github.com/dockhippie/minecraft-vanilla)构建，用于快速部署和运行支持Mod的Minecraft Forge服务器，简化服务器环境的配置与管理。

## 版本信息
可用版本可通过以下途径查看：
- [Docker Hub](https://hub.docker.com/r/webhippie/minecraft-forge/tags)
- [Quay](https://quay.io/repository/webhippie/minecraft-forge?tab=tags)
- [GitHub仓库](https://github.com/dockhippie/minecraft-forge)中的现有文件夹

## 核心功能和特性
- 基于香草版Minecraft镜像，继承其基础运行环境与核心功能
- 原生支持Minecraft Forge服务器，允许安装和运行Mod扩展
- 提供数据持久化与配置覆盖机制，确保服务器数据与配置稳定

## 使用场景和适用范围
适用于需要部署支持Mod的Minecraft服务器的场景，如个人服务器、小型社区服务器等，尤其适合希望通过Docker快速搭建标准化Forge服务器环境的用户。

## 详细使用方法和配置说明

### 卷（Volumes）
- `/var/lib/minecraft`: 存储Minecraft服务器数据（如世界文件、玩家数据、Mod文件等）
- `/etc/minecraft/override`: 用于覆盖服务器默认配置文件

### 端口（Ports）
- `25565`: Minecraft游戏连接默认端口
- `25575`: RCON远程控制台端口
- `8123`: 附加服务端口（如地图查看器等）

### 环境变量
#### 可用环境变量
当前镜像未定义特定环境变量。

#### 继承的环境变量
- [webhippie/minecraft-vanilla](https://github.com/dockhippie/minecraft-vanilla#available-environment-variables)（香草版Minecraft镜像环境变量）
- [webhippie/temurin](https://github.com/dockhippie/temurin#available-environment-variables)（Java运行环境变量）
- [webhippie/ubuntu](https://github.com/dockhippie/ubuntu#available-environment-variables)（基础Ubuntu系统环境变量）

### 部署示例

#### 使用`docker run`命令部署
```bash
docker run -d \
  --name minecraft-forge-server \
  -p 25565:25565 \
  -p 25575:25575 \
  -p 8123:8123 \
  -v /path/to/local/data:/var/lib/minecraft \
  -v /path/to/local/override:/etc/minecraft/override \
  docker.xuanyuan.run/webhippie/minecraft-forge:latest
```

#### 使用`docker-compose`配置部署
```yaml
version: '3'
services:
  minecraft-forge:
    image: docker.xuanyuan.run/webhippie/minecraft-forge:latest
    container_name: minecraft-forge-server
    ports:
      - "25565:25565"
      - "25575:25575"
      - "8123:8123"
    volumes:
      - ./minecraft-data:/var/lib/minecraft  # 本地数据目录映射
      - ./minecraft-override:/etc/minecraft/override  # 配置覆盖目录映射
    restart: unless-stopped
```

## 贡献方式
Fork → 提交补丁 → 推送 → 提交Pull Request

## 作者
- [Thomas Boerger](https://github.com/tboerger)

## 许可证
MIT

## 版权信息
```console
Copyright (c) 2015 Thomas Boerger <http://www.webhippie.de>
