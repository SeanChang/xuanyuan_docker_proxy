---
image: justlikemaki/aiclient-2-api
description: "AIClient-2-API 将 Gemini CLI、Qwen Code、Kiro Claude 等仅限客户端的大模型接口统一为本地 OpenAI 兼容 API，支持多协议转换、账号池与 Web 管理台，便于 Cline、NextChat 等工具调用 Claude、Gemini、Qwen 等模型。"
source: https://xuanyuan.cloud/zh/r/justlikemaki/aiclient-2-api
canonical: https://xuanyuan.cloud/zh/r/justlikemaki/aiclient-2-api
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/justlikemaki/aiclient-2-api" title="justlikemaki/aiclient-2-api Docker 镜像中文简介、标签列表与拉取命令">justlikemaki/aiclient-2-api — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/justlikemaki/aiclient-2-api" title="justlikemaki/aiclient-2-api Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/justlikemaki/aiclient-2-api</a>

# AIClient-2-API

## 镜像概述和主要用途
AIClient-2-API 是一款强大的 API 代理服务，可将仅在客户端内使用的大模型接口（如 Gemini CLI、Qwen Code Plus、Kiro Claude 等）统一转换为本地 OpenAI 兼容接口，供任意应用调用。基于 Node.js 构建，支持 OpenAI、Claude、Gemini 三种协议的智能转换，使 Cherry-Studio、NextChat、Cline 等工具能够自由使用 Claude Sonnet 4.5、Gemini 2.5 Flash、Qwen3 Coder Plus 等高级模型。项目采用基于策略与适配器的模块化架构，内置账号池管理、智能轮询、自动故障转移与健康检查，保障高可用。

## 核心功能和特性
- **多协议统一接入**：通过标准 OpenAI 兼容协议，一次配置即可访问 Gemini、Claude、GPT、Qwen Code、Kimi K2、GLM-4.6 等主流大模型
- **突破客户端限制**：利用 OAuth 授权机制突破 Gemini 等免费 API 的速率与配额限制，通过 Kiro 免费使用 Claude Sonnet 4.5，通过 Qwen OAuth 使用 Qwen3 Coder Plus
- **多协议智能转换**：支持 OpenAI / Claude / Gemini 协议间智能转换，可用 OpenAI 协议调用 Claude、用 Claude 协议调用 Gemini 等
- **账号池与高可用**：支持多账号轮询、自动故障转移与配置降级，配合健康检查，提升服务可用性
- **Web 管理控制台**：提供仪表盘、配置管理、Provider 池监控、配置文件管理、实时日志等 Web UI（默认访问 http://localhost:3000，默认密码见 pwd 文件）
- **MCP 协议支持**：完整兼容 Model Context Protocol，便于与支持 MCP 的客户端集成
- **容器化部署**：提供 Docker 镜像，一键拉取与跨平台运行

## 使用场景和适用范围
- 将仅限客户端的免费大模型（Gemini CLI、Qwen Code、Kiro Claude 等）暴露为本地 OpenAI 兼容 API，供 Cline、NextChat、Cherry-Studio 等工具调用
- 在单一路由下切换不同模型提供商（OpenAI、Claude、Gemini、Qwen 等），满足开发与测试需求
- 通过 Path 路由（如 /claude-kiro-oauth、/gemini-cli-oauth）或 Ollama 协议统一访问多模型
- 需要全链路请求/响应日志、私有数据集构建或系统提示词覆盖/追加的场景

## 详细使用方法和配置说明

### 拉取与运行镜像

```bash
docker pull justlikemaki/aiclient-2-api
```

### 路径路由与 Provider 对应关系

| 路由路径 | 说明 | 典型用途 |
| --- | --- | --- |
| /claude-custom | 使用配置文件中的 Claude API | 官方 Claude 调用 |
| /claude-kiro-oauth | 通过 Kiro OAuth 访问 Claude | 免费使用 Claude Sonnet 4.5 |
| /openai-custom | 使用 OpenAI 提供商 | 标准 OpenAI API |
| /gemini-cli-oauth | 通过 Gemini CLI OAuth 访问 | 突破 Gemini 免费限制 |
| /openai-qwen-oauth | 通过 Qwen OAuth 访问 | 使用 Qwen Code Plus |
| /openaiResponses-custom | OpenAI Responses API | 结构化对话场景 |
| /ollama | Ollama API 协议 | 统一访问所有支持模型 |

### 授权与配置要点

- **Gemini CLI OAuth**：需在 Google Cloud Console 创建项目并启用 Gemini API，首次使用会在命令行打印授权页，授权后凭证保存在 `~/.gemini/oauth_creds.json`，需提供有效的 `--project-id`。
- **Qwen Code OAuth**：首次启动会自动打开浏览器授权，凭证保存在 `~/.qwen/oauth_creds.json`。
- **Kiro**：需安装 Kiro 客户端并登录，在客户端内生成 `kiro-auth-token.json`（默认路径如 `~/.aws/sso/cache/kiro-auth-token.json`）。
- **账号池**：通过 `PROVIDER_POOLS_FILE_PATH` 或启动参数 `--provider-pools-file` 指定账号池配置文件，支持多账号轮询与健康检查。

### 常用启动参数示例

```bash
# 指定端口与 API Key
node src/api-server.js --port 8080 --api-key my-secret-key

# 使用 OpenAI 提供商
node src/api-server.js --model-provider openai-custom --openai-api-key sk-xxx --openai-base-url https://api.openai.com/v1

# 使用 Gemini（凭证文件）
node src/api-server.js --model-provider gemini-cli-oauth --gemini-oauth-creds-file ./credentials.json --project-id your-project-id

# 使用账号池
node src/api-server.js --provider-pools-file ./provider_pools.json
```

### Ollama 协议示例

```bash
# 列出模型
curl http://localhost:3000/ollama/api/tags

# 聊天（可通过模型前缀指定 Provider：[Kiro]、[Claude]、[Gemini CLI]、[OpenAI]、[Qwen CLI]）
curl http://localhost:3000/ollama/api/chat -H "Content-Type: application/json" -d '{"model": "[Claude] claude-sonnet-4.5", "messages": [{"role": "user", "content": "Hello"}]}'
```

## 相关链接
- [Docker Hub - justlikemaki/aiclient-2-api](https://hub.docker.com/r/justlikemaki/aiclient-2-api)
- 项目 GitHub 与完整文档见镜像仓库说明
- 开源协议：GNU General Public License v3 (GPLv3)
