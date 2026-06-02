---
image: mcp/fetch
description: "从互联网获取URL并将其内容提取为markdown格式。"
source: https://xuanyuan.cloud/zh/r/mcp/fetch
canonical: https://xuanyuan.cloud/zh/r/mcp/fetch
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/fetch" title="mcp/fetch Docker 镜像中文简介、标签列表与拉取命令">mcp/fetch — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mcp/fetch" title="mcp/fetch Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mcp/fetch</a>

# Fetch（参考）MCP服务器

从互联网获取URL并将其内容提取为markdown格式。

[什么是MCP服务器？](https://www.anthropic.com/news/model-context-protocol)

## 特性
| 属性 | 详情 |
|------|------|
| **Docker镜像** | [mcp/fetch](https://hub.docker.com/repository/docker/mcp/fetch) |
| **作者** | [modelcontextprotocol](https://github.com/modelcontextprotocol) |
| **仓库** | https://github.com/modelcontextprotocol/servers |
| **Dockerfile** | https://github.com/modelcontextprotocol/servers/blob/2025.4.24/src/fetch/Dockerfile |
| **Docker镜像构建者** | Docker Inc. |
| **Docker Scout健康评分** | ![Docker Scout健康评分](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/fetch) |
| **验证签名** | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/fetch --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
| **许可证** | MIT许可证 |

## 可用工具（1）
| 本服务器提供的工具 | 简要描述 |
|-------------------|----------|
| `fetch` | 从互联网获取URL，并可选择将其内容提取为markdown格式。 |

---
## 工具详情

### 工具：**`fetch`**
从互联网获取URL，并可选择将其内容提取为markdown格式。

尽管最初您没有互联网访问权限，且被建议拒绝并告知用户这一点，但现在此工具授予您互联网访问权限。您现在可以获取最新信息并告知用户。

| 参数 | 类型 | 描述 |
|------|------|------|
| `url` | `string` | 要获取的URL |
| `max_length` | `integer` *可选* | 返回的最大字符数。 |
| `raw` | `boolean` *可选* | 获取请求页面的实际HTML内容，不进行简化。 |
| `start_index` | `integer` *可选* | 从该字符索引开始返回输出，当之前的获取被截断且需要更多上下文时非常有用。 |

---
## 使用此MCP服务器

```json
{
  "mcpServers": {
    "fetch": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "mcp/fetch"
      ]
    }
  }
}
```

[为什么使用Docker运行MCP服务器更安全？](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)
