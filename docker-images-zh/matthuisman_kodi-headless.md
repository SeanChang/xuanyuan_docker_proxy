---
image: matthuisman/kodi-headless
description: "Docker容器中的无头Kodi媒体中心，适用于无图形界面环境运行媒体中心功能。"
source: https://xuanyuan.cloud/zh/r/matthuisman/kodi-headless
canonical: https://xuanyuan.cloud/zh/r/matthuisman/kodi-headless
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/matthuisman/kodi-headless" title="matthuisman/kodi-headless Docker 镜像中文简介、标签列表与拉取命令">matthuisman/kodi-headless 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# matthuisman/kodi-headless

## 镜像概述和主要用途
matthuisman/kodi-headless 是一个在 Docker 容器中运行的无头(headless) Kodi 安装。主要用于配合 MySQL Kodi 环境，通过 Web 界面实现媒体库更新等功能。

## 核心功能和特性
- 无头运行模式，无需图形界面
- 支持 MySQL 数据库集成，实现多设备媒体库同步
- 提供 Web 界面和 WebSocket 访问
- 自动启用配置目录中的插件
- 支持媒体库更新、清理等管理任务
- 跨平台架构支持，自动适配硬件环境

## 使用场景和适用范围
- 家庭媒体服务器环境，需要集中管理 Kodi 媒体库
- 多设备 Kodi 客户端共享媒体库的场景
- 需要远程更新或维护 Kodi 媒体库的应用
- 自动化媒体库管理流程（如定时扫描、清理）

## 使用方法和配置说明

### 基础部署（Docker Run）
```bash
docker run -d \
--name=kodi-headless \
--restart unless-stopped \
-v <数据路径>:/config/.kodi \
-e PUID=<用户ID> \
-e PGID=<组ID> \
-e TZ=<时区> \
-p 8080:8080 \
-p 9090:9090 \
-p 9777:9777/udp \
docker.xuanyuan.run/matthuisman/kodi-headless:Matrix
```

### 参数说明
| 参数                | 说明                                                                 |
|---------------------|----------------------------------------------------------------------|
| `-p 8080:8080`      | Web 界面端口                                                         |
| `-p 9090:9090`      | WebSocket 端口                                                       |
| `-p 9777:9777/udp`  | ESAll 接口端口（UDP）                                                |
| `-v /config/.kodi`  | Kodi 配置文件存储路径，需映射至宿主机目录                            |
| `-e PUID`           | 用户 ID，用于解决权限问题（见下文用户/组标识符说明）                  |
| `-e PGID`           | 组 ID，用于解决权限问题（见下文用户/组标识符说明）                    |
| `-e TZ`             | 时区设置，例如：Europe/London、Asia/Shanghai 等                      |

### Docker Compose 部署
提供包含 SQL 数据库和 Kodi 集成的示例配置文件：  
[docker-compose.yml](https://github.com/matthuisman/docker-kodi-headless/blob/master/docker-compose.yml)

## 标签与平台支持

### 版本标签
- Leia
- Matrix
- Nexus
- Omega

### 支持平台
- x86_64 / amd64
- armv7
- armv8 / arm64

Docker 会自动拉取与当前平台匹配的镜像版本。

## 插件安装

### 方法一：手动复制插件
1. 将插件文件复制到配置目录下的 `addons` 文件夹中
2. 重启 Docker 容器，插件将自动启用

### 方法二：命令行安装
通过容器命令安装插件及其依赖（需已启用插件仓库）：
```bash
docker exec kodi-headless install_addon "<插件ID>" "<插件ID>" "<插件ID>"
```

示例：
```bash
docker exec kodi-headless install_addon "metadata.tvshows.thetvdb.com.v4.python" "another.addon.id"
```

## Python 版本对应关系
| Kodi 版本标签 | Python 版本   |
|---------------|---------------|
| Leia          | 2.7.17        |
| Matrix        | 3.6.5         |
| Nexus         | 3.10.4        |
| Omega         | 3.10.4        |

## 用户与组标识符
使用数据卷（`-v` 参数）时，主机与容器可能出现权限冲突。通过指定 `PUID`（用户 ID）和 `PGID`（组 ID）可避免此问题。确保主机数据卷目录的所有者与指定的 UID/GID 一致。

获取当前用户的 UID/GID：
```bash
id <用户名>
```
示例输出：
```
uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## 应用配置
### MySQL 数据库设置
SQL 配置需通过 `advancedsettings.xml` 文件完成，该文件位于 `/config/.kodi/userdata/` 目录下。其他高级设置也可在此文件中配置。

### 媒体源配置
若需使用此 Kodi 实例执行媒体库清理等操作，必须将初始媒体库扫描主机的 `sources.xml` 文件复制到当前实例的 `userdata` 目录下，否则可能导致数据库丢失。

## 容器管理
- 容器运行时 Shell 访问：
  ```bash
  docker exec -it kodi-headless /bin/bash
  ```

- 实时监控容器日志：
  ```bash
  docker logs -f kodi-headless
  ```

## 快速扫描配置
当媒体文件与容器在同一主机，且通过 SMB 共享时，可通过以下配置提升扫描速度：

1. 将主机媒体目录挂载到容器内：
   ```bash
   --mount type=bind,source=/sharedfolders/pool,target=/media
   ```

2. 在 `advancedsettings.xml` 中配置路径替换：
   ```xml
   <pathsubstitution>
     <substitute>
       <from>smb://192.168.20.3/sharedfolders/pool/</from>
       <to>/media/</to>
     </substitute>
   </pathsubstitution>
   ```

配置后，Kodi 将通过本地路径 `/media` 扫描媒体，而非通过 SMB 网络，同时数据库中仍保留 SMB 路径记录。

## 已知问题
若遇到以下错误：`unable to iopause`、`what(): Operation not permitted`、`/usr/lib/kodi/kodi-x11 not found`，请参考：  
[https://github.com/sdr-enthusiasts/Buster-Docker-Fixes#the-situation](https://github.com/sdr-enthusiasts/Buster-Docker-Fixes#the-situation)

## 致谢
- [linuxserver](https://github.com/linuxserver/docker-kodi-headless/)（原始无头容器）

## 支持信息
[https://matthuisman.nz/support-me](https://matthuisman.nz/support-me)
