---
image: mcp/obsidian
description: "通过Obsidian REST API社区插件与Obsidian交互的MCP服务器"
source: https://xuanyuan.cloud/zh/r/mcp/obsidian
canonical: https://xuanyuan.cloud/zh/r/mcp/obsidian
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/obsidian" title="mcp/obsidian Docker 镜像中文简介、标签列表与拉取命令">mcp/obsidian 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Obsidian MCP Server

通过Obsidian REST API社区插件与Obsidian交互的MCP服务器。

[什么是MCP服务器？](https://www.anthropic.com/news/model-context-protocol)

## 特性
| 属性 | 详情 |
|------|------|
| **Docker镜像** | [mcp/obsidian](https://hub.docker.com/repository/docker/mcp/obsidian) |
| **作者** | [MarkusPfundstein](https://github.com/MarkusPfundstein) |
| **仓库** | https://github.com/MarkusPfundstein/mcp-obsidian |
| **Dockerfile** | https://github.com/docker/mcp-obsidian/blob/docker-support/Dockerfile |
| **Docker镜像构建者** | Docker Inc. |
| **Docker Scout健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/obsidian) |
| **验证签名** | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/obsidian --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
| **许可证** | MIT许可证 |

## 可用工具（12个）
| 服务器提供的工具 | 简短描述 |
|------------------|----------|
| `obsidian_append_content` | 向库中的新文件或现有文件追加内容。 |
| `obsidian_batch_get_file_contents` | 返回库中多个文件的内容，带标题拼接。 |
| `obsidian_complex_search` | 使用JsonLogic查询进行复杂文档搜索。 |
| `obsidian_delete_file` | 从库中删除文件或目录。 |
| `obsidian_get_file_contents` | 返回库中单个文件的内容。 |
| `obsidian_get_periodic_note` | 获取指定周期的当前周期性笔记。 |
| `obsidian_get_recent_changes` | 获取库中最近修改的文件。 |
| `obsidian_get_recent_periodic_notes` | 获取指定周期类型的最近周期性笔记。 |
| `obsidian_list_files_in_dir` | 列出特定Obsidian目录中的所有文件和目录。 |
| `obsidian_list_files_in_vault` | 列出Obsidian库根目录中的所有文件和目录。 |
| `obsidian_patch_content` | 将内容插入现有笔记中，相对于标题、块引用或前置元数据字段。 |
| `obsidian_simple_search` | 在库中所有文件中搜索匹配指定文本查询的文档。 |

---
## 工具详情

#### 工具：**`obsidian_append_content`**
向库中的新文件或现有文件追加内容。
| 参数 | 类型 | 描述 |
|------|------|------|
| `content` | `string` | 要追加到文件的内容 |
| `filepath` | `string` | 文件路径（相对于库根目录） |

---
#### 工具：**`obsidian_batch_get_file_contents`**
返回库中多个文件的内容，带标题拼接。
| 参数 | 类型 | 描述 |
|------|------|------|
| `filepaths` | `array` | 要读取的文件路径列表 |

---
#### 工具：**`obsidian_complex_search`**
使用JsonLogic查询进行复杂文档搜索。支持标准JsonLogic运算符以及用于模式匹配的'glob'和'regexp'。结果必须为非假值。

当需要进行复杂搜索时使用此工具，例如查找所有带有特定标签的文档等。
| 参数 | 类型 | 描述 |
|------|------|------|
| `query` | `object` | JsonLogic查询对象。示例：{"glob": ["*.md", {"var": "path"}]} 匹配所有markdown文件 |

---
#### 工具：**`obsidian_delete_file`**
从库中删除文件或目录。
| 参数 | 类型 | 描述 |
|------|------|------|
| `confirm` | `boolean` | 删除确认（必须为true） |
| `filepath` | `string` | 要删除的文件或目录路径（相对于库根目录） |

---
#### 工具：**`obsidian_get_file_contents`**
返回库中单个文件的内容。
| 参数 | 类型 | 描述 |
|------|------|------|
| `filepath` | `string` | 相关文件的路径（相对于库根目录）。 |

---
#### 工具：**`obsidian_get_periodic_note`**
获取指定周期的当前周期性笔记。
| 参数 | 类型 | 描述 |
|------|------|------|
| `period` | `string` | 周期类型（daily-每日，weekly-每周，monthly-每月，quarterly-每季度，yearly-每年） |

---
#### 工具：**`obsidian_get_recent_changes`**
获取库中最近修改的文件。
| 参数 | 类型 | 描述 |
|------|------|------|
| `days` | `integer` *可选* | 仅包含最近N天内修改的文件（默认：90） |
| `limit` | `integer` *可选* | 返回的最大文件数（默认：10） |

---
#### 工具：**`obsidian_get_recent_periodic_notes`**
获取指定周期类型的最近周期性笔记。
| 参数 | 类型 | 描述 |
|------|------|------|
| `period` | `string` | 周期类型（daily-每日，weekly-每周，monthly-每月，quarterly-每季度，yearly-每年） |
| `include_content` | `boolean` *可选* | 是否包含笔记内容（默认：false） |
| `limit` | `integer` *可选* | 返回的最大笔记数（默认：5） |

---
#### 工具：**`obsidian_list_files_in_dir`**
列出特定Obsidian目录中的所有文件和目录。
| 参数 | 类型 | 描述 |
|------|------|------|
| `dirpath` | `string` | 要列出文件的目录路径（相对于库根目录）。注意：空目录将不会返回。 |

---
#### 工具：**`obsidian_list_files_in_vault`**
列出Obsidian库根目录中的所有文件和目录。

---
#### 工具：**`obsidian_patch_content`**
将内容插入现有笔记中，相对于标题、块引用或前置元数据字段。
| 参数 | 类型 | 描述 |
|------|------|------|
| `content` | `string` | 要插入的内容 |
| `filepath` | `string` | 文件路径（相对于库根目录） |
| `operation` | `string` | 执行的操作（append-追加，prepend-前置，replace-替换） |
| `target` | `string` | 目标标识符（标题路径、块引用或前置元数据字段） |
| `target_type` | `string` | 要修补的目标类型 |

---
#### 工具：**`obsidian_simple_search`**
在库中所有文件中搜索匹配指定文本查询的文档。当需要进行简单文本搜索时使用此工具。
| 参数 | 类型 | 描述 |
|------|------|------|
| `query` | `string` | 要在库中进行简单搜索的文本。 |
| `context_length` | `integer` *可选* | 返回匹配字符串周围的上下文长度（默认：100） |

---
## 使用此MCP服务器

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "OBSIDIAN_HOST",
        "-e",
        "OBSIDIAN_API_KEY",
        "mcp/obsidian"
      ],
      "env": {
        "OBSIDIAN_HOST": "host.docker.internal",
        "OBSIDIAN_API_KEY": "你的Obsidian API密钥"
      }
    }
  }
}
```

[为什么使用Docker运行MCP服务器更安全？](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)
