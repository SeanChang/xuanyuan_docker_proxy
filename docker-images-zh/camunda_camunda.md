---
image: camunda/camunda
description: "Camunda流程引擎Docker镜像，用于业务流程管理与工作流自动化，支持BPMN/DMN标准，实现企业级流程的建模、执行与监控。"
source: https://xuanyuan.cloud/zh/r/camunda/camunda
canonical: https://xuanyuan.cloud/zh/r/camunda/camunda
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/camunda/camunda" title="camunda/camunda Docker 镜像中文简介、标签列表与拉取命令">camunda/camunda 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Camunda Docker 镜像文档

## 镜像概述和主要用途

Camunda Docker 镜像是 Camunda BPM 平台的容器化分发版本，提供了完整的业务流程管理功能。该镜像封装了 Camunda 引擎、Web 应用（包括 Camunda Cockpit、Tasklist 和 Admin）以及嵌入式流程引擎，可快速部署和运行在各种容器化环境中，适用于开发、测试和生产环境的业务流程自动化需求。

## 核心功能和特性

- **完整的 BPMN 2.0 支持**：全面支持业务流程模型和符号标准，实现流程可视化设计与执行
- **流程引擎**：高性能、可扩展的流程执行核心，支持同步/异步操作和事务管理
- **Web 管理工具**：
  - Cockpit：流程监控和管理控制台
  - Tasklist：人工任务处理界面
  - Admin：用户、角色和权限管理
- **多数据库支持**：兼容 H2、MySQL、PostgreSQL、Oracle 等主流数据库
- **REST API**：提供完整的 RESTful 接口，支持外部系统集成
- **事件驱动架构**：支持消息、信号和错误事件，实现灵活的流程交互

## 使用场景和适用范围

- **业务流程自动化**：订单处理、审批流程、客户旅程等企业级业务流程
- **微服务编排**：作为微服务架构中的流程协调器，管理服务间交互
- **DevOps 环境**：快速部署和测试流程定义，支持 CI/CD 集成
- **低代码开发**：结合流程设计器，实现业务流程的快速建模和运行
- **企业集成**：与 ERP、CRM 等系统集成，实现端到端流程自动化

## 详细的使用方法和配置说明

### 基本使用

#### Docker Run 命令

```bash
# 使用默认配置（H2 数据库）运行
docker run -d --name camunda -p 8080:8080 docker.xuanyuan.run/camunda/camunda-bpm-platform:latest
```

#### 访问应用

容器启动后，通过以下地址访问 Web 应用：
- Cockpit: http://localhost:8080/camunda/app/cockpit
- Tasklist: http://localhost:8080/camunda/app/tasklist
- Admin: http://localhost:8080/camunda/app/admin

默认登录凭据：
- 用户名: demo
- 密码: demo

### 使用外部数据库

#### MySQL 配置示例

```bash
docker run -d --name camunda \
  -p 8080:8080 \
  -e DB_DRIVER=com.mysql.cj.jdbc.Driver \
  -e DB_URL=jdbc:mysql://mysql-host:3306/camunda?useSSL=false \
  -e DB_USERNAME=camunda \
  -e DB_PASSWORD=camunda123 \
  docker.xuanyuan.run/camunda/camunda-bpm-platform:latest
```

### Docker Compose 配置

```yaml
version: '3.8'

services:
  camunda:
    image: docker.xuanyuan.run/camunda/camunda-bpm-platform:latest
    container_name: camunda
    ports:
      - "8080:8080"
    environment:
      - DB_DRIVER=org.postgresql.Driver
      - DB_URL=jdbc:postgresql://db:5432/camunda
      - DB_USERNAME=camunda
      - DB_PASSWORD=camunda123
      - WAIT_FOR_DB=true
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: docker.xuanyuan.run/postgres:13
    container_name: camunda-db
    environment:
      - POSTGRES_DB=camunda
      - POSTGRES_USER=camunda
      - POSTGRES_PASSWORD=camunda123
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:
```

### 环境变量配置

| 环境变量 | 描述 | 默认值 |
|----------|------|--------|
| `DB_DRIVER` | JDBC 驱动类名 | org.h2.Driver |
| `DB_URL` | 数据库连接 URL | jdbc:h2:./camunda-h2-dbs/process-engine;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE |
| `DB_USERNAME` | 数据库用户名 | sa |
| `DB_PASSWORD` | 数据库密码 | 空字符串 |
| `DB_SCHEMA_UPDATE` | 数据库模式更新策略 (true, false, create-drop) | true |
| `WAIT_FOR_DB` | 是否等待数据库可用 | false |
| `JAVA_OPTS` | JVM 参数 | -Xmx768m -XX:MaxMetaspaceSize=256m |
| `CAMUNDA_WEBAPPS_CONTEXT_PATH` | Web 应用上下文路径 | /camunda |
| `TOMCAT_PORT` | HTTP 端口 | 8080 |

### 持久化配置

为确保数据持久化，需挂载以下目录：

```bash
docker run -d --name camunda \
  -p 8080:8080 \
  -v camunda-data:/camunda-h2-dbs \
  -v camunda-logs:/usr/local/tomcat/logs \
  docker.xuanyuan.run/camunda/camunda-bpm-platform:latest
```

### 自定义配置

通过挂载自定义配置文件覆盖默认设置：

```bash
docker run -d --name camunda \
  -p 8080:8080 \
  -v ./custom-bpm-platform.xml:/camunda/conf/bpm-platform.xml \
  -v ./custom-logback.xml:/camunda/conf/logback.xml \
  docker.xuanyuan.run/camunda/camunda-bpm-platform:latest
```

## 参考链接

- [Camunda 官方 GitHub 仓库](https://github.com/camunda/camunda)
- [Camunda 官方文档](https://docs.camunda.org/manual/latest/)
- [Camunda Docker Hub 页面](https://hub.docker.com/r/camunda/camunda-bpm-platform)
