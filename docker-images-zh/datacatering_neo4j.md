---
image: datacatering/neo4j
description: "支持Neo4j 3.x版本的Docker镜像，提供多架构支持（linux/amd64和linux/arm64）"
source: https://xuanyuan.cloud/zh/r/datacatering/neo4j
canonical: https://xuanyuan.cloud/zh/r/datacatering/neo4j
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/datacatering/neo4j" title="datacatering/neo4j Docker 镜像中文简介、标签列表与拉取命令">datacatering/neo4j 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Neo4j 多架构Docker镜像（3.x版本）

## 镜像概述
该Docker镜像专为Neo4j早期版本（主要是3.x系列）提供多架构支持，解决官方早期版本缺乏跨架构兼容性的问题。镜像可在linux/amd64（x86_64）和linux/arm64（ARM64）两种架构环境中运行，确保在不同硬件平台上的一致性体验。

## 核心功能与特性
- **多架构支持**：同时兼容linux/amd64和linux/arm64两种主流架构
- **版本适配**：针对Neo4j 3.x系列版本优化，保持与官方3.x版本功能一致性
- **构建透明**：基于[data-catering/docker-neo4j-publish](https://github.com/data-catering/docker-neo4j-publish)项目构建，构建过程完全开源可追溯

## 使用场景
- 需要在ARM架构设备（如树莓派、ARM服务器）上部署Neo4j 3.x版本的场景
- 多架构环境下的开发、测试或小型生产部署
- 对Neo4j 3.x版本有依赖且需要跨架构运行的应用系统

## 使用方法

### 拉取镜像
```bash
docker pull docker.xuanyuan.run/<镜像名称>:<标签>  # 需替换为实际镜像名称和标签，例如data-catering/neo4j:3.5.0-multiarch
```

### 基本运行命令
```bash
docker run -d \
  --name neo4j-3x \
  -p 7474:7474 -p 7687:7687 \
  <镜像名称>:<标签>
```

### 环境变量配置
支持Neo4j官方标准环境变量，主要包括：
- `NEO4J_AUTH`：设置数据库认证信息，格式为`username/password`，默认值为`neo4j/neo4j`（首次登录需强制修改）
- `NEO4J_dbms_memory_heap_initial__size`：JVM堆内存初始大小，如`512m`
- `NEO4J_dbms_memory_heap_max__size`：JVM堆内存最大大小，如`1g`

示例（自定义认证和内存配置）：
```bash
docker run -d \
  --name neo4j-3x \
  -p 7474:7474 -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/StrongPassword123 \
  -e NEO4J_dbms_memory_heap_initial__size=512m \
  -e NEO4J_dbms_memory_heap_max__size=1g \
  <镜像名称>:<标签>
```

### 数据持久化配置
通过挂载本地目录实现数据持久化：
```bash
docker run -d \
  --name neo4j-3x \
  -p 7474:7474 -p 7687:7687 \
  -v /local/path/to/data:/data \
  -v /local/path/to/logs:/logs \
  <镜像名称>:<标签>
```

### docker-compose配置示例
```yaml
version: '3'
services:
  neo4j:
    image: <镜像名称>:<标签>
    container_name: neo4j-3x
    ports:
      - "7474:7474"
      - "7687:7687"
    environment:
      - NEO4J_AUTH=neo4j/StrongPassword123
      - NEO4J_dbms_memory_heap_initial__size=512m
      - NEO4J_dbms_memory_heap_max__size=1g
    volumes:
      - ./data:/data
      - ./logs:/logs
    restart: unless-stopped
