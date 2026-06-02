---
image: n8nio/n8n
description: "这是一款免费且开源、采用公平代码许可的基于节点的工作流自动化工具，它通过直观的节点连接方式，帮助用户轻松构建和自动化各类复杂工作流程，适用于个人、团队及企业等不同场景，兼具灵活性与易用性，致力于为用户提供高效、透明的自动化解决方案。"
source: https://xuanyuan.cloud/zh/r/n8nio/n8n
canonical: https://xuanyuan.cloud/zh/r/n8nio/n8n
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/n8nio/n8n" title="n8nio/n8n Docker 镜像中文简介、标签列表与拉取命令">n8nio/n8n — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/n8nio/n8n" title="n8nio/n8n Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/n8nio/n8n</a>

# n8n - 面向技术团队的安全工作流自动化平台  

n8n 是一款工作流自动化平台，为技术团队提供代码级的灵活性与无代码工具的效率。它支持 400 多种集成、原生 AI 能力，并采用公平代码许可，让你在构建强大自动化流程的同时，完全掌控数据与部署。  


## 核心功能  

- **按需编写代码**：支持 JavaScript/Python 脚本、npm 包引入，或直接使用可视化界面操作  
- **AI 原生平台**：基于 LangChain 构建 AI 代理工作流，可接入自有数据与模型  
- **完全自主控制**：通过公平代码许可实现自托管，或直接使用 [云服务]([])  
- **企业级适配**：提供高级权限管理、SSO 单点登录及气隙部署方案  
- **活跃社区支持**：400 多种集成工具与 900 多个 [现成模板]([])  


## 演示  

观看 [:tv: 短视频（<4 分钟）]() 了解 n8n 工作流创建的核心概念。  


## 可用集成  

n8n 提供 200 多种节点用于自动化流程，完整列表见 [集成页面]([])。  


## 文档  

官方文档可访问 [[]]([])，网站 [[]]([]) 还提供额外示例工作流。  


## 使用 Docker 启动 n8n  

在终端执行以下命令：  

```bash
docker volume create n8n_data

docker run -it --rm \
 --name n8n \
 -p 5678:5678 \
 -v n8n_data:/home/node/.n8n \
 docker.n8n.io/n8nio/n8n
```  

该命令会下载 n8n 镜像并启动容器，通过 [[]]([]) 访问平台。  

为确保容器重启后数据不丢失，命令中挂载了 `n8n_data` 卷，工作流数据（含 SQLite 数据库、Webhook URL、凭证加密密钥等）会保存在 `/home/node/.n8n` 目录。若启动时无法读取该目录，n8n 会自动生成新密钥，导致现有凭证无法解密，需特别注意。  


## 使用隧道启动 n8n  

> **警告**：仅用于本地开发测试，**禁止用于生产环境**！  

n8n 需接入公网才能使用 Webhook（如接收 GitHub 等外部服务触发）。平台提供隧道服务，可将外部请求转发至本地实例（代码见 [此处]([])）。启动时添加 `--tunnel` 参数即可：  

```bash
docker volume create n8n_data

docker run -it --rm \
 --name n8n \
 -p 5678:5678 \
 -v n8n_data:/home/node/.n8n \
 docker.n8n.io/n8nio/n8n \
 start --tunnel
```  


## 搭配 PostgreSQL 使用  

默认情况下，n8n 使用 SQLite 存储凭证、执行记录和工作流，也支持 PostgreSQL。  

> **注意**：即使使用其他数据库，仍需持久化 `/home/node/.n8n` 目录，其中包含凭证加密密钥等关键数据。  

替换以下命令中的占位符（如 `<POSTGRES_USER>`）后执行：  

```bash
docker volume create n8n_data

docker run -it --rm \
 --name n8n \
 -p 5678:5678 \
 -e DB_TYPE=postgresdb \
 -e DB_POSTGRESDB_DATABASE=<数据库名> \
 -e DB_POSTGRESDB_HOST=<数据库主机> \
 -e DB_POSTGRESDB_PORT=<端口> \
 -e DB_POSTGRESDB_USER=<用户名> \
 -e DB_POSTGRESDB_SCHEMA=< schema > \
 -e DB_POSTGRESDB_PASSWORD=<密码> \
 -v n8n_data:/home/node/.n8n \
 docker.n8n.io/n8nio/n8n
```  

完整的 Docker Compose 配置示例见 [此处]([])。  


## 通过文件传递敏感数据  

为避免通过环境变量明文传递敏感信息，可在部分环境变量后添加 `_FILE` 后缀，n8n 会从对应文件读取数据（适用于 Docker/Kubernetes 密钥管理）。支持的变量包括：  

- DB_POSTGRESDB_DATABASE_FILE  
- DB_POSTGRESDB_HOST_FILE  
- DB_POSTGRESDB_PASSWORD_FILE  
- DB_POSTGRESDB_PORT_FILE  
- DB_POSTGRESDB_USER_FILE  
- DB_POSTGRESDB_SCHEMA_FILE  


## 服务器部署示例  

针对主流云服务商及不同场景的部署方案，可参考 [服务器设置文档]([])。  


## 版本更新  

更新前请先查看 [ breaking changes ]([])，确认是否影响现有配置。可通过 Docker 桌面端（Images 标签页右键 "Pull"）或命令行拉取镜像：  


### 拉取最新稳定版  
```bash
docker pull docker.n8n.io/n8nio/n8n
```  


### 拉取指定版本  
```bash
docker pull docker.n8n.io/n8nio/n8n:0.220.1  # 示例版本号
```  


### 拉取开发版（不稳定）  
```bash
docker pull docker.n8n.io/n8nio/n8n:next
```  


### 重启容器  
1. 获取容器 ID：  
   ```bash
   docker ps -a
   ```  
2. 停止容器：  
   ```bash
   docker stop [容器ID]
   ```  
3. 删除容器（数据不会丢失）：  
   ```bash
   docker rm [容器ID]
   ```  
4. 启动新容器：  
   ```bash
   docker run --name=[容器名] [其他参数] -d docker.n8n.io/n8nio/n8n
   ```  


### 使用 Docker Compose 更新  
```bash
# 拉取最新镜像
docker compose pull

# 停止并移除旧容器
docker compose down

# 启动新容器
docker compose up -d
```  


## 设置时区  

通过环境变量 `GENERIC_TIMEZONE` 指定 n8n 内部使用的时区（如调度节点），`TZ` 控制系统命令（如 `date`）的时区。示例：  

```bash
docker run -it --rm \
 --name n8n \
 -p 5678:5678 \
 -e GENERIC_TIMEZONE="Europe/Berlin" \  # n8n 内部时区
 -e TZ="Europe/Berlin" \  # 系统时区
 docker.n8n.io/n8nio/n8n
```  

更多配置说明见 [环境变量文档]([])。  


## 构建 Docker 镜像  

```bash
docker buildx build --platform linux/amd64,linux/arm64 --build-arg N8N_VERSION=<版本号> -t n8n:<版本号> .

# 示例（构建 1.30.1 版本）：
docker buildx build --platform linux/amd64,linux/arm64 --build-arg N8N_VERSION=1.30.1 -t n8n:1.30.1 .
```  


## n8n 的名称含义与发音  

**简答**：意为“nodemation”，发音为“n-eight-n”。  

**详解**：项目原名“nodemation”（结合“node”节点视图/Node.js 技术栈与“automation”自动化），因名称过长且域名不可用，简化为“n8n”（类似 Kubernetes 缩写为 k8s）。  


## 支持与资源  

- **技术支持**：访问 [社区论坛]([]) 获取官方团队及用户帮助  
- **招聘信息**：查看 [职位页面]([])，加入 n8n 团队  
- **许可证**：详见 [许可证说明]([])
