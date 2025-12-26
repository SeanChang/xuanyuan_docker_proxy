---
id: 17
title: n8n Docker 容器化部署教程
slug: n8n-docker
summary: n8n是一款专为技术团队打造的开源工作流自动化平台（Workflow Automation Platform），兼具「低代码（No-code）」与「可编程（Pro-code）」双重特性。它让你可以轻松地将不同系统、API 和服务连接起来，自动执行任务、数据同步、通知、集成 AI 模型等各种流程。n8n 不仅能节省大量重复性工作，还能在团队内部构建稳定、安全的自动化体系。
category: Docker,n8n
tags: n8n,docker,部署教程
image_name: n8nio/n8n
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-n8n.png"
status: published
created_at: "2025-10-08 06:26:59"
updated_at: "2025-10-12 06:07:27"
---

# n8n Docker 容器化部署教程

> n8n是一款专为技术团队打造的开源工作流自动化平台（Workflow Automation Platform），兼具「低代码（No-code）」与「可编程（Pro-code）」双重特性。它让你可以轻松地将不同系统、API 和服务连接起来，自动执行任务、数据同步、通知、集成 AI 模型等各种流程。n8n 不仅能节省大量重复性工作，还能在团队内部构建稳定、安全的自动化体系。

## n8n 简介

**n8n** 是一款专为技术团队打造的 **开源工作流自动化平台（Workflow Automation Platform）**，兼具「低代码（No-code）」与「可编程（Pro-code）」双重特性。

它让你可以轻松地将不同系统、API 和服务连接起来，自动执行任务、数据同步、通知、集成 AI 模型等各种流程。
n8n 不仅能节省大量重复性工作，还能在团队内部构建稳定、安全的自动化体系。

### 🔑 核心功能亮点

| 功能               | 说明                                                               |
| ---------------- | ---------------------------------------------------------------- |
| 🧠 **可编程与可视化兼备** | 支持可视化拖拽节点，也能直接编写 JavaScript/Python 逻辑。                           |
| 🤖 **AI 原生支持**   | 内置 LangChain、OpenAI 接口，可搭建自定义 AI Agent 流程。                       |
| 🧩 **400+ 集成节点** | 支持 GitHub、Slack、MySQL、Redis、Google Sheets、Telegram、OpenAI 等常用服务。 |
| 🔐 **完全自托管**     | Fair-Code 许可协议，支持本地部署，数据完全掌控在自己手中。                               |
| 🧱 **企业级特性**     | 提供权限管理、SSO、离线部署（Air-gapped）等企业功能。                                |
| 🌍 **活跃社区生态**    | 超过 900+ 预制工作流模板，可快速复用。                                           |

> 简言之：**n8n = 可编程的 Zapier + 自主可控的 Airflow + AI 工作流引擎**。

---

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

## n8n Docker 镜像来源

你可以在 **轩辕镜像** 中找到官方同步的 n8n 镜像页面：
👉 [https://xuanyuan.cloud/r/n8nio/n8n](https://xuanyuan.cloud/r/n8nio/n8n)

镜像完全与官方 `docker.n8n.io/n8nio/n8n` 同步，支持快速拉取和国内加速。

---

## 下载 n8n 镜像

### 3.1 使用轩辕镜像拉取（推荐）

```bash
docker pull docker.xuanyuan.run/n8nio/n8n:latest
```

### 3.2 拉取后改名（标准命名方式）

```bash
docker pull docker.xuanyuan.run/n8nio/n8n:latest \
  && docker tag docker.xuanyuan.run/n8nio/n8n:latest n8nio/n8n:latest \
  && docker rmi docker.xuanyuan.run/n8nio/n8n:latest
```

说明：

* `docker pull`：从轩辕镜像源拉取镜像，访问表现快且稳定
* `docker tag`：重命名为官方标准名称，方便后续使用
* `docker rmi`：删除临时镜像标签，节省存储空间

### 3.3 官方方式（可选）

如果网络能直连官方服务器，可直接拉取：

```bash
docker pull n8nio/n8n:latest
```

### 3.4 验证镜像下载

```bash
docker images
```

出现类似输出即表示成功：

```
REPOSITORY     TAG       IMAGE ID       CREATED        SIZE
n8nio/n8n      latest    7b14ac9439f2   2 weeks ago    450MB
```

---

## 启动 n8n 容器

### 4.1 快速启动（适合初学者）

此方式使用默认配置与 SQLite 存储，开箱即用：

```bash
docker volume create n8n_data

docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  n8nio/n8n
```

启动成功后，访问浏览器：

```
http://localhost:5678
```

即可看到 n8n 的可视化工作流界面。

> 💡 数据将保存在名为 `n8n_data` 的 Docker 卷中，包含所有工作流、凭证与加密密钥。

---

### 4.2 持久化部署（推荐）

适合生产环境，挂载宿主机目录，保证配置与数据持久化。

#### 第一步：创建目录

```bash
mkdir -p /data/n8n/{data,files}
```

#### 第二步：启动容器

```bash
docker run -d --name n8n-web \
  -p 5678:5678 \
  -e TZ=Asia/Shanghai \
  -v /data/n8n/data:/home/node/.n8n \
  n8nio/n8n
```

说明：

| 参数                                  | 含义               |
| ----------------------------------- | ---------------- |
| `-v /data/n8n/data:/home/node/.n8n` | 挂载数据目录，防止重启丢失工作流 |
| `-e TZ=Asia/Shanghai`               | 设置时区为北京时间        |
| `-p 5678:5678`                      | 映射本地端口           |

---

### 4.3 开启公网隧道（测试 Webhook）

Webhook 需要公网访问时，可使用内置的 tunnel 功能（仅限开发测试）：

```bash
docker run -it --rm \
  --name n8n-tunnel \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  n8nio/n8n start --tunnel
```

⚠️ **注意**：tunnel 模式仅供测试，不应在生产环境使用。

---

## 与 PostgreSQL 配合使用（高级部署）

默认 n8n 使用 SQLite，可切换为 PostgreSQL 以获得更高性能和数据安全性。

### 5.1 启动 PostgreSQL（示例）

```bash
docker run -d \
  --name n8n-postgres \
  -e POSTGRES_USER=n8n \
  -e POSTGRES_PASSWORD=123456 \
  -e POSTGRES_DB=n8n \
  -v /data/postgres:/var/lib/postgresql/data \
  postgres:15
```

### 5.2 启动 n8n 并连接数据库

```bash
docker run -d --name n8n-db \
  -p 5678:5678 \
  -e DB_TYPE=postgresdb \
  -e DB_POSTGRESDB_DATABASE=n8n \
  -e DB_POSTGRESDB_HOST=n8n-postgres \
  -e DB_POSTGRESDB_PORT=5432 \
  -e DB_POSTGRESDB_USER=n8n \
  -e DB_POSTGRESDB_PASSWORD=123456 \
  -v /data/n8n/data:/home/node/.n8n \
  --link n8n-postgres \
  n8nio/n8n
```

---

## 使用 Docker Compose 一键部署

适合长期运行与团队协作环境。

### 6.1 创建 docker-compose.yml

```yaml
version: '3.8'
services:
  postgres:
    image: xxx.xuanyuan.run/postgres:15
    container_name: n8n-postgres
    environment:
      POSTGRES_USER: n8n
      POSTGRES_PASSWORD: 123456
      POSTGRES_DB: n8n
    volumes:
      - ./postgres:/var/lib/postgresql/data
    restart: always

  n8n:
    image: xxx.xuanyuan.run/n8nio/n8n:latest
    container_name: n8n-service
    ports:
      - "5678:5678"
    environment:
      DB_TYPE: postgresdb
      DB_POSTGRESDB_HOST: n8n-postgres
      DB_POSTGRESDB_PORT: 5432
      DB_POSTGRESDB_DATABASE: n8n
      DB_POSTGRESDB_USER: n8n
      DB_POSTGRESDB_PASSWORD: 123456
      GENERIC_TIMEZONE: Asia/Shanghai
      TZ: Asia/Shanghai
    volumes:
      - ./n8n_data:/home/node/.n8n
    depends_on:
      - postgres
    restart: always
```

### 6.2 启动服务

```bash
docker compose up -d
```

查看状态：

```bash
docker compose ps
```

停止：

```bash
docker compose down
```

### 常见问题
```bash
No encryption key found - Auto-generating and saving to: /home/node/.n8n/config
No encryption kEy fOuNd - Auto-gEnerating and saving to: /home/Node/.n8n/config
Error:EACCES:permission denied,open'/home/node/.n8n/config'
```

这个报错的意思是权限不足。因为容器内的 n8n 进程是以 node 用户运行的，但宿主机上的 ./n8n_data 目录默认是用你当前系统用户创建的，这样就会导致容器内的 node 用户没有权限写入。

### 解决方法
```bash
sudo chown -R 1000:1000 ./n8n_data
sudo chmod -R 755 ./n8n_data
```
给这个目录一个权限就可以了，注意替换为你的目录哈。

---

## 升级与维护

### 7.1 拉取最新镜像

```bash
docker pull n8nio/n8n:latest
```

### 7.2 重启容器

```bash
docker stop n8n-web && docker rm n8n-web
docker run -d --name n8n-web -p 5678:5678 -v /data/n8n/data:/home/node/.n8n n8nio/n8n
```

或使用 Compose：

```bash
docker compose pull
docker compose down
docker compose up -d
```

> 更新前请务必备份 `/data/n8n/data` 目录，避免密钥丢失导致凭证无法解密。

---

## 常见问题

### 8.1 启动后网页打不开？

* 检查端口是否被占用：`netstat -tulnp | grep 5678`
* 检查容器日志：`docker logs n8n-web`
* 确认防火墙放行端口：`ufw allow 5678/tcp`

### 8.2 数据丢失？

请确认是否挂载了 `/home/node/.n8n` 数据卷。若该目录未持久化，重启后将丢失所有工作流。

### 8.3 如何修改时区？

在运行命令或 Compose 文件中增加：

```bash
-e TZ=Asia/Shanghai
-e GENERIC_TIMEZONE=Asia/Shanghai
```

### 8.4 密钥丢失导致无法解密？

如 `.n8n` 目录被误删，n8n 会生成新的密钥，旧凭证无法解密。
建议定期备份 `/data/n8n/data`。

---

## 验证运行状态

```bash
docker ps
```

若状态为 `Up`，表示运行成功。

访问浏览器：

```
http://服务器IP:5678
```

若能正常打开 n8n 界面并创建工作流，即部署成功 🎉。

---

## 🔚 结语

至此，你已掌握 **基于轩辕镜像的 n8n Docker 部署全流程** ——
从镜像拉取、快速部署、持久化挂载、数据库集成，到 Compose 管理与版本升级。

* **新手用户**：建议先使用 SQLite 快速启动熟悉界面
* **工程师/团队部署**：推荐 PostgreSQL + Docker Compose 架构
* **进阶应用**：结合 Redis、Webhook、AI 节点构建自动化系统

> 🚀 n8n 让自动化更智能、更自由，让每个开发者都能构建属于自己的「自托管 Zapier」。

