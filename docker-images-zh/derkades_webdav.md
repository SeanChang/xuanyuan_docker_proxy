---
image: derkades/webdav
description: "基于NGINX和最新Debian（bullseye）构建的简单WebDAV镜像，支持amd64、arm及arm64架构，提供便捷的文件共享服务，可通过环境变量配置访问凭证。"
source: https://xuanyuan.cloud/zh/r/derkades/webdav
canonical: https://xuanyuan.cloud/zh/r/derkades/webdav
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/derkades/webdav" title="derkades/webdav Docker 镜像中文简介、标签列表与拉取命令">derkades/webdav 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# derkades/webdav 镜像文档

## 镜像概述
derkades/webdav是一个基于NGINX构建的轻量级WebDAV服务镜像，旨在提供简单易用的文件共享解决方案。该镜像基于最新的Debian操作系统版本（当前为bullseye），并支持amd64、arm及arm64多种硬件架构，确保在不同设备上的兼容性。

## 核心功能与特性
- **WebDAV服务**：通过NGINX实现标准WebDAV协议，支持文件上传、下载、管理等基础操作
- **多架构支持**：提供amd64（x86_64）、arm（32位ARM）及arm64（64位ARM）架构镜像，适配PC、树莓派等多种设备
- **简化配置**：通过环境变量直接配置访问用户名和密码，无需复杂的配置文件修改
- **轻量基础**：基于Debian bullseye构建，系统环境精简，降低资源占用

## 使用场景
- 个人文件共享：在本地网络或家庭环境中搭建私有文件存储与共享服务
- 小型团队协作：为小团队提供简单的文件同步与共享平台
- 嵌入式设备文件服务：在ARM架构的嵌入式设备（如树莓派）上部署，实现设备间文件传输

## 使用方法与配置说明

### 前置要求
- Docker Engine 1.13.0+ 或 Docker Compose 1.10.0+
- 宿主机需提供用于存储WebDAV文件的目录（需确保读写权限）

### docker-compose 部署示例
推荐使用docker-compose进行部署，配置示例如下：

```yaml
webdav:
  image: docker.xuanyuan.run/derkades/webdav
  volumes:
    - '/path/to/host/data:/data'  # 将宿主机目录挂载到容器内/data（WebDAV根目录）
  ports:
    - '8080:80'  # 映射容器80端口到宿主机8080端口（可根据需求修改宿主机端口）
  environment:
    USERNAME: user  # WebDAV访问用户名（必填）
    PASSWORD: Yo4Nup5uvDmo587P8xPpqT  # WebDAV访问密码（必填，建议使用强密码）
  restart: unless-stopped  # 容器退出时自动重启（除非手动停止）
```

### docker run 命令部署
若需直接使用docker run命令启动，可执行：

```bash
docker run -d \
  --name webdav \
  -v /path/to/host/data:/data \
  -p 8080:80 \
  -e USERNAME=user \
  -e PASSWORD=Yo4Nup5uvDmo587P8xPpqT \
  --restart unless-stopped \
  docker.xuanyuan.run/derkades/webdav
```

### 配置参数说明
| 参数类型       | 参数名       | 说明                                                                 |
|----------------|--------------|----------------------------------------------------------------------|
| volumes        | `/data`      | 容器内WebDAV服务的根目录，需挂载宿主机目录以持久化存储文件           |
| ports          | `80`         | 容器内WebDAV服务端口，通常映射到宿主机非特权端口（如8080、8088等）  |
| environment    | `USERNAME`   | 访问WebDAV服务的用户名，必填项                                       |
| environment    | `PASSWORD`   | 访问WebDAV服务的密码，必填项，建议使用包含大小写字母、数字及特殊字符的强密码 |
| restart        | `unless-stopped` | 建议配置此重启策略，确保服务稳定运行                                 |

## 访问方式
部署完成后，可通过WebDAV客户端（如Windows文件资源管理器、macOS Finder、Linux davfs2、手机端WebDAV应用等）访问服务，地址格式为：`http://宿主机IP:映射端口`，使用配置的`USERNAME`和`PASSWORD`进行身份验证。
