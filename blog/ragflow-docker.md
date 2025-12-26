---
id: 9
title: 🚀 RAGFlow Docker 部署全流程教程
slug: ragflow-docker
summary: 本文介绍开源下一代RAG系统RAGFlow的特点（检索增强生成、插件化设计等），详解其Docker部署前的软硬件准备、环境参数设置、镜像下载（含版本选择）、容器启动（含仓库克隆原因）、配置文件说明、搜索引擎切换及常见问题排查，助用户完成部署。
category: Docker,RAGFlow
tags: RAGFlow,docker,部署教程
image_name: infiniflow/ragflow
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-ragflow.png"
status: published
created_at: "2025-10-04 02:51:33"
updated_at: "2025-10-08 06:46:02"
---

# 🚀 RAGFlow Docker 部署全流程教程

> 本文介绍开源下一代RAG系统RAGFlow的特点（检索增强生成、插件化设计等），详解其Docker部署前的软硬件准备、环境参数设置、镜像下载（含版本选择）、容器启动（含仓库克隆原因）、配置文件说明、搜索引擎切换及常见问题排查，助用户完成部署。

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

## 0、RAGFlow 简介
RAGFlow 是开源的下一代 RAG（Retrieval-Augmented Generation）系统，它结合了搜索引擎（向量数据库/Elasticsearch/Infinity）和大语言模型（LLM），用于搭建企业级智能问答与知识库平台。

它的主要特点包括：
- 检索增强生成 (RAG)：支持全文检索 + 向量检索，提升模型回答的准确性。
- 插件化设计：可自由切换后端引擎（如 Elasticsearch、Infinity）。
- 灵活部署：支持 Docker 一键部署，提供 slim 版（轻量）和 full 版（带嵌入模型）。
- 应用场景：企业知识问答、智能客服、文档搜索、私有化 AI 助手。

👉 官方镜像仓库地址（轩辕镜像访问支持版）：https://xuanyuan.cloud/r/infiniflow/ragflow


## 1、部署前准备（Prerequisites）
在部署 RAGFlow 前，建议满足以下硬件与软件环境：
- CPU：≥ 4 核
- 内存：≥ 16 GB
- 硬盘：≥ 50 GB
- Docker：版本 ≥ 24.0.0
- Docker Compose：版本 ≥ v2.26.1

额外注意事项：
- 确保 vm.max_map_count ≥ 262144（Elasticsearch / Infinity 需要此参数，否则启动报错）。
- 如果还未安装 Docker，请先参考 Docker 官方安装文档。


## 2、环境参数设置
### 2.1 检查 vm.max_map_count
```bash
sysctl vm.max_map_count
```

如果返回值小于 262144，需要执行：
```bash
sudo sysctl -w vm.max_map_count=262144
```

该设置会在重启后失效，如需永久生效，请修改 `/etc/sysctl.conf`，加入：
```
vm.max_map_count=262144
```
并运行 `sudo sysctl -p` 使配置生效。


## 3、下载 RAGFlow 镜像
### 3.1 使用轩辕镜像拉取（推荐）
```bash
docker pull docker.xuanyuan.run/infiniflow/ragflow:v0.15.0-slim
```

### 3.2 拉取后改名
```bash
docker pull docker.xuanyuan.run/infiniflow/ragflow:v0.15.0-slim \
&& docker tag docker.xuanyuan.run/infiniflow/ragflow:v0.15.0-slim infiniflow/ragflow:v0.15.0-slim \
&& docker rmi docker.xuanyuan.run/infiniflow/ragflow:v0.15.0-slim
```

### 3.3 免登录方式拉取
```bash
docker pull xxx.xuanyuan.run/infiniflow/ragflow:v0.15.0-slim
```

### 3.4 官方直连（若能访问 DockerHub）
```bash
docker pull infiniflow/ragflow:v0.15.0-slim
```

### 3.5 镜像版本选择
| 版本             | 大小   | 是否包含嵌入模型 | 稳定性 |
|------------------|--------|------------------|--------|
| v0.15.0          | ≈9GB   | ✅                | 稳定   |
| v0.15.0-slim     | ≈2GB   | ❌                | 稳定   |
| nightly          | ≈9GB   | ✅                | 不稳定 |
| nightly-slim     | ≈2GB   | ❌                | 不稳定 |

👉 建议：
- 初学者使用 v0.15.0-slim（轻量版本）。
- 高级工程师或需要内置 embedding 的，使用 v0.15.0。


## 4、启动 RAGFlow
### 4.1 克隆官方仓库
```bash
git clone https://github.com/infiniflow/ragflow.git
cd ragflow
```

🚀 为什么需要克隆官方仓库？
1. Docker 镜像只包含可运行环境和服务代码：镜像里是 RAGFlow 的服务端应用本身，但未提供 docker-compose 配置文件、环境变量模板、服务配置文件。
2. 克隆仓库是为了获取配置模板和启动脚本：
   - 仓库里的 `docker/docker-compose.yml` 定义了 RAGFlow 的多容器架构（ragflow-server 主服务、mysql 数据库、minio 对象存储、elasticsearch 文档与向量存储）。
   - `.env` 文件里有默认的环境变量（端口、密码、镜像版本号等）。
   - `service_conf.yaml.template` 提供了 LLM 接口等可配置参数。
   - 👉 这些文件要么自己手写，要么直接用官方模板，更省事。
3. 启动逻辑依赖 docker-compose 文件：单独 `docker run` 只能启动一个容器，而 RAGFlow 至少还需数据库和存储；官方 `docker-compose.yml` 编排好所有服务，可一键启动。

### 4.2 启动容器
```bash
docker compose -f docker/docker-compose.yml up -d
```

### 4.3 查看启动日志
```bash
docker logs -f ragflow-server
```

若看到以下信息，说明启动成功：
```
* Running on all addresses (0.0.0.0)
* Running on http://127.0.0.1:9380
* Running on http://<服务器IP>:9380
```

### 4.4 访问 Web 页面
在浏览器中输入：`http://<服务器IP>`  
默认运行在 80 端口，无需写端口号。


## 5、配置文件说明
RAGFlow 的配置文件主要有 3 个：
1. `.env`：设置系统参数（如端口、MySQL 密码、MinIO 密码）。
2. `service_conf.yaml.template`：配置 LLM 工厂（如 OpenAI、Azure、Claude），设置 API_KEY。
3. `docker-compose.yml`：管理容器服务（Web、DB、存储、搜索引擎）；修改端口映射时，可将 `80:80` 改为 `8080:80` 之类。

修改配置后需要重启：
```bash
docker compose -f docker/docker-compose.yml up -d
```


## 6、搜索引擎切换（Elasticsearch ↔ Infinity）
默认使用 Elasticsearch。如需切换到 Infinity：
1. 停止容器：
   ```bash
   docker compose -f docker/docker-compose.yml down -v
   ```
2. 修改 `.env`：
   ```
   DOC_ENGINE=infinity
   ```
3. 重新启动：
   ```bash
   docker compose -f docker/docker-compose.yml up -d
   ```

⚠️ 注意：Infinity 在 Linux/arm64 暂不支持。


## 7、常见问题排查（FAQ）
### 7.1 无法访问网页？
- 防火墙：开放 80、443 端口。
- 端口占用：检查 `netstat -tuln | grep 80`。

### 7.2 浏览器提示网络错误？
启动后需等待初始化完成，请先执行：
```bash
docker logs -f ragflow-server
```
确认系统已正常启动。

### 7.3 如何修改访问端口？
编辑 `docker-compose.yml`：
```yaml
ports:
  - "8080:80"
```
然后重启容器。

### 7.4 如何设置 API Key？
编辑 `service_conf.yaml.template`，配置：
```yaml
user_default_llm: openai
openai:
  API_KEY: "你的OpenAI API Key"
```
然后重启。


## 结尾
至此，你已经完成了 RAGFlow 的 Docker 部署！  
通过本文你学会了：
- RAGFlow 的作用与镜像版本选择；
- 如何用「轩辕镜像」加速拉取 RAGFlow 镜像；
- Docker Compose 一键启动；
- 修改配置文件（端口、API Key、搜索引擎）；
- 常见问题排查思路。

👉 对初学者：建议先使用 slim 版熟悉流程；  
👉 对高级工程师：可尝试切换 Infinity，或结合 Nginx/SSL 反向代理进行生产部署。

