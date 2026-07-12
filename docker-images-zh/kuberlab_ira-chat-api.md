---
image: kuberlab/ira-chat-api
description: "ira-chat-api 是一个基于 Python 的聊天 API 服务，需配合 PostgreSQL 数据库，集成 OpenAI 和 Pinecone 向量存储，支持 LLM 模型（如 gpt-3.5-turbo），提供 Swagger 文档，适用于构建智能聊天应用。"
source: https://xuanyuan.cloud/zh/r/kuberlab/ira-chat-api
canonical: https://xuanyuan.cloud/zh/r/kuberlab/ira-chat-api
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kuberlab/ira-chat-api" title="kuberlab/ira-chat-api Docker 镜像中文简介、标签列表与拉取命令">kuberlab/ira-chat-api 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ira-chat-api 镜像文档

## 镜像概述

ira-chat-api 是一个基于 Python 的聊天 API 服务，旨在提供集成 AI 能力的聊天功能。该服务依赖 PostgreSQL 数据库进行数据存储，集成 OpenAI API 用于 LLM 模型调用，并通过 Pinecone 向量存储实现向量数据管理，适用于构建智能聊天应用、问答系统等场景。

## 核心功能与特性

- **数据库集成**：依赖 PostgreSQL 数据库存储组织、域名等核心数据
- **AI 能力集成**：支持通过 OpenAI API 调用 LLM 模型（如 gpt-3.5-turbo）
- **向量存储支持**：集成 Pinecone 向量存储，用于向量数据的存储与检索
- **组织与域名管理**：支持创建组织及关联域名，实现基于域名的访问控制
- **调试功能**：提供数据库调试（DEBUG_DB）和 Prompt 调试（DEBUG_PROMPT）模式
- **API 文档**：内置 Swagger 文档，便于 API 调试与集成

## 使用场景

- 构建智能聊天机器人应用
- 企业内部智能问答系统
- 需要 LLM 模型与向量存储结合的 AI 应用开发
- 快速部署具备聊天能力的后端服务

## 使用方法与配置说明

### 环境要求

- 需提前准备 PostgreSQL 数据库（本地或远程），并创建名为 `ira` 的数据库
- 需获取 OpenAI API 密钥、HuggingFace API 密钥（如使用相关服务）及 Pinecone API 密钥

### 环境变量配置

以下环境变量为服务运行必需，需根据实际情况配置：

| 环境变量                | 说明                                                                 |
|-------------------------|----------------------------------------------------------------------|
| `PGHOST`                | PostgreSQL 数据库主机地址                                            |
| `PGUSER`                | PostgreSQL 数据库用户名                                              |
| `PGPASSWORD`            | PostgreSQL 数据库密码                                                |
| `PGDATABASE`            | PostgreSQL 数据库名称（通常为 `ira`）                                |
| `OPENAI_API_KEY`        | OpenAI API 密钥，用于调用 LLM 模型                                   |
| `HUGGINGFACE_API_KEY`   | HuggingFace API 密钥（如使用相关模型或服务）                         |
| `AUTH_KEY`              | 管理员授权密钥，用于安全访问                                         |
| `BASE_URL`              | 服务基础 URL（如 `http://localhost:8083`）                           |
| `VECTORSTORE`           | 向量存储类型（当前支持 `pinecone`）                                  |
| `ENV_PREFIX`            | 环境前缀（如 `local`）                                                |
| `PINECONE_ENVIRONMENT`  | Pinecone 环境（如 `asia-southeast1-gcp`）                             |
| `PINECONE_API_KEY`      | Pinecone API 密钥                                                    |
| `PINECONE_INDEX`        | Pinecone 索引名称                                                    |
| `LLM_MODEL_NAME`        | LLM 模型名称（如 `gpt-3.5-turbo`）                                   |
| `ENGINE_TYPE`           | LLM 引擎类型（当前支持 `langchain`）                                 |

### Docker 部署示例

通过 Docker 快速部署服务，需替换以下命令中的环境变量值为实际配置：

```bash
docker run -it --rm \
  -e PGHOST=<PostgreSQL主机地址> \
  -e PGUSER=<PostgreSQL用户名> \
  -e PGPASSWORD=<PostgreSQL密码> \
  -e PGDATABASE=ira \
  -e OPENAI_API_KEY=<你的OpenAI API密钥> \
  -e HUGGINGFACE_API_KEY=<你的HuggingFace API密钥> \
  -e AUTH_KEY=<随机管理员密钥> \
  -e BASE_URL=http://localhost:8083 \
  -e VECTORSTORE=pinecone \
  -e PINECONE_ENVIRONMENT=<Pinecone环境> \
  -e PINECONE_API_KEY=<Pinecone API密钥> \
  -e PINECONE_INDEX=<Pinecone索引名称> \
  -e LLM_MODEL_NAME=gpt-3.5-turbo \
  -e ENGINE_TYPE=langchain \
  kuberlab/ira-chat-api:latest
```

### 首次访问前准备

服务首次运行前，需在 PostgreSQL 数据库中创建初始组织及域名：

1. 登录 PostgreSQL 数据库：
   ```bash
   psql -h <PGHOST> -U <PGUSER> -d ira
   ```

2. 执行 SQL 命令创建组织：
   ```sql
   INSERT INTO organizations (name, display_name, created_at, updated_at) VALUES ('my-local-org', 'my-local-org', now(), now());
   ```

3. 关联域名到组织：
   ```sql
   INSERT INTO organization_domains (domain, org_id) VALUES ('my-local-org.localhost', (SELECT id FROM organizations WHERE name = 'my-local-org'));
   ```

4. 配置本地 hosts 文件（仅本地访问需配置）：
   在 `/etc/hosts` 文件中添加：
   ```
   127.0.0.1 my-local-org.localhost
   ```

### 服务访问

- API 服务地址：`http://localhost:8083`
- 组织 API 地址：`http://<组织域名>:8083`（如 `http://my-local-org.localhost:8083`）
- Swagger 文档地址：`http://localhost:8083/docs`

### 调试模式

#### 数据库调试模式
启动服务时添加 `DEBUG_DB=true` 环境变量，开启数据库调试：
```bash
docker run -it --rm -e DEBUG_DB=true [其他环境变量] kuberlab/ira-chat-api:latest
```

#### Prompt 调试模式
启动服务时添加 `DEBUG_PROMPT=true` 环境变量，开启 Prompt 调试：
```bash
docker run -it --rm -e DEBUG_PROMPT=true [其他环境变量] kuberlab/ira-chat-api:latest
