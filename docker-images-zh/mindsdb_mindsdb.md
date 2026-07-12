---
image: mindsdb/mindsdb
description: "用于构建可在大规模联邦数据上回答问题的AI平台。"
source: https://xuanyuan.cloud/zh/r/mindsdb/mindsdb
canonical: https://xuanyuan.cloud/zh/r/mindsdb/mindsdb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mindsdb/mindsdb" title="mindsdb/mindsdb Docker 镜像中文简介、标签列表与拉取命令">mindsdb/mindsdb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MindsDB Docker镜像技术文档


## 镜像概述和主要用途

MindsDB是一个用于构建AI的平台，旨在让人类、AI、代理和应用程序能够跨分散且大规模的数据源获取高精度答案。该平台内置MCP（MindsDB Control Plane）服务器，支持MCP应用程序连接、统一并响应跨数据库、数据仓库及SaaS应用的大规模联邦数据查询，实现多源数据的整合与智能分析。


## 核心功能和特性

### 内置MCP服务器
提供MCP服务器功能，支持跨数据库、数据仓库和SaaS应用的大规模联邦数据连接、统一与查询响应，简化多源数据整合流程。

### 多数据源集成
支持与各类数据源（如数据库、数据仓库、SaaS应用）集成，具体集成列表可参考[默认集成清单](https://github.com/mindsdb/mindsdb/blob/staging/default_handlers.txt)。

### 预加载AI框架集成
提供包含特定AI框架依赖的镜像版本，如Lightwood（MindsDB原生机器学习框架）和Hugging Face（开源AI模型库），简化AI模型集成流程。

### 轻量级与定制化镜像
提供轻量级基础镜像及多种定制化镜像标签，可根据实际需求选择包含不同依赖的版本，平衡功能与资源占用。


## 使用场景和适用范围

### 跨数据源AI问答
适用于需要从多个分散数据源（如MySQL、PostgreSQL、Snowflake、Salesforce等）中获取整合答案的场景，支持自然语言或结构化查询。

### 数据整合与分析
用于企业级数据整合分析，通过MCP服务器统一管理多源数据，实现跨平台数据关联查询与智能分析。

### AI模型集成开发
支持基于Lightwood或Hugging Face模型开发AI应用，适用于需要快速部署机器学习模型并对接多数据源的开发场景。


## 使用方法和配置说明

### 镜像标签说明

MindsDB Docker镜像标签遵循以下格式：  
`mindsdb:<version>-<handlers>`  

- `<version>`：指定MindsDB版本，若不指定则默认为最新版本。  
- `<handlers>`：指定预加载的集成依赖，若不指定则为轻量级镜像（包含[默认集成](https://github.com/mindsdb/mindsdb/blob/staging/default_handlers.txt)）。  

#### `<handlers>`取值说明
- `lightwood`：包含Lightwood集成所需的全部依赖。  
- `huggingface`：包含Hugging Face集成所需的全部依赖。  
- `cloud`：包含[额外集成依赖](https://github.com/mindsdb/mindsdb/blob/b9787ce237ccb6eb31493afdf763c419c0df5d51/docker/docker-bake.hcl#L90)。  
- `dev`：包含开发所需的额外Python包。  


### 镜像选择指南

| 镜像标签                | 适用场景                                  | 核心集成内容                          |
|-------------------------|-------------------------------------------|---------------------------------------|
| `mindsdb/mindsdb:latest` | 基础场景，仅需默认数据源集成              | [默认集成](https://github.com/mindsdb/mindsdb/blob/staging/default_handlers.txt) |
| `mindsdb/mindsdb:lightwood` | 需要使用Lightwood机器学习框架的场景      | 默认集成 + Lightwood依赖              |
| `mindsdb/mindsdb:huggingface` | 需要对接Hugging Face模型的场景          | 默认集成 + Hugging Face依赖           |
| `mindsdb/mindsdb:cloud`  | 企业级云环境，需额外数据源集成            | 默认集成 + 云环境额外依赖             |
| `mindsdb/mindsdb:dev`    | MindsDB开发或二次开发场景                | 默认集成 + 开发工具依赖               |


### Docker部署示例

#### 1. 使用轻量级镜像（默认集成）
```bash
docker run -d -p 47334:47334 --name mindsdb docker.xuanyuan.run/mindsdb/mindsdb:latest
```
- `-p 47334:47334`：映射MindsDB默认端口（47334）到主机。  
- `--name mindsdb`：指定容器名称为mindsdb。


#### 2. 使用Lightwood集成镜像
```bash
docker run -d -p 47334:47334 --name mindsdb-lightwood docker.xuanyuan.run/mindsdb/mindsdb:lightwood
```


#### 3. 使用Hugging Face集成镜像
```bash
docker run -d -p 47334:47334 --name mindsdb-huggingface docker.xuanyuan.run/mindsdb/mindsdb:huggingface
```


#### 4. Docker Compose配置示例
创建`docker-compose.yml`文件：
```yaml
version: '3.8'
services:
  mindsdb:
    image: docker.xuanyuan.run/mindsdb/mindsdb:latest  # 可替换为lightwood/huggingface等标签
    container_name: mindsdb
    ports:
      - "47334:47334"  # MindsDB API端口
      - "47335:47335"  # MindsDB Web UI端口（若启用）
    volumes:
      - ./mindsdb_data:/root/mindsdb/data  # 持久化数据目录
      - ./mindsdb_config:/root/mindsdb/config  # 挂载自定义配置（可选）
    restart: unless-stopped
```
启动服务：
```bash
docker-compose up -d
```


### 配置与持久化

#### 数据持久化
MindsDB的数据（如模型、配置、日志等）默认存储在容器内`/root/mindsdb/data`目录，通过挂载主机目录实现持久化：
```bash
docker run -d -p 47334:47334 -v /host/path/to/data:/root/mindsdb/data --name mindsdb docker.xuanyuan.run/mindsdb/mindsdb:latest
```

#### 自定义配置
可通过挂载配置文件目录自定义MindsDB配置（如`config.json`）：
```bash
docker run -d -p 47334:47334 -v /host/path/to/config:/root/mindsdb/config --name mindsdb docker.xuanyuan.run/mindsdb/mindsdb:latest
```


## 参考链接
- [MindsDB官方文档](https://docs.mindsdb.com/)  
- [MCP服务器概述](https://docs.mindsdb.com/mcp/overview)  
- [数据源集成清单](https://docs.mindsdb.com/integrations/data-overview)  
- [AI框架集成清单](https://docs.mindsdb.com/integrations/ai-overview)  
- [MindsDB GitHub仓库](https://github.com/mindsdb/mindsdb)
