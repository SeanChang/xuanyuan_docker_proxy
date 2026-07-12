---
image: jamesits/dst-server
description: "《饥荒：联机版》专用服务器镜像，用于搭建和运行该游戏的联机服务器。"
source: https://xuanyuan.cloud/zh/r/jamesits/dst-server
canonical: https://xuanyuan.cloud/zh/r/jamesits/dst-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jamesits/dst-server" title="jamesits/dst-server Docker 镜像中文简介、标签列表与拉取命令">jamesits/dst-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Don't Starve Together 专用服务器 Docker 镜像


## 镜像概述和主要用途

本 Docker 镜像旨在简化 Don't Starve Together (DST) 专用服务器的部署与管理流程。通过容器化方式，解决原生服务器设置复杂、配置繁琐的问题，提供便捷的部署、更新和维护体验，适用于需要快速搭建 DST 服务器的个人或团队。


## 核心功能和特性

### 镜像变体（标签）

镜像提供多种变体以满足不同需求，可通过 [Docker Hub](https://hub.docker.com/r/jamesits/dst-server/) 获取：

- **`latest`/`vanilla`**：更新频率较低，适合日常稳定使用  
- **`nightly`**：每日构建，包含最新服务器代码  
- **`steamcmd-rebase`**：基于 [`cm2network/steamcmd:root`](https://hub.docker.com/r/cm2network/steamcmd) 构建，功能与 `latest` 一致  

除 `nightly` 外，其他变体均提供 `-slim` 版本：  
- 不含预安装的 DST 服务器文件，每次启动容器时需下载必要文件  
- 无法离线启动  


### 构建方式

- `latest` 变体：通过 Docker Hub 自动构建  
- 其他变体（`nightly`、`steamcmd-rebase` 等）：通过 Azure DevOps CI 构建  


## 使用场景和适用范围

### 适用场景
- 搭建小规模 DST 私人服务器（如好友联机）  
- 需要简化服务器部署、更新流程的用户  
- 希望通过容器化隔离服务器环境的场景  

### 环境要求
- **网络**：需公网 IP 以支持互联网访问，需开放 4 个 UDP 端口（详见 FAQ）  
- **硬件**：  
  - CPU：1 核可满足小规模服务器需求（建议从 15 或 30  ticks 起步，不建议 60 ticks）  
  - 内存：建议预留 1GiB 基础内存，每活跃用户额外增加 60MiB  
  - 磁盘：镜像占用 1.5GiB，建议可用空间 ≥4GiB（含地图、配置和日志存储）  


## 详细使用方法和配置说明

### 前提条件
- 系统：Linux x86_64，安装 Docker 18.05.0-ce 及以上版本  
- 网络：公网 IP（如需互联网访问），开放 4 个 UDP 端口  
- 硬件：满足上述“环境要求”中的 CPU、内存和磁盘条件  


### 运行服务器

#### 启动服务器

**数据目录挂载**：服务器配置、地图和日志默认存储在宿主机 `${HOME}/.klei/DoNotStarveTogether` 目录，需将该目录挂载至容器内 `/data` 目录（若需自定义路径，替换 `${HOME}/.klei/DoNotStarveTogether` 为目标路径即可）。

**启动命令**：
```shell
docker run -v ${HOME}/.klei/DoNotStarveTogether:/data \
  -p 10999-11000:10999-11000/udp \
  -p 12346-12347:12346-12347/udp \
  -it docker.xuanyuan.run/jamesits/dst-server:latest
```

**Docker Compose**：可参考 [示例配置](https://github.com/Jamesits/docker-dst-server/blob/master/docker-compose.yml)。


#### 停止服务器

- 手动停止：在容器运行终端中按 `Ctrl+C`，等待服务器保存数据并正常关闭（避免连续按 `Ctrl+C` 强制终止，以防数据丢失）  
- 程序停止：向容器内 `supervisord` 进程发送 `SIGINT` 信号  

> **注意**：服务器可能需要最长 5 分钟时间保存地图并完全关闭。


### 服务器配置

#### 首次启动与集群令牌设置

1. **生成默认配置**：首次启动容器时，若数据目录无配置文件，镜像将自动生成默认配置，并提示：  
   ```
   Creating default server config...
   Please fill in `DoNotStarveTogether/Cluster_1/cluster_token.txt` with your cluster token and restart server!
   ```

2. **获取集群令牌**：  
   - 打开 DST 客户端并登录  
   - 点击“开始游戏”进入主菜单，左下角点击“账户”  
   - 在弹出的浏览器中，顶部导航栏选择“GAMES”，点击右上角“Don't Starve Together Servers”  
   - 下滑至“ADD NEW SERVER”，填写服务器名称（可不重要），复制生成的令牌（格式如 `pds-g^aaaaaaaaa-q^jaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=`）  

3. **设置令牌**：  
   - 方法 1：启动容器时通过环境变量传入：`-e DST_CLUSTER_TOKEN="你的令牌"`  
   - 方法 2：将令牌粘贴至宿主机数据目录下的 `DoNotStarveTogether/Cluster_1/cluster_token.txt` 文件  


#### 高级配置（Mods、世界生成等）

- **Mods 设置**：编辑数据目录下的 `DoNotStarveTogether/Cluster_1/Master/modoverrides.lua`，添加 `workshop-XXXXX`（XXXXX 为 Mod ID），并在 `DoNotStarveTogether/Cluster_1/mods/dedicated_server_mods_setup.lua` 中添加 `ServerModSetup("XXXXX")`  
- **世界配置**：修改 `DoNotStarveTogether/Cluster_1/cluster.ini` 设置服务器名称、游戏模式等  
- **关闭洞穴**：需修改容器内 `supervisor.conf` 以禁用洞穴服务器  


### 本地构建镜像

（通常无需本地构建，直接拉取 Docker Hub 预构建镜像即可。）

#### 构建步骤
```shell
git clone https://github.com/Jamesits/docker-dst-server.git docker-dst-server
cd docker-dst-server
docker build . -t dst-server:latest
```

#### 构建参数（通过 `--build-arg` 设置）
- `BASE_IMAGE`：基础镜像（支持 Debian 或 Ubuntu 系镜像）  
- `STEAMCMD_PATH`：`steamcmd.sh` 在基础镜像中的路径  
- `DST_DOWNLOAD`：设为 `1` 则将 DST 服务器文件嵌入镜像  
- `DST_USER`/`DST_GROUP`：容器内运行服务器的用户/组  


## 已知问题

- **UDP 端口转发不支持**：部分 Docker 环境不支持 UDP 端口转发时，局域网服务器无法使用（可启用 Steam 穿透，在“在线”列表中搜索服务器）  
- **IPv6 支持**：当前不支持 IPv6，相关问题可参考 [Issue #7](https://github.com/Jamesits/docker-dst-server/issues/7)  


## 常见问题（FAQ）

### 如何更新服务器或 Mods？
重启容器，服务器将自动下载更新。


### 如何连接局域网服务器？
在客户端控制台执行 `c_connect("IP地址", 端口)` 或 `c_connect("IP地址", 端口, "密码")`。


### 如何检查服务器是否在线？
可使用第三方网站 [Don't Starve Together Server List](https://dstserverlist.appspot.com) 查询。


### 服务器需要哪些端口？
需开放以下 UDP 端口：  
- 10999（主服务器）、11000（洞穴服务器）：客户端连接  
- 12346、12347：Steam 连接  

> 注意：请勿将这些端口 NAT 映射到其他端口号。


### 错误：App '343050' state is 0x202 after update job？
磁盘空间不足，需清理空间。


### 错误：App '343050' state is 0x602 after update job？
通常是文件系统权限问题，导致 steamcmd 无法写入游戏安装目录。


### 客户端延迟高或卡顿？
可能原因：  
- 网络丢包率高  
- 服务器 tick 率过高（如 60 ticks），低性能客户端（如笔记本）难以适应  


### 如何将本地存档复制到服务器？
本地存档路径：`<用户文档>\Klei\DoNotStarveTogether\<随机数字>`  
- **含洞穴存档**：直接复制 `Cluster_X` 目录至服务器数据目录，并重命名为 `Cluster_1`  
- **不含洞穴存档**：复制 `client_save` 中除 `session` 和 `Cluster_X/save/session` 的内容至服务器 `Cluster_1/save`；若本地存档非第 1 槽位，需修改 `saveindex` 为 1（服务器仅识别第 1 槽位）  


## 维护者

- [James Swineson](https://swineson.me)  


## 致谢

- [Mingye Wang](https://github.com/Arthur2e5)  
- [@MephistoMMM](https://github.com/MephistoMMM)  
- [@m13253](https://github.com/m13253)  
- [@wph95](https://github.com/wph95)  
- [DaoCloud](https://daocloud.io)  
- [CodeVS](http://codevs.cn/)  
- [I Choose Death Too](https://steamcommunity.com/id/ichoosedeathtoo/)  


## 许可证

```
Don't Starve Together Dedicated Server Docker Image
Copyright (C) 2015-2018 James Swineson (Jamesits) and Mingye Wang (Arthur2e5)

本程序为自由软件；您可依据 GNU 通用公共许可证（GPL）第 2 版或（可选）更高版本的条款，重新分发和/或修改本程序。
本程序的发布旨在希望它能有用，但不提供任何明示或暗示的担保，包括但不限于对适销性或特定用途适用性的担保。详情见 GNU 通用公共许可证。

您应已收到一份 GNU 通用公共许可证的副本；若未收到，请查阅 <http://www.gnu.org/licenses/>。
```


## 参考资料

- [Linux 环境下搭建带洞穴的专用服务器](https://steamcommunity.com/sharedfiles/filedetails/?id=590565473)  
- [专用服务器 Mod 安装、配置与更新指南](https://steamcommunity.com/sharedfiles/filedetails/?id=591543858)  
- [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)
