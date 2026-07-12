---
image: naoyoshinori/codex
description: "这是OpenAI Codex CLI的Docker镜像，预安装Node.js和官方Codex工具，提供隔离可复现的AI编码环境，支持团队一致开发、VS Code Dev Containers，非root用户保障安全，可持久化配置与缓存。"
source: https://xuanyuan.cloud/zh/r/naoyoshinori/codex
canonical: https://xuanyuan.cloud/zh/r/naoyoshinori/codex
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/naoyoshinori/codex" title="naoyoshinori/codex Docker 镜像中文简介、标签列表与拉取命令">naoyoshinori/codex 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-codex

OpenAI Codex CLI（`@openai/codex`）的Docker镜像——在干净、可复现的隔离环境中运行强大的终端AI编码代理。

## 镜像概述

本项目提供预安装Node.js和官方[OpenAI Codex CLI](https://developers.openai.com/codex/cli)的即用型Docker镜像。

**使用该镜像的优势：**
- 无需在主机全局安装Node.js或Codex
- 跨机器和团队成员的一致开发环境
- 完美适配VS Code Dev Containers
- 非root用户（`node`）提升安全性
- 预安装实用工具（`git`、`curl`、`ca-certificates`、`bubblewrap`等）
- 通过卷实现配置与缓存持久化

## 可用镜像

| 标签 | 基础镜像 | 描述 |
|------|----------|------|
| `0-node`（最新） | `node:22-bookworm-slim` | 轻量Node.js环境 |
| `0-javascript-node` | Microsoft Dev Container（JS） | 聚焦JavaScript的开发环境 |
| `0-typescript-node` | Microsoft Dev Container（TS） | 聚焦TypeScript的开发环境 |

> 替换`0-`为具体版本号（如`0.128-`）可固定版本。

## 快速开始

### 1. 使用Docker Compose（推荐）

复制以下`docker-compose.yaml`：

```yaml
services:
  codex:
    image: docker.xuanyuan.run/naoyoshinori/codex:0-node
    working_dir: /workspace
    volumes:
      - ~/.gitconfig:/home/node/.gitconfig
      - ~/.codex_cli:/home/node/.codex:cached
      - .:/workspace:cached
    command: ["sleep", "infinity"]
```

启动容器：

```bash
docker compose up -d
docker compose exec codex bash
```

### 2. 单行命令（手动）

```bash
docker run -it --rm \
  -v "$(pwd):/workspace" \
  -v ~/.codex_cli:/home/node/.codex \
  -v ~/.gitconfig:/home/node/.gitconfig \
  -w /workspace \
  docker.xuanyuan.run/naoyoshinori/codex:0-node bash
```

### 3. 容器内操作

```bash
# 首次使用需设置API密钥
export OPENAI_API_KEY=sk-...

# 运行Codex
codex
```

若需要，Codex会引导完成认证与设置。

## 使用示例

### 示例1：启动新项目
```bash
mkdir my-ai-project && cd my-ai-project
docker compose up -d
docker compose exec codex bash

# 容器内：
codex "创建一个带PostgreSQL和任务基础CRUD的FastAPI后端"
```

### 示例2：处理现有代码库
```bash
cd existing-project
docker compose up -d
docker compose exec codex codex "重构用户认证模块并添加速率限制"
```

### 示例3：非交互式运行Codex
```bash
docker compose exec codex codex "添加TypeScript类型并改进错误处理" --yes
```

## VS Code Dev Containers支持

本仓库无缝适配Dev Containers。在项目中添加`.devcontainer/devcontainer.json`：

```json
{
  "image": "naoyoshinori/codex:0-typescript-node",
  "workspaceFolder": "/workspace",
  "postCreateCommand": "codex --version",
  "remoteUser": "node"
}
```

## 配置说明

- Codex配置持久化于主机的`~/.codex_cli`
- Git配置从主机共享
- 所有项目文件挂载于`/workspace`

## 本地构建

```bash
git clone https://github.com/naoyoshinori/docker-codex.git
cd docker-codex

# 构建特定变体
docker build -t codex:local -f src/node/Dockerfile .
```

## 相关项目

- [官方Codex CLI文档](https://developers.openai.com/codex/cli)
- [docker-gemini-cli](https://github.com/naoyoshinori/docker-gemini-cli)（Google Gemini CLI等效镜像）

## 许可证

MIT许可证——详见[LICENSE](LICENSE)文件。
