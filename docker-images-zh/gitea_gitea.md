---
image: gitea/gitea
description: "Gitea，寓意“一杯茶的功夫轻松玩转Git”，是一款简单易用的自托管Git服务，专为个人开发者与中小型团队打造，提供轻量高效的代码托管解决方案，无需复杂配置即可快速部署，支持版本控制、代码审查、项目管理等核心功能，让Git使用体验如品茶般惬意无忧，轻松满足自托管代码管理需求。"
source: https://xuanyuan.cloud/zh/r/gitea/gitea
canonical: https://xuanyuan.cloud/zh/r/gitea/gitea
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gitea/gitea" title="gitea/gitea Docker 镜像中文简介、标签列表与拉取命令">gitea/gitea — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/gitea/gitea" title="gitea/gitea Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/gitea/gitea</a>

# Gitea Docker Rootless 安装指南


## 概述  
Gitea 是一款轻量级自托管 Git 服务，支持代码管理、Issue 跟踪、CI/CD 等功能，适合个人或团队搭建私有代码仓库。采用 Docker Rootless 模式安装，可避免容器以 root 权限运行，降低系统安全风险，同时简化环境配置流程。以下基于官方文档，介绍在 Docker Rootless 环境中安装 Gitea 的具体步骤。


## 前提条件  
开始前需确保环境满足以下要求：  

1. **系统支持**：推荐 Linux 系统（如 Ubuntu 20.04+、Debian 11+），Windows/macOS 需通过 Docker Desktop 启用 Rootless 模式（配置略不同，建议优先参考官方文档）。  
2. **Docker 环境**：已安装 Docker 20.10+ 及 Docker Compose（或 Docker Desktop 内置的 Compose）。  
3. **Rootless 模式启用**：Docker 需配置为 Rootless 模式（非 root 用户运行 Docker）。若未启用，可通过官方脚本安装：  
   ```bash
   curl -fsSL [] | sh
   ```  
   安装后按提示配置环境变量（如 `export PATH=$HOME/bin:$PATH`）。  


## 安装步骤  

### 1. 准备数据目录  
为避免容器权限问题，先创建本地数据目录（存储配置、代码库等数据），并确保当前用户有读写权限：  
```bash
mkdir -p ~/.gitea/{data,config}  # 数据目录和配置目录
```  


### 2. 创建 Docker Compose 配置文件  
在 `~/.gitea` 目录下创建 `docker-compose.yml` 文件，内容如下（基于官方 Rootless 镜像配置）：  
```yaml
version: "3"

services:
  gitea:
    image: gitea/gitea:latest-rootless  # Rootless 专用镜像
    container_name: gitea
    restart: always
    volumes:
      - ~/.gitea/data:/var/lib/gitea  # 数据持久化
      - ~/.gitea/config:/etc/gitea    # 配置文件
      - /etc/timezone:/etc/timezone:ro  # 同步时区
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "3000:3000"  # Web 访问端口（宿主机:容器内）
      - "2222:22"    # SSH 访问端口（容器内默认 22，宿主机映射到 2222 避免冲突）
    environment:
      - USER_UID=$(id -u)  # 当前用户 UID（避免权限问题）
      - USER_GID=$(id -g)  # 当前用户 GID
```  

**说明**：  
- 镜像使用 `gitea/gitea:latest-rootless`，确保是 Rootless 版本；  
- 端口映射：Web 默认 3000，SSH 因 Rootless 容器无法使用 1024 以下端口，宿主机映射到 2222（可自定义）；  
- `USER_UID` 和 `USER_GID` 设为当前用户 ID，避免容器内用户与宿主机权限冲突。  


### 3. 启动 Gitea 容器  
在 `~/.gitea` 目录下执行以下命令启动容器：  
```bash
cd ~/.gitea
docker compose up -d  # 后台启动容器
```  

首次启动可能需要几分钟（拉取镜像、初始化数据库等），可通过 `docker logs gitea` 查看启动日志，确认无报错。  


## 验证安装  

### 1. 确认容器状态  
执行 `docker ps`，若看到 `gitea` 容器状态为 `Up`，说明启动成功：  
```
CONTAINER ID   IMAGE                          COMMAND                  CREATED         STATUS         PORTS                                       NAMES
abc123         gitea/gitea:latest-rootless   "/usr/bin/entrypoint…"   5 minutes ago   Up 5 minutes   0.0.0.0:3000->3000/tcp, 0.0.0.0:2222->22/tcp  gitea
```  


### 2. 访问 Web 界面并完成配置  
打开浏览器访问 `[] IP），进入 Gitea 初始设置页面：  
- **数据库配置**：默认使用 SQLite（适合个人/小团队），直接点击“立即安装”；  
- **管理员账号**：设置管理员用户名、密码（建议强密码）；  
- **站点设置**：可修改站点名称、SSH 服务器域名（如 `ssh://用户名@服务器IP:2222`）。  

完成后点击“立即安装”，等待配置生效，即可使用 Gitea 服务。  


## 注意事项  
- **升级 Gitea**：需先停止容器（`docker compose down`），更新 `docker-compose.yml` 中的镜像版本（如 `1.21.0-rootless`），再重新启动（`docker compose up -d`）；  
- **数据备份**：定期备份 `~/.gitea/data` 和 `~/.gitea/config` 目录，避免数据丢失；  
- **端口冲突**：若 3000/2222 端口被占用，修改 `docker-compose.yml` 中的端口映射（如 `3001:3000`）。  


更多细节可参考 [Gitea 官方 Docker Rootless 安装文档]([])。
