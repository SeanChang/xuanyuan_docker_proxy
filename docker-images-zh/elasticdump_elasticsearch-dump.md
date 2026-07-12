---
image: elasticdump/elasticsearch-dump
description: "Elasticdump是用于从Elasticsearch和OpenSearch移动及保存索引的工具。"
source: https://xuanyuan.cloud/zh/r/elasticdump/elasticsearch-dump
canonical: https://xuanyuan.cloud/zh/r/elasticdump/elasticsearch-dump
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/elasticdump/elasticsearch-dump" title="elasticdump/elasticsearch-dump Docker 镜像中文简介、标签列表与拉取命令">elasticdump/elasticsearch-dump 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Elasticdump Docker镜像文档


## 镜像概述和主要用途

Elasticdump 是一款用于迁移和保存 Elasticsearch 及 OpenSearch 索引的工具。它支持在不同 Elasticsearch/OpenSearch 实例之间传输数据，或备份索引至文件、对象存储（如 AWS S3、MinIO）等目标位置。该工具可灵活处理索引的映射（mapping）、分析器（analyzer）、数据（data）等多种类型，并提供数据过滤、分片、加密等高级功能，适用于数据备份、跨环境迁移、数据导出等场景。


## 核心功能和特性

- **多源输入输出**：支持 Elasticsearch/OpenSearch 实例、本地文件、AWS S3、MinIO、CSV 文件等作为输入/输出源。  
- **全面数据类型支持**：可迁移/备份索引的映射（mapping）、分析器（analyzer）、数据（data）、别名（alias）、模板（template）等元数据及内容。  
- **灵活数据过滤**：通过 `--searchBody` 指定查询条件，仅导出符合条件的数据；支持搜索模板（Search Template）。  
- **文件处理能力**：支持文件分割（按大小或行数）、GZIP 压缩/解压、CSV 导入（自定义分隔符、跳过行）。  
- **高性能与可靠性**：支持并发请求控制、滚动查询（scroll）、错误重试（自动重试网络错误）、断点续传（基于 scrollId）。  
- **云存储集成**：原生支持 AWS S3 及 S3 兼容存储（如 MinIO），支持服务端加密（SSE-KMS）、存储类别配置。  
- **OpenSearch 兼容**：从 6.76.0 版本开始支持 OpenSearch（基于 Elasticsearch 7.10.2 分支）。  
- **自定义扩展**：支持自定义数据转换（transform）、搜索体模板（searchBodyTemplate）、输入/输出传输插件。  


## 使用场景和适用范围

### 典型场景
- **索引备份与恢复**：将 Elasticsearch 索引备份至本地文件或 S3，需时恢复。  
- **跨环境迁移**：将生产环境索引迁移至测试/ staging 环境（如映射、数据全量迁移）。  
- **数据过滤导出**：通过查询条件导出部分数据（如特定用户、时间段的记录）。  
- **多索引批量处理**：配合 `multielasticdump` 工具批量迁移多个索引。  
- **对象存储集成**：将索引数据归档至 S3 或从 S3 导入数据至 Elasticsearch。  
- **CSV 数据导入**：将 CSV 文件（如日志、报表）导入 Elasticsearch 建立索引。  

### 适用范围
- Elasticsearch 版本：5.x 及以上（3.0.0+ 默认支持），低版本可能存在兼容性问题。  
- OpenSearch 版本：7.10.2 及以上（6.76.0+ 支持）。  
- 部署环境：支持 Linux/macOS/Windows，推荐通过 Docker 容器化部署以简化依赖管理。  


## 安装与部署

### 本地安装（非 Docker）
需先安装 Node.js（v10.0.0+），通过 npm 安装：
```bash
# 本地安装
npm install elasticdump
./bin/elasticdump

# 全局安装
npm install -g elasticdump
elasticdump
```

### Docker 安装
#### 拉取镜像
```bash
docker pull docker.xuanyuan.run/elasticdump/elasticsearch-dump
```

#### 基础使用格式
```bash
docker run --rm -ti docker.xuanyuan.run/elasticdump/elasticsearch-dump [OPTIONS]
```
- `--rm`：退出后删除容器。  
- `-ti`：交互式终端，便于查看日志。  
- 如需访问本地文件，需挂载宿主机目录（如 `-v /本地目录:/容器内目录`）。  


## 使用方法

### 1. 基本操作示例

#### 1.1 迁移索引（生产环境到 Staging）
迁移索引的映射、分析器和数据：
```bash
# 迁移分析器
docker run --rm -ti docker.xuanyuan.run/elasticdump/elasticsearch-dump \
  --input=http://production.es:9200/my_index \
  --output=http://staging.es:9200/my_index \
  --type=analyzer

# 迁移映射
docker run --rm -ti docker.xuanyuan.run/elasticdump/elasticsearch-dump \
  --input=http://production.es:9200/my_index \
  --output=http://staging.es:9200/my_index \
  --type=mapping

# 迁移数据
docker run --rm -ti docker.xuanyuan.run/elasticdump/elasticsearch-dump \
  --input=http://production.es:9200/my_index \
  --output=http://staging.es:9200/my_index \
  --type=data
```

#### 1.2 备份索引到本地文件
将索引映射和数据备份至宿主机 `/data` 目录（需挂载卷）：
```bash
# 备份映射
docker run --rm -ti -v /data:/tmp docker.xuanyuan.run/elasticdump/elasticsearch-dump \
  --input=http://production.es:9200/my_index \
  --output=/tmp/my_index_mapping.json \
  --type=mapping

# 备份数据（启用 GZIP 压缩）
docker run --rm -ti -v /data:/tmp docker.xuanyuan.run/elasticdump/elasticsearch-dump \
  --input=http://production.es:9200/my_index \
  --output=/tmp/my_index_data.json.gz \
  --type=data \
  --fsCompress
```

#### 1.3 基于查询导出数据
导出 `username: admin` 的记录至文件：
```bash
docker run --rm -ti -v /data:/tmp docker.xuanyuan.run/elasticdump/elasticsearch-dump \
  --input=http://production.es:9200/my_index \
  --output=/tmp/admin_data.json \
  --type=data \
  --searchBody='{"query":{"term":{"username":"admin"}}}'
```
> 若查询条件复杂，可将 JSON 保存至文件（如 `/data/search.json`），通过 `--searchBody=@/tmp/search.json` 引用。

#### 1.4 从 S3 导入数据至 Elasticsearch
```bash
docker run --rm -ti docker.xuanyuan.run/elasticdump/elasticsearch-dump \
  --s3AccessKeyId "AKIAXXX" \
  --s3SecretAccessKey "secret" \
  --input "s3://my-bucket/backup/my_index_data.json" \
  --output=http://production.es:9200/my_index \
  --type=data
```

#### 1.5 CSV 文件导入 Elasticsearch
导入 CSV 文件（跳过首行标题，使用分号分隔）：
```bash
docker run --rm -ti -v /data:/tmp docker.xuanyuan.run/elasticdump/elasticsearch-dump \
  --input "csv:///tmp/data.csv" \
  --output=http://production.es:9200/my_index \
  --csvSkipRows 1 \
  --csvDelimiter ";"
```


### 2. 非标准 Elasticsearch 部署场景
若 Elasticsearch 未部署在根路径（如 `http://es:9200/api/search`），需显式指定索引名：
```bash
docker run --rm -ti docker.xuanyuan.run/elasticdump/elasticsearch-dump \
  --input=http://es:9200/api/search \
  --input-index=my_index \
  --output=http://es:9200/api/search \
  --output-index=my_index_backup \
  --type=data
```


### 3. Docker 网络配置
若需访问宿主机上的 Elasticsearch（`localhost:9200`），需使用主机网络：
```bash
docker run --rm -ti --net=host docker.xuanyuan.run/elasticdump/elasticsearch-dump \
  --input=http://staging.es:9200/my_index \
  --output=http://localhost:9200/my_index \
  --type=data
```


## 转储文件格式
Elasticdump 生成的文件为**行分隔 JSON（Line-Delimited JSON）**，即每行是一个独立的 JSON 对象，而非整体 JSON 数组。此格式支持流式处理，避免内存溢出。示例：
```json
{"_index":"my_index","_type":"_doc","_id":"1","_source":{"name":"test1"}}
{"_index":"my_index","_type":"_doc","_id":"2","_source":{"name":"test2"}}
```
可通过以下命令解析：
```bash
while read LINE; do jq . <<< "${LINE}"; done < dump.json
```


## 配置参数详解

### 输入输出参数
| 参数                | 默认值          | 描述                                                                 |
|---------------------|-----------------|----------------------------------------------------------------------|
| `--input`           | 无（必填）      | 输入源（ES 地址、文件路径、S3 URL 等，如 `http://es:9200/index`）。  |
| `--output`          | 无（必填）      | 输出目标（格式同 `--input`）。                                       |
| `--input-index`     | `all`           | 输入索引名（含类型，如 `my_index/_doc`）。                            |
| `--output-index`    | `all`           | 输出索引名。                                                         |
| `--type`            | `data`          | 迁移数据类型：`settings`/`analyzer`/`mapping`/`data`/`alias`/`template` 等。 |


### 数据控制参数
| 参数                | 默认值          | 描述                                                                 |
|---------------------|-----------------|----------------------------------------------------------------------|
| `--limit`           | 100             | 批量操作的对象数量（近似值）。                                       |
| `--size`            | -1              | 最大迁移对象数（-1 表示无限制）。                                    |
| `--searchBody`      | 匹配所有文档    | 过滤查询 JSON（如 `{"query":{"match_all":{}}}`），支持 `@file` 引用文件。 |
| `--searchWithTemplate` | false        | 启用搜索模板（需 `--searchBody` 包含 `id` 和 `params`）。             |
| `--sourceOnly`      | false           | 仅输出 `_source` 字段内容（默认包含 `_index`/`_id` 等元数据）。       |
| `--delete`          | false           | 迁移后删除输入源文档（不删除索引）。                                 |


### 性能与网络参数
| 参数                | 默认值          | 描述                                                                 |
|---------------------|-----------------|----------------------------------------------------------------------|
| `--concurrency`     | 1               | 并发请求数上限。                                                     |
| `--scrollTime`      | `10m`           | 滚动查询（scroll）结果在节点保留时间（如 `5m`、`1h`）。               |
| `--timeout`         | 无              | 请求超时时间（毫秒）。                                               |
| `--retryAttempts`   | 0               | 网络错误重试次数（支持 `ECONNRESET`/`ETIMEDOUT` 等错误）。           |
| `--retryDelay`      | 5000            | 重试间隔（毫秒）。                                                   |


### 文件处理参数
| 参数                | 默认值          | 描述                                                                 |
|---------------------|-----------------|----------------------------------------------------------------------|
| `--fileSize`        | 无              | 文件分割大小（如 `10mb`、`1gb`）。                                   |
| `--maxRows`         | 无              | 文件分割行数。                                                       |
| `--fsCompress`      | false           | 启用文件 GZIP 压缩/解压。                                           |
| `--csvDelimiter`    | `,`             | CSV 文件分隔符（如 `;`、`\t`）。                                    |
| `--csvSkipRows`     | 0               | CSV 跳过行数（不含标题行）。                                         |


### AWS/S3 参数
| 参数                | 默认值          | 描述                                                                 |
|---------------------|-----------------|----------------------------------------------------------------------|
| `--s3AccessKeyId`   | 无              | AWS/S3 访问密钥 ID。                                                 |
| `--s3SecretAccessKey` | 无           | AWS/S3 密钥。                                                        |
| `--s3Region`        | 自动推断        | S3 区域（如 `us-east-1`）。                                          |
| `--s3Endpoint`      | 无              | S3 兼容服务端点（如 MinIO：`https://minio.example.com`）。           |
| `--s3ForcePathStyle` | false        | 强制使用路径风格 URL（如 `s3.amazonaws.com/bucket/key`）。           |
| `--s3ServerSideEncryption` | false | 启用 S3 服务端加密。                                                 |


### 安全参数
| 参数                | 默认值          | 描述                                                                 |
|---------------------|-----------------|----------------------------------------------------------------------|
| `--tlsAuth`         | false           | 启用 TLS 客户端认证。                                                 |
| `--cert`            | 无              | TLS 客户端证书文件路径。                                             |
| `--key`             | 无              | TLS 客户端密钥文件路径。                                             |
| `--headers`         | `{"User-Agent": "elasticdump"}` | 自定义 HTTP 头（如代理认证）。                        |


## 版本兼容性注意事项

- **1.0.0+**：转储文件格式变更，0.x.x 版本生成的文件不兼容，可能导致“内存不足”错误。  
- **2.0.0+**：移除 `bulk` 选项，多索引迁移需使用 `multielasticdump`。  
- **3.0.0+**：默认查询仅支持 Elasticsearch 5+，低版本兼容性下降。  
- **5.0.0+**：S3 传输移除 `s3Bucket`/`s3RecordKey`，需使用 S3 URL（如 `s3://bucket/key`）。  
- **6.1.0+**：并行处理提升性能，但数据顺序不保证。  
- **6.67.0+**：要求 Node.js 版本 ≥10.0.0，否则退出。  
- **6.76.0+**：支持 OpenSearch（基于 Elasticsearch 7.10.2）。  

> 升级版本前建议参考 [官方 release 说明](https://github.com/elasticsearch-dump/elasticsearch-dump/releases)，避免数据格式或功能兼容性问题。
