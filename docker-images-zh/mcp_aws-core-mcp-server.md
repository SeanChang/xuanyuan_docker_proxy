---
image: mcp/aws-core-mcp-server
description: "用于使用awslabs MCP服务器的基础镜像"
source: https://xuanyuan.cloud/zh/r/mcp/aws-core-mcp-server
canonical: https://xuanyuan.cloud/zh/r/mcp/aws-core-mcp-server
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/aws-core-mcp-server" title="mcp/aws-core-mcp-server Docker 镜像中文简介、标签列表与拉取命令">mcp/aws-core-mcp-server — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mcp/aws-core-mcp-server" title="mcp/aws-core-mcp-server Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mcp/aws-core-mcp-server</a>

# AWS Core MCP Server 镜像文档

## 1. 镜像概述和主要用途

MCP（Model Context Protocol，模型上下文协议）服务器是用于简化AI应用构建的组件，旨在结合Anthropic Claude Desktop和Docker等工具，提供模型上下文管理能力。本镜像（`mcp/aws-core-mcp-server`）是使用awslabs MCP服务器的起点，提供基础的MCP核心功能支持。

了解更多MCP服务器：[什么是MCP服务器？](https://www.anthropic.com/news/model-context-protocol)


## 2. 核心特性

| 属性                | 详情                                                                 |
|---------------------|----------------------------------------------------------------------|
| **Docker镜像**      | [mcp/aws-core-mcp-server](https://hub.docker.com/repository/docker/mcp/aws-core-mcp-server) |
| **作者**            | [awslabs](https://github.com/awslabs)                                |
| **代码仓库**        | https://github.com/awslabs/mcp                                       |
| **Dockerfile**      | https://github.com/awslabs/mcp/blob/main/src/core-mcp-server/Dockerfile |
| **镜像构建者**      | Docker Inc.                                                          |
| **Docker Scout健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/aws-core-mcp-server) |
| **签名验证命令**    | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/aws-core-mcp-server --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
| **许可证**          | Apache License 2.0                                                   |


## 3. 可用工具

### 3.1 工具列表

| 工具名称               | 简要描述                     |
|------------------------|------------------------------|
| `prompt_understanding` | MCP-CORE提示理解工具         |

### 3.2 工具详情

#### 工具：`prompt_understanding`

MCP-CORE提示理解工具。

**使用说明**：始终首先使用此工具理解用户查询，并将其转化为AWS专家建议。


## 4. 使用场景

本MCP服务器适用于需要解析用户自然语言查询并生成AWS相关专业建议的AI应用场景。作为MCP服务器网络的核心组件，可作为处理AWS相关查询的起点，通过`prompt_understanding`工具优先对用户意图进行解析，为后续处理提供基础。


## 5. 使用方法与配置

### 5.1 Docker部署示例

运行本MCP服务器的Docker命令：

```bash
docker run -i --rm mcp/aws-core-mcp-server
```

### 5.2 MCP服务器配置示例

在MCP服务器配置中引用本镜像的示例：

```json
{
  "mcpServers": {
    "aws-core-mcp-server": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "mcp/aws-core-mcp-server"
      ]
    }
  }
}
```

### 5.3 镜像签名验证

为确保镜像完整性和安全性，可通过以下命令验证镜像签名：

```bash
COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/aws-core-mcp-server --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub
```


## 6. 安全性说明

使用Docker运行MCP服务器可提供隔离的运行环境，有效降低应用与主机系统的直接交互风险，确保模型上下文处理的安全性和环境一致性。

了解更多：[为什么使用Docker运行MCP服务器更安全？](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)
