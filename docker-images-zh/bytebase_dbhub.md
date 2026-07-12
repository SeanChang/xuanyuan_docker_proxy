---
image: bytebase/dbhub
description: "实现模型上下文协议（MCP）服务器接口的通用数据库网关"
source: https://xuanyuan.cloud/zh/r/bytebase/dbhub
canonical: https://xuanyuan.cloud/zh/r/bytebase/dbhub
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bytebase/dbhub" title="bytebase/dbhub Docker 镜像中文简介、标签列表与拉取命令">bytebase/dbhub 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 通用MCP数据库网关镜像


## 镜像概述和主要用途  
本镜像提供一个实现Model Context Protocol (MCP)服务器接口的通用数据库网关，作为中间层组件，用于连接不同类型的数据库系统与遵循MCP协议的客户端应用，实现跨数据库的数据交互、协议转换与请求路由。其核心价值在于简化多数据库环境下的统一访问与集成，降低应用与底层数据库的耦合度。


## 核心功能和特性  
### 核心功能  
1. **多数据库适配**：支持主流关系型数据库（如MySQL、PostgreSQL、Oracle）及NoSQL数据库（如MongoDB、Redis），通过统一接口实现跨数据库访问。  
2. **MCP协议实现**：完整实现MCP服务器接口规范，支持MCP协议客户端的连接、认证与数据交互。  
3. **数据路由与转换**：根据请求上下文动态路由数据查询至目标数据库，并自动处理不同数据库间的数据类型与格式转换。  
4. **请求代理与负载均衡**：支持多后端数据库实例的请求分发，实现负载均衡与故障自动切换。  

### 关键特性  
- **通用性**：无需修改客户端代码即可适配不同数据库类型，降低集成成本。  
- **低延迟**：内置数据缓存机制与优化的协议解析逻辑，减少请求处理延迟。  
- **可扩展性**：支持插件化扩展数据库驱动与协议适配模块。  
- **安全性**：集成TLS加密传输、基于JWT的客户端认证及细粒度权限控制。  
- **可观测性**：提供Prometheus metrics接口与结构化日志，支持监控与问题排查。  


## 使用场景和适用范围  
### 典型使用场景  
1. **企业多数据库集成**：企业内部同时使用MySQL、PostgreSQL等多种数据库时，通过本网关为应用提供统一MCP接口，避免应用直接对接多数据库。  
2. **遗留系统现代化改造**：旧系统数据库（如DB2、Sybase）通过网关转换为MCP协议接口，供现代微服务应用访问，无需重构遗留数据库。  
3. **跨平台数据服务**：不同技术栈（如Java、Python、Go）的应用通过MCP协议统一访问底层数据库，简化跨平台数据交互。  
4. **微服务数据层解耦**：微服务架构中，通过网关隔离数据访问层，实现“应用-网关-数据库”的分层架构，提升系统弹性。  

### 适用范围  
- 企业级多数据库环境  
- 数据集成平台与ETL系统  
- 微服务架构的数据访问层  
- 跨技术栈应用的数据库统一访问  
- 需兼容MCP协议的客户端与数据库交互场景  


## 使用方法和配置说明  

### 环境要求  
- Docker Engine 20.10+ 或 Kubernetes 1.21+  
- 目标数据库网络可达（容器需与后端数据库在同一网络或通过端口映射连通）  


### Docker快速启动（docker run）  
通过以下命令快速启动网关，连接至MySQL数据库并暴露MCP服务端口：  

```bash
docker run -d \
  --name mcp-db-gateway \
  -p 50051:50051 \  # MCP服务端口映射（宿主机:容器）
  -e MCP_PORT=50051 \  # 容器内MCP服务监听端口
  -e DB_TYPE=mysql \  # 后端数据库类型（支持mysql/postgresql/mongodb/redis等）
  -e DB_HOST=mysql-instance \  # 后端数据库主机名/IP
  -e DB_PORT=3306 \  # 后端数据库端口
  -e DB_USER=admin \  # 数据库访问用户名
  -e DB_PASSWORD=secret \  # 数据库访问密码
  -e LOG_LEVEL=info \  # 日志级别（debug/info/warn/error）
  -e AUTH_ENABLED=true \  # 是否启用MCP客户端认证
  -e TLS_ENABLED=true \  # 是否启用TLS加密传输
  -v /path/to/tls/certs:/etc/mcp/tls \  # 挂载TLS证书（若启用TLS）
  mcp-db-gateway:latest
```  


### Docker Compose部署  
通过`docker-compose.yml`配置多数据库后端与网关的集成（以MySQL和PostgreSQL为例）：  

```yaml
version: '3.8'
services:
  mcp-gateway:
    image: docker.xuanyuan.run/mcp-db-gateway:latest
    container_name: mcp-db-gateway
    ports:
      - "50051:50051"  # MCP服务端口
    environment:
      - MCP_PORT=50051
      - LOG_LEVEL=info
      - AUTH_ENABLED=true
      - TLS_ENABLED=true
      # 数据库1：MySQL配置
      - DB_1_TYPE=mysql
      - DB_1_HOST=mysql
      - DB_1_PORT=3306
      - DB_1_USER=mysql_user
      - DB_1_PASSWORD=mysql_pass
      - DB_1_NAME=app_db
      # 数据库2：PostgreSQL配置
      - DB_2_TYPE=postgresql
      - DB_2_HOST=pgsql
      - DB_2_PORT=5432
      - DB_2_USER=pgsql_user
      - DB_2_PASSWORD=pgsql_pass
      - DB_2_NAME=analytics_db
    volumes:
      - ./tls:/etc/mcp/tls  # 挂载TLS证书目录（包含server.crt和server.key）
    depends_on:
      - mysql
      - pgsql
    networks:
      - mcp-network

  # 后端数据库服务（示例）
  mysql:
    image: docker.xuanyuan.run/mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=root_pass
      - MYSQL_DATABASE=app_db
      - MYSQL_USER=mysql_user
      - MYSQL_PASSWORD=mysql_pass
    networks:
      - mcp-network

  pgsql:
    image: docker.xuanyuan.run/postgres:14
    environment:
      - POSTGRES_DB=analytics_db
      - POSTGRES_USER=pgsql_user
      - POSTGRES_PASSWORD=pgsql_pass
    networks:
      - mcp-network

networks:
  mcp-network:
    driver: bridge
```  


### 配置参数说明  
#### 核心环境变量  
| 环境变量名               | 描述                                  | 默认值       | 示例值                |
|--------------------------|---------------------------------------|--------------|-----------------------|
| `MCP_PORT`               | MCP服务器监听端口                     | `50051`      | `50052`               |
| `LOG_LEVEL`              | 日志级别（debug/info/warn/error/fatal）| `info`       | `debug`               |
| `AUTH_ENABLED`           | 是否启用MCP客户端认证（true/false）   | `false`      | `true`                |
| `TLS_ENABLED`            | 是否启用TLS加密传输（true/false）     | `false`      | `true`                |
| `CACHE_ENABLED`          | 是否启用请求缓存（true/false）        | `true`       | `false`               |
| `CACHE_TTL`              | 缓存过期时间（秒）                    | `300`        | `600`                 |

#### 数据库连接配置（单数据库场景）  
| 环境变量名               | 描述                                  | 示例值                |
|--------------------------|---------------------------------------|-----------------------|
| `DB_TYPE`                | 后端数据库类型（mysql/pgsql/mongo/redis） | `mysql`             |
| `DB_HOST`                | 数据库主机名/IP                       | `mysql-host`          |
| `DB_PORT`                | 数据库端口                             | `3306`                |
| `DB_USER`                | 数据库访问用户名                       | `dbuser`              |
| `DB_PASSWORD`            | 数据库访问密码                         | `dbpass`              |
| `DB_NAME`                | 目标数据库名称（如适用）               | `app_db`              |

#### 多数据库路由配置（多数据库场景）  
通过`DB_<N>_*`格式的环境变量配置多数据库后端（`<N>`为数字，从1开始），例如：  
- `DB_1_TYPE=mysql`  
- `DB_1_HOST=mysql-1`  
- `DB_2_TYPE=pgsql`  
- `DB_2_HOST=pgsql-1`  

网关将根据MCP请求中的`context`字段路由至对应数据库（需客户端请求中携带`db_id: <N>`上下文参数）。


### 高级配置（配置文件挂载）  
对于复杂配置（如自定义路由规则、细粒度权限策略），可通过挂载配置文件覆盖默认配置。配置文件为YAML格式，路径为`/etc/mcp/config.yaml`，示例：  

```yaml
mcp:
  port: 50051
  tls:
    cert_path: /etc/mcp/tls/server.crt
    key_path: /etc/mcp/tls/server.key
  auth:
    jwt:
      secret: "your-jwt-secret"
      expires_in: 3600

databases:
  - id: 1
    type: mysql
    host: mysql-1
    port: 3306
    user: user1
    password: pass1
    name: db1
    routes: ["order_service.*"]  # 仅路由order_service前缀的请求

  - id: 2
    type: pgsql
    host: pgsql-1
    port: 5432
    user: user2
    password: pass2
    name: db2
    routes: ["analytics_service.*"]

cache:
  enabled: true
  ttl: 300
  backend: redis  # 可选：local/redis
  redis:
    host: redis-cache
    port: 6379
```  

通过Docker命令挂载配置文件：  
```bash
docker run -d \
  --name mcp-db-gateway \
  -p 50051:50051 \
  -v ./config.yaml:/etc/mcp/config.yaml \  # 挂载自定义配置文件
  -v ./tls:/etc/mcp/tls \
  mcp-db-gateway:latest
