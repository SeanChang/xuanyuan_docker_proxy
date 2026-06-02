---
image: cm2network/squad
description: "提供Squad游戏专用服务器，集成SteamCMD以支持服务器的安装与更新，用于部署和运行Squad多人游戏服务器。"
source: https://xuanyuan.cloud/zh/r/cm2network/squad
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[cm2network/squad](https://xuanyuan.cloud/zh/r/cm2network/squad)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Squad 专用服务器 Docker 镜像文档

[![](https://img.shields.io/codacy/grade/ac35171da5ca4fc29cfcdd2f7c1f7833)](https://hub.docker.com/r/cm2network/squad/) [![Docker Build Status](https://img.shields.io/docker/cloud/build/cm2network/squad.svg)](https://hub.docker.com/r/cm2network/squad/) [![Docker Stars](https://img.shields.io/docker/stars/cm2network/squad.svg)](https://hub.docker.com/r/cm2network/squad/) [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/squad.svg)](https://hub.docker.com/r/cm2network/squad/) [![](https://img.shields.io/docker/image-size/cm2network/squad)](https://microbadger.com/images/cm2network/squad) [![Discord](https://img.shields.io/discord/747067734029893653)](https://discord.gg/7ntmAwM)


## 支持的标签及对应 Dockerfile 链接
- [`latest` (*bullseye/Dockerfile*)](https://github.com/CM2Walki/Squad/blob/master/bullseye/Dockerfile)


## 镜像概述与主要用途
Squad 是一款战术 FPS 游戏，通过团队协作、沟通和游戏玩法提供真实的战斗体验，旨在弥合街机射击游戏与军事模拟游戏之间的巨大差距，支持大规模联合作战、基地建设和集成 VoIP 系统。  
本 Docker 镜像包含该游戏的专用服务器程序，用于快速部署和托管 Squad 游戏服务器。

> [Squad 游戏 Steam 商店页面](http://store.steampowered.com/app/393380/Squad/)

<img src="https://vignette.wikia.nocookie.net/squadgame/images/2/27/Squad_logo.png/revision/latest?cb=20150625185705" alt="Squad 标志" width="300"/>


## 核心功能与特性
- **自动更新**：容器启动时自动更新游戏服务器至最新版本，重启容器即可应用更新。
- **多实例支持**：通过调整端口参数（PORT、QUERYPORT、RCONPORT）可部署多个独立服务器实例。
- **数据持久化**：支持绑定挂载（bind mount）存储游戏数据，容器重建后数据不丢失。
- **环境变量配置**：通过环境变量灵活配置服务器端口、玩家数量、服务器名称等核心参数。
- **Mod 支持**：可通过环境变量指定 Workshop Mod ID，自动加载游戏模组。
- **资源优化**：支持通过 `--cpuset-cpus` 限制服务器使用特定 CPU 核心与线程，提升性能稳定性。


## 使用场景与适用范围
- **个人玩家**：快速搭建私人游戏服务器，与好友联机游玩。
- **社区管理员**：部署公共服务器，通过环境变量和配置文件定制服务器规则（如玩家数量、Mod 加载）。
- **需要自动更新的场景**：无需手动干预，重启容器即可完成游戏服务器更新。
- **多服务器部署**：通过调整端口参数，在同一主机上运行多个独立的 Squad 服务器实例。


## 使用方法与部署示例

### 快速部署简单游戏服务器
#### 使用 host 网络（推荐）
直接使用主机网络栈，减少网络转发开销：
```console
$ docker run -d --net=host -v /home/steam/squad-dedicated/ --name=squad-dedicated cm2network/squad
```

#### 绑定挂载实现数据持久化
通过绑定本地目录到容器，确保容器重建后游戏数据（如配置、Mod）不丢失：
```console
$ mkdir -p $(pwd)/squad-data  # 创建本地数据目录
$ chmod 777 $(pwd)/squad-data  # 确保容器非特权用户可写
$ docker run -d --net=host -v $(pwd)/squad-data:/home/steam/squad-dedicated/ --name=squad-dedicated cm2network/squad
```

#### 部署多个服务器实例
通过调整端口参数（PORT、QUERYPORT、RCONPORT）区分不同实例：
```console
$ docker run -d --net=host -v /home/steam/squad-dedicated/ \
  -e PORT=7788 -e QUERYPORT=27166 -e RCONPORT=21115 \
  --name=squad-dedicated2 cm2network/squad
```

### 注意事项
- **性能优化**：建议使用 `--cpuset-cpus=<核心ID>` 限制服务器使用特定 CPU 核心（如 `--cpuset-cpus=0,1`），避免资源竞争。
- **自动更新**：容器启动时会自动检查并更新游戏服务器，如需应用更新，重启容器即可。


### Docker Compose 部署示例
创建 `docker-compose.yml` 文件，定义服务配置：
```yaml
version: '3.9'

services:
  squad:
    image: cm2network/squad
    container_name: squad
    restart: unless-stopped  # 容器退出后自动重启（除非手动停止）
    network_mode: "host"     # 使用主机网络
    volumes:
      - /storage/squad/:/home/steam/squad-dedicated/  # 绑定本地目录持久化数据
    environment:
      - MULTIHOME=""  # 多IP主机时，指定服务器绑定的IP地址（如 "192.168.1.100"）
      - PORT=7787     # 游戏端口（默认7787）
      - QUERYPORT=27165  # 查询端口（默认27165）
      - BEACONPORT=15000  # 信标端口（默认15000）
      - RCONPORT=21114    # RCON管理端口（默认21114）
      - FIXEDMAXPLAYERS=100  # 最大玩家数量（默认80）
      - SERVER_NAME="Squad Dedicated Server"  # 服务器名称
```

启动服务：
```console
$ docker-compose up -d
```


## 配置说明

### 环境变量参数
通过 `-e`（或 `--env`）指定环境变量，自定义服务器配置。以下为核心参数说明：

| 环境变量          | 默认值              | 说明                                                                 |
|-------------------|---------------------|----------------------------------------------------------------------|
| `PORT`            | `7787`              | 游戏客户端连接端口（UDP）                                             |
| `QUERYPORT`       | `27165`             | 服务器状态查询端口（Steam Query，UDP）                                |
| `BEACONPORT`      | `15000`             | 信标端口（用于服务器列表广播，UDP）                                   |
| `RCONPORT`        | `21114`             | RCON管理端口（用于远程控制服务器，TCP）                               |
| `FIXEDMAXPLAYERS` | `80`                | 最大玩家数量（服务器支持的最大在线人数）                             |
| `FIXEDMAXTICKRATE`| `50`                | 服务器最大tick率（影响游戏更新频率，建议根据服务器性能调整）          |
| `RANDOM`          | `NONE`              | 随机种子（用于地图轮换等随机化场景）                                 |
| `MODS`            | `()`                | Workshop Mod ID列表，格式为 `(mod1id mod2id ...)`（如 `(13371337 12341234)`） |
| `SERVER_NAME`     | `"Squad Dedicated Server"` | 服务器名称（将显示在游戏服务器列表中）                           |
| `MULTIHOME`       | `""`                | 多IP主机时，指定服务器绑定的IP地址（如 `"192.168.1.100"`）            |


### 配置文件编辑
服务器详细配置（如地图轮换、管理员权限、游戏规则）需通过编辑配置文件实现。进入容器后修改 `Server.cfg`：
```console
$ docker exec -it squad-dedicated nano /home/steam/squad-dedicated/SquadGame/ServerConfig/Server.cfg
```
> 更多配置项参考 [Squad 服务器配置文档](https://squad.gamepedia.com/Server_Configuration)。


### 安装与加载 Mod
通过 `MODS` 环境变量指定 Workshop Mod ID，格式为空格分隔的 ID 列表（需包含在括号中）。例如，加载 ID 为 `13371337` 和 `12341234` 的 Mod：
```console
$ docker run -d --net=host -v $(pwd)/squad-data:/home/steam/squad-dedicated/ \
  -e MODS="(13371337 12341234)" \
  --name=squad-dedicated cm2network/squad
```
> Mod ID 可从 Steam Workshop  URL 获取（如 `https://steamcommunity.com/sharedfiles/filedetails/?id=13371337` 中的 `13371337`），或在本地 Workshop 目录（`<Steam安装目录>/steamapps/workshop/content/393380`）中查看文件夹名称（即 Mod ID）。


## 贡献者
[![Contributors Display](https://badges.pufler.dev/contributors/CM2Walki/Squad?size=50&padding=5&bots=false)](https://github.com/CM2Walki/Squad/graphs/contributors)
