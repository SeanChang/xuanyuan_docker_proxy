---
image: devzwf/iventoy
description: "Docker化的iventoy，用于提供网络启动(PXE)服务，支持ISO镜像管理、配置持久化，适用于企业网络部署、多系统启动环境搭建及无盘工作站启动。"
source: https://xuanyuan.cloud/zh/r/devzwf/iventoy
canonical: https://xuanyuan.cloud/zh/r/devzwf/iventoy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/devzwf/iventoy" title="devzwf/iventoy Docker 镜像中文简介、标签列表与拉取命令">devzwf/iventoy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# iventoy Docker镜像文档

## 镜像概述
devzwf/iventoy镜像为Docker化的iventoy工具，提供网络启动(PXE)服务，支持通过网络引导客户端并管理ISO镜像。该镜像实现了配置、日志和用户数据的持久化存储，便于快速部署和维护网络启动环境。

## 核心功能和特性
- **PXE网络启动支持**：通过TFTP协议提供网络引导服务，支持客户端从网络启动
- **ISO镜像管理**：集中存储和管理ISO镜像文件，供客户端启动时选择
- **数据持久化**：配置文件、日志和用户数据通过卷挂载实现持久化，重启容器不丢失
- **灵活配置**：支持通过环境变量控制调试模式，适应不同部署需求

## 使用场景和适用范围
- 企业网络批量部署操作系统
- 多系统启动测试环境搭建
- 无盘工作站网络启动方案
- 系统维护与救援环境构建
- 教学或演示环境的快速部署

## 使用方法和配置说明

### Docker Run命令示例
```bash
docker run -d \
  --name iventoy \
  --restart unless-stopped \
  --privileged \
  -p 26000:26000 \
  -p 16000:16000 \
  -p 69:69/udp \
  -v ./isos:/app/iso \
  -v ./config:/app/data \
  -v ./log:/app/log \
  -v ./user:/app/user \
  -e DEBUG=false \
  docker.xuanyuan.run/devzwf/iventoy:latest
```

### Docker Compose配置
```yaml
version: '3'
services:
  iventoy:
    image: docker.xuanyuan.run/devzwf/iventoy:latest
    container_name: iventoy
    restart: unless-stopped
    privileged: true
    ports:
      - 26000:26000  # Web管理界面端口
      - 16000:16000  # 数据传输端口
      - 69:69/udp    # TFTP服务端口(PXE启动必需)
    volumes:
      - ./isos:/app/iso    # ISO镜像存储目录
      - ./config:/app/data # 配置文件持久化目录
      - ./log:/app/log     # 日志文件存储目录
      - ./user:/app/user   # 用户数据目录
    environment:
      - DEBUG=false  # 调试模式开关(true开启，false关闭)
```

### 配置参数说明

#### 容器设置
- `--privileged: true`：必需，启用特权模式以支持网络启动相关系统功能
- `--restart unless-stopped`：容器退出时自动重启(除非手动停止)

#### 端口映射
- `26000:26000`：iventoy Web管理界面访问端口
- `16000:16000`：ISO镜像数据传输端口
- `69:69/udp`：TFTP服务端口，PXE启动协议必需端口

#### 卷挂载
- `./isos:/app/iso`：本地ISO镜像存放目录，容器将读取此目录下的ISO文件供启动选择
- `./config:/app/data`：配置文件存储目录，包含网络设置、启动菜单等配置
- `./log:/app/log`：服务运行日志目录，用于问题排查和状态监控
- `./user:/app/user`：用户自定义数据目录，存储用户相关配置和脚本

#### 环境变量
- `DEBUG=false`：调试模式控制，设置为`true`时输出详细调试日志，默认`false`

## 支持信息
如需支持，可通过[Ko-fi](https://ko-fi.com/devzwf)支持开发者。
