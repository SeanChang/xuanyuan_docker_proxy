---
image: mcp/oracle
description: "通过MCP连接Oracle数据库，提供安全的只读访问，支持模式探索、查询执行和元数据检查。"
source: https://xuanyuan.cloud/zh/r/mcp/oracle
canonical: https://xuanyuan.cloud/zh/r/mcp/oracle
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/oracle" title="mcp/oracle Docker 镜像中文简介、标签列表与拉取命令">mcp/oracle 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Oracle数据库MCP服务器

通过MCP连接Oracle数据库，提供安全的只读访问，支持模式探索、查询执行和元数据检查。

[什么是MCP服务器？](https://www.anthropic.com/news/model-context-protocol)

## 特性
| 属性 | 详情 |
|-|-|
**Docker镜像** | [mcp/oracle](https://hub.docker.com/repository/docker/mcp/oracle) |
**作者** | [samscarrow](https://github.com/samscarrow) |
**仓库** | https://github.com/samscarrow/oracle-mcp-server |
**Dockerfile** | https://github.com/samscarrow/oracle-mcp-server/blob/main/Dockerfile |
**Docker镜像构建者** | Docker Inc. |
**Docker Scout健康评分** | ![Docker Scout健康评分](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/oracle) |
**验证签名** | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/oracle --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
**许可证** | MIT License |

## 可用工具（6个）
| 服务器提供的工具 | 简要描述 |
|-|-|
`describe_table` | 获取表结构，包括列、数据类型和约束 |
`execute_query` | 在Oracle数据库上执行SQL查询 |
`get_table_constraints` | 获取表的约束（主键、外键、唯一键、检查约束） |
`get_table_indexes` | 获取特定表的索引 |
`list_schemas` | 列出数据库中的所有模式 |
`list_tables` | 列出指定模式或所有可访问模式中的表 |

---
## 工具详情

#### 工具：**`describe_table`**
获取表结构，包括列、数据类型和约束
| 参数 | 类型 | 描述 |
|-|-|-|
`table_name` | `string` | 表名 |
`schema` | `string` *可选* | 模式名（可选，如未指定则搜索所有可访问模式） |

---
#### 工具：**`execute_query`**
在Oracle数据库上执行SQL查询
| 参数 | 类型 | 描述 |
|-|-|-|
`query` | `string` | 要执行的SQL查询 |
`maxRows` | `number` *可选* | 返回的最大行数（默认：1000） |
`params` | `array` *可选* | 查询参数（可选） |

---
#### 工具：**`get_table_constraints`**
获取表的约束（主键、外键、唯一键、检查约束）
| 参数 | 类型 | 描述 |
|-|-|-|
`table_name` | `string` | 表名 |
`schema` | `string` *可选* | 模式名（可选，如未指定则搜索所有可访问模式） |

---
#### 工具：**`get_table_indexes`**
获取特定表的索引
| 参数 | 类型 | 描述 |
|-|-|-|
`table_name` | `string` | 表名 |
`schema` | `string` *可选* | 模式名（可选，如未指定则搜索所有可访问模式） |

---
#### 工具：**`list_schemas`**
列出数据库中的所有模式

---
#### 工具：**`list_tables`**
列出指定模式或所有可访问模式中的表
| 参数 | 类型 | 描述 |
|-|-|-|
`pattern` | `string` *可选* | 表名模式（支持%通配符） |
`schema` | `string` *可选* | 模式名（可选，如未指定则显示所有可访问模式） |

---
## 使用此MCP服务器

```json
{
  "mcpServers": {
    "oracle": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "ORACLE_CONNECTION_STRING",
        "-e",
        "ORACLE_USER",
        "-e",
        "ORACLE_PASSWORD",
        "mcp/oracle"
      ],
      "env": {
        "ORACLE_CONNECTION_STRING": "hostname:1521/servicename",
        "ORACLE_USER": "readonly_user",
        "ORACLE_PASSWORD": "<ORACLE_PASSWORD>"
      }
    }
  }
}
```

[为什么使用Docker运行MCP服务器更安全？](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)
