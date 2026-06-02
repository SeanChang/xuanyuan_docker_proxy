---
image: langfuse/langfuse
description: "Langfuse应用容器是开源LLM工程平台，提供追踪、评估、提示词管理等功能，用于LLM应用开发与优化。"
source: https://xuanyuan.cloud/zh/r/langfuse/langfuse
canonical: https://xuanyuan.cloud/zh/r/langfuse/langfuse
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/langfuse/langfuse" title="langfuse/langfuse Docker 镜像中文简介、标签列表与拉取命令">langfuse/langfuse — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/langfuse/langfuse" title="langfuse/langfuse Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/langfuse/langfuse</a>

# Langfuse Docker镜像文档

## 1. 镜像概述和主要用途

Langfuse是一款开源的LLM（大语言模型）工程平台，旨在为LLM应用开发提供全生命周期支持。该Docker镜像封装了Langfuse应用程序，可快速部署并运行Langfuse平台，帮助开发者调试、监控和改进LLM应用。

**主要用途**：提供可观测性、评估、提示管理、交互式 playground 及性能指标分析，支持LLM应用的全链路追踪、效果评估与持续优化。


## 2. 核心功能和特性

### 2.1 核心功能
- **可观测性（Traces）**：追踪LLM应用的调用链路，可视化请求、响应及中间过程，便于问题定位。
- **评估（Evals）**：内置评估框架，支持自定义指标，量化LLM应用的准确性、相关性、安全性等性能。
- **提示管理（Prompts）**：集中管理提示模板，支持版本控制、团队协作，简化提示迭代流程。
- **Playground**：交互式调试环境，快速测试提示与模型响应，实时调整参数。
- **指标（Metrics）**：聚合LLM应用关键指标（如响应时间、成功率、成本等），辅助性能优化。

### 2.2 平台特性
- **开放性**：兼容任意LLM模型（如GPT、Claude、开源模型等）及框架（如LangChain、LlamaIndex等）。
- **复杂场景支持**：允许嵌套调用链路追踪，适配多轮对话、工具调用等复杂LLM应用场景。
- **开放API**：提供完整API接口，支持与下游系统集成，构建自定义工作流。


## 3. 使用场景和适用范围

### 3.1 适用场景
- **LLM应用开发与调试**：开发者可通过追踪链路和playground快速定位应用中的逻辑错误或性能瓶颈。
- **提示工程与管理**：团队集中管理提示模板，追踪版本历史，协作优化提示效果。
- **LLM应用性能评估**：通过评估模块和指标分析，量化应用在不同场景下的表现，指导优化方向。
- **生产环境监控**：部署后持续监控LLM应用运行状态，及时发现并解决线上问题。

### 3.2 适用范围
- 个人开发者调试LLM原型应用
- 企业团队开发生产级LLM应用
- 研究机构评估新型LLM模型性能
- 教育场景演示LLM应用工作原理


## 4. 使用方法和配置说明

### 4.1 镜像拉取

推荐使用最新主版本镜像，确保获取最新功能和安全更新：

```bash
docker pull langfuse/langfuse:2
```

### 4.2 Docker Run部署

基本运行命令（需根据实际需求补充环境变量，详见4.4节）：

```bash
docker run -d \
  --name langfuse \
  -p 3000:3000 \  # 默认Web端口，可根据需求调整
  -e DATABASE_URL="your-db-url" \  # 示例：数据库连接URL（具体需参考官方文档）
  -e NEXTAUTH_SECRET="your-auth-secret" \  # 示例：认证密钥（具体需参考官方文档）
  langfuse/langfuse:2
```

> 注：实际部署需配置必要环境变量（如数据库、认证密钥等），完整环境变量列表请参考[Langfuse官方自托管文档](https://langfuse.com/docs/deployment/self-host)。

### 4.3 Docker Compose部署

创建`docker-compose.yml`文件，示例配置如下：

```yaml
version: '3.8'
services:
  langfuse:
    image: langfuse/langfuse:2
    container_name: langfuse
    ports:
      - "3000:3000"  # Web访问端口
    environment:
      - DATABASE_URL="your-db-url"  # 数据库连接URL
      - NEXTAUTH_SECRET="your-auth-secret"  # 认证密钥
      # 其他必要环境变量请参考官方自托管文档补充
    restart: unless-stopped
```

启动服务：

```bash
docker-compose up -d
```

### 4.4 配置参数说明

Langfuse自托管需通过环境变量配置核心参数，主要包括：

- **数据库配置**：如`DATABASE_URL`（支持PostgreSQL等，具体参考官方文档）。
- **认证配置**：如`NEXTAUTH_SECRET`（用于会话加密）、`NEXTAUTH_URL`（应用访问URL）。
- **API密钥**：如`LANGFUSE_PUBLIC_KEY`、`LANGFUSE_SECRET_KEY`（用于SDK集成）。
- **存储配置**：如对象存储参数（用于存储评估数据、提示模板等）。

完整配置参数及说明请查阅[Langfuse官方自托管文档](https://langfuse.com/docs/deployment/self-host)。


## 5. 注意事项

- **版本管理**：推荐固定使用主版本标签（如`:2`），以自动接收最新稳定更新，避免直接使用`:latest`标签导致兼容性问题。
- **依赖环境**：自托管部署需确保外部依赖（如数据库）正常运行，且网络可访问。
- **安全配置**：生产环境中需妥善保管敏感环境变量（如密钥、数据库凭证），避免明文暴露。
- **系统资源**：根据LLM应用规模调整容器资源（CPU、内存），确保平台稳定运行。


**官方资源**  
- 自托管文档：[https://langfuse.com/docs/deployment/self-host](https://langfuse.com/docs/deployment/self-host)  
- GitHub仓库：[https://github.com/langfuse/langfuse/](https://github.com/langfuse/langfuse/)  
- 演示环境：[https://langfuse.com/demo](https://langfuse.com/demo)
