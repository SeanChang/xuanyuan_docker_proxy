---
image: sipeed/picoclaw
description: "矽速科技开源的 PicoClaw 超轻量个人 AI 助手镜像：纯 Go 实现，支持 MCP、网关与 Docker Compose（Gateway / Launcher / Agent），详见官方中文 README 与 Docker 文档。"
source: https://xuanyuan.cloud/zh/r/sipeed/picoclaw
canonical: https://xuanyuan.cloud/zh/r/sipeed/picoclaw
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sipeed/picoclaw" title="sipeed/picoclaw Docker 镜像中文简介、标签列表与拉取命令">sipeed/picoclaw — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/sipeed/picoclaw" title="sipeed/picoclaw Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/sipeed/picoclaw</a>

# sipeed/picoclaw 镜像文档

## 镜像概述

**PicoClaw** 是由 [矽速科技 (Sipeed)](https://sipeed.com) 发起的独立开源项目，完全使用 **Go 语言**从零编写——不是其他项目的分支。它是一款受 [NanoBot](https://github.com/HKUDS/nanobot) 启发的**超轻量级个人 AI 助手**，强调极低资源占用与快速启动，并支持原生 [MCP（Model Context Protocol）](https://modelcontextprotocol.io/)、多 LLM 提供商、模型路由、视觉管线（向 Agent 发送图片/文件）等能力。

官方镜像便于在 Docker 环境中通过 Compose 部署 **Gateway（网关）**、**Launcher（Web 控制台）** 或 **Agent（一次性/交互对话）**，无需在宿主机单独安装运行环境。

更多信息见项目中文说明：[README.zh.md](https://github.com/sipeed/picoclaw/blob/main/README.zh.md)。

## 核心功能与特性

- **极致轻量**：面向低配置设备与容器场景设计（近期版本因功能迭代，实际内存占用可能高于早期宣传，以官方说明为准）
- **纯 Go 单二进制**：跨 x86_64、ARM64、RISC-V 等多种架构，便于分发与部署
- **MCP 原生集成**：可连接任意 MCP 服务器扩展 Agent 能力
- **智能路由**：基于规则的模型路由，简单任务可走轻量模型以节省 API 成本
- **多 Provider**：支持配置多种 LLM 提供商与 `model_list`（详见官方文档）
- **Docker 多模式**：Gateway / Launcher（含 Web UI）/ Agent 等运行方式

## 使用场景

- 在服务器或开发机上快速部署个人 AI 助手与网关服务
- 使用 Launcher 在浏览器中完成配置与对话（默认本地端口，勿对公网暴露）
- 在 CI 或脚本中通过 Agent 模式执行一次性问答任务

## 使用方法

### 推荐：使用官方仓库中的 Docker Compose

官方文档说明可使用仓库内 `docker/docker-compose.yml` 运行（无需本地安装 Go 等环境）。典型流程如下（与 [Docker 与快速开始](https://github.com/sipeed/picoclaw/blob/main/docs/zh/docker.md) 一致）：

```bash
# 1. 克隆仓库
git clone https://github.com/sipeed/picoclaw.git
cd picoclaw

# 2. 首次运行 — 自动生成 docker/data/config.json 后退出
#    （仅在 config.json 和 workspace/ 都不存在时触发）
docker compose -f docker/docker-compose.yml --profile gateway up
# 容器打印 "First-run setup complete." 后自动停止

# 3. 填写 API Key 等配置
vim docker/data/config.json

# 4. 正式启动
docker compose -f docker/docker-compose.yml --profile gateway up -d
```

查看日志与停止：

```bash
docker compose -f docker/docker-compose.yml logs -f picoclaw-gateway
docker compose -f docker/docker-compose.yml --profile gateway down
```

### Launcher 模式（Web 控制台）

```bash
docker compose -f docker/docker-compose.yml --profile launcher up -d
```

浏览器访问 `http://localhost:18800`。Launcher 会管理 Gateway 进程。

### Agent 模式（一次性或交互）

```bash
docker compose -f docker/docker-compose.yml run --rm picoclaw-agent -m "2+2 等于几？"
docker compose -f docker/docker-compose.yml run --rm picoclaw-agent
```

### 网关监听地址（需从宿主机访问健康检查等）

默认 Gateway 可能监听 `127.0.0.1`，端口不会映射到容器外。若需通过端口映射从外部访问，请在环境变量中设置 `PICOCLAW_GATEWAY_HOST=0.0.0.0` 或修改 `config.json`（见官方 Docker 文档说明）。

### 更新镜像

```bash
docker compose -f docker/docker-compose.yml pull
docker compose -f docker/docker-compose.yml --profile gateway up -d
```

## 注意事项

- **安全**：项目处于快速迭代阶段，官方建议在 1.0 正式版前**不要**将其用于生产环境；部署前请阅读仓库安全声明与版本说明。
- **Web 控制台**：Launcher/Web 控制台**尚不支持身份验证**，请勿暴露到公网。
- **无加密货币**：PicoClaw **没有**官方代币；请认准官方网站 [picoclaw.io](https://picoclaw.io) 与 [sipeed.com](https://sipeed.com)，谨防仿冒域名与诈骗信息。
- **配置**：首次运行后务必在生成的 `config.json` 中配置 LLM Provider、Bot Token（若使用聊天渠道）等；完整示例与字段说明见官方[配置指南](https://github.com/sipeed/picoclaw/blob/main/docs/zh/configuration.md)与[提供商文档](https://github.com/sipeed/picoclaw/blob/main/docs/zh/providers.md)。
