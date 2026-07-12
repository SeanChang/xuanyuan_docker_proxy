---
image: mcp/line
description: "集成LINE Messaging API的MCP服务器，用于将AI Agent连接到LINE官方账号，支持消息广播、用户资料获取、菜单管理等多种LINE功能。"
source: https://xuanyuan.cloud/zh/r/mcp/line
canonical: https://xuanyuan.cloud/zh/r/mcp/line
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/line" title="mcp/line Docker 镜像中文简介、标签列表与拉取命令">mcp/line 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LINE MCP Server

集成LINE Messaging API的MCP服务器，用于将AI Agent连接到LINE官方账号。

[什么是MCP服务器？](https://www.anthropic.com/news/model-context-protocol)

## MCP信息
| 属性 | 详情 |
|-|-|
**Docker镜像**|[mcp/line](https://hub.docker.com/repository/docker/mcp/line)
**作者**|[line](https://github.com/line)
**代码仓库**|https://github.com/line/line-bot-mcp-server

## 镜像构建信息**Dockerfile**|https://github.com/line/line-bot-mcp-server/blob/main/Dockerfile
**Docker镜像构建方**|Docker Inc.
**Docker Scout健康评分**| ![Docker Scout健康评分](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/line)
**验证签名**|`COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/line --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub`
**许可证**|Apache许可证 2.0

## 可用工具 (10)
| 服务器提供的工具 | 简短描述 |
|-|-|
`broadcast_flex_message`|通过LINE向所有已添加您LINE官方账号的用户广播高度可定制的flex消息。|
`broadcast_text_message`|通过LINE向所有已关注您LINE官方账号的用户广播简单文本消息。|
`cancel_rich_menu_default`|取消默认的富菜单。|
`delete_rich_menu`|从您的LINE官方账号中删除富菜单。|
`get_message_quota`|获取LINE官方账号的消息配额和消耗情况。|
`get_profile`|获取LINE用户的详细资料信息，包括显示名称、头像URL、状态消息和语言。|
`get_rich_menu_list`|获取与您LINE官方账号关联的所有富菜单列表。|
`push_flex_message`|通过LINE向用户推送高度可定制的flex消息，支持气泡（单个容器）和轮播（多个可滑动气泡）布局。|
`push_text_message`|通过LINE向用户推送简单文本消息，用于发送无格式的纯文本内容。|
`set_rich_menu_default`|将某个富菜单设置为默认富菜单。|

---
## 工具详情

#### Tool: **`broadcast_flex_message`**
通过LINE向所有已添加您LINE官方账号的用户广播高度可定制的flex消息。支持气泡（单个容器）和轮播（多个可滑动气泡）布局。请注意，此消息将发送给所有用户。

| 参数 | 类型 | 描述 |
|-|-|-|
`message`|`object`|flex消息对象，包含消息内容和布局配置|

---
#### Tool: **`broadcast_text_message`**
通过LINE向所有已关注您LINE官方账号的用户广播简单文本消息。用于发送无格式的纯文本内容。请注意，此消息将发送给所有关注用户。

| 参数 | 类型 | 描述 |
|-|-|-|
`message`|`object`|文本消息对象，包含消息内容|

---
#### Tool: **`cancel_rich_menu_default`**
取消当前设置的默认富菜单。

---
#### Tool: **`delete_rich_menu`**
从您的LINE官方账号中删除指定的富菜单。

| 参数 | 类型 | 描述 |
|-|-|-|
`richMenuId`|`string`|要删除的富菜单ID|

---
#### Tool: **`get_message_quota`**
获取LINE官方账号的消息配额和消耗情况，包括月度消息限制及当前使用量。

---
#### Tool: **`get_profile`**
获取LINE用户的详细资料信息，包括显示名称、头像URL、状态消息和语言。

| 参数 | 类型 | 描述 |
|-|-|-|
`userId`|`string` *可选*|LINE用户ID，默认为DESTINATION_USER_ID|

---
#### Tool: **`get_rich_menu_list`**
获取与您LINE官方账号关联的所有富菜单列表，包含菜单ID、名称等基本信息。

---
#### Tool: **`push_flex_message`**
通过LINE向指定用户推送高度可定制的flex消息。支持气泡（单个容器）和轮播（多个可滑动气泡）布局。

| 参数 | 类型 | 描述 |
|-|-|-|
`message`|`object`|flex消息对象，包含消息内容和布局配置|
`userId`|`string` *可选*|接收消息的用户ID，默认为DESTINATION_USER_ID|

---
#### Tool: **`push_text_message`**
通过LINE向指定用户推送简单文本消息，用于发送无格式的纯文本内容。

| 参数 | 类型 | 描述 |
|-|-|-|
`message`|`object`|文本消息对象，包含消息内容|
`userId`|`string` *可选*|接收消息的用户ID，默认为DESTINATION_USER_ID|

---
#### Tool: **`set_rich_menu_default`**
将指定的富菜单设置为LINE官方账号的默认富菜单，用户添加账号后将自动显示该菜单。

| 参数 | 类型 | 描述 |
|-|-|-|
`richMenuId`|`string`|要设为默认的富菜单ID|

---
## 使用此MCP服务器

```json
{
  "mcpServers": {
    "line": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "DESTINATION_USER_ID",
        "-e",
        "CHANNEL_ACCESS_TOKEN",
        "mcp/line"
      ],
      "env": {
        "DESTINATION_USER_ID": "请在此处填写目标用户ID",
        "CHANNEL_ACCESS_TOKEN": "请在此处填写LINE官方账号的频道访问令牌"
      }
    }
  }
}
```

[为什么使用Docker运行MCP服务器更安全？](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)
