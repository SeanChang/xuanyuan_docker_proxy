---
image: dyrnq/open-webui
description: "ghcr.io/open-webui/open-webui 是 GitHub 容器镜像仓库中托管的一款开源 Web 用户界面应用，主要用于构建和部署 AI 交互平台，支持多种主流大语言模型接入，提供可自定义的界面布局与交互功能，便于开发者和用户通过 Web 浏览器便捷访问、管理和使用 AI 服务，具备轻量化部署特性，适合个人或企业快速搭建专属 AI 交互界面。"
source: https://xuanyuan.cloud/zh/r/dyrnq/open-webui
canonical: https://xuanyuan.cloud/zh/r/dyrnq/open-webui
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [dyrnq/open-webui — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/dyrnq/open-webui)

含镜像标签、拉取命令、部署文档与相关推荐。

[dyrnq/open-webui Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/dyrnq/open-webui)

## Open WebUI 容器镜像使用指南


### 一、什么是 Open WebUI？  
这是一个开源的 Web 界面工具，专门用于和各类 AI 模型（尤其是大语言模型）交互。你可以通过它连接本地部署的模型（如用 Ollama 运行的 Llama、Mistral 等）或远程 API 服务（如 OpenAI API、Anthropic API），无需复杂配置就能快速搭建自己的 AI 对话平台，适合个人日常使用或小团队协作。


### 二、核心功能  
1. **多模型兼容**：支持接入本地模型（Ollama、LM Studio）和远程 API（OpenAI、Google Gemini、Anthropic 等），同一界面切换不同模型。  
2. **对话管理**：自动保存对话历史，支持标签分类、搜索历史记录，还能导出对话内容（文本/PDF）。  
3. **自定义配置**：可添加提示词模板、调整模型参数（温度、上下文长度等），甚至自定义界面主题。  
4. **多用户支持**：支持创建多个用户账号，区分不同人的对话数据，适合家庭或团队共享使用。  


### 三、如何用容器镜像快速启动？  
#### 前提：先装 Docker  
确保你的电脑或服务器已安装 Docker（[Docker 官方安装指南]([])），安装后启动 Docker 服务。


#### 1. 拉取镜像  
打开终端，运行以下命令拉取最新镜像（默认拉取 `main` 分支，即开发主版本）：  
```bash
docker pull ghcr.io/open-webui/open-webui:main
```  
如果需要稳定版本，可指定标签（如 `v0.2.3`，具体版本见 [Open WebUI 镜像仓库]([])）：  
```bash
docker pull ghcr.io/open-webui/open-webui:v0.2.3
```  


#### 2. 启动容器  
拉取完成后，用以下命令启动容器（以默认配置为例）：  
```bash
docker run -d \
  --name open-webui \
  -p 3000:8080 \  # 主机端口 3000 映射到容器内 8080（WebUI 默认端口）
  -v open-webui-data:/app/backend/data \  # 数据持久化（保存对话、配置等）
  --restart always \  # 容器意外停止后自动重启
  ghcr.io/open-webui/open-webui:main
```  


#### 3. 访问界面  
启动后，打开浏览器访问 `[] `[] 四、注意事项  
1. **数据别丢了**：启动命令中的 `-v open-webui-data:/app/backend/data` 很重要！它会把对话记录、用户配置等保存在本地 Docker 卷中，即使容器删除，数据也不会丢失。如果没加这个参数，容器删除后数据会清空。  
2. **端口别冲突**：如果主机 3000 端口已被占用，可修改 `-p` 参数中的主机端口（如 `-p 8088:8080`，则通过 8088 端口访问）。  
3. **选对版本**：`main` 分支是开发版，功能新但可能不稳定；生产环境建议用带版本号的镜像（如 `v0.2.3`）。  
4. **网络权限**：如果需要连接外部 API（如 OpenAI API），确保容器能访问互联网；如果用本地模型（如 Ollama），需让容器和本地模型在同一网络（可通过 `--network=host` 参数共享主机网络，或配置桥接网络）。  


通过以上步骤，你就能快速用容器镜像跑起 Open WebUI，开始和 AI 模型交互了。如果需要更复杂的部署（如用 Docker Compose 配数据库、HTTPS 等），可参考 [Open WebUI 官方文档]([])。
