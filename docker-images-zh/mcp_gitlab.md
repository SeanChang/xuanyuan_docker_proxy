---
image: mcp/gitlab
description: "用于GitLab API的MCP服务器，支持项目管理、文件操作等功能，可通过Docker运行，提供安全的API交互能力。"
source: https://xuanyuan.cloud/zh/r/mcp/gitlab
canonical: https://xuanyuan.cloud/zh/r/mcp/gitlab
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [mcp/gitlab — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/mcp/gitlab)

含镜像标签、拉取命令、部署文档与相关推荐。

[mcp/gitlab Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/mcp/gitlab)

# GitLab (已归档) MCP服务器

用于GitLab API的MCP服务器，支持项目管理、文件操作等功能。

[什么是MCP服务器？](https://www.anthropic.com/news/model-context-protocol)

## MCP信息
| 属性 | 详情 |
|------|------|
| **Docker镜像** | [mcp/gitlab](https://hub.docker.com/repository/docker/mcp/gitlab) |
| **作者** | [modelcontextprotocol](https://github.com/modelcontextprotocol) |
| **代码仓库** | https://github.com/modelcontextprotocol/servers |

## 镜像构建信息
| 属性 | 详情 |
|------|------|
| **Dockerfile** | https://github.com/modelcontextprotocol/servers/blob/b4ee623039a6c60053ce67269701ad9e95073306/src/gitlab/Dockerfile |
| **提交记录** | `b4ee623039a6c60053ce67269701ad9e95073306` |
| **Docker镜像构建者** | Docker Inc. |
| **Docker Scout健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/gitlab) |
| **验证签名** | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/gitlab --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
| **许可证** | MIT许可证 |

## 可用工具（9个）
| 服务器提供的工具 | 简短描述 |
|------------------|----------|
| `create_branch` | 在GitLab项目中创建新分支 |
| `create_issue` | 在GitLab项目中创建新议题 |
| `create_merge_request` | 在GitLab项目中创建新合并请求 |
| `create_or_update_file` | 在GitLab项目中创建或更新单个文件 |
| `create_repository` | 创建新的GitLab项目 |
| `fork_repository` | 将GitLab项目分叉到您的账户或指定命名空间 |
| `get_file_contents` | 获取GitLab项目中文件或目录的内容 |
| `push_files` | 在单次提交中向GitLab项目推送多个文件 |
| `search_repositories` | 搜索GitLab项目 |

---
## 工具详情

#### 工具：**`create_branch`**
在GitLab项目中创建新分支
| 参数 | 类型 | 描述 |
|------|------|------|
| `branch` | `string` | 新分支的名称 |
| `project_id` | `string` | 项目ID或URL编码路径 |
| `ref` | `string` *可选* | 新分支的源分支/提交 |

---
#### 工具：**`create_issue`**
在GitLab项目中创建新议题
| 参数 | 类型 | 描述 |
|------|------|------|
| `project_id` | `string` | 项目ID或URL编码路径 |
| `title` | `string` | 议题标题 |
| `assignee_ids` | `array` *可选* | 要分配的用户ID数组 |
| `description` | `string` *可选* | 议题描述 |
| `labels` | `array` *可选* | 标签名称数组 |
| `milestone_id` | `number` *可选* | 要分配的里程碑ID |

---
#### 工具：**`create_merge_request`**
在GitLab项目中创建新合并请求
| 参数 | 类型 | 描述 |
|------|------|------|
| `project_id` | `string` | 项目ID或URL编码路径 |
| `source_branch` | `string` | 包含更改的分支 |
| `target_branch` | `string` | 要合并到的分支 |
| `title` | `string` | 合并请求标题 |
| `allow_collaboration` | `boolean` *可选* | 允许上游成员提交 |
| `description` | `string` *可选* | 合并请求描述 |
| `draft` | `boolean` *可选* | 创建为草稿合并请求 |

---
#### 工具：**`create_or_update_file`**
在GitLab项目中创建或更新单个文件
| 参数 | 类型 | 描述 |
|------|------|------|
| `branch` | `string` | 要创建/更新文件的分支 |
| `commit_message` | `string` | 提交消息 |
| `content` | `string` | 文件内容 |
| `file_path` | `string` | 要创建/更新文件的路径 |
| `project_id` | `string` | 项目ID或URL编码路径 |
| `previous_path` | `string` *可选* | 要移动/重命名的文件路径 |

---
#### 工具：**`create_repository`**
创建新的GitLab项目
| 参数 | 类型 | 描述 |
|------|------|------|
| `name` | `string` | 仓库名称 |
| `description` | `string` *可选* | 仓库描述 |
| `initialize_with_readme` | `boolean` *可选* | 使用README.md初始化 |
| `visibility` | `string` *可选* | 仓库可见性级别 |

---
#### 工具：**`fork_repository`**
将GitLab项目分叉到您的账户或指定命名空间
| 参数 | 类型 | 描述 |
|------|------|------|
| `project_id` | `string` | 项目ID或URL编码路径 |
| `namespace` | `string` *可选* | 要分叉到的命名空间（完整路径） |

---
#### 工具：**`get_file_contents`**
获取GitLab项目中文件或目录的内容
| 参数 | 类型 | 描述 |
|------|------|------|
| `file_path` | `string` | 文件或目录的路径 |
| `project_id` | `string` | 项目ID或URL编码路径 |
| `ref` | `string` *可选* | 要获取内容的分支/标签/提交 |

---
#### 工具：**`push_files`**
在单次提交中向GitLab项目推送多个文件
| 参数 | 类型 | 描述 |
|------|------|------|
| `branch` | `string` | 要推送的分支 |
| `commit_message` | `string` | 提交消息 |
| `files` | `array` | 要推送的文件数组 |
| `project_id` | `string` | 项目ID或URL编码路径 |

---
#### 工具：**`search_repositories`**
搜索GitLab项目
| 参数 | 类型 | 描述 |
|------|------|------|
| `search` | `string` | 搜索查询 |
| `page` | `number` *可选* | 分页页码（默认：1） |
| `per_page` | `number` *可选* | 每页结果数（默认：20） |

---
## 使用此MCP服务器

```json
{
  "mcpServers": {
    "gitlab": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "GITLAB_API_URL",
        "-e",
        "GITLAB_PERSONAL_ACCESS_TOKEN",
        "mcp/gitlab"
      ],
      "env": {
        "GITLAB_API_URL": "https://gitlab.com/api/v4",
        "GITLAB_PERSONAL_ACCESS_TOKEN": "<您的令牌>"
      }
    }
  }
}
```

[为什么使用Docker运行MCP服务器更安全？](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)
