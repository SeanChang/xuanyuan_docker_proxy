---
image: mcp/postgres
description: "提供PostgreSQL数据库的只读访问，使LLMs能够检查数据库的服务器。"
source: https://xuanyuan.cloud/zh/r/mcp/postgres
canonical: https://xuanyuan.cloud/zh/r/mcp/postgres
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/postgres" title="mcp/postgres Docker 镜像中文简介、标签列表与拉取命令">mcp/postgres 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PostgreSQL只读(已归档)MCP服务器

## 镜像概述和主要用途

提供对PostgreSQL数据库的只读访问。该服务器允许大型语言模型(LLMs)检查数据库模式并执行只读查询。

> 关于MCP服务器的更多信息，请参见：[什么是MCP服务器？](https://www.anthropic.com/news/model-context-protocol)

## 核心功能和特性

- 提供只读SQL查询执行能力
- 通过Docker容器化部署，确保安全性
- 支持配置环境变量连接到PostgreSQL数据库
- 提供`query`工具执行SQL查询

## 使用场景和适用范围

- 允许AI模型(如Claude)安全地访问PostgreSQL数据库
- 为LLM提供数据库模式检查能力
- 支持AI应用程序执行只读SQL查询分析数据
- 适用于需要AI辅助数据分析但需限制写权限的场景

## 详细特性

| 属性 | 详情 |
|------|------|
| **Docker镜像** | [mcp/postgres](https://hub.docker.com/repository/docker/mcp/postgres) |
| **作者** | [modelcontextprotocol](https://github.com/modelcontextprotocol) |
| **代码仓库** | https://github.com/modelcontextprotocol/servers |
| **Dockerfile** | https://github.com/modelcontextprotocol/servers/blob/2025.4.24/src/postgres/Dockerfile |
| **Docker镜像构建者** | Docker Inc. |
| **Docker Scout健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/postgres) |
| **验证签名** | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/postgres --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
| **许可证** | MIT许可证 |

## 可用工具 (1)

| 服务器提供的工具 | 简短描述 |
|------------------|----------|
| `query` | 运行只读SQL查询 |

## 工具详情

### 工具: **`query`**

运行只读SQL查询

| 参数 | 类型 | 描述 |
|------|------|------|
| `sql` | `string` *可选* | SQL查询字符串 |

## 使用方法和配置说明

### Docker部署示例

```json
{
  "mcpServers": {
    "postgres": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "POSTGRES_URL",
        "mcp/postgres",
        "$POSTGRES_URL"
      ],
      "env": {
        "POSTGRES_URL": "postgresql://host.docker.internal:5432/mydb"
      }
    }
  }
}
```

### 环境变量配置

| 环境变量 | 描述 | 示例值 |
|----------|------|--------|
| `POSTGRES_URL` | PostgreSQL数据库连接URL | `postgresql://host.docker.internal:5432/mydb` |

### 为什么使用Docker运行MCP服务器更安全？

了解更多信息：[为什么使用Docker运行MCP服务器更安全？](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)
