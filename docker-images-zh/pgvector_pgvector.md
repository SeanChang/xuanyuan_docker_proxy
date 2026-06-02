---
image: pgvector/pgvector
description: "这是一款适用于PostgreSQL的开源向量相似性搜索工具，可无缝集成至PostgreSQL数据库，支持对文本嵌入、图像特征、音频向量等各类向量数据进行高效相似性查询。它借助优化的索引结构与搜索算法实现快速检索相似向量结果，助力用户在人工智能、机器学习、推荐系统等场景下，利用PostgreSQL便捷处理向量数据，提升查询效率与开发灵活性，且作为开源项目具备代码透明、社区支持完善、易于扩展等优势。"
source: https://xuanyuan.cloud/zh/r/pgvector/pgvector
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[pgvector/pgvector](https://xuanyuan.cloud/zh/r/pgvector/pgvector)
> 含镜像标签、拉取命令、部署文档与相关推荐。

## pgvector 简介  

pgvector 是 PostgreSQL 的扩展，专门用于向量数据的存储、索引和相似性查询。它能让 PostgreSQL 直接处理向量类型数据（如机器学习模型输出的嵌入向量），支持高效的相似性检索，适合需要在数据库内完成向量计算的场景。


### 核心功能  

- **向量数据类型**：提供 `vector` 类型，可存储固定维度的浮点数组（默认最大 16000 维，支持调整）。  
- **多距离计算**：支持欧氏距离（`<->`）、余弦相似度（`<=>`）、曼哈顿距离（`<#>`），直接通过 SQL 函数调用。  
- **高性能索引**：内置 IVFFlat、HNSW 等索引类型，加速百万级/亿级向量的相似性查询（比全表扫描快 10-100 倍）。  
- **PostgreSQL 原生集成**：兼容 PostgreSQL 11 及以上版本，可与现有 SQL 功能（如事务、触发器、权限控制）结合使用。  


### 安装步骤  

#### 1. 系统依赖安装  
根据操作系统选择对应方式：  

- **Ubuntu/Debian**：  
  ```bash
  # 安装 PostgreSQL 开发包（版本需与当前 PostgreSQL 一致，如 14）
  sudo apt-get install postgresql-server-dev-14  
  # 从源码编译安装 pgvector（或用 pip install pgvector）
  git clone [] && cd pgvector && make && sudo make install
  ```  

- **macOS**：  
  ```bash
  brew install pgvector
  ```  

- **Windows**：  
  推荐用 Docker 镜像（`pgvector/pgvector:14`），或手动编译（需先安装 PostgreSQL 开发环境）。  


#### 2. 启用扩展  
在目标数据库中执行 SQL：  
```sql
CREATE EXTENSION vector;  -- 安装完成后，即可使用 vector 类型
```  


### 基本使用  

#### 1. 创建含向量列的表  
先定义向量列，需指定维度（如 3 维、768 维，与模型输出的嵌入维度一致）：  
```sql
-- 示例：存储文本嵌入向量（假设用 BERT 生成的 768 维向量）
CREATE TABLE documents (
  id SERIAL PRIMARY KEY,
  content TEXT,
  embedding vector(768)  -- 向量列，指定 768 维
);
```  


#### 2. 插入向量数据  
直接插入向量值（格式为 `[x1, x2, ..., xn]`）：  
```sql
-- 插入文本嵌入向量（实际场景中通常通过应用程序生成，如 Python 的 psycopg2 插入）
INSERT INTO documents (content, embedding) VALUES 
  (' PostgreSQL 教程', '[0.12, 0.34, ..., 0.89]'),  -- 省略中间维度值
  ('向量数据库对比', '[0.23, 0.45, ..., 0.78]');
```  


#### 3. 相似性查询  
通过距离函数筛选相似向量，结果按距离排序（值越小越相似）：  
```sql
-- 例：查找与目标向量最相似的 Top 10 文档（余弦相似度 <=>）
SELECT id, content, embedding <=> '[0.18, 0.31, ..., 0.92]' AS similarity 
FROM documents 
ORDER BY similarity  -- 按相似度升序（值越小越相似）
LIMIT 10;

-- 欧氏距离查询（适用于高维稀疏向量）
SELECT id, embedding <-> '[0.18, 0.31, ..., 0.92]' AS distance 
FROM documents 
ORDER BY distance 
LIMIT 10;
```  


#### 4. 索引优化（大规模数据）  
当向量数据量超过 10 万级时，建议创建索引加速查询。pgvector 支持多种索引类型，根据数据规模选择：  

- **IVFFlat 索引**（中等规模，百万级数据）：  
  ```sql
  -- 创建余弦相似度索引（指定算子 vector_cosine_ops）
  CREATE INDEX ON documents USING ivfflat (embedding vector_cosine_ops) 
  WITH (lists = 100);  -- lists 数量建议设为数据量平方根（如 100 万数据设 1000）
  ```  

- **HNSW 索引**（大规模，亿级数据，查询更快但内存占用高）：  
  ```sql
  -- 创建欧氏距离索引（算子 vector_l2_ops）
  CREATE INDEX ON documents USING hnsw (embedding vector_l2_ops)
  WITH (m = 16, ef_construction = 64);  -- m=16（邻居数）、ef_construction=64（构建时候选集）
  ```  


### 适用场景  

- **推荐系统**：存储用户/物品嵌入向量，快速匹配相似用户或物品（如“猜你喜欢”）。  
- **语义检索**：文本通过 BERT、Sentence-BERT 转为向量后，实现“语义相似”而非关键词匹配的搜索（如论文、文档检索）。  
- **图像/音频检索**：存储图像特征向量（如 ResNet 输出）、音频嵌入，检索相似图像或音频片段。  
- **在线机器学习**：模型嵌入向量直接存数据库，实时用于推理（如实时风控、个性化推荐）。  


### 注意事项  

- **向量维度**：默认最大 16000 维，如需更高维度，编译时修改 `VECTOR_MAX_DIM` 宏。  
- **PostgreSQL 版本**：需 PostgreSQL 11 及以上，推荐 14+ 以支持 HNSW 索引和更好的性能。  
- **索引维护**：IVFFlat 索引在数据频繁更新时可能性能下降，建议定期重建；HNSW 索引更新成本较高，适合静态或增量更新数据。  
- **兼容性**：可与 Python 的 psycopg2、SQLAlchemy，Java 的 JDBC 等工具链配合，直接在应用中调用向量操作。
