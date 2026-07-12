---
image: anujdatar/cups
description: "通用UNIX打印系统（CUPS）服务器运行在Docker容器中，该容器化部署方式借助Docker的轻量级虚拟化技术，实现了打印服务的隔离运行、快速部署与跨环境移植，可高效管理网络打印任务、处理打印请求及协调打印机资源，为用户提供稳定且灵活的打印服务支持。"
source: https://xuanyuan.cloud/zh/r/anujdatar/cups
canonical: https://xuanyuan.cloud/zh/r/anujdatar/cups
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/anujdatar/cups" title="anujdatar/cups Docker 镜像中文简介、标签列表与拉取命令">anujdatar/cups 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CUPS-docker  
[GitHub地址]   


## 简介  
这是一个可在远程设备上运行的CUPS打印服务器Docker方案，用于通过WiFi共享USB打印机。主要设计用于树莓派作为无头服务器（无显示器的设备），但也支持amd64架构设备。已在树莓派3B+（arm/v7）和树莓派4（arm64/v8）上测试通过，可正常工作。  


## 容器镜像来源  
可从以下平台获取容器镜像：  
- Docker Hub镜像：`anujdatar/cups`  
- GHCR镜像：`ghcr.io/anujdatar/cups`  


## 部署与使用  


### 快速启动（默认参数）  
使用默认配置快速启动容器：  
```sh
docker run -d -p 631:631 --device /dev/bus/usb --name cups docker.xuanyuan.run/anujdatar/cups
```  


### 自定义容器配置  
根据需求调整参数，示例命令如下：  
```sh
docker run -d --name cups \
    --restart unless-stopped \  # 重启策略：除非手动停止
    -p 631:631 \                # 映射CUPS默认端口
    --device /dev/bus/usb \     # 授予容器USB设备访问权限
    -e CUPSADMIN=batman \       # 自定义管理员用户名
    -e CUPSPASSWORD=batcave_password \  # 自定义管理员密码
    -e TZ="America/Gotham" \    # 设置服务器时区（示例，需用有效时区字符串）
    -v <本地持久化目录>:/etc/cups \  # 挂载持久化卷保存配置
    anujdatar/cups
```  

> 注意：时区字符串需使用有效格式（示例仅为玩笑），**强烈建议修改默认用户名和密码**以提升安全性。  


### 参数及默认值  

#### 核心参数  
| 参数       | 默认值                  | 说明                                                                 |  
|------------|-------------------------|----------------------------------------------------------------------|  
| `port`     | `631:631`               | CUPS服务默认端口，非必要不建议修改。                                  |  
| `device`   | `/dev/bus/usb`          | 授予容器访问USB设备的权限。默认映射整个USB总线（避免更换USB接口后失效），若接口固定，可指定具体路径（如`/dev/bus/usb/001/005`）。 |  


#### 可选参数  
- `name`：容器名称，示例中使用`cups`，可自定义。  
- `volume`：挂载持久化卷（如`-v <本地目录>:/etc/cups`），用于保存CUPS配置文件，方便迁移或重建容器时复用设置。  


### 环境变量配置  
通过`-e`参数设置以下环境变量，自定义服务器配置：  

| #   | 参数         | 默认值              | 类型   | 说明                     |  
|-----|--------------|---------------------|--------|--------------------------|  
| 1   | TZ           | "America/New_York"  | 字符串 | 服务器所在时区           |  
| 2   | CUPSADMIN    | admin               | 字符串 | 管理员用户名             |  
| 3   | CUPSPASSWORD | password            | 字符串 | 管理员密码               |  


## 使用docker-compose部署  
创建`docker-compose.yml`文件，内容如下：  
```yaml
version: "3"
services:
    cups:
        image: docker.xuanyuan.run/anujdatar/cups  # 镜像名称
        container_name: cups   # 容器名称
        restart: unless-stopped  # 重启策略
        ports:
            - "631:631"  # 端口映射
        devices:
            - /dev/bus/usb:/dev/bus/usb  # USB设备访问
        environment:
            - CUPSADMIN=batman  # 自定义管理员用户名
            - CUPSPASSWORD=batcave_password  # 自定义管理员密码
            - TZ="America/Gotham"  # 时区（需替换为有效时区）
        volumes:
            - <本地持久化路径>:/etc/cups  # 持久化配置文件
```  

通过`docker-compose up -d`启动服务。  


## 服务器管理  
部署完成后，通过以下方式访问CUPS管理界面：  
- 无头服务器（如树莓派）：通过设备IP访问 `[] `[]  
- 本地设备（非无头服务器）：直接访问 `[]  


## 致谢  
本项目基于 **RagingTiger** 的工作开发：[[]]
