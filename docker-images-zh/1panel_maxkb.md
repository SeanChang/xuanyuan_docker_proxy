---
image: 1panel/maxkb
description: "这是一款即开即用、灵活高效的RAG聊天机器人，基于检索增强生成技术，无需复杂配置即可直接部署使用，具备高度灵活性以适配多样化的应用场景与数据需求，通过高效检索外部知识库信息并结合生成式AI能力，能够精准理解用户需求、提供准确且上下文相关的智能响应。"
source: https://xuanyuan.cloud/zh/r/1panel/maxkb
canonical: https://xuanyuan.cloud/zh/r/1panel/maxkb
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/1panel/maxkb" title="1panel/maxkb Docker 镜像中文简介、标签列表与拉取命令">1panel/maxkb — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/1panel/maxkb" title="1panel/maxkb Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/1panel/maxkb</a>

# MaxKB：企业级智能体构建开源平台


## 简介  
MaxKB（全称Max Knowledge Brain）是一款企业级智能体构建开源平台，整合检索增强生成（RAG）流水线，支持稳健工作流及高级MCP工具调用能力。其核心应用场景包括智能客服、企业内部知识库、学术研究及教育等领域。


## 核心功能  

### RAG流水线  
支持直接上传文档或自动爬取在线文档，具备自动文本拆分、向量化处理能力。可有效减少大模型输出“幻觉”，提升智能问答交互体验。

### 智能工作流  
配备工作流引擎、函数库及MCP工具调用能力，可编排AI流程以适配复杂业务场景需求。

### 无缝集成  
支持零代码快速接入第三方业务系统，为现有系统赋予智能问答能力，提升用户使用满意度。

### 模型无关性  
兼容多种大模型，包括私有模型（如DeepSeek、Llama、Qwen等）及公共模型（如OpenAI、Claude、Gemini等）。

### 多模态支持  
原生支持文本、图片、音频、视频的输入与输出。


## 快速启动  
通过Docker快速部署：  
```bash
docker run -d --name=maxkb --restart=always -p 8080:8080 -v ~/.maxkb:/opt/maxkb 1panel/maxkb
```  
- 默认用户名：admin  
- 默认密码：MaxKB@123..  


## 技术栈  
- **前端**：[Vue.js]([])  
- **后端**：[Python / Django]([])  
- **LLM框架**：[LangChain]([])  
- **数据库**：[PostgreSQL + pgvector]([])  


## 许可证  
MaxKB基于GNU通用公共许可证第3版（GPLv3）授权。用户需遵守许可条款，详情参见[GPLv3许可证]([])。  
除非法律要求或书面约定，软件按“原样”分发，不提供任何明示或暗示的担保（包括但不限于适销性、特定用途适用性等）。具体权限与限制请参照许可证条款。


项目地址：[GitHub Repo]([])
