---
image: langflowai/langflow
description: "Langflow是用于RAG和多智能体AI应用的低代码应用构建器。"
source: https://xuanyuan.cloud/zh/r/langflowai/langflow
canonical: https://xuanyuan.cloud/zh/r/langflowai/langflow
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/langflowai/langflow" title="langflowai/langflow Docker 镜像中文简介、标签列表与拉取命令">langflowai/langflow — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/langflowai/langflow" title="langflowai/langflow Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/langflowai/langflow</a>

# Langflow Docker镜像文档


## 1. 镜像概述与主要用途

Langflow 是一款面向 RAG（检索增强生成）和多智能体 AI 应用的低代码构建工具。该 Docker 镜像封装了 Langflow 平台的核心功能，旨在通过可视化界面简化 AI 应用的开发、迭代与部署流程。用户可通过拖拽组件并连接流程，快速构建复杂的 AI 应用，无需深入编写底层代码。


## 2. 核心功能与特性

### 2.1 可视化编程界面
提供直观的拖拽式界面，支持组件连接与流程编排，无需手动编码即可构建 AI 应用逻辑。

### 2.2 CLI 与 API 支持
内置完整的命令行接口（CLI）和应用程序接口（API），支持自动化部署与高级管理操作。

### 2.3 可扩展性
支持导入或创建自定义组件，灵活扩展平台功能以满足特定业务需求。

### 2.4 部署就绪
简化部署流程，支持在 Google Cloud Platform、Railway、Render 等主流平台快速部署。


## 3. 使用场景与适用范围

### 3.1 RAG 应用开发
适用于构建基于检索增强生成的应用，如智能文档问答、知识库检索系统等。

### 3.2 多智能体系统构建
支持设计多智能体协作流程，实现复杂任务自动化（如数据分析、客户服务机器人集群）。

### 3.3 AI 应用快速原型
低代码特性加速 AI 应用原型验证，帮助开发者快速迭代功能并验证业务逻辑。

### 3.4 低代码开发团队
适合需要平衡开发效率与功能复杂度的团队，降低 AI 应用开发门槛。


## 4. 使用方法与配置说明

### 4.1 镜像版本说明
- `latest`：对应官方 `main` 分支的最新稳定构建版本，包含已发布的最新功能与修复。


### 4.2 前提条件
- 已安装 Docker 环境（参考 [Docker 官方安装指南](https://docs.docker.com/engine/install/)）。
- 本地端口 `7860` 未被占用（或可通过端口映射调整）。


### 4.3 镜像拉取
通过以下命令拉取最新版本镜像：
```bash
docker pull langflowai/langflow:latest
```


### 4.4 启动容器
#### 4.4.1 基础运行命令
```bash
docker run -it --rm -p 7860:7860 langflowai/langflow:latest
```
- 参数说明：
  - `-it`：以交互模式运行容器，支持终端输入输出。
  - `--rm`：容器停止后自动删除，避免残留资源。
  - `-p 7860:7860`：端口映射，将容器内 7860 端口映射到本地 7860 端口（左侧为本地端口，右侧为容器内端口）。


#### 4.4.2 访问 Langflow
容器启动后，在浏览器中访问 `http://localhost:7860` 即可打开 Langflow 可视化界面。


### 4.5 Docker Compose 配置示例
如需通过 Docker Compose 管理容器（如持久化数据或集成其他服务），可创建 `docker-compose.yml` 文件：
```yaml
version: '3.8'

services:
  langflow:
    image: langflowai/langflow:latest
    container_name: langflow
    ports:
      - "7860:7860"  # 端口映射
    restart: unless-stopped  # 除非手动停止，否则自动重启
    # 如需持久化数据，可添加 volumes（需参考官方文档确认数据目录）
    # volumes:
    #   - ./langflow_data:/app/data
```
启动命令：`docker-compose up -d`  
停止命令：`docker-compose down`


## 5. 文档与社区支持

### 5.1 官方文档
完整使用指南与开发文档：[Langflow 官方文档](https://docs.langflow.org)

### 5.2 社区资源
- Discord 社区：[加入 Discord](https://discord.com/invite/EqksyE2EX9)（获取技术支持与交流）
- GitHub 仓库：[Langflow GitHub](https://github.com/langflow-ai/langflow)（提交 issue 或贡献代码）
