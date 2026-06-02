---
image: qdrant/qdrant
description: "Qdrant是一个向量相似性搜索引擎和向量数据库，提供生产级服务，支持存储、搜索和管理带有附加负载的向量点，具备强大的扩展过滤能力，适用于神经网络或语义匹配、分面搜索等AI应用，使用Rust编写，确保高性能和可靠性。"
source: https://xuanyuan.cloud/zh/r/qdrant/qdrant
canonical: https://xuanyuan.cloud/zh/r/qdrant/qdrant
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/qdrant/qdrant" title="qdrant/qdrant Docker 镜像中文简介、标签列表与拉取命令">qdrant/qdrant — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/qdrant/qdrant" title="qdrant/qdrant Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/qdrant/qdrant</a>

# Qdrant 向量搜索引擎 Docker 镜像文档

## 镜像概述和主要用途

Qdrant（读作"quadrant"）是一个向量相似性搜索引擎和向量数据库，提供生产级服务，通过便捷的API存储、搜索和管理向量点（即带有附加负载的向量）。其专为扩展过滤支持设计，适用于各类神经网络或语义匹配、分面搜索及其他AI应用场景。

Qdrant采用Rust语言开发，确保在高负载下仍保持快速和可靠的性能。同时提供完全托管的[Qdrant Cloud](https://cloud.qdrant.io/)服务，包括免费层级。

## 核心功能和特性

### 扩展过滤支持
- 支持为向量附加任意JSON负载，可基于负载值进行数据存储和过滤
- 负载支持多种数据类型和查询条件：关键字匹配、全文过滤、数值范围、地理位置等
- 过滤条件可通过`should`、`must`和`must_not`子句组合，实现复杂业务逻辑

### 混合搜索与稀疏向量
- 支持稀疏向量与常规稠密向量结合，解决向量嵌入在特定关键词搜索中的局限性
- 稀疏向量可视为BM25或TF-IDF排序的泛化，利用基于Transformer的神经网络有效权衡单个令牌权重

### 向量量化与磁盘存储
- 内置向量量化技术，减少RAM使用量高达97%
- 动态管理搜索速度与精度之间的权衡，提高资源效率

### 分布式部署
- 支持水平扩展：通过分片实现容量扩展，通过复制提升吞吐量
- 零停机滚动更新和无缝动态扩展集合

### 突出特性
- **查询规划与负载索引**：利用存储的负载信息优化查询执行策略
- **SIMD硬件加速**：利用现代CPU x86-x64和Neon架构提升性能
- **异步I/O**：使用`io_uring`最大化磁盘吞吐量，即使在网络附加存储上
- **预写日志（Write-Ahead Logging）**：确保数据持久性，即使在断电情况下也能确认更新

## 使用场景和适用范围

### 语义文本搜索
突破基于关键词的搜索限制，利用语义嵌入在短文本中找到有意义的关联，几分钟内即可部署神经搜索。

### 相似图像搜索
适用于视觉搜索场景（如食品发现），帮助用户基于外观找到所需物品，即使不知道具体名称。

### 极端分类
解决具有数百万标签的多类和多标签问题，适用于电商产品分类等场景，结合预训练Transformer模型实现高效分类。

### 其他应用场景
- 推荐系统
- 聊天机器人
- 异常检测
- 地理空间搜索
- 多模态数据检索

## 使用方法和配置说明

### Docker 快速部署

#### 基础运行命令
```bash
docker run -p 6333:6333 qdrant/qdrant
```
此命令启动Qdrant服务，映射容器6333端口到主机，默认配置下可通过`http://localhost:6333`访问。

#### 持久化存储配置
为确保数据持久化，可挂载本地目录到容器内的数据存储路径：
```bash
docker run -p 6333:6333 -v $(pwd)/qdrant_data:/qdrant/storage qdrant/qdrant
```
其中`$(pwd)/qdrant_data`为本地目录，用于存储Qdrant数据。

#### Docker Compose 配置示例
创建`docker-compose.yml`文件：
```yaml
version: '3.8'
services:
  qdrant:
    image: qdrant/qdrant
    ports:
      - "6333:6333"
      - "6334:6334"  # gRPC端口
    volumes:
      - ./qdrant_data:/qdrant/storage
    restart: unless-stopped
    environment:
      - QDRANT__SERVICE__HTTP_PORT=6333
      - QDRANT__SERVICE__GRPC_PORT=6334
```
通过`docker-compose up -d`启动服务。

### 客户端连接

#### Python 客户端
1. 安装客户端：
```bash
pip install qdrant-client
```

2. 连接到Docker中运行的Qdrant服务：
```python
from qdrant_client import QdrantClient

client = QdrantClient("http://localhost:6333")

# 创建集合示例
client.create_collection(
    collection_name="my_collection",
    vectors_config={"size": 300, "distance": "Cosine"}
)
```

#### 其他客户端库
Qdrant提供多种官方客户端库：
- Go: [qdrant/go-client](https://github.com/qdrant/go-client)
- Rust: [qdrant/rust-client](https://github.com/qdrant/rust-client)
- JavaScript/TypeScript: [qdrant/qdrant-js](https://github.com/qdrant/qdrant-js)
- .NET/C#: [qdrant/qdrant-dotnet](https://github.com/qdrant/qdrant-dotnet)
- Java: [qdrant/java-client](https://github.com/qdrant/java-client)

社区贡献客户端：Elixir、PHP、Ruby等。

### 生产环境注意事项
- 部署前请阅读[安装指南](https://qdrant.tech/documentation/guides/installation/)和[安全指南](https://qdrant.tech/documentation/guides/security/)
- 配置适当的资源限制（CPU、内存），根据数据量和查询负载调整
- 启用身份验证和TLS加密，保护API访问安全
- 考虑使用分布式部署方案，实现高可用和水平扩展

## 集成支持

Qdrant可与多种AI/ML工具和框架集成，包括：
- **Cohere**：结合Cohere嵌入模型构建QA应用
- **LangChain**：作为LangChain的内存后端
- **LlamaIndex**：作为向量存储使用
- **Haystack**：作为文档存储
- **OpenAI ChatGPT检索插件**：作为ChatGPT的内存后端
- **Microsoft Semantic Kernel**：作为持久化内存

## 许可证信息

Qdrant基于Apache License 2.0许可协议开源，详情参见[许可证文件](https://github.com/qdrant/qdrant/blob/master/LICENSE)。

## 相关资源
- [官方文档](https://qdrant.tech/documentation/)
- [快速入门指南](https://github.com/qdrant/qdrant/blob/master/docs/QUICK_START.md)
- [Discord社区](https://qdrant.to/discord)
- [Qdrant Cloud](https://cloud.qdrant.io/)
