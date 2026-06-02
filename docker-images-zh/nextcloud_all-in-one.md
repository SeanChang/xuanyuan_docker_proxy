<!-- xuanyuan-docker-images-zh
image: nextcloud/all-in-one
source: https://xuanyuan.cloud/zh/r/nextcloud/all-in-one
canonical: https://xuanyuan.cloud/zh/r/nextcloud/all-in-one
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [nextcloud/all-in-one — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/nextcloud/all-in-one "nextcloud/all-in-one Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/nextcloud/all-in-one

# Nextcloud All-in-One


## 介绍  
Nextcloud All-in-One（AIO）是官方推荐的Nextcloud安装方式，提供一站式部署与维护方案，集成了Nextcloud核心及多数扩展功能，无需复杂配置即可快速搭建完整实例。


## 包含组件  
- Nextcloud 核心功能  
- Nextcloud Files 高性能后端  
- Nextcloud Office（可选）  
- Nextcloud Talk 高性能后端及TURN服务器（可选）  
- Nextcloud Talk 录制服务器（可选）  
- 备份方案（可选，基于 [BorgBackup]([])）  
- Imaginary（可选，用于预览heic、heif、illustrator、pdf、svg、tiff和webp格式文件）  
- ClamAV（可选，Nextcloud防病毒后端）  
- 全文搜索（可选）  
- 白板功能（可选）  
- Docker Socket Proxy（可选，用于 [Nextcloud App API]([])）  
- [社区容器]([])  


## 截图  
| 首次设置界面 | 安装后界面 |  
|---|---|  
| ![image]([]) | ![image]([]) |  


## 使用方法  

### 适用场景  
以下步骤适用于**无前置Web服务器/反向代理（如Apache、Nginx等）** 的Linux环境。若需在Web服务器/反向代理后运行AIO，详见 [反向代理文档]([])。其他系统参考：macOS 见 [此文档](#how-to-run-aio-on-macos)、Windows 见 [此文档](#how-to-run-aio-on-windows)、Synology 见 [此文档](#how-to-run-aio-on-synology-dsm)。  


### 安装步骤  

#### 1. 安装Docker  
通过Docker官方文档安装Docker引擎：[]  
```sh  
curl -fsSL [] | sudo sh  
```  


#### 2. （可选）启用IPv6支持  
如需IPv6，按 [此文档]([]) 配置。  


#### 3. 启动容器  
在Linux环境且无前置Web服务器/反向代理时，运行以下命令启动AIO主容器：  
```sh  
sudo docker run \  
--sig-proxy=false \  
--name nextcloud-aio-mastercontainer \  
--restart always \  
--publish 80:80 \  
--publish 8080:8080 \  
--publish 8443:8443 \  
--volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \  
--volume /var/run/docker.sock:/var/run/docker.sock:ro \  
nextcloud/all-in-one:latest  
```  

> **注意**：默认数据存储在Docker卷中，如需自定义数据目录位置，参考 [调整数据目录文档]([])。  


#### 4. 访问管理界面  
容器启动后，通过服务器IP的8080端口访问AIO管理界面：  
`[]]:8080`  

若已将域名指向服务器并开放80/8443端口，可通过域名访问以自动获取SSL证书：  
`[]]:8443`  


#### 5. 开放Talk端口  
如需使用Nextcloud Talk，需在防火墙/路由器中开放端口 `3478/TCP` 和 `3478/UDP`。  


## FAQ  
详见 [官方FAQ]([])
