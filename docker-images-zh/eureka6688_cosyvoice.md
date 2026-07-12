---
image: eureka6688/cosyvoice
description: "cosyvoice服务的Docker镜像，提供Web接口，默认通过50000端口运行，支持x86（latest标签）和ARM（arm标签）架构，适用于部署语音相关应用服务。"
source: https://xuanyuan.cloud/zh/r/eureka6688/cosyvoice
canonical: https://xuanyuan.cloud/zh/r/eureka6688/cosyvoice
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/eureka6688/cosyvoice" title="eureka6688/cosyvoice Docker 镜像中文简介、标签列表与拉取命令">eureka6688/cosyvoice 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# cosyvoice Docker镜像文档

## 镜像概述

eureka6688/cosyvoice是用于部署cosyvoice服务的Docker镜像，提供Web接口功能。该镜像支持x86架构（使用`latest`标签）和ARM架构（使用`arm`标签），默认通过50000端口对外提供服务，适用于快速部署语音相关应用。

## 核心功能与特性

- **Web服务支持**：通过`web.py`启动Web服务，提供应用接口
- **多架构兼容**：x86架构使用`latest`标签，ARM架构使用`arm`标签
- **持久化运行**：默认配置`restart: unless-stopped`，确保服务意外停止后自动恢复
- **交互式终端**：启用`stdin_open`和`tty`，支持容器内交互式操作

## 使用场景

- 语音应用服务部署
- 开发环境快速搭建
- 语音相关功能测试与验证

## 使用方法

### 1. Docker Run 部署

```bash
# x86架构
docker run -d \
  --name cov \
  -p 50000:50000 \
  --restart unless-stopped \
  -it \
  docker.xuanyuan.run/eureka6688/cosyvoice:latest \
  python web.py --port 50000

# ARM架构
docker run -d \
  --name cov \
  -p 50000:50000 \
  --restart unless-stopped \
  -it \
  docker.xuanyuan.run/eureka6688/cosyvoice:arm \
  python web.py --port 50000
```

### 2. Docker Compose 部署

创建`docker-compose.yml`文件：

```yaml
services:
  cov:
    image: docker.xuanyuan.run/eureka6688/cosyvoice:latest  # ARM架构替换为"eureka6688/cosyvoice:arm"
    container_name: cov
    ports:
      - "50000:50000"  # 宿主机端口:容器端口
    command: ["python", "web.py", "--port", "50000"]  # 启动命令及端口参数
    stdin_open: true  # 保持标准输入打开
    tty: true  # 分配伪终端
    restart: unless-stopped  # 除非手动停止，否则自动重启
```

启动服务：
```bash
docker-compose up -d
```

## 配置说明

### 架构选择
- x86架构：使用镜像标签`latest`
- ARM架构：使用镜像标签`arm`

### 端口配置
- 默认容器内端口：50000
- 端口映射格式：`宿主机端口:50000`，可根据需求修改宿主机端口

### 启动命令参数
- `--port`：指定Web服务监听端口，默认50000，需与端口映射中的容器端口保持一致

### 容器设置
- `stdin_open: true`：保持标准输入打开，支持容器内交互
- `tty: true`：分配伪终端，增强交互体验
- `restart: unless-stopped`：服务异常退出时自动重启，保障服务稳定性
