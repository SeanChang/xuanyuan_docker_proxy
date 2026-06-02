---
image: qbittorrentofficial/qbittorrent-nox
description: "官方qbittorrent-nox Docker镜像是由qbittorrent开发团队官方维护的、针对无图形界面版本qbittorrent-nox的容器化部署包，旨在为用户提供安全可靠、易于跨平台部署的BT客户端运行环境，适用于服务器、云平台等需高效后台运行的场景，用户可通过Docker快速拉取并配置使用，无需复杂依赖管理，确保与官方版本同步更新及良好兼容性。"
source: https://xuanyuan.cloud/zh/r/qbittorrentofficial/qbittorrent-nox
canonical: https://xuanyuan.cloud/zh/r/qbittorrentofficial/qbittorrent-nox
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/qbittorrentofficial/qbittorrent-nox" title="qbittorrentofficial/qbittorrent-nox Docker 镜像中文简介、标签列表与拉取命令">qbittorrentofficial/qbittorrent-nox — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/qbittorrentofficial/qbittorrent-nox" title="qbittorrentofficial/qbittorrent-nox Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/qbittorrentofficial/qbittorrent-nox</a>

# qBittorrent-nox Docker镜像 [![GitHub Actions CI状态]([])]([])

Docker Hub仓库：[]  
GitHub仓库：[] 支持架构

* linux/386
* linux/amd64
* linux/arm/v6
* linux/arm/v7
* linux/arm64/v8
* linux/riscv64


## 问题反馈

若问题与Docker相关，请反馈至本仓库：  
[]  

若问题属于qBittorrent本身，请反馈至主仓库：  
[]  


## 使用方法

### 0. 前置条件

运行此镜像需先安装Docker：[]  

若无需图形界面，仅安装Docker Engine即可：[]  

建议同时安装Docker Compose，可简化操作流程：[]  


### 1. 下载仓库

可通过 `git clone` 克隆仓库，或下载ZIP压缩包：[]  


### 2. 编辑Docker环境文件

若使用Docker Stack，可参考 [docker-stack.yml]([]) 示例配置。该文件已基本可用，但需补充部分变量，具体配置逻辑与下文步骤一致。  

若不使用Docker Compose，可跳过编辑环境文件，但需理解下文变量含义，后续步骤需手动指定。  

找到并打开克隆（或下载）的仓库中的 `.env` 文件，以下变量需提前配置，具体含义见下方说明：  


#### 环境变量

* `QBT_LEGAL_NOTICE`  
  用于确认是否已阅读qBittorrent的法律声明。**仅在已阅读法律声明后，方可设为 `confirm`**。法律声明内容可查看 [此处]([])。  

* `QBT_VERSION`  
  指定qBittorrent-nox版本，例如 `4.4.5-1` 为有效取值。所有标签版本可查看 [此处]([])。设为 `latest` 可使用最新稳定版；设为 `alpha` 可获取每周开发版（测试用）。  

* `QBT_TORRENTING_PORT`  
  用于绑定BT下载流量的端口，未设置时默认 `6881`。  

* `QBT_WEBUI_PORT`  
  用于绑定WebUI的端口，未设置时默认 `8080`。  


#### 卷配置

需指定以下宿主机路径（**必须使用绝对路径，相对路径无效**）：  
* `<your_path>/config`：宿主机中用于存储qBittorrent配置文件的文件夹路径。  
* `<your_path>/downloads`：宿主机中用于存储下载文件的文件夹路径。  


### 3. 运行镜像

#### Docker方式（非Docker Compose）  
编辑变量后执行以下命令：  
```shell
export \
  QBT_LEGAL_NOTICE=<填写confirm> \
  QBT_VERSION=latest \
  QBT_TORRENTING_PORT=6881 \
  QBT_WEBUI_PORT=8080 \
  QBT_CONFIG_PATH="<宿主机配置文件夹绝对路径>" \
  QBT_DOWNLOADS_PATH="<宿主机下载文件夹绝对路径>"
docker run \
  -t \
  --name qbittorrent-nox \
  --read-only \
  --rm \
  --stop-timeout 1800 \
  --tmpfs /tmp \
  -e QBT_LEGAL_NOTICE \
  -e QBT_TORRENTING_PORT \
  -e QBT_WEBUI_PORT \
  -p "$QBT_TORRENTING_PORT":"$QBT_TORRENTING_PORT"/tcp \
  -p "$QBT_TORRENTING_PORT":"$QBT_TORRENTING_PORT"/udp \
  -p "$QBT_WEBUI_PORT":"$QBT_WEBUI_PORT"/tcp \
  -v "$QBT_CONFIG_PATH":/config \
  -v "$QBT_DOWNLOADS_PATH":/downloads \
  qbittorrentofficial/qbittorrent-nox:${QBT_VERSION}
```


#### Docker Compose方式  
直接执行：  
```shell
docker compose up
```


#### 注意事项

* 镜像路径也可使用 `ghcr.io/qbittorrent/docker-qbittorrent-nox:${QBT_VERSION}`。  
* 可在 `docker run ...` 命令末尾添加 `qbittorrent-nox` 的命令行参数；使用Docker Compose时，需修改 `docker-compose.yml` 中的 `command:` 数组。  
* 容器默认时区为Alpine Linux默认时区（通常为UTC），可通过环境变量 `TZ` 指定自定义时区（例如 `Asia/Shanghai`）。  
* 可通过环境变量 `PUID` 和 `PGID` 修改进程的用户ID和组ID（默认均为1000）。**注意**：修改时需移除 `--read-only` 标志（Docker方式）或设 `read_only: false`（Docker Compose方式），两者不兼容。  
* 可通过环境变量 `PAGID` 添加附加组ID，例如 `10000,10001` 表示加入两个次要组。使用时同样需关闭只读模式。  
* 可通过环境变量 `UMASK` 设置进程的umask值，默认使用Alpine Linux默认值。  
* 查看编译时软件物料清单（SBOM）：  
  ```shell
  docker run --entrypoint /bin/cat --rm qbittorrentofficial/qbittorrent-nox:latest /sbom.txt
  ```  


#### 访问WebUI  
启动后，通过 `http://<Docker主机IP>:8080` 访问WebUI：  
* qBittorrent版本 < 4.6.1：默认账号密码为 `admin/adminadmin`。  
* qBittorrent版本 ≥ 4.6.1：首次登录需使用临时密码，密码会打印到控制台（可通过 `docker logs qbittorrent-nox` 查看日志获取）。  
登录后建议立即修改密码：WebUI中依次点击 “工具” → “选项” → “Web UI” → “认证”。  


### 4. 停止容器

#### Docker方式（非Docker Compose）  
```shell
docker stop qbittorrent-nox
```

#### Docker Compose方式  
```shell
docker compose down
```


## 手动构建镜像

参考仓库中的 [manual_build]([]) 文件夹。


## 调试

如需使用gdb调试运行中的qbittorrent-nox进程，步骤如下：  

### 1. 启动容器前准备  
* 移除 `--read-only` 标志（或在docker-compose.yml中禁用只读模式），需在容器内安装额外依赖。  
* 添加 `--cap-add=SYS_PTRACE` 到 `docker run` 参数（或在docker-compose.yml中启用对应配置）。  


### 2. 启动容器  


### 3. 进入容器  
```shell
# 查看容器ID
docker ps
# 进入容器
docker exec -it <容器ID> /bin/sh
```


### 4. 安装调试工具  
```shell
apk add \
  gdb \
  musl-dbg
```


### 5. 附加gdb到进程  
```shell
# 查看qbittorrent-nox进程PID
ps -a
# 附加调试器
gdb -p <PID>
```
