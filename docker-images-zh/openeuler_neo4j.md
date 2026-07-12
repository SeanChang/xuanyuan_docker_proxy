---
image: openeuler/neo4j
description: "官方neo4j Docker镜像，基于openEuler构建，提供高性能图数据库功能，支持ACID事务、灵活的节点与关系结构及友好查询语言，适用于处理复杂关系数据的应用场景。"
source: https://xuanyuan.cloud/zh/r/openeuler/neo4j
canonical: https://xuanyuan.cloud/zh/r/openeuler/neo4j
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/neo4j" title="openeuler/neo4j Docker 镜像中文简介、标签列表与拉取命令">openeuler/neo4j 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# neo4j Docker镜像文档

## 镜像概述和主要用途

本镜像为官方neo4j Docker镜像，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护，基于[openEuler](https://repo.openeuler.org/)构建。该仓库可免费使用，且不受每用户速率限制。

Neo4j是全球领先的图数据库，提供高性能图存储能力，具备成熟数据库的所有特性（如友好查询语言、ACID事务等）。开发者可使用灵活的节点和关系网络结构而非静态表进行工作，同时享受企业级数据库的所有优势。在许多应用中，Neo4j相比关系型数据库提供数量级的性能提升。

## 核心功能和特性

- **高性能图存储**：针对图数据模型优化，提供高效数据读写能力
- **ACID事务支持**：确保数据一致性和可靠性
- **灵活数据模型**：基于节点和关系的网络结构，适应复杂关系数据场景
- **友好查询语言**：支持Cypher查询语言，简化图数据操作
- **跨架构支持**：提供amd64和arm64架构镜像

## 支持的标签及对应Dockerfile链接

每个`neo4j` Docker镜像的标签由neo4j版本和基础镜像版本组成，具体如下：

| 标签 | 当前版本信息 | 支持架构 |
|------|--------------|----------|
| [5.26.7-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/neo4j/5.26.7/24.03-lts-sp1/Dockerfile) | Neo4j 5.26.7 基于 openEuler 24.03-LTS-SP1 | amd64, arm64 |
| [2025.07.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/neo4j/2025.07.0/24.03-lts-sp2/Dockerfile) | Neo4j 2025.07.0 基于 openEuler 24.03-LTS-SP2 | amd64, arm64 |

## 使用方法和配置说明

### 启动服务器实例

```bash
docker run -d --name my-neo4j -p 7474:7474 -p 7687:7687 docker.xuanyuan.run/openeuler/neo4j:latest
```

通过浏览器访问 `http://localhost:7474` 即可使用Neo4j。

#### 端口说明
- 7474：HTTP访问端口，用于浏览器界面和HTTP API
- 7687：Bolt协议端口，用于应用程序通过Bolt驱动连接

#### 数据持久化
容器会将数据持久化到`/data`目录，建议通过卷挂载确保数据持久化到容器外部。

#### 认证设置
默认情况下，需要使用用户名`neo4j`和密码`neo4j`登录，并强制修改初始密码。开发环境中可通过设置环境变量禁用认证：

```bash
docker run -d --name my-neo4j -p 7474:7474 -p 7687:7687 --env=NEO4J_AUTH=none docker.xuanyuan.run/openeuler/neo4j:latest
```

## 问题反馈

如有任何问题或需要使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。

## 获取帮助

- [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)
- [openEuler 社区](https://gitee.com/openeuler/community)
