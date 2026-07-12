---
image: mcp/elasticsearch
description: "通过自然语言对话与Elasticsearch索引进行交互"
source: https://xuanyuan.cloud/zh/r/mcp/elasticsearch
canonical: https://xuanyuan.cloud/zh/r/mcp/elasticsearch
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/elasticsearch" title="mcp/elasticsearch Docker 镜像中文简介、标签列表与拉取命令">mcp/elasticsearch 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Elasticsearch MCP Server 镜像文档


## 1. 镜像概述与主要用途

Elasticsearch MCP Server 是一个基于 Model Context Protocol (MCP) 的 Docker 镜像，主要用途是通过自然语言对话与 Elasticsearch 索引进行交互。用户无需直接编写查询语句，可通过自然语言输入实现对 Elasticsearch 索引的查询、映射获取、分片信息查看等操作，简化与 Elasticsearch 的交互流程。


## 2. 核心功能与特性

### 2.1 基本特性

| 属性                 | 详情                                                                 |
|----------------------|----------------------------------------------------------------------|
| **Docker 镜像**      | [mcp/elasticsearch](https://hub.docker.com/repository/docker/mcp/elasticsearch) |
| **作者**             | [elastic](https://github.com/elastic)                               |
| **代码仓库**         | https://github.com/elastic/mcp-server-elasticsearch                 |
| **Dockerfile**       | https://github.com/elastic/mcp-server-elasticsearch/blob/v0.4.0/Dockerfile |
| **镜像构建方**       | Docker Inc.                                                          |
| **Docker Scout 健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/elasticsearch) |
| **验证签名**         | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/elasticsearch --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
| **许可证**           | Apache License 2.0                                                   |


### 2.2 提供的工具

该镜像提供以下 5 种工具，用于与 Elasticsearch 交互：

| 工具名称         | 简短描述                     |
|------------------|------------------------------|
| `esql`           | Elasticsearch ES|QL 查询     |
| `get_mappings`   | 获取 ES 索引映射             |
| `get_shards`     | 获取 ES 分片信息             |
| `list_indices`   | 列出 ES 索引                 |
| `search`         | Elasticsearch 搜索 DSL 查询  |


## 3. 使用场景与适用范围

### 适用场景
- 开发者通过自然语言快速查询 Elasticsearch 索引数据，无需手动编写 ESQL 或搜索 DSL。
- 数据分析师需要获取索引结构（如映射）、分片状态等元数据时，简化操作流程。
- 集成到支持 MCP 的 AI 应用（如 Anthropic Claude Desktop）中，作为自然语言与 Elasticsearch 交互的中间层。

### 适用人群
- Elasticsearch 开发者
- 数据分析师
- AI 应用集成工程师


## 4. 使用方法与配置说明

### 4.1 环境变量配置

运行镜像前需配置以下环境变量：

| 环境变量       | 描述                          | 默认值              | 是否必填 |
|----------------|-------------------------------|---------------------|----------|
| `ES_URL`       | Elasticsearch 服务访问 URL    | `http://localhost:9200` | 是       |
| `ES_API_KEY`   | 访问 Elasticsearch 的 API 密钥 | -                   | 是       |


### 4.2 Docker 运行命令示例

通过以下命令启动容器，以标准输入输出（stdio）模式运行：

```bash
docker run -i --rm \
  -e ES_URL="http://localhost:9200" \
  -e ES_API_KEY="your-api-key" \
  docker.xuanyuan.run/mcp/elasticsearch stdio
```

**参数说明**：
- `-i`：保持标准输入打开，支持交互模式。
- `--rm`：容器退出后自动删除，避免残留。
- `-e`：设置环境变量（`ES_URL` 和 `ES_API_KEY`）。
- `stdio`：指定 MCP 服务器以标准输入输出模式运行，用于与外部应用通信。


### 4.3 MCP 配置示例

在支持 MCP 的应用（如 Docker Compose 或 AI 应用配置）中，可通过以下 JSON 配置集成该镜像：

```json
{
  "mcpServers": {
    "elasticsearch": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "ES_URL",
        "-e",
        "ES_API_KEY",
        "mcp/elasticsearch",
        "stdio"
      ],
      "env": {
        "ES_URL": "http://localhost:9200",
        "ES_API_KEY": "your-api-key"
      }
    }
  }
}
```


## 5. 工具详细说明

### 5.1 `esql`
**功能**：执行 Elasticsearch ES|QL 查询。

| 参数名   | 类型     | 描述                          |
|----------|----------|-------------------------------|
| `query`  | `string` | 完整的 Elasticsearch ES|QL 查询语句 |

*该工具为只读，不会修改环境。*


### 5.2 `get_mappings`
**功能**：获取指定 Elasticsearch 索引的字段映射。

| 参数名   | 类型     | 描述                          |
|----------|----------|-------------------------------|
| `index`  | `string` | 需获取映射的 Elasticsearch 索引名称 |

*该工具为只读，不会修改环境。*


### 5.3 `get_shards`
**功能**：获取所有或指定索引的分片信息。

| 参数名   | 类型     | 描述                          |
|----------|----------|-------------------------------|
| `index`  | `string`（可选） | 可选，需获取分片信息的索引名称 |

*该工具为只读，不会修改环境。*


### 5.4 `list_indices`
**功能**：列出所有可用的 Elasticsearch 索引。

| 参数名         | 类型     | 描述                          |
|----------------|----------|-------------------------------|
| `index_pattern`| `string` | 用于筛选索引的模式（如 `log-*`） |

*该工具为只读，不会修改环境。*


### 5.5 `search`
**功能**：通过提供的查询 DSL 执行 Elasticsearch 搜索。

| 参数名       | 类型     | 描述                          |
|--------------|----------|-------------------------------|
| `index`      | `string` | 需搜索的 Elasticsearch 索引名称 |
| `query_body` | `object` | 完整的 Elasticsearch 查询 DSL 对象（可包含 query、size、from、sort 等） |
| `fields`     | `array`（可选） | 需返回的字段列表（可选） |

*该工具为只读，不会修改环境。*


## 6. 安全与验证

### 6.1 镜像签名验证

通过以下命令验证镜像签名，确保镜像完整性：

```bash
COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/elasticsearch --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub
```

### 6.2 为什么使用 Docker 运行更安全？

Docker 容器提供隔离环境，限制 MCP 服务器对主机系统的访问，降低潜在安全风险。详情参考：[为什么使用 Docker 运行 MCP 服务器更安全？](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)


## 7. 许可证

本镜像基于 Apache License 2.0 许可证开源，详情参见 [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)。
