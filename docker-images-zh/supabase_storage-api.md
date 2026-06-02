---
image: supabase/storage-api
description: "Supabase的存储后端API服务，提供文件存储、检索和管理功能，支持与Supabase生态系统集成的对象存储解决方案，处理文件上传、下载及访问控制等操作。"
source: https://xuanyuan.cloud/zh/r/supabase/storage-api
canonical: https://xuanyuan.cloud/zh/r/supabase/storage-api
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/supabase/storage-api" title="supabase/storage-api Docker 镜像中文简介、标签列表与拉取命令">supabase/storage-api — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/supabase/storage-api" title="supabase/storage-api Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/supabase/storage-api</a>

# Supabase Storage Backend API 镜像文档

## 镜像概述
Supabase Storage Backend API镜像是Supabase生态系统的核心组件之一，作为存储服务的后端API，负责处理文件的存储、检索、更新和删除等操作。该镜像提供与Supabase认证系统、PostgreSQL数据库深度集成的对象存储能力，为基于Supabase构建的应用提供可靠的文件管理基础设施。

## 核心功能与特性
- **对象存储管理**：支持文件上传、下载、删除及批量操作，兼容标准对象存储接口
- **访问控制集成**：与Supabase Auth联动，实现基于JWT的身份验证和基于角色的权限控制
- **元数据管理**：自动记录文件元数据（大小、MIME类型、上传时间等）并存储于PostgreSQL
- **多存储后端支持**：可配置本地文件系统、S3兼容存储（如AWS S3、MinIO）等存储介质
- **生态系统兼容性**：无缝对接Supabase Realtime、PostgREST等服务，支持事件触发与数据联动

## 使用场景
- 基于Supabase构建的Web应用的文件存储后端（如用户头像、文档附件）
- 移动应用的媒体文件管理系统（如图片、视频存储与分发）
- 需要访问控制的私有文件存储服务（如企业内部文档库）
- 与PostgreSQL数据关联的文件管理场景（如电商平台的商品图片存储）

## 使用方法与配置说明

### 基本部署（Docker Run）
```bash
docker run -d \
  --name supabase-storage \
  -p 5000:5000 \
  -e DATABASE_URL="postgresql://<user>:<password>@<postgres-host>:5432/<db-name>" \
  -e STORAGE_BACKEND="local" \
  -e STORAGE_PATH="/data/storage" \
  -e PORT=5000 \
  -v /host/path/to/storage:/data/storage \
  supabase/storage-api:latest
```

### Docker Compose 配置示例
```yaml
version: '3.8'
services:
  storage:
    image: supabase/storage-api:latest
    container_name: supabase-storage
    ports:
      - "5000:5000"
    environment:
      # 数据库配置（必填）
      - DATABASE_URL=postgresql://postgres:postgres@postgres:5432/supabase
      # 存储后端配置
      - STORAGE_BACKEND=local  # 可选：local/s3
      - STORAGE_PATH=/data/storage  # 本地存储路径（local模式必填）
      # S3配置（S3模式时必填）
      # - S3_ENDPOINT=https://s3.<region>.amazonaws.com
      # - S3_ACCESS_KEY=<access-key>
      # - S3_SECRET_KEY=<secret-key>
      # - S3_BUCKET=<bucket-name>
      # 服务配置
      - PORT=5000
      - LOG_LEVEL=info
    volumes:
      - storage_data:/data/storage  # 本地存储卷（local模式）
    depends_on:
      - postgres
    restart: unless-stopped

  postgres:
    image: supabase/postgres:14.1.0.11
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=supabase
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  storage_data:
  postgres_data:
```

### 核心环境变量配置
| 环境变量名          | 描述                          | 默认值          | 是否必填 |
|---------------------|-------------------------------|-----------------|----------|
| DATABASE_URL        | PostgreSQL数据库连接URL       | -               | 是       |
| STORAGE_BACKEND     | 存储后端类型（local/s3）      | local           | 否       |
| STORAGE_PATH        | 本地存储根目录（local模式）   | /data/storage   | 否       |
| PORT                | API服务监听端口               | 5000            | 否       |
| S3_ENDPOINT         | S3兼容存储服务端点（S3模式）  | -               | S3模式必填 |
| S3_ACCESS_KEY       | S3访问密钥（S3模式）          | -               | S3模式必填 |
| S3_SECRET_KEY       | S3密钥（S3模式）              | -               | S3模式必填 |
| S3_BUCKET           | S3存储桶名称（S3模式）        | -               | S3模式必填 |
| LOG_LEVEL           | 日志级别（debug/info/warn/error） | info         | 否       |

### 注意事项
1. **数据库依赖**：需先初始化Supabase数据库schema（可通过supabase/migrations镜像执行）
2. **存储后端选择**：生产环境推荐使用S3兼容存储以提高可靠性和可扩展性
3. **数据持久化**：本地存储模式需挂载宿主机卷以防止容器重启后数据丢失
4. **性能调优**：高并发场景下建议调整容器CPU/内存限制，并配置适当的缓存策略
