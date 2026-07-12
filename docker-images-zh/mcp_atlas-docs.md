---
image: mcp/atlas-docs
description: "为大型语言模型提供托管的、清晰的库和框架Markdown文档"
source: https://xuanyuan.cloud/zh/r/mcp/atlas-docs
canonical: https://xuanyuan.cloud/zh/r/mcp/atlas-docs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/atlas-docs" title="mcp/atlas-docs Docker 镜像中文简介、标签列表与拉取命令">mcp/atlas-docs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Atlas Docs MCP服务器

提供大型语言模型（LLMs）托管的、清晰的库和框架Markdown文档。

[什么是MCP服务器？](https://www.anthropic.com/news/model-context-protocol)

## 特性
| 属性 | 详情 |
|-|-|
**Docker镜像** | [mcp/atlas-docs](https://hub.docker.com/repository/docker/mcp/atlas-docs)
**作者** | [CartographAI](https://github.com/CartographAI)
**仓库** | https://github.com/CartographAI/atlas-docs-mcp
**Dockerfile** | https://github.com/CartographAI/atlas-docs-mcp/blob/master/Dockerfile
**Docker镜像构建者** | Docker Inc.
**Docker Scout健康评分** | ![Docker Scout健康评分](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/atlas-docs)
**验证签名** | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/atlas-docs --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub`
**许可证** | MIT许可证

## 可用工具（5个）
| 服务器提供的工具 | 简短描述 |
|-|-|
`get_docs_full` | 以单个合并文件的形式检索完整文档内容。 |
`get_docs_index` | 检索文档集中页面的精简、适合LLM的索引。 |
`get_docs_page` | 使用相对路径检索特定文档页面的内容。 |
`list_docs` | 列出所有可用的文档库和框架。 |
`search_docs` | 在文档集中搜索特定内容。 |

---
## 工具详情

#### 工具：**`get_docs_full`**
以单个合并文件的形式检索完整文档内容。当需要全面了解或分析完整文档上下文时使用此工具。返回大量文本 - 如需目标信息，可考虑使用`get_docs_page`或`search_docs`。
| 参数 | 类型 | 描述 |
|-|-|-|
`docName` | `string` | 文档集名称 |

---
#### 工具：**`get_docs_index`**
检索文档集中页面的精简、适合LLM的索引。用于初步探索以了解文档涵盖内容并识别相关页面时使用。返回包含可用页面列表的Markdown页面。可后续使用`get_docs_page`获取完整内容。
| 参数 | 类型 | 描述 |
|-|-|-|
`docName` | `string` | 文档集名称 |

---
#### 工具：**`get_docs_page`**
使用相对路径检索特定文档页面的内容。在通过`get_docs_index`或`search_docs`确定相关页面后，需获取特定主题的详细信息时使用。返回单个文档页面的完整内容。
| 参数 | 类型 | 描述 |
|-|-|-|
`docName` | `string` | 文档集名称 |
`pagePath` | `string` | 特定文档页面的根相对路径（例如：'/guides/getting-started'，'/api/authentication'） |

---
#### 工具：**`list_docs`**
列出所有可用的文档库和框架。作为发现可用文档集的第一步使用。返回每个文档集的名称、描述和源URL。使用其他文档工具前需先使用此工具获取docName。

---
#### 工具：**`search_docs`**
在文档集中搜索特定内容。用于查找包含特定关键词、概念或主题的页面时使用。返回按相关性排序的匹配页面及其路径和描述。可后续使用`get_docs_page`获取完整内容。
| 参数 | 类型 | 描述 |
|-|-|-|
`docName` | `string` | 文档集名称 |
`query` | `string` | 在文档集中搜索特定内容的查询词 |

---
## 使用此MCP服务器

```json
{
  "mcpServers": {
    "atlas-docs": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "ATLAS_API_URL",
        "mcp/atlas-docs"
      ],
      "env": {
        "ATLAS_API_URL": "https://atlas.cartograph.app/api"
      }
    }
  }
}
```

[为什么使用Docker运行MCP服务器更安全？](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)
