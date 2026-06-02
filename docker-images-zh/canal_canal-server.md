<!-- xuanyuan-docker-images-zh
image: canal/canal-server
source: https://xuanyuan.cloud/zh/r/canal/canal-server
canonical: https://xuanyuan.cloud/zh/r/canal/canal-server
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [canal/canal-server — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/canal/canal-server "canal/canal-server Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/canal/canal-server

# Canal服务容器构建说明  


## 基础镜像选择  
容器基于 `canal/osbase:v3` 基础镜像构建，支持两种架构：  
- `amd64` 架构：使用 `canal/osbase:v3-amd64`  
- `arm64` 架构：使用 `canal/osbase:v3-arm64`  


## 基础信息标注  
通过 `LABEL` 指定容器维护者信息：  
- 维护者：agapple  
- 联系邮箱：[邮箱已删除]  


## 文件复制与准备  
构建前需准备以下文件，并通过 `COPY` 指令复制到容器内：  
1. 本地 `image/` 目录下的文件：复制到容器 `/tmp/docker/` 路径，用于后续配置与脚本部署。  
2. `canal.deployer-*.tar.gz` 安装包：复制到容器 `/home/admin/` 路径，作为 Canal 服务的部署包。  


## 环境配置与服务部署  
通过 `RUN` 指令完成容器内环境配置、服务部署及权限调整，具体步骤如下：  

### 1. 基础配置与工具准备  
- 复制 `/tmp/docker/alidata` 目录到容器根路径 `/alidata`，并为 `/alidata/bin/` 下所有文件添加执行权限（确保脚本可运行）。  
- 创建 `/home/admin` 目录，复制 `/tmp/docker/app.sh` 脚本及 `/tmp/docker/admin/` 目录下的文件到该路径（存放服务启动及管理脚本）。  
- 将 `/alidata/bin/lark-wait` 工具复制到 `/usr/bin/`（系统级工具，用于服务依赖等待）。  

### 2. Canal 服务部署  
- 创建 `/home/admin/canal-server` 目录，将 `/home/admin/` 下的 `canal.deployer-*.tar.gz` 解压到该目录（部署 Canal 服务核心文件）。  
- 解压完成后删除安装包，清理冗余文件。  

### 3. 监控工具部署  
- 解压 `/tmp/node_exporter.tar.gz` 到 `/home/admin/`，并创建软链接 `/home/admin/node_exporter` 指向解压后的 `node_exporter-1.6.1*` 目录（部署节点监控工具 node_exporter）。  

### 4. 权限与环境清理  
- 创建 `/home/admin/canal-server/logs` 目录（存放 Canal 服务日志）。  
- 为 `/home/admin/` 下所有 `.sh` 脚本及 `/home/admin/bin/` 下的脚本添加执行权限（确保启动脚本可运行）。  
- 将 `/home/admin` 目录及子文件的所有者改为 `admin` 用户（遵循最小权限原则）。  
- 清理 yum 缓存，减少镜像体积。  


## 网络端口说明  
容器暴露以下端口，用于服务访问与监控：  
- `11110`：admin 端口（管理接口）  
- `11111`：canal 端口（Canal 服务主端口）  
- `11112`：metrics 端口（服务指标采集接口）  
- `9100`：node_exporter 端口（节点监控数据接口）  


## 容器运行配置  
- **工作目录**：容器启动后默认进入 `/home/admin` 路径。  
- **启动流程**：  
  - 入口脚本为 `/alidata/bin/main.sh`（通过 `ENTRYPOINT` 指定，固定执行）。  
  - 启动命令为 `/home/admin/app.sh`（通过 `CMD` 指定，作为主脚本运行，可在启动容器时覆盖）。
