---
image: mcp/context7
description: "Context7 MCP Server是为大型语言模型和AI代码编辑器提供最新代码文档的服务器。"
source: https://xuanyuan.cloud/zh/r/mcp/context7
canonical: https://xuanyuan.cloud/zh/r/mcp/context7
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/context7" title="mcp/context7 Docker 镜像中文简介、标签列表与拉取命令">mcp/context7 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Context7 MCP Server

## 镜像概述和主要用途

Context7 MCP Server - 为LLMs和AI代码编辑器提供最新的代码文档。

[什么是MCP Server？](https://www.anthropic.com/news/model-context-protocol)

## 核心功能和特性

### 基本信息

| 属性 | 详情 |
|------|------|
| **Docker镜像** | [mcp/context7](https://hub.docker.com/repository/docker/mcp/context7) |
| **作者** | [upstash](https://github.com/upstash) |
| **代码仓库** | https://github.com/upstash/context7 |
| **Dockerfile** | https://github.com/upstash/context7/blob/f2f367d8913843bd28b2a96a6ce860f43e3fc3ca/Dockerfile |
| **Docker镜像构建者** | Docker Inc. |
| **Docker Scout健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/context7) |
| **验证签名** | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/context7 --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
| **许可证** | MIT License |

### 可用工具

| 服务器提供的工具 | 简要说明 |
|----------------|----------|
| `get-library-docs` | 获取库的最新文档。 |
| `resolve-library-id` | 将包/产品名称解析为Context7兼容的库ID，并返回匹配库的列表。 |

## 工具详情

### 工具：**`get-library-docs`**

获取库的最新文档。您必须先调用'resolve-library-id'以获取使用此工具所需的确切Context7兼容库ID，除非用户在其查询中明确提供'/org/project'或'/org/project/version'格式的库ID。

| 参数 | 类型 | 描述 |
|------|------|------|
| `context7CompatibleLibraryID` | `string` | 确切的Context7兼容库ID（例如，'/mongodb/docs'、'/vercel/next.js'、'/supabase/supabase'、'/vercel/next.js/v14.3.0-canary.87'），从'resolve-library-id'获取或直接从用户查询中获取，格式为'/org/project'或'/org/project/version'。 |
| `tokens` | `number` *可选* | 要检索的文档的最大令牌数（默认值：10000）。值越高提供的上下文越多，但消耗的令牌也越多。 |
| `topic` | `string` *可选* | 要关注的文档主题（例如，'hooks'、'routing'）。 |

### 工具：**`resolve-library-id`**

将包/产品名称解析为Context7兼容的库ID，并返回匹配库的列表。

除非用户在其查询中明确提供'/org/project'或'/org/project/version'格式的库ID，否则您必须在调用'get-library-docs'之前调用此函数以获取有效的Context7兼容库ID。

#### 选择过程：
1. 分析查询以了解用户正在寻找的库/包
2. 基于以下因素返回最相关的匹配：
   - 与查询的名称相似性（优先考虑完全匹配）
   - 与查询意图的描述相关性
   - 文档覆盖率（优先考虑代码片段数量较高的库）
   - 信任分数（考虑分数为7-10的库更具权威性）

#### 响应格式：
- 在明确标记的部分中返回所选的库ID
- 提供选择此库的简要解释
- 如果存在多个良好匹配，确认这一点但继续使用最相关的一个
- 如果没有良好匹配，明确说明并建议查询改进

对于模糊查询，在进行最佳猜测匹配之前请求澄清。

| 参数 | 类型 | 描述 |
|------|------|------|
| `libraryName` | `string` | 要搜索并检索Context7兼容库ID的库名称。 |

## 使用场景和适用范围

Context7 MCP Server适用于需要为LLMs（大型语言模型）和AI代码编辑器提供最新代码文档的场景，特别是在以下情况：

1. AI辅助编程：为AI代码编辑器提供准确、最新的库文档
2. 开发人员工具集成：在开发环境中集成实时文档查询功能
3. LLM应用开发：构建需要访问最新技术文档的AI应用程序
4. 自动化文档检索：为各种开发工作流自动获取库文档

## 详细的使用方法和配置说明

### Docker运行示例

```json
{
  "mcpServers": {
    "context7": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "mcp/context7"
      ]
    }
  }
}
```

### Docker命令行部署

可以使用以下命令直接从Docker Hub拉取并运行Context7 MCP Server：

```bash
docker run -i --rm docker.xuanyuan.run/mcp/context7
```

参数说明：
- `-i`: 交互式运行，保持标准输入打开
- `--rm`: 容器退出后自动删除容器

### 为什么使用Docker运行MCP Server更安全？

[为什么使用Docker运行MCP Server更安全？](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)

Docker容器提供了隔离环境，确保MCP Server在受控环境中运行，减少安全风险和系统资源冲突。
