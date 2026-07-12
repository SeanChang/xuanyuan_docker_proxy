---
image: testcontainers/sshd
description: "包含SSH守护进程的Docker镜像，用于提供SSH服务以实现对容器的远程访问。"
source: https://xuanyuan.cloud/zh/r/testcontainers/sshd
canonical: https://xuanyuan.cloud/zh/r/testcontainers/sshd
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/testcontainers/sshd" title="testcontainers/sshd Docker 镜像中文简介、标签列表与拉取命令">testcontainers/sshd 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# sshd-docker 镜像文档


## 镜像概述和主要用途  
sshd-docker 是一个预装 SSH 守护进程（sshd）的 Docker 镜像，旨在为容器提供 SSH 服务能力，支持通过 SSH 协议远程连接容器内部。该镜像通常基于轻量级 Linux 发行版（如 Alpine、Ubuntu 等，具体取决于镜像版本）构建，核心目标是简化容器的远程访问与管理流程，适用于需要通过 SSH 协议与容器交互的场景。


## 核心功能和特性  
- **预装 SSH 服务**：内置 OpenSSH Server，无需手动安装配置，启动容器即可提供 SSH 服务。  
- **灵活认证方式**：支持 SSH 密码认证和密钥认证（推荐密钥认证以提升安全性）。  
- **可配置服务参数**：支持通过环境变量或自定义配置文件调整 SSH 服务参数（如端口、认证策略等）。  
- **轻量级设计**：基于精简基础镜像构建，镜像体积小，资源占用低。  
- **跨平台兼容**：支持 Docker 官方支持的所有架构（如 x86_64、ARM 等）。  


## 使用场景和适用范围  
- **开发环境调试**：开发过程中需远程连接容器，调试应用或查看日志。  
- **容器远程管理**：需要通过 SSH 协议访问容器内部服务（如数据库、应用进程）。  
- **临时 SSH 服务需求**：快速部署临时容器并提供 SSH 访问能力（如临时测试环境）。  
- **教学或演示场景**：用于演示 SSH 服务配置、容器远程访问等操作。  


## 使用方法和配置说明  

### 基本使用（`docker run` 命令）  
通过 `docker run` 快速启动容器并暴露 SSH 服务：  

```bash
# 基础示例：使用密码认证，映射主机端口 2222 到容器 SSH 端口 22
docker run -d \
  --name sshd-container \
  -p 2222:22 \
  -e ROOT_PASSWORD=your_secure_password \
  docker.xuanyuan.run/sshd-docker

# 密钥认证示例：添加本地公钥到容器，禁用密码认证
docker run -d \
  --name sshd-container \
  -p 2222:22 \
  -e AUTHORIZED_KEYS="$(cat ~/.ssh/id_rsa.pub)" \
  -e DISABLE_PASSWORD_AUTH=true \
  docker.xuanyuan.run/sshd-docker
```

### Docker Compose 配置示例  
创建 `docker-compose.yml` 文件，定义服务并持久化配置：  

```yaml
version: '3'
services:
  sshd:
    image: docker.xuanyuan.run/sshd-docker
    container_name: sshd-service
    ports:
      - "2222:22"  # 主机端口 2222 映射到容器 SSH 端口 22
    environment:
      - ROOT_PASSWORD=your_secure_password  # 可选：设置 root 密码（若使用密码认证）
      - AUTHORIZED_KEYS=ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ...  # 可选：添加授权公钥（多个公钥用换行分隔）
      - SSH_PORT=22  # 可选：自定义容器内 SSH 服务端口（默认 22）
    volumes:
      - ./ssh-config:/etc/ssh  # 可选：挂载本地 SSH 配置目录（覆盖容器默认配置）
      - ./data:/root/data  # 可选：挂载数据卷，持久化容器内数据
    restart: unless-stopped
```

启动服务：  
```bash
docker-compose up -d
```


### 配置参数说明  

#### 环境变量  
| 环境变量名               | 描述                                                                 | 默认值       | 示例                                  |
|--------------------------|----------------------------------------------------------------------|--------------|---------------------------------------|
| `ROOT_PASSWORD`          | 设置 root 用户密码（用于密码认证，若同时配置 `AUTHORIZED_KEYS`，密码认证仍可用） | 无           | `ROOT_PASSWORD=SecurePass123!`        |
| `AUTHORIZED_KEYS`        | 添加 SSH 公钥到 `~/.ssh/authorized_keys`（用于密钥认证，支持多个公钥，用换行分隔） | 无           | `AUTHORIZED_KEYS="ssh-rsa AAA...\nssh-rsa BBB..."` |
| `DISABLE_PASSWORD_AUTH`  | 是否禁用密码认证（`true` 或 `false`，推荐启用密钥认证时设为 `true`）          | `false`      | `DISABLE_PASSWORD_AUTH=true`          |
| `SSH_PORT`               | 自定义容器内 SSH 服务监听端口（需同步调整端口映射）                           | `22`         | `SSH_PORT=2222`                       |


#### 端口映射  
容器内 SSH 服务默认监听 `22` 端口，需通过 `-p` 参数映射到主机端口（如 `-p 2222:22`，表示主机端口 2222 对应容器端口 22）。若自定义 `SSH_PORT`，需同步调整映射（如 `SSH_PORT=2222` 时，映射 `-p 2223:2222`）。


#### 数据卷挂载  
- **SSH 配置文件**：挂载本地 `sshd_config` 文件到容器 `/etc/ssh/sshd_config`，自定义 SSH 服务配置（如禁用 root 登录、限制 IP 访问等）。  
  示例：  
  ```bash
  docker run -d \
    -p 2222:22 \
    -v ./sshd_config:/etc/ssh/sshd_config \
    docker.xuanyuan.run/sshd-docker
  ```  
- **密钥文件**：挂载本地公钥文件到容器 `~/.ssh/authorized_keys`，避免通过环境变量传递长字符串（适用于公钥较多的场景）。  
  示例：  
  ```bash
  docker run -d \
    -p 2222:22 \
    -v ~/.ssh/id_rsa.pub:/root/.ssh/authorized_keys:ro \
    docker.xuanyuan.run/sshd-docker
  ```  


### 远程连接示例  
启动容器后，通过以下命令远程连接：  
```bash
# 密码认证（需设置 ROOT_PASSWORD）
ssh root@localhost -p 2222

# 密钥认证（需配置 AUTHORIZED_KEYS 或挂载公钥）
ssh -i ~/.ssh/id_rsa root@localhost -p 2222
```


## 自定义 SSH 服务配置  
若需深度自定义 SSH 服务（如修改默认端口、禁用 root 登录、限制用户等），可通过挂载 `sshd_config` 文件实现。示例自定义配置（`sshd_config`）：  
```conf
Port 2222                # 自定义端口
PermitRootLogin no       # 禁用 root 直接登录
AllowUsers appuser       # 仅允许 appuser 用户登录
PasswordAuthentication no  # 禁用密码认证
PubkeyAuthentication yes  # 启用密钥认证
```  
启动容器时挂载该文件：  
```bash
docker run -d \
  -p 2222:2222 \  # 端口映射需与自定义 Port 一致
  -v ./sshd_config:/etc/ssh/sshd_config \
  sshd-docker
