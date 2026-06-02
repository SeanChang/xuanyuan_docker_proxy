<!-- xuanyuan-docker-images-zh
image: dataease/sqlbot
source: https://xuanyuan.cloud/zh/r/dataease/sqlbot
canonical: https://xuanyuan.cloud/zh/r/dataease/sqlbot
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/dataease/sqlbot" title="dataease/sqlbot Docker 镜像中文简介、标签列表与拉取命令">dataease/sqlbot — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/dataease/sqlbot" title="dataease/sqlbot Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/dataease/sqlbot</a></p>

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

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/dataease/sqlbot" title="dataease/sqlbot Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/dataease/sqlbot</a></p>
