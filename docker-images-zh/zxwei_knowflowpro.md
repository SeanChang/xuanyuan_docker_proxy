---
image: zxwei/knowflowpro
description: "KnowFlow企业级智能知识库解决方案的Docker镜像，支持快速部署，集成文档解析、智能检索与企业级管理功能。"
source: https://xuanyuan.cloud/zh/r/zxwei/knowflowpro
canonical: https://xuanyuan.cloud/zh/r/zxwei/knowflowpro
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zxwei/knowflowpro" title="zxwei/knowflowpro Docker 镜像中文简介、标签列表与拉取命令">zxwei/knowflowpro — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/zxwei/knowflowpro" title="zxwei/knowflowpro Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/zxwei/knowflowpro</a>

# zxwei/knowflow Docker镜像技术文档


## 1. 镜像概述和主要用途

### 1.1 镜像概述
<div align="center">
  <img src="knowflow/assets/logo.png" alt="KnowFlow 企业知识库" width="30%">
</div>

KnowFlow是基于RAGFlow的企业级开源知识库解决方案，专注于为企业提供知识管理落地的最后一公里服务。本Docker镜像封装了KnowFlow的完整服务组件，包括后端服务、前端界面及相关依赖，支持快速部署企业级智能知识库系统，且持续兼容RAGFlow官方版本（当前适配RAGFlow v0.20.1）。

### 1.2 主要用途
- 构建企业内部智能知识库，实现文档集中管理与高效检索
- 支持多格式文档解析（20+格式）、OCR文字识别及图文混排输出
- 提供精准语义检索与上下文感知问答，助力企业知识高效利用
- 集成团队协作与权限管理，满足企业级数据安全与访问控制需求


## 2. 核心功能和特性

### 2.1 核心功能
- **智能文档解析**：集成MinerU2.x OCR引擎，支持图文混排输出、多种分块策略及20+文档格式解析
- **增强检索问答**：提供精准语义检索、上下文感知问答、多模态内容理解及实时知识更新
- **企业级管理**：支持用户权限管理（RBAC）、团队协作空间、纯离线部署及企业微信/LDAP/SSO集成
- **开放集成**：采用插件化架构，提供API开放接口，支持自定义扩展与第三方系统集成

### 2.2 关键特性
- **插件化架构**：无缝兼容RAGFlow任意版本，增强功能可热插拔，升级无风险
- **微服务设计**：作为独立服务运行，不修改RAGFlow核心代码，降低集成复杂度
- **简化部署**：支持Docker Compose一键部署，提供完整镜像包，减少环境配置成本
- **性能优化**：支持GPU加速（需NVIDIA GPU及相关工具），提升文档解析与检索效率


## 3. 使用场景和适用范围

### 3.1 典型使用场景
- **企业内部知识库**：集中管理产品手册、流程规范、技术文档等，支持员工快速查询
- **客户服务支持**：整合客户资料、常见问题等，辅助客服人员高效响应客户咨询
- **研发团队协作**：管理技术文档、代码注释、项目经验，促进团队知识共享
- **政务/教育领域**：构建政策法规库、教学资源库，实现精准检索与智能问答

### 3.2 适用范围
- **用户群体**：企业IT部门、知识管理专员、研发团队、客服团队等
- **环境要求**：支持Docker 20.10+、Docker Compose 2.0+的服务器，推荐8GB+内存，GPU可选（提升性能）
- **部署规模**：中小型企业全量部署、大型企业部门级部署，支持离线环境


## 4. 使用方法和配置说明

### 4.1 基础使用（Docker Compose）

#### 4.1.1 部署步骤
1. 克隆项目代码：
```bash
git clone https://github.com/weizxfree/KnowFlow.git
cd KnowFlow
```

2. 配置MinerU服务地址（可选，用于增强文档解析）：
编辑`/knowflow/server/services/config/settings.yaml`：
```yaml
fastapi:
  url: "http://宿主机IP:8888"  # MinerU API服务地址
  timeout: 30000
vlm:
  sglang:
    server_url: "http://宿主机IP:30000"  # VLM视觉模型服务地址（如需多模态分析）
```

3. 启动容器：
```bash
cd docker
docker compose up -d
```

4. 访问系统：
通过`http://服务器IP:80`访问KnowFlow首页

### 4.2 镜像构建（开发者）

#### 4.2.1 构建全镜像
```bash
# 安装依赖管理工具uv
sudo snap install astral-uv --classic
# 安装系统依赖
sudo apt-get update && sudo apt-get install -y python3.12-dev build-essential pkg-config libicu-dev
# 下载依赖
av run download_deps.py
# 构建基础依赖镜像
docker build -f Dockerfile.deps -t infiniflow/ragflow_deps .
# 构建KnowFlow镜像
docker build --build-arg LIGHTEN=1 -f Dockerfile -t zxwei/knowflow:latest .
```

#### 4.2.2 构建前后端分离镜像
```bash
# 后端镜像
docker buildx build --platform linux/amd64 --target backend -t zxwei/knowflow-server:latest --push .
# 前端镜像
docker buildx build --platform linux/amd64 --target frontend -t zxwei/knowflow-web:latest --push .
```

### 4.3 性能优化建议
1. **启用GPU加速**：配置NVIDIA GPU及nvidia-container-toolkit，提升文档解析与模型推理速度
2. **资源配置**：为容器分配至少8GB内存，推荐使用SSD存储提升I/O性能
3. **网络优化**：如需外网访问，配置适当防火墙规则，保障服务安全


## 5. 参考链接
- 项目GitHub地址：[https://github.com/weizxfree/KnowFlow](https://github.com/weizxfree/KnowFlow)
- 官方网站：[https://www.knowflowchat.cn/](https://www.knowflowchat.cn/)
- B站演示视频：[https://www.bilibili.com/video/BV1Vfg8zDEUf/](https://www.bilibili.com/video/BV1Vfg8zDEUf/)
