---
image: acuvity/mcp-server-chart
description: "一个使用AntV生成可视化图表的模型上下文协议(MCP)服务器，由Acuvity打包发布，提供安全隔离的运行环境和多种集成方式。"
source: https://xuanyuan.cloud/zh/r/acuvity/mcp-server-chart
canonical: https://xuanyuan.cloud/zh/r/acuvity/mcp-server-chart
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/acuvity/mcp-server-chart" title="acuvity/mcp-server-chart Docker 镜像中文简介、标签列表与拉取命令">acuvity/mcp-server-chart 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# mcp-server-chart 是什么

[![评分](https://img.shields.io/badge/B-3775A9?label=Rating)](https://docs.anthropic.com/en/docs/build-with-claude/tool-use/implement-tool-use#best-practices-for-tool-definitions)
[![Helm](https://img.shields.io/badge/1.0.0-3775A9?logo=helm&label=Charts&logoColor=fff)](https://hub.docker.com/r/acuvity/mcp-server-chart/tags/)
[![Docker](https://img.shields.io/docker/image-size/acuvity/mcp-server-chart/0.9.7?logo=docker&logoColor=fff&label=0.9.7)](https://hub.docker.com/r/acuvity/mcp-server-chart)
[![PyPI](https://img.shields.io/badge/0.9.7-3775A9?logo=pypi&logoColor=fff&label=@antv/mcp-server-chart)](https://github.com/antvis/mcp-server-chart)
[![Scout](https://img.shields.io/badge/Active-3775A9?logo=docker&logoColor=fff&label=Scout)](https://hub.docker.com/r/acuvity/mcp-server-chart/)
[![在VS Code Docker中安装](https://img.shields.io/badge/VS_Code-一键安装-0078d7?logo=githubcopilot)](https://insiders.vscode.dev/redirect/mcp/install?name=mcp-server-chart&config=%7B%22args%22%3A%5B%22run%22%2C%22-i%22%2C%22--rm%22%2C%22--read-only%22%2C%22docker.io%2Facuvity%2Fmcp-server-chart%3A0.9.7%22%5D%2C%22command%22%3A%22docker%22%7D)

**描述**：一个使用AntV生成可视化图表的模型上下文协议(MCP)服务器。

由Acuvity打包并发布到我们的精选MCP服务器[ registry ](https://mcp.acuvity.ai)，基于@antv/mcp-server-chart的原始[源代码](https://github.com/antvis/mcp-server-chart)构建。

**快速链接**：

- [与IDE集成](https://github.com/acuvity/mcp-servers-registry/blob/main/mcp-server-chart/docker/README.md#-clients-integrations)
- [使用Docker安装](https://github.com/acuvity/mcp-servers-registry/tree/main/mcp-server-chart/docker/README.md#-run-it-with-docker)
- [使用Helm安装](https://github.com/acuvity/mcp-servers-registry/tree/main/mcp-server-chart/charts/mcp-server-chart/README.md#how-to-install)

# 我们构建此镜像的原因

在[Acuvity](https://acuvity.ai)，安全性是我们使命的核心——尤其是对于MCP服务器和智能体系统集成等关键系统。为满足这一需求，我们创建了一个安全可靠的Docker镜像，确保@antv/mcp-server-chart能够可靠且安全地运行。

## 🔐 关键安全特性

### 📦 隔离的不可变沙箱

| 特性 | 描述 |
|---------------------------|------------------------------------------------------------------------------------------------------------------------|
| 隔离执行 | 所有工具在安全的容器化沙箱中运行，以实施进程隔离并防止横向移动。 |
| 默认非root用户 | 实施最小权限原则，最大限度减少潜在安全漏洞的影响。 |
| 只读文件系统 | 确保运行时不可变性，防止未授权修改。 |
| 版本固定 | 通过锁定工具和依赖版本，保证跨部署的一致性和可重现性。 |
| CVE扫描 | 使用[Docker Scout](https://docs.docker.com/scout/)持续扫描镜像中的已知漏洞，支持主动缓解。 |
| SBOM与溯源信息 | 通过嵌入元数据和可追踪的构建信息，提供完整的供应链透明度。 |
| 容器签名(Cosign) | 使用[Cosign](https://github.com/sigstore/cosign)实施镜像签名，确保容器镜像的完整性和真实性。 |

### 🛡️ 运行时安全与防护措施

**Minibridge集成**：[Minibridge](https://github.com/acuvity/minibridge)建立安全的智能体到MCP连接，支持Rego/HTTP-based策略执行🕵️，并简化编排。

[ARC](https://github.com/acuvity/mcp-servers-registry/tree/main)容器包含一个[内置Rego策略](https://github.com/acuvity/mcp-servers-registry/tree/main/mcp-server-chart/docker/policy.rego)，提供一系列运行时[防护措施](https://github.com/acuvity/mcp-servers-registry/tree/main/mcp-server-chart#%EF%B8%8F-guardrails)，帮助实施服务的安全、隐私和正确使用。以下是提供的各防护措施列表：

| 防护措施 | 摘要 |
|----------------------------------|-------------------------------------------------------------------------|
| `resource integrity` | 嵌入所有暴露资源的哈希，确保其真实性并防止未授权修改，防范供应链攻击和工具元数据的动态篡改。 |
| `covert-instruction-detection` | 检测请求中隐藏或混淆的指令。 |
| `sensitive-pattern-detection` | 标记暗示敏感数据或文件系统暴露的模式。 |
| `shadowing-pattern-detection` | 识别覆盖或影响其他工具描述的工具描述。 |
| `schema-misuse-prevention` | 对输入数据实施严格的模式合规性。 |
| `cross-origin-tool-access` | 控制对外部服务或API的调用。 |
| `secrets-redaction` | 防止凭证或敏感值的暴露。 |
| `basic authentication` | 允许配置共享密钥以限制对MCP服务器的未授权访问，确保只有经过批准的客户端可以连接。 |

这些控制确保强大的运行时完整性，防止未授权行为，并为安全设计的系统操作提供基础。

> [!NOTE]
> 默认情况下，除`resource integrity`外，所有防护措施均处于关闭状态。您可以单独启用或禁用每一项，确保只激活您环境所需的保护。

# 快速参考

**维护者**：
- 打包：[Acuvity团队](mailto:support@acuvity.ai)
- 原始应用：[AntV](https://github.com/antvis/mcp-server-chart)

**获取帮助**：
- [Acuvity MCP Forge仓库](https://github.com/acuvity/mcp-servers-registry)
- [Acuvity社区Discord](https://discord.gg/BkU7fBkrNk)
- [@antv/mcp-server-chart](https://github.com/antvis/mcp-server-chart)

**提交问题**：
- [Github issue跟踪器](https://github.com/acuvity/mcp-servers-registry/issues)
- [@antv/mcp-server-chart](https://github.com/antvis/mcp-server-chart)

**支持的架构**：
- `amd64`
- `arm64`

**基础镜像**：
- `node:23.11.0-alpine3.21`

**资源**：
- [Charts](https://github.com/acuvity/mcp-servers-registry/tree/main/mcp-server-chart/charts/mcp-server-chart)
- [Dockerfile](https://github.com/acuvity/mcp-servers-registry/tree/main/mcp-server-chart/docker/Dockerfile)

**最新标签**：
- `latest` -> `1.0.0-0.9.7` -> `0.9.7`
- [旧标签](https://hub.docker.com/r/acuvity/mcp-server-chart/tags)

**使用[cosign](https://github.com/sigstore/cosign)验证签名**：
- `cosign verify --certificate-oidc-issuer "https://token.actions.githubusercontent.com" --certificate-identity "https://github.com/acuvity/mcp-servers-registry/.github/workflows/release.yaml@refs/heads/main" docker.io/acuvity/mcp-server-chart:latest`
- `cosign verify --certificate-oidc-issuer "https://token.actions.githubusercontent.com" --certificate-identity "https://github.com/acuvity/mcp-servers-registry/.github/workflows/release.yaml@refs/heads/main" docker.io/acuvity/mcp-server-chart:0.9.7`
- `cosign verify --certificate-oidc-issuer "https://token.actions.githubusercontent.com" --certificate-identity "https://github.com/acuvity/mcp-servers-registry/.github/workflows/release.yaml@refs/heads/main" docker.io/acuvity/mcp-server-chart:1.0.0-0.9.7`

# 📦 安装方法

> [!TIP]
> 鉴于mcp-server-chart的操作范围，它可以在任何地方托管。

有关更多信息和额外配置，您可以参考[软件包](https://github.com/antvis/mcp-server-chart)文档。

# 🧰 客户端集成

以下是配置大多数使用MCP提升Copilot体验的客户端的步骤。

> [!NOTE]
> 这些集成在所有Minibridge模式下原生运行。为简洁起见，此处仅涵盖docker本地运行设置。

<details>
<summary>Visual Studio Code</summary>

要立即开始，您可以使用下面的"一键"链接：

[![在VS Code Docker中安装](https://img.shields.io/badge/VS_Code-一键安装-0078d7?logo=githubcopilot)](https://insiders.vscode.dev/redirect/mcp/install?name=mcp-server-chart&config=%7B%22args%22%3A%5B%22run%22%2C%22-i%22%2C%22--rm%22%2C%22--read-only%22%2C%22docker.io%2Facuvity%2Fmcp-server-chart%3A0.9.7%22%5D%2C%22command%22%3A%22docker%22%7D)

## 全局范围

按`ctrl + shift + p`并输入`首选项: 打开用户设置 JSON`，添加以下部分：

```json
{
  "mcp": {
    "servers": {
      "acuvity-mcp-server-chart": {
        "command": "docker",
        "args": [
          "run",
          "-i",
          "--rm",
          "--read-only",
          "docker.io/acuvity/mcp-server-chart:0.9.7"
        ]
      }
    }
  }
}
```

## 工作区范围

在您的工作区中创建一个名为`.vscode/mcp.json`的文件，并添加以下部分：

```json
{
  "servers": {
    "acuvity-mcp-server-chart": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "--read-only",
        "docker.io/acuvity/mcp-server-chart:0.9.7"
      ]
    }
  }
}
```

> 要传递密钥，您应该使用[Visual Studio Code文档](https://code.visualstudio.com/docs/copilot/chat/mcp-servers)中描述的`promptString`输入类型。

</details>

<details>
<summary>Windsurf IDE</summary>

在`~/.codeium/windsurf/mcp_config.json`中添加以下部分：

```json
{
  "mcpServers": {
    "acuvity-mcp-server-chart": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "--read-only",
        "docker.io/acuvity/mcp-server-chart:0.9.7"
      ]
    }
  }
}
```

更多信息请参见[Windsurf文档](https://docs.windsurf.com/windsurf/mcp)。

</details>

<details>
<summary>Cursor IDE</summary>

将以下JSON块添加到您的mcp配置文件：
- 全局范围：`~/.cursor/mcp.json`
- 项目范围：`.cursor/mcp.json`

```json
{
  "mcpServers": {
    "acuvity-mcp-server-chart": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "--read-only",
        "docker.io/acuvity/mcp-server-chart:0.9.7"
      ]
    }
  }
}
```

更多信息请参见[cursor文档](https://docs.cursor.com/context/model-context-protocol)。

</details>

<details>
<summary>Claude Desktop</summary>

在`claude_desktop_config.json`配置文件中添加以下部分：

```json
{
  "mcpServers": {
    "acuvity-mcp-server-chart": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "--read-only",
        "docker.io/acuvity/mcp-server-chart:0.9.7"
      ]
    }
  }
}
```

更多信息请参见[Anthropic文档](https://docs.anthropic.com/en/docs/agents-and-tools/mcp)。
</details>

<details>
<summary>OpenAI Python SDK</summary>

## 本地运行

```python
async with MCPServerStdio(
    params={
        "command": "docker",
        "args": ["run","-i","--rm","--read-only","docker.io/acuvity/mcp-server-chart:0.9.7"]
    }
) as server:
    tools = await server.list_tools()
```

## 远程运行

```python
async with MCPServerSse(
    params={
        "url": "http://<ip>:<port>/sse",
    }
) as server:
    tools = await server.list_tools()
```

更多信息请参见[OpenAI Agents SDK文档](https://openai.github.io/openai-agents-python/mcp/)。

</details>

## 🐳 使用Docker运行

<details>
<summary>本地使用STDIO</summary>

在客户端配置中设置：

- 命令：`docker`
- 参数：`run -i --rm --read-only docker.io/acuvity/mcp-server-chart:0.9.7`

</details>

<details>
<summary>本地使用HTTP/sse</summary>

直接运行：

```console
docker run -it -p 8000:8000 --rm --read-only docker.io/acuvity/mcp-server-chart:0.9.7
```

然后在您的应用程序/客户端中，可以配置为：

```json
{
  "mcpServers": {
    "acuvity-mcp-server-chart": {
      "url": "http://localhost:8000/sse"
    }
  }
}
```

您可能需要为不同的工具使用不同的端口。

</details>

<details>
<summary>使用Websocket隧道和MTLS远程运行</summary>

> 本节假设您熟悉TLS和证书，并且需要：
> - 具有与工具部署匹配的正确DNS/IP字段的服务器证书。
> - 用于签署客户端证书的client-ca

1. 以`backend`模式启动服务器
 - 添加环境变量，如`-e MINIBRIDGE_MODE=backend`
 - 通过卷添加TLS证书（推荐），例如`/certs`（如`-v $PWD/certs:/certs`）
 - 指示minibridge使用这些证书：
   - `-e MINIBRIDGE_TLS_SERVER_CERT=/certs/server-cert.pem`
   - `-e MINIBRIDGE_TLS_SERVER_KEY=/certs/server-key.pem`
   - `-e MINIBRIDGE_TLS_SERVER_KEY_PASS=optional`（可选）
   - `-e MINIBRIDGE_TLS_SERVER_CLIENT_CA=/certs/client-ca.pem`

2. 在本地以frontend模式启动`minibridge`：
  - 获取适用于您操作系统的[minibridge](https://github.com/acuvity/minibridge)二进制文件。

在客户端配置中，Minibridge的工作方式与任何其他STDIO命令相同。

Claude Desktop示例：

```json
{
  "mcpServers": {
    "acuvity-mcp-server-chart": {
      "command": "minibridge",
      "args": ["frontend", "--backend", "wss://<remote-url>:8000/ws", "--tls-client-backend-ca", "/path/to/ca/that/signed/the/server-cert.pem/ca.pem", "--tls-client-cert", "/path/to/client-cert.pem", "--tls-client-key", "/path/to/client-key.pem"]
    }
  }
}
```

就是这样。

Minibridge提供了许多额外功能。如需分步指导，请访问wiki。如有任何不清楚之处，欢迎联系我们！

</details>

## ☁️ 在Kubernetes上部署

<details>
<summary>使用Helm Charts部署</summary>

### 安装方法

您可以查看chart的`README
