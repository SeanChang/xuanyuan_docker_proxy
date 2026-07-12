---
image: riskledger/pgvector
description: "集成pgvector扩展的PostgreSQL数据库镜像，支持向量数据存储与相似性搜索，适用于AI/机器学习场景中向量嵌入的高效管理与查询。"
source: https://xuanyuan.cloud/zh/r/riskledger/pgvector
canonical: https://xuanyuan.cloud/zh/r/riskledger/pgvector
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/riskledger/pgvector" title="riskledger/pgvector Docker 镜像中文简介、标签列表与拉取命令">riskledger/pgvector 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# pgvector/pgvector 镜像文档


## 概述  
pgvector/pgvector 是一个预集成 PostgreSQL 数据库与 pgvector 扩展的 Docker 镜像。该镜像基于官方 PostgreSQL 构建，默认预装并启用 pgvector 扩展，提供向量数据类型支持及高效相似性搜索能力，简化需要向量操作的应用部署流程。


## 核心功能与特性  
### PostgreSQL 基础能力  
- 完整支持 PostgreSQL 核心功能：ACID 事务、标准 SQL 语法、JSON 支持、复杂查询优化等。  
- 兼容 PostgreSQL 生态工具（如 pg_dump、pg_restore、psql 客户端）。  

### pgvector 扩展能力  
- **向量数据类型**：提供 `vector` 类型，支持存储高维向量（默认最大维度为 16384）。  
- **相似性搜索**：内置多种距离计算运算符，支持欧氏距离（`<->`）、内积（`<#>`）、余弦相似度（`<=>`）等。  
- **索引优化**：支持为向量列创建 IVFFlat、HNSW 等索引，加速相似性查询（适用于大规模数据场景）。  
- **低侵入性**：作为 PostgreSQL 扩展，可与现有 SQL 功能无缝结合（如事务、JOIN、聚合函数）。  

### 部署便利性  
- 预配置 pgvector 扩展，无需手动编译安装。  
- 基于官方 PostgreSQL 镜像，版本透明（如 `16-alpine` 标签对应 PostgreSQL 16 + pgvector 最新版）。  


## 使用场景  
适用于需要向量存储与相似性计算的场景，包括但不限于：  
- **AI 应用**：存储语言模型（如 GPT、BERT）生成的文本嵌入向量，支持语义搜索、上下文关联。  
- **推荐系统**：基于用户/物品特征向量，计算相似度并生成推荐结果。  
- **多媒体检索**：图像、音频的特征向量存储，实现“以图搜图”“以声搜声”。  
- **数据挖掘**：聚类分析、异常检测中的高维向量运算。  


## 使用方法  

### 基础部署（docker run）  
通过以下命令快速启动容器：  
```bash
docker run -d \
  --name pgvector-db \
  -p 5432:5432 \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_PASSWORD=mypassword \
  -e POSTGRES_DB=mydb \
  -v pgdata:/var/lib/postgresql/data \
  docker.xuanyuan.run/pgvector/pgvector:16-alpine
```

### docker-compose 配置  
创建 `docker-compose.yml` 文件，定义服务与持久化存储：  
```yaml
version: '3.8'
services:
  pgvector:
    image: docker.xuanyuan.run/pgvector/pgvector:16-alpine
    container_name: pgvector-db
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: mydb
    volumes:
      - pgdata:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  pgvector-data:  # 持久化卷，避免数据丢失
```


## 配置参数  
通过环境变量自定义容器行为，支持 PostgreSQL 官方镜像的所有环境变量，核心参数如下：  

| 环境变量名          | 说明                                  | 默认值          |
|---------------------|---------------------------------------|-----------------|
| `POSTGRES_USER`     | 数据库超级用户账号                    | `postgres`      |
| `POSTGRES_PASSWORD` | 超级用户密码（必填，否则容器启动失败）| 无              |
| `POSTGRES_DB`       | 初始化数据库名称                      | 与 `POSTGRES_USER` 同名 |
| `PGDATA`            | PostgreSQL 数据存储路径              | `/var/lib/postgresql/data` |
| `POSTGRES_INITDB_ARGS` | 初始化数据库时的额外参数（如字符集）  | 无              |


## 操作示例  

### 1. 连接数据库  
使用 `psql` 客户端连接容器内数据库：  
```bash
docker exec -it pgvector-db psql -U myuser -d mydb
```

### 2. 向量表操作示例  
#### 创建向量表  
```sql
-- 创建含向量列的表（向量维度为 3）
CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  embedding vector(3)  -- vector(维度) 定义向量类型
);
```

#### 插入向量数据  
```sql
INSERT INTO items (embedding) VALUES 
  ('[1, 2, 3]'),
  ('[4, 5, 6]'),
  ('[7, 8, 9]');
```

#### 相似性查询  
```sql
-- 查询与目标向量 [3, 1, 2] 欧氏距离最近的 2 条记录
SELECT id, embedding, embedding <-> '[3, 1, 2]' AS distance 
FROM docker.xuanyuan.run/items 
ORDER BY distance 
LIMIT 2;

-- 结果示例：
-- id | embedding |     distance      
-- ----+-----------+-------------------
--  1 | [1,2,3]   | 2.449489742783178
--  2 | [4,5,6]   | 5.916079783099616
```

#### 创建向量索引（优化查询性能）  
```sql
-- 为 embedding 列创建 IVFFlat 索引（适用于中小规模数据）
CREATE INDEX items_embedding_idx ON items USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
```


## 持久化存储  
为避免容器重启导致数据丢失，需挂载 PostgreSQL 数据目录到 Docker 卷或宿主机路径：  
```bash
# 使用命名卷（推荐）
docker run -d \
  -v pgvector-data:/var/lib/postgresql/data \
  ...  # 其他参数

# 或挂载宿主机目录
docker run -d \
  -v /path/on/host:/var/lib/postgresql/data \
  ...  # 其他参数
```


## 注意事项  
1. **版本兼容性**：镜像标签格式为 `<postgresql-version>-<variant>`（如 `16-alpine`），需根据应用需求选择 PostgreSQL 版本（pgvector 要求 PostgreSQL ≥ 11）。  
2. **向量维度**：`vector` 类型默认最大维度为 16384，超出需通过 `max_vector_dimension` 参数调整（需修改 `postgresql.conf`）。  
3. **索引选择**：小规模数据可直接使用暴力搜索（无索引）；大规模数据推荐 HNSW 索引（比 IVFFlat 更优，但内存占用更高）。  
4. **性能调优**：向量操作为 CPU 密集型，建议为容器分配足够资源；大批量写入时可禁用索引，完成后重建。
