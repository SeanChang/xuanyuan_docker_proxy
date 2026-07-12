---
image: simplifierag/workflow-runtime
description: "Simplifier Workflow Runtime是一个轻量级工作流运行时环境，旨在简化工作流的部署、执行与管理过程，支持多种工作流定义格式，提供高效可靠的流程自动化能力。"
source: https://xuanyuan.cloud/zh/r/simplifierag/workflow-runtime
canonical: https://xuanyuan.cloud/zh/r/simplifierag/workflow-runtime
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/simplifierag/workflow-runtime" title="simplifierag/workflow-runtime Docker 镜像中文简介、标签列表与拉取命令">simplifierag/workflow-runtime 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Simplifier Workflow Runtime 镜像文档

## 镜像概述和主要用途

Simplifier Workflow Runtime 是一款面向流程自动化场景的容器化工作流执行引擎，提供工作流定义解析、任务调度、流程监控等核心能力。该镜像旨在降低工作流系统的部署复杂度，支持主流工作流规范（如BPMN 2.0、Flowable），可作为企业级业务流程管理（BPM）、微服务协调、自动化任务调度的基础运行环境。

## 核心功能和特性

- **多格式兼容**：原生支持BPMN 2.0、Flowable、Camunda等主流工作流定义格式，无需格式转换即可直接执行
- **轻量级架构**：基于精简的执行引擎设计，启动时间<30秒，内存占用<256MB，适合资源受限环境
- **灵活配置**：通过环境变量或配置文件自定义执行参数（并发数、重试策略、超时控制等）
- **监控集成**：内置Prometheus指标接口，支持流程实例状态、任务执行耗时等关键指标采集
- **高可用支持**：支持集群部署模式，通过分布式锁机制实现任务执行的幂等性保障
- **日志可观测**：提供结构化日志输出，支持JSON格式日志与ELK/EFK等日志分析平台集成

## 使用场景和适用范围

### 典型应用场景
- 企业内部审批流程自动化（如请假、报销、合同审批）
- 业务流程管理系统的执行引擎层（替代传统重型BPM平台）
- 微服务架构中的跨服务流程协调（如订单履约、支付流程）
- DevOps流程自动化（CI/CD流水线编排、部署流程控制）
- 数据处理流程调度（ETL任务依赖管理、批处理流程执行）

### 适用范围
- 中小企业业务流程数字化转型
- 开发/测试环境的工作流验证与调试
- 边缘计算场景下的轻量化流程自动化
- 需要与现有系统（ERP/CRM/OA）集成的流程场景

## 使用方法和配置说明

### 快速启动命令（Docker Run）

```bash
docker run -d \
  --name simplifier-workflow \
  -p 8080:8080 \
  -v /host/path/workflows:/app/workflows \
  -v /host/path/logs:/app/logs \
  -e WORKFLOW_DEFINITION_DIR=/app/workflows \
  -e LOG_LEVEL=INFO \
  -e MAX_CONCURRENT_TASKS=5 \
  docker.xuanyuan.run/simplifier/workflow-runtime:latest
```

**参数说明**：
- `-p 8080:8080`：映射API服务端口（默认管理端口）
- `-v /host/path/workflows:/app/workflows`：挂载本地工作流定义文件目录
- `-v /host/path/logs:/app/logs`：挂载日志持久化目录
- `-e WORKFLOW_DEFINITION_DIR`：容器内工作流定义文件存放路径（需与挂载路径对应）

### Docker Compose 配置示例

```yaml
version: '3.8'
services:
  workflow-runtime:
    image: docker.xuanyuan.run/simplifier/workflow-runtime:latest
    container_name: simplifier-workflow
    ports:
      - "8080:8080"    # API端口
      - "9090:9090"    # 监控指标端口
    volumes:
      - ./workflow-definitions:/app/workflows:ro  # 只读挂载工作流定义
      - ./persistence:/app/data                   # 持久化存储（流程实例状态）
      - ./logs:/app/logs                          # 日志存储
    environment:
      - WORKFLOW_DEFINITION_DIR=/app/workflows
      - LOG_LEVEL=INFO
      - API_PORT=8080
      - METRICS_PORT=9090
      - MAX_CONCURRENT_TASKS=10
      - TASK_TIMEOUT=300s
      - RETRY_COUNT=3
      - DB_TYPE=h2                                # 支持h2/PostgreSQL/MySQL
      - DB_CONNECTION_STRING=jdbc:h2:/app/data/workflow.db
    restart: unless-stopped
```

### 核心环境变量配置

| 环境变量名              | 描述                          | 默认值                | 有效值范围                  |
|-------------------------|-------------------------------|-----------------------|-----------------------------|
| `WORKFLOW_DEFINITION_DIR` | 工作流定义文件根目录（容器内） | `/app/workflows`      | 容器内可访问的绝对路径       |
| `LOG_LEVEL`             | 日志输出级别                  | `INFO`                | `DEBUG`, `INFO`, `WARN`, `ERROR` |
| `API_PORT`              | 管理API服务端口               | `8080`                | 1-65535                     |
| `METRICS_PORT`          | 监控指标端口（需启用监控）    | `9090`                | 1-65535                     |
| `MAX_CONCURRENT_TASKS`  | 最大并发任务执行数            | `5`                   | 1-100                       |
| `TASK_TIMEOUT`          | 单个任务执行超时时间          | `300s`                | 格式：`Ns`(纳秒)-`Nh`(小时) |
| `RETRY_COUNT`           | 任务失败重试次数              | `3`                   | 0-10                        |
| `DB_TYPE`               | 持久化数据库类型              | `h2`                  | `h2`, `postgresql`, `mysql` |
| `DB_CONNECTION_STRING`  | 数据库连接字符串              | `jdbc:h2:/app/data/workflow.db` | 对应数据库的JDBC连接串 |

### 工作流部署流程

1. **准备工作流定义文件**：将BPMN/Flowable格式的`.bpmn`/`.xml`文件存放至本地目录（如`./workflow-definitions`）
2. **启动容器**：通过上述`docker run`或`docker-compose`命令启动容器，确保工作流目录正确挂载
3. **验证部署**：访问`http://localhost:8080/workflows`接口，返回已加载的工作流定义列表即部署成功
4. **启动流程实例**：通过`POST /workflows/{definitionId}/start`接口触发工作流执行（支持JSON格式入参）

### 监控与运维

- **指标监控**：启用监控后，通过`http://localhost:9090/metrics`获取Prometheus格式指标，关键指标包括：`workflow_instances_total`（总实例数）、`task_execution_duration_seconds`（任务执行耗时）、`failed_tasks_total`（失败任务数）
- **日志管理**：日志文件默认存放于`/app/logs/workflow-runtime.log`，支持按大小（默认50MB）和时间（默认每天）切割
- **数据持久化**：默认使用H2嵌入式数据库存储流程实例状态，生产环境建议配置PostgreSQL/MySQL实现数据持久化

## API接口文档

容器启动后可通过`http://localhost:8080/swagger-ui`访问交互式API文档，核心接口包括：

| 接口路径                  | 方法 | 描述                          |
|---------------------------|------|-------------------------------|
| `/workflows`              | GET  | 获取所有已加载的工作流定义    |
| `/workflows/{id}`         | GET  | 获取指定ID的工作流定义详情    |
| `/workflows/{id}/start`   | POST | 启动指定ID的工作流实例        |
| `/instances`              | GET  | 查询所有工作流实例状态        |
| `/instances/{id}`         | GET  | 查询指定ID的工作流实例详情    |
| `/instances/{id}/terminate` | POST | 终止指定ID的工作流实例        |
| `/tasks`                  | GET  | 查询当前活跃任务列表          |
