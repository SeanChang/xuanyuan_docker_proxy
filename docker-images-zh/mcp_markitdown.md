---
image: mcp/markitdown
description: "一个轻量级的MCP服务器，用于调用MarkItDown功能。"
source: https://xuanyuan.cloud/zh/r/mcp/markitdown
canonical: https://xuanyuan.cloud/zh/r/mcp/markitdown
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/markitdown" title="mcp/markitdown Docker 镜像中文简介、标签列表与拉取命令">mcp/markitdown 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Markitdown MCP服务器

一个轻量级的MCP服务器，用于调用MarkItDown。

[什么是MCP服务器？](https://www.anthropic.com/news/model-context-protocol)

## MCP信息
| 属性 | 详情 |
|-|-|
**Docker镜像** | [mcp/markitdown](https://hub.docker.com/repository/docker/mcp/markitdown)
**作者** | [microsoft](https://github.com/microsoft)
**仓库** | https://github.com/microsoft/markitdown

## 镜像构建信息
| 属性 | 详情 |
|-|-|
**Dockerfile** | https://github.com/microsoft/markitdown/blob/main/packages/markitdown-mcp/Dockerfile
**Docker镜像构建者** | Docker Inc.
**Docker Scout健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/markitdown)
**验证签名** | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/markitdown --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub`
**许可证** | MIT许可证

## 可用工具 (1)
| 服务器提供的工具 | 简短描述 |
|-|-|
`convert_to_markdown` | 将由http:、https:、file:或data: URI描述的资源转换为markdown |

---
## 工具详情

#### 工具：**`convert_to_markdown`**
将由http:、https:、file:或data: URI描述的资源转换为markdown

| 参数 | 类型 | 描述 |
|-|-|-|
`uri` | `string` |  |

---
## 使用此MCP服务器

使用此MCP服务器的配置示例：

```json
{
  "mcpServers": {
    "markitdown": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-v",
        "/local-directory:/local-directory",
        "mcp/markitdown"
      ]
    }
  }
}
```

[为什么使用Docker运行MCP服务器更安全？](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)
