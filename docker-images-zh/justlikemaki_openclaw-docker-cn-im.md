---
image: justlikemaki/openclaw-docker-cn-im
description: "OpenClaw 的中国 IM 平台整合 Docker 版本，预装飞书、钉钉、QQ 机器人、企业微信等通道，并可通过 OpenAI/Claude 协议对接 AIClient-2-API 等后端服务，用于快速搭建多 IM 入口的 AI 机器人网关。"
source: https://xuanyuan.cloud/zh/r/justlikemaki/openclaw-docker-cn-im
canonical: https://xuanyuan.cloud/zh/r/justlikemaki/openclaw-docker-cn-im
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/justlikemaki/openclaw-docker-cn-im" title="justlikemaki/openclaw-docker-cn-im Docker 镜像中文简介、标签列表与拉取命令">justlikemaki/openclaw-docker-cn-im — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/justlikemaki/openclaw-docker-cn-im" title="justlikemaki/openclaw-docker-cn-im Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/justlikemaki/openclaw-docker-cn-im</a>

# justlikemaki/openclaw-docker-cn-im 镜像说明

## 项目概述

`justlikemaki/openclaw-docker-cn-im` 是 **OpenClaw 的中国 IM 平台整合 Docker 版本**，预装并配置了飞书、钉钉、QQ 机器人、企业微信等主流中国 IM 通道，用于快速搭建一个面向多 IM 平台的 AI 机器人网关。

镜像内置 OpenClaw 网关、本地配置向导以及多种插件，配合 AIClient-2-API 等后端服务，可以把各类 AI 客户端统一转换为标准 API 接口，实现多模型、多协议的统一接入。

> Docker Hub 页面：`https://hub.docker.com/r/justlikemaki/openclaw-docker-cn-im`

## 核心特性

- **中国 IM 平台一体化整合**：
  - ✅ 飞书（Feishu/Lark）
  - ✅ 钉钉（DingTalk）
  - ✅ QQ 机器人（QQ Bot）
  - ✅ 企业微信（WeCom）
- **开箱即用**：镜像预装 OpenClaw 及常用插件，启动后即可根据环境变量自动生成配置文件，无需手动安装依赖。
- **与 AIClient-2-API 深度配合**：推荐与 AIClient-2-API 搭配使用，将各类 AI 客户端统一转换为 OpenAI/Claude 协议，实现“无限 Token 调用”和后端模型切换。
- **多协议、多模型支持**：
  - OpenAI 协议（如：Gemini、OpenAI 等）
  - Claude 协议（Anthropic Messages）
  - 支持自定义 `MODEL_ID`、`BASE_URL`、`API_KEY`、`API_PROTOCOL` 等参数
- **浏览器自动化与代码助手**：内置 OpenCode AI 和 Playwright，可在需要时执行网页操作、截图及代码相关任务。
- **中文 TTS 支持**：集成中文语音合成功能，用于语音回复或语音播报场景。
- **配置与数据持久化**：通过挂载卷将 OpenClaw 配置和工作空间持久化，便于升级与迁移。

## 主要环境变量

### AI 模型与 API 配置

| 变量名           | 说明                     | 示例值                         |
| ---------------- | ------------------------ | ------------------------------ |
| `MODEL_ID`       | 模型名称                 | `gemini-3-flash-preview`      |
| `BASE_URL`       | Provider Base URL       | `http://localhost:3000/v1`    |
| `API_KEY`        | Provider API Key        | `your-api-key`                |
| `API_PROTOCOL`   | API 协议类型            | `openai-completions` / `anthropic-messages` |
| `CONTEXT_WINDOW` | 模型上下文窗口大小      | `1000000`                     |
| `MAX_TOKENS`     | 模型最大输出 tokens 数  | `8192`                        |

### Gateway 网关配置

| 变量名                     | 说明               | 默认值   |
| -------------------------- | ------------------ | -------- |
| `OPENCLAW_GATEWAY_TOKEN`   | 网关访问令牌       | `123456` |
| `OPENCLAW_GATEWAY_BIND`    | 绑定地址           | `lan`    |
| `OPENCLAW_GATEWAY_PORT`    | Gateway 端口       | `18789`  |
| `OPENCLAW_BRIDGE_PORT`     | Bridge 端口        | `18790`  |
| `WORKSPACE`                | 工作空间目录       | `/home/node/.openclaw/workspace` |

### IM 平台示例配置（节选）

#### 飞书（Feishu）

需要在飞书开放平台创建自建应用并获取以下凭证：

- `FEISHU_APP_ID`
- `FEISHU_APP_SECRET`

```bash
FEISHU_APP_ID=your-app-id
FEISHU_APP_SECRET=your-app-secret
```

需要开启 `im:message`、`im.message.receive_v1` 等必要权限，并配置长连接事件订阅。

#### 钉钉（DingTalk）

在钉钉开发者后台创建企业内部应用，获取：

- `DINGTALK_CLIENT_ID`
- `DINGTALK_CLIENT_SECRET`
- 以及可选的 `DINGTALK_ROBOT_CODE`、`DINGTALK_CORP_ID`、`DINGTALK_AGENT_ID`

```bash
DINGTALK_CLIENT_ID=your-dingtalk-client-id
DINGTALK_CLIENT_SECRET=your-dingtalk-client-secret
```

#### QQ 机器人

在 QQ 开放平台创建应用，并配置：

```bash
QQBOT_APP_ID=your-qqbot-app-id
QQBOT_CLIENT_SECRET=your-qqbot-client-secret
```

#### 企业微信（WeCom）

在企业微信后台创建“智能机器人”应用，并配置消息接收回调：

```bash
WECOM_TOKEN=your-token
WECOM_ENCODING_AES_KEY=your-aes-key
```

## Docker 部署示例

### 使用 docker-compose

```bash
wget https://raw.githubusercontent.com/justlovemaki/OpenClaw-Docker-CN-IM/main/docker-compose.yml
wget https://raw.githubusercontent.com/justlovemaki/OpenClaw-Docker-CN-IM/main/.env.example

cp .env.example .env
nano .env  # 根据需要修改模型和 IM 平台配置

docker-compose up -d
```

### 使用 docker run 直接运行

```bash
docker run -d \
  --name openclaw-gateway \
  --cap-add=CHOWN \
  --cap-add=SETUID \
  --cap-add=SETGID \
  --cap-add=DAC_OVERRIDE \
  -e MODEL_ID=gemini-3-flash-preview \
  -e BASE_URL=http://localhost:3000/v1 \
  -e API_KEY=your-api-key \
  -e API_PROTOCOL=openai-completions \
  -e OPENCLAW_GATEWAY_TOKEN=123456 \
  -e OPENCLAW_GATEWAY_BIND=lan \
  -e OPENCLAW_GATEWAY_PORT=18789 \
  -v ~/.openclaw:/home/node/.openclaw \
  -v ~/.openclaw/workspace:/home/node/.openclaw/workspace \
  -p 18789:18789 \
  -p 18790:18790 \
  --restart unless-stopped \
  justlikemaki/openclaw-docker-cn-im:latest
```

## 数据持久化与权限

- 挂载目录：
  - `/home/node/.openclaw`：OpenClaw 配置与运行数据
  - `/home/node/.openclaw/workspace`：工作空间数据
- 建议将上述目录映射到宿主机的持久化路径（如 `~/.openclaw`），以便升级镜像或迁移主机时保持配置和历史数据。
- 若出现 `Permission denied`，需要检查宿主机挂载目录的 UID/GID 是否与容器内运行用户一致，可通过 `chown -R 1000:1000 ~/.openclaw` 等方式修正。

## 适用场景

- 在多个 IM 平台统一接入同一个 AI 助手，作为“多入口统一网关”。
- 将本地/云端大模型服务通过 OpenAI/Claude 协议统一暴露给 OpenClaw 使用。
- 快速搭建具备代码助手、浏览器自动化和中文 TTS 能力的聊天机器人系统。

## 许可协议

项目基于 OpenClaw 构建，遵循 GPL-3.0（GNU General Public License v3.0）协议，具体条款请参考上游仓库与镜像页面中的 LICENSE 说明。
