<!-- xuanyuan-docker-images-zh
image: outlovecn/portainer-cn
source: https://xuanyuan.cloud/zh/r/outlovecn/portainer-cn
canonical: https://xuanyuan.cloud/zh/r/outlovecn/portainer-cn
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [outlovecn/portainer-cn — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/outlovecn/portainer-cn "outlovecn/portainer-cn Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/outlovecn/portainer-cn

# Portainer 中文镜像部署指南  


Portainer 是一款轻量级的 Docker 管理工具，支持可视化管理容器、镜像、网络等资源。以下介绍基于 `outlovecn/portainer-cn` 中文镜像的三种常用操作方式，可根据实际需求选择。


## 一、通过 docker-compose 部署  
适合习惯使用 docker-compose 管理服务的场景，配置文件可复用，便于维护。  


### 操作步骤：  
1. 创建 `docker-compose.yml` 文件，复制以下内容：  
```yaml
version: "2.1"
services:
  portainer:
    image: outlovecn/portainer-cn:latest  # 使用中文镜像
    container_name: portainer  # 容器名称
    restart: always  # 容器退出后自动重启
    ports:
      - "9000:9000"  # Web 管理界面端口（宿主机:容器）
      - "8000:8000"  # 节点通信端口（用于 Swarm 集群，单节点可保留默认）
    volumes:
      - ./dockerconfig/portainer:/data  # 持久化 Portainer 数据（当前目录下的 dockerconfig/portainer 文件夹）
      - /var/run/docker.sock:/var/run/docker.sock  # 挂载 Docker 守护进程套接字，让 Portainer 能管理宿主机 Docker
```  

2. 在 `docker-compose.yml` 文件所在目录，执行以下命令启动服务：  
```bash
docker-compose up -d
```  

服务启动后，访问 `[] 即可打开 Portainer 中文管理界面。


## 二、通过 docker cli 直接部署  
适合快速启动单个容器，无需编写配置文件，直接通过命令行操作。  


### 操作命令：  
执行以下命令，直接启动 Portainer 容器：  
```bash
docker run -d \
  -p 8000:8000 \  # 节点通信端口映射
  -p 9000:9000 \  # Web 管理界面端口映射
  --name=portainer \  # 容器名称
  --restart=always \  # 容器退出后自动重启
  -v /var/run/docker.sock:/var/run/docker.sock \  # 挂载 Docker 套接字，用于管理宿主机 Docker
  -v portainer_data:/data \  # 使用命名卷持久化数据（自动创建名为 portainer_data 的卷）
  outlovecn/portainer-cn:latest  # 中文镜像
```  

命令说明：  
- `-d`：后台运行容器；  
- `-p`：端口映射，格式为 `宿主机端口:容器端口`；  
- `--name`：指定容器名称，便于后续管理；  
- `--restart=always`：确保容器在宿主机重启或意外停止后自动恢复；  
- `-v`：数据卷挂载，`/var/run/docker.sock` 让 Portainer 能控制宿主机 Docker，`portainer_data:/data` 持久化 Portainer 配置和数据。  


## 三、仅拉取镜像到本地  
若只需将镜像下载到本地（暂不启动容器），可执行以下命令：  


### 操作命令：  
```bash
docker pull outlovecn/portainer-cn
```  

拉取完成后，可通过 `docker images` 查看本地镜像，后续需要时可手动通过 `docker run` 命令启动容器（参考「通过 docker cli 直接部署」中的参数）。
