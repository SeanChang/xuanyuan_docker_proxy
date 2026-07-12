---
image: openwebui/open-webui
description: "Open WebUI 官方 Docker 镜像，用于自托管大模型 Web 聊天界面，支持 Ollama 与 OpenAI 兼容 API，适合本地或内网部署私有 AI 对话服务，提供 RAG、多用户与模型管理等功能。"
source: https://xuanyuan.cloud/zh/r/openwebui/open-webui
canonical: https://xuanyuan.cloud/zh/r/openwebui/open-webui
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openwebui/open-webui" title="openwebui/open-webui Docker 镜像中文简介、标签列表与拉取命令">openwebui/open-webui 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Open WebUI Docker 镜像

Open WebUI 是面向大语言模型的自托管 Web 界面，支持 Ollama、OpenAI 兼容 API 等多种后端，提供对话、RAG、模型管理与用户权限等功能，适合在本地或内网快速搭建私有 AI 聊天服务。

## 典型场景

- 对接 Ollama 本地模型，提供团队可用的浏览器界面
- 通过 OpenAI 兼容端点接入 vLLM、LiteLLM 等推理服务
- 内网部署，避免将对话数据上传至公有云

## 拉取与运行

```bash
docker pull docker.xuanyuan.run/openwebui/open-webui:main
docker run -d -p 3000:8080 -v open-webui:/app/backend/data --name open-webui docker.xuanyuan.run/openwebui/open-webui:main
```

访问 `http://localhost:3000` 完成初始化。生产环境建议配置反向代理、HTTPS 与持久化卷。
