# 飞书/钉钉/QQ 机器人一站式搞定！OpenClaw Docker 部署教程

![飞书/钉钉/QQ 机器人一站式搞定！OpenClaw Docker 部署教程](https://img.xuanyuan.dev/docker/blog/docker-openclaw-im.png)

*分类: OpenClaw,AI,部署教程 | 标签: OpenClaw,AI,部署教程,飞书,钉钉,QQ | 发布时间: 2026-03-06 02:54:25*

> OpenClaw 中国 IM 插件整合版 Docker 镜像，预装并配置了飞书、钉钉、QQ机器人、企业微信等主流中国 IM 平台插件，让您可以快速部署一个支持多个中国 IM 平台的 AI 机器人网关。
> 
> 同时集成了OpenCode AI代码助手、Playwright浏览器自动化工具及中文TTS语音合成功能，适用于需要构建多平台IM机器人的开发者与科研用户。
> 
> 本指南将详细介绍其Docker部署流程，包括环境准备、镜像拉取、容器配置、功能测试及生产环境优化建议，帮助用户快速实现服务部署与应用。

# 一、概述

OpenClaw-Docker-CN-IM（OpenClaw 中国IM平台整合Docker版本）是一款容器化应用，旨在提供集成中国主流IM平台的AI机器人网关解决方案。该镜像预装并配置了飞书、钉钉、QQ机器人、企业微信等插件，支持通过环境变量灵活配置，实现快速部署与数据持久化。

同时集成了OpenCode AI代码助手、Playwright浏览器自动化工具及中文TTS语音合成功能，适用于需要构建多平台IM机器人的开发者与科研用户。

本指南将详细介绍其Docker部署流程，包括环境准备、镜像拉取、容器配置、功能测试及生产环境优化建议，帮助用户快速实现服务部署与应用。

# 二、项目简介与核心特性

## 2.1 项目简介

OpenClaw 中国 IM 插件整合版 Docker 镜像，预装并配置了飞书、钉钉、QQ机器人、企业微信等主流中国 IM 平台插件，让您可以快速部署一个支持多个中国 IM 平台的 AI 机器人网关。

官方项目地址: https://github.com/justlovemaki/OpenClaw-Docker-CN-IM

国内镜像地址：

- openclaw-docker-cn-im 项目：https://xuanyuan.cloud/zh/r/justlikemaki/openclaw-docker-cn-im
- AIClient-2-API 项目：https://xuanyuan.cloud/r/justlikemaki/aiclient-2-api

## 2.2 核心特性

- 🚀 开箱即用：预装所有中国主流 IM 平台插件
- 🔧 灵活配置：通过环境变量轻松配置各平台凭证
- 🐳 Docker 部署：一键启动，无需复杂配置
- 📦 数据持久化：支持配置和工作空间数据持久化
- 💻 OpenCode AI：内置 AI 代码助手，支持智能代码生成和分析
- 🎭 Playwright：预装浏览器自动化工具，支持网页操作和截图
- 🗣️ 中文 TTS：支持中文语音合成（Text-to-Speech）

## 2.3 支持的平台

### 2.3.1 IM 平台

- ✅ 飞书（Feishu/Lark）
- ✅ 钉钉（DingTalk）
- ✅ QQ 机器人（QQ Bot）
- ✅ 企业微信（WeCom）

### 2.3.2 集成工具

- ✅ OpenCode AI - AI 代码助手
- ✅ Playwright - 浏览器自动化
- ✅ 中文 TTS - 语音合成

推荐搭配：OpenClaw 功能强大但 Token 消耗较大，推荐配合 AIClient-2-API 项目使用，将各大 AI 客户端转换为标准 API 接口，实现无限 Token 调用，彻底解决 Token 焦虑！本项目已支持 OpenAI 和 Claude 两种协议，可直接对接 AIClient-2-API 服务。

# 三、环境准备

## 3.1 Docker环境安装

部署OpenClaw-Docker-CN-IM前需确保Docker环境已正确安装。推荐使用以下一键安装脚本（适用于Linux系统）：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

安装完成后，可通过以下命令验证Docker是否正常运行：

```bash
docker --version  # 检查Docker版本
docker info       # 查看Docker系统信息
```

# 四、镜像准备

## 4.1 拉取镜像

使用以下命令通过轩辕镜像访问支持域名拉取最新版本的 OpenClaw-Docker-CN-IM 镜像（拉取后将在配置文件中直接引用，确保镜像有效使用）：

```bash
docker pull docker.xuanyuan.run/justlikemaki/openclaw-docker-cn-im:latest
```

拉取完成后，可通过以下命令验证镜像是否成功下载：

```bash
docker images | grep justlikemaki/openclaw-docker-cn-im
```

轩辕镜像地址：https://xuanyuan.cloud/zh/r/justlikemaki/openclaw-docker-cn-im

备用拉取命令（直接从Docker Hub拉取）：

```bash
docker pull justlikemaki/openclaw-docker-cn-im:latest
```

# 五、快速开始（一键部署）

按照以下步骤，可快速启动OpenClaw-Docker-CN-IM服务，无需复杂配置。

## 5.1 获取配置文件

无需下载配置文件，直接复制以下完整内容，分别创建 docker-compose.yml 和 .env.example 文件（两个文件需放在同一目录下）：

### 5.1.1 docker-compose.yml 完整内容

```bash
version: '3.8'

services:
  openclaw-gateway:
    container_name: openclaw-gateway
    image: ${OPENCLAW_IMAGE}  # 引用.env文件中的镜像配置，默认使用轩辕拉取的镜像
    cap_add:
      - CHOWN
      - SETUID
      - SETGID
      - DAC_OVERRIDE
    # 可选：指定容器运行 UID:GID（例如 1000:1000）
    # 默认保持 root 启动，以便 init.sh 自动修复挂载卷权限后再降权运行网关
    user: ${OPENCLAW_RUN_USER:-0:0}
    environment:
      TZ: Asia/Shanghai
      HOME: /home/node
      TERM: xterm-256color
      # 模型配置
      SYNC_MODEL_CONFIG: ${SYNC_MODEL_CONFIG}
      MODEL_ID: ${MODEL_ID}
      IMAGE_MODEL_ID: ${IMAGE_MODEL_ID}
      BASE_URL: ${BASE_URL}
      API_KEY: ${API_KEY}
      API_PROTOCOL: ${API_PROTOCOL}
      CONTEXT_WINDOW: ${CONTEXT_WINDOW}
      MAX_TOKENS: ${MAX_TOKENS}
      # 提供商 2 (可选)
      MODEL2_NAME: ${MODEL2_NAME}
      MODEL2_MODEL_ID: ${MODEL2_MODEL_ID}
      MODEL2_BASE_URL: ${MODEL2_BASE_URL}
      MODEL2_API_KEY: ${MODEL2_API_KEY}
      MODEL2_PROTOCOL: ${MODEL2_PROTOCOL}
      MODEL2_CONTEXT_WINDOW: ${MODEL2_CONTEXT_WINDOW}
      MODEL2_MAX_TOKENS: ${MODEL2_MAX_TOKENS}
      # 通道配置
      TELEGRAM_BOT_TOKEN: ${TELEGRAM_BOT_TOKEN}
      FEISHU_APP_ID: ${FEISHU_APP_ID}
      FEISHU_APP_SECRET: ${FEISHU_APP_SECRET}
      DINGTALK_CLIENT_ID: ${DINGTALK_CLIENT_ID}
      DINGTALK_CLIENT_SECRET: ${DINGTALK_CLIENT_SECRET}
      DINGTALK_ROBOT_CODE: ${DINGTALK_ROBOT_CODE}
      DINGTALK_CORP_ID: ${DINGTALK_CORP_ID}
      DINGTALK_AGENT_ID: ${DINGTALK_AGENT_ID}
      QQBOT_APP_ID: ${QQBOT_APP_ID}
      QQBOT_CLIENT_SECRET: ${QQBOT_CLIENT_SECRET}
      NAPCAT_REVERSE_WS_PORT: ${NAPCAT_REVERSE_WS_PORT}
      NAPCAT_HTTP_URL: ${NAPCAT_HTTP_URL}
      NAPCAT_ACCESS_TOKEN: ${NAPCAT_ACCESS_TOKEN}
      NAPCAT_ADMINS: ${NAPCAT_ADMINS}
      # 企业微信配置
      WECOM_TOKEN: ${WECOM_TOKEN}
      WECOM_ENCODING_AES_KEY: ${WECOM_ENCODING_AES_KEY}
      # 企业微信多账号配置（JSON 字符串，示例见 .env.example）
      WECOM_BOTS_JSON: ${WECOM_BOTS_JSON}
      # 工作空间配置
      WORKSPACE: ${WORKSPACE}
      # Gateway 配置
      OPENCLAW_GATEWAY_TOKEN: ${OPENCLAW_GATEWAY_TOKEN}
      OPENCLAW_GATEWAY_BIND: ${OPENCLAW_GATEWAY_BIND}
      OPENCLAW_GATEWAY_PORT: ${OPENCLAW_GATEWAY_PORT}
      OPENCLAW_BRIDGE_PORT: ${OPENCLAW_BRIDGE_PORT}
      OPENCLAW_GATEWAY_MODE: ${OPENCLAW_GATEWAY_MODE}
      OPENCLAW_GATEWAY_ALLOWED_ORIGINS: ${OPENCLAW_GATEWAY_ALLOWED_ORIGINS}
      OPENCLAW_GATEWAY_ALLOW_INSECURE_AUTH: ${OPENCLAW_GATEWAY_ALLOW_INSECURE_AUTH}
      OPENCLAW_GATEWAY_DANGEROUSLY_DISABLE_DEVICE_AUTH: ${OPENCLAW_GATEWAY_DANGEROUSLY_DISABLE_DEVICE_AUTH}
      OPENCLAW_GATEWAY_AUTH_MODE: ${OPENCLAW_GATEWAY_AUTH_MODE}
      # 插件控制
      OPENCLAW_PLUGINS_ENABLED: ${OPENCLAW_PLUGINS_ENABLED}
    volumes:
      - ${OPENCLAW_DATA_DIR}:/home/node/.openclaw
      # 使用匿名卷排除 extensions 目录，使用镜像中预装的插件
      - /home/node/.openclaw/extensions
    ports:
      - "${OPENCLAW_GATEWAY_PORT}:18789"
      - "${OPENCLAW_BRIDGE_PORT}:18790"
    init: true
    restart: unless-stopped
```

### 5.1.2 .env.example 完整内容

```bash
# OpenClaw Docker 环境变量配置示例
# 复制此文件为 .env 并修改相应的值
# 注意：若使用轩辕镜像拉取的镜像，可将下方OPENCLAW_IMAGE改为 docker.xuanyuan.run/justlikemaki/openclaw-docker-cn-im:latest

# Docker 镜像配置（直接引用拉取的镜像，确保镜像有效使用）
OPENCLAW_IMAGE=justlikemaki/openclaw-docker-cn-im:latest
# 轩辕镜像配置（若已通过轩辕镜像拉取，建议替换上方地址为以下内容）
# OPENCLAW_IMAGE=docker.xuanyuan.run/justlikemaki/openclaw-docker-cn-im:latest

# 模型配置
# 是否自动同步模型配置到 openclaw.json (true/false)
# 如果你手动修改了 openclaw.json 中的模型设置，请将其设为 false
SYNC_MODEL_CONFIG=true

# 提供商 1 (默认)
# 主模型 ID (支持多个，用逗号隔开，第一个将作为默认模型)
MODEL_ID=model id
# 图片模型 ID (可选，留空则使用 MODEL_ID，支持 provider/model 格式)
IMAGE_MODEL_ID=
BASE_URL=http://xxxxx/v1
API_KEY=123456
# API 协议类型: openai-completions 或 anthropic-messages
API_PROTOCOL=openai-completions
# 模型上下文窗口大小
CONTEXT_WINDOW=200000
# 模型最大输出 tokens
MAX_TOKENS=8192

# 提供商 2 (可选)
# MODEL2_NAME=model2
# MODEL2_MODEL_ID=model id1,model id2
# MODEL2_BASE_URL=http://xxxxx/v1
# MODEL2_API_KEY=123456
# MODEL2_PROTOCOL=openai-completions
# MODEL2_CONTEXT_WINDOW=200000
# MODEL2_MAX_TOKENS=8192

# Telegram 配置（可选，留空则不启用）
TELEGRAM_BOT_TOKEN=

# 飞书配置（可选，留空则不启用）
FEISHU_APP_ID=
FEISHU_APP_SECRET=

# 钉钉配置（可选，留空则不启用）
DINGTALK_CLIENT_ID=
DINGTALK_CLIENT_SECRET=
DINGTALK_ROBOT_CODE=
DINGTALK_CORP_ID=
DINGTALK_AGENT_ID=

# QQ 机器人配置（可选，留空则不启用）
QQBOT_APP_ID=
QQBOT_CLIENT_SECRET=
# NapCat (OneBot v11) 配置（可选，留空则不启用）
# NapCat 反向 WS 监听端口（NapCat 主动连接到此端口）
NAPCAT_REVERSE_WS_PORT=
# NapCat HTTP API 地址（可选，用于主动发送消息）
NAPCAT_HTTP_URL=
# 连接鉴权 Token（与 NapCat 侧保持一致）
NAPCAT_ACCESS_TOKEN=
# 管理员用户 ID，多个用逗号分隔
NAPCAT_ADMINS=

# 企业微信配置（可选，留空则不启用）
# 方式1：单账号（兼容旧格式），会自动同步为 channels.wecom.default
WECOM_TOKEN=
WECOM_ENCODING_AES_KEY=
# 方式2：多账号（Multi-Bot）JSON，支持 bot1/bot2... 独立配置（会与现有配置深度合并）
# 注意：.env 中 JSON 需要写成单行
# 示例：{"bot1":{"token":"t1","encodingAesKey":"k1","agent":{"corpId":"wwxxx","corpSecret":"s1","agentId":1000001}},"bot2":{"token":"t2","encodingAesKey":"k2","agent":{"corpId":"wwxxx","corpSecret":"s2","agentId":1000002}}}
WECOM_BOTS_JSON=

# 工作空间配置（不要更改）
WORKSPACE=/home/node/.openclaw/workspace

# 挂载目录配置（按实际更改）
# OpenClaw 数据目录（包含配置文件、工作空间等所有数据）
OPENCLAW_DATA_DIR=~/.openclaw

# 可选：容器启动用户 UID:GID
# 默认 0:0（root）用于 init.sh 自动修复挂载目录权限，再降权为 node 启动服务
# 如需与宿主机用户对齐，可设置为 1000:1000 或 Linux 上的 $(id -u):$(id -g)
OPENCLAW_RUN_USER=0:0

# Gateway 配置
## 网关 token，用于认证（按实际更改）
OPENCLAW_GATEWAY_TOKEN=123456
OPENCLAW_GATEWAY_BIND=lan
OPENCLAW_GATEWAY_PORT=18789
OPENCLAW_BRIDGE_PORT=18790
OPENCLAW_GATEWAY_MODE=local
# 允许的 Origin 域，多个用逗号隔开
OPENCLAW_GATEWAY_ALLOWED_ORIGINS=http://localhost
# 允许不安全认证（如 http），可选 true/false
OPENCLAW_GATEWAY_ALLOW_INSECURE_AUTH=true
# 危险：禁用设备认证（如在 Docker 环境中无法获取设备信息），可选 true/false
OPENCLAW_GATEWAY_DANGEROUSLY_DISABLE_DEVICE_AUTH=false
# 插件全局控制
OPENCLAW_PLUGINS_ENABLED=true
```

## 5.2 配置环境变量

复制环境变量模板并编辑，至少配置AI模型相关参数，同时确认镜像配置与拉取的轩辕镜像一致：

```bash
# 复制环境变量模板
cp .env.example .env
```
```bash
# 编辑配置文件（推荐使用nano或vim）
nano .env
```

### 5.2.1 最小配置示例

| 环境变量 | 说明 | 示例值 |
| --- | --- | --- |
| MODEL_ID | AI 模型名称 | gpt-4 |
| BASE_URL | AI 服务 API 地址 | https://api.openai.com/v1 |
| API_KEY | AI 服务 API 密钥 | sk-xxx... |
| OPENCLAW_IMAGE | 镜像地址（轩辕镜像） | docker.xuanyuan.run/justlikemaki/openclaw-docker-cn-im:latest |

提示：IM 平台配置为可选项，可以先启动服务，后续再配置需要的平台。

## 5.3 启动服务

```bash
docker-compose up -d
```

## 5.4 查看日志

```bash
docker-compose logs -f
```

## 5.5 停止服务

```bash
docker-compose down
```

# 六、详细配置指南

## 6.1 AI 模型配置

本项目支持 OpenAI 协议和 Claude 协议两种 API 格式，可直接对接 AIClient-2-API 服务。

推荐模型：推荐使用 gemini-3-flash-preview 模型，该模型具有超大上下文窗口（1M tokens）、快速响应速度和优秀的性价比，非常适合作为 OpenClaw 的后端模型。

### 6.1.1 基础配置参数

| 参数 | 说明 | 默认值 |
| --- | --- | --- |
| MODEL_ID | 模型名称 | model id |
| BASE_URL | Provider Base URL | http://xxxxx/v1 |
| API_KEY | Provider API Key | 123456 |
| API_PROTOCOL | API 协议类型 | openai-completions |
| CONTEXT_WINDOW | 模型上下文窗口大小 | 200000 |
| MAX_TOKENS | 模型最大输出 tokens | 8192 |

### 6.1.2 协议类型说明

| 协议类型 | 适用模型 | Base URL 格式 | 特殊特性 |
| --- | --- | --- | --- |
| openai-completions | OpenAI、Gemini 等 | 需要 /v1 后缀 | - |
| anthropic-messages | Claude | 不需要 /v1 后缀 | Prompt Caching、Extended Thinking |

### 6.1.3 配置示例

1. OpenAI 协议（Gemini 模型）
```
MODEL_ID=gemini-3-flash-preview
BASE_URL=http://localhost:3000/v1
API_KEY=your-api-key
API_PROTOCOL=openai-completions
CONTEXT_WINDOW=1000000
MAX_TOKENS=8192
```

2. Claude 协议（Claude 模型）
```
MODEL_ID=claude-sonnet-4-5
BASE_URL=http://localhost:3000
API_KEY=your-api-key
API_PROTOCOL=anthropic-messages
CONTEXT_WINDOW=200000
MAX_TOKENS=8192
```

### 6.1.4 AIClient-2-API 配置补充

前置准备：启动 AIClient-2-API 服务，在 Web UI (http://localhost:3000) 配置至少一个提供商，记录配置文件中的 API Key。

如需指定特定提供商，可修改 Base URL：

```
# Kiro 提供的 Claude (OpenAI 协议)
BASE_URL=http://localhost:3000/claude-kiro-oauth/v1

# Kiro 提供的 Claude (Claude 协议)
BASE_URL=http://localhost:3000/claude-kiro-oauth

# Gemini CLI (OpenAI 协议)
BASE_URL=http://localhost:3000/gemini-cli-oauth/v1

# Antigravity (OpenAI 协议)
BASE_URL=http://localhost:3000/gemini-antigravity/v1
```

## 6.2 Gateway 配置

| 参数 | 说明 | 默认值 |
| --- | --- | --- |
| OPENCLAW_GATEWAY_TOKEN | Gateway 访问令牌 | 123456 |
| OPENCLAW_GATEWAY_BIND | 绑定地址 | lan |
| OPENCLAW_GATEWAY_PORT | Gateway 端口 | 18789 |
| OPENCLAW_BRIDGE_PORT | Bridge 端口 | 18790 |

## 6.3 工作空间配置

| 参数 | 说明 | 默认值 |
| --- | --- | --- |
| WORKSPACE | 工作空间目录 | /home/node/.openclaw/workspace |

## 6.4 IM 平台配置

### 6.4.1 飞书配置

1. 获取飞书机器人凭证

- 在 飞书开放平台 创建自建应用
- 添加应用能力-机器人
- 在凭证页面获取 App ID 和 App Secret
- 开启所需权限（见下方）⚠️ 重要
- 配置事件订阅（见下方）⚠️ 重要

2. 必需权限（租户级别）

| 权限 | 范围 | 说明 |
| --- | --- | --- |
| im:message | 消息 | 发送和接收消息（核心权限） |
| im:message.p2p_msg:readonly | 私聊 | 读取发给机器人的私聊消息 |
| im:message.group_at_msg:readonly | 群聊 | 接收群内 @机器人 的消息 |
| im:message:send_as_bot | 发送 | 以机器人身份发送消息 |
| im:resource | 媒体 | 上传和下载图片/文件 |
| im:chat.members:bot_access | 群成员 | 获取群成员信息 |
| im:chat.access_event.bot_p2p_chat:read | 聊天事件 | 读取机器人单聊事件 |

3. 推荐权限（租户级别）

| 权限 | 范围 | 说明 |
| --- | --- | --- |
| contact:user.employee_id:readonly | 用户信息 | 获取用户员工 ID（用于用户识别） |
| im:message:readonly | 读取 | 获取历史消息 |
| application:application:self_manage | 应用管理 | 应用自我管理 |
| application:bot.menu:write | 机器人菜单 | 配置机器人菜单 |
| event:ip_list | IP 列表 | 获取飞书服务器 IP 列表 |

4. 可选权限（租户级别）

| 权限 | 范围 | 说明 |
| --- | --- | --- |
| aily:file:read | AI 文件读取 | 读取 AI 助手文件 |
| aily:file:write | AI 文件写入 | 写入 AI 助手文件 |
| application:application.app_message_stats.overview:readonly | 消息统计 | 查看应用消息统计概览 |
| corehr:file:download | 人事文件 | 下载人事系统文件 |

5. 用户级别权限（可选）

| 权限 | 范围 | 说明 |
| --- | --- | --- |
| aily:file:read | AI 文件读取 | 以用户身份读取 AI 助手文件 |
| aily:file:write | AI 文件写入 | 以用户身份写入 AI 助手文件 |
| im:chat.access_event.bot_p2p_chat:read | 聊天事件 | 以用户身份读取机器人单聊事件 |

6. 事件订阅 ⚠️（最容易遗漏）

如果机器人能发消息但收不到消息，请检查此项。在飞书开放平台的应用后台，进入 事件与回调 页面：

- 事件配置方式：选择 使用长连接接收事件（推荐）
- 添加事件订阅，勾选以下事件：

| 事件 | 说明 |
| --- | --- |
| im.message.receive_v1 | 接收消息（必需） |
| im.message.message_read_v1 | 消息已读回执 |
| im.chat.member.bot.added_v1 | 机器人进群 |
| im.chat.member.bot.deleted_v1 | 机器人被移出群 |

确保事件订阅的权限已申请并通过审核。

7. 环境变量配置（在 .env 文件中添加）

```
FEISHU_APP_ID=your-app-id
FEISHU_APP_SECRET=your-app-secret
```

### 6.4.2 钉钉配置

1. 创建钉钉应用

- 访问 钉钉开发者后台
- 创建企业内部应用
- 添加「机器人」能力
- 配置消息接收模式为 Stream 模式
- 发布应用

2. 获取凭证

从开发者后台获取：Client ID（AppKey）、Client Secret（AppSecret）、Robot Code（与 Client ID 相同）、Corp ID（与 Client ID 相同）、Agent ID（应用 ID）

3. 环境变量配置（在 .env 文件中添加）

```
DINGTALK_CLIENT_ID=your-dingtalk-client-id
DINGTALK_CLIENT_SECRET=your-dingtalk-client-secret
DINGTALK_ROBOT_CODE=your-dingtalk-robot-code
DINGTALK_CORP_ID=your-dingtalk-corp-id
DINGTALK_AGENT_ID=your-dingtalk-agent-id
```

参数说明：

- DINGTALK_CLIENT_ID - 必需，钉钉应用的 Client ID（AppKey）
- DINGTALK_CLIENT_SECRET - 必需，钉钉应用的 Client Secret（AppSecret）
- DINGTALK_ROBOT_CODE - 可选，机器人 Code，默认与 Client ID 相同
- DINGTALK_CORP_ID - 可选，企业 ID
- DINGTALK_AGENT_ID - 可选，应用 Agent ID

### 6.4.3 QQ 机器人配置

1. 获取 QQ 机器人凭证

- 访问 QQ 开放平台
- 创建机器人应用
- 获取 AppID 和 AppSecret（ClientSecret）
- 获取主机在公网的 IP，配置到 IP 白名单

2. 环境变量配置（在 .env 文件中添加）

```
QQBOT_APP_ID=你的AppID
QQBOT_CLIENT_SECRET=你的AppSecret
```

### 6.4.4 企业微信配置

1. 获取企业微信凭证

- 访问 企业微信管理后台
- 进入"应用管理" - 用 API 模式创建"智能机器人"应用
- 在应用的"接收消息"配置中设置 Token 和 EncodingAESKey
- 设置"接收消息"URL 为你的服务地址（例如：https://your-domain.com/webhooks/wxwork），需要当前服务可公网访问

2. 环境变量配置（在 .env 文件中添加）

```
WECOM_TOKEN=your-token
WECOM_ENCODING_AES_KEY=your-aes-key
```

# 七、高级使用

## 7.1 使用 Docker 命令运行

如果不使用 Docker Compose，可以直接使用 Docker 命令启动容器（引用轩辕镜像，确保镜像有效使用）：

```bash
docker run -d \
  --name openclaw-gateway \
  --cap-add=CHOWN \
  --cap-add=SETUID \
  --cap-add=SETGID \
  --cap-add=DAC_OVERRIDE \
  -e MODEL_ID=model id \
  -e BASE_URL=http://xxxxx/v1 \
  -e API_KEY=123456 \
  -e API_PROTOCOL=openai-completions \
  -e CONTEXT_WINDOW=200000 \
  -e MAX_TOKENS=8192 \
  -e FEISHU_APP_ID=your-app-id \
  -e FEISHU_APP_SECRET=your-app-secret \
  -e DINGTALK_CLIENT_ID=your-dingtalk-client-id \
  -e DINGTALK_CLIENT_SECRET=your-dingtalk-client-secret \
  -e DINGTALK_ROBOT_CODE=your-dingtalk-robot-code \
  -e DINGTALK_CORP_ID=your-dingtalk-corp-id \
  -e DINGTALK_AGENT_ID=your-dingtalk-agent-id \
  -e QQBOT_APP_ID=your-qqbot-app-id \
  -e QQBOT_CLIENT_SECRET=your-qqbot-client-secret \
  -e WECOM_TOKEN=your-token \
  -e WECOM_ENCODING_AES_KEY=your-aes-key \
  -e OPENCLAW_GATEWAY_TOKEN=123456 \
  -e OPENCLAW_GATEWAY_BIND=lan \
  -e OPENCLAW_GATEWAY_PORT=18789 \
  -v ~/.openclaw:/home/node/.openclaw \
  -v ~/.openclaw/workspace:/home/node/.openclaw/workspace \
  -p 18789:18789 \
  -p 18790:18790 \
  --restart unless-stopped \
  docker.xuanyuan.run/justlikemaki/openclaw-docker-cn-im:latest  # 使用轩辕镜像
```

## 7.2 数据持久化

容器使用以下卷进行数据持久化，确保配置和工作数据不丢失：

- - /home/node/.openclaw - OpenClaw 配置和数据目录
- - /home/node/.openclaw/workspace - 工作空间目录

## 7.3 端口说明

- - 18789 - OpenClaw Gateway 端口
- - 18790 - OpenClaw Bridge 端口

## 7.4 自定义配置文件

如果需要完全自定义配置文件，可按以下步骤操作：

- - 在宿主机创建配置文件 ~/.openclaw/openclaw.json
- - 挂载该目录到容器：-v ~/.openclaw:/home/node/.openclaw
- - 容器启动时会检测到已存在的配置文件，跳过自动生成

# 八、常见问题

**Q: 修改了环境变量但配置没有生效？**

容器启动时只有在配置文件不存在时才会生成新配置。如需重新生成配置，请删除现有配置文件：

```bash
# 删除配置文件
rm ~/.openclaw/openclaw.json
# 重启容器
docker-compose restart
```

或者直接删除整个数据目录重新开始：

```bash
rm -rf ~/.openclaw
docker-compose up -d
```

**Q: 连接 AIClient-2-API 失败？**

- 确认 AIClient-2-API 服务运行中
- 检查 Base URL 是否正确（OpenAI 协议需要 /v1 后缀）
- 尝试使用 127.0.0.1 替代 localhost

**Q: 401 错误？**

- 检查 API Key 是否正确配置
- 确认环境变量 API_KEY 已设置

**Q: 模型不可用？**

- 在 AIClient-2-API Web UI 确认已配置对应提供商
- 重启容器：`docker-compose restart`

**Q: 飞书机器人能发消息但收不到消息？**

- 检查是否配置了事件订阅（最容易遗漏的配置）
- 确认事件配置方式选择了"使用长连接接收事件"
- 确认已添加 im.message.receive_v1 事件

**Q: Telegram 机器人如何配对？**

如果需要启用 Telegram，必须提供有效的 TELEGRAM_BOT_TOKEN，启用后需要执行以下命令进行配对审批：

```bash
openclaw pairing approve telegram {token}
```

并且需要重启 Docker 服务使配置生效。

**Q: 同样的启动命令，为什么有人报错 Permission denied？**

这通常不是命令本身不稳定，而是运行上下文变化导致：宿主机挂载目录所有者（UID/GID）与容器内进程用户不一致。

**为什么会“偶发”**

同样是 docker compose up -d，但目录来源不同：

- 你手动创建目录：可能是当前用户（如 1000:1000）
- Docker 自动创建或使用 sudo 创建：可能是 root:root（0:0）

本镜像最终以 node 用户运行网关；若挂载目录归属不匹配，就可能无法写入。

**快速排查**

```bash
# 1) 看宿主机目录归属（Linux）
ls -ln ~/.openclaw

# 2) 看容器内运行用户
docker run --rm justlikemaki/openclaw-docker-cn-im:latest id
```

若容器用户是 uid=1000，而宿主机目录是 uid=0 且权限不足，就会报错。

**解决方案（推荐顺序）**

1. 宿主机修正目录所有权（最直接）

```bash
sudo chown -R 1000:1000 ~/.openclaw
```

2. 显式指定容器运行用户（可选）

在 .env 中设置：

```
OPENCLAW_RUN_USER=1000:1000
```

然后重启：

```bash
docker compose up -d
```

3. SELinux 场景（CentOS/RHEL/Fedora）

若权限看起来没问题但仍拒绝访问，请给挂载卷加 :z 或 :Z 标签。

**本项目已做的稳态处理：**

- docker-compose.yml 新增可选 user 配置：OPENCLAW_RUN_USER（默认 0:0）
- init.sh 启动时会：打印挂载目录当前 UID/GID 与目标 UID/GID；尝试自动修复 /home/node/.openclaw 权限；若仍不可写，输出明确的修复命令并失败退出，避免“有时成功有时报错”的隐性状态

# 九、注意事项

- 确保宿主机的 18789 和 18790 端口未被占用
- 配置文件中的敏感信息（如 API 密钥、令牌）应妥善保管
- 首次运行时会自动创建必要的目录和配置文件，包括 openclaw.json 配置文件，已存在时不会覆盖
- 容器以 node 用户身份运行，确保挂载的卷有正确的权限
- IM 平台配置均为可选项，可根据实际需求选择性配置
- 使用 OpenAI 协议时，Base URL 需要包含 /v1 后缀
- 使用 Claude 协议时，Base URL 不需要 /v1 后缀

