---
image: gz1903/roonserver
description: "用于运行RoonServer的Docker镜像，首次运行时会自动下载RoonServer，支持在任何设备上以最高音质播放音频，集成Qobuz、Tidal等多种音频服务，支持外部存储卷和网络共享，适用于构建家庭高品质音频系统。"
source: https://xuanyuan.cloud/zh/r/gz1903/roonserver
canonical: https://xuanyuan.cloud/zh/r/gz1903/roonserver
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gz1903/roonserver" title="gz1903/roonserver Docker 镜像中文简介、标签列表与拉取命令">gz1903/roonserver — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/gz1903/roonserver" title="gz1903/roonserver Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/gz1903/roonserver</a>

# RoonServer Docker镜像

## 镜像概述

此Docker镜像用于运行RoonServer，首次运行时会自动下载RoonServer（若外部卷中未找到）。基于Debian 13.2环境构建，集成了最新版Roon及ffmpeg、alsa-utils等必要组件，支持多种音频服务和网络存储，为家庭音频系统提供高品质播放解决方案。

官方文档：[https://roon.app](https://roon.app)  
更新日志：[https://community.roonlabs.com/c/roon/software-release-notes/18](https://community.roonlabs.com/c/roon/software-release-notes/18)

## 核心功能与特性

### 支持的服务
- Qobuz、KKBOX、Tidal、Dropbox等音频和存储服务

### 环境版本
| 环境         | 版本       |
|--------------|------------|
| Debian       | 13.2       |
| Roon         | latest     |
| libicu76     | 76.1-4     |
| cifs-utils   | 7.4-1      |
| ffmpeg       | 8.1        |
| alsa-utils   | 1.2.14-1   |

### 主要特性
- 首次运行自动下载RoonServer，支持外部卷持久化存储
- 支持时区设置（通过TZ环境变量）
- 支持网络共享（SMB/CIFS）访问
- 兼容Docker、Docker Compose和systemd服务管理
- 提供多种网络配置方案，解决音频设备发现问题

## 使用场景
- 家庭音频系统：在Docker环境中部署RoonServer，构建高品质家庭音乐中心
- 多设备音频播放：通过网络将音频流传输到多个终端设备
- 音乐库管理：集中管理音乐文件，支持备份和共享

## 使用方法

### 基本启动命令

```shell
docker run -d \
--name=roonserver \
--restart always \
--net=host \
--privileged \
-e TZ="Asia/Shanghai" \
-v roon-app:/app \
-v roon-data:/data \
-v roon-music:/music \
-v roon-backups:/backup \
gz1903/roonserver:latest
```

**参数说明**：
- `--net=host`：使用主机网络模式，确保音频设备发现正常
- `--privileged`：特权模式，解决网络共享访问问题
- `-e TZ`：设置时区（如"Asia/Shanghai"）
- 卷挂载：
  - `/app`：RoonServer应用目录
  - `/data`：配置数据目录
  - `/music`：音乐文件存储目录
  - `/backup`：备份目录
- **注意**：`/app`和`/data`必须使用不同的卷或路径，否则应用无法启动

### Docker Compose配置

创建`docker-compose.yaml`文件：

```yaml
version: "3.7"
services:
  roon:
    image: gz1903/roonserver:latest
    container_name: roonserver
    network_mode: host
    privileged: true
    environment:
      TZ: "Asia/Shanghai"
    volumes:
      - roon-app:/app
      - roon-data:/data
      - roon-music:/music
      - roon-backups:/backup
    restart: always
volumes:
  roon-app:
  roon-data:
  roon-music:
  roon-backups:
```

启动服务：`docker-compose up -d`

### Systemd服务配置

在支持systemd的系统上，创建服务文件（如`/etc/systemd/system/roonserver.service`）：

```ini
[Unit]
Description=RoonServer Docker Service
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
TimeoutStopSec=180
ExecStartPre=-/usr/bin/docker kill %n
ExecStartPre=-/usr/bin/docker rm -f %n
ExecStartPre=/usr/bin/docker pull gz1903/roonserver:latest
ExecStart=/usr/bin/docker \
  run --name %n \
  --net=host \
  -e TZ="Asia/Shanghai" \
  -v roon-app:/app \
  -v roon-data:/data \
  -v roon-music:/music \
  -v roon-backups:/backup \
  gz1903/roonserver:latest
ExecStop=/usr/bin/docker stop %n
Restart=always
RestartSec=10s

[Install]
WantedBy=multi-user.target
```

启用并启动服务：
```shell
systemctl daemon-reload
systemctl enable --now roonserver.service
```

### 网络共享配置

若需访问远程SMB/CIFS共享，可通过以下两种方式配置：

#### 方法一：特权模式（推荐）
在启动命令或Compose配置中添加`--privileged`参数：
```shell
# 独立运行
docker run --privileged --name roonserver ...

# Docker Compose（服务配置中）
privileged: true
```

#### 方法二：添加必要权限
通过`cap-add`和安全选项配置：
```shell
# 独立运行
docker run --cap-add SYS_ADMIN --cap-add DAC_READ_SEARCH --security-opt apparmor:unconfined ...

# Docker Compose（服务配置中）
cap_add:
  - SYS_ADMIN
  - DAC_READ_SEARCH
security_opt:
  - apparmor:unconfined
```

### 网络问题解决

若主机存在多网络接口，导致核心难以发现音频设备，可创建macvlan网络：

```shell
docker network create -d macvlan \
   --subnet 192.168.1.0/24 --gateway 192.168.1.1 \
   --ip-range 192.168.1.240/28 -o parent=enp4s0 roon-lan

# 使用新网络启动容器
docker run --network roon-lan --name roonserver ...
```

**说明**：需根据实际网络环境调整`--subnet`、`--gateway`、`--ip-range`和`parent`（物理网卡）参数。

## 配置参数

### 环境变量
| 变量 | 说明 | 示例 |
|------|------|------|
| TZ | 时区设置 | "Asia/Shanghai" |

### 卷挂载
| 容器路径 | 用途 |
|----------|------|
| /app | RoonServer应用程序目录 |
| /data | 配置和运行时数据目录 |
| /music | 音乐库存储目录 |
| /backup | 备份文件存储目录 |

## 提示

首次运行时，镜像会自动下载RoonServer，可能需要几分钟时间。建议在首次启动后等待下载完成再进行配置。音乐库路径建议设置为`/music`，备份路径设置为`/backup`以匹配卷挂载配置。

享受音乐吧！🎧  

> 若您热爱音乐，您会希望它听起来尽可能宏大、逼真。Roon的音频引擎专为高保真标准设计，在保持易用性的同时提供最佳性能。
