---
image: mintplexlabs/anythingllm
description: "这是一款集多用户协作与数据私有化为一体的RAG与AI智能体应用程序及用户界面，支持适配任何大型语言模型，整合检索增强生成与智能体交互功能，提供便捷高效的一站式AI服务体验，满足用户在不同场景下的智能检索、对话交互等需求。"
source: https://xuanyuan.cloud/zh/r/mintplexlabs/anythingllm
canonical: https://xuanyuan.cloud/zh/r/mintplexlabs/anythingllm
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mintplexlabs/anythingllm" title="mintplexlabs/anythingllm Docker 镜像中文简介、标签列表与拉取命令">mintplexlabs/anythingllm — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mintplexlabs/anythingllm" title="mintplexlabs/anythingllm Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mintplexlabs/anythingllm</a>

# AnythingLLM 介绍


## 概述  
**AnythingLLM** 是一款全栈AI应用，可让你与文档对话、使用AI代理，支持高度自定义配置、多用户协作，且无需复杂部署。桌面版已开放公开测试，可[立即下载]([])。


## 产品定位  
AnythingLLM 支持接入主流商用或开源LLM及向量数据库，帮助你构建私有化“ChatGPT”——既可本地运行，也可远程托管，能智能对话各类文档。核心设计围绕“工作区”（workspace）展开：工作区类似对话线程，但支持文档隔离存储，不同工作区互不干扰，确保上下文独立清晰。


## 核心功能  
- **多用户与权限管理**：支持多人协作，可配置不同权限  
- **工作区内置AI代理**：支持网页浏览、代码运行等扩展能力  
- **可嵌入网站的聊天组件**：提供[自定义嵌入工具]([])，方便集成到个人网站  
- **多文档类型支持**：兼容PDF、TXT、DOCX等格式  
- **可视化文档管理**：通过简洁UI直接管理向量数据库中的文档  
- **两种聊天模式**：  
  - 对话模式：保留历史问答，支持上下文连续交互  
  - 查询模式：针对文档内容进行简单问答  
- **引用标注**：聊天中自动标注内容来源  
- **云部署就绪**：支持直接部署到云端环境  
- **自定义LLM接入**：支持“自带模型”（Bring your own LLM）  
- **成本优化**：大幅降低大文档嵌入成本，避免重复处理，比同类工具节省90%费用  
- **开发者API**：提供完整接口，支持自定义集成  


## 支持的模型与数据库  

### 语言模型（LLM）  
- 开源模型：llama.cpp兼容模型、Ollama、LM Studio、LocalAI、Mistral、KoboldCPP、Text Generation Web UI等  
- 商用服务：OpenAI、Azure OpenAI、Anthropic、Google Gemini Pro、Hugging Face、Together AI、Perplexity、OpenRouter、Groq、Cohere、LiteLLM等  


### 嵌入模型  
- 默认：AnythingLLM原生嵌入模型  
- 其他：OpenAI、Azure OpenAI、LocalAI、Ollama、LM Studio、Cohere  


### 音频处理  
- **转录**：默认内置模型、OpenAI  
- **文本转语音（TTS）**：浏览器原生（默认）、OpenAI TTS、ElevenLabs  
- **语音转文本（STT）**：浏览器原生（默认）  


### 向量数据库  
- 默认：LanceDB  
- 其他：Astra DB、Pinecone、Chroma、Weaviate、Qdrant、Milvus、Zilliz  


## 技术架构  
项目采用monorepo结构，包含以下核心模块：  
- **frontend**：基于ViteJS+React的前端界面，用于创建和管理LLM所需内容  
- **server**：NodeJS+Express后端服务，处理交互逻辑、向量数据库管理及LLM调用  
- **docker**：Docker构建与部署相关配置  
- **collector**：NodeJS+Express服务，负责解析和处理用户上传的文档  


## 自托管指南  
如需搭建生产环境实例（无Docker），可参考[《裸金属部署文档》]([])。


## 版权信息  
© 2023 [Mintplex Labs]([])  
本项目基于[MIT许可证]([])开源。
