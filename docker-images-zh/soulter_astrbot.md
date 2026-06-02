---
image: soulter/astrbot
description: "AstrBot 是一个开源的多功能聊天机器人框架，支持与 、、微信等主流消息平台无缝集成，具备自然语言处理、插件化扩展以添加自定义功能、多轮对话及 API 对接能力，帮助用户高效自动化任务、提升交互体验并构建个性化聊天机器人解决方案。"
source: https://xuanyuan.cloud/zh/r/soulter/astrbot
canonical: https://xuanyuan.cloud/zh/r/soulter/astrbot
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/soulter/astrbot" title="soulter/astrbot Docker 镜像中文简介、标签列表与拉取命令">soulter/astrbot 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# AstrBot 介绍


## 简介  
AstrBot 是一个基于 OneBot 协议开发的轻量级跨平台机器人框架，旨在提供灵活的消息处理与功能扩展能力。它支持多平台消息收发，并通过插件系统和 AI 集成，满足多样化的自动化交互需求，适合个人或小型团队快速搭建定制化机器人。


## 核心功能  

### 1. 多平台适配  
支持主流即时通讯平台消息交互，包括但不限于：  
- QQ（基于 go-cqhttp 等协议端）  
-   
-   
- 微信（需配合第三方协议端，具体参考文档）  


### 2. AI 对话集成  
可接入主流 AI 模型实现智能交互，目前支持：  
- OpenAI GPT 系列（需配置 API Key）  
- Google Gemini  
- 本地部署模型（如 Llama 系列，需额外配置推理服务）  
通过简单配置即可实现文本对话、问题解答、内容生成等交互场景。  


### 3. 插件化扩展  
采用插件系统设计，支持功能模块化开发与集成：  
- 内置基础插件（如关键词回复、定时任务、天气查询）  
- 提供插件开发模板与文档，开发者可通过 Python 编写自定义插件（基于事件回调机制）  
- 支持热加载，无需重启机器人即可更新插件  


### 4. 数据管理与配置  
- 本地文件存储配置信息（如平台参数、AI 模型密钥、插件开关），支持 JSON/YAML 格式  
- 用户数据与对话历史可选择性持久化（本地 SQLite 数据库或文件），支持数据备份与清理  


## 安装与使用  


### 环境准备  
- 系统：Windows/macOS/Linux（推荐 Linux 服务器长期运行）  
- 依赖：Python 3.8+，pip  
- 协议端：根据目标平台选择（如 QQ 需搭配 go-cqhttp， 需申请 Bot Token）  


### 快速启动步骤  

#### 1. 克隆仓库  
```bash  
git clone []  
cd AstrBot  
```  

#### 2. 安装依赖  
```bash  
pip install -r requirements.txt  
```  

#### 3. 配置文件设置  
编辑项目根目录下的 `config.yaml`，配置关键参数：  
- `platform`：目标平台（如 `qq` ``）  
- `onebot_config`：协议端连接信息（如 QQ 协议端的 IP、端口）  
- `ai`：AI 模型配置（如 `model: gpt-3.5-turbo`，`api_key: your_openai_key`）  
- `plugins`：启用插件列表（如 `[reply, weather, ai_chat]`）  


#### 4. 启动机器人  
```bash  
python main.py  
```  

- 若使用 Docker 部署：参考项目 `docker-compose.yml` 配置，执行 `docker-compose up -d`  


## 注意事项  

1. **平台权限**：  
   - QQ 机器人需确保协议端（如 go-cqhttp）已正确登录并配置消息上报格式（需与 OneBot v11 协议兼容）  
   - / 机器人需提前在对应平台申请 Bot 账号并获取 Token  


2. **AI 模型使用**：  
   - 第三方 AI 模型（如 GPT）需确保 API Key 有效且余额充足，避免调用失败  
   - 本地模型需自行部署推理服务（如通过 FastAPI 封装），并在配置中填写服务地址  


3. **插件开发**：  
   自定义插件需遵循项目插件规范（参考 `plugins/example_plugin.py`），并将插件文件放入 `plugins/` 目录，重启机器人或使用热加载命令生效  


## 总结  
AstrBot 以轻量、可扩展为核心优势，适合需要快速搭建跨平台机器人的用户。通过简单配置即可实现基础消息处理，结合插件与 AI 集成可进一步扩展功能。详细文档与示例可参考项目 GitHub 仓库的 `docs/` 目录。
