<!-- xuanyuan-docker-images-zh
image: lfnovo/open_notebook
source: https://xuanyuan.cloud/zh/r/lfnovo/open_notebook
canonical: https://xuanyuan.cloud/zh/r/lfnovo/open_notebook
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [lfnovo/open_notebook — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/lfnovo/open_notebook "lfnovo/open_notebook Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/lfnovo/open_notebook

# Open Notebook 镜像文档

## 镜像概述和主要用途
Open Notebook是一款开源、注重隐私的Google Notebook LM替代方案。在人工智能主导的时代，思考和获取新知识的能力不应为少数人所独享，也不应受限于单一服务提供商。该镜像旨在让用户不再将数据交给Google，而是自主掌控研究工作流，支持管理研究资料、生成AI辅助笔记及与内容交互，一切操作均以用户需求为中心。

## 核心功能和特性
- **开源与隐私优先**：源代码完全开放，聚焦用户数据隐私保护，避免数据被第三方平台收集
- **替代Google Notebook LM**：提供与Google Notebook LM类似的核心功能，同时扩展更多实用特性
- **自主研究工作流**：用户可完全控制研究数据和工作流程，无需依赖第三方服务
- **AI辅助笔记生成**：集成人工智能技术，辅助用户高效生成和整理研究笔记
- **内容交互能力**：支持与个人内容进行深度交互，提升知识管理和利用效率

## 使用场景和适用范围
- **研究人员**：需要管理大量学术文献、实验数据，生成结构化研究笔记的科研工作者
- **学生群体**：用于课程学习、文献阅读时的笔记整理、知识消化与复习
- **知识工作者**：内容创作者、分析师等需高效管理个人知识库并进行深度内容交互的用户
- **隐私敏感用户**：不愿将数据上传至第三方平台，希望本地或自主控制数据的隐私保护需求者

## 使用方法和配置说明
### 基本部署流程
（注：以下为通用部署示例，具体命令请以官方最新文档为准）

#### 1. 拉取镜像
```bash
docker pull opennotebook/open-notebook:latest
```

#### 2. 启动容器
```bash
docker run -d -p 8080:8080 --name open-notebook opennotebook/open-notebook:latest
```

#### 3. 访问应用
容器启动后，通过浏览器访问 `http://localhost:8080` 即可使用Open Notebook。

### 配置说明
目前官方尚未提供详细配置参数说明，建议通过项目官网获取最新配置指南：  
[https://www.open-notebook.ai](https://www.open-notebook.ai)
