<!-- xuanyuan-docker-images-zh
image: docker/welcome-to-docker
source: https://xuanyuan.cloud/zh/r/docker/welcome-to-docker
canonical: https://xuanyuan.cloud/zh/r/docker/welcome-to-docker
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/docker/welcome-to-docker" title="docker/welcome-to-docker Docker 镜像中文简介、标签列表与拉取命令">docker/welcome-to-docker — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/docker/welcome-to-docker" title="docker/welcome-to-docker Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/docker/welcome-to-docker</a></p>

# docker/welcome-to-docker 镜像文档


## 镜像概述和主要用途

`docker/welcome-to-docker` 是 Docker 官方提供的入门示例镜像，专为 Docker 新手用户设计。该镜像封装了一个简单的 Web 应用，旨在通过直观的实践帮助新用户快速理解 Docker 的核心概念和基本操作流程，包括镜像拉取、容器创建、端口映射、容器生命周期管理等基础技能。


## 核心功能和特性

- **直观的学习反馈**：提供简易 Web 界面，实时展示容器运行状态，帮助用户验证操作结果
- **极简配置需求**：无需复杂参数或前置配置，新手可通过单条命令完成从启动到访问的全流程
- **标准操作示范**：完整展示 Docker 基础命令（如 `docker run`）的核心参数用法，包括后台运行、端口映射、容器命名等
- **轻量级设计**：基于官方精简基础镜像构建，体积小巧，拉取和启动速度快，降低新手操作门槛


## 使用场景和适用范围

### 使用场景
- Docker 初学者的首次实践操作（如验证 Docker 环境是否正常工作）
- 学习 `docker run` 命令及端口映射（`-p` 参数）的实际效果
- 理解容器与宿主机之间的网络通信基础原理
- 演示 Docker 容器的基本生命周期（启动、运行、停止、删除）

### 适用范围
- Docker 新手用户（0-3个月使用经验）
- 编程/运维培训中的 Docker 入门教学案例
- 快速验证 Docker 环境部署正确性的场景
- 技术分享中演示 Docker 基础功能的极简示例


## 详细使用方法和配置说明

### 前提条件
- 已在本地环境安装 Docker Engine（支持 Docker Desktop 或 Docker Engine on Linux/macOS/Windows）
- 网络环境可正常访问 Docker Hub（用于拉取镜像）


### 获取镜像
无需手动拉取镜像，执行 `docker run` 命令时 Docker 会自动从 Docker Hub 拉取最新版本：
```bash
# 自动拉取并运行镜像（若本地无镜像）
docker run -d -p 8088:80 --name welcome-to-docker docker/welcome-to-docker
```


### 运行容器
使用以下命令启动容器，该命令包含核心参数说明：
```bash
docker run \
  -d \                  # 后台运行容器（守护进程模式）
  -p 8088:80 \          # 端口映射：宿主机8088端口映射到容器80端口
  --name welcome-to-docker \  # 为容器指定名称（便于后续管理）
  docker/welcome-to-docker    # 镜像名称（格式：仓库名/镜像名）
```


### 访问应用
容器启动后，通过浏览器访问以下地址验证运行状态：
```
http://localhost:8088
```
成功访问后，页面将显示欢迎信息及容器运行相关的基础说明，确认容器已正常工作。


### 容器管理
#### 查看运行状态
```bash
# 查看容器运行状态
docker ps --filter "name=welcome-to-docker"

# 查看容器日志（验证应用输出）
docker logs welcome-to-docker
```

#### 停止容器
```bash
docker stop welcome-to-docker
```

#### 删除容器
```bash
# 需先停止容器，或使用 -f 强制删除运行中的容器
docker rm welcome-to-docker
# 强制删除运行中的容器：docker rm -f welcome-to-docker
```


## Docker 部署方案示例

### 1. 基础部署（docker run 命令）
直接使用官方推荐命令快速启动（同上文 "运行容器" 部分）：
```bash
docker run -d -p 8088:80 --name welcome-to-docker docker/welcome-to-docker
```


### 2. Docker Compose 部署（可选）
若需通过 Docker Compose 管理（适合后续扩展学习），创建 `docker-compose.yml` 文件：
```yaml
version: '3.8'

services:
  welcome-app:
    image: docker/welcome-to-docker
    container_name: welcome-to-docker
    ports:
      - "8088:80"  # 宿主机端口:容器端口
    restart: "no"  # 仅手动启动，不自动重启（适合学习场景）
```
启动命令：
```bash
docker-compose up -d
```
停止并删除：
```bash
docker-compose down
```


## 配置参数与环境变量

当前版本镜像设计极简，**无需额外配置参数或环境变量**，所有功能通过基础 `docker run` 参数即可实现。若需自定义端口映射，仅需修改 `-p` 参数的宿主机端口部分（如 `-p 8090:80` 可将访问端口改为 8090）。


## 相关资源
- GitHub 源码仓库：[https://github.com/docker/welcome-to-docker](https://github.com/docker/welcome-to-docker)
- Docker Hub 镜像主页：[https://hub.docker.com/r/docker/welcome-to-docker](https://hub.docker.com/r/docker/welcome-to-docker)

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/docker/welcome-to-docker" title="docker/welcome-to-docker Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/docker/welcome-to-docker</a></p>
