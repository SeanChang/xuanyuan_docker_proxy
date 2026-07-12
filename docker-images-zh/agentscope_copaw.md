---
image: agentscope/copaw
description: "基于 AgentScope 的开源个人 AI 助理 CoPaw 的 Docker 镜像，支持多渠道接入与本地/云端部署，可通过 Web 控制台或钉钉、飞书、QQ 等频道使用。"
source: https://xuanyuan.cloud/zh/r/agentscope/copaw
canonical: https://xuanyuan.cloud/zh/r/agentscope/copaw
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/agentscope/copaw" title="agentscope/copaw Docker 镜像中文简介、标签列表与拉取命令">agentscope/copaw 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CoPaw

**[CoPaw](https://github.com/agentscope-ai/CoPaw)** 是基于 [AgentScope](https://github.com/agentscope-ai/agentscope) 的开源个人 AI 助理，支持多端接入、本地与云端部署，可通过 Web 控制台或钉钉、飞书、QQ、Discord、Telegram、iMessage 等频道与助手对话。本镜像为 CoPaw 的官方 Docker 镜像，便于在容器中一键运行。

## 核心能力

- **多渠道接入**：一个 CoPaw 实例可连接钉钉、飞书、QQ、Discord、Telegram、iMessage 等，按需配置。
- **数据与记忆由你掌控**：配置、记忆与个性化数据可保存在本地或云端；支持定时任务与指定频道协作。
- **Skills 扩展**：内置定时任务，支持自定义技能目录，CoPaw 自动加载，无绑定。

## 镜像与标签

- **镜像**：`agentscope/copaw`（Docker Hub）
- **标签**：`latest`（稳定版）；`pre`（PyPI 预发布版）
- 国内用户可选用阿里云容器镜像：`agentscope-registry.ap-southeast-1.cr.aliyuncs.com/agentscope/copaw`，tag 与上述一致。

## 使用 Docker 快速开始

### 拉取并运行

```bash
docker pull docker.xuanyuan.run/agentscope/copaw:latest
docker run -p 8088:8088 -v copaw-data:/app/working docker.xuanyuan.run/agentscope/copaw:latest
```

在浏览器打开 **http://127.0.0.1:8088/** 即可进入 CoPaw 控制台（与助手对话、配置 Agent）。

数据卷 `copaw-data` 用于持久化配置、记忆与 Skills；若需自定义挂载路径，可将 `/app/working` 替换为宿主机目录。

### 传入 API Key 或环境变量

使用云端大模型（如 DashScope、OpenAI）时，需配置 API Key。通过 `-e` 或 `--env-file` 传入：

```bash
docker run -p 8088:8088 -v copaw-data:/app/working -e DASHSCOPE_API_KEY=你的Key docker.xuanyuan.run/agentscope/copaw:latest
```

或使用 env 文件：

```bash
docker run -p 8088:8088 -v copaw-data:/app/working --env-file .env docker.xuanyuan.run/agentscope/copaw:latest
```

仅使用本地模型（如 Ollama、llama.cpp）时，无需配置云端 API Key。

### 使用 docker-compose 运行

```yaml
services:
  copaw:
    image: docker.xuanyuan.run/agentscope/copaw:latest
    ports:
      - "8088:8088"
    volumes:
      - copaw-data:/app/working
    environment:
      - DASHSCOPE_API_KEY=你的Key
volumes:
  copaw-data:
```

## 配置说明

- **模型与 API Key**：首次使用前在控制台 **设置 → 模型** 中选择提供商并填写 API Key，或通过环境变量传入。
- **频道接入**：在钉钉、飞书、QQ 等中使用 CoPaw 需在官方文档中按「频道配置」完成接入。
- **本地模型**：CoPaw 支持 llama.cpp、MLX（Apple Silicon）、Ollama 等本地后端；在容器中或宿主机部署本地服务后，在控制台中配置对应地址即可。

## 其他部署方式

除 Docker 外，CoPaw 支持 pip 安装（`pip install copaw`）、一键安装脚本（含 Windows PowerShell）、魔搭创空间及阿里云 ECS 等部署方式，详见 [CoPaw 官方文档](https://github.com/agentscope-ai/CoPaw)。

## 自行构建镜像

从源码构建镜像可参考 CoPaw 仓库中 `scripts/README.md` 的「Build Docker image」小节，构建后推送到自有镜像仓库即可。

## 许可证

CoPaw 为开源项目，许可证见 [GitHub 仓库](https://github.com/agentscope-ai/CoPaw)。
