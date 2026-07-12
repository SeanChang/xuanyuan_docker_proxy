---
image: p3terx/ariang
description: "AriaNg Docker镜像提供现代Web前端，作为Aria2的WebUI，旨在简化aria2的使用流程。"
source: https://xuanyuan.cloud/zh/r/p3terx/ariang
canonical: https://xuanyuan.cloud/zh/r/p3terx/ariang
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/p3terx/ariang" title="p3terx/ariang Docker 镜像中文简介、标签列表与拉取命令">p3terx/ariang 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# AriaNg Docker镜像文档


## 镜像概述和主要用途  
AriaNg Docker镜像是Aria2下载工具的现代Web前端（WebUI），旨在简化Aria2的使用流程。该镜像基于纯HTML和JavaScript编写，无需额外编译器或运行环境，可直接部署在Web服务器中通过浏览器访问。其采用响应式布局设计，支持桌面端和移动端等各类设备，推荐与[Aria2 Pro](https://hub.docker.com/r/p3terx/aria2-pro)镜像配合使用，以实现完整的下载管理功能。


## 核心功能和特性  
- **纯前端架构**：基于HTML和JavaScript开发，无需后端运行环境，部署轻量便捷。  
- **响应式设计**：自适应不同屏幕尺寸，完美支持桌面设备、平板及移动设备访问。  
- **零依赖部署**：无需预装编译器或运行时，直接通过Docker容器启动即可使用。  
- **简化Aria2管理**：提供直观的Web界面，支持下载任务的创建、监控、暂停/继续、删除等操作。  


## 使用场景和适用范围  
- **个人/家庭下载管理**：通过Web界面便捷管理Aria2下载任务，替代命令行操作。  
- **跨设备访问需求**：支持桌面端和移动端无缝切换，满足多场景下的任务监控需求。  
- **轻量化部署场景**：适用于NAS、个人服务器等资源有限的环境，镜像体积小，资源占用低。  
- **配合Aria2 Pro使用**：作为Aria2 Pro的配套WebUI，提升下载管理体验。  


## 详细使用方法和配置说明  

### Docker运行命令示例  

#### 桥接网络模式（bridge network mode）  
适用于常规网络环境，通过端口映射暴露服务：  
```bash
docker run -d \
    --name ariang \  # 容器名称
    --log-opt max-size=1m \  # 限制日志文件大小为1MB
    --restart unless-stopped \  # 容器退出时自动重启（除非手动停止）
    -p 6880:6880 \  # 端口映射：宿主机6880端口映射到容器6880端口
    p3terx/ariang
```

#### 主机网络模式（host network mode）  
适用于需要IPv6网络访问的场景，直接使用宿主机网络栈：  
```bash
docker run -d \
    --name ariang \
    --log-opt max-size=1m \
    --restart unless-stopped \
    --network host \  # 使用宿主机网络模式
    p3terx/ariang --port 6880 --ipv6  # 容器启动参数：指定端口6880并启用IPv6
```

### Docker Compose配置示例  
创建`docker-compose.yml`文件，配置如下：  
```yaml
version: '3'
services:
  ariang:
    image: docker.xuanyuan.run/p3terx/ariang
    container_name: ariang
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "1m"  # 日志大小限制
    ports:
      - "6880:6880"  # 桥接模式端口映射（若使用host模式，删除ports并添加network_mode: "host"）
    # network_mode: "host"  # 如需启用主机网络模式，取消此行注释并删除ports配置
    command: --port 6880  # 可选：指定服务端口（默认6880）
```

启动命令：  
```bash
docker-compose up -d
```

### 访问方式  
容器启动后，通过浏览器访问宿主机IP:6880即可打开AriaNg Web界面。  
示例：`http://宿主机IP:6880`  


## 配置参数说明  
### 容器启动参数  
- `--port <端口号>`：指定AriaNg服务端口（默认6880），如`--port 8080`将服务端口改为8080。  
- `--ipv6`：启用IPv6网络支持（仅在主机网络模式下生效）。  

### Docker运行参数（常用）  
- `--name ariang`：自定义容器名称为`ariang`，便于管理。  
- `--log-opt max-size=1m`：限制容器日志文件大小，避免磁盘空间占用过大。  
- `--restart unless-stopped`：设置容器重启策略，确保服务稳定运行（除非手动停止容器）。  
- `-p 6880:6880`：端口映射，格式为`宿主机端口:容器端口`，允许外部访问容器内服务。  
- `--network host`：使用主机网络模式，容器直接使用宿主机的网络栈，适用于需要IPv6或避免端口映射的场景。  


## 截图  

### 桌面设备  
![桌面设备界面](https://cdn.jsdelivr.net/gh/mayswind/AriaNg-WebSite/screenshots/desktop.png)  

### 移动设备  
![移动设备界面](https://cdn.jsdelivr.net/gh/mayswind/AriaNg-WebSite/screenshots/mobile.png)  


## 参考与致谢  
- AriaNg核心项目：[mayswind/AriaNg](https://github.com/mayswind/AriaNg)  
- Web服务器组件：[emikulic/darkhttpd](https://github.com/emikulic/darkhttpd)
