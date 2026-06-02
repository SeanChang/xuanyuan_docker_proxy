---
image: library/neo4j
description: "Neo4j是一种高度可扩展、稳健的原生图数据库，它专为图数据模型设计，能够高效存储和查询由节点、关系及其属性构成的复杂网络数据，凭借原生图存储和处理引擎，可支持从中小型项目到企业级大规模数据的无缝扩展，同时具备强大的稳定性和可靠性，广泛应用于社交网络分析、知识图谱构建、推荐系统等需要深度挖掘数据关联关系的场景，为用户提供高效、精准的图数据管理与分析能力。"
source: https://xuanyuan.cloud/zh/r/library/neo4j
canonical: https://xuanyuan.cloud/zh/r/library/neo4j
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/neo4j" title="library/neo4j Docker 镜像中文简介、标签列表与拉取命令">library/neo4j — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/neo4j" title="library/neo4j Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/neo4j</a>

## 快速参考  

### 维护者  
[Neo4j]([])  


### 获取帮助  
[Neo4j社区论坛]([])  


## 支持的标签及对应Dockerfile链接  

### 2025.09.0 系列  
- **社区版（基于bullseye）**  
  标签包括：`2025.09.0-community-bullseye`、`2025.09-community-bullseye`、`2025-community-bullseye`、`2025.09.0-community`、`2025.09-community`、`2025-community`、`2025.09.0-bullseye`、`2025.09-bullseye`、`2025-bullseye`、`2025.09.0`、`2025.09`、`2025`、`community-bullseye`、`community`、`bullseye`、`latest`  
  [Dockerfile链接]([])  

- **企业版（基于bullseye）**  
  标签包括：`2025.09.0-enterprise-bullseye`、`2025.09-enterprise-bullseye`、`2025-enterprise-bullseye`、`2025.09.0-enterprise`、`2025.09-enterprise`、`2025-enterprise`、`enterprise-bullseye`、`enterprise`  
  [Dockerfile链接]([])  

- **社区版（基于ubi9）**  
  标签包括：`2025.09.0-community-ubi9`、`2025.09-community-ubi9`、`2025-community-ubi9`、`2025.09.0-ubi9`、`2025.09-ubi9`、`2025-ubi9`、`community-ubi9`、`ubi9`  
  [Dockerfile链接]([])  

- **企业版（基于ubi9）**  
  标签包括：`2025.09.0-enterprise-ubi9`、`2025.09-enterprise-ubi9`、`2025-enterprise-ubi9`、`enterprise-ubi9`  
  [Dockerfile链接]([])  


### 5.26.13 系列  
- **社区版（基于bullseye）**  
  标签包括：`5.26.13-community-bullseye`、`5.26-community-bullseye`、`5-community-bullseye`、`5.26.13-community`、`5.26-community`、`5-community`、`5.26.13-bullseye`、`5.26-bullseye`、`5-bullseye`、`5.26.13`、`5.26`、`5`  
  [Dockerfile链接]([])  

- **企业版（基于bullseye）**  
  标签包括：`5.26.13-enterprise-bullseye`、`5.26-enterprise-bullseye`、`5-enterprise-bullseye`、`5.26.13-enterprise`、`5.26-enterprise`、`5-enterprise`  
  [Dockerfile链接]([])  

- **社区版（基于ubi9）**  
  标签包括：`5.26.13-community-ubi9`、`5.26-community-ubi9`、`5-community-ubi9`、`5.26.13-ubi9`、`5.26-ubi9`、`5-ubi9`  
  [Dockerfile链接]([])  

- **企业版（基于ubi9）**  
  标签包括：`5.26.13-enterprise-ubi9`、`5.26-enterprise-ubi9`、`5-enterprise-ubi9`  
  [Dockerfile链接]([])  


### 4.4.46 系列  
- **社区版（基于bullseye）**  
  标签包括：`4.4.46`、`4.4.46-community`、`4.4`、`4.4-community`  
  [Dockerfile链接]([])  

- **企业版（基于bullseye）**  
  标签包括：`4.4.46-enterprise`、`4.4-enterprise`  
  [Dockerfile链接]([])  


## 快速参考（续）  

- **提交问题**：[GitHub Issues]([])  
- **支持架构**：`amd64`（[镜像]([])）、`arm64v8`（[镜像]([])）  
- **镜像详情**：包含元数据、传输大小等，见[repo-info仓库的neo4j目录]([])（[历史记录]([])）  
- **镜像更新**：通过[official-images仓库的library/neo4j标签]([])或[文件]([])（[历史记录]([])）查看  
- **描述来源**：[docs仓库的neo4j目录]([])（[历史记录]([])）  


## 什么是Neo4j？  
Neo4j是全球领先的图数据库，具备原生图存储和处理能力。了解更多[开发资源]([])。  


## 如何使用此镜像  

### 基本启动命令  
```console
docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$HOME/neo4j/data:/data \
    neo4j
```  

### 说明  
- **端口映射**：`7474`（HTTP接口）和`7687`（Bolt接口），用于访问Neo4j API。  
- **数据持久化**：通过`--volume`将本地目录`$HOME/neo4j/data`挂载到容器内`/data`目录，避免数据丢失。  
- **访问方式**：启动后通过浏览器访问`[]  

### 登录与认证  
- 默认登录凭据：`neo4j/neo4j`，首次登录需修改密码。  
- 开发环境禁用认证：添加`--env=NEO4J_AUTH=none`参数，如：  
  ```console
  docker run --publish=7474:7474 --publish=7687:7687 --volume=$HOME/neo4j/data:/data --env=NEO4J_AUTH=none neo4j
  ```  


## 文档  
完整使用指南和示例见[官方手册]([])。  


## 许可  
- 软件许可信息：[查看详情]([])。  
- 镜像可能包含其他软件（如基础系统工具），其许可信息可在[repo-info的neo4j目录]([])查询。使用前请确保合规。
