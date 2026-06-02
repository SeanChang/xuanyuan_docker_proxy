---
image: xubiaolin/zerotier-planet
description: "这是一个用于部署ZeroTier Planet根服务器的Docker镜像，可帮助用户快速搭建私有虚拟网络的核心节点，无需复杂配置即可简化跨设备、跨网络的安全连接部署流程，支持自定义网络参数，适用于企业或个人构建稳定、可控的私有网络环境，项目托管于GitHub，地址为[]"
source: https://xuanyuan.cloud/zh/r/xubiaolin/zerotier-planet
canonical: https://xuanyuan.cloud/zh/r/xubiaolin/zerotier-planet
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/xubiaolin/zerotier-planet" title="xubiaolin/zerotier-planet Docker 镜像中文简介、标签列表与拉取命令">xubiaolin/zerotier-planet — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/xubiaolin/zerotier-planet" title="xubiaolin/zerotier-planet Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/xubiaolin/zerotier-planet</a>

## ZeroTier Planet Docker镜像介绍  


### 什么是ZeroTier Planet？  
ZeroTier是一款常用的虚拟局域网（VLAN）工具，支持多设备跨网络互联互通。而“Planet”是ZeroTier网络中的核心根服务器，负责节点发现、身份验证和连接中继。官方Planet服务器可能受地域或网络限制，自建Planet可提升连接稳定性，适合需要私有、可控虚拟网络的场景（如家庭设备互联、小型办公组网等）。  


### 这个Docker镜像能做什么？  
[xubiaolin/docker-zerotier-planet]([]) 是一个打包好的Docker镜像，帮你快速部署自己的ZeroTier Planet服务器。无需手动编译源码或配置复杂依赖，通过Docker容器即可一键启动，省去环境配置麻烦。  


### 核心功能  
- **部署简单**：基于Docker封装，无需手动安装依赖（如ZeroTier源码、编译工具等），一条命令即可启动服务。  
- **环境隔离**：容器化运行，不干扰主机系统环境，配置和数据独立管理。  
- **灵活配置**：支持自定义Planet名称、端口映射、数据持久化，适配不同网络需求。  
- **跨平台兼容**：只要主机支持Docker（Linux、Windows、macOS均可），就能部署。  


### 怎么用这个镜像？  
以下是基本使用步骤，详细配置可参考 [GitHub仓库文档]([])。  


#### 1. 准备环境  
先确保主机已安装 **Docker** 和 **Docker Compose**（推荐用Docker Compose管理容器，更方便）。  
- 安装Docker：参考 [Docker官方文档]([])  
- 安装Docker Compose：参考 [Docker Compose文档]([])  


#### 2. 获取镜像  
两种方式获取镜像：  
- **直接拉取**：从Docker Hub拉取（推荐，无需本地构建）：  
  ```bash
  docker pull :latest
  ```  
- **本地构建**：若需修改源码或定制配置，可克隆GitHub仓库后本地构建：  
  ```bash
  git clone []  cd docker-zerotier-planet
  docker build -t :custom .  # "custom"为自定义标签
  ```  


#### 3. 配置并启动容器  
推荐用 `docker-compose.yml` 管理容器（比纯Docker命令更易维护）。  

1. 在主机创建一个目录（如 `~/zerotier-planet`），用于存放配置和数据。  
2. 新建 `docker-compose.yml` 文件，参考以下示例（具体参数可调整）：  
   ```yaml
   version: '3'
   services:
     zerotier-planet:
       image: :latest
       container_name: zerotier-planet
       restart: always  # 容器意外退出后自动重启
       ports:
         - "9993:9993/udp"  # ZeroTier默认通信端口（必须开放UDP）
         - "9993:9993/tcp"  # 可选，用于HTTP API（若需管理界面）
       volumes:
         - ./data:/app/data  # 数据持久化（保存Planet配置、节点信息等）
       environment:
         - PLANET_NAME=MyPrivatePlanet  # 自定义Planet名称（可选）
         - TZ=Asia/Shanghai  # 时区设置（可选）
   ```  
3. 启动容器：  
   ```bash
   cd ~/zerotier-planet  # 进入配置文件所在目录
   docker-compose up -d  # 后台启动容器
   ```  


#### 4. 验证服务是否正常  
- 检查容器状态：  
  ```bash
  docker ps | grep zerotier-planet  # 若状态为"Up"，说明启动成功
  ```  
- 查看日志（排查问题用）：  
  ```bash
  docker logs -f zerotier-planet
  ```  
- 测试连接：用ZeroTier客户端添加自建Planet（需配置客户端的 `planet` 文件指向你的服务器IP和端口），具体方法见GitHub仓库说明。  


### 注意事项  
- **端口开放**：确保主机防火墙开放UDP 9993端口（ZeroTier核心通信端口），云服务器还需在安全组中放行该端口。  
- **数据备份**：`./data` 目录存放Planet的核心配置和节点数据，定期备份避免丢失。  
- **更新镜像**：若需升级，先停止旧容器，拉取新版本镜像后重启：  
  ```bash
  docker-compose down  # 停止旧容器
  docker pull :latest  # 拉取新版本
  docker-compose up -d  # 启动新容器
  ```  


### 更多信息  
完整配置说明、问题排查、客户端接入教程，可参考项目GitHub地址：  
👉 [xubiaolin/docker-zerotier-planet]([])
