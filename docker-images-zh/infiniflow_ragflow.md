---
image: infiniflow/ragflow
description: "RAGFlow是一款开源检索增强生成（RAG）引擎，它集成高效信息检索与智能内容生成能力，支持文本、文档等多模态数据处理，可灵活对接企业私有知识库，帮助用户快速构建精准问答、智能创作等AI应用，具备轻量化部署特性与友好的开发者接口，为企业及个人提供低成本、高可定制的知识增强解决方案。"
source: https://xuanyuan.cloud/zh/r/infiniflow/ragflow
canonical: https://xuanyuan.cloud/zh/r/infiniflow/ragflow
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/infiniflow/ragflow" title="infiniflow/ragflow Docker 镜像中文简介、标签列表与拉取命令">infiniflow/ragflow — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/infiniflow/ragflow" title="infiniflow/ragflow Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/infiniflow/ragflow</a>

# RAGFlow 部署与使用指南


## 关于 RAGFlow
RAGFlow 是一款基于检索增强生成（RAG）技术的工具，支持文档处理与智能问答。以下是其部署步骤、配置说明及使用要点。


## 前置条件
部署前需确保环境满足以下要求：
- CPU 核心数 ≥ 4
- 内存 ≥ 16 GB
- 磁盘空间 ≥ 50 GB
- Docker 版本 ≥ 24.0.0 且 Docker Compose 版本 ≥ v2.26.1  
  ⚠️ 若未安装 Docker，可参考 [Docker 官方安装文档]([])。


## 启动服务器

### 步骤 1：检查并设置 `vm.max_map_count`
确保系统参数 `vm.max_map_count` ≥ 262144：  
- 查看当前值：  
  ```bash
  $ sysctl vm.max_map_count
  ```  
- 若不满足，临时调整（重启后失效）：  
  ```bash
  $ sudo sysctl -w vm.max_map_count=262144
  ```  
- 永久生效：编辑 `/etc/sysctl.conf`，添加或修改：  
  ```bash
  vm.max_map_count=262144
  ```  


### 步骤 2：克隆代码仓库
```bash
$ git clone [] 步骤 3：通过 Docker 镜像启动服务
默认使用 `v0.15.0-slim` 版本镜像。如需指定其他版本，需先修改 `docker/.env` 文件中的 `RAGFLOW_IMAGE` 变量（如 `RAGFLOW_IMAGE=infiniflow/ragflow:v0.14.1` 对应完整版）。  

启动命令：  
```bash
$ cd ragflow
$ docker compose -f docker/docker-compose.yml up -d
```

#### 镜像版本说明
| RAGFlow 镜像标签 | 镜像大小 (GB) | 是否包含嵌入模型 | 稳定性          |
|------------------|---------------|------------------|-----------------|
| v0.15.0          | ≈9            | ✅                | 稳定版本        |
| v0.15.0-slim     | ≈2            | ❌                | 稳定版本        |
| nightly          | ≈9            | ✅                | ⚠️ 不稳定 nightly 构建 |
| nightly-slim     | ≈2            | ❌                | ⚠️ 不稳定 nightly 构建 |


### 步骤 4：验证服务启动状态
查看服务日志确认启动成功：  
```bash
$ docker logs -f ragflow-server
```  
成功启动会显示类似以下内容：  
```
     ____   ___    ______ ______ __               
    / __ \ /   |  / ____// ____// /____  _      __
   / /_/ // /| | / / __ / /_   / // __ \| | /| / /
  / _, _// ___ |/ /_/ // __/  / // /_/ /| |/ |/ / 
 /_/ |_|/_/  |_|\____//_/    /_/ \____/ |__/|__/ 

* Running on all addresses (0.0.0.0)
* Running on [] Running on [] CTRL+C to quit
```  
⚠️ 若未确认日志直接登录，可能因服务未完全初始化导致浏览器提示“网络异常”。


### 步骤 5：登录系统
在浏览器中输入服务器 IP 地址（默认端口 80 可省略，如 `[] RAGFlow。


### 步骤 6：配置 LLM API 密钥
编辑 `docker/service_conf.yaml.template` 文件：  
- 在 `user_default_llm` 中选择所需的 LLM 厂商；  
- 在对应厂商的 `API_KEY` 字段填入 API 密钥。  
详细配置可参考 [LLM API 密钥设置文档]([])。  

至此，RAGFlow 已可正常使用。


## 配置说明
系统配置主要通过以下文件管理：

### 核心配置文件
1. **`docker/.env`**  
   存储基础设置，如 `SVR_HTTP_PORT`（服务端口）、`MYSQL_PASSWORD`（数据库密码）、`MINIO_PASSWORD`（对象存储密码）等。  

2. **`docker/service_conf.yaml.template`**  
   配置后端服务，容器启动时会自动填充环境变量，可根据部署环境自定义服务行为。  

3. **`docker/docker-compose.yml`**  
   系统启动依赖的 Docker Compose 配置文件。  


### 修改默认 HTTP 端口
默认 HTTP 服务端口为 80，如需修改：  
1. 编辑 `docker-compose.yml`，将 `80:80` 改为 `<自定义端口>:80`；  
2. 重启容器使配置生效：  
   ```bash
   $ docker compose -f docker/docker-compose.yml up -d
   ```  


## 切换文档引擎（Elasticsearch → Infinity）
RAGFlow 默认使用 Elasticsearch 存储全文与向量数据，可切换为 [Infinity]([])：  

### 切换步骤
1. 停止现有容器：  
   ```bash
   $ docker compose -f docker/docker-compose.yml down -v
   ```  
2. 编辑 `docker/.env`，设置 `DOC_ENGINE=infinity`；  
3. 重启容器：  
   ```bash
   $ docker compose -f docker/docker-compose.yml up -d
   ```  

⚠️ 注意：Linux/arm64 架构机器暂不支持切换至 Infinity。


> 更多配置细节可参考 `docker/README.md`，其中详细说明环境变量及服务配置项（可作为 `${ENV_VARS}` 在 `service_conf.yaml.template` 中引用）。
