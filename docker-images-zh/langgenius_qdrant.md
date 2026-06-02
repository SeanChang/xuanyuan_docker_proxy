<!-- xuanyuan-docker-images-zh
image: langgenius/qdrant
source: https://xuanyuan.cloud/zh/r/langgenius/qdrant
canonical: https://xuanyuan.cloud/zh/r/langgenius/qdrant
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/langgenius/qdrant" title="langgenius/qdrant Docker 镜像中文简介、标签列表与拉取命令">langgenius/qdrant — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/langgenius/qdrant" title="langgenius/qdrant Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/langgenius/qdrant</a></p>

## 镜像概述

本镜像基于qdrant:v1.6.1版本构建，核心增强功能为添加了对中文、日文和韩文（CJK）的分词器支持。qdrant是一款高性能向量数据库，主要用于向量相似度搜索和存储，本镜像通过集成CJK分词器，优化了对东亚语言文本的预处理能力，提升了相关场景下的向量检索准确性和效率。

## 核心功能与特性

### 基础功能（继承自qdrant:v1.6.1）
- 支持多种向量索引类型（如HNSW、FLAT等）
- 提供RESTful API和gRPC接口，便于集成
- 支持动态数据更新（添加/删除/修改向量）
- 内置过滤和聚合功能，支持复杂查询场景

### 新增功能
- **中文分词器**：支持中文文本的精确分词，适配常见中文语义场景
- **日文分词器**：支持日文文本的 morphological analysis（形态分析）
- **韩文分词器**：支持韩文文本的音节和词素级别分词

## 使用场景与适用范围

### 典型场景
- 中文/日文/韩文文本的语义搜索系统
- 东亚语言智能问答机器人（基于向量知识库）
- 多语言文档相似度匹配（含CJK语言）
- 东亚语言文本的聚类与分类任务

### 适用范围
- 需要处理中文、日文或韩文文本的向量检索应用
- 基于qdrant构建且对东亚语言支持有需求的系统
- 版本兼容性要求与qdrant:v1.6.1一致的环境

## 使用方法与配置说明

### 前提条件
- Docker引擎版本≥20.10.0
- 网络环境可访问Docker镜像仓库（如配置私有仓库需确保镜像可拉取）

### 镜像拉取
```bash
docker pull [镜像仓库地址]/qdrant-cjk:v1.6.1  # 替换为实际镜像仓库地址
```

### 基本运行命令
```bash
docker run -d \
  --name qdrant-cjk \
  -p 6333:6333 \
  -p 6334:6334 \
  -v $(pwd)/qdrant_data:/qdrant/storage \
  [镜像仓库地址]/qdrant-cjk:v1.6.1
```
- `-p 6333:6333`：映射REST API端口
- `-p 6334:6334`：映射gRPC端口
- `-v $(pwd)/qdrant_data:/qdrant/storage`：挂载数据卷，持久化存储向量数据

### 分词器验证
运行容器后，可通过以下步骤验证CJK分词器是否生效：
1. 向qdrant插入包含CJK文本的数据（如中文句子"我爱自然语言处理"）
2. 使用向量搜索接口检索相关文本，观察检索结果是否符合语义预期（相比未添加分词器的版本，应能更准确匹配同语言相关文本）

### 配置说明
本镜像继承qdrant:v1.6.1的所有配置参数，可通过环境变量或配置文件进行自定义。常用配置示例：
- 设置日志级别：`-e QDRANT_LOG_LEVEL=info`
- 自定义存储路径：`-e QDRANT_STORAGE_PATH=/custom/storage`（需配合数据卷挂载调整）

## docker-compose配置示例
```yaml
version: '3.8'
services:
  qdrant-cjk:
    image: [镜像仓库地址]/qdrant-cjk:v1.6.1
    container_name: qdrant-cjk
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - qdrant_data:/qdrant/storage
    environment:
      - QDRANT_LOG_LEVEL=info
    restart: unless-stopped

volumes:
  qdrant_data:
```

## 注意事项
- 本镜像与qdrant:v1.6.1的API和数据格式完全兼容，可直接替换使用
- 分词器默认对所有CJK语言文本自动生效，无需额外配置
- 如需进一步优化分词效果，可通过修改镜像内置的分词器配置文件（路径：`/qdrant/config/cjk_tokenizers.yaml`）实现自定义分词规则

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/langgenius/qdrant" title="langgenius/qdrant Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/langgenius/qdrant</a></p>
