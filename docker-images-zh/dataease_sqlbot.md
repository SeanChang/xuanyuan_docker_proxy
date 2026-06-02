---
image: dataease/sqlbot
description: "基于大型语言模型（大模型）与检索增强生成（RAG）技术构建的智能问数系统，通过深度融合大模型的自然语言理解与推理能力，以及RAG对结构化和非结构化数据的精准检索能力，实现用户以自然语言提问即可快速获取准确数据结论的功能，广泛应用于企业数据分析、业务决策支持等场景，有效提升数据查询效率与决策响应速度，为用户提供智能化、便捷化的数据问答体验。"
source: https://xuanyuan.cloud/zh/r/dataease/sqlbot
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[dataease/sqlbot](https://xuanyuan.cloud/zh/r/dataease/sqlbot)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# SQLBot 介绍


## 关于 SQLBot  
SQLBot 是一款结合大模型与 RAG 技术的智能问数系统，核心特点如下：  

### 开箱即用，快速上手  
无需复杂配置，只需完成大模型和数据源的基础设置，即可启动问数功能。系统通过大模型与 RAG 技术的结合，能高效实现 text2sql 转换，直接满足智能问数需求。  

### 易于集成，灵活扩展  
支持快速嵌入第三方业务系统，也可被 n8n、MaxKB、Dify、Coze 等 AI 应用开发平台直接调用。通过简单集成，各类应用能快速获得智能问数能力，扩展业务场景。  

### 安全可控，权限分明  
采用工作空间机制实现资源隔离，可按需求配置细粒度数据权限，确保数据访问安全，满足不同场景下的权限管理需求。  


## 快速开始使用  

### 安装部署  
#### Docker 一键部署  
准备一台 Linux 服务器，先安装 [Docker]([])，随后执行以下一键部署脚本：  

```bash
docker run -d \
  --name sqlbot \
  --restart unless-stopped \
  -p 8000:8000 \
  -p 8001:8001 \
  -v ./data/sqlbot/excel:/opt/sqlbot/data/excel \
  -v ./data/sqlbot/file:/opt/sqlbot/data/file \
  -v ./data/sqlbot/images:/opt/sqlbot/images \
  -v ./data/sqlbot/logs:/opt/sqlbot/app/logs \
  -v ./data/postgresql:/var/lib/postgresql/data \
  --privileged=true \
  dataease/sqlbot
```

#### 1Panel 应用商店部署  
也可通过 [1Panel 应用商店]([]) 直接搜索并快速部署 SQLBot。  


### 访问系统  
部署完成后，在浏览器中输入地址：  
`http://<你的服务器IP>:8000/`  

- 默认用户名：admin  
- 默认密码：SQLBot@123456
