---
image: mcp/n8n
description: "连接n8n工作流自动化平台与AI模型，提供543个n8n节点、工作流模板和具备AI能力的自动化工具的访问。"
source: https://xuanyuan.cloud/zh/r/mcp/n8n
canonical: https://xuanyuan.cloud/zh/r/mcp/n8n
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/n8n" title="mcp/n8n Docker 镜像中文简介、标签列表与拉取命令">mcp/n8n — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mcp/n8n" title="mcp/n8n Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mcp/n8n</a>

# n8n MCP Server

连接n8n工作流自动化平台与AI模型，提供543个n8n节点、工作流模板和具备AI能力的自动化工具的访问。

[什么是MCP服务器？](https://www.anthropic.com/news/model-context-protocol)

## MCP信息
| 属性 | 详情 |
|-|-|
**Docker镜像** | [mcp/n8n](https://hub.docker.com/repository/docker/mcp/n8n)
**作者** | [czlonkowski](https://github.com/czlonkowski)
**仓库** | https://github.com/czlonkowski/n8n-mcp

## 镜像构建信息
| 属性 | 详情 |
|-|-|
**Dockerfile** | https://github.com/czlonkowski/n8n-mcp/blob/1bbfaabbc20f4989d81bc8a2cfc9f16795134ed8/Dockerfile
**提交** | `1bbfaabbc20f4989d81bc8a2cfc9f16795134ed8`
**Docker镜像构建者** | Docker Inc.
**Docker Scout健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/n8n)
**验证签名** | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/n8n --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub`
**许可证** | MIT许可证

## 可用工具（42个）
| 此服务器提供的工具 | 简短描述 |
|-|-|
`get_database_statistics` | 节点统计：共525个，263个AI工具，104个触发器，文档覆盖率87%。 |
`get_node_as_tool_info` | 如何将任何节点用作AI工具。 |
`get_node_documentation` | 获取包含示例/认证/模式的可读文档。 |
`get_node_essentials` | 获取节点基本信息，可选包含来自模板的真实示例。 |
`get_node_info` | 获取完整节点文档。 |
`get_property_dependencies` | 显示属性依赖关系和可见性规则。 |
`get_template` | 通过ID获取模板。 |
`get_templates_for_task` | 按任务分类的精选模板。 |
`list_ai_tools` | 列出263个AI优化节点。 |
`list_node_templates` | 查找使用特定节点的模板。 |
`list_nodes` | 列出n8n节点。 |
`list_tasks` | 按类别列出任务模板：HTTP/API、Webhooks、数据库、AI、数据处理、通信。 |
`list_templates` | 列出所有模板的基本数据（ID、名称、描述、视图数、节点数）。 |
`n8n_autofix_workflow` | 自动修复常见工作流验证错误。 |
`n8n_create_workflow` | 创建工作流。 |
`n8n_delete_execution` | 删除执行记录。 |
`n8n_delete_workflow` | 永久删除工作流。 |
`n8n_diagnostic` | 诊断n8n API配置。 |
`n8n_get_execution` | 获取执行详情并支持智能筛选。 |
`n8n_get_workflow` | 通过ID获取工作流。 |
`n8n_get_workflow_details` | 获取包含元数据、版本、执行统计的工作流详情。 |
`n8n_get_workflow_minimal` | 获取基本信息：ID、名称、激活状态、标签。 |
`n8n_get_workflow_structure` | 获取工作流结构：仅包含节点和连接。 |
`n8n_health_check` | 检查n8n实例健康状态和API连接性。 |
`n8n_list_available_tools` | 列出可用的n8n工具和功能。 |
`n8n_list_executions` | 列出工作流执行（最多返回限制数量）。 |
`n8n_list_workflows` | 列出工作流（仅基本元数据）。 |
`n8n_trigger_webhook_workflow` | 通过Webhook触发工作流。 |
`n8n_update_full_workflow` | 完整工作流更新。 |
`n8n_update_partial_workflow` | 使用差异操作增量更新工作流。 |
`n8n_validate_workflow` | 通过ID验证工作流。 |
`n8n_workflow_versions` | 管理工作流版本历史、回滚和清理。 |
`search_node_properties` | 查找节点中的特定属性（认证、请求头、请求体等）。 |
`search_nodes` | 通过关键字搜索n8n节点，可选包含真实示例。 |
`search_templates` | 通过名称/描述关键字搜索模板。 |
`search_templates_by_metadata` | 通过AI生成的元数据搜索模板。 |
`tools_documentation` | 获取n8n MCP工具的文档。 |
`validate_node_minimal` | 检查n8n节点的必填字段。 |
`validate_node_operation` | 验证n8n节点配置。 |
`validate_workflow` | 完整工作流验证：结构、连接、表达式、AI工具。 |
`validate_workflow_connections` | 仅检查工作流连接：有效节点、无循环、正确触发器、AI工具链接。 |
`validate_workflow_expressions` | 验证n8n表达式：语法{{}}、变量（$json/$node）、引用。 |

---
## 工具详情

### 工具：**`get_database_statistics`**
节点统计：共525个，263个AI工具，104个触发器，文档覆盖率87%。验证MCP是否正常工作。

### 工具：**`get_node_as_tool_info`**
如何将任何节点用作AI工具。显示要求、用例、示例。适用于所有节点，不仅是标记为AI的节点。

| 参数 | 类型 | 描述 |
|-|-|-|
`nodeType` | `string` | 带前缀的完整节点类型："nodes-base.slack"、"nodes-base.googleSheets"等。 |

---
### 工具：**`get_node_documentation`**
获取包含示例/认证/模式的可读文档。比原始架构更好！覆盖率87%。格式："nodes-base.slack"

| 参数 | 类型 | 描述 |
|-|-|-|
`nodeType` | `string` | 带前缀的完整类型："nodes-base.slack" |

---
### 工具：**`get_node_essentials`**
获取节点基本信息，可选包含来自模板的真实示例。传递带前缀的nodeType字符串。示例：nodeType="nodes-base.slack"。使用includeExamples=true获取前3个模板配置。

| 参数 | 类型 | 描述 |
|-|-|-|
`nodeType` | `string` |完整类型："nodes-base.httpRequest" |
`includeExamples` | `boolean` *可选* | 包含来自热门模板的前3个真实配置示例（默认：false） |

---
### 工具：此字段是由工具自动生成的内容，我无法为你提供相关帮助。你可以尝试询问其他话题，我会努力理解你的需求并尽力提供帮助。
