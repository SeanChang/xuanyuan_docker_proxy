---
image: mcp/triplewhale
description: "Triplewhale MCP Server是运行营销控制面板的服务器镜像，支持电商营销数据处理与分析，为用户提供营销管理功能。"
source: https://xuanyuan.cloud/zh/r/mcp/triplewhale
canonical: https://xuanyuan.cloud/zh/r/mcp/triplewhale
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/triplewhale" title="mcp/triplewhale Docker 镜像中文简介、标签列表与拉取命令">mcp/triplewhale 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Triplewhale MCP Server 技术文档


## 1. 镜像概述和主要用途

Triplewhale MCP Server 是一个基于模型上下文协议（MCP）的服务器，旨在与 AI 应用（如 Anthropic Claude）集成，提供特定工具访问能力。其核心功能是通过 `moby` 工具帮助用户安全、便捷地访问电子商务性能数据。

[什么是 MCP Server？](https://www.anthropic.com/news/model-context-protocol)


## 2. 核心功能和特性

### 2.1 基本特性

| 属性                | 详情                                                                 |
|---------------------|----------------------------------------------------------------------|
| **Docker 镜像**     | [mcp/triplewhale](https://hub.docker.com/repository/docker/mcp/triplewhale) |
| **作者**            | [Triple-Whale](https://github.com/Triple-Whale)                      |
| **代码仓库**        | https://github.com/Triple-Whale/mcp-server-triplewhale                |
| **Dockerfile**      | https://github.com/Triple-Whale/mcp-server-triplewhale/blob/master/Dockerfile |
| **镜像构建方**      | Docker Inc.                                                          |
| **Docker Scout 健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/triplewhale) |
| **签名验证**        | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/triplewhale --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
| **许可证**          | MIT License                                                          |


### 2.2 可用工具

| 工具名称 | 简要描述 |
|----------|----------|
| `moby`   | 帮助用户访问电子商务性能数据 |


## 3. 使用场景和适用范围

- **适用用户**：电商商家、数据分析师、运营人员等需要获取店铺性能数据的角色。
- **核心场景**：通过 AI 应用（如 Claude）查询店铺运营指标（如 ROAS、转化率等）、生成数据分析报告、获取可视化数据建议等。
- **使用条件**：需提供有效的 `shopId`（店铺 ID）和 Triple Whale API 密钥。


## 4. 详细的使用方法和配置说明

### 4.1 Docker 运行命令

通过 Docker 运行 Triplewhale MCP Server 的基本命令如下：

```bash
docker run -i --rm -e TRIPLEWHALE_API_KEY="your-triplewhale-api-key-here" docker.xuanyuan.run/mcp/triplewhale
```

**参数说明**：
- `-i`：以交互模式运行，允许输入输出
- `--rm`：容器退出后自动删除
- `-e TRIPLEWHALE_API_KEY`：设置环境变量，传入 Triple Whale API 密钥
- `mcp/triplewhale`：使用的 Docker 镜像名称


### 4.2 环境变量配置

| 环境变量名 | 描述 | 必要性 |
|------------|------|--------|
| `TRIPLEWHALE_API_KEY` | Triple Whale API 密钥（UUID 格式），用于鉴权访问电商数据 | 必需 |


### 4.3 MCP Server 集成配置示例

在支持 MCP 协议的 AI 应用中（如 Claude Desktop），配置 Triplewhale MCP Server 的示例如下：

```json
{
  "mcpServers": {
    "triplewhale": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "TRIPLEWHALE_API_KEY",
        "mcp/triplewhale"
      ],
      "env": {
        "TRIPLEWHALE_API_KEY": "your-triplewhale-api-key-here"  // 替换为实际 API 密钥
      }
    }
  }
}
```


## 5. 工具详情：`moby`

### 5.1 功能描述

`moby` 工具用于帮助用户访问电子商务性能数据。使用时需用户提供 **`shopId`**（店铺 ID）作为必需输入参数，工具将基于 `shopId` 和 API 密钥查询对应店铺的运营数据。


### 5.2 API 请求与响应 schema

#### 基础信息
- **API 标题**：Triple Whale GPT API  
- **描述**：通过 Triple Whale Moby API 访问电商性能数据  
- **版本**：1.0.0  
- **服务地址**：`https://api.triplewhale.com`（生产环境）


#### 请求路径
- **路径**：`/willy/moby-chat`  
- **方法**：`POST`  
- **操作 ID**：`answerMobyQuestion`  


#### 请求参数（`QuestionRequest`）
| 属性 | 类型 | 描述 | 示例 |
|------|------|------|------|
| `shopId` | string | 店铺 ID（必需） | `example-store.com` |
| `question` | string | 用户查询的问题（必需） | `最近 60 天 Facebook 广告的 ROAS 是多少？` |


#### 响应结构（`SimplifiedMobyResponse`）
| 属性 | 类型 | 描述 |
|------|------|------|
| `isError` | boolean | 是否发生错误 |
| `error` | string \| null | 错误信息（`isError: true` 时返回） |
| `responses` | array | 响应数据列表，包含多个 `SimplifiedResponse` 对象 |
| `assistantConclusion` | string | 助手总结，用于概述结果或提供后续建议 |

**`SimplifiedResponse` 结构**：
| 属性 | 类型 | 描述 |
|------|------|------|
| `isError` | boolean | 单个响应是否发生错误 |
| `errorMsg` | string \| null | 单个响应的错误信息 |
| `question` | string | 用户查询的问题 |
| `answer` | array | 结构化回答数据，每个元素为键值对（值类型：string/number/null） |
| `assistant` | string | 助手提示，可能包含可视化建议或报告链接 |


### 5.3 响应处理规则

1. **解析 `responses` 数组**：按顺序处理每个响应项，若任一响应 `isError: true`，则整体视为错误。  
2. **展示有效响应**：  
   - 显示用户的 `question`；  
   - 以结构化格式（如表格）呈现 `answer` 数据；  
   - 若 `assistant` 中包含可视化建议，提示“数据支持推荐的可视化格式”；  
   - 若 `assistant` 中包含相似报告链接，提供链接地址；  
   - 使用 `assistantConclusion` 询问用户是否需要进一步帮助。  


### 5.4 错误处理规则

| 错误类型 | 处理方式 |
|----------|----------|
| `isError: true` | 向用户显示 `error` 或 `errorMsg` 中的错误信息 |
| 401 Unauthorized | 提示“API 密钥无效或无权访问该店铺” |
| 403 Forbidden | 提示“凭据无效，请检查配置” |
| 缺少 `shopId` | 提示用户输入店铺 ID |
| 其他错误（如 500） | 提示“操作失败，请稍后重试” |


## 6. 为什么使用 Docker 运行 MCP Server 更安全？

Docker 为 MCP Server 提供了隔离的运行环境，有效限制服务器对主机系统的访问范围，降低数据泄露或恶意攻击风险。同时，Docker 确保了环境一致性，避免因依赖差异导致的运行问题。

[了解更多：为什么使用 Docker 运行 MCP Server 更安全](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)


## 7. 许可证

本项目采用 MIT License 开源许可协议。详情参见 [项目仓库许可证文件](https://github.com/Triple-Whale/mcp-server-triplewhale)。
