---
image: apache/couchdb
description: "非官方的CouchDB便捷二进制文件，适用于RESTful文档型数据库。"
source: https://xuanyuan.cloud/zh/r/apache/couchdb
canonical: https://xuanyuan.cloud/zh/r/apache/couchdb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/couchdb" title="apache/couchdb Docker 镜像中文简介、标签列表与拉取命令">apache/couchdb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CouchDB 非官方便捷二进制镜像

## 镜像概述和主要用途  
本镜像提供 Apache CouchDB 的非官方便捷二进制分发，CouchDB 是一个基于 RESTful API 的文档导向型数据库，采用 JSON 格式存储数据，支持分布式架构和高可用性。该镜像旨在简化 CouchDB 的部署流程，适用于开发、测试及小型生产环境的快速搭建。


## 核心功能和特性  
- **文档导向存储**：以 JSON 格式存储文档，支持灵活的数据模型，无需预定义表结构。  
- **RESTful API**：通过 HTTP/HTTPS 接口实现数据的创建、读取、更新和删除（CRUD），兼容标准 HTTP 方法（GET、POST、PUT、DELETE 等）。  
- **分布式与复制**：支持多节点数据复制，实现数据冗余和高可用性，适合跨地域部署。  
- **ACID 兼容**：采用多版本并发控制（MVCC）确保事务一致性，支持原子性操作和数据完整性。  
- **内置 Web 管理界面**：集成 Fauxton 管理界面，提供可视化数据管理和集群配置功能。  
- **水平扩展**：支持通过添加节点实现集群扩展，适应数据量增长需求。


## 使用场景和适用范围  
- **内容管理系统**：存储非结构化/半结构化数据（如文章、评论、用户配置文件）。  
- **实时协作工具**：支持多用户并发编辑，通过复制功能实现离线数据同步（如协作文档编辑）。  
- **移动应用后端**：适配移动场景下的离线数据存储需求，支持客户端与服务端数据双向同步。  
- **日志与分析系统**：高效存储和查询 JSON 格式日志数据，结合 MapReduce 进行批量数据分析。  
- **原型开发与测试**：快速搭建数据库环境，降低开发阶段的部署复杂度。


## 详细的使用方法和配置说明  

### 前提条件  
- 已安装 Docker Engine（20.10+ 版本推荐）  
- 已安装 Docker Compose（如需使用编排功能）  


### 获取镜像  
通过 Docker Hub 拉取镜像（具体标签请参考 [GitHub 仓库](https://github.com/apache/couchdb-docker)）：  
```bash
docker pull docker.xuanyuan.run/apache/couchdb:latest  # 替换为实际镜像标签
```


### 基本运行命令（docker run）  
#### 最简启动（默认配置）  
```bash
docker run -d --name couchdb -p 5984:5984 docker.xuanyuan.run/apache/couchdb:latest
```  
- `-d`：后台运行容器  
- `--name couchdb`：指定容器名称  
- `-p 5984:5984`：映射容器内 CouchDB 默认端口（5984）到主机  


### 自定义配置（环境变量）  
通过环境变量调整核心配置，常用参数如下：  

| 环境变量          | 说明                                  | 默认值       |
|-------------------|---------------------------------------|--------------|
| `COUCHDB_USER`    | 管理员用户名（启用认证时必填）        | 无           |
| `COUCHDB_PASSWORD`| 管理员密码（启用认证时必填）          | 无           |
| `COUCHDB_PORT`    | 容器内 CouchDB 服务端口               | 5984         |
| `COUCHDB_BIND_ADDRESS` | 服务绑定地址（如 `0.0.0.0` 允许外部访问） | `127.0.0.1` |

#### 示例：启用认证并自定义端口  
```bash
docker run -d \
  --name couchdb-auth \
  -p 5984:5984 \
  -e COUCHDB_USER=admin \
  -e COUCHDB_PASSWORD=securepassword \
  -e COUCHDB_BIND_ADDRESS=0.0.0.0 \
  docker.xuanyuan.run/apache/couchdb:latest
```


### 数据持久化  
通过 Docker 数据卷挂载实现数据持久化，避免容器重启后数据丢失：  
```bash
docker run -d \
  --name couchdb-persistent \
  -p 5984:5984 \
  -v /host/path/to/couchdb/data:/opt/couchdb/data \  # 数据目录挂载
  -v /host/path/to/couchdb/conf:/opt/couchdb/etc \   # 配置文件挂载（可选）
  -e COUCHDB_USER=admin \
  -e COUCHDB_PASSWORD=securepassword \
  apache/couchdb:latest
```


### 使用 docker-compose 部署  
创建 `docker-compose.yml` 文件，定义服务配置：  
```yaml
version: '3.8'
services:
  couchdb:
    image: docker.xuanyuan.run/apache/couchdb:latest
    container_name: couchdb
    restart: always  # 容器退出时自动重启
    ports:
      - "5984:5984"  # HTTP 端口
      - "6984:6984"  # HTTPS 端口（如需启用）
    environment:
      - COUCHDB_USER=admin
      - COUCHDB_PASSWORD=securepassword
      - COUCHDB_BIND_ADDRESS=0.0.0.0
    volumes:
      - couchdb_data:/opt/couchdb/data  # 命名卷（自动创建）
      - ./conf:/opt/couchdb/etc         # 本地配置文件目录（可选）
    networks:
      - couchdb_network  # 自定义网络（可选）

volumes:
  couchdb_data:  # 持久化数据卷

networks:
  couchdb_network:  # 隔离网络环境
```  

启动服务：  
```bash
docker-compose up -d
```


### 访问 Web 管理界面（Fauxton）  
CouchDB 内置 Web 管理界面 Fauxton，启动容器后通过浏览器访问：  
```
http://<主机IP>:5984/_utils/
```  
- 若启用认证，需输入 `COUCHDB_USER` 和 `COUCHDB_PASSWORD` 登录。  
- 通过 Fauxton 可管理数据库、文档、用户及集群配置。


## 注意事项  
1. **非官方镜像**：本镜像为非官方分发，功能与官方镜像可能存在差异，详细信息请参考 [GitHub 仓库](https://github.com/apache/couchdb-docker)。  
2. **生产环境建议**：生产环境中需启用 HTTPS、配置防火墙、定期备份数据，并通过自定义配置文件（`local.ini`）优化性能参数。  
3. **版本兼容性**：不同镜像标签对应 CouchDB 不同版本，部署前需确认应用兼容性。
