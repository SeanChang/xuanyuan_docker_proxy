<!-- xuanyuan-docker-images-zh
image: moltbot/moltbot
source: https://xuanyuan.cloud/zh/r/moltbot/moltbot
canonical: https://xuanyuan.cloud/zh/r/moltbot/moltbot
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [moltbot/moltbot — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/moltbot/moltbot "moltbot/moltbot Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/moltbot/moltbot

# Clawdbot — 个人AI助手

## 镜像概述和主要用途

Clawdbot是一款可在您自己设备上运行的个人AI助手。它能通过您已在使用的渠道（如WhatsApp、Telegram、Slack、Discord、Signal、iMessage等）与您交互，支持macOS/iOS/Android平台的语音交互，并可渲染您控制的实时Canvas。如果您需要一个个人化、单用户、本地运行、响应迅速且始终在线的助手，Clawdbot正是您的理想选择。

## 核心功能和特性

### 主要功能

- **本地优先网关**：单一控制平面，管理会话、渠道、工具和事件
- **多渠道收件箱**：支持WhatsApp、Telegram、Slack、Discord、Signal、iMessage等多种消息渠道
- **多代理路由**：将入站渠道/账户/对等方路由到隔离的代理
- **语音唤醒与对话模式**：macOS/iOS/Android上的始终在线语音功能
- **实时Canvas**：代理驱动的可视化工作区，支持A2UI
- **一流工具集**：浏览器控制、Canvas、节点、定时任务、会话管理等
- **配套应用**：macOS菜单栏应用、iOS/Android节点应用
- **引导式设置**：向导驱动的设置流程，包含捆绑/托管/工作区技能

### 安全特性

- 默认DM配对策略：未知发件人将收到配对码，机器人不处理其消息
- 明确的允许列表机制：控制谁可以与助手交互
- 沙箱模式：可将非主会话（群组/渠道）运行在Docker沙箱中
- 权限管理：精细控制设备本地操作权限

## 使用场景和适用范围

- 个人日常助手：日程管理、提醒、信息查询
- 多平台消息集中管理：在一个界面处理来自不同渠道的消息
- 语音交互应用：免手动输入的语音控制和响应
- 自动化任务：定时任务、webhook触发、邮件通知处理
- 远程设备控制：通过节点应用控制iOS/Android设备功能
- 视觉化工作空间：使用Canvas功能进行协作和内容创作

## 详细使用方法和配置说明

### 系统要求

- Node.js ≥ 22
- npm、pnpm或bun包管理器
- 支持的操作系统：macOS、Linux、Windows（通过WSL2，强烈推荐）

### 安装方法

#### npm安装（推荐）

```bash
npm install -g clawdbot@latest
# 或使用pnpm: pnpm add -g clawdbot@latest

# 运行引导式设置向导
clawdbot onboard --install-daemon
```

#### 从源码安装（开发）

```bash
git clone https://github.com/clawdbot/clawdbot.git
cd clawdbot

pnpm install
pnpm ui:build # 首次运行时自动安装UI依赖
pnpm build

pnpm clawdbot onboard --install-daemon

# 开发循环（TS更改时自动重新加载）
pnpm gateway:watch
```

### 快速启动

```bash
# 运行引导式设置并安装守护进程
clawdbot onboard --install-daemon

# 启动网关
clawdbot gateway --port 18789 --verbose

# 发送消息
clawdbot message send --to +1234567890 --message "来自Clawdbot的问候"

# 与助手对话
clawdbot agent --message "船舶检查清单" --thinking high
```

### Docker部署

#### 基本docker run命令

```bash
docker run -d \
  --name clawdbot \
  -p 18789:18789 \
  -v ~/.clawdbot:/root/.clawdbot \
  -e NODE_ENV=production \
  clawdbot/clawdbot:latest \
  clawdbot gateway --port 18789
```

#### docker-compose配置

```yaml
version: '3.8'

services:
  clawdbot:
    image: clawdbot/clawdbot:latest
    container_name: clawdbot
    restart: unless-stopped
    ports:
      - "18789:18789"
    volumes:
      - ~/.clawdbot:/root/.clawdbot
    environment:
      - NODE_ENV=production
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - OPENAI_API_KEY=${OPENAI_API_KEY}
    command: clawdbot gateway --port 18789 --verbose
```

### 配置说明

#### 环境变量

- `ANTHROPIC_API_KEY`: Anthropic API密钥（用于Claude Pro/Max）
- `OPENAI_API_KEY`: OpenAI API密钥（用于ChatGPT/Codex）
- `TELEGRAM_BOT_TOKEN`: Telegram机器人令牌
- `SLACK_BOT_TOKEN`: Slack机器人令牌
- `SLACK_APP_TOKEN`: Slack应用令牌
- `DISCORD_BOT_TOKEN`: Discord机器人令牌

#### 配置文件

最小化配置文件示例 `~/.clawdbot/clawdbot.json`:

```json5
{
  agent: {
    model: "anthropic/claude-opus-4-5"
  },
  channels: {
    telegram: {
      botToken: "123456:ABCDEF"
    },
    discord: {
      token: "1234abcd"
    }
  },
  browser: {
    enabled: true,
    controlUrl: "http://127.0.0.1:18791",
    color: "#FF4500"
  }
}
```

### 聊天命令

在支持的消息渠道中发送以下命令：

- `/status` — 紧凑的会话状态（模型+令牌，可用时显示成本）
- `/new` 或 `/reset` — 重置会话
- `/compact` — 压缩会话上下文（摘要）
- `/think <级别>` — 设置思考级别（off|minimal|low|medium|high|xhigh）
- `/verbose on|off` — 切换详细模式
- `/usage off|tokens|full` — 设置每响应使用情况页脚
- `/restart` — 重启网关（群组中仅所有者可用）
- `/activation mention|always` — 群组激活切换（仅群组）

## 开发渠道

- **stable**: 标记发布版本 (`vYYYY.M.D` 或 `vYYYY.M.D-<patch>`)，npm dist-tag `latest`
- **beta**: 预发布版本 (`vYYYY.M.D-beta.N`)，npm dist-tag `beta`（可能缺少macOS应用）
- **dev**: 开发中的主分支版本，npm dist-tag `dev`（发布时）

切换渠道：
```bash
clawdbot update --channel stable|beta|dev
```

## 安全设置

Clawdbot连接到真实的消息平台，默认将入站DM视为不受信任的输入。

默认行为（Telegram/WhatsApp/Signal/iMessage/Microsoft Teams/Discord/Slack）：
- **DM配对**：未知发件人会收到简短的配对码，机器人不会处理其消息
- 批准命令：`clawdbot pairing approve <channel> <code>`（发送者将被添加到本地允许列表）
- 公共入站DM需要显式选择加入：设置 `dmPolicy="open"` 并在渠道允许列表中包含 `"*"`

运行 `clawdbot doctor` 可检查风险/配置错误的DM策略。

## 文档和资源

- [官方网站](https://clawdbot.com)
- [完整文档](https://docs.clawd.bot)
- [入门指南](https://docs.clawd.bot/start/getting-started)
- [更新指南](https://docs.clawd.bot/install/updating)
- [安全指南](https://docs.clawd.bot/gateway/security)
- [配置参考](https://docs.clawd.bot/gateway/configuration)
