---
image: surrealdb/surrealdb
description: "一个可扩展、分布式、协作式的文档-图形数据库，适用于实时网络应用"
source: https://xuanyuan.cloud/zh/r/surrealdb/surrealdb
canonical: https://xuanyuan.cloud/zh/r/surrealdb/surrealdb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/surrealdb/surrealdb" title="surrealdb/surrealdb Docker 镜像中文简介、标签列表与拉取命令">surrealdb/surrealdb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# SurrealDB Docker 镜像文档

## 镜像概述

SurrealDB 是一个端到端的云原生数据库，适用于 Web、移动、无服务器、Jamstack、后端和传统应用。它通过简化数据库和 API 栈，减少对大多数服务器端组件的需求，帮助开发人员更轻松地开发、更快地构建和更快速地扩展应用。SurrealDB 兼具数据库和现代实时协作 API 后端层的功能，可作为单个服务器运行，或在高可用、高可扩展的分布式模式下运行。

## 核心功能与特性

- **多模式支持**：融合文档数据库和图形数据库特性，支持结构化和非结构化数据
- **实时协作**：通过 WebSocket 连接提供实时数据同步
- **多查询语言**：支持 SQL 查询、GraphQL、图形查询、全文索引和地理空间查询
- **ACID 事务**：确保数据一致性和可靠性
- **细粒度权限**：基于行的权限访问控制
- **分布式架构**：支持高可用和高可扩展部署
- **云原生设计**：专为云环境优化，适合现代应用架构

## 适用场景

- Web 应用和移动应用开发
- 无服务器架构和 Jamstack 项目
- 需要实时数据同步的协作应用
- 后端服务和传统应用现代化
- 需要处理复杂关系数据（图形结构）的场景

## 使用方法

### 使用 Docker 运行

Docker 可用于管理和运行 SurrealDB 实例，无需安装命令行工具。容器包含完整的命令行工具，用于导入/导出数据或运行服务器。

#### 基本启动命令

```bash
docker run --rm --pull always --name surrealdb -p 8000:8000 surrealdb/surrealdb:latest start
```

#### 开发环境启动（带用户认证和内存模式）

如需快速启动开发服务器，可指定用户密码并使用内存模式：

```bash
docker run --rm --pull always --name surrealdb -p 8000:8000 surrealdb/surrealdb:latest start --log trace --user root --pass root memory
```

#### 访问 SurrealDB CLI

通过容器执行命令访问 CLI：

```bash
docker exec -it <容器名称> /surreal sql -c http://localhost:8000 -u root -p root --ns test --db test --pretty
```

### 使用 Docker Compose 运行

可通过 docker-compose 工具管理 SurrealDB，可覆盖入口点指定启动命令。以下是 docker-compose.yml 示例：

```yaml
version: '3'

services:
  surrealdb:
    env_file:
      - .env
    entrypoint: 
      - /surreal 
      - start 
      - --user
      - $DB_USER
      - --pass
      - $DB_PASSWORD
    image: docker.xuanyuan.run/surrealdb/surrealdb:latest
    ports:
      - 8000:8000
```

## 社区支持

加入全球社区获取帮助、交流想法和讨论 SurrealDB 相关话题：

- 官方博客
- Discord 实时聊天
- Twitter 关注
- LinkedIn 连接
- YouTube 频道
- Dev 社区
- Stack Overflow（#surrealdb 标签）

## 贡献指南

欢迎参与 SurrealDB 开发！如需贡献，可查看[贡献指南](CONTRIBUTING.md)了解详细流程。

## 安全信息

有关安全问题，请查看我们的[漏洞政策](https://github.com/surrealdb/surrealdb/security/policy)和[安全政策](https://surrealdb.com/legal/security)，并通过 email 联系：security@surrealdb.com（请勿在 GitHub 上发布公开问题）。

## 许可信息

SurrealDB 源代码根据不同组件采用多种许可证：

- 库和 SDK（位于各自仓库）：[Apache License 2.0](https://github.com/surrealdb/license/blob/main/APL.txt) 或 [MIT License](https://github.com/surrealdb/license/blob/main/MIT.txt)
- 某些核心数据库组件（位于各自仓库）：[Apache License 2.0](https://github.com/surrealdb/license/blob/main/APL.txt)
- SurrealDB 核心数据库代码（位于[此仓库](https://github.com/surrealdb/surrealdb)）：[Business Source License 1.1](/LICENSE)

更多信息请参见[许可信息](https://github.com/surrealdb/license)。
